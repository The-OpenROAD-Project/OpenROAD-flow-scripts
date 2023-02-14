Mock array big
==============

A mock array that can be configured in different sizes to generate
interesting test-cases.

By default, the array is 8x8 elements and has an 8 bit datapath.

To create a 4x4 element array with 4 bit datapath, run:

    MOCK_ARRAY_WIDTH=4 MOCK_ARRAY_HEIGHT=4 MOCK_ARRAY_DATAWIDTH=4 ./configure.sh
    MOCK_ARRAY_WIDTH=4 MOCK_ARRAY_HEIGHT=4 MOCK_ARRAY_DATAWIDTH=4 make DESIGN_CONFIG=designs/asap7/mock-array-big/config.mk
