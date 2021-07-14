proc absolute_rectangle {rect offset} {
    return [list \
        [expr [lindex $rect 0] + [lindex $offset 0]] \
        [expr [lindex $rect 1] + [lindex $offset 1]] \
        [expr [lindex $rect 2] + [lindex $offset 0]] \
        [expr [lindex $rect 3] + [lindex $offset 1]] \
    ]
}
proc relative_rectangle {rect offset} {
    return [list \
        [expr [lindex $rect 0] - [lindex $offset 0]] \
        [expr [lindex $rect 1] - [lindex $offset 1]] \
        [expr [lindex $rect 2] - [lindex $offset 0]] \
        [expr [lindex $rect 3] - [lindex $offset 1]] \
    ]
}

if [package vcompare 8.6 $tcl_version] {
    proc lmap {_var list body} {
        upvar 1 $_var var
        set res {}
        foreach var $list {lappend res [uplevel 1 $body]}
        set res
    }
}

namespace eval lef {
    variable lefOut stdout
    variable def_units 2000
    
    proc open {file_name} {
        variable lefOut
        set lefOut [::open $file_name w]
    }
    
    proc close {} {
        variable lefOut
        if {$lefOut != "stdout"} {
            ::close $lefOut
        }
        set lefOut stdout
    }
    
    proc out {args} {
        variable lefOut
        
        if {[llength $args] == 2} {
            puts [lindex $args 0] $lefOut [lindex $args 1]
        } else {
            puts $lefOut [lindex $args 0]
        }
    }

    variable cells

    proc get_cells {} {
        variable cells 
        return $cells
    }
    
    proc get_cell {cell_name} {
        variable cells 
        return [dict get $cells $cell_name]
    }
    
    proc get_width {cell} {
        return [expr [lindex [dict get $cell die_area] 2] - [lindex [dict get $cell die_area] 0]]
    }
    
    proc get_height {cell} {
        return [expr [lindex [dict get $cell die_area] 3] - [lindex [dict get $cell die_area] 1]]
    }
    
