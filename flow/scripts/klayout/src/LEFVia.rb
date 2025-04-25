#!/usr/bin/env ruby

require 'digest'
require 'json'
require_relative 'LEFNamedObject'

#
# Class to store LEF via information
#
class LEFVia < LEFNamedObject
    #
    # Container class that store information about the and shapes that are part
    # of the via that exist on the specified layer. Only RECTs are supported.
    #
    class LEFViaLayer
        #
        # Initializer
        #
        # layer is a ref to a LEFLayer
        # shape_list is the list of shapes for the via on the specified layer
        #
        def initialize(layer)
            # make sure this is a LEFLayer
            if !layer.is_a?(LEFLayer)
                raise ArgumentError, sprintf("LEFViaLayer initialize expects LEFLayer, got %s", layer.class.name)
            end
            @layer = layer
            @shape_list = []
        end

        #
        # Adds a shape to the shape list
        #
        def add_shape(shape)
            @shape_list << shape
        end

        #
        # Returns the LEF layer for the shapes
        #
        def get_layer()
            return @layer
        end

        #
        # Returns the shape list
        #
        def get_shape_list()
            return @shape_list
        end

        #
        # Computes and returns the sha256 for the container
        #
        def sha256()
            layer_sha = get_layer().sha256()
            serialized_shapes = JSON.generate(get_shape_list)
            shape_list_sha = Digest::SHA256.hexdigest(serialized_shapes)
            return Digest::SHA256.hexdigest(layer_sha + shape_list_sha)
        end

        #
        # Writes the LEF snippet for the container
        #
        def write_lef(outfh)
            outfh.puts sprintf("  LAYER %s ;", get_layer().get_name())
            get_shape_list.each do | rect |
                outfh.puts sprintf("  RECT %5.3f %5.3f %5.3f %5.3f ;", rect[0],
                                   rect[1], rect[2], rect[3])
            end
        end
    end

    #
    # Initializer
    #
    # layer_list is a list of LEFViaLayers, which is unsorted. That way whoever
    # is creating the via can just add LEFViaLayers without regard for the
    # layer stacking order.
    #
    def initialize(name, is_default=false)
        super(name)
        @is_default = is_default

        # List of LEFViaLayers - unsorted
        @layer_list = []
    end

    #
    # Computes and returns the sha256 for the via
    #
    def sha256()
        layer_stack = get_layer_list()
        hashes = get_layer_list.map { |layer| layer.sha256 }
        concat_hashes = hashes.join
        return Digest::SHA256.hexdigest(concat_hashes)
    end

    #
    # Returns the LEFViaLayer list for the via
    #
    # default is to sort the layers, by the layer number. That way it's returned
    # bottom layer to top layer
    #
    def get_layer_list(sorted=true)
        if sorted
            return @layer_list.sort_by { |layer| layer.get_layer().get_number }
        end
        return @layer_list
    end

    #
    # Adds a layer to the layer list
    #
    def add_layer(layer)
        @layer_list << layer
    end

    #
    # Writes the LEF snippet
    #
    def write_lef(outfh)
        via_name = get_name()
        if @is_default
            default_str = " DEFAULT"
        else
            default_str = ""
        end
        outfh.puts sprintf("VIA %s%s", via_name, default_str)
        get_layer_list().each do | layer |
            layer.write_lef(outfh)
        end
        outfh.puts sprintf("END %s", via_name)
        outfh.puts
    end
end
