#!/usr/bin/env ruby

require 'stringio'
require 'test/unit'
require_relative '../src/LEFViaData'

#
# Unit test for LEFViaData
#
class LEFViaDataTest < Test::Unit::TestCase
    #
    # Sets up LEFViaData object
    #
    def setup
        @rep = LEFViaData.new()
    end

    #
    # Tests basic operation
    #
    def test_basic
        data_str = <<~LEF_TEXT
LAYER M8
  TYPE ROUTING ;
END M8
LAYER V8
  TYPE CUT ;
END V8
LAYER M9
  TYPE ROUTING ;
END M9
LAYER V9
  TYPE CUT ;
END V9
LAYER Pad
  TYPE ROUTING ;
END Pad
 VIA VIA9Pad Default
  LAYER M9 ;
 RECT -0.05 -0.05 0.05 0.05 ;
  LAYER Pad ;
 RECT -0.05 -0.05 0.05 0.05 ;
  LAYER V9 ;
 RECT -0.05 -0.05 0.05 0.05 ;
END VIA9Pad

VIA VIA89 Default
  LAYER M8 ;
 RECT -0.02 -0.02 0.02 0.02 ;
  LAYER M9 ;
 RECT -0.02 -0.02 0.02 0.02 ;
  LAYER V8 ;
 RECT -0.02 -0.02 0.02 0.02 ;
END VIA89
LEF_TEXT

        exp_layers = {
            "VIA9Pad" => [ "M9", "V9", "Pad" ],
            "VIA89" => [ "M8", "V8", "M9" ],
        }
            
        data_stream = StringIO.new(data_str)
        @rep.read(data_stream)
        via_map = @rep.get_map()
        assert(via_map)
        assert(via_map.length == 2,
               sprintf("via map length is not 2: %d", via_map.length))
        via_map.each do | via_name, via |
            layer_list = via.get_layer_list()
            assert(layer_list.length == exp_layers[via_name].length)
            layer_name_list = layer_list.sort_by {|obj| obj.get_layer.get_number}.map { |obj| obj.get_layer.get_name }
            assert(exp_layers[via_name] == layer_name_list,
                   sprintf("expected %s. got %s", exp_layers[via_name],
                           layer_name_list))
        end
    end
end