    proc read_macros {file_name} {
        variable cells
        variable def_units
        
        set ch [::open $file_name]

        set cells {}

        while {![eof $ch]} {
            set line [gets $ch]

            if {[regexp {MACRO\s*([^\s]*)} $line - cell_name]} {
                dict set cells $cell_name units $def_units
                dict set cells $cell_name name $cell_name
                while {![eof $ch]} {
                    set line [gets $ch]
                    if {[regexp {^\s*$} $line]} {
                        continue
                    } elseif {[regexp {CLASS\s+([^\s]*)} $line - cell_class]} {
                        dict set cells $cell_name cell_class $cell_class
                    } elseif {[regexp {ORIGIN\s+([^\s]*)\s+([^\s]*)} $line - origin_x origin_y]} {
                        dict set cells $cell_name origin [lmap x [list $origin_x $origin_y] {expr round($x * $def_units)}]
                    } elseif {[regexp {FOREIGN\s+([^\s]*)\s+([^\s]*)\s+([^\s]*)} $line - foreign x y]} {
                        dict set cells $cell_name foreign [list ref $foreign origin [lmap x [list $x $y] {expr round($x * $def_units)}]]
                    } elseif {[regexp {SIZE\s+([^\s]*)\s+BY\s+([^\s]*)} $line - width height]} {
                        dict set cells $cell_name die_area [list 0 0 [expr round($width * $def_units)] [expr round($height * $def_units)]]
                    } elseif {[regexp {SYMMETRY\s+(.*)\s;} $line - symmetry]} {
                        dict set cells $cell_name symmetry $symmetry
                    } elseif {[regexp {SITE\s+([^\s]*)} $line - site]} {
                        dict set cells $cell_name site $site
                    } elseif {[regexp {PIN\s*([^\s]*)} $line - pin_name]} {
                        set pin_pattern [regsub -all {([\[\]])} $pin_name {\\\1}]
                        if {[info vars antennamodel] != ""} {
                            unset antennamodel
                        }
                        while {![eof $ch]} {
                            set line [gets $ch]
                            if {[regexp {^\s*$} $line]} {
                                continue
                            } elseif {[regexp {DIRECTION\s+([^\s]*)} $line - direction]} {
                                dict set cells $cell_name pins $pin_name direction $direction
                            } elseif {[regexp {USE\s+([^\s]*)} $line - use]} {
                                dict set cells $cell_name pins $pin_name use $use
                            } elseif {[regexp {ANTENNAMODEL\s+([^\s]*)} $line - antennamodel]} {
                                continue
                            } elseif {[regexp {ANTENNAGATEAREA\s+([^\s]*)\s+LAYER\s+([^\s]*)} $line - gate_area layer]} {
                                if {[info vars antennamodel] == ""} {
                                    set antennamodel "default"
                                }
                                if {[dict exists $cells $cell_name pins $pin_name antenna_model $antennamodel]} {
                                    set model [dict get $cells $cell_name pins $pin_name antenna_model $antennamodel]
                                } else {
                                    set model {}
                                }
                                lappend model [list gate_area $gate_area layer $layer]
                                dict set cells $cell_name pins $pin_name antenna_model $antennamodel $model
                            } elseif {[regexp {ANTENNAGATEAREA\s+([^\s]*)} $line - gate_area]} {
                                if {[info vars antennamodel] == ""} {
                                    set antennamodel "default"
                                }
                                if {[dict exists $cells $cell_name pins $pin_name antenna_model $antennamodel]} {
                                    set model [dict get $cells $cell_name pins $pin_name antenna_model $antennamodel]
                                } else {
                                    set model {}
                                }
                                lappend model [list gate_area $gate_area]
                                dict set cells $cell_name pins $pin_name antenna_model $antennamodel $model
                            } elseif {[regexp {ANTENNADIFFAREA\s+([^\s]*)\s+LAYER\s+([^\s]*)} $line - antennadiffarea layer]} {
                                dict set cells $cell_name pins $pin_name antennadiffarea area $antennadiffarea
                                dict set cells $cell_name pins $pin_name antennadiffarea layer $antennadiffarea
                            } elseif {[regexp {ANTENNADIFFAREA\s+([^\s]*)\s} $line - antennadiffarea]} {
                                dict set cells $cell_name pins $pin_name antennadiffarea area $antennadiffarea
                            } elseif {[regexp {SHAPE\s+([^\s]*)\s+([^\s]*)} $line - shape]} {
                                dict set cells $cell_name pins $pin_name shape $shape
                            } elseif {[regexp {PORT} $line]} {
                                set port {}
                                dict set port orientation N
                                while {![eof $ch]} {
                                    set line [gets $ch]
                                    if {[regexp {^\s*$} $line]} {
                                        continue
                                    } elseif {[regexp {LAYER\s+([^\s]*)} $line - layer]} {
                                        continue
                                    } elseif {[regexp {RECT\s+MASK\s+([^\s]*)\s+([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)} $line - mask x1 y1 x2 y2]} {
                                    	if {[dict exists $port layers $layer shapes]} {
                                            set layer_shapes [dict get $port layers $layer shapes]
                                        } else {
                                            set layer_shapes {}
                                        }
                                        if {[dict exists $port fixed]} {
                                            set offset [dict get $port fixed]
                                        } else {
                                            set offset [lmap x [list $x1 $y1] {expr round($x * $def_units)}]
                                            dict set port fixed $offset
                                        }
                                        set new_shape [list \
                                            rect [relative_rectangle [lmap x [list $x1 $y1 $x2 $y2] {expr round($x * $def_units)}] $offset] \
                                            mask $mask \
                                        ]
                                        lappend layer_shapes $new_shape
                                        dict set port layers $layer shapes $layer_shapes
                                    } elseif {[regexp {RECT\s([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)} $line - x1 y1 x2 y2]} {
                                    	if {[dict exists $port layers $layer shapes]} {
                                            set layer_shapes [dict get $port layers $layer shapes]
                                        } else {
                                            set layer_shapes {}
                                        }
                                        if {[dict exists $port fixed]} {
                                            set offset [dict get $port fixed]
                                        } else {
                                            set offset [lmap x [list $x1 $y1] {expr round($x * $def_units)}]
                                            dict set port fixed $offset
                                        }
                                        set new_shape [list \
                                            rect [relative_rectangle [lmap x [list $x1 $y1 $x2 $y2] {expr round($x * $def_units)}] $offset] \
                                        ]
                                        lappend layer_shapes $new_shape
                                        dict set port layers $layer shapes $layer_shapes
                                    } elseif {[regexp {END} $line]} {
                                        if {[dict exists $cells $cell_name pins $pin_name ports]} {
                                            set ports [dict get $cells $cell_name pins $pin_name ports]
                                        } else {
                                            set ports {}
                                        }
                                        lappend ports $port
                                        dict set cells $cell_name pins $pin_name ports $ports
                                        break
                                    } else {
                                        error "Parsing failure PORT:\n$line"
                                    }
                                }
                            } elseif {[regexp "END\\s$pin_pattern" $line]} {
                                break
                            } else {
                                error "Parsing failure PIN:\n$line"
                            }
                        }
                    } elseif {[regexp {OBS} $line]} {
                        while {![eof $ch]} {
                            set line [gets $ch]
                            if {[regexp {^\s*$} $line]} {
                                continue
                            } elseif {[regexp {LAYER\s+([^\s]*)(\s+DESIGNRULEWIDTH\s+([0-9.]+))?} $line - layer - drw]} {
                                if {$drw != ""} {
                                    dict set cells $cell_name layers $layer drw $drw
                                }
                                continue
                            } elseif {[regexp {RECT\s+MASK\s+([^\s]*)\s+([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)} $line - mask x1 y1 x2 y2]} {
                                if {[dict exists $cells $cell_name obstructions $layer]} {
                                    set obstructions [dict get $cells $cell_name obstructions $layer]
                                } else {
                                    set obstructions {}
                                }
                                lappend obstructions [list rect [lmap x [list $x1 $y1 $x2 $y2] {expr round($x * $def_units)}] mask $mask]
                                dict set cells $cell_name obstructions $layer $obstructions
                            } elseif {[regexp {RECT\s([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)\s\s*([0-9\-\.]*)} $line - x1 y1 x2 y2]} {
                                if {[dict exists $cells $cell_name obstructions $layer]} {
                                    set obstructions [dict get $cells $cell_name obstructions $layer]
                                } else {
                                    set obstructions {}
                                }
                                lappend obstructions [list rect [lmap x [list $x1 $y1 $x2 $y2] {expr round($x * $def_units)}]]
                                dict set cells $cell_name obstructions $layer $obstructions
                            } elseif {[regexp {END} $line]} {
                                break
                            } else {
                                error "Parsing failure OBS:\n$line"
                            }
                        }
                    } elseif {[regexp "END\\s*$cell_name" $line]} {
                        break
                    } else {
                        error "Parsing failure MACRO\n$line"
                    }
                }
            }
        }

        ::close $ch
    }

    proc get_blockage_layers {design} {
      if {[dict exists $design blockage_layers]} {
        return [dict get $design blockage_layers]
      }

      set blocked_layers {}

      dict for {layer_name obstructions} [dict get $design obstructions] {
        lappend blocked_layers $layer_name
      }
      return $blocked_layers
    }

    proc write_header {} {
    }
    proc write_footer {} {
    }
    # Read a LEF from a file into a dictionary with the name of the cell as the key and the following entries
    #   - cell_class
    #   - origin
    #   - foreign
    #       - ref
    #       - origin
    #   - die_area
    #   - symmetry
    #   - site
    #   - pins: dict with the name of the pin as the key
    #       - antenna_model
    #           - gate_area
    #           - layer
    #       - antennadiffarea
    #           - layer
    #           - area
    #       - direction
    #       - use
    #       - shape
    #       - ports: a list of lists of shapes that make up a physical connection
    #               - layer
    #               - rect 
    #               - mask?
    #   - obstructions
    #       - layer: a dictionaries with layer_name as the key
    #           - rect 
    #           - mask?
    #             
    proc write {design} {
        set def_units [dict get $design units]
        
        out "MACRO [dict get $design name]"
        out "  CLASS [dict get $design cell_class] ;"
        if {[dict exists $design origin]} {
            out "  ORIGIN [dict get $design origin] ;"
        } else {
             out "  ORIGIN 0.0 0.0 ;"
        }
        out "  FOREIGN [dict get $design foreign ref] [dict get $design foreign origin] ;"
        out "  SIZE [expr 1.0 * [lindex [dict get $design die_area] 2] / $def_units] BY [expr 1.0 * [lindex [dict get $design die_area] 3] / $def_units] ;"
        out "  SYMMETRY [dict get $design symmetry] ;"
        if {[dict exists $design site]} {
            out "  SITE [dict get $design site] ;"
        }

        if {[dict exists $design pins]} {
            dict for {pin_name pin} [dict get $design pins] {
                out "  PIN $pin_name"
                out "     DIRECTION [dict get $pin direction] ;"
                if {[dict exists $pin use]} {
                    out "     USE [dict get $pin use] ;"
                }
                foreach port [dict get $pin ports] {
                    out "     PORT "
                    foreach layer_name [dict keys [dict get $port layers]] {
                        set shapes [dict get $port layers $layer_name shapes]

                        out "       LAYER $layer_name ;"
                        foreach shape $shapes {
                            if {[dict exists $port fixed]} {
                                set offset [dict get $port fixed]
                            } elseif {[dict exists $port placed]} {
                                set offset [dict get $port placed]
                            } else {
                                set offset [list 0 0]
                            }
                            set rect [absolute_rectangle [dict get $shape rect] $offset]

                            if {[dict exists $shape mask]} {
                                out "         RECT MASK [dict get $shape mask] [lmap x $rect {expr 1.0 * $x / $def_units}] ;"
                            } else {
                                out "         RECT [lmap x $rect {expr 1.0 * $x / $def_units}] ;"
                            }
                        }
                    }
                    out "     END "
                }
                out "  END $pin_name"
            }
        }

        if {[dict exists $design obstructions]} {
            out "  OBS"
            if {[dict get $design use_sheet_obstructions]} {
              dict for {layer_name obstructions} [dict get $design obstructions] {
                lappend blocked_layers $layer_name
              }
              set sheet "0 0 [expr 1.0 * [lindex [dict get $design die_area] 2] / $def_units] [expr 1.0 * [lindex [dict get $design die_area] 3] / $def_units]"
              foreach layer_name [get_blockage_layers $design] {
                if {[dict exists $design layers $layer_name drw]} {
                    set drw "DESIGNRULEWIDTH [dict get $design layers $layer_name drw] "
                } else {
                    set drw ""
                }
                out "    LAYER $layer_name $drw;"
                out "      RECT $sheet ;"
              }
            } else {
              dict for {layer_name obstructions} [dict get $design obstructions] {
                  out "    LAYER $layer_name ;"
                  foreach obs $obstructions {
                      if {[dict exists $obs mask]} {
                          out "      RECT MASK [dict get $obs mask] [lmap x [dict get $obs rect] {expr 1.0 * $x / $def_units}] ;"
                      } else {
                          out "      RECT [lmap x [dict get $obs rect] {expr 1.0 * $x / $def_units}] ;"
                      }
                  }
              }
            }
            out "  END"
        }
        out "END [dict get $design name]"
        out ""
    }
    
    proc write_cells {file_name cells} {
        lef open $file_name

        out "###############################################################"
        out "# Created by cell-veneer"
        out "# Created on: [clock format [clock seconds] -format {%A, %d %B %Y}]"
        out "###############################################################"
        out ""
        out "VERSION 5.8 ;"
        out "BUSBITCHARS \"\[\]\" ;"
        out "DIVIDERCHAR \"/\" ;"
        out ""
        out "SITE sc10p5mcpp84_14lpp"
        out "  CLASS CORE ;"
        out "  SIZE 0.084 BY 0.672 ;"
        out "  SYMMETRY Y ;"
        out "END sc10p5mcpp84_14lpp"
        out ""
        out "SITE sc10p5mcpp84_14lpp_pg"
        out "  CLASS CORE ;"
        out "  SIZE 0.084 BY 1.344 ;"
        out "  SYMMETRY Y ;"
        out "END sc10p5mcpp84_14lpp_pg"
        out ""

        dict for {cell_name cell} $cells {
            lef write $cell
        }

        out "END LIBRARY"
        out ""
        lef close
    }

    proc write_macros {file_name cells} {
        lef open $file_name

        out "###############################################################"
        out "# Created by cell-veneer"
        out "# Created on: [clock format [clock seconds] -format {%A, %d %B %Y}]"
        out "###############################################################"
        out ""
        out "VERSION 5.8 ;"
        out "BUSBITCHARS \"\[\]\" ;"
        out "DIVIDERCHAR \"/\" ;"
        out ""

        dict for {cell_name cell} $cells {
            lef write $cell
        }

        out "END LIBRARY"
        out ""
        lef close
    }

    namespace export read_macros get_width get_height
    namespace export get_cell get_cells write write_cells write_macros
    namespace export open close out
    namespace ensemble create
}

namespace eval def {
    variable def_units 
    variable defOut stdout
    variable designs {}
    
    proc open {file_name} {
        variable defOut
        set defOut [::open $file_name w]
    }
    
    proc close {} {
        variable defOut
        if {$defOut != "stdout"} {
            ::close $defOut
        }
        set defOut stdout
    }
    
    proc out {args} {
        variable defOut
        
        if {[llength $args] == 2} {
            puts [lindex $args 0] $defOut [lindex $args 1]
        } else {
            puts $defOut [lindex $args 0]
        }
    }

    # Write out DEF from a design structure which is a dictionary with the following keys
    #   - name
    #   - tool
    #   - units
    #   - die_area
    #   - core_area
    #   - rows: dict with the index of the row as the key
    #       - site
    #       - start
    #       - height
    #       - orientation
    #       - num_sites
    #       - site_width
    #   - pins: dict with the name of the pin as the key
    #       - net_name
    #       - direction
    #       - use
    #       - special
    #       - ports : a list of dictionaries, one per port
    #           - orientation
    #           - (placed|fixed)
    #           - layers
    #               - spacing
    #               - designrulewidth
    #               - shapes : list of rectangles (or polygons)
    #                   - (rect|polygon)
    #   - physical_viarules: dict with the name of the viarule as the key
    #       - rule        
    #       - cutsize     
    #       - layers      
    #       - cutspacing  
    #       - enclosure   
    #       - rowcol      
    #   - components: dict with the instance name of the component as the key
    #       - inst_name
    #       - cell_name
    #       - (fixed|placed)?
    #       - orientation
    #   - nets: dict with the name of the net as the key
    #       - use: SIGNAL | POWER | GROUND
    #       - connections: list of instance pin pairs  
    #       - routes: list of dictionaries              
    #           - layer                                
    #           - points: list of points, where a point can be an XY location or the name of a VIA 
    #   - special_nets: dict with the name of the net as the key
    #       - use: SIGNAL | POWER | GROUND                                    
    #       - connections: list of instance pin pairs  
    #       - routes: list of dictioaries              
    #           - layer                                
    #           - width                                
    #           - shape                                
    #           - points: list of points, where a point can be an XY location or the name of a VIA
    #                              

    proc shift_point {point x y} {
        return [list [expr [lindex $point 0] + $x] [expr [lindex $point 1] + $y]]
    }
    
    proc shift_rect {rect x y} {
        return [list [expr [lindex $rect 0] + $x] [expr [lindex $rect 1] + $y] [expr [lindex $rect 2] + $x] [expr [lindex $rect 3] + $y]]
    }

    proc shift_origin {design x y} {
        if {[dict exists $design die_area]} {
            dict set design die_area [shift_rect [dict get $design die_area] $x $y] 
        }
        if {[dict exists $design core_area]} {
            dict set design core_area [shift_rect [dict get $design core_area] $x $y] 
        }
        if {[dict exists $design rows]} {
        }
        if {[dict exists $design pins]} {
            dict for {pin_name pin} [dict get $design pins] {
                set ports {}
                foreach port [dict get $pin ports] {
                    if {[dict exists $port fixed]} {
                        dict set port fixed [shift_point [dict get $port fixed] $x $y]
                    } elseif {[dict exists $port placed]} {
                        dict set port placed [shift_point [dict get $port placed] $x $y]
                    }
                    lappend ports $port
                }
                dict set design pins $pin_name ports $ports
            }
        }
        if {[dict exists $design components]} {
            dict for {inst_name inst} [dict get $design components] {
                if {[dict exists $inst fixed]} {
                    dict set design components $inst_name fixed [shift_point [dict get $inst fixed] $x $y]
                } elseif {[dict exists $inst placed]} {
                    dict set design components $inst_name placed [shift_point [dict get $inst placed] $x $y]
                }
            }
        }
        if {[dict exists $design nets]} {
            dict for {net_name net} [dict get $design nets] {
                if {[dict exists $net routes]} {
                    set routes {}
                    foreach route [dict get $net routes] {
                        set points {}
                        foreach point $points {
                            if {[llength $point] == 2} {
                                lappend points [shift_point $point $x $y]
                            } else {
                                lappend points $point
                            }
                        }
                        lappend routes $route
                    }
                    dict set design nets $net_name routes $routes
                }
            }
        }
        if {[dict exists $design special_nets]} {
            dict for {net_name net} [dict get $design special_nets] {
                set routes {}
                if {[dict exists $net routes]} {
                    foreach route [dict get $net routes] {
                        set points {}
                        foreach point $points {
                            if {[llength $point] == 2} {
                                lappend points [shift_point $point $x $y]
                            } else {
                                lappend points $point
                            }
                        }
                        lappend routes $route
                    }
                    dict set design special_nets $net_name routes $routes
                }
            }
        }
        if {[dict exists $design obstructions]} {
            dict for {layer_name obstructions} [dict get $design obstructions] {
                set new_obs {}
                foreach obs $obstructions {
                    dict set obs rect [def::shift_rect [dict get $obs rect] $x $y]
                    lappend new_obs $obs
                }
                dict set design obstructions $layer_name $new_obs
            }
        }

        return $design
    }

    variable layer_info {} 
    proc set_layer_info {layer_name key value} {
        variable layer_info

        dict set layer_info layers $layer_name $key $value
    }

    proc get_layer_width {layer_name} {
        variable layer_info
        return [dict get $layer_info layers $layer_name width]
    }

    proc get_layer_non_preferred_width {layer_name} {
        variable layer_info
        if {[dict exists $layer_info layers $layer_name non_preferred_width]} {
            return [dict get $layer_info layers $layer_name non_preferred_width]
        }
        return [dict get $layer_info layers $layer_name width]
    }

    proc get_layer_direction {layer_name} {
        variable layer_info
        return [dict get $layer_info layers $layer_name direction]
    }

    proc get_line_direction {points} {
        if {[lindex $points 0 0] == [lindex $points 1 0]} {
            set direction "VERTICAL"
        } elseif {[lindex $points 0 1] == [lindex $points 1 1]} {
            set direction "HORIZONTAL"
        } else {
            error "Non orthogonal line $points"
        }
        return $direction
    }
    proc get_line_width {layer_name points} {
        set direction [get_line_direction $points]

        if {[get_layer_direction $layer_name] == $direction} {
            return [get_layer_width $layer_name]
        } else {
            return [get_layer_non_preferred_width $layer_name]
        }
    }

    proc get_extended_line {layer_name points} {
        if {[llength [lindex $points 1]] == 1} {
            return "( [lindex $points 0] ) [lindex $points 1]"
        }

        set direction [get_line_direction $points]

        if {$direction == [get_layer_direction $layer_name]} {
          set extension [expr [get_layer_non_preferred_width $layer_name] / 2]
        } else {
          set extension [expr [get_layer_width $layer_name] / 2]
        }

        if {$direction == "VERTICAL"} {
            set x_min [lindex $points 0 0]
            set x_max [lindex $points 0 0]
            set y_min [expr min([lindex $points 0 1], [lindex $points 1 1]) - $extension]
            set y_max [expr max([lindex $points 0 1], [lindex $points 1 1]) + $extension]
        } else {
            set x_min [expr min([lindex $points 0 0], [lindex $points 1 0])]
            set x_max [expr max([lindex $points 0 0], [lindex $points 1 0])]
            set y_min [lindex $points 0 1]
            set y_max [lindex $points 0 1]
        }

        return "( $x_min $y_min ) ( $x_max $y_max )"
    }

    proc write {design} {
        out "###############################################################"
        if {[dict exists $design tool]} {
            out "# Created by [dict get $design tool]"
        }
        out "# Created on: [clock format [clock seconds] -format {%A, %d %B %Y}]"
        out "###############################################################"

        out "VERSION 5.8 ;"
        out "DIVIDERCHAR \"/\" ;"
        out "BUSBITCHARS \"\[\]\" ;"
        out "DESIGN [dict get $design name] ;"
        out "UNITS DISTANCE MICRONS [dict get $design units] ;"
        out ""

        if {[dict exists $design properties]} {
            out "PROPERTYDEFINITIONS "
            if {[dict exists $design properties core_area]} {
                out "DESIGN FE_CORE_BOX_LL_X REAL [lindex [dict get $design properties core_area] 0] ;"
                out "DESIGN FE_CORE_BOX_UR_X REAL [lindex [dict get $design properties core_area] 1] ;"
                out "DESIGN FE_CORE_BOX_LL_Y REAL [lindex [dict get $design properties core_area] 2] ;"
                out "DESIGN FE_CORE_BOX_UR_Y REAL [lindex [dict get $design properties core_area] 3] ;"
            }
            out "END PROPERTYDEFINITIONS"
        }

        out ""
        out "DIEAREA ( [lrange [dict get $design die_area] 0 1] ) ( [lrange [dict get $design die_area] 2 3] ) ;"

        if {[dict exists $design tracks]} {
        }
        
        if {[dict exists $design rows]} {
            foreach idx [lsort -integer [dict keys $design rows]] {
                out -nonewline "ROW ROW_$idx [dict keys $design rows $idx site] [dict keys $design rows $idx start] [dict keys $design rows $idx height] [dict keys $design rows $idx orientation]"
                out " DO [dict keys $design rows $idx num_sites] BY 1 STEP [dict keys $design rows $idx site_width] 0 ;"
            }
        }
        
        if {[dict exists $design pins]} {
            out ""
            out "PINS [dict size [dict get $design pins]] ;"
            dict for {pin_name pin} [dict get $design pins] {
                out -nonewline "- $pin_name + NET [dict get $pin net_name] + DIRECTION [dict get $pin direction] "
                if {[dict exists $pin use]} {
                    out -nonewline "+ USE [dict get $pin use] "
                }
                if {[dict exists $pin special]} {
                    out -nonewline "+ SPECIAL "
                }
                out ""
                if {[dict exists $pin ports]} {
                    foreach port [dict get $pin ports] {
                        if {[llength [dict get $design pins $pin_name ports]] > 1} {
                            out "  + PORT "
                        }
                        dict for {layer_name layer_info} [dict get $port layers] {
                            foreach shape [dict get $port layers $layer_name shapes] {
                                out -nonewline "  + LAYER $layer_name "
                                if {[dict exists $port layers $layer_name spacing]} {
                                    out "SPACING [dict get $port layers $layer_name spacing] "
                                } elseif {[dict exists $port layers $layer_name designrulewidth]} {
                                    out "DESIGNRULEWIDTH [dict get $port layers $layer_name designrulewidth] "
                                }
                                out "( [lrange [dict get $shape rect] 0 1] ) ( [lrange [dict get $shape rect] 2 3] ) "
                            }
                        }
                        if {[dict exists $port fixed]} {
                            out "  + FIXED ( [dict get $port fixed] ) [dict get $port orientation] "
                        } elseif {[dict exists $shape placed]} {
                            out "  + PLACED ( [dict get $port placed] ) [dict get $port orientation] "
                        }
                    }
                out " ;"
                }
            }
            out "END PINS"
        }

        ##### Generating via rules

        if {[dict exists $design physical_viarules]} {
            out ""
            out "VIAS [dict size [dict get $design physical_viarules]] ;"
            dict for {name rule} [dict get $design physical_viarules] {
                out "- $name"
                out " + VIARULE [dict get $rule rule]"
                out " + CUTSIZE [dict get $rule cutsize]"
                out " + LAYERS [dict get $rule layers]"
                out " + CUTSPACING [dict get $rule cutspacing]"
                out " + ENCLOSURE [dict get $rule enclosure]"
                out " + ROWCOL [dict get $rule rowcol]"
                out " ;"
            }
            out "END VIAS"
        }

        if {[dict exists $design components]} {
            out ""
            out "COMPONENTS [dict size [dict get $design components]] ;"
            dict for {inst_name inst} [dict get $design components] {
                out -nonewline "- $inst_name [dict get $inst cell_name] "
                if {[dict exists $inst fixed]} {
                    out -nonewline "+ FIXED ( [dict get $inst fixed] ) "
                } elseif {[dict exists $inst placed]} {
                    out -nonewline "+ PLACED ( [dict get $inst placed] ) "
                }
                if {[dict exists $inst orientation]} {
                    out -nonewline "[dict get $inst orientation] "
                }
                out ";"
            }
            out "END COMPONENTS"
        }
        
        if {[dict exists $design nets]} {
            out ""
            out "SPECIALNETS [dict size [dict get $design nets]] ;"
            dict for {net_name net} [dict get $design nets] {
                out -nonewline "- $net_name "
                foreach connection [dict get $net connections] {
                    out " ( $connection )"
                }
                if {[dict exists $net routes]} {
                    set type "ROUTED"
                    foreach route [dict get $net routes] {
                        set first_point [lindex [dict get $route points] 0]
 
                        foreach point [lrange [dict get $route points] 1 end] {
                            set points [get_extended_line [dict get $route layer] [list $first_point $point]]
                            if {[dict exists $route shape]} {
		                set shape " + SHAPE [dict get $route shape] "
                            } else {
                                set shape ""
                            }
                            if {[dict exists $route mask]} {
                                set mask "MASK [dict get $route mask] "
                            } else {
                                set mask ""
                            }
                            if {[llength $point] == 2} {
    		                out -nonewline "  + $type [dict get $route layer] [get_line_width [dict get $route layer] [list $first_point $point]] "
                                out -nonewline $shape
                                out -nonewline $points
                                out -nonewline $mask
                            } else {
    		                out -nonewline "  + $type [dict get $route layer] 0 "
                                out -nonewline $shape
                                out -nonewline $points
                                out -nonewline $mask
                            }
                            out ""
                            set first_point $point
                            set type "ROUTED"
                        }
                    }
                }
                out "  + USE [dict get $net use]\n ;"
            }
            out "END SPECIALNETS"
        }

        if {[dict exists $design special_nets]} {
            out ""
            out "SPECIALNETS [dict size [dict get $design special_nets]] ;"
            dict for {net_name net} [dict get $design special_nets] {
                out -nonewline "- $net_name "
                foreach connection [dict get $net connections] {
                    out " ( $connection )"
                }
                if {[dict exists $net routes]} {
                    set route [lindex [dict get $net routes] 0]
		    out -nonewline "  + ROUTED [dict get $route layer] [expr round([dict get $route width])] + SHAPE [dict get $route shape] "
                    foreach point [dict get $route points] {
                        out -nonewline " $point"
                    }
                    out ""

                    foreach route [lrange [dict get $net routes] 1 end] {
		        out "    NEW [dict get $route layer] [expr round([dict get $route width])] + SHAPE [dict get $route shape] "
                        foreach point [dict get $route points] {
                            out -nonewline " $point"
                        }
                        out ""
                    }
                }
                out "  + USE [dict get $net use]\n ;"
            }
            out "\nEND SPECIALNETS"
        }

        out ""
        out "END DESIGN"
    }

    proc new_design {design_name units {die_area {0 0 0 0}}} {
        variable designs
        variable current_design
        set current_design $design_name

        dict set designs $current_design [list name $design_name units $units die_area $die_area]
    }

    proc add_component {inst_name cell_name x y orientation status} {
        variable designs
        variable current_design

        dict set designs $current_design components $inst_name inst_name $inst_name
        dict set designs $current_design components $inst_name cell_name $cell_name
        dict set designs $current_design components $inst_name $status [list $x $y]
        dict set designs $current_design components $inst_name orientation $orientation
    }
    
    proc get_current_design {} {
        variable designs
        variable current_design

        return [dict get $designs $current_design]
    }
    
    proc write_cells {cells} {
        dict for {cell_name cell} $cells {
            def open ${cell_name}.def
            def write $cell
            def close
        }
    }
    
    proc set_def_units {units} {
        variable def_units
        
        set def_units $units
    }
    
    proc get_def_units {} {
        variable def_units
        
        return $def_units
    }
    
    namespace export new_design add_component get_current_design
    namespace export set_def_units get_def_units shift_origin shift_rect
    namespace export open close out write write_cells
    namespace export set_layer_info
    namespace ensemble create
}

package provide lefdef 1.0.0
