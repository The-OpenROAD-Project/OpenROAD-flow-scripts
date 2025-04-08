#!/usr/bin/env ruby
#
# Extracts via layer stack information from the technology LEF file
#
# Usage: LEFViaData.rb -i tech_lef_file [-s sha_file] [-l layer_lef_file ]
#                     [-v via_lef_file ]
#
# This file needs to be located in ~/.klayout/ruby
#

require 'optparse'
require_relative 'LEFVia'
require_relative 'LEFLayer'

#
# Class to extract via layer stack information from technology LEF
#
class LEFViaData
    #
    # Initialization method
    #
    # via_map: stores the mapping from a key to the list of layers in the stack
    # layer_ct: current layer count - used to set layer numbers establishing
    #           layer stack order
    # start_via_re: regexp to find the start of the LEF VIA statement
    # via_layer_re: regexp to extract the layer name in the via layer stack
    # start_layer_re: regexp to find the start of the LEF LAYER statement
    # rect_re: regexp to extract rect coords
    # layer_type_re: regexp to extract LAYER TYPE
    # end_re: regexp to find the end of a section
    #
    def initialize()
        @layer_map = {}
        @layer_ct = 0
        @via_map = {}
        @start_via_re = /^\s*VIA\s+(\S+)(?i)(\s+DEFAULT)?/
        @via_layer_re = /^\s*LAYER\s+(\S+)\s*\;/
        @start_layer_re = /^\s*LAYER\s+(\S+)\s*$/
        @rect_re = /^\s*RECT\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/
        @layer_type_re = /^\s*TYPE\s+(\S+)/
        @end_re = /^\s*END\s+\S+/
    end

    #
    # Reads the tech LEF and creates the VIA map
    #
    def read_file(file_name)
        fh = File.open(file_name, chomp: true)
        if fh
            read(fh)
            fh.close
        else
            puts "Error: can't open " + file_name
        end
    end

    #
    # Reads the content from a stream and looks for the LEF LAYER and VIA
    # statements. The layers are added to the layer_map and the vias are added
    # to the via_map
    #
    def read(fh)
        while (line = fh.gets)
            result = line.match(@start_via_re)
            if result
                via_name = result[1]
                is_default = result[2]
                via = LEFVia.new(via_name, is_default)
                read_via(fh, via)
                @via_map[via.get_name()] = via
            else
                result = line.match(@start_layer_re)
                if result
                    layer_name = result[1]
                    layer = LEFLayer.new(layer_name, @layer_ct)
                    read_layer(fh, layer)
                    @layer_map[layer_name] = layer
                    @layer_ct += 1
                end
            end
        end
    end

    #
    # Reads the LEF LAYER definition and adds it to the layer object
    #
    def read_layer(fh, layer)
        while (line = fh.gets)
            if line.match(@end_re)
                return
            end
            result = line.match(@layer_type_re)
            if result
                layer.set_type(result[1])
            end
        end
    end

    #
    # Reads the LEF VIA definition and adds it to the via object
    #
    def read_via(fh, via)
        current_layer = nil
        while (line = fh.gets)
            if line.match(@end_re)
                via.add_layer(current_layer)
                return
            end
            result = line.match(@via_layer_re)
            if result
                if current_layer
                    via.add_layer(current_layer)
                end
                current_layer = LEFVia::LEFViaLayer.new(@layer_map[result[1]])
            else
                result = line.match(@rect_re)
                if result
                    rect = [result[1].to_f, result[2].to_f, result[3].to_f, result[4].to_f]
                    current_layer.add_shape(rect)
                end
            end
        end
    end

    #
    # Accessor to get the via map
    #
    def get_map()
        return @via_map
    end

    #
    # Utility method to write out LEF VIA snippet to output stream
    #
    def write_via_lef(outfh)
        @via_map.each do | via_name, via |
            via.write_lef(outfh)
        end
    end

    #
    # Utility method to write out LEF VIA snippet to file
    #
    def write_via_lef_file(file_name)
        outfh = File.open(file_name, "w")
        write_via_lef(outfh)
        outfh.close
    end

    #
    # Utility method to write out SHA list to output stream
    #
    def write_sha(outfh)
        @via_map.each do | via_name, via |
            sha256 = via.sha256()
            outfh.puts sprintf("%s %s", sha256, via_name)
        end
    end

    #
    # Utility method to write out SHA list to output file
    #
    def write_sha_file(file_name)
        outfh = File.open(file_name, "w")
        write_sha(outfh)
        outfh.close
    end
    
    #
    # Utility method to write out LEF LAYER snippet to output stream
    #
    def write_layer_lef(outfh)
        sorted_layer_map = @layer_map.sort_by { |layer_name, layer| layer.get_number }.to_h
        sorted_layer_map.each do | layer_name, layer |
            layer.write_lef(outfh)
        end
    end

    #
    # Utility method to write out LEF LAYER snippet to output file
    #
    def write_layer_lef_file(file_name)
        outfh = File.open(file_name, "w")
        write_layer_lef(outfh)
        outfh.close
    end

    #
    # Standalone main driver
    #
    def LEFViaData.main()
        options = {}
        OptionParser.new do |opts|
            opts.banner = "Usage: LEFViaData.rb -i tech_lef_file [-s <sha_file>] [-l <layer_lef_file>] [-v <via_lef_file]"
            opts.on("-iTECH_LEF_FILE", "--input_file=TECH_LEF_FILE") do |input_file|
                options[:input_file] = input_file
            end
            opts.on("-sSHA_FILE", "--sha_file=SHA_FILE") do |sha_file|
                options[:sha_file] = sha_file
            end
            opts.on("-lLAYER_LEF_FILE", "--layer_lef_file=LAYER_LEF_FILE") do |layer_lef_file|
                options[:layer_lef_file] = layer_lef_file
            end
            opts.on("-vVIA_LEF_FILE", "--via_lef_file=VIA_LEF_FILE") do |via_lef_file|
                options[:via_lef_file] = via_lef_file
            end
        end.parse!

        if options[:input_file]
            rep = LEFViaData.new
            rep.read_file(options[:input_file])
            if options[:sha_file]
                rep.write_sha_file(options[:sha_file])
            end
            if options[:layer_lef_file]
                rep.write_layer_lef_file(options[:layer_lef_file])
            end
            if options[:via_lef_file]
                rep.write_via_lef_file(options[:via_lef_file])
            end
        end
    end
end

#
# Only call the main driver if we're calling this as a script
#
if __FILE__ == $0
    LEFViaData.main()
end
        
