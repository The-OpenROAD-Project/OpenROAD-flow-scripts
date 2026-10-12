#!/usr/bin/env python3

import unittest
from unittest.mock import MagicMock, patch, call
import sys
import os
import tempfile

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

import def2stream


def make_mock_cell(name, cell_index=0, is_empty=False, parent_cells=1):
    """Create a mock cell object."""
    cell = MagicMock()
    cell.name = name
    cell.cell_index.return_value = cell_index
    cell.is_empty.return_value = is_empty
    cell.parent_cells.return_value = parent_cells
    return cell


def make_mock_pya(cells_before_read=None, cells_after_read=None, top_only_cells=None):
    """Create a mock pya module with configurable cell behavior.

    Args:
        cells_before_read: Cells in main_layout before reading DEF.
        cells_after_read: Cells in main_layout after reading DEF/GDS.
        top_only_cells: Cells in top_only_layout after copy_tree.
    """
    pya_mod = MagicMock()

    # Technology mock
    tech = MagicMock()
    pya_mod.Technology.return_value = tech

    # Main layout mock
    main_layout = MagicMock()
    pya_mod.Layout.side_effect = [main_layout]

    if cells_before_read is None:
        cells_before_read = []
    if cells_after_read is None:
        cells_after_read = []

    # each_cell returns different results before and after read
    main_layout.each_cell.side_effect = [
        iter(cells_before_read),  # first call: before reading DEF
        iter(cells_after_read),  # second call: clearing non-top cells
    ]

    # top_only_layout is the second Layout() call
    top_only_layout = MagicMock()

    if top_only_cells is None:
        top_only_cells = []

    # top_only each_cell called twice: missing cell check and orphan check
    top_only_layout.each_cell.side_effect = [
        iter(top_only_cells),  # missing cell check
        iter(top_only_cells),  # orphan cell check
    ]

    # Override Layout side_effect to return both layouts
    pya_mod.Layout.side_effect = [main_layout, top_only_layout]

    top_cell = MagicMock()
    top_cell.name = "test_design"
    top_only_layout.create_cell.return_value = top_cell
    top_only_layout.top_cell.return_value = top_cell
    top_only_layout.top_cells.return_value = []

    return pya_mod, main_layout, top_only_layout, top_cell


class TestMergeGdsBasic(unittest.TestCase):
    def test_no_errors_clean_design(self):
        """A clean design with no missing/orphan cells should return 0 errors."""
        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, top_only_layout, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[],
        )

        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="/tmp/cells.gds",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(errors, 0)
        top_only_layout.write.assert_called_once_with("/tmp/out.gds")

    def test_layer_map_applied(self):
        """When layer_map is non-empty, it should be set on layout options."""
        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        tech = pya_mod.Technology.return_value

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="/tmp/layer.map",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(
            tech.load_layout_options.lefdef_config.map_file, "/tmp/layer.map"
        )

    def test_empty_layer_map_not_applied(self):
        """When layer_map is empty, map_file should not be set."""
        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        tech = pya_mod.Technology.return_value
        original_map = tech.load_layout_options.lefdef_config.map_file

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(tech.load_layout_options.lefdef_config.map_file, original_map)


class TestCellClearing(unittest.TestCase):
    def test_non_top_cells_cleared(self):
        """Non-top cells (not VIA_ or _DEF_FILL) should be cleared."""
        top = make_mock_cell("test_design", cell_index=0)
        filler = make_mock_cell("FILLER_cell", cell_index=1)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top, filler],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        filler.clear.assert_called_once()

    def test_via_cells_preserved(self):
        """Cells starting with VIA_ should NOT be cleared."""
        top = make_mock_cell("test_design", cell_index=0)
        via = make_mock_cell("VIA_M1M2", cell_index=1)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top, via],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        via.clear.assert_not_called()

    def test_def_fill_cells_preserved(self):
        """Cells ending with _DEF_FILL should NOT be cleared."""
        top = make_mock_cell("test_design", cell_index=0)
        fill = make_mock_cell("some_DEF_FILL", cell_index=2)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top, fill],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        fill.clear.assert_not_called()


class TestMissingCells(unittest.TestCase):
    def test_empty_cell_is_error(self):
        """An empty cell without GDS_ALLOW_EMPTY should count as an error."""
        missing = make_mock_cell(
            "missing_gds", cell_index=1, is_empty=True, parent_cells=1
        )

        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[missing],
        )
        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(errors, 1)

    def test_allow_empty_regex_suppresses_error(self):
        """GDS_ALLOW_EMPTY regex should suppress errors for matching cells."""
        missing = make_mock_cell(
            "pad_io_cell", cell_index=1, is_empty=True, parent_cells=1
        )

        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[missing],
        )
        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
            allow_empty="pad_.*",
        )

        self.assertEqual(errors, 0)

    def test_allow_empty_regex_no_match_still_errors(self):
        """GDS_ALLOW_EMPTY regex should not suppress non-matching cells."""
        missing = make_mock_cell(
            "other_cell", cell_index=1, is_empty=True, parent_cells=1
        )

        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[missing],
        )
        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
            allow_empty="pad_.*",
        )

        self.assertEqual(errors, 1)

    def test_auto_memories_cell_may_be_empty(self):
        """A macro AUTO_MEMORIES generated has no GDS; it is not an error."""
        generated = make_mock_cell(
            "tage_entry_sram", cell_index=1, is_empty=True, parent_cells=1
        )
        other = make_mock_cell("other_cell", cell_index=2, is_empty=True)

        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[generated, other],
        )
        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
            allow_empty_cells=frozenset(["tage_entry_sram"]),
        )

        self.assertEqual(errors, 1)


