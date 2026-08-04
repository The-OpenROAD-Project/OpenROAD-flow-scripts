#!/usr/bin/env python3

from port import Port


class BasicPortCreator:
    """
    Creates pin shapes for all signal and pg ports plus obstructions
    """

    def __init__(self, mem):
        # In rect_pin_mode, we try and avoid EOL spacing issues by:
        #   1) making the pins rectangular in the X direction:
        #          width: min_pin_width * 1.5
        #          height: 1.5 * min_pin_width
        #   2) reducing the width of the power/ground straps by one x_offset
        #      on the left side where the pins are
        self._rect_pin_mode = (
            mem.get_physical_data().get_pin_pitch()
            == mem.get_process_data().get_pin_pitch_um()
        )
        self._mem = mem

    def create_ports(self):
        """Creates the pin/port shapes"""

        physical = self._mem.get_physical_data()
        pin_pitch = physical.get_pin_pitch()
        group_pitch = physical.get_group_pitch()
        w = physical.get_width()
        h = physical.get_height()

        process = self._mem.get_process_data()
        min_pin_width = process.get_pin_width_um()
        min_pin_pitch = process.get_pin_pitch_um()
        metal_prefix = process.get_metal_prefix()
        metal_layer = process.get_metal_layer()
        x_offset = process.get_x_offset()
        y_offset = process.get_y_offset()

        self.create_signal_pins(pin_pitch, group_pitch)
        self.create_pg_straps(
            min_pin_width, min_pin_pitch, x_offset, y_offset, w, h, metal_layer
        )
        self.create_obs(metal_layer, metal_prefix, w, h)

    def create_signal_pins(self, pin_pitch, group_pitch):
        """Creates the signal pin/port shapes"""

        y_step = self._mem.get_process_data().y_step
        for rw_port_group in self._mem.get_rw_port_groups():
            y_step = self.create_signals(rw_port_group, y_step, pin_pitch, group_pitch)
        for rw_port_group in self._mem.get_rw_port_groups():
            y_step = self.add_pin(
                rw_port_group.get_write_enable_name(),
                Port.Direction.INPUT,
                y_step,
                pin_pitch,
            )
            y_step = self.add_pin(
                rw_port_group.get_clock_name(), Port.Direction.INPUT, y_step, pin_pitch
            )
        for bus_data in self._mem.get_misc_busses():
            y_step += group_pitch
            y_step = self.write_signal_bus(
                bus_data["name"],
                bus_data["lsb"],
                bus_data["msb"],
                Port.Direction.INPUT,
                y_step,
                pin_pitch,
            )
        for port_name in self._mem.get_misc_ports():
            port = self._mem.get_port(port_name)
            y_step = self.add_pin(port_name, Port.Direction.INPUT, y_step, pin_pitch)

    def create_signals(self, rw_port_group, y_step, pin_pitch, group_pitch):
        """creates rw signal bundle, comprised of dout, din, addr busses"""

        bits = self._mem.get_width()
        y_step = self.write_signal_bus(
            rw_port_group.get_data_output_bus_name(),
            0,
            bits,
            Port.Direction.OUTPUT,
            y_step,
            pin_pitch,
        )
        y_step += group_pitch
        y_step = self.write_signal_bus(
            rw_port_group.get_data_input_bus_name(),
            0,
            bits,
            Port.Direction.INPUT,
            y_step,
            pin_pitch,
        )
        y_step += group_pitch
        y_step = self.write_signal_bus(
            rw_port_group.get_address_bus_name(),
            0,
            self._mem.get_addr_width(),
            Port.Direction.INPUT,
            y_step,
            pin_pitch,
        )
        y_step += group_pitch
        return y_step

    def write_signal_bus(self, name, lsb, msb, direction, y_step, pin_pitch):
        """Writes the individual pins for a signal bus"""

        name_format = f"{name}[%d]"
        for i in range(lsb, msb):
            y_step = self.add_pin(name_format % i, direction, y_step, pin_pitch)
        return y_step

    def add_pin(self, pin_name, direction, y, pitch):
        """
        Helper function that adds a signal pin
        """
        process = self._mem.get_process_data()
        layer = process.get_metal_layer()
        pw = process.get_pin_width_um()
        hpw = process.get_pin_width_um() / 2.0
        # half pin width

        port = Port(pin_name)
        port.set_direction(direction)
        port.set_layer(layer)
        if self._rect_pin_mode:
            # make pins a little longer in the X direction
            port.add_rect([0, y - hpw, pw + hpw, y + hpw])
        else:
            port.add_rect([0, y - hpw, pw, y + hpw])
        self._mem.add_port(port)
        return y + pitch

    def create_pg_pin(
        self,
        pin_name,
        pin_use,
        metal_layer,
        w,
        h,
        y_step,
        x_offset,
        y_offset,
        supply_pin_half_width,
        supply_pin_pitch,
    ):
        """Writes a power/ground pin"""

        port = Port(pin_name)
        port.set_direction(Port.Direction.INOUT)
        port.set_use(pin_use)
        port.set_layer(metal_layer)
        self.create_pg_shapes(
            port,
            w,
            h,
            y_step,
            x_offset,
            y_offset,
            supply_pin_half_width,
            supply_pin_pitch,
        )
        self._mem.add_pg_port(port)

    def create_pg_shapes(
        self,
        port,
        w,
        h,
        y_step,
        x_offset,
        y_offset,
        supply_pin_half_width,
        supply_pin_pitch,
    ):
        """Creates power/ground shapes"""

        # if in rect_pin_mode we start the pin two offsets in to avoid
        # spacing issues with the signal pin
        mod_x_offset = x_offset * (self._rect_pin_mode + 1)
        while y_step <= h - y_offset:
            port.add_rect(
                [
                    mod_x_offset,
                    y_step - supply_pin_half_width,
                    w - mod_x_offset,
                    y_step + supply_pin_half_width,
                ]
            )
            y_step += (
                supply_pin_pitch * 2
            )  # this *2 is important because we want alternate VDD and VSS pins

    def create_pg_straps(
        self, min_pin_width, min_pin_pitch, x_offset, y_offset, w, h, metal_layer
    ):
        """Create power/ground straps"""

        supply_pin_width = min_pin_width * 4
        supply_pin_half_width = supply_pin_width / 2
        supply_pin_pitch = min_pin_pitch * 8
        # supply_pin_layer = '%s' % metal_layer

        ## Create supply pins  : How are we ensuring that supply pins don't overlap
        ## with the signal pins? Is it by giving x_offset as the base x coordinate ?
        y_step = y_offset
        self.create_pg_pin(
            "VSS",
            "GROUND",
            metal_layer,
            w,
            h,
            y_step,
            x_offset,
            y_offset,
            supply_pin_half_width,
            supply_pin_pitch,
        )

        y_step = y_offset + supply_pin_pitch
        self.create_pg_pin(
            "VDD",
            "POWER",
            metal_layer,
            w,
            h,
            y_step,
            x_offset,
            y_offset,
            supply_pin_half_width,
            supply_pin_pitch,
        )

    def create_obs(self, metal_layer, metal_prefix, w, h):
        """Create obstructions"""

        # full rect
        pin_layer_number = int(metal_layer.replace(metal_prefix, "", 1))
        obs_rect = [0, 0, w, h]
        for x in range(pin_layer_number):
            dummy = x + 1
            layer_name = f"{metal_prefix}{dummy}"
            self._mem.add_obstruction(layer_name, obs_rect)
