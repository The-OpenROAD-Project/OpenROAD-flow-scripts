// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

package snitch_icache_pkg;

    typedef struct packed {
      logic l0_miss;
      logic l0_hit;
      logic l0_prefetch;
      logic l0_double_hit;
    } icache_events_t;

    typedef struct packed {
        // Parameters passed to the root module.
        int NR_FETCH_PORTS;
        int LINE_WIDTH;
        int LINE_COUNT;
        int SET_COUNT;
        int PENDING_COUNT;
        int L0_LINE_COUNT;
        int FETCH_AW;
        int FETCH_DW;
        int FILL_AW;
        int FILL_DW;
        bit L1_TAG_SCM;
        bit EARLY_LATCH;

        // Derived values.
        int FETCH_ALIGN;
        int FILL_ALIGN;
        int LINE_ALIGN;
        int COUNT_ALIGN;
        int SET_ALIGN;
        int TAG_WIDTH;
        int L0_TAG_WIDTH;
        int L0_EARLY_TAG_WIDTH;
        int ID_WIDTH_REQ;
        int ID_WIDTH_RESP;
        int PENDING_IW; // refill ID width
    } config_t;

endpackage
