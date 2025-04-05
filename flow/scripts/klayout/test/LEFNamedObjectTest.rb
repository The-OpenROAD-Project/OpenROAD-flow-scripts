#!/usr/bin/env ruby

require 'test/unit'
require_relative '../src/LEFNamedObject'

#
# Unit test for LEFNamedObject
#
class LEFNamedObjectTest < Test::Unit::TestCase
    #
    # Sets up LEFNamedObject object
    #
    def setup
    end

    #
    # Tests basic operation
    #
    def test_basic
        name = "M1"

        obj = LEFNamedObject.new(name)
        assert(obj)
        assert(obj.get_name() == name)
    end
end
