#!/usr/bin/env ruby

require 'test/unit'
require_relative '../src/LEFLayer'

#
# Unit test for LEFLayer
#
class LEFLayerTest < Test::Unit::TestCase
    #
    # Sets up LEFLayer object
    #
    def setup
    end

    #
    # Tests basic operation
    #
    def test_basic
        name = "M1"
        num = 100
        type = "ROUTING"

        # make a M1 and verify contents
        orig_m1 = LEFLayer.new(name, num)
        assert(orig_m1)
        assert(orig_m1.get_type().nil?)
        assert(orig_m1.get_name() == name)
        assert(orig_m1.get_number() == num)
        sha_wo_type = orig_m1.sha256()
        orig_m1.set_type(type)
        assert(orig_m1.get_type() == type)
        orig_m1_sha = orig_m1.sha256()
        assert(orig_m1_sha != sha_wo_type)

        # make a new M1 with a different layer number
        new_m1 = LEFLayer.new(name, num + 1)
        assert(new_m1)
        assert(new_m1.get_type().nil?)
        assert(new_m1.get_name() == name)
        assert(new_m1.get_number() == num + 1)
        new_m1.set_type(type)
        assert(new_m1.get_type() == type)
        new_m1_sha = new_m1.sha256()

        # The sha's should be the same since we are excluding the layer number
        assert(orig_m1_sha == new_m1_sha)
    end
end
