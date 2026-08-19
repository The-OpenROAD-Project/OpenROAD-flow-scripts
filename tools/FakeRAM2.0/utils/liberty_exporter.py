#!/usr/bin/env python3

import time
import datetime
from exporter import Exporter


class LibertyExporter(Exporter):
    """Liberty exporter base class"""

    def __init__(self, memory):
        """Initializer"""
        Exporter.__init__(self, memory)

    def export(self, out_fh):
        """Exports the Liberty content to the output stream"""

        name = self.get_memory().get_name()
        out_fh.write("library(%s) {\n" % name)
        self.write_header(out_fh)
        self.write_defaults(out_fh)
        self.write_table_templates(out_fh)
        out_fh.write("    library_features(report_delay_calculation);\n")
        self.write_bus_defs(out_fh)
        self.write_cell_header(out_fh)
        self.write_cell(out_fh)
        self.write_cell_footer(out_fh)
        out_fh.write("\n")
        out_fh.write("}\n")

    def write_cell_header(self, out_fh):
        """Writes the cell header to the output stream"""

        name = self.get_memory().get_name()
        area = self.get_memory().physical.get_area(False)
        out_fh.write("cell(%s) {\n" % name)
        out_fh.write("    area : %.6f;\n" % area)
        out_fh.write("    interface_timing : true;\n")

    def write_cell_footer(self, out_fh):
        """Writes the cell footer to the output stream"""

        out_fh.write(
            "    cell_leakage_power : %.3f;\n"
            % (self.get_memory().get_timing_data().leakage)
        )
        out_fh.write("}\n")

    def write_header(self, out_fh):
        """Writes the Liberty header"""

        # Get the date
        d = datetime.date.today()
        date = d.isoformat()
        current_time = time.strftime("%H:%M:%SZ", time.gmtime())

        voltage = self.get_memory().get_process_data().voltage
        out_fh.write("    technology (cmos);\n")
        out_fh.write("    delay_model : table_lookup;\n")
        out_fh.write("    revision : 1.0;\n")
        out_fh.write('    date : "%s %s";\n' % (date, current_time))
        out_fh.write('    comment : "SRAM";\n')
        out_fh.write('    time_unit : "1ns";\n')
        out_fh.write('    voltage_unit : "1V";\n')
        out_fh.write('    current_unit : "1uA";\n')
        out_fh.write('    leakage_power_unit : "1uW";\n')
        out_fh.write("    nom_process : 1;\n")
        out_fh.write("    nom_temperature : 25.000;\n")
        out_fh.write("    nom_voltage : %.3f;\n" % voltage)
        out_fh.write("    capacitive_load_unit (1,pf);\n\n")
        out_fh.write('    pulling_resistance_unit : "1kohm";\n\n')
        out_fh.write("    operating_conditions(tt_1.0_25.0) {\n")
        out_fh.write("        process : 1;\n")
        out_fh.write("        temperature : 25.000;\n")
        out_fh.write("        voltage : %.3f;\n" % voltage)
        out_fh.write("        tree_type : balanced_tree;\n")
        out_fh.write("    }\n")
        out_fh.write("\n")

    def write_defaults(self, out_fh):
        """Writes the library defaults"""

        out_fh.write("    /* default attributes */\n")
        out_fh.write("    default_cell_leakage_power : 0;\n")
        out_fh.write("    default_fanout_load : 1;\n")
        out_fh.write("    default_inout_pin_cap : 0.0;\n")
        out_fh.write("    default_input_pin_cap : 0.0;\n")
        out_fh.write("    default_output_pin_cap : 0.0;\n")
        out_fh.write("    default_input_pin_cap : 0.0;\n")
        out_fh.write(
            "    default_max_transition : %.3f;\n\n"
            % self.get_memory().get_timing_data().max_slew
        )
        out_fh.write("    default_operating_conditions : tt_1.0_25.0;\n")
        out_fh.write("    default_leakage_power_density : 0.0;\n")
        out_fh.write("\n")

        out_fh.write("    /* additional header data */\n")
        out_fh.write("    slew_derate_from_library : 1.000;\n")
        out_fh.write("    slew_lower_threshold_pct_fall : 20.000;\n")
        out_fh.write("    slew_upper_threshold_pct_fall : 80.000;\n")
        out_fh.write("    slew_lower_threshold_pct_rise : 20.000;\n")
        out_fh.write("    slew_upper_threshold_pct_rise : 80.000;\n")
        out_fh.write("    input_threshold_pct_fall : 50.000;\n")
        out_fh.write("    input_threshold_pct_rise : 50.000;\n")
        out_fh.write("    output_threshold_pct_fall : 50.000;\n")
        out_fh.write("    output_threshold_pct_rise : 50.000;\n\n")
        out_fh.write("\n")

    def write_table_templates(self, out_fh):
        """Writes the default table templates"""

        name = self.get_memory().get_name()
        out_fh.write("    lu_table_template(%s_mem_out_delay_template) {\n" % name)
        out_fh.write("        variable_1 : input_net_transition;\n")
        out_fh.write("        variable_2 : total_output_net_capacitance;\n")
        out_fh.write('            index_1 ("1000, 1001");\n')
        out_fh.write('            index_2 ("1000, 1001");\n')
        out_fh.write("    }\n")
        out_fh.write("    lu_table_template(%s_mem_out_slew_template) {\n" % name)
        out_fh.write("        variable_1 : total_output_net_capacitance;\n")
        out_fh.write('            index_1 ("1000, 1001");\n')
        out_fh.write("    }\n")
        out_fh.write("    lu_table_template(%s_constraint_template) {\n" % name)
        out_fh.write("        variable_1 : related_pin_transition;\n")
        out_fh.write("        variable_2 : constrained_pin_transition;\n")
        out_fh.write('            index_1 ("1000, 1001");\n')
        out_fh.write('            index_2 ("1000, 1001");\n')
        out_fh.write("    }\n")
        out_fh.write("    power_lut_template(%s_energy_template_clkslew) {\n" % name)
        out_fh.write("        variable_1 : input_transition_time;\n")
        out_fh.write('            index_1 ("1000, 1001");\n')
        out_fh.write("    }\n")
        out_fh.write("    power_lut_template(%s_energy_template_sigslew) {\n" % name)
        out_fh.write("        variable_1 : input_transition_time;\n")
        out_fh.write('            index_1 ("1000, 1001");\n')
        out_fh.write("    }\n")

    def write_bus_defs(self, out_fh):
        """Writes the bus type definitions"""

        mem = self.get_memory()
        name = mem.get_name()
        bits = mem.get_width()
        data_bus_msb = mem.get_data_bus_msb()
        addr_width = mem.get_addr_width()
        addr_bus_msb = mem.get_addr_bus_msb()
        self.write_bus_def(out_fh, name + "_DATA", bits, data_bus_msb)
        self.write_bus_def(out_fh, name + "_ADDRESS", addr_width, addr_bus_msb)
        for rw_port_group in mem.get_rw_port_groups():
            for bus_name, bus_data in rw_port_group.get_related_busses().items():
                self.write_bus_def(
                    out_fh,
                    mem.get_name() + "_" + bus_name,
                    bus_data["msb"] - bus_data["lsb"] + 1,
                    bus_data["msb"],
                )
        for bus_name, bus_data in mem.get_misc_busses().items():
            self.write_bus_def(
                out_fh,
                mem.get_name() + "_" + bus_name,
                bus_data["msb"] - bus_data["lsb"] + 1,
                bus_data["msb"],
            )

    def write_bus_def(self, out_fh, bus_name, width, msb):
        out_fh.write(f"    type ({bus_name}) {{\n")
        out_fh.write("        base_type : array ;\n")
        out_fh.write("        data_type : bit ;\n")
        out_fh.write(f"        bit_width : {width};\n")
        out_fh.write(f"        bit_from : {msb};\n")
        out_fh.write("        bit_to : 0 ;\n")
        out_fh.write("        downto : true ;\n")
        out_fh.write("    }\n")

    def write_int_power_table(
        self, out_fh, rise_fall, template_name, slew_indices, dynamic
    ):
        """Writes the internal power table"""

        out_fh.write("            %s_power(%s) {\n" % (rise_fall, template_name))
        out_fh.write('                index_1 ("%s");\n' % slew_indices)
        out_fh.write('                values ("%.3f, %.3f")\n' % (dynamic, dynamic))
        out_fh.write("            }\n")

    def write_internal_power(
        self, out_fh, template_name, slew_indices, dynamic, when=None
    ):
        """Writes the internal power section"""

        out_fh.write("        internal_power(){\n")
        if when:
            out_fh.write('            when : "%s";\n' % when)
        self.write_int_power_table(out_fh, "rise", template_name, slew_indices, dynamic)
        self.write_int_power_table(out_fh, "fall", template_name, slew_indices, dynamic)
        out_fh.write("        }\n")

    def write_clk_pin(self, out_fh, pin_name):
        """Writes the clock pin section"""

        int_power_template = self.get_memory().get_name() + "_energy_template_clkslew"
        timing_data = self.get_memory().get_timing_data()
        out_fh.write(f"    pin({pin_name})   {{\n")
        out_fh.write("        direction : input;\n")
        out_fh.write(
            "        capacitance : %.6f;\n" % (timing_data.min_driver_in_cap * 5)
        )
        # Clk pin is usually higher cap for fanout control, assuming an x5 driver.
        out_fh.write("        clock : true;\n")
        out_fh.write(
            "        min_period           : %.3f ;\n" % (timing_data.cycle_time_ns)
        )
        self.write_internal_power(
            out_fh,
            int_power_template,
            timing_data.slew_indices,
            timing_data.clkpin_dynamic_power,
        )
        out_fh.write("    }\n")
        out_fh.write("\n")

    def write_cell_delay(
        self, out_fh, rise_fall, template_name, slew_indices, load_indices, delay
    ):
        """Writes the cell delay section"""

        out_fh.write("            cell_%s(%s) {\n" % (rise_fall, template_name))
        out_fh.write('                index_1 ("%s");\n' % slew_indices)
        out_fh.write('                index_2 ("%s");\n' % load_indices)
        out_fh.write("                values ( \\\n")
        out_fh.write('                  "%.3f, %.3f", \\\n' % (delay, delay))
        out_fh.write('                  "%.3f, %.3f" \\\n' % (delay, delay))
        out_fh.write("                )\n")
        out_fh.write("            }\n")

    def write_cell_transition(
        self, out_fh, rise_fall, template_name, load_indices, min_slew, max_slew
    ):
        """Writes the cell transition section"""

        out_fh.write("            %s_transition(%s) {\n" % (rise_fall, template_name))
        out_fh.write('                index_1 ("%s");\n' % load_indices)
        out_fh.write('                values ("%.3f, %.3f")\n' % (min_slew, max_slew))
        out_fh.write("            }\n")

    def write_cell_constraint(
        self, out_fh, rise_fall, template_name, slew_indices, val
    ):
        """Writes the cell constraint section"""

        out_fh.write("            %s_constraint(%s) {\n" % (rise_fall, template_name))
        out_fh.write('                index_1 ("%s");\n' % slew_indices)
        out_fh.write('                index_2 ("%s");\n' % slew_indices)
        out_fh.write("                values ( \\\n")
        out_fh.write('                  "%.3f, %.3f", \\\n' % (val, val))
        out_fh.write('                  "%.3f, %.3f" \\\n' % (val, val))
        out_fh.write("                )\n")
        out_fh.write("            }\n")

    def write_output_bus(
        self, out_fh, name, pin_name, clk_pin_name, include_memory_read, addr_bus_name
    ):
        """Writes the output bus definition"""

        delay_template_name = name + "_mem_out_delay_template"
        transition_template_name = name + "_mem_out_slew_template"
        timing_data = self.get_memory().get_timing_data()
        max_load = timing_data.max_load
        slew_indices = timing_data.slew_indices
        load_indices = timing_data.load_indices
        min_slew = timing_data.min_slew
        max_slew = timing_data.max_slew
        tcq = timing_data.access_time_ns

        out_fh.write("    bus(%s)   {\n" % pin_name)
        out_fh.write("        bus_type : %s_DATA;\n" % name)
        out_fh.write("        direction : output;\n")
        out_fh.write("        max_capacitance : %.6f;\n" % max_load)
        # Based on 32x inverter being a common max (or near max) inverter
        if include_memory_read:
            out_fh.write("        memory_read() {\n")
            out_fh.write(f"            address : {addr_bus_name};\n")
            out_fh.write("        }\n")
        out_fh.write("        timing() {\n")
        out_fh.write(f'            related_pin : "{clk_pin_name}" ;\n')
        out_fh.write("            timing_type : rising_edge;\n")
        out_fh.write("            timing_sense : non_unate;\n")
        self.write_cell_delay(
            out_fh, "rise", delay_template_name, slew_indices, load_indices, tcq
        )
        self.write_cell_delay(
            out_fh, "fall", delay_template_name, slew_indices, load_indices, tcq
        )
        self.write_cell_transition(
            out_fh, "rise", transition_template_name, load_indices, min_slew, max_slew
        )
        self.write_cell_transition(
            out_fh, "fall", transition_template_name, load_indices, min_slew, max_slew
        )
        out_fh.write("        }\n")
        out_fh.write("    }\n")

    def write_pin(self, out_fh, name, pin_name, clk_pin_name):
        """Writes the enable pin definition"""

        template_name = name + "_constraint_template"
        timing_data = self.get_memory().get_timing_data()
        min_driver_in_cap = timing_data.min_driver_in_cap
        slew_indices = timing_data.slew_indices
        tsetup = timing_data.t_setup_ns
        thold = timing_data.t_hold_ns
        pindynamic = timing_data.pin_dynamic
        out_fh.write("    pin(%s){\n" % pin_name)
        out_fh.write("        direction : input;\n")
        out_fh.write("        capacitance : %.6f;\n" % (min_driver_in_cap))
        self.write_timing(out_fh, name, clk_pin_name, slew_indices, tsetup, thold)
        self.write_internal_power(
            out_fh, name + "_energy_template_sigslew", slew_indices, pindynamic
        )
        out_fh.write("    }\n")

    def write_timing(self, out_fh, name, clk_pin_name, slew_indices, tsetup, thold):
        """Writes the pin/bus timing section"""

        template_name = name + "_constraint_template"
        out_fh.write("        timing() {\n")
        out_fh.write(f"            related_pin : {clk_pin_name};\n")
        out_fh.write("            timing_type : setup_rising ;\n")
        self.write_cell_constraint(out_fh, "rise", template_name, slew_indices, tsetup)
        self.write_cell_constraint(out_fh, "fall", template_name, slew_indices, tsetup)
        out_fh.write("        }\n")
        out_fh.write("        timing() {\n")
        out_fh.write(f"            related_pin : {clk_pin_name};\n")
        out_fh.write("            timing_type : hold_rising ;\n")
        self.write_cell_constraint(out_fh, "rise", template_name, slew_indices, thold)
        self.write_cell_constraint(out_fh, "fall", template_name, slew_indices, thold)
        out_fh.write("        }\n")

    def write_address_bus(self, out_fh, name, bus_name, clk_pin_name):
        """Writes the address bus"""

        timing_data = self.get_memory().get_timing_data()
        min_driver_in_cap = timing_data.min_driver_in_cap
        slew_indices = timing_data.slew_indices
        tsetup = timing_data.t_setup_ns
        thold = timing_data.t_hold_ns
        pindynamic = timing_data.pin_dynamic
        out_fh.write("    bus(%s)   {\n" % bus_name)
        out_fh.write("        bus_type : %s_ADDRESS;\n" % name)
        out_fh.write("        direction : input;\n")
        out_fh.write("        capacitance : %.6f;\n" % (min_driver_in_cap))
        self.write_timing(out_fh, name, clk_pin_name, slew_indices, tsetup, thold)
        self.write_internal_power(
            out_fh, name + "_energy_template_sigslew", slew_indices, pindynamic
        )
        out_fh.write("    }\n")

    def write_data_bus(
        self,
        out_fh,
        name,
        bus_name,
        we_pin_name,
        clk_pin_name,
        include_memory_write,
        addr_bus_name,
    ):
        """Writes the data bus"""

        timing_data = self.get_memory().get_timing_data()
        min_driver_in_cap = timing_data.min_driver_in_cap
        slew_indices = timing_data.slew_indices
        tsetup = timing_data.t_setup_ns
        thold = timing_data.t_hold_ns
        pindynamic = timing_data.pin_dynamic
        out_fh.write("    bus(%s)   {\n" % bus_name)
        out_fh.write("        bus_type : %s_DATA;\n" % name)
        if include_memory_write:
            out_fh.write("        memory_write() {\n")
            out_fh.write(f"            address : {addr_bus_name};\n")
            out_fh.write(f'            clocked_on : "{clk_pin_name}";\n')
            out_fh.write("        }\n")
        out_fh.write("        direction : input;\n")
        out_fh.write("        capacitance : %.6f;\n" % (min_driver_in_cap))
        self.write_timing(out_fh, name, clk_pin_name, slew_indices, tsetup, thold)
        self.write_internal_power(
            out_fh,
            name + "_energy_template_sigslew",
            slew_indices,
            pindynamic,
            f"(! ({we_pin_name}) )",
        )
        self.write_internal_power(
            out_fh,
            name + "_energy_template_sigslew",
            slew_indices,
            pindynamic,
            f"({we_pin_name})",
        )
        out_fh.write("    }\n")

    def write_generic_bus(self, out_fh, name, bus_name, clk_pin_name):
        """Writes the generic bus"""

        timing_data = self.get_memory().get_timing_data()
        min_driver_in_cap = timing_data.min_driver_in_cap
        slew_indices = timing_data.slew_indices
        tsetup = timing_data.t_setup_ns
        thold = timing_data.t_hold_ns
        pindynamic = timing_data.pin_dynamic
        out_fh.write("    bus(%s)   {\n" % bus_name)
        out_fh.write(f"        bus_type : {name}_{bus_name};\n")
        out_fh.write("        direction : input;\n")
        out_fh.write("        capacitance : %.6f;\n" % (min_driver_in_cap))
        self.write_timing(out_fh, name, clk_pin_name, slew_indices, tsetup, thold)
        self.write_internal_power(
            out_fh, name + "_energy_template_sigslew", slew_indices, pindynamic
        )
        out_fh.write("    }\n")

    def write_rw_pin_set(self, out_fh, name, rw_port_group, is_ram):
        """Writes the rw port group to the output stream"""

        clk_pin_name = rw_port_group.get_clock_name()
        addr_bus_name = rw_port_group.get_address_bus_name()
        if rw_port_group.get_write_enable_name():
            self.write_pin(
                out_fh, name, rw_port_group.get_write_enable_name(), clk_pin_name
            )
        if addr_bus_name:
            self.write_address_bus(out_fh, name, addr_bus_name, clk_pin_name)
        if (
            rw_port_group.get_data_input_bus_name()
            and rw_port_group.get_write_enable_name()
        ):
            self.write_data_bus(
                out_fh,
                name,
                rw_port_group.get_data_input_bus_name(),
                rw_port_group.get_write_enable_name(),
                clk_pin_name,
                is_ram,
                addr_bus_name,
            )
        if rw_port_group.get_data_output_bus_name():
            self.write_output_bus(
                out_fh,
                name,
                rw_port_group.get_data_output_bus_name(),
                clk_pin_name,
                is_ram,
                addr_bus_name,
            )
        for related_pin in rw_port_group.get_related_pins():
            self.write_pin(out_fh, name, related_pin, clk_pin_name)
        for bus_name, bus_data in rw_port_group.get_related_busses().items():
            self.write_generic_bus(out_fh, name, bus_name, clk_pin_name)
        self.write_clk_pin(out_fh, clk_pin_name)
