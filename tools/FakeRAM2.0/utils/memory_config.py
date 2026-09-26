#!/usr/bin/env python3


class MemoryConfig:
    """Container for functional memory configuration"""

    def __init__(self, name, width_in_bits, depth, num_banks, additional_height):
        """Initializer"""

        self._name = name
        self._width_in_bits = width_in_bits
        self._depth = depth
        self._num_banks = num_banks
        self._additional_height = additional_height

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

    @staticmethod
    def from_json(json_data):
        return MemoryConfig(
            str(json_data["name"]),
            int(json_data["width"]),
            int(json_data["depth"]),
            int(json_data["banks"]),
            json_data.get("additional_height", 0),
        )
