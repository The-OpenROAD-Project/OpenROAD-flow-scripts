#!/usr/bin/env python3

import unittest
from unittest.mock import MagicMock, patch
import sys
import os

# Mock pya before importing convertDrc since it imports pya at module level
sys.modules["pya"] = MagicMock()

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

# convertDrc uses a global `in_drc` set by klayout -rd, so we must set it
import builtins

builtins.in_drc = "/tmp/test.drc"
builtins.out_file = "/tmp/test.json"

# Now we can import - but the module-level code tries to use pya.Application
# We need to handle this by patching before import
import importlib

# Import just the convert_drc function by reading the source
import types

_util_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util")
_src_path = os.path.join(_util_dir, "convertDrc.py")

# Load only the convert_drc function, not the module-level klayout code
with open(_src_path) as f:
    source = f.read()

# Extract just the function definition
import textwrap
import re as _re

# Parse out the convert_drc function
_func_start = source.index("def convert_drc(rdb):")
_func_end = source.index("\n\napp = pya.Application")
_func_source = source[_func_start:_func_end]

# Create a module with just the function
_mod = types.ModuleType("convertDrc_test")
_mod.__dict__["os"] = os
_mod.__dict__["in_drc"] = "/tmp/test.drc"
exec(compile(_func_source, _src_path, "exec"), _mod.__dict__)
convert_drc = _mod.convert_drc


def make_mock_point(x, y):
    p = MagicMock()
    p.x = x
    p.y = y
    return p


def make_mock_edge(p1_x, p1_y, p2_x, p2_y):
    edge = MagicMock()
    edge.p1 = make_mock_point(p1_x, p1_y)
    edge.p2 = make_mock_point(p2_x, p2_y)
    return edge


def make_box_value(left, bottom, right, top):
    value = MagicMock()
    value.is_box.return_value = True
    value.is_edge.return_value = False
    value.is_edge_pair.return_value = False
    value.is_polygon.return_value = False
    value.is_path.return_value = False
    value.is_text.return_value = False
    value.is_string.return_value = False
    box = MagicMock()
    box.left = left
    box.bottom = bottom
    box.right = right
    box.top = top
    value.box.return_value = box
    return value


def make_edge_value(p1_x, p1_y, p2_x, p2_y):
    value = MagicMock()
    value.is_box.return_value = False
    value.is_edge.return_value = True
    value.is_edge_pair.return_value = False
    value.is_polygon.return_value = False
    value.is_path.return_value = False
    value.is_text.return_value = False
    value.is_string.return_value = False
    value.edge.return_value = make_mock_edge(p1_x, p1_y, p2_x, p2_y)
    return value


def make_text_value(text):
    value = MagicMock()
    value.is_box.return_value = False
    value.is_edge.return_value = False
    value.is_edge_pair.return_value = False
    value.is_polygon.return_value = False
    value.is_path.return_value = False
    value.is_text.return_value = True
    value.is_string.return_value = False
    value.text.return_value = text
    return value


def make_mock_item(values, is_visited=False, tags_str="", comment=None):
    item = MagicMock()
    item.is_visited.return_value = is_visited
    item.tags_str = tags_str
    item.each_value.return_value = iter(values)
    if comment is not None:
        item.comment = comment
    else:
        # Remove hasattr for comment
        del item.comment
    return item


def make_mock_category(name, description, rdb_id, num_items, items):
    cat = MagicMock()
    cat.name.return_value = name
    cat.path.return_value = name
    cat.description = description
    cat.rdb_id.return_value = rdb_id
    cat.num_items.return_value = num_items
    return cat, items


