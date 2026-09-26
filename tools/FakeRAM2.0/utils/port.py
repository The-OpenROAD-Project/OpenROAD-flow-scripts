#!/usr/bin/env python3

from enum import Enum
from named_object import NamedObject


class Port(NamedObject):
    """
    Memory Port object
    """

    class Direction(Enum):
        """Direction enum"""

        INPUT = 1
        OUTPUT = 2
        INOUT = 3

        def get_liberty_name(self):
            """Returns the liberty name for the direction"""
            return self.name.lower()

        def get_lef_name(self):
            """Returns the lef name for the direction"""
            return self.name

        def get_verilog_name(self):
            """Returns the verilog name for the direction"""
            return self.name.lower()

    def __init__(self, name):
        """
        Initializer

          name - port name
          dir - port direction
          use - LEF USE
          layer - port/pin shape layer name
          rect_list - list of port/pin shape (each is a list of four
                      numbers: llx lly urx ury)
        """
        NamedObject.__init__(self, name)
        self._dir = Port.Direction.INPUT
        self._use = "SIGNAL"
        self._layer = None
        self._rect_list = []

    def set_direction(self, dir):
        """Sets the port direction"""
        self._dir = dir

    def get_direction(self):
        """Gets the port direction"""
        return self._dir

    def set_use(self, use):
        """Sets the LEF USE"""
        self._use = use

    def get_use(self):
        """Gets the LEF USE"""
        return self._use

    def set_layer(self, layer):
        """Sets the port/pin shape layer name"""
        self._layer = layer

    def get_layer(self):
        """Gets the port/pin shape layer name"""
        return self._layer

    def add_rect(self, rect):
        """Sets the port/pin shape"""
        self._rect_list.append(rect)

    def get_rects(self):
        """Gets the port/pin shape list"""
        return self._rect_list
