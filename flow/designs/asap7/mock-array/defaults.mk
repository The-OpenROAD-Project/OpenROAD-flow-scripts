# single source of truth for defaults.
# each number is a unit
# current unit is configured as 2.16 which is on the routing grid for M5

# table of Elements - (rows cols width height pitch_x pitch_y)
export MOCK_ARRAY_TABLE         ?= 8 8 20 20 20 22

# Element'd data width
export MOCK_ARRAY_DATAWIDTH     ?= 64

# Must be zero for routing by abutment
export MACRO_BLOCKAGE_HALO      ?= 0

export MOCK_ARRAY_SCALE         ?= 45
