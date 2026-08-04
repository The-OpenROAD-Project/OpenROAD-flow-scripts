################################################################################
# PROCESS CLASS
#
# This class stores the infromation about the process that the memory is being
# generated in. Every memory has a pointer to a process object. The information
# for the process comes from the json configuration file (typically before the
# "sram" list section).
################################################################################


class Process:
    def __init__(self, json_data):
        """Initialize from json_data imported from config file"""

        # From JSON configuration file
        self.tech_nm = int(json_data["tech_nm"])
        self.voltage = float(json_data["voltage"])
        self.metal_prefix = str(json_data["metal_prefix"])
        self.metal_layer = str(json_data["metal_layer"])
        self.pin_width_nm = int(json_data["pin_width_nm"])
        self.pin_pitch_nm = int(json_data["pin_pitch_nm"])
        self.metal_track_pitch_nm = int(json_data["metal_track_pitch_nm"])
        self.contacted_poly_pitch_nm = json_data.get("contacted_poly_pitch_nm", None)
        self.fin_pitch_nm = json_data.get("fin_pitch_nm", None)
        self.manufacturing_grid_nm = int(json_data["manufacturing_grid_nm"])
        self.column_mux_factor = int(json_data["column_mux_factor"])

        # Optional keys
        self.snap_width_nm = (
            int(json_data["snap_width_nm"]) if "snap_width_nm" in json_data else 1
        )
        self.snap_height_nm = (
            int(json_data["snap_height_nm"]) if "snap_height_nm" in json_data else 1
        )

        # Converted values
        self.tech_um = self.tech_nm / 1000.0
        self.pin_width_um = self.pin_width_nm / 1000.0
        self.pin_pitch_um = self.pin_pitch_nm / 1000.0
        self.metal_track_pitch_um = self.metal_track_pitch_nm / 1000.0
        self.manufacturing_grid_um = self.manufacturing_grid_nm / 1000.0

        if self.pin_pitch_nm % self.metal_track_pitch_nm != 0:
            raise Exception(
                "Pin Pitch %d not a multiple of Metal Track Pitch %d"
                % (self.pin_pitch_nm, self.metal_track_pitch_nm)
            )
        if self.pin_pitch_nm % self.manufacturing_grid_nm != 0:
            raise Exception(
                "Pin Pitch %d not a multiple of Manufacturing Grid %d"
                % (self.pin_pitch_nm, self.manufacturing_grid_nm)
            )

        # Offset from bottom edge to first pin
        self.x_offset = 1 * self.pin_pitch_um
        # as told by MSK
        self.y_offset = 1 * self.pin_pitch_um
        # as told by MSK

        self._calc_y_step()
        self.bitcell_width_um = json_data.get("bitcell_width_um", None)
        self.bitcell_height_um = json_data.get("bitcell_height_um", None)

        # Set to True when we want to use the process parameters or bitcell
        # sizes to calculate the macro dimensions. Set to False for spreadsheet
        # mode
        self._calc_dimensions = True

    def _calc_y_step(self):
        """
        Calculates y_step, which is really the y location for the center of
        the first pin
        """

        offset_snap = round(self.y_offset % self.manufacturing_grid_um, 2)
        if offset_snap < self.manufacturing_grid_um:
            offset_snap = 0
        self.y_step = self.y_offset - offset_snap + (self.pin_width_um / 2.0)

    def has_defined_bitcell_size(self):
        return self.bitcell_width_um and self.bitcell_height_um

    def get_bitcell_dimensions(self):
        if self.has_defined_bitcell_size():
            bitcell_width = self.bitcell_width_um
            bitcell_height = self.bitcell_height_um
        else:
            contacted_poly_pitch_um = self.contacted_poly_pitch_nm / 1000
            fin_pitch_um = self.fin_pitch_nm / 1000

            # Corresponds to the recommended 122 cell in asap7
            bitcell_height = 10 * fin_pitch_um
            bitcell_width = 2 * contacted_poly_pitch_um
        return (bitcell_width, bitcell_height)

    def get_macro_dimensions(self, width_in_bits, depth, num_banks, additional_height):
        """
        Returns the computed macro height & width based on the width/depth/banks
        and process parameters
        """

        column_mux_factor = self.column_mux_factor
        (bitcell_width, bitcell_height) = self.get_bitcell_dimensions()

        all_bitcell_height = bitcell_height * depth
        all_bitcell_width = bitcell_width * width_in_bits

        if num_banks == 2 or num_banks == 4:
            all_bitcell_height = all_bitcell_height / num_banks
            all_bitcell_width = all_bitcell_width * num_banks
        elif num_banks != 1:
            raise Exception("Unsupported number of banks: {}".format(num_banks))

        all_bitcell_height = all_bitcell_height / column_mux_factor
        all_bitcell_width = all_bitcell_width * column_mux_factor

        total_height = all_bitcell_height * 1.2
        total_width = all_bitcell_width * 1.2

        total_height += additional_height

        return (total_width, total_height)

    def get_tech_nm(self):
        """Returns the process technology size in nm"""
        return self.tech_nm

    def get_tech_um(self):
        """Returns the process technology size in um"""
        return self.tech_um

    def get_voltage(self):
        """Returns the voltage in V"""
        return self.voltage

    def get_metal_prefix(self):
        """Returns the metal layer prefix string"""
        return self.metal_prefix

    def get_metal_layer(self):
        """Returns the metal layer string"""
        return self.metal_layer

    def get_pin_width_nm(self):
        """Returns the pin width in nm"""
        return self.pin_width_nm

    def get_pin_width_um(self):
        """Returns the pin width in um"""
        return self.pin_width_um

    def get_pin_pitch_nm(self):
        """Returns the pin pitch in nm"""
        return self.pin_pitch_nm

    def get_pin_pitch_um(self):
        """Returns the pin pitch in um"""
        return self.pin_pitch_um

    def get_snap_width_nm(self):
        """Returns the snap width in nm"""
        return self.snap_width_nm

    def get_snap_height_nm(self):
        """Returns the snap height in nm"""
        return self.snap_height_nm

    def get_metal_track_pitch_nm(self):
        """Returns the metal track pitch in nm"""
        return self.metal_track_pitch_nm

    def get_metal_track_pitch_um(self):
        """Returns the metal track pitch in um"""
        return self.metal_track_pitch_um

    def get_manufacturing_grid_nm(self):
        """Returns the manufacturing grid in nm"""
        return self.manufacturing_grid_nm

    def get_manufacturing_grid_um(self):
        """Returns the manufacturing grid in um"""
        return self.manufacturing_grid_um

    def get_contacted_poly_pitch(self):
        """Returns the poly pitch in nm"""
        return self.contacted_poly_pitch_nm

    def get_fin_pitch(self):
        """Returns the fin pitch in nm"""
        return self.fin_pitch_nm

    def get_x_offset(self):
        """Returns the x offset in um"""
        return self.x_offset

    def get_y_offset(self):
        """Returns the y offset in um"""
        return self.y_offset

    def get_y_step(self):
        """Returns the y step in um"""
        return self.y_step

    def get_column_mux_factor(self):
        """Returns the column mux factor"""
        return self.column_mux_factor

    def set_calc_dimensions(self, val):
        """
        Sets a predicate to indicate if we should calculate the dimensions
        """
        self._calc_dimensions = val

    def calc_dimensions(self):
        """
        Returns a predicate to indicate if we should calculate the dimensions
        """
        return self._calc_dimensions
