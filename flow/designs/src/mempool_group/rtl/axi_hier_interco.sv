// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

//
// Implement a hierarchical AXI interconnect. Below shows one level of the interconnect. This module
// recursively instantiates itself and creates a tree of interconnects, each with `NumPortsPerMux`
// slave ports.
//
// TODO: Add a configurable cache per level
//
//           AXI Mux       ID Width
//                         Converter
//            |‾╲
//  +-------->|  ╲
//            |   +        +-------+
//  +-------->| M |        |       |
//            | U |------->|   >   |--------->
//            | X |        |       |
//            |   +        +-------+
//  +-------->|  ╱
//            |_╱
//                 Internal
//  Slave type       type          Master type

module axi_hier_interco #(
  parameter int unsigned NumSlvPorts    = 0,
  parameter int unsigned NumPortsPerMux = NumSlvPorts,
  parameter int unsigned EnableCache    = 1'b0,
  parameter int unsigned AddrWidth      = 0,
  parameter int unsigned DataWidth      = 0,
  parameter int unsigned SlvIdWidth     = 0,
  parameter int unsigned MstIdWidth     = 0,
  parameter int unsigned UserWidth      = 0,
  parameter type         slv_req_t      = logic,
  parameter type         slv_resp_t     = logic,
  parameter type         mst_req_t      = logic,
  parameter type         mst_resp_t     = logic
) (
  input  logic                        clk_i,
  input  logic                        rst_ni,
  input  logic                        test_i,
  input  slv_req_t  [NumSlvPorts-1:0] slv_req_i,
  output slv_resp_t [NumSlvPorts-1:0] slv_resp_o,
  output mst_req_t                    mst_req_o,
  input  mst_resp_t                   mst_resp_i
);

  ////////////////
  //  Typedefs  //
  ////////////////

  localparam int unsigned IntIdWidth = SlvIdWidth + $clog2(NumSlvPorts);

  typedef logic [AddrWidth-1:0]   addr_t;
  typedef logic [DataWidth-1:0]   data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [SlvIdWidth-1:0]  slv_id_t;
  typedef logic [MstIdWidth-1:0]  mst_id_t;
  typedef logic [IntIdWidth-1:0]  int_id_t;
  typedef logic [UserWidth-1:0]   user_t;

  `include "axi/typedef.svh"
  // Common AXI types
  `AXI_TYPEDEF_W_CHAN_T(w_t, data_t, strb_t, user_t);
  // Slave AXI types
  `AXI_TYPEDEF_AW_CHAN_T(slv_aw_t, addr_t, slv_id_t, user_t);
  `AXI_TYPEDEF_B_CHAN_T(slv_b_t, slv_id_t, user_t);
  `AXI_TYPEDEF_AR_CHAN_T(slv_ar_t, addr_t, slv_id_t, user_t);
  `AXI_TYPEDEF_R_CHAN_T(slv_r_t, data_t, slv_id_t, user_t);
  // Intermediate AXI types
  `AXI_TYPEDEF_AW_CHAN_T(int_aw_t, addr_t, int_id_t, user_t);
  `AXI_TYPEDEF_B_CHAN_T(int_b_t, int_id_t, user_t);
  `AXI_TYPEDEF_AR_CHAN_T(int_ar_t, addr_t, int_id_t, user_t);
  `AXI_TYPEDEF_R_CHAN_T(int_r_t, data_t, int_id_t, user_t);
  `AXI_TYPEDEF_REQ_T(int_req_t, int_aw_t, w_t, int_ar_t);
  `AXI_TYPEDEF_RESP_T(int_resp_t, int_b_t, int_r_t );

  ///////////////
  //  Interco  //
  ///////////////

  // Recursive module to implement multiple hierarchy levels at once

  if (NumSlvPorts <= NumPortsPerMux) begin : gen_axi_level_final

    // Intermediate AXI channel
    int_req_t  int_req;
    int_resp_t int_resp;

    axi_mux #(
      // AXI parameter and channel types
      .SlvAxiIDWidth (SlvIdWidth ), // AXI ID width, slave ports
      .slv_aw_chan_t (slv_aw_t   ), // AW Channel Type, slave ports
      .mst_aw_chan_t (int_aw_t   ), // AW Channel Type, master port
      .w_chan_t      (w_t        ), //  W Channel Type, all ports
      .slv_b_chan_t  (slv_b_t    ), //  B Channel Type, slave ports
      .mst_b_chan_t  (int_b_t    ), //  B Channel Type, master port
      .slv_ar_chan_t (slv_ar_t   ), // AR Channel Type, slave ports
      .mst_ar_chan_t (int_ar_t   ), // AR Channel Type, master port
      .slv_r_chan_t  (slv_r_t    ), //  R Channel Type, slave ports
      .mst_r_chan_t  (int_r_t    ), //  R Channel Type, master port
      .slv_req_t     (slv_req_t  ), // Slave port request type
      .slv_resp_t    (slv_resp_t ), // Slave port response type
      .mst_req_t     (int_req_t  ), // Master ports request type
      .mst_resp_t    (int_resp_t ), // Master ports response type
      .NoSlvPorts    (NumSlvPorts), // Number of slave ports
      // Maximum number of outstanding transactions per write
      .MaxWTrans     (8          ),
      // If enabled, this multiplexer is purely combinatorial
      .FallThrough   (1'b0       ),
      // add spill register on write master ports, adds a cycle latency on write channels
      .SpillAw       (1'b1       ),
      .SpillW        (1'b1       ),
      .SpillB        (1'b1       ),
      // add spill register on read master ports, adds a cycle latency on read channels
      .SpillAr       (1'b1       ),
      .SpillR        (1'b1       )
    ) i_axi_mux (
      .clk_i       (clk_i     ),
      .rst_ni      (rst_ni    ),
      .test_i      (test_i    ),
      .slv_reqs_i  (slv_req_i ),
      .slv_resps_o (slv_resp_o),
      .mst_req_o   (int_req   ),
      .mst_resp_i  (int_resp  )
    );

    axi_id_remap #(
      .AxiSlvPortIdWidth    (IntIdWidth),
      .AxiSlvPortMaxUniqIds (IntIdWidth),
      .AxiMaxTxnsPerId      (4         ),
      .AxiMstPortIdWidth    (MstIdWidth),
      .slv_req_t            (int_req_t ),
      .slv_resp_t           (int_resp_t),
      .mst_req_t            (mst_req_t ),
      .mst_resp_t           (mst_resp_t)
    ) i_axi_id_remap (
      .clk_i      (clk_i     ),
      .rst_ni     (rst_ni    ),
      .slv_req_i  (int_req   ),
      .slv_resp_o (int_resp  ),
      .mst_req_o  (mst_req_o ),
      .mst_resp_i (mst_resp_i)
    );

    // TODO: Implement cache
    if (EnableCache[0])
      $error("[axi_hier_interco] `EnableCache` not yet supported.");
    // Check all the AXI widths
    if ($bits(slv_req_i[0].aw.addr) != AddrWidth)
      $error("[axi_hier_interco] `slv_req_i.aw.addr` does not match AddrWidth.");
    if ($bits(slv_req_i[0].w.data) != DataWidth)
      $error("[axi_hier_interco] `slv_req_i.w.data` does not match DataWidth.");
    if ($bits(slv_req_i[0].aw.id) != SlvIdWidth)
      $error("[axi_hier_interco] `slv_req_i.aw.id` does not match SlvIdWidth.");
    if ($bits(slv_req_i[0].aw.user) != UserWidth)
      $error("[axi_hier_interco] `slv_req_i.aw.user` does not match UserWidth.");

    if ($bits(mst_req_o.aw.addr) != AddrWidth)
      $error("[axi_hier_interco] `mst_req_o.aw.addr` does not match AddrWidth.");
    if ($bits(mst_req_o.w.data) != DataWidth)
      $error("[axi_hier_interco] `mst_req_o.w.data` does not match DataWidth.");
    if ($bits(mst_req_o.aw.id) != MstIdWidth)
      $error("[axi_hier_interco] `mst_req_o.aw.id` does not match MstIdWidth.");
    if ($bits(mst_req_o.aw.user) != UserWidth)
      $error("[axi_hier_interco] `mst_req_o.aw.user` does not match UserWidth.");

    if ($bits(int_req.aw.addr) != AddrWidth)
      $error("[axi_hier_interco] `int_req.aw.addr` does not match AddrWidth.");
    if ($bits(int_req.w.data) != DataWidth)
      $error("[axi_hier_interco] `int_req.w.data` does not match DataWidth.");
    if ($bits(int_req.aw.id) != IntIdWidth)
      $error("[axi_hier_interco] `int_req.aw.id` does not match IntIdWidth.");
    if ($bits(int_req.aw.user) != UserWidth)
      $error("[axi_hier_interco] `int_req.aw.user` does not match UserWidth.");
  end else begin : gen_axi_level_recursive
    // More than one level missing. --> Recursively call this module
    // This level will contain `NumMuxes` interconnects
    localparam int unsigned NumMuxes = NumSlvPorts / NumPortsPerMux;

    slv_req_t  [NumMuxes-1:0] int_req;
    slv_resp_t [NumMuxes-1:0] int_resp;

    for (genvar i = 0; i < NumMuxes; i++) begin : gen_axi_intercos
      axi_hier_interco #(
        .NumSlvPorts    (NumPortsPerMux),
        .NumPortsPerMux (NumPortsPerMux),
        .EnableCache    (EnableCache[0]),
        .AddrWidth      (AddrWidth     ),
        .DataWidth      (DataWidth     ),
        .SlvIdWidth     (SlvIdWidth    ),
        .MstIdWidth     (SlvIdWidth    ),
        .UserWidth      (UserWidth     ),
        .slv_req_t      (slv_req_t     ),
        .slv_resp_t     (slv_resp_t    ),
        .mst_req_t      (slv_req_t     ),
        .mst_resp_t     (slv_resp_t    )
      ) i_axi_interco (
        .clk_i      (clk_i                                         ),
        .rst_ni     (rst_ni                                        ),
        .test_i     (test_i                                        ),
        .slv_req_i  (slv_req_i[i*NumPortsPerMux +: NumPortsPerMux] ),
        .slv_resp_o (slv_resp_o[i*NumPortsPerMux +: NumPortsPerMux]),
        .mst_req_o  (int_req[i]                                    ),
        .mst_resp_i (int_resp[i]                                   )
      );
    end

    axi_hier_interco #(
      .NumSlvPorts    (NumMuxes      ),
      .NumPortsPerMux (NumPortsPerMux),
      .EnableCache    (EnableCache>>1),
      .AddrWidth      (AddrWidth     ),
      .DataWidth      (DataWidth     ),
      .SlvIdWidth     (SlvIdWidth    ),
      .MstIdWidth     (MstIdWidth    ),
      .UserWidth      (UserWidth     ),
      .slv_req_t      (slv_req_t     ),
      .slv_resp_t     (slv_resp_t    ),
      .mst_req_t      (mst_req_t     ),
      .mst_resp_t     (mst_resp_t    )
    ) i_axi_interco (
      .clk_i      (clk_i     ),
      .rst_ni     (rst_ni    ),
      .test_i     (test_i    ),
      .slv_req_i  (int_req   ),
      .slv_resp_o (int_resp  ),
      .mst_req_o  (mst_req_o ),
      .mst_resp_i (mst_resp_i)
    );

    if (NumMuxes * NumPortsPerMux != NumSlvPorts)
      $error("[axi_hier_interco] `NumSlvPorts mod NumPortsPerMux` must be 0.");
  end

  if (NumPortsPerMux <= 1)
    $error("[axi_hier_interco] `NumPortsPerMux` must be bigger than 1.");

endmodule