class TestConvertDrc(unittest.TestCase):
    def test_nested_categories_keep_rules_with_the_same_name(self):
        metal1, _ = make_mock_category("metal1", "Metal 1", 1, 1, [])
        metal2, _ = make_mock_category("metal2", "Metal 2", 2, 1, [])
        width1, _ = make_mock_category("width", "Metal 1 width", 3, 1, [])
        width2, _ = make_mock_category("width", "Metal 2 width", 4, 1, [])
        width1.path.return_value = "metal1.width"
        width2.path.return_value = "metal2.width"
        metal1.each_sub_category.return_value = iter([width1])
        metal2.each_sub_category.return_value = iter([width2])
        items = {
            3: [make_mock_item([make_box_value(0, 0, 1, 1)])],
            4: [make_mock_item([make_box_value(2, 2, 3, 3)])],
        }
        rdb = MagicMock()
        rdb.each_category.return_value = iter([metal1, metal2])
        rdb.each_item_per_category.side_effect = lambda category_id: iter(
            items.get(category_id, [])
        )

        categories = convert_drc(rdb)["category"]

        self.assertEqual(len(categories["metal1.width"]["violations"]), 1)
        self.assertEqual(len(categories["metal2.width"]["violations"]), 1)
        self.assertEqual(categories["metal2.width"]["description"], "Metal 2 width")
        self.assertEqual(
            categories["metal2.width"]["violations"][0]["shape"][0]["points"],
            [{"x": 2, "y": 2}, {"x": 3, "y": 3}],
        )

    def test_categories_are_traversed_beyond_one_child_level(self):
        metal, _ = make_mock_category("metal1", "Metal 1", 1, 1, [])
        width, _ = make_mock_category("width", "Width", 2, 1, [])
        minimum, _ = make_mock_category("minimum", "Minimum width", 3, 1, [])
        minimum.path.return_value = "metal1.width.minimum"
        metal.each_sub_category.return_value = iter([width])
        width.each_sub_category.return_value = iter([minimum])
        item = make_mock_item([make_box_value(0, 0, 1, 1)])
        rdb = MagicMock()
        rdb.each_category.return_value = iter([metal])
        rdb.each_item_per_category.side_effect = lambda category_id: iter(
            [item] if category_id == 3 else []
        )

        categories = convert_drc(rdb)["category"]

        self.assertEqual(len(categories["metal1.width.minimum"]["violations"]), 1)

    def test_literal_dotted_name_does_not_overwrite_a_category_path(self):
        metal, _ = make_mock_category("metal1", "Metal 1", 1, 1, [])
        width, _ = make_mock_category("width", "Nested rule", 2, 1, [])
        literal, _ = make_mock_category("metal1.width", "Flat rule", 3, 1, [])
        width.path.return_value = "metal1.width"
        literal.path.return_value = "'metal1.width'"
        metal.each_sub_category.return_value = iter([width])
        items = {
            2: [make_mock_item([make_box_value(0, 0, 1, 1)])],
            3: [make_mock_item([make_box_value(2, 2, 3, 3)])],
        }
        rdb = MagicMock()
        rdb.each_category.return_value = iter([metal, literal])
        rdb.each_item_per_category.side_effect = lambda category_id: iter(
            items.get(category_id, [])
        )

        categories = convert_drc(rdb)["category"]

        self.assertEqual(categories["metal1.width"]["description"], "Nested rule")
        self.assertEqual(categories["'metal1.width'"]["description"], "Flat rule")

    def test_empty_rdb(self):
        rdb = MagicMock()
        rdb.each_category.return_value = iter([])

        result = convert_drc(rdb)

        self.assertEqual(result["source"], os.path.abspath("/tmp/test.drc"))
        self.assertEqual(result["category"], {})

    def test_empty_category_skipped(self):
        cat = MagicMock()
        cat.num_items.return_value = 0

        rdb = MagicMock()
        rdb.each_category.return_value = iter([cat])

        result = convert_drc(rdb)
        self.assertEqual(result["category"], {})

    def test_box_violation(self):
        box_val = make_box_value(100, 200, 300, 400)
        item = make_mock_item([box_val])

        cat = MagicMock()
        cat.name.return_value = "metal1.min_width"
        cat.path.return_value = "'metal1.min_width'"
        cat.description = "Minimum width violation"
        cat.rdb_id.return_value = 1
        cat.num_items.return_value = 1

        rdb = MagicMock()
        rdb.each_category.return_value = iter([cat])
        rdb.each_item_per_category.return_value = iter([item])

        result = convert_drc(rdb)

        violations = result["category"]["'metal1.min_width'"]["violations"]
        self.assertEqual(len(violations), 1)
        self.assertEqual(len(violations[0]["shape"]), 1)
        shape = violations[0]["shape"][0]
        self.assertEqual(shape["type"], "box")
        self.assertEqual(shape["points"][0], {"x": 100, "y": 200})
        self.assertEqual(shape["points"][1], {"x": 300, "y": 400})

    def test_edge_violation(self):
        edge_val = make_edge_value(10, 20, 30, 40)
        item = make_mock_item([edge_val])

        cat = MagicMock()
        cat.name.return_value = "metal1.spacing"
        cat.path.return_value = "'metal1.spacing'"
        cat.description = "Spacing violation"
        cat.rdb_id.return_value = 2
        cat.num_items.return_value = 1

        rdb = MagicMock()
        rdb.each_category.return_value = iter([cat])
        rdb.each_item_per_category.return_value = iter([item])

        result = convert_drc(rdb)

        violations = result["category"]["'metal1.spacing'"]["violations"]
        shape = violations[0]["shape"][0]
        self.assertEqual(shape["type"], "line")
        self.assertEqual(shape["points"][0], {"x": 10, "y": 20})
        self.assertEqual(shape["points"][1], {"x": 30, "y": 40})

    def test_waived_violation(self):
        box_val = make_box_value(0, 0, 10, 10)
        item = make_mock_item([box_val], tags_str="waived")

        cat = MagicMock()
        cat.name.return_value = "rule1"
        cat.path.return_value = "rule1"
        cat.description = "Rule 1"
        cat.rdb_id.return_value = 1
        cat.num_items.return_value = 1

        rdb = MagicMock()
        rdb.each_category.return_value = iter([cat])
        rdb.each_item_per_category.return_value = iter([item])

        result = convert_drc(rdb)

        violation = result["category"]["rule1"]["violations"][0]
        self.assertTrue(violation["waived"])

    def test_text_in_comment(self):
        text_val = make_text_value("error detail")
        item = make_mock_item([text_val])

        cat = MagicMock()
        cat.name.return_value = "rule1"
        cat.path.return_value = "rule1"
        cat.description = "Rule 1"
        cat.rdb_id.return_value = 1
        cat.num_items.return_value = 1

        rdb = MagicMock()
        rdb.each_category.return_value = iter([cat])
        rdb.each_item_per_category.return_value = iter([item])

        result = convert_drc(rdb)

        violation = result["category"]["rule1"]["violations"][0]
        self.assertEqual(violation["comment"], "error detail")

    def test_comment_with_text(self):
        text_val = make_text_value("extra info")
        item = make_mock_item([text_val], comment="base comment")

        cat = MagicMock()
        cat.name.return_value = "rule1"
        cat.path.return_value = "rule1"
        cat.description = "Rule 1"
        cat.rdb_id.return_value = 1
        cat.num_items.return_value = 1

        rdb = MagicMock()
        rdb.each_category.return_value = iter([cat])
        rdb.each_item_per_category.return_value = iter([item])

        result = convert_drc(rdb)

        violation = result["category"]["rule1"]["violations"][0]
        self.assertEqual(violation["comment"], "base comment: extra info")


if __name__ == "__main__":
    unittest.main()
