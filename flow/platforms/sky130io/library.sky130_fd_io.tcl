Footprint library {
  types {
    sig top_gpiov2_pad
    vccd_hvc vccd_hvc_power_pad
    vccd_lvc vccd_lvc_power_pad
    vssd_hvc vssd_hvc_ground_pad
    vssd_lvc vssd_lvc_ground_pad
    vdda_hvc vdda_hvc_power_pad
    vdda_lvc vdda_lvc_power_pad
    vssa_hvc vssa_hvc_ground_pad
    vssa_lvc vssa_lvc_ground_pad
    vddio_hvc vddio_hvc_power_pad 
    vddio_lvc vddio_lvc_power_pad 
    vssio_hvc vssio_hvc_ground_pad
    vssio_lvc vssio_lvc_ground_pad
    corner sky130_ef_io__corner_pad
    fill {sky130_ef_io__com_bus_slice_20um sky130_ef_io__com_bus_slice_10um sky130_ef_io__com_bus_slice_5um sky130_ef_io__com_bus_slice_1um}
  }

  connect_by_abutment {
    AMUXBUS_A
    AMUXBUS_B
    VSSA
    VDDA
    VSWITCH
    VDDIO_Q
    VSSIO_Q
    VCCHIB
    VDDIO
    VCCD
    VSSIO
    VSSD
  }

  pad_pin_name PAD
  pad_pin_layer met5

  cells {
    top_gpiov2_pad {
      cell_name sky130_ef_io__gpiov2_pad_wrapped
      orient {bottom R180 right R270 top R0 left R90}
      flip_pair 1
    }
    vccd_hvc_power_pad {
      cell_name sky130_ef_io__vccd_hvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vccd_lvc_power_pad {
      cell_name sky130_ef_io__vccd_lvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vssd_hvc_ground_pad {
      cell_name sky130_ef_io__vssd_hvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vssd_lvc_ground_pad {
      cell_name sky130_ef_io__vssd_lvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vdda_hvc_power_pad {
      cell_name sky130_ef_io__vdda_hvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vdda_lvc_power_pad {
      cell_name sky130_ef_io__vdda_lvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vssa_hvc_ground_pad {
      cell_name sky130_ef_io__vssa_hvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vssa_lvc_ground_pad {
      cell_name sky130_ef_io__vssa_lvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vddio_hvc_power_pad {
      cell_name sky130_ef_io__vddio_hvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vddio_lvc_power_pad {
      cell_name sky130_ef_io__vddio_lvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vssio_hvc_ground_pad {
      cell_name sky130_ef_io__vssio_hvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    vssio_lvc_ground_pad {
      cell_name sky130_ef_io__vssio_lvc_pad
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
    }
    sky130_ef_io__corner_pad {
      physical_only 1
      offset {200.0 204}
      orient {ll R180 lr MX ur R0 ul MY}
    }
    sky130_ef_io__com_bus_slice_1um {
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
      offset {1.0 197.965}
    }
    sky130_ef_io__com_bus_slice_5um {
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
      offset {5.0 197.965}
    }
    sky130_ef_io__com_bus_slice_10um {
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
      offset {10.0 197.965}
    }
    sky130_ef_io__com_bus_slice_20um  {
      physical_only 1
      orient {bottom R180 right R270 top R0 left R90}
      offset {20.0 197.965}
    }
  }
}

