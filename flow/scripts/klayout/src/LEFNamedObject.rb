#!/usr/bin/env ruby

#
# Class for a basic LEF named object
#
class LEFNamedObject
    #
    # Initializer
    #
    def initialize(name)
        @name = name
    end

    #
    # Returns the name
    #
    def get_name()
        return @name
    end
end
