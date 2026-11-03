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
        if self._mask_lanes and width_in_bits % self._mask_lanes:
            raise Exception(
                "Width %d is not a whole number of %d mask lanes (%s)"
                % (width_in_bits, self._mask_lanes, name)
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
        )
