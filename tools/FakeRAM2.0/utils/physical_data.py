#!/usr/bin/env python3

import math


class PhysicalData:
    """Physical data container"""

    def __init__(self):
        """Initializer"""

        self._width_um = None
        self._height_um = None
        self._snapped_width_um = None
        self._snapped_height_um = None
        self._pin_pitch = None
        self._group_pitch = None

    def set_extents(self, width, height):
        """Sets the extents of the memory (e.g. width and height)"""

        self._width_um = width
        self._height_um = height

    def get_width(self, snapped=True):
        """
        Returns the width of the memory in um.

        If snapped and the width has been snapped, the snapped width is
        returned. Otherwise, the unsnapped width is returned
        """

        if snapped and self._snapped_width_um:
            return self._snapped_width_um
        return self._width_um

    def get_height(self, snapped=True):
        """
        Returns the height of the memory in um.

        If snapped and the height has been snapped, the snapped height is
        returned. Otherwise, the unsnapped height is returned
        """

        if snapped and self._snapped_height_um:
            return self._snapped_height_um
        return self._height_um

    def get_area(self, snapped=True):
        """
        Returns the area of the memory in um^2.

        If snapped and the area has been snapped, the snapped area is
        returned. Otherwise, the unsnapped area is returned
        """

        if snapped and self._snapped_width_um and self._snapped_height_um:
            return self._snapped_width_um * self._snapped_height_um
        return self._width_um * self._height_um

    def snap_side_to_grid(self, side_um, snap_nm):
        """Snaps the length to the grid"""

        return (math.ceil((side_um * 1000.0) / snap_nm) * snap_nm) / 1000.0

    def snap_to_grid(self, snap_width_nm, snap_height_nm):
        """Snaps the width and height to the grid"""

        if not self._width_um and not self._height_um:
            raise Exception("Error: width and height must be defined before snapping")
        # Adjust to snap
        self._snapped_width_um = self.snap_side_to_grid(self._width_um, snap_width_nm)
        self._snapped_height_um = self.snap_side_to_grid(
            self._height_um, snap_height_nm
        )

    def get_pin_pitch(self):
        """Returns the pin pitch in um"""

        return self._pin_pitch

    def get_group_pitch(self):
        """Returns the group pitch (spacing between pin groups) in um"""

        return self._group_pitch

    def set_pin_pitches(self, name, num_pins, min_pin_pitch, y_offset):
        """Calculate the pin spacing (pitch)"""

        h = self.get_height()  # snapped height
        if not h:
            raise Exception(
                f"Error: attempting to set pin pitches before height ({name})"
            )
        number_of_tracks_available = math.floor((h - 2 * y_offset) / min_pin_pitch)
        number_of_spare_tracks = number_of_tracks_available - num_pins

        if number_of_spare_tracks < 0:
            raise Exception(
                "Error: not enough tracks for %s (num pins: %d, available tracks: %d)."
                % (name, num_pins, number_of_tracks_available)
            )

        ## The next few lines of code till "pin_pitch = min.." spreads the pins
        ## in higher multiples of pin pitch if there are available tracks
        track_count = 1
        if number_of_spare_tracks > 0:
            while number_of_spare_tracks > 0:
                track_count += 1
                number_of_spare_tracks = (
                    number_of_tracks_available - num_pins * track_count
                )
            track_count -= 1

        self._pin_pitch = min_pin_pitch * track_count
        # Divide by the remaining 'spare' tracks into the inter-group spaces
        #  [4 groups -> 3 spaces]
        extra = math.floor((number_of_tracks_available - num_pins * track_count) / 3)
        self._group_pitch = extra * min_pin_pitch
