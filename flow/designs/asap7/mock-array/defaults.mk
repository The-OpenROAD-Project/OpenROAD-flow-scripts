# single source of truth for defaults.
# each number is a unit
# current unit is configured as 2.16 which is on the routing grid for M5

# table of Elements - (rows cols width height space_x space_y)
# NOTE -> in order to get power between Element's placement, 
#   space_x >= 1
#   space_y >= 2
export MOCK_ARRAY_TABLE         ?= 8 8 4 4 1 2

# Element'd data width
export MOCK_ARRAY_DATAWIDTH     ?= 8

# Must be zero for routing by abutment
export MACRO_BLOCKAGE_HALO      ?= 0.5
