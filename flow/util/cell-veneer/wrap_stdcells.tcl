namespace eval wrapper {
  variable wrapper_cfg
  
  proc set_message {level message} {
    return "\[$level\] $message"
  }

  proc debug {message} {
    set state [info frame -1]
    set str ""
    if {[dict exists $state file]} {
      set str "$str[dict get $state file]:"
    }
    if {[dict exists $state proc]} {
      set str "$str[dict get $state proc]:"
    }
    if {[dict exists $state line]} {
      set str "$str[dict get $state line]"
    }
    puts [set_message DEBUG "$str: $message"]
  }

  proc information {id message} {
    puts [set_message INFO [format "\[WRAP-%04d\] %s" $id $message]]
  }

  proc warning {id message} {
    puts [set_message WARN [format "\[WRAP-%04d\] %s" $id $message]]
  }

  proc err {id message} {
    puts [set_message ERROR [format "\[WRAP-%04d\] %s" $id $message]]
  }

  proc critical {id message} {
    error [set_message CRIT [format "\[WRAP-%04d\] %s" $id $message]]
  }

  proc find_cells_with_m2_pins {} {
    set cells [lef get_cells]
    set data {}

    dict for {cell_name cell} $cells {
      dict for {pin_name pin} [dict get $cell pins] {
        foreach port [dict get $pin ports] {
          set offset [wrapper::get_port_offset $port]
          set layer_name "M2"
          if {[dict exists $port layers $layer_name]} {
            foreach shape [dict get $port layers $layer_name shapes] {

              set rect [absolute_rectangle [dict get $shape rect] $offset]
              set x1 [lindex $rect 0]
              set y1 [lindex $rect 1]
              set x2 [lindex $rect 2]
              set y2 [lindex $rect 3]

              if {[dict exists $data $cell_name pins $pin_name]} {
                set pins [dict get $data $cell_name pins $pin_name]
              } else {
                set pins {}
              }
              if {round($y2 - $y1) > 64} {
                error "cell $cell_name, pin: $pin_name, [expr $y2 - $y1] -> vertical M2 pin: $y2, $y1"
              }
              lappend pins [list track [expr round(($y2 + $y1) / 2 / 128)] from $x1 to $x2]
              dict set data $cell_name pins $pin_name $pins
            }
          }
        }
      }

      if {[dict exists $data $cell_name]} {
        dict for {layer_name obstructions} [dict get $cell obstructions] {
          if {$layer_name == "M2"} {
            foreach obs $obstructions {
              set rect [dict get $obs rect]
              set x1 [lindex $rect 0]
              set y1 [lindex $rect 1]
              set x2 [lindex $rect 2]
              set y2 [lindex $rect 3]

              if {round(($y2 - $y1)) > 64} {
                error "cell $cell_name, blockage, [expr $y2 - $y1] -> vertical blockage: $y2, $y1"
              }
              if {[dict exists $data $cell_name blockages]} {
                set blockages [dict get $data $cell_name blockages]
              } else {
                set blockages {}
              }

              lappend blockages [list track [expr round(($y2 + $y1) / 2 / 128)] from $x1 to $x2]
              dict set data $cell_name blockages $blockages
            }
          }
        }
      }
    }

    return $data
  }

  proc clear_left {physical_pin blockages} {
    set track [dict get $physical_pin track] 

    foreach blockage $blockages {
      if {[dict get $blockage track] == $track && [dict get $blockage to] < [dict get $physical_pin from]} {
        return 0
      }
    }
    return 1
  }

  proc clear_right {physical_pin blockages} {
    set track [dict get $physical_pin track] 

    foreach blockage $blockages {
      if {[dict get $blockage track] == $track && [dict get $blockage from] > [dict get $physical_pin to]} {
        return 0
      }
    }
    return 1
  }

  proc create_def_wrapper {cell_name new_cell_name} {
    variable tech    
    set orig_cell [lef get_cell $cell_name]
    
    set design $orig_cell
    
    dict set design name $new_cell_name
    dict set design tool "cell-veneer"
    dict set design units 2000
    dict set design use_sheet_obstructions 0
    if {[dict exists $tech use_sheet_obstructions]} {
      dict set design use_sheet_obstructions [dict get $tech use_sheet_obstructions]
    }
    if {[dict exists $tech blockage_layers]} {
      dict set design blockage_layers [dict get $tech blockage_layers]
    }
    dict set design die_area [dict get $orig_cell die_area]

    dict set design components u0 cell_name $cell_name
    dict set design components u0 placed "0 0"
    dict set design components u0 orientation "N"
    
    dict for {pin_name pin} [dict get $orig_cell pins] {
      
      dict set design pins $pin_name net_name $pin_name 
      if {[dict exists $pin use]} {
        if {[dict get $pin use] == "POWER" || [dict get $pin use] == "GROUND"} {
          dict set design special_nets $pin_name connections [list "PIN $pin_name" "* $pin_name"]
          dict set design special_nets $pin_name use [dict get $pin use]
        } else {
          dict set design nets $pin_name connections [list "PIN $pin_name" "u0 $pin_name"]
          dict set design nets $pin_name use [dict get $pin use]
        }
      } else {
        dict set design nets $pin_name connections [list "PIN $pin_name" "u0 $pin_name"]
      }
    }

    return $design
  }
  
  proc get_port_offset {port} {
    if {[dict exists $port fixed]} {
      return [dict get $port fixed]
    } elseif {[dict exists $port placed]} {
      return [dict get $port fixed]
    }

    return [list 0 0]
  }

  proc move_m2_pins_to_edge {cell_name cell_data} {
    variable wrapper_cfg
    
    set wrapper_cell [lef get_cell [dict get $wrapper_cfg padding_cell]]
    set padding_cell_width [lindex [dict get $wrapper_cell die_area] 2]
    set def_units [dict get $wrapper_cfg def_units]
    set layer_name [dict get $wrapper_cfg remove_pins layer]
    set layer_width [expr round([dict get $wrapper_cfg layer $layer_name width] * $def_units)]
    set new_pin_layer_name [dict get $wrapper_cfg new_pins layer]
    set new_pin_layer_width [expr round([dict get $wrapper_cfg layer $new_pin_layer_name width] * $def_units)]
    set cell_width [lindex [dict get [lef get_cell $cell_name] die_area] 2]
    set design [wrapper::create_def_wrapper $cell_name ${cell_name}_mod]
    set lower_y [expr 2 * 128]
    set upper_y [expr 8 * 128]
    set via_overlap [expr round([dict get $wrapper_cfg via_overlap] * $def_units)]
    
    set right_padding 0
    set left_padding 0

    # Determine which sides to route the M2 pins to and create a wire
    dict for {pin_name pin} [dict get $cell_data pins] {
      set wires {}
      foreach physical_pin $pin {
        if {[dict get $physical_pin to] >= [expr $cell_width / 2.0]} {
          if {[dict exists $cell_data blockages]} {
            if {[wrapper::clear_right $physical_pin [dict get $cell_data blockages]]} {
              set direction right
            } elseif {[wrapper::clear_left $physical_pin [dict get $cell_data blockages]]} {
              set direction left
            } else {
              set direction blocked
            }
          } else {
            set direction right
          }
        } else {
          if {[dict exists $cell_data blockages]} {
            if {[wrapper::clear_left $physical_pin [dict get $cell_data blockages]]} {
              set direction left
            } elseif {[wrapper::clear_right $physical_pin [dict get $cell_data blockages]]} {
              set direction right
            } else {
              set direction blocked
            }
          } else {
            set direction left
          }
        }

        if {$direction == "blocked"} {
          break
        }

        set y [expr [dict get $physical_pin track] * 128]
        if {$direction == "right"} {
          set x1 [dict get $physical_pin to]
          set x2 [expr $cell_width + ($padding_cell_width * ($right_padding + 1))]
          set x3 [expr $cell_width + ($padding_cell_width * ($right_padding + 1)) + $via_overlap]
          incr right_padding
        } elseif {$direction == "left"} {
          set x1 [dict get $physical_pin from]
          set x2 [expr 0 - ($padding_cell_width * ($left_padding + 1))]
          set x3 [expr 0 - ($padding_cell_width * ($left_padding + 1)) - $via_overlap]
          incr left_padding
        }

        # Route M2 out to the side of the block
        lappend wires [list \
          layer $layer_name \
          points [list [list $x1 $y] [list $x3 $y] [dict get $wrapper_cfg via]] 
        ]
        set new_wire [list \
          layer "M1" \
          points [list [list $x2 $lower_y] [list $x2 $upper_y]] \
        ]
        if {[dict exists $wrapper_cfg new_pins mask]} {
          dict set new_wire mask [dict get $wrapper_cfg new_pins mask]
        }
        lappend wires $new_wire
        # Add the new M2 wire as an obstruction when writing the LEF of the cell
        if {[dict exists $design obstructions $layer_name]} {
          set obstructions [dict get $design obstructions $layer_name]
        } else {
          set obstructions {}
        }
        lappend obstructions [list \
          rect [list \
            [expr min($x1, $x3)] [expr $y - round($layer_width / 2)] \
            [expr max($x1, $x3)] [expr $y + round($layer_width / 2)] \
          ]
        ]
        dict set design obstructions $layer_name $obstructions

        break
      }

      if {$direction == "blocked"} {
        break
      }

      set ports {}
      foreach port [dict get $design pins $pin_name ports] {
        if {[dict exists $port layers "M2"]} {
          set offset [get_port_offset $port]
          # Copy all M2 pins on instance to M2 obstructions
          foreach shape [dict get $port layers "M2" shapes] {
            set pin_rect [absolute_rectangle [dict get $shape rect] $offset]

            set m2_obstructions [dict get $design obstructions M2]
            lappend m2_obstructions [list \
              rect $pin_rect \
            ]
            dict set design obstructions M2 $m2_obstructions
          }
          # Replace the M2 port with an M1 port which is now at the side of the cells
          set new_pin_rect [list [expr round($x2 - ($new_pin_layer_width / 2))] $lower_y [expr round($x2 + ($new_pin_layer_width / 2))] $upper_y]
          if {[dict exists $port layers "M1" shapes]} {
            set shapes [dict get $port layers "M1" shapes]
          } else {
            set shapes {}
          }
          set new_shape [list \
            rect  [relative_rectangle $new_pin_rect $offset] \
          ]
          if {[dict exists $wrapper_cfg new_pins mask]} {
            dict set new_shape mask [dict get $wrapper_cfg new_pins mask]
          }
          lappend shapes $new_shape
          dict set port layers M1 shapes $shapes
        }
        dict set port layers [dict remove [dict get $port layers] "M2"]
        lappend ports $port
      }
      dict set design pins $pin_name ports $ports
      dict set design nets $pin_name routes $wires
    }

    # Adjust the placement of the component if we have padding on the left
    if {$left_padding > 0} {
      dict set design components u0 placed [list [expr $padding_cell_width * ($left_padding + 1)] 0]
    }

    # Add in the cell padding
    set pad_idx 0
    if {$left_padding > 0} {
      for {set i 0} {$i <= $left_padding} {incr i} {
        set x [expr $padding_cell_width * ($i + 1) * -1]
        set y 0
        dict set design components p$pad_idx inst_name p$pad_idx
        dict set design components p$pad_idx cell_name [dict get $wrapper_cfg padding_cell]
        dict set design components p$pad_idx placed [list $x $y]
        dict set design components p$pad_idx orientation N

        # Add all obstructions of padding cell to obstructions of wrapper
        dict for {layer_name obstructions} [dict get $wrapper_cell obstructions] {
          if {[dict exists $design obstructions $layer_name]} {
            set current_obstructions [dict get $design obstructions $layer_name]
          } else {
            set current_obstructions {}
          }
          foreach obs $obstructions {
            dict set obs rect [def shift_rect [dict get $obs rect] $x $y]
            lappend current_obstructions $obs
          }
          dict set design obstructions $layer_name $current_obstructions
        }
        incr pad_idx
      }
    } else {
      set left_padding -1
    }
    if {$right_padding > 0} {
      for {set i 0} {$i <= $right_padding} {incr i} {
        set x [expr $padding_cell_width * $i + $cell_width]
        set y 0
        dict set design components p$pad_idx inst_name p$pad_idx
        dict set design components p$pad_idx cell_name [dict get $wrapper_cfg padding_cell]
        dict set design components p$pad_idx placed [list $x $y]
        dict set design components p$pad_idx orientation N

        # Add all obstructions of padding cell to obstructions of wrapper
        dict for {layer_name obstructions} [dict get $wrapper_cell obstructions] {
          if {[dict exists $design obstructions $layer_name]} {
            set current_obstructions [dict get $design obstructions $layer_name]
          } else {
            set current_obstructions {}
          }
          foreach obs $obstructions {
            dict set obs rect [def shift_rect [dict get $obs rect] $x $y]
            lappend current_obstructions $obs
          }
          dict set design obstructions $layer_name $current_obstructions
        }
        incr pad_idx
      }
    }

    # Adjust origin so that 0,0 is the lowr left corner of the cell
    set adjustment [expr $padding_cell_width * ($left_padding + 1)]
    set design [def shift_origin $design $adjustment 0]

    dict set design die_area [list \
      0 \
      0 \
      [expr [lindex [dict get $design die_area] 2] + (($pad_idx - ($left_padding + 1)) * $padding_cell_width)] \
      [lindex [dict get $design die_area] 3] \
    ]
    
    # Extend VDD, VSS, VPW, VNW pins to be the width of the wrapper
    #   VDD overlaps by 0.009 on each side
    #   VSS overlaps by 0.009 on each side
    #   VNW overlaps the edges of the cell by 0.1 on both sides
    set extend_ports {
      VDD {layer M1 overlap 0.009}
      VSS {layer M1 overlap 0.009}
      VNW {layer NW overlap 0.1}
      VPW {layer SXCUT overlap 0}
    }
    dict for {pin_name info} $extend_ports {
      set layer [dict get $info layer]
      set overlap [dict get $info overlap]

      set ports {}
      foreach port [dict get $design pins $pin_name ports] {
        if {[dict exists $port layers $layer]} {
          set shapes {}
          set offset [get_port_offset $port]

          foreach shape [dict get $port layers $layer shapes] {
            set rect [absolute_rectangle [dict get $shape rect] $offset]
            dict set shape rect [relative_rectangle \
              [list \
                [expr [lindex [dict get $design die_area] 0] - [expr round($overlap * $def_units)]] \
                [lindex $rect 1] \
                [expr [lindex [dict get $design die_area] 2] + [expr round($overlap * $def_units)]] \
                [lindex $rect 3] \
              ] \
              $offset \
            ]
            lappend shapes $shape
          }
          dict set port layers $layer shapes $shapes
        }
        lappend ports $port
      }
      dict set design pins $pin_name ports $ports
    }

    return $design
  }

  proc build_wrappers {data} {
    variable wrapper_cfg
    
    set designs {}

    dict for {cell_name cell_data} $data {
      set data [move_m2_pins_to_edge $cell_name $cell_data $wrapper_cfg]
      dict set designs [dict get $data name] $data 
    }

    return $designs
  }

  proc get_pin_rect {port layer} {
    if {[dict exists $port fixed]} {
      set offset [dict get $port fixed]
    } elseif {[dict exists $port placed]} {
      set offset [dict get $port placed]
    } else {
      set offset [list 0 0]
    }
    
    return [absolute_rectangle [dict get [lindex [dict get $port layers $layer shapes] 0] rect] $offset]
  }
  
  proc wrap_macro {cell_name} {
    variable tech
    set wrapper [wrapper::create_def_wrapper $cell_name ${cell_name}_mod]
    debug "$tech"
    debug "[dict get $wrapper use_sheet_obstructions]"

    set cell [lef get_cell $cell_name]
    # debug "$cell_name"
    
    # Order the signal pins based on the y location of the pin
    set pin_info {}
    set net_info {}
    set grid_pins {}

    dict for {pin_name pin} [dict get $cell pins] {
      if {[dict get $pin use] != "SIGNAL"} {continue}

      # CHEAT: Assume that there is only one port for each pin and one rectangle per layer
      set port [lindex [dict get $pin ports] 0]
      if {[dict exists $port layers C4]} {
        set pin_rect [get_pin_rect $port C4]
        dict set net_info $pin_name pin_layer "C4"
      } elseif {[dict exists $port layers M3]} {
        set pin_rect [get_pin_rect $port M3]
        dict set net_info $pin_name pin_layer "M3"
      }

      set macro_pin_y [expr ([lindex $pin_rect 1] + [lindex $pin_rect 3]) / 2]
      set grid_y [expr round((floor(([lindex $pin_rect 1] + [lindex $pin_rect 3]) / 2 / [dict get $tech pitch horizontal_track]) - 1))]

      # Need to check that the grid point we're trying to use is going to be accessible.
      # If it is not, then try the point 2 grid points higher
      if {[dict exists $grid_pins $grid_y]} {
        if {[dict exists [expr $grid_y + 2]]} {
          puts "Cell $cell_name"
          puts "Problem assigning pin grid - requested and upper grid points for $pin_name at $grid_y already allocated to [dict get $grid_pins $grid_y] and [dict get $grid_pins [expr $grid_y + 2]]"
          exit -1
        }
        set grid_y [expr $grid_y + 2]
      }
      dict set grid_pins $grid_y $pin_name

      dict set net_info $pin_name grid_y $grid_y
      dict set net_info $pin_name macro_pin_y $macro_pin_y
    }

    set order [lsort -integer [dict keys $grid_pins]]
    set prev_pos [lindex $order 0]

    # We will have a jog in the track, which needs to be on a vertical grid 3 units from the edge of the macro
    # If there is another pin close by, the we will need to have the jog 3 grids further in
    dict set net_info [dict get $grid_pins $prev_pos] h_offset 3
    foreach pin_pos [lrange $order 1 end] {
      if {$pin_pos - $prev_pos > 3} {
         dict set net_info [dict get $grid_pins $pin_pos] h_offset 3
      } else {
         dict set net_info [dict get $grid_pins $pin_pos] h_offset [expr [dict get $net_info [dict get $grid_pins $prev_pos] h_offset] + 3]
      }
      set prev_pos $pin_pos
    }

    # Work out where to place the instance based on the size of amount of jogging space needed
    set wrapper_depth 0
    dict for {net_name net} [dict get $net_info] {
      if {$wrapper_depth < [dict get $net h_offset]} {
        set wrapper_depth [dict get $net h_offset]
      }
    }
    set wrapper_depth [expr $wrapper_depth + 3]
    set macro_x [expr $wrapper_depth * [dict get $tech pitch vertical_track]]
    set width  [expr round((floor([lef get_width $cell]  / [dict get $tech pitch vertical_track]) + 1)   * [dict get $tech pitch vertical_track]  )]
    set height [expr round((floor([lef get_height $cell] / [dict get $tech pitch horizontal_track]) + 1) * [dict get $tech pitch horizontal_track])]

    # Now we know where the macro is placed, we know the size of the wrapper
    dict set wrapper die_area [list [expr round(-1 * $macro_x)] 0 [expr $width] $height]
    # debug "Set die area [dict get $wrapper die_area]"
    # Now we know the maximum extent of the space needed for the job we can add in the pins the appropriate number of grids to the left of the RAM

    # Shift the wrapper so the lower left corner is at (0, 0)
    set wrapper [def shift_origin $wrapper $macro_x 0]
    # debug "Shifted die area [dict get $wrapper die_area]"

    # Add obstructions
    foreach obs_layer {M3 J3 C4} {
      set obstructions {}
      if {[dict exists $wrapper obstructions $obs_layer]} {
        set obstructions [dict get $wrapper obstructions $obs_layer]
      }
      # debug "[lindex [dict get $wrapper obstructions $obs_layer] 0]"
      lappend obstructions [list rect [list 0 0 $macro_x $height]]
      # debug "[lindex $obstructions 0]"
      dict set wrapper obstructions $obs_layer $obstructions
      # debug "Added wrapper obstruction [list 0 0 [expr $width + $macro_x] $height]"
    }
    
    
    # Add wrapper pins and nets
    dict for {net_name net} [dict get $net_info] {
      set grid_y [dict get $net grid_y]
      set y_position [expr $grid_y * [dict get $tech pitch horizontal_track]]

      set new_port [lindex [dict get $wrapper pins $net_name ports] 0]
      dict set new_port layers {}
      dict set new_port fixed [list 0 $y_position]
      dict set new_port layers "C4" shapes [list \
        [list rect [list 0 [expr 0 - [dict get $tech layer C4 width] / 2] [dict get $tech layer C4 depth] [expr 0 + [dict get $tech layer C4 width] / 2]]] \
      ]
      # debug "Replacing pin $net_name with $new_port"
      dict set wrapper pins $net_name ports [list $new_port]
      
      set segments {}

      # First segment from RAM to jog location, to the y grid of the pin
      set target_grid_point [expr ($wrapper_depth - [dict get $net h_offset]) * [dict get $tech pitch vertical_track]]
      set width [dict get $tech layer [dict get $net pin_layer] width]
      lappend segments [list \
        layer [dict get $net pin_layer] \
        points [list \
          "$macro_x [dict get $net macro_pin_y]" \
          "$target_grid_point [dict get $net macro_pin_y]" \
          "$target_grid_point $y_position" \
        ]
      ]
      if {[dict get $net pin_layer] != "C4"} {
        lappend segments [list \
          layer [dict get $net pin_layer] \
          points [list \
            "$target_grid_point $y_position" \
            [dict get $tech via] \
          ] \
        ]
      }
      lappend segments [list \
        layer C4 \
        points [list \
          "$target_grid_point $y_position" \
          "0 $y_position" \
        ] \
      ]

      dict set wrapper nets $net_name routes $segments
    }

    return $wrapper
  }

  proc test_harness {wrappers} {
    variable wrapper_cfg

    set site_height [expr [dict get $wrapper_cfg site height] * [dict get $wrapper_cfg def_units]]
    set site_width [expr [dict get $wrapper_cfg site width] * [dict get $wrapper_cfg def_units]]
    set idx 0
    set num_cells [dict size $wrappers]
    set num_grids [expr round(sqrt($num_cells)) + 1]
    set max_cell_width 0
    dict for {cell_name cell} $wrappers {
      set max_cell_width [expr max($max_cell_width,[lindex [dict get $cell die_area] 2])]
    }
    set grid_x_size [expr $max_cell_width + (2 * $site_width)]
    set grid_y_size [expr 4 * $site_height]

    def new_design "test_harness" [dict get $wrapper_cfg def_units] [list 0 0 [expr round($grid_x_size * $num_grids)] [expr round($grid_y_size * $num_grids)]]

    foreach cell [dict keys $wrappers] {
      set x [expr round(($idx % $num_grids) * $grid_x_size)]
      set y [expr round(round($idx / $num_grids) * $grid_y_size)]

      set orig_cell [regsub {_mod} $cell {}]
      def add_component "w_$idx" $cell $x $y N placed
      def add_component "o_$idx" $orig_cell $x [expr round($y + (2 * $site_height))] N placed

      incr idx
    }

    def open test_harness.def
    def write [set design [def get_current_design]]
    def close

    return $design
  }

  proc set_stdcell_config {config} {
    variable wrapper_cfg
    set wrapper_cfg $config
  }

  proc run {} {
    set file_name /projects/ssg/pj10000064_diphda/users/colhol01/openroad/library/arm/cp/14lpp/sc10p5mcpp84_base_lvt_c14/r2p1/lef/sc10p5mcpp84_14lpp_base_lvt_c14.lef

    lef read_macros $file_name
    set data [wrapper find_cells_with_m2_pins]

    set wrappers [wrapper build_wrappers $data]

    lef write_cells sc10p5mcpp84_14lpp_base_lvt_c14.mod.lef $wrappers
    def write_cells $wrappers
  }

  proc convert_tech_to_def_units {tech} {
    set def_units [dict get $tech units]
    dict for {layer_name layer} [dict get $tech layer] {
      foreach property {depth width non_preferred_width} {
        if {[dict exists $layer $property]} {
          dict set tech layer $layer_name $property [expr round([dict get $layer $property] * $def_units)]
        }
      }
    }
    
    foreach layer_name [dict keys [dict get $tech layer]] {
      foreach property {direction width non_preferred_width} { 
        if {[dict exists $tech layer $layer_name $property]} {
          def set_layer_info $layer_name $property [dict get $tech layer $layer_name $property]
        }
      }
    }

    dict set tech pitch vertical_track [expr round([dict get $tech pitch vertical_track] * $def_units)]
    dict set tech pitch horizontal_track [expr round([dict get $tech pitch horizontal_track] * $def_units)]

    return $tech
  }

  proc set_macro_config {lef_tech} {
    variable tech
    
    set tech [convert_tech_to_def_units $lef_tech]
  }
  
  proc macro {lef_file} {
    lef read_macros $lef_file
    set cells {}
    
    foreach cell_name [dict keys [lef get_cells]] {
    # debug "$cell_name"
      set designs  [list ${cell_name}_mod [wrap_macro $cell_name]]
      lef write_macros ${cell_name}_mod.lef $designs
      def write_cells $designs
      lappend cells $cell_name      
    }
    
    return $cells
  }

  namespace export find_cells_with_m2_pins macro set_stdcell_config set_macro_config
  namespace export information warning err critical
  namespace export build_wrappers
  namespace export test_harness
  namespace ensemble create
}

package provide wrapper 1.0.0
