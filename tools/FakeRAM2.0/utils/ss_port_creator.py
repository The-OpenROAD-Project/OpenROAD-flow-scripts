#!/usr/bin/env python3

from port import Port


class SSPortCreator:
    """
    Creates pin shapes for all signal and pg ports plus obstructions from
    a spreadsheet input
    """

    def __init__(self, mem, pin_type_map):
        self._mem = mem
        self._pin_type_map = pin_type_map

    def get_direction(self, pin_name):
        base_name = pin_name.split("[")[0]
        if base_name in self._pin_type_map:
            pin_type = self._pin_type_map[base_name]
            if pin_type in ["power", "ground"]:
                return (pin_type, Port.Direction.INOUT)
            elif pin_type == "output_bus":
                return (pin_type, Port.Direction.OUTPUT)
        return (None, Port.Direction.INPUT)

    def create_ports(self, ss_data):
        for pin_name, pin_data in ss_data.items():
            port = Port(pin_name)
            port.set_use(pin_data["use"])
            port.set_layer(pin_data["layer"])
            rect_data = pin_data["rect"]
            if isinstance(rect_data[0], list):
                for rect in rect_data:
                    port.add_rect(rect)
            else:
                port.add_rect(rect_data)
            pin_type, direction = self.get_direction(pin_name)
            port.set_direction(direction)
            if pin_type in ["power", "ground"]:
                self._mem.add_pg_port(port)
            else:
                self._mem.add_port(port)

    def create_obs(self, ss_data):
        for obs in ss_data:
            self._mem.add_obstruction(obs["layer"], obs["rect"], obs["layer_attr"])
