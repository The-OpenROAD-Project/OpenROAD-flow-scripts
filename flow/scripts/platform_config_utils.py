#!/usr/bin/env python3
"""Shared utilities for platform config.py files.

Each platform's config.py uses PlatformConfig to accumulate variables
and output them in Make-compatible or JSON format. This follows the
same pattern as defaults.py: Python generates Make code that Make
$(eval)s back into itself.
"""

import glob
import json
import os
import sys


class PlatformConfig:
    """Accumulates platform configuration variables and outputs them.

    Maintains ordered list of (key, value, conditional) tuples.
    conditional=True means ?= (only set if not already defined).
    conditional=False means = (unconditional assignment).
    """

    def __init__(self, platform_dir=None):
        if platform_dir is not None:
            self.platform_dir = platform_dir
        else:
            self.platform_dir = os.environ.get(
                "PLATFORM_DIR",
                os.path.dirname(
                    os.path.abspath(sys._getframe(1).f_globals["__file__"])
                ),
            )
        self.platform = os.environ.get("PLATFORM", os.path.basename(self.platform_dir))
        self._vars = []  # ordered list of (key, value, conditional)
        self._index = {}  # key -> index in _vars for fast lookup

    def env(self, key, default=""):
        """Read a variable from the environment."""
        return os.environ.get(key, default)

    def set(self, key, value, conditional=False):
        """Set a variable. conditional=True means ?= semantics."""
        value = str(value)
        if conditional and key in self._index:
            # Already set internally, skip conditional
            return
        if conditional and key in os.environ:
            # Already set in environment, use env value
            value = os.environ[key]
            conditional = False
        if key in self._index:
            self._vars[self._index[key]] = (key, value, conditional)
        else:
            self._index[key] = len(self._vars)
            self._vars.append((key, value, conditional))

    def append(self, key, value):
        """Append to a variable (like Make +=).

        If the key exists internally, appends to that value.
        Otherwise reads current value from environment first.
        """
        value = str(value)
        if key in self._index:
            existing = self._vars[self._index[key]][1]
            combined = (existing + " " + value).strip()
            self._vars[self._index[key]] = (key, combined, False)
        else:
            existing = os.environ.get(key, "")
            combined = (existing + " " + value).strip()
            self._index[key] = len(self._vars)
            self._vars.append((key, combined, False))

    def get(self, key, default=""):
        """Get a variable's current value (from internal state)."""
        if key in self._index:
            return self._vars[self._index[key]][1]
        return default

    def sorted_glob(self, pattern):
        """sorted(glob.glob(pattern)) -- replaces $(sort $(wildcard ...))"""
        return " ".join(sorted(glob.glob(pattern)))

    def wildcard_glob(self, pattern):
        """glob.glob(pattern) -- replaces $(wildcard ...)"""
        return " ".join(glob.glob(pattern))

    def _unexpand(self, value):
        """Replace expanded paths with Make variable references.

        Consumers expand these on their end:
        - Make: $(eval) expands $(PLATFORM_DIR) and $(PLATFORM)
        - bazel-orfs: Python substitution when the rule executes
        """
        # Replace platform_dir first (longer, more specific)
        value = value.replace(self.platform_dir, "$(PLATFORM_DIR)")
        # Replace platform name within $(PLATFORM_DIR)/... paths only
        # e.g. $(PLATFORM_DIR)/sky130hd.lyt -> $(PLATFORM_DIR)/$(PLATFORM).lyt
        if self.platform:
            value = value.replace(
                "$(PLATFORM_DIR)/" + self.platform,
                "$(PLATFORM_DIR)/$(PLATFORM)",
            )
            # Also in subdirectories: $(PLATFORM_DIR)/drc/sky130hd.lydrc
            value = value.replace(
                "/" + self.platform + ".",
                "/$(PLATFORM).",
            )
        return value

    def output_make(self):
        """Print Make-compatible output lines.

        Format matches defaults.py: export KEY=VALUE or export KEY?=VALUE
        with spaces replaced by __SPACE__.
        """
        for key, value, conditional in self._vars:
            op = "?=" if conditional else "="
            value = self._unexpand(value)
            encoded = value.replace(" ", "__SPACE__")
            print(f"export {key}{op}{encoded}")

    def output_json(self):
        """Print flat JSON dict for bazel-orfs or other consumers."""
        result = {}
        for key, value, _conditional in self._vars:
            result[key] = self._unexpand(value)
        json.dump(result, sys.stdout, indent=2)
        print()  # trailing newline

    def output(self):
        """Select output mode based on --format=json argument."""
        if "--format=json" in sys.argv:
            self.output_json()
        else:
            self.output_make()

    def to_dict(self):
        """Return flat dict of all variables (for testing)."""
        result = {}
        for key, value, _conditional in self._vars:
            result[key] = value
        return result