class TestAutoMemoriesCells(unittest.TestCase):
    def test_off_reads_nothing(self):
        self.assertEqual(
            def2stream.auto_memories_cells({"RESULTS_DIR": "/nonexistent"}),
            frozenset(),
        )

    def test_names_from_blackboxes_txt(self):
        with tempfile.TemporaryDirectory() as results:
            os.mkdir(os.path.join(results, "memories"))
            with open(os.path.join(results, "memories", "blackboxes.txt"), "w") as f:
                # a name per line, optionally followed by more columns
                f.write("tage_entry_sram\nmbtb_entry_sram 491.400000\n\n")
            self.assertEqual(
                def2stream.auto_memories_cells(
                    {"AUTO_MEMORIES": "1", "RESULTS_DIR": results}
                ),
                frozenset(["tage_entry_sram", "mbtb_entry_sram"]),
            )

    def test_missing_list_is_an_error(self):
        # the flow always writes it; a missing list is a broken flow, not
        # a design without generated macros
        with tempfile.TemporaryDirectory() as results:
            with self.assertRaisesRegex(RuntimeError, "blackboxes.txt is missing"):
                def2stream.auto_memories_cells(
                    {"AUTO_MEMORIES": "1", "RESULTS_DIR": results}
                )

    def test_missing_results_dir_is_an_error(self):
        with self.assertRaisesRegex(RuntimeError, "RESULTS_DIR is not set"):
            def2stream.auto_memories_cells({"AUTO_MEMORIES": "1"})

    def test_empty_list_allows_nothing(self):
        with tempfile.TemporaryDirectory() as results:
            os.mkdir(os.path.join(results, "memories"))
            open(os.path.join(results, "memories", "blackboxes.txt"), "w").close()
            self.assertEqual(
                def2stream.auto_memories_cells(
                    {"AUTO_MEMORIES": "1", "RESULTS_DIR": results}
                ),
                frozenset(),
            )


class TestOrphanCells(unittest.TestCase):
    def test_orphan_cell_is_error(self):
        """A cell with no parents (orphan) should count as an error."""
        orphan = make_mock_cell(
            "orphan_cell", cell_index=1, is_empty=False, parent_cells=0
        )

        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[orphan],
        )
        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(errors, 1)

    def test_top_cell_not_orphan(self):
        """The top cell itself should not be counted as an orphan."""
        top = make_mock_cell(
            "test_design", cell_index=0, is_empty=False, parent_cells=0
        )

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[top],
        )
        main_layout.cell.return_value = top

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(errors, 0)


class TestSealFile(unittest.TestCase):
    def test_seal_file_merged(self):
        """When seal_file is provided, seal cells should be merged."""
        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, top_only_layout, top_cell = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        seal_cell = MagicMock()
        seal_cell.name = "seal_ring"
        seal_cell.cell_index.return_value = 5
        # top_cells returns original top + seal after reading seal file
        top_only_layout.top_cells.return_value = [top_cell, seal_cell]

        errors = def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="/tmp/seal.gds",
            out_file="/tmp/out.gds",
        )

        self.assertEqual(errors, 0)
        top_only_layout.read.assert_called_once_with("/tmp/seal.gds")
        pya_mod.CellInstArray.assert_called_once_with(5, pya_mod.Trans.return_value)

    def test_no_seal_file(self):
        """When seal_file is empty, no seal merging should happen."""
        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, top_only_layout, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        top_only_layout.read.assert_not_called()


class TestGdsFileMerging(unittest.TestCase):
    def test_multiple_gds_files_read(self):
        """All space-separated GDS files should be read into main_layout."""
        top = make_mock_cell("test_design", cell_index=0)

        pya_mod, main_layout, _, _ = make_mock_pya(
            cells_before_read=[],
            cells_after_read=[top],
            top_only_cells=[],
        )
        main_layout.cell.return_value = top

        def2stream.merge_gds(
            pya_mod=pya_mod,
            tech_file="/tmp/test.lyt",
            layer_map="",
            in_def="/tmp/test.def",
            design_name="test_design",
            in_files="/tmp/a.gds /tmp/b.gds /tmp/c.gds",
            seal_file="",
            out_file="/tmp/out.gds",
        )

        # read is called for DEF + 3 GDS files = 4 total
        read_calls = main_layout.read.call_args_list
        self.assertEqual(len(read_calls), 4)  # 1 DEF + 3 GDS


if __name__ == "__main__":
    unittest.main()
