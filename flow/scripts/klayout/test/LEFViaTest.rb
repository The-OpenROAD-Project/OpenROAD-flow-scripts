#!/usr/bin/env ruby

require 'test/unit'
require 'stringio'
require_relative '../src/LEFLayer'
require_relative '../src/LEFVia'

#
# Unit test for LEFVia
#
class LEFViaTest < Test::Unit::TestCase
    #
    # Sets up LEFVia object
    #
    def setup
        @m1_layer = LEFLayer.new("M1", 100, "ROUTING")
        @cut_layer = LEFLayer.new("CUT", 150, "CUT")
        @m2_layer = LEFLayer.new("M2", 200, "ROUTING")
        @diff_m1_layer = LEFLayer.new(@m1_layer.get_name(),
                                      @m1_layer.get_number() + 1000,
                                      @m1_layer.get_type())
        @rect = [0, 0, 100, 100]
        @bottom_via_layer = LEFVia::LEFViaLayer::new(@m1_layer)
        @bottom_via_layer.add_shape(@rect)
        @bottom_via_layer_lef = get_exp_via_layer_str(@m1_layer.get_name(),
                                                      @rect)
        @cut_via_layer = LEFVia::LEFViaLayer::new(@cut_layer)
        @cut_via_layer.add_shape(@rect)
        @cut_via_layer_lef = get_exp_via_layer_str(@cut_layer.get_name(), @rect)
        @top_via_layer = LEFVia::LEFViaLayer::new(@m2_layer)
        @top_via_layer.add_shape(@rect)
        @top_via_layer_lef = get_exp_via_layer_str(@m2_layer.get_name(), @rect)
    end

    def get_exp_via_layer_str(layer_name, rect)
        return sprintf("  LAYER %s ;\n  RECT %5.3f %5.3f %5.3f %5.3f ;\n",
                       layer_name, rect[0], rect[1], rect[2], rect[3])
    end

    #
    # Tests the LEFViaLayer object
    #
    def test_via_layer_basic
        lef_output = StringIO.new()
        
        obj = LEFVia::LEFViaLayer.new(@m1_layer)
        assert(obj)
        assert(obj.get_layer() == @m1_layer)
        assert(obj.get_shape_list().empty?)
        obj.write_lef(lef_output)
        exp_lef = "  LAYER M1 ;\n"
        assert(lef_output.string == exp_lef,
               sprintf("got '%s' expected '%s'", lef_output.string, exp_lef))
        obj.add_shape(@rect)
        assert(obj.get_shape_list().length == 1)
        assert(obj.get_shape_list()[0] == @rect)
        exp_lef = "  LAYER M1 ;\n  RECT 0.000 0.000 100.000 100.000 ;\n"
        lef_output.rewind
        obj.write_lef(lef_output)
        assert(lef_output.string == exp_lef,
               sprintf("got '%s' expected '%s'", lef_output.string, exp_lef))
        orig_sha = obj.sha256

        # Make another object with the same values, but a different layer
        new_obj = LEFVia::LEFViaLayer.new(@diff_m1_layer)
        new_obj.add_shape(@rect)
        new_sha = new_obj.sha256
        assert(orig_sha == new_sha)
    end

    #
    # Tests basic operation for a default via
    #
    def test_basic_default
        name = "VIA12"
        lef_output = StringIO.new()

        obj = LEFVia.new(name, true)
        assert(obj)
        assert(obj.get_name() == name)
        assert(obj.get_layer_list().empty?)
        exp_lef = sprintf("VIA %s DEFAULT\nEND %s\n\n", name, name)
        empty_sha = obj.sha256()
        obj.write_lef(lef_output)
        assert(lef_output.string == exp_lef,
               sprintf("got '%s' expected '%s'", lef_output.string, exp_lef))
        
        # add layers and check
        obj.add_layer(@bottom_via_layer)
        obj.add_layer(@cut_via_layer)
        obj.add_layer(@top_via_layer)
        
        # check unsorted layer_list
        assert(obj.get_layer_list(false).length == 3)
        
        # check sorted layer_list
        layer_list = obj.get_layer_list()
        assert(layer_list.length == 3)
        assert(layer_list[0] == @bottom_via_layer)
        assert(layer_list[1] == @cut_via_layer)
        assert(layer_list[2] == @top_via_layer)

        # check LEF output
        lef_output.rewind
        obj.write_lef(lef_output)
        exp_lef = sprintf("VIA %s DEFAULT\n%s%s%sEND %s\n\n", name,
                          @bottom_via_layer_lef, @cut_via_layer_lef,
                          @top_via_layer_lef, name)
        assert(lef_output.string == exp_lef,
               sprintf("got '%s' expected '%s'", lef_output.string, exp_lef))

        # Check sha's with and without layers - should be different
        assert(obj.sha256() != empty_sha)
    end
        
    #
    # Tests basic operation
    #
    def test_basic
        name = "VIA12"
        lef_output = StringIO.new()
        
        obj = LEFVia.new(name, false)
        assert(obj)
        assert(obj.get_name() == name)
        exp_lef = sprintf("VIA %s\nEND %s\n\n", name, name)
        obj.write_lef(lef_output)
        assert(lef_output.string == exp_lef,
               sprintf("got '%s' expected '%s'", lef_output.string, exp_lef))
        
        # add layers and check
        # for this test, we'll create the layers in top to bottom order and
        # then verify that they come back in bottom to top order
        obj.add_layer(@top_via_layer)
        obj.add_layer(@cut_via_layer)
        obj.add_layer(@bottom_via_layer)
        
        # check unsorted layer_list
        assert(obj.get_layer_list(false).length == 3)
        
        # check sorted layer_list
        layer_list = obj.get_layer_list()
        assert(layer_list.length == 3)
        assert(layer_list[0] == @bottom_via_layer)
        assert(layer_list[1] == @cut_via_layer)
        assert(layer_list[2] == @top_via_layer)
        
        # check LEF output
        lef_output.rewind
        obj.write_lef(lef_output)
        exp_lef = sprintf("VIA %s\n%s%s%sEND %s\n\n", name,
                          @bottom_via_layer_lef, @cut_via_layer_lef,
                          @top_via_layer_lef, name)
        assert(lef_output.string == exp_lef,
               sprintf("got '%s' expected '%s'", lef_output.string, exp_lef))
    end
end
