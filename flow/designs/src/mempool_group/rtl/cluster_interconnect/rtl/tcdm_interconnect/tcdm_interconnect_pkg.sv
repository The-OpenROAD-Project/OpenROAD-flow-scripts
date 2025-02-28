// Copyright 2019 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
// Date: 28.05.2019
// Description: Package with important constants and lookup tables for TCDM
// interconnect.

package tcdm_interconnect_pkg;

typedef enum logic [1:0] { LIC, BFLY2, BFLY4, CLOS } topo_e;

////////////////////////////////////////////////////////////////////////
// LUT params for Clos net with configs: 1: m=0.50*n, 2: m=1.00*n, 3: m=2.00*n,
// to be indexed with [config_idx][$clog2(BankingFact)][$clog2(NumBanks)]
// generated with MATLAB script gen_clos_params.m
////////////////////////////////////////////////////////////////////////
localparam logic [3:1][4:0][12:2][15:0] ClosNLut = {16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2};
localparam logic [3:1][4:0][12:2][15:0] ClosMLut = {16'd128,16'd128,16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,
                                                    16'd128,16'd128,16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,
                                                    16'd128,16'd128,16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,
                                                    16'd128,16'd128,16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,
                                                    16'd128,16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,16'd1,
                                                    16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,16'd1,
                                                    16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,16'd1,
                                                    16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,16'd1,
                                                    16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,16'd1,16'd1};
localparam logic [3:1][4:0][12:2][15:0] ClosRLut = {16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2,16'd2,
                                                    16'd64,16'd64,16'd32,16'd32,16'd16,16'd16,16'd8,16'd8,16'd4,16'd4,16'd2};



endpackage : tcdm_interconnect_pkg
