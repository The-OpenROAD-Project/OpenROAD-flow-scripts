#!/usr/bin/env python3


class MemoryConfig:
    """Container for functional memory configuration"""

    def __init__(
        self,
        name,
        width_in_bits,
        depth,
        num_banks,
        additional_height,
        pin_names=None,
        mask_lanes=0,
        mask_lane_width=0,
    ):
        """Initializer"""

        self._name = name
        self._width_in_bits = width_in_bits
        self._depth = depth
        self._num_banks = num_banks
        self._additional_height = additional_height
        # Optional: the port names the macro must carry, keyed by role
        # (clk, ce, we, addr, din, dout, mask), and the number of write
        # mask lanes. Absent, the memory keeps its historical pin names
        # and writes whole words.
        self._pin_names = dict(pin_names) if pin_names else {}
        self._mask_lanes = int(mask_lanes or 0)
        # Bits per lane; the last lane holds the rest (tc_sram's byte
        # enables over a word that is not whole bytes). 0: an even split.
        self._mask_lane_width = int(mask_lane_width or 0)
        lanes, width = self._mask_lanes, self._mask_lane_width
        if lanes and not width:
            if width_in_bits % lanes:
                raise Exception(
                    "Width %d is not a whole number of %d mask lanes (%s)"
                    % (width_in_bits, lanes, name)
                )
            self._mask_lane_width = width_in_bits // lanes
        elif width and not lanes:
            raise Exception("mask_lane_width without mask_lanes (%s)" % name)
        elif width and not (lanes * width >= width_in_bits > (lanes - 1) * width):
            raise Exception(
                "%d mask lanes of %d bits do not cover width %d (%s)"
                % (lanes, width, width_in_bits, name)
            )

    def set_name(self, name):
        """Sets the name"""
        self._name = name

    def get_name(self):
        """Returns the name"""
        return self._name

    def get_width_in_bits(self):
        """Returns the width_in_bits"""
        return self._width_in_bits

    def get_depth(self):
        """Returns the depth"""
        return self._depth

    def get_num_banks(self):
        """Returns the num_banks"""
        return self._num_banks

    def get_additional_height(self):
        """Returns the additional_height"""
        return self._additional_height

    def get_pin_names(self):
        """Returns the role -> port name dictionary (may be empty)"""
        return self._pin_names

    def get_mask_lanes(self):
        """Returns the number of write mask lanes, 0 when unmasked"""
        return self._mask_lanes

    def get_mask_lane_width(self):
        """Returns the bits per mask lane; the last lane holds the rest"""
        return self._mask_lane_width

    @staticmethod
    def from_json(json_data):
        return MemoryConfig(
            str(json_data["name"]),
            int(json_data["width"]),
            int(json_data["depth"]),
            int(json_data["banks"]),
            json_data.get("additional_height", 0),
            json_data.get("pin_names"),
            json_data.get("mask_lanes", 0),
            json_data.get("mask_lane_width", 0),
        )
