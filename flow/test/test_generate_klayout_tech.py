#!/usr/bin/env python3

import unittest
import os
import sys
import tempfile

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

import generate_klayout_tech

MINIMAL_LYT = """\
<?xml version="1.0" encoding="utf-8"?>
<technology>
 <name>Test</name>
 <reader-options>
  <lefdef>
   <lef-files>./original.lef</lef-files>
  </lefdef>
 </reader-options>
</technology>
"""

LYT_WITH_MAP = """\
<?xml version="1.0" encoding="utf-8"?>
<technology>
 <name>Test</name>
 <reader-options>
  <lefdef>
   <lef-files>./original.lef</lef-files>
   <map-file>original.map</map-file>
  </lefdef>
 </reader-options>
</technology>
"""

LYT_WITH_EMPTY_MAP = """\
<?xml version="1.0" encoding="utf-8"?>
<technology>
 <name>Test</name>
 <reader-options>
  <lefdef>
   <lef-files>./original.lef</lef-files>
   <map-file/>
  </lefdef>
 </reader-options>
</technology>
"""


class TestReplaceLefFiles(unittest.TestCase):
    def test_single_lef(self):
        result = generate_klayout_tech.replace_lef_files(MINIMAL_LYT, ["tech.lef"])
        self.assertIn("<lef-files>tech.lef</lef-files>", result)
        self.assertNotIn("original.lef", result)

    def test_multiple_lefs(self):
        result = generate_klayout_tech.replace_lef_files(
            MINIMAL_LYT, ["tech.lef", "sc.lef", "extra.lef"]
        )
        self.assertIn(
            "<lef-files>tech.lef</lef-files>"
            "<lef-files>sc.lef</lef-files>"
            "<lef-files>extra.lef</lef-files>",
            result,
        )
        self.assertNotIn("original.lef", result)

    def test_empty_lefs(self):
        result = generate_klayout_tech.replace_lef_files(MINIMAL_LYT, [])
        self.assertNotIn("original.lef", result)
        # Empty replacement removes the element content
        self.assertNotIn("<lef-files>", result)


class TestReplaceMapFiles(unittest.TestCase):
    def test_replace_existing_map(self):
        result = generate_klayout_tech.replace_map_files(
            LYT_WITH_MAP, ["/abs/path/layer.map"]
        )
        self.assertIn("<map-file>/abs/path/layer.map</map-file>", result)
        self.assertNotIn("original.map", result)

    def test_replace_empty_map(self):
        result = generate_klayout_tech.replace_map_files(
            LYT_WITH_EMPTY_MAP, ["/abs/path/layer.map"]
        )
        self.assertIn("<map-file>/abs/path/layer.map</map-file>", result)

    def test_no_map_files_noop(self):
        result = generate_klayout_tech.replace_map_files(LYT_WITH_MAP, [])
        self.assertEqual(result, LYT_WITH_MAP)

    def test_no_map_element_in_template(self):
        result = generate_klayout_tech.replace_map_files(MINIMAL_LYT, ["/some/map"])
        # No map element to replace, content unchanged
        self.assertEqual(result, MINIMAL_LYT)


class TestGenerateKlayoutTech(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.template = os.path.join(self.tmp_dir.name, "test.lyt")
        self.output = os.path.join(self.tmp_dir.name, "output.lyt")
        self.results_dir = os.path.join(self.tmp_dir.name, "results")
        os.makedirs(self.results_dir, exist_ok=True)

    def tearDown(self):
        self.tmp_dir.cleanup()

    def test_basic_generation(self):
        with open(self.template, "w") as f:
            f.write(MINIMAL_LYT)

        lef_path = os.path.join(self.tmp_dir.name, "tech.lef")
        with open(lef_path, "w") as f:
            f.write("")

        generate_klayout_tech.generate_klayout_tech(
            template_lyt=self.template,
            output_lyt=self.output,
            lef_files=[lef_path],
            reference_dir=self.results_dir,
            map_files=[],
            use_relative_paths=True,
        )

        with open(self.output) as f:
            content = f.read()

        self.assertIn("<lef-files>", content)
        self.assertNotIn("original.lef", content)
        # LEF paths are written as plain abspath (not relpath, not realpath):
        # klayout's Layout.read resolves relative <lef-files> entries
        # against the realpath of the DEF being merged, which under a
        # Bazel sandbox is the bare execroot -- the in-flight sibling
        # files only exist in the per-action sandbox.  Absolute paths
        # bypass the relative-resolution dance.
        self.assertIn(os.path.abspath(lef_path), content)

    def test_with_map_files(self):
        with open(self.template, "w") as f:
            f.write(LYT_WITH_MAP)

        lef_path = os.path.join(self.tmp_dir.name, "tech.lef")
        map_path = os.path.join(self.tmp_dir.name, "layer.map")
        for p in [lef_path, map_path]:
            with open(p, "w") as f:
                f.write("")

        generate_klayout_tech.generate_klayout_tech(
            template_lyt=self.template,
            output_lyt=self.output,
            lef_files=[lef_path],
            reference_dir=self.results_dir,
            map_files=[map_path],
            use_relative_paths=False,
        )

        with open(self.output) as f:
            content = f.read()

        self.assertIn(os.path.realpath(map_path), content)
        self.assertNotIn("original.map", content)

    def test_multiple_lef_files(self):
        with open(self.template, "w") as f:
            f.write(MINIMAL_LYT)

        lef_files = []
        for name in ["tech.lef", "sc.lef", "extra.lef"]:
            path = os.path.join(self.tmp_dir.name, name)
            with open(path, "w") as f:
                f.write("")
            lef_files.append(path)

        generate_klayout_tech.generate_klayout_tech(
            template_lyt=self.template,
            output_lyt=self.output,
            lef_files=lef_files,
            reference_dir=self.results_dir,
            map_files=[],
            use_relative_paths=True,
        )

        with open(self.output) as f:
            content = f.read()

        # Should have three lef-files elements
        self.assertEqual(content.count("<lef-files>"), 3)


class TestRealPlatformLyt(unittest.TestCase):
    """Test against actual platform .lyt files to catch regressions."""

    PLATFORMS_DIR = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "..", "platforms"
    )

    def _test_platform(self, lyt_path):
        if not os.path.exists(lyt_path):
            self.skipTest(f"{lyt_path} not found")

        with open(lyt_path) as f:
            content = f.read()

        result = generate_klayout_tech.replace_lef_files(
            content, ["replaced_tech.lef", "replaced_sc.lef"]
        )
        self.assertIn("<lef-files>replaced_tech.lef</lef-files>", result)
        self.assertIn("<lef-files>replaced_sc.lef</lef-files>", result)
        # Original lef-files content should be gone
        self.assertNotIn("NangateOpenCellLibrary", result)
        self.assertNotIn("asap7_tech", result)

    def test_nangate45(self):
        self._test_platform(
            os.path.join(self.PLATFORMS_DIR, "nangate45", "FreePDK45.lyt")
        )

    def test_asap7(self):
        self._test_platform(
            os.path.join(self.PLATFORMS_DIR, "asap7", "KLayout", "asap7.lyt")
        )

    def test_sky130hd(self):
        self._test_platform(
            os.path.join(self.PLATFORMS_DIR, "sky130hd", "sky130hd.lyt")
        )


if __name__ == "__main__":
    unittest.main()
