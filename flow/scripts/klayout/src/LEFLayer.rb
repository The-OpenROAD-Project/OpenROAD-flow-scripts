#!/usr/bin/env ruby

require 'digest'
require_relative 'LEFNamedObject'

#
# Class to store LEF layer data
#
class LEFLayer < LEFNamedObject
    #
    # Initializer
    #
    def initialize(name, num, type=nil)
        super(name)
        @num = num
        @type = type
    end

    #
    # Sets the layer type
    #
    def set_type(layer_type)
        @type = layer_type
    end

    #
    # Sets the layer number (order of layer in the tech LEF, which implies
    # layer stacking order
    #
    def get_number()
        return @num
    end

    #
    # Returns the layer type
    #
    def get_type()
        return @type
    end

    #
    # Writes the LEF statement snippet for the layer
    #
    def write_lef(out)
        layer_name = get_name()
        out.puts sprintf("LAYER %s", layer_name)
        out.puts sprintf("  TYPE %s ;", get_type())
        out.puts sprintf("END %s", layer_name)
        out.puts
    end

    #
    # Returns the SHA256 for the layer
    #
    # Layer number is skipped since the layer number could be different between
    # tech LEF versions and we'd like to use this to compare across versions
    #
    def sha256()
        if get_type.nil?
            return Digest::SHA256.hexdigest(get_name())
        end
        return Digest::SHA256.hexdigest(get_name() + get_type())
    end
end
