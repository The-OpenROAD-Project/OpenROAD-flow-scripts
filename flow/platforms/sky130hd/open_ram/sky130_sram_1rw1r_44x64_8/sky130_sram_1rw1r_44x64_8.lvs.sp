**************************************************
* OpenRAM generated memory.
* Words: 64
* Data bits: 44
* Banks: 1
* Column mux: 1:1
**************************************************
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

* SPICE3 file created from sky130_fd_bd_sram__openram_sram_dff.ext - technology: EFS8A

.subckt sky130_fd_bd_sram__openram_sram_dff D Q CLK VDD GND
X1000 a_511_725# a_n8_115# VDD VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1001 a_353_115# CLK a_11_624# GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1002 a_353_725# a_203_89# a_11_624# VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1003 a_11_624# a_203_89# a_161_115# GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1004 a_11_624# CLK a_161_725# VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1005 GND Q a_703_115# GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1006 VDD Q a_703_725# VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1007 a_203_89# CLK GND GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1008 a_203_89# CLK VDD VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1009 a_161_115# D GND GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1010 a_161_725# D VDD VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1011 GND a_11_624# a_n8_115# GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1012 a_703_115# a_203_89# ON GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1013 VDD a_11_624# a_n8_115# VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1014 a_703_725# CLK ON VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1015 Q ON VDD VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1016 Q ON GND GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1017 ON a_203_89# a_511_725# VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1018 ON CLK a_511_115# GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1019 GND a_n8_115# a_353_115# GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X1020 VDD a_n8_115# a_353_725# VDD sky130_fd_pr__pfet_01v8 W=3u L=0.15u m=1
X1021 a_511_115# a_n8_115# GND GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
.ends

.SUBCKT row_addr_dff din_0 din_1 din_2 din_3 din_4 din_5 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 clk vdd gnd
*.PININFO din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O clk:I vdd:B gnd:B
* INPUT : din_0 
* INPUT : din_1 
* INPUT : din_2 
* INPUT : din_3 
* INPUT : din_4 
* INPUT : din_5 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 6 cols: 1
Xdff_r0_c0 din_0 dout_0 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r1_c0 din_1 dout_1 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r2_c0 din_2 dout_2 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r3_c0 din_3 dout_3 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r4_c0 din_4 dout_4 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r5_c0 din_5 dout_5 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
.ENDS row_addr_dff

.SUBCKT data_dff din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 din_8 din_9 din_10 din_11 din_12 din_13 din_14 din_15 din_16 din_17 din_18 din_19 din_20 din_21 din_22 din_23 din_24 din_25 din_26 din_27 din_28 din_29 din_30 din_31 din_32 din_33 din_34 din_35 din_36 din_37 din_38 din_39 din_40 din_41 din_42 din_43 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 dout_8 dout_9 dout_10 dout_11 dout_12 dout_13 dout_14 dout_15 dout_16 dout_17 dout_18 dout_19 dout_20 dout_21 dout_22 dout_23 dout_24 dout_25 dout_26 dout_27 dout_28 dout_29 dout_30 dout_31 dout_32 dout_33 dout_34 dout_35 dout_36 dout_37 dout_38 dout_39 dout_40 dout_41 dout_42 dout_43 clk vdd gnd
*.PININFO din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I din_6:I din_7:I din_8:I din_9:I din_10:I din_11:I din_12:I din_13:I din_14:I din_15:I din_16:I din_17:I din_18:I din_19:I din_20:I din_21:I din_22:I din_23:I din_24:I din_25:I din_26:I din_27:I din_28:I din_29:I din_30:I din_31:I din_32:I din_33:I din_34:I din_35:I din_36:I din_37:I din_38:I din_39:I din_40:I din_41:I din_42:I din_43:I dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O dout_8:O dout_9:O dout_10:O dout_11:O dout_12:O dout_13:O dout_14:O dout_15:O dout_16:O dout_17:O dout_18:O dout_19:O dout_20:O dout_21:O dout_22:O dout_23:O dout_24:O dout_25:O dout_26:O dout_27:O dout_28:O dout_29:O dout_30:O dout_31:O dout_32:O dout_33:O dout_34:O dout_35:O dout_36:O dout_37:O dout_38:O dout_39:O dout_40:O dout_41:O dout_42:O dout_43:O clk:I vdd:B gnd:B
* INPUT : din_0 
* INPUT : din_1 
* INPUT : din_2 
* INPUT : din_3 
* INPUT : din_4 
* INPUT : din_5 
* INPUT : din_6 
* INPUT : din_7 
* INPUT : din_8 
* INPUT : din_9 
* INPUT : din_10 
* INPUT : din_11 
* INPUT : din_12 
* INPUT : din_13 
* INPUT : din_14 
* INPUT : din_15 
* INPUT : din_16 
* INPUT : din_17 
* INPUT : din_18 
* INPUT : din_19 
* INPUT : din_20 
* INPUT : din_21 
* INPUT : din_22 
* INPUT : din_23 
* INPUT : din_24 
* INPUT : din_25 
* INPUT : din_26 
* INPUT : din_27 
* INPUT : din_28 
* INPUT : din_29 
* INPUT : din_30 
* INPUT : din_31 
* INPUT : din_32 
* INPUT : din_33 
* INPUT : din_34 
* INPUT : din_35 
* INPUT : din_36 
* INPUT : din_37 
* INPUT : din_38 
* INPUT : din_39 
* INPUT : din_40 
* INPUT : din_41 
* INPUT : din_42 
* INPUT : din_43 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* OUTPUT: dout_6 
* OUTPUT: dout_7 
* OUTPUT: dout_8 
* OUTPUT: dout_9 
* OUTPUT: dout_10 
* OUTPUT: dout_11 
* OUTPUT: dout_12 
* OUTPUT: dout_13 
* OUTPUT: dout_14 
* OUTPUT: dout_15 
* OUTPUT: dout_16 
* OUTPUT: dout_17 
* OUTPUT: dout_18 
* OUTPUT: dout_19 
* OUTPUT: dout_20 
* OUTPUT: dout_21 
* OUTPUT: dout_22 
* OUTPUT: dout_23 
* OUTPUT: dout_24 
* OUTPUT: dout_25 
* OUTPUT: dout_26 
* OUTPUT: dout_27 
* OUTPUT: dout_28 
* OUTPUT: dout_29 
* OUTPUT: dout_30 
* OUTPUT: dout_31 
* OUTPUT: dout_32 
* OUTPUT: dout_33 
* OUTPUT: dout_34 
* OUTPUT: dout_35 
* OUTPUT: dout_36 
* OUTPUT: dout_37 
* OUTPUT: dout_38 
* OUTPUT: dout_39 
* OUTPUT: dout_40 
* OUTPUT: dout_41 
* OUTPUT: dout_42 
* OUTPUT: dout_43 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 1 cols: 44
Xdff_r0_c0 din_0 dout_0 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c1 din_1 dout_1 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c2 din_2 dout_2 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c3 din_3 dout_3 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c4 din_4 dout_4 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c5 din_5 dout_5 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c6 din_6 dout_6 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c7 din_7 dout_7 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c8 din_8 dout_8 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c9 din_9 dout_9 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c10 din_10 dout_10 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c11 din_11 dout_11 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c12 din_12 dout_12 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c13 din_13 dout_13 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c14 din_14 dout_14 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c15 din_15 dout_15 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c16 din_16 dout_16 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c17 din_17 dout_17 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c18 din_18 dout_18 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c19 din_19 dout_19 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c20 din_20 dout_20 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c21 din_21 dout_21 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c22 din_22 dout_22 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c23 din_23 dout_23 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c24 din_24 dout_24 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c25 din_25 dout_25 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c26 din_26 dout_26 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c27 din_27 dout_27 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c28 din_28 dout_28 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c29 din_29 dout_29 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c30 din_30 dout_30 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c31 din_31 dout_31 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c32 din_32 dout_32 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c33 din_33 dout_33 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c34 din_34 dout_34 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c35 din_35 dout_35 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c36 din_36 dout_36 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c37 din_37 dout_37 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c38 din_38 dout_38 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c39 din_39 dout_39 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c40 din_40 dout_40 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c41 din_41 dout_41 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c42 din_42 dout_42 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c43 din_43 dout_43 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
.ENDS data_dff

.SUBCKT wmask_dff din_0 din_1 din_2 din_3 din_4 din_5 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 clk vdd gnd
*.PININFO din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O clk:I vdd:B gnd:B
* INPUT : din_0 
* INPUT : din_1 
* INPUT : din_2 
* INPUT : din_3 
* INPUT : din_4 
* INPUT : din_5 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 1 cols: 6
Xdff_r0_c0 din_0 dout_0 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c1 din_1 dout_1 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c2 din_2 dout_2 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c3 din_3 dout_3 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c4 din_4 dout_4 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c5 din_5 dout_5 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
.ENDS wmask_dff
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

* NGSPICE file created from sky130_fd_bd_sram__openram_dp_nand2_dec.ext - technology: EFS8A


* Top level circuit sky130_fd_bd_sram__openram_dp_nand2_dec
.subckt sky130_fd_bd_sram__openram_dp_nand2_dec A B Z VDD GND

M1001 Z B VDD VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1002 VDD A Z VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1000 Z A a_n722_276# GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1003 a_n722_276# B GND GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
.ends


* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=0.36 l=0.15 pd=1.02 ps=1.02 as=0.14u ad=0.14u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=1 w=1.12 l=0.15 pd=2.54 ps=2.54 as=0.42u ad=0.42u

.SUBCKT pinv_dec A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_dec

.SUBCKT and2_dec A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* size: 1
Xpand2_dec_nand A B zb_int vdd gnd sky130_fd_bd_sram__openram_dp_nand2_dec
Xpand2_dec_inv zb_int Z vdd gnd pinv_dec
.ENDS and2_dec
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

* NGSPICE file created from sky130_fd_bd_sram__openram_dp_nand3_dec.ext - technology: EFS8A


* Top level circuit sky130_fd_bd_sram__openram_dp_nand3_dec
.subckt sky130_fd_bd_sram__openram_dp_nand3_dec A B C Z VDD GND

M1001 Z A a_n346_328# GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1002 a_n346_256# C GND GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1003 a_n346_328# B a_n346_256# GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1000 Z B VDD VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1004 Z A VDD VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1005 Z C VDD VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
.ends


.SUBCKT and3_dec A B C Z vdd gnd
*.PININFO A:I B:I C:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* INPUT : C 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* size: 1
Xpand3_dec_nand A B C zb_int vdd gnd sky130_fd_bd_sram__openram_dp_nand3_dec
Xpand3_dec_inv zb_int Z vdd gnd pinv_dec
.ENDS and3_dec

.SUBCKT hierarchical_predecode2x4 in_0 in_1 out_0 out_1 out_2 out_3 vdd gnd
*.PININFO in_0:I in_1:I out_0:O out_1:O out_2:O out_3:O vdd:B gnd:B
* INPUT : in_0 
* INPUT : in_1 
* OUTPUT: out_0 
* OUTPUT: out_1 
* OUTPUT: out_2 
* OUTPUT: out_3 
* POWER : vdd 
* GROUND: gnd 
Xpre_inv_0 in_0 inbar_0 vdd gnd pinv_dec
Xpre_inv_1 in_1 inbar_1 vdd gnd pinv_dec
XXpre2x4_and_0 inbar_0 inbar_1 out_0 vdd gnd and2_dec
XXpre2x4_and_1 in_0 inbar_1 out_1 vdd gnd and2_dec
XXpre2x4_and_2 inbar_0 in_1 out_2 vdd gnd and2_dec
XXpre2x4_and_3 in_0 in_1 out_3 vdd gnd and2_dec
.ENDS hierarchical_predecode2x4

.SUBCKT hierarchical_predecode3x8 in_0 in_1 in_2 out_0 out_1 out_2 out_3 out_4 out_5 out_6 out_7 vdd gnd
*.PININFO in_0:I in_1:I in_2:I out_0:O out_1:O out_2:O out_3:O out_4:O out_5:O out_6:O out_7:O vdd:B gnd:B
* INPUT : in_0 
* INPUT : in_1 
* INPUT : in_2 
* OUTPUT: out_0 
* OUTPUT: out_1 
* OUTPUT: out_2 
* OUTPUT: out_3 
* OUTPUT: out_4 
* OUTPUT: out_5 
* OUTPUT: out_6 
* OUTPUT: out_7 
* POWER : vdd 
* GROUND: gnd 
Xpre_inv_0 in_0 inbar_0 vdd gnd pinv_dec
Xpre_inv_1 in_1 inbar_1 vdd gnd pinv_dec
Xpre_inv_2 in_2 inbar_2 vdd gnd pinv_dec
XXpre3x8_and_0 inbar_0 inbar_1 inbar_2 out_0 vdd gnd and3_dec
XXpre3x8_and_1 in_0 inbar_1 inbar_2 out_1 vdd gnd and3_dec
XXpre3x8_and_2 inbar_0 in_1 inbar_2 out_2 vdd gnd and3_dec
XXpre3x8_and_3 in_0 in_1 inbar_2 out_3 vdd gnd and3_dec
XXpre3x8_and_4 inbar_0 inbar_1 in_2 out_4 vdd gnd and3_dec
XXpre3x8_and_5 in_0 inbar_1 in_2 out_5 vdd gnd and3_dec
XXpre3x8_and_6 inbar_0 in_1 in_2 out_6 vdd gnd and3_dec
XXpre3x8_and_7 in_0 in_1 in_2 out_7 vdd gnd and3_dec
.ENDS hierarchical_predecode3x8
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

* NGSPICE file created from sky130_fd_bd_sram__openram_dp_nand4_dec.ext - technology: EFS8A

.subckt sky130_fd_bd_sram__openram_dp_nand4_dec A B C D Z VDD GND
M1000 Z A a_406_334# GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1004 a_406_190# D GND GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1005 a_406_262# C a_406_190# GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1007 a_406_334# B a_406_262# GND sky130_fd_pr__nfet_01v8 W=0.74u L=0.15u m=1
M1001 Z A VDD VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1002 VDD C Z VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1003 VDD D Z VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
M1006 Z B VDD VDD sky130_fd_pr__pfet_01v8 W=1.12u L=0.15u m=1
.ends


.SUBCKT and4_dec A B C D Z vdd gnd
*.PININFO A:I B:I C:I D:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* INPUT : C 
* INPUT : D 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* size: 1
Xpand4_dec_nand A B C D zb_int vdd gnd sky130_fd_bd_sram__openram_dp_nand4_dec
Xpand4_dec_inv zb_int Z vdd gnd pinv_dec
.ENDS and4_dec

.SUBCKT hierarchical_predecode4x16 in_0 in_1 in_2 in_3 out_0 out_1 out_2 out_3 out_4 out_5 out_6 out_7 out_8 out_9 out_10 out_11 out_12 out_13 out_14 out_15 vdd gnd
*.PININFO in_0:I in_1:I in_2:I in_3:I out_0:O out_1:O out_2:O out_3:O out_4:O out_5:O out_6:O out_7:O out_8:O out_9:O out_10:O out_11:O out_12:O out_13:O out_14:O out_15:O vdd:B gnd:B
* INPUT : in_0 
* INPUT : in_1 
* INPUT : in_2 
* INPUT : in_3 
* OUTPUT: out_0 
* OUTPUT: out_1 
* OUTPUT: out_2 
* OUTPUT: out_3 
* OUTPUT: out_4 
* OUTPUT: out_5 
* OUTPUT: out_6 
* OUTPUT: out_7 
* OUTPUT: out_8 
* OUTPUT: out_9 
* OUTPUT: out_10 
* OUTPUT: out_11 
* OUTPUT: out_12 
* OUTPUT: out_13 
* OUTPUT: out_14 
* OUTPUT: out_15 
* POWER : vdd 
* GROUND: gnd 
Xpre_inv_0 in_0 inbar_0 vdd gnd pinv_dec
Xpre_inv_1 in_1 inbar_1 vdd gnd pinv_dec
Xpre_inv_2 in_2 inbar_2 vdd gnd pinv_dec
Xpre_inv_3 in_3 inbar_3 vdd gnd pinv_dec
XXpre4x16_and_0 inbar_0 inbar_1 inbar_2 inbar_3 out_0 vdd gnd and4_dec
XXpre4x16_and_1 in_0 inbar_1 inbar_2 inbar_3 out_1 vdd gnd and4_dec
XXpre4x16_and_2 inbar_0 in_1 inbar_2 inbar_3 out_2 vdd gnd and4_dec
XXpre4x16_and_3 in_0 in_1 inbar_2 inbar_3 out_3 vdd gnd and4_dec
XXpre4x16_and_4 inbar_0 inbar_1 in_2 inbar_3 out_4 vdd gnd and4_dec
XXpre4x16_and_5 in_0 inbar_1 in_2 inbar_3 out_5 vdd gnd and4_dec
XXpre4x16_and_6 inbar_0 in_1 in_2 inbar_3 out_6 vdd gnd and4_dec
XXpre4x16_and_7 in_0 in_1 in_2 inbar_3 out_7 vdd gnd and4_dec
XXpre4x16_and_8 inbar_0 inbar_1 inbar_2 in_3 out_8 vdd gnd and4_dec
XXpre4x16_and_9 in_0 inbar_1 inbar_2 in_3 out_9 vdd gnd and4_dec
XXpre4x16_and_10 inbar_0 in_1 inbar_2 in_3 out_10 vdd gnd and4_dec
XXpre4x16_and_11 in_0 in_1 inbar_2 in_3 out_11 vdd gnd and4_dec
XXpre4x16_and_12 inbar_0 inbar_1 in_2 in_3 out_12 vdd gnd and4_dec
XXpre4x16_and_13 in_0 inbar_1 in_2 in_3 out_13 vdd gnd and4_dec
XXpre4x16_and_14 inbar_0 in_1 in_2 in_3 out_14 vdd gnd and4_dec
XXpre4x16_and_15 in_0 in_1 in_2 in_3 out_15 vdd gnd and4_dec
.ENDS hierarchical_predecode4x16

.SUBCKT hierarchical_decoder addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 decode_0 decode_1 decode_2 decode_3 decode_4 decode_5 decode_6 decode_7 decode_8 decode_9 decode_10 decode_11 decode_12 decode_13 decode_14 decode_15 decode_16 decode_17 decode_18 decode_19 decode_20 decode_21 decode_22 decode_23 decode_24 decode_25 decode_26 decode_27 decode_28 decode_29 decode_30 decode_31 decode_32 decode_33 decode_34 decode_35 decode_36 decode_37 decode_38 decode_39 decode_40 decode_41 decode_42 decode_43 decode_44 decode_45 decode_46 decode_47 decode_48 decode_49 decode_50 decode_51 decode_52 decode_53 decode_54 decode_55 decode_56 decode_57 decode_58 decode_59 decode_60 decode_61 decode_62 decode_63 vdd gnd
*.PININFO addr_0:I addr_1:I addr_2:I addr_3:I addr_4:I addr_5:I decode_0:O decode_1:O decode_2:O decode_3:O decode_4:O decode_5:O decode_6:O decode_7:O decode_8:O decode_9:O decode_10:O decode_11:O decode_12:O decode_13:O decode_14:O decode_15:O decode_16:O decode_17:O decode_18:O decode_19:O decode_20:O decode_21:O decode_22:O decode_23:O decode_24:O decode_25:O decode_26:O decode_27:O decode_28:O decode_29:O decode_30:O decode_31:O decode_32:O decode_33:O decode_34:O decode_35:O decode_36:O decode_37:O decode_38:O decode_39:O decode_40:O decode_41:O decode_42:O decode_43:O decode_44:O decode_45:O decode_46:O decode_47:O decode_48:O decode_49:O decode_50:O decode_51:O decode_52:O decode_53:O decode_54:O decode_55:O decode_56:O decode_57:O decode_58:O decode_59:O decode_60:O decode_61:O decode_62:O decode_63:O vdd:B gnd:B
* INPUT : addr_0 
* INPUT : addr_1 
* INPUT : addr_2 
* INPUT : addr_3 
* INPUT : addr_4 
* INPUT : addr_5 
* OUTPUT: decode_0 
* OUTPUT: decode_1 
* OUTPUT: decode_2 
* OUTPUT: decode_3 
* OUTPUT: decode_4 
* OUTPUT: decode_5 
* OUTPUT: decode_6 
* OUTPUT: decode_7 
* OUTPUT: decode_8 
* OUTPUT: decode_9 
* OUTPUT: decode_10 
* OUTPUT: decode_11 
* OUTPUT: decode_12 
* OUTPUT: decode_13 
* OUTPUT: decode_14 
* OUTPUT: decode_15 
* OUTPUT: decode_16 
* OUTPUT: decode_17 
* OUTPUT: decode_18 
* OUTPUT: decode_19 
* OUTPUT: decode_20 
* OUTPUT: decode_21 
* OUTPUT: decode_22 
* OUTPUT: decode_23 
* OUTPUT: decode_24 
* OUTPUT: decode_25 
* OUTPUT: decode_26 
* OUTPUT: decode_27 
* OUTPUT: decode_28 
* OUTPUT: decode_29 
* OUTPUT: decode_30 
* OUTPUT: decode_31 
* OUTPUT: decode_32 
* OUTPUT: decode_33 
* OUTPUT: decode_34 
* OUTPUT: decode_35 
* OUTPUT: decode_36 
* OUTPUT: decode_37 
* OUTPUT: decode_38 
* OUTPUT: decode_39 
* OUTPUT: decode_40 
* OUTPUT: decode_41 
* OUTPUT: decode_42 
* OUTPUT: decode_43 
* OUTPUT: decode_44 
* OUTPUT: decode_45 
* OUTPUT: decode_46 
* OUTPUT: decode_47 
* OUTPUT: decode_48 
* OUTPUT: decode_49 
* OUTPUT: decode_50 
* OUTPUT: decode_51 
* OUTPUT: decode_52 
* OUTPUT: decode_53 
* OUTPUT: decode_54 
* OUTPUT: decode_55 
* OUTPUT: decode_56 
* OUTPUT: decode_57 
* OUTPUT: decode_58 
* OUTPUT: decode_59 
* OUTPUT: decode_60 
* OUTPUT: decode_61 
* OUTPUT: decode_62 
* OUTPUT: decode_63 
* POWER : vdd 
* GROUND: gnd 
Xpre_0 addr_0 addr_1 out_0 out_1 out_2 out_3 vdd gnd hierarchical_predecode2x4
Xpre_1 addr_2 addr_3 out_4 out_5 out_6 out_7 vdd gnd hierarchical_predecode2x4
Xpre_2 addr_4 addr_5 out_8 out_9 out_10 out_11 vdd gnd hierarchical_predecode2x4
XDEC_AND_0 out_0 out_4 out_8 decode_0 vdd gnd and3_dec
XDEC_AND_16 out_0 out_4 out_9 decode_16 vdd gnd and3_dec
XDEC_AND_32 out_0 out_4 out_10 decode_32 vdd gnd and3_dec
XDEC_AND_48 out_0 out_4 out_11 decode_48 vdd gnd and3_dec
XDEC_AND_4 out_0 out_5 out_8 decode_4 vdd gnd and3_dec
XDEC_AND_20 out_0 out_5 out_9 decode_20 vdd gnd and3_dec
XDEC_AND_36 out_0 out_5 out_10 decode_36 vdd gnd and3_dec
XDEC_AND_52 out_0 out_5 out_11 decode_52 vdd gnd and3_dec
XDEC_AND_8 out_0 out_6 out_8 decode_8 vdd gnd and3_dec
XDEC_AND_24 out_0 out_6 out_9 decode_24 vdd gnd and3_dec
XDEC_AND_40 out_0 out_6 out_10 decode_40 vdd gnd and3_dec
XDEC_AND_56 out_0 out_6 out_11 decode_56 vdd gnd and3_dec
XDEC_AND_12 out_0 out_7 out_8 decode_12 vdd gnd and3_dec
XDEC_AND_28 out_0 out_7 out_9 decode_28 vdd gnd and3_dec
XDEC_AND_44 out_0 out_7 out_10 decode_44 vdd gnd and3_dec
XDEC_AND_60 out_0 out_7 out_11 decode_60 vdd gnd and3_dec
XDEC_AND_1 out_1 out_4 out_8 decode_1 vdd gnd and3_dec
XDEC_AND_17 out_1 out_4 out_9 decode_17 vdd gnd and3_dec
XDEC_AND_33 out_1 out_4 out_10 decode_33 vdd gnd and3_dec
XDEC_AND_49 out_1 out_4 out_11 decode_49 vdd gnd and3_dec
XDEC_AND_5 out_1 out_5 out_8 decode_5 vdd gnd and3_dec
XDEC_AND_21 out_1 out_5 out_9 decode_21 vdd gnd and3_dec
XDEC_AND_37 out_1 out_5 out_10 decode_37 vdd gnd and3_dec
XDEC_AND_53 out_1 out_5 out_11 decode_53 vdd gnd and3_dec
XDEC_AND_9 out_1 out_6 out_8 decode_9 vdd gnd and3_dec
XDEC_AND_25 out_1 out_6 out_9 decode_25 vdd gnd and3_dec
XDEC_AND_41 out_1 out_6 out_10 decode_41 vdd gnd and3_dec
XDEC_AND_57 out_1 out_6 out_11 decode_57 vdd gnd and3_dec
XDEC_AND_13 out_1 out_7 out_8 decode_13 vdd gnd and3_dec
XDEC_AND_29 out_1 out_7 out_9 decode_29 vdd gnd and3_dec
XDEC_AND_45 out_1 out_7 out_10 decode_45 vdd gnd and3_dec
XDEC_AND_61 out_1 out_7 out_11 decode_61 vdd gnd and3_dec
XDEC_AND_2 out_2 out_4 out_8 decode_2 vdd gnd and3_dec
XDEC_AND_18 out_2 out_4 out_9 decode_18 vdd gnd and3_dec
XDEC_AND_34 out_2 out_4 out_10 decode_34 vdd gnd and3_dec
XDEC_AND_50 out_2 out_4 out_11 decode_50 vdd gnd and3_dec
XDEC_AND_6 out_2 out_5 out_8 decode_6 vdd gnd and3_dec
XDEC_AND_22 out_2 out_5 out_9 decode_22 vdd gnd and3_dec
XDEC_AND_38 out_2 out_5 out_10 decode_38 vdd gnd and3_dec
XDEC_AND_54 out_2 out_5 out_11 decode_54 vdd gnd and3_dec
XDEC_AND_10 out_2 out_6 out_8 decode_10 vdd gnd and3_dec
XDEC_AND_26 out_2 out_6 out_9 decode_26 vdd gnd and3_dec
XDEC_AND_42 out_2 out_6 out_10 decode_42 vdd gnd and3_dec
XDEC_AND_58 out_2 out_6 out_11 decode_58 vdd gnd and3_dec
XDEC_AND_14 out_2 out_7 out_8 decode_14 vdd gnd and3_dec
XDEC_AND_30 out_2 out_7 out_9 decode_30 vdd gnd and3_dec
XDEC_AND_46 out_2 out_7 out_10 decode_46 vdd gnd and3_dec
XDEC_AND_62 out_2 out_7 out_11 decode_62 vdd gnd and3_dec
XDEC_AND_3 out_3 out_4 out_8 decode_3 vdd gnd and3_dec
XDEC_AND_19 out_3 out_4 out_9 decode_19 vdd gnd and3_dec
XDEC_AND_35 out_3 out_4 out_10 decode_35 vdd gnd and3_dec
XDEC_AND_51 out_3 out_4 out_11 decode_51 vdd gnd and3_dec
XDEC_AND_7 out_3 out_5 out_8 decode_7 vdd gnd and3_dec
XDEC_AND_23 out_3 out_5 out_9 decode_23 vdd gnd and3_dec
XDEC_AND_39 out_3 out_5 out_10 decode_39 vdd gnd and3_dec
XDEC_AND_55 out_3 out_5 out_11 decode_55 vdd gnd and3_dec
XDEC_AND_11 out_3 out_6 out_8 decode_11 vdd gnd and3_dec
XDEC_AND_27 out_3 out_6 out_9 decode_27 vdd gnd and3_dec
XDEC_AND_43 out_3 out_6 out_10 decode_43 vdd gnd and3_dec
XDEC_AND_59 out_3 out_6 out_11 decode_59 vdd gnd and3_dec
XDEC_AND_15 out_3 out_7 out_8 decode_15 vdd gnd and3_dec
XDEC_AND_31 out_3 out_7 out_9 decode_31 vdd gnd and3_dec
XDEC_AND_47 out_3 out_7 out_10 decode_47 vdd gnd and3_dec
XDEC_AND_63 out_3 out_7 out_11 decode_63 vdd gnd and3_dec
.ENDS hierarchical_decoder

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=0.74 l=0.15 pd=1.78 ps=1.78 as=0.28u ad=0.28u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=1 w=3.0 l=0.15 pd=6.30 ps=6.30 as=1.12u ad=1.12u

.SUBCKT pinv_dec_0 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=3.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
.ENDS pinv_dec_0

.SUBCKT pbuf_dec A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xbuf_inv1 A zb_int vdd gnd pinv_dec
Xbuf_inv2 zb_int Z vdd gnd pinv_dec_0
.ENDS pbuf_dec

.SUBCKT wordline_driver A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xwld_nand A B zb_int vdd gnd sky130_fd_bd_sram__openram_dp_nand2_dec
Xwl_driver zb_int Z vdd gnd pbuf_dec
.ENDS wordline_driver

.SUBCKT wordline_driver_array in_0 in_1 in_2 in_3 in_4 in_5 in_6 in_7 in_8 in_9 in_10 in_11 in_12 in_13 in_14 in_15 in_16 in_17 in_18 in_19 in_20 in_21 in_22 in_23 in_24 in_25 in_26 in_27 in_28 in_29 in_30 in_31 in_32 in_33 in_34 in_35 in_36 in_37 in_38 in_39 in_40 in_41 in_42 in_43 in_44 in_45 in_46 in_47 in_48 in_49 in_50 in_51 in_52 in_53 in_54 in_55 in_56 in_57 in_58 in_59 in_60 in_61 in_62 in_63 wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 en vdd gnd
*.PININFO in_0:I in_1:I in_2:I in_3:I in_4:I in_5:I in_6:I in_7:I in_8:I in_9:I in_10:I in_11:I in_12:I in_13:I in_14:I in_15:I in_16:I in_17:I in_18:I in_19:I in_20:I in_21:I in_22:I in_23:I in_24:I in_25:I in_26:I in_27:I in_28:I in_29:I in_30:I in_31:I in_32:I in_33:I in_34:I in_35:I in_36:I in_37:I in_38:I in_39:I in_40:I in_41:I in_42:I in_43:I in_44:I in_45:I in_46:I in_47:I in_48:I in_49:I in_50:I in_51:I in_52:I in_53:I in_54:I in_55:I in_56:I in_57:I in_58:I in_59:I in_60:I in_61:I in_62:I in_63:I wl_0:O wl_1:O wl_2:O wl_3:O wl_4:O wl_5:O wl_6:O wl_7:O wl_8:O wl_9:O wl_10:O wl_11:O wl_12:O wl_13:O wl_14:O wl_15:O wl_16:O wl_17:O wl_18:O wl_19:O wl_20:O wl_21:O wl_22:O wl_23:O wl_24:O wl_25:O wl_26:O wl_27:O wl_28:O wl_29:O wl_30:O wl_31:O wl_32:O wl_33:O wl_34:O wl_35:O wl_36:O wl_37:O wl_38:O wl_39:O wl_40:O wl_41:O wl_42:O wl_43:O wl_44:O wl_45:O wl_46:O wl_47:O wl_48:O wl_49:O wl_50:O wl_51:O wl_52:O wl_53:O wl_54:O wl_55:O wl_56:O wl_57:O wl_58:O wl_59:O wl_60:O wl_61:O wl_62:O wl_63:O en:I vdd:B gnd:B
* INPUT : in_0 
* INPUT : in_1 
* INPUT : in_2 
* INPUT : in_3 
* INPUT : in_4 
* INPUT : in_5 
* INPUT : in_6 
* INPUT : in_7 
* INPUT : in_8 
* INPUT : in_9 
* INPUT : in_10 
* INPUT : in_11 
* INPUT : in_12 
* INPUT : in_13 
* INPUT : in_14 
* INPUT : in_15 
* INPUT : in_16 
* INPUT : in_17 
* INPUT : in_18 
* INPUT : in_19 
* INPUT : in_20 
* INPUT : in_21 
* INPUT : in_22 
* INPUT : in_23 
* INPUT : in_24 
* INPUT : in_25 
* INPUT : in_26 
* INPUT : in_27 
* INPUT : in_28 
* INPUT : in_29 
* INPUT : in_30 
* INPUT : in_31 
* INPUT : in_32 
* INPUT : in_33 
* INPUT : in_34 
* INPUT : in_35 
* INPUT : in_36 
* INPUT : in_37 
* INPUT : in_38 
* INPUT : in_39 
* INPUT : in_40 
* INPUT : in_41 
* INPUT : in_42 
* INPUT : in_43 
* INPUT : in_44 
* INPUT : in_45 
* INPUT : in_46 
* INPUT : in_47 
* INPUT : in_48 
* INPUT : in_49 
* INPUT : in_50 
* INPUT : in_51 
* INPUT : in_52 
* INPUT : in_53 
* INPUT : in_54 
* INPUT : in_55 
* INPUT : in_56 
* INPUT : in_57 
* INPUT : in_58 
* INPUT : in_59 
* INPUT : in_60 
* INPUT : in_61 
* INPUT : in_62 
* INPUT : in_63 
* OUTPUT: wl_0 
* OUTPUT: wl_1 
* OUTPUT: wl_2 
* OUTPUT: wl_3 
* OUTPUT: wl_4 
* OUTPUT: wl_5 
* OUTPUT: wl_6 
* OUTPUT: wl_7 
* OUTPUT: wl_8 
* OUTPUT: wl_9 
* OUTPUT: wl_10 
* OUTPUT: wl_11 
* OUTPUT: wl_12 
* OUTPUT: wl_13 
* OUTPUT: wl_14 
* OUTPUT: wl_15 
* OUTPUT: wl_16 
* OUTPUT: wl_17 
* OUTPUT: wl_18 
* OUTPUT: wl_19 
* OUTPUT: wl_20 
* OUTPUT: wl_21 
* OUTPUT: wl_22 
* OUTPUT: wl_23 
* OUTPUT: wl_24 
* OUTPUT: wl_25 
* OUTPUT: wl_26 
* OUTPUT: wl_27 
* OUTPUT: wl_28 
* OUTPUT: wl_29 
* OUTPUT: wl_30 
* OUTPUT: wl_31 
* OUTPUT: wl_32 
* OUTPUT: wl_33 
* OUTPUT: wl_34 
* OUTPUT: wl_35 
* OUTPUT: wl_36 
* OUTPUT: wl_37 
* OUTPUT: wl_38 
* OUTPUT: wl_39 
* OUTPUT: wl_40 
* OUTPUT: wl_41 
* OUTPUT: wl_42 
* OUTPUT: wl_43 
* OUTPUT: wl_44 
* OUTPUT: wl_45 
* OUTPUT: wl_46 
* OUTPUT: wl_47 
* OUTPUT: wl_48 
* OUTPUT: wl_49 
* OUTPUT: wl_50 
* OUTPUT: wl_51 
* OUTPUT: wl_52 
* OUTPUT: wl_53 
* OUTPUT: wl_54 
* OUTPUT: wl_55 
* OUTPUT: wl_56 
* OUTPUT: wl_57 
* OUTPUT: wl_58 
* OUTPUT: wl_59 
* OUTPUT: wl_60 
* OUTPUT: wl_61 
* OUTPUT: wl_62 
* OUTPUT: wl_63 
* INPUT : en 
* POWER : vdd 
* GROUND: gnd 
* rows: 64 cols: 44
Xwl_driver_and0 in_0 en wl_0 vdd gnd wordline_driver
Xwl_driver_and1 in_1 en wl_1 vdd gnd wordline_driver
Xwl_driver_and2 in_2 en wl_2 vdd gnd wordline_driver
Xwl_driver_and3 in_3 en wl_3 vdd gnd wordline_driver
Xwl_driver_and4 in_4 en wl_4 vdd gnd wordline_driver
Xwl_driver_and5 in_5 en wl_5 vdd gnd wordline_driver
Xwl_driver_and6 in_6 en wl_6 vdd gnd wordline_driver
Xwl_driver_and7 in_7 en wl_7 vdd gnd wordline_driver
Xwl_driver_and8 in_8 en wl_8 vdd gnd wordline_driver
Xwl_driver_and9 in_9 en wl_9 vdd gnd wordline_driver
Xwl_driver_and10 in_10 en wl_10 vdd gnd wordline_driver
Xwl_driver_and11 in_11 en wl_11 vdd gnd wordline_driver
Xwl_driver_and12 in_12 en wl_12 vdd gnd wordline_driver
Xwl_driver_and13 in_13 en wl_13 vdd gnd wordline_driver
Xwl_driver_and14 in_14 en wl_14 vdd gnd wordline_driver
Xwl_driver_and15 in_15 en wl_15 vdd gnd wordline_driver
Xwl_driver_and16 in_16 en wl_16 vdd gnd wordline_driver
Xwl_driver_and17 in_17 en wl_17 vdd gnd wordline_driver
Xwl_driver_and18 in_18 en wl_18 vdd gnd wordline_driver
Xwl_driver_and19 in_19 en wl_19 vdd gnd wordline_driver
Xwl_driver_and20 in_20 en wl_20 vdd gnd wordline_driver
Xwl_driver_and21 in_21 en wl_21 vdd gnd wordline_driver
Xwl_driver_and22 in_22 en wl_22 vdd gnd wordline_driver
Xwl_driver_and23 in_23 en wl_23 vdd gnd wordline_driver
Xwl_driver_and24 in_24 en wl_24 vdd gnd wordline_driver
Xwl_driver_and25 in_25 en wl_25 vdd gnd wordline_driver
Xwl_driver_and26 in_26 en wl_26 vdd gnd wordline_driver
Xwl_driver_and27 in_27 en wl_27 vdd gnd wordline_driver
Xwl_driver_and28 in_28 en wl_28 vdd gnd wordline_driver
Xwl_driver_and29 in_29 en wl_29 vdd gnd wordline_driver
Xwl_driver_and30 in_30 en wl_30 vdd gnd wordline_driver
Xwl_driver_and31 in_31 en wl_31 vdd gnd wordline_driver
Xwl_driver_and32 in_32 en wl_32 vdd gnd wordline_driver
Xwl_driver_and33 in_33 en wl_33 vdd gnd wordline_driver
Xwl_driver_and34 in_34 en wl_34 vdd gnd wordline_driver
Xwl_driver_and35 in_35 en wl_35 vdd gnd wordline_driver
Xwl_driver_and36 in_36 en wl_36 vdd gnd wordline_driver
Xwl_driver_and37 in_37 en wl_37 vdd gnd wordline_driver
Xwl_driver_and38 in_38 en wl_38 vdd gnd wordline_driver
Xwl_driver_and39 in_39 en wl_39 vdd gnd wordline_driver
Xwl_driver_and40 in_40 en wl_40 vdd gnd wordline_driver
Xwl_driver_and41 in_41 en wl_41 vdd gnd wordline_driver
Xwl_driver_and42 in_42 en wl_42 vdd gnd wordline_driver
Xwl_driver_and43 in_43 en wl_43 vdd gnd wordline_driver
Xwl_driver_and44 in_44 en wl_44 vdd gnd wordline_driver
Xwl_driver_and45 in_45 en wl_45 vdd gnd wordline_driver
Xwl_driver_and46 in_46 en wl_46 vdd gnd wordline_driver
Xwl_driver_and47 in_47 en wl_47 vdd gnd wordline_driver
Xwl_driver_and48 in_48 en wl_48 vdd gnd wordline_driver
Xwl_driver_and49 in_49 en wl_49 vdd gnd wordline_driver
Xwl_driver_and50 in_50 en wl_50 vdd gnd wordline_driver
Xwl_driver_and51 in_51 en wl_51 vdd gnd wordline_driver
Xwl_driver_and52 in_52 en wl_52 vdd gnd wordline_driver
Xwl_driver_and53 in_53 en wl_53 vdd gnd wordline_driver
Xwl_driver_and54 in_54 en wl_54 vdd gnd wordline_driver
Xwl_driver_and55 in_55 en wl_55 vdd gnd wordline_driver
Xwl_driver_and56 in_56 en wl_56 vdd gnd wordline_driver
Xwl_driver_and57 in_57 en wl_57 vdd gnd wordline_driver
Xwl_driver_and58 in_58 en wl_58 vdd gnd wordline_driver
Xwl_driver_and59 in_59 en wl_59 vdd gnd wordline_driver
Xwl_driver_and60 in_60 en wl_60 vdd gnd wordline_driver
Xwl_driver_and61 in_61 en wl_61 vdd gnd wordline_driver
Xwl_driver_and62 in_62 en wl_62 vdd gnd wordline_driver
Xwl_driver_and63 in_63 en wl_63 vdd gnd wordline_driver
.ENDS wordline_driver_array

.SUBCKT port_address addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 wl_en wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 rbl_wl vdd gnd
*.PININFO addr_0:I addr_1:I addr_2:I addr_3:I addr_4:I addr_5:I wl_en:I wl_0:O wl_1:O wl_2:O wl_3:O wl_4:O wl_5:O wl_6:O wl_7:O wl_8:O wl_9:O wl_10:O wl_11:O wl_12:O wl_13:O wl_14:O wl_15:O wl_16:O wl_17:O wl_18:O wl_19:O wl_20:O wl_21:O wl_22:O wl_23:O wl_24:O wl_25:O wl_26:O wl_27:O wl_28:O wl_29:O wl_30:O wl_31:O wl_32:O wl_33:O wl_34:O wl_35:O wl_36:O wl_37:O wl_38:O wl_39:O wl_40:O wl_41:O wl_42:O wl_43:O wl_44:O wl_45:O wl_46:O wl_47:O wl_48:O wl_49:O wl_50:O wl_51:O wl_52:O wl_53:O wl_54:O wl_55:O wl_56:O wl_57:O wl_58:O wl_59:O wl_60:O wl_61:O wl_62:O wl_63:O rbl_wl:O vdd:B gnd:B
* INPUT : addr_0 
* INPUT : addr_1 
* INPUT : addr_2 
* INPUT : addr_3 
* INPUT : addr_4 
* INPUT : addr_5 
* INPUT : wl_en 
* OUTPUT: wl_0 
* OUTPUT: wl_1 
* OUTPUT: wl_2 
* OUTPUT: wl_3 
* OUTPUT: wl_4 
* OUTPUT: wl_5 
* OUTPUT: wl_6 
* OUTPUT: wl_7 
* OUTPUT: wl_8 
* OUTPUT: wl_9 
* OUTPUT: wl_10 
* OUTPUT: wl_11 
* OUTPUT: wl_12 
* OUTPUT: wl_13 
* OUTPUT: wl_14 
* OUTPUT: wl_15 
* OUTPUT: wl_16 
* OUTPUT: wl_17 
* OUTPUT: wl_18 
* OUTPUT: wl_19 
* OUTPUT: wl_20 
* OUTPUT: wl_21 
* OUTPUT: wl_22 
* OUTPUT: wl_23 
* OUTPUT: wl_24 
* OUTPUT: wl_25 
* OUTPUT: wl_26 
* OUTPUT: wl_27 
* OUTPUT: wl_28 
* OUTPUT: wl_29 
* OUTPUT: wl_30 
* OUTPUT: wl_31 
* OUTPUT: wl_32 
* OUTPUT: wl_33 
* OUTPUT: wl_34 
* OUTPUT: wl_35 
* OUTPUT: wl_36 
* OUTPUT: wl_37 
* OUTPUT: wl_38 
* OUTPUT: wl_39 
* OUTPUT: wl_40 
* OUTPUT: wl_41 
* OUTPUT: wl_42 
* OUTPUT: wl_43 
* OUTPUT: wl_44 
* OUTPUT: wl_45 
* OUTPUT: wl_46 
* OUTPUT: wl_47 
* OUTPUT: wl_48 
* OUTPUT: wl_49 
* OUTPUT: wl_50 
* OUTPUT: wl_51 
* OUTPUT: wl_52 
* OUTPUT: wl_53 
* OUTPUT: wl_54 
* OUTPUT: wl_55 
* OUTPUT: wl_56 
* OUTPUT: wl_57 
* OUTPUT: wl_58 
* OUTPUT: wl_59 
* OUTPUT: wl_60 
* OUTPUT: wl_61 
* OUTPUT: wl_62 
* OUTPUT: wl_63 
* OUTPUT: rbl_wl 
* POWER : vdd 
* GROUND: gnd 
Xrow_decoder addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 vdd gnd hierarchical_decoder
Xwordline_driver dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_en vdd gnd wordline_driver_array
Xrbl_driver wl_en rbl_wl vdd gnd pinv_dec_0
.ENDS port_address

.SUBCKT port_address_0 addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 wl_en wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 rbl_wl vdd gnd
*.PININFO addr_0:I addr_1:I addr_2:I addr_3:I addr_4:I addr_5:I wl_en:I wl_0:O wl_1:O wl_2:O wl_3:O wl_4:O wl_5:O wl_6:O wl_7:O wl_8:O wl_9:O wl_10:O wl_11:O wl_12:O wl_13:O wl_14:O wl_15:O wl_16:O wl_17:O wl_18:O wl_19:O wl_20:O wl_21:O wl_22:O wl_23:O wl_24:O wl_25:O wl_26:O wl_27:O wl_28:O wl_29:O wl_30:O wl_31:O wl_32:O wl_33:O wl_34:O wl_35:O wl_36:O wl_37:O wl_38:O wl_39:O wl_40:O wl_41:O wl_42:O wl_43:O wl_44:O wl_45:O wl_46:O wl_47:O wl_48:O wl_49:O wl_50:O wl_51:O wl_52:O wl_53:O wl_54:O wl_55:O wl_56:O wl_57:O wl_58:O wl_59:O wl_60:O wl_61:O wl_62:O wl_63:O rbl_wl:O vdd:B gnd:B
* INPUT : addr_0 
* INPUT : addr_1 
* INPUT : addr_2 
* INPUT : addr_3 
* INPUT : addr_4 
* INPUT : addr_5 
* INPUT : wl_en 
* OUTPUT: wl_0 
* OUTPUT: wl_1 
* OUTPUT: wl_2 
* OUTPUT: wl_3 
* OUTPUT: wl_4 
* OUTPUT: wl_5 
* OUTPUT: wl_6 
* OUTPUT: wl_7 
* OUTPUT: wl_8 
* OUTPUT: wl_9 
* OUTPUT: wl_10 
* OUTPUT: wl_11 
* OUTPUT: wl_12 
* OUTPUT: wl_13 
* OUTPUT: wl_14 
* OUTPUT: wl_15 
* OUTPUT: wl_16 
* OUTPUT: wl_17 
* OUTPUT: wl_18 
* OUTPUT: wl_19 
* OUTPUT: wl_20 
* OUTPUT: wl_21 
* OUTPUT: wl_22 
* OUTPUT: wl_23 
* OUTPUT: wl_24 
* OUTPUT: wl_25 
* OUTPUT: wl_26 
* OUTPUT: wl_27 
* OUTPUT: wl_28 
* OUTPUT: wl_29 
* OUTPUT: wl_30 
* OUTPUT: wl_31 
* OUTPUT: wl_32 
* OUTPUT: wl_33 
* OUTPUT: wl_34 
* OUTPUT: wl_35 
* OUTPUT: wl_36 
* OUTPUT: wl_37 
* OUTPUT: wl_38 
* OUTPUT: wl_39 
* OUTPUT: wl_40 
* OUTPUT: wl_41 
* OUTPUT: wl_42 
* OUTPUT: wl_43 
* OUTPUT: wl_44 
* OUTPUT: wl_45 
* OUTPUT: wl_46 
* OUTPUT: wl_47 
* OUTPUT: wl_48 
* OUTPUT: wl_49 
* OUTPUT: wl_50 
* OUTPUT: wl_51 
* OUTPUT: wl_52 
* OUTPUT: wl_53 
* OUTPUT: wl_54 
* OUTPUT: wl_55 
* OUTPUT: wl_56 
* OUTPUT: wl_57 
* OUTPUT: wl_58 
* OUTPUT: wl_59 
* OUTPUT: wl_60 
* OUTPUT: wl_61 
* OUTPUT: wl_62 
* OUTPUT: wl_63 
* OUTPUT: rbl_wl 
* POWER : vdd 
* GROUND: gnd 
Xrow_decoder addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 vdd gnd hierarchical_decoder
Xwordline_driver dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_en vdd gnd wordline_driver_array
Xrbl_driver wl_en rbl_wl vdd gnd pinv_dec_0
.ENDS port_address_0
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0


.SUBCKT sky130_fd_bd_sram__openram_dp_cell BL0 BR0 BL1 BR1 WL0 WL1 VDD GND
** N=11 EP=8 IP=0 FDC=16
*.SEEDPROM

* Bitcell Core
X0 Q WL1 BL1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X1 GND Q_bar Q GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X2 GND Q_bar Q GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X3 BL0 WL0 Q GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X4 Q_bar WL1 BR1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X5 GND Q Q_bar GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X6 GND Q Q_bar GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X7 BR0 WL0 Q_bar GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X8 VDD Q Q_bar VDD sky130_fd_pr__special_pfet_latch W=0.14u L=0.15u m=1
X9 Q Q_bar VDD VDD sky130_fd_pr__special_pfet_latch W=0.14u L=0.15u m=1

* drainOnly PMOS
X10 Q_bar WL1 Q_bar VDD sky130_fd_pr__special_pfet_latch W=0.14u L=0.08u m=1
X11 Q WL0 Q VDD sky130_fd_pr__special_pfet_latch W=0.14u L=0.08u m=1

* drainOnly NMOS
X12 BL1 GND BL1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.08u m=1
X14 BR1 GND BR1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.08u m=1

.ENDS

.SUBCKT bitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I vdd:B gnd:B
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* POWER : vdd 
* GROUND: gnd 
* rows: 64 cols: 16
Xbit_r0_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
.ENDS bitcell_array
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

* Ingore first line
.SUBCKT sky130_fd_bd_sram__openram_dp_cell_replica BL0 BR0 BL1 BR1 WL0 WL1 VDD GND
** N=9 EP=8 IP=0 FDC=16
*.SEEDPROM

* Bitcell Core
X0 Q WL1 BL1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X1 GND VDD Q GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X2 GND VDD Q GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X3 BL0 WL0 Q GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X4 VDD WL1 BR1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X5 GND Q VDD GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X6 GND Q VDD GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X7 BR0 WL0 VDD GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X8 VDD Q VDD VDD sky130_fd_pr__special_pfet_latch W=0.14u L=0.15u m=1
X9 Q VDD VDD VDD sky130_fd_pr__special_pfet_latch W=0.14u L=0.15u m=1

* drainOnly PMOS
* M10 VDD WL1 VDD VDD sky130_fd_pr__special_pfet_latchu L=0.08 W=0.14
* M11 Q WL0 Q VDD sky130_fd_pr__special_pfet_latchu L=0.08 W=0.14

* drainOnly NMOS
X12 BL1 GND BL1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.08u m=1
X14 BR1 GND BR1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.08u m=1

.ENDS
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0


.SUBCKT sky130_fd_bd_sram__openram_dp_cell_dummy BL0 BR0 BL1 BR1 WL0 WL1 VDD GND
** N=14 EP=6 IP=0 FDC=16
*.SEEDPROM

* Bitcell Core
X1 1 GND GND GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X2 1 WL1 BL1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X3 2 GND GND GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X4 2 WL1 BR1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X5 3 GND GND GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X6 3 WL0 BL0 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X7 4 GND GND GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1
X8 4 WL0 BR0 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.15u m=1

* drainOnly NMOS
X9 BL1 GND BL1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.08u m=1
X10 BR1 GND BR1 GND sky130_fd_pr__special_nfet_latch W=0.21u L=0.08u m=1

.ENDS

.SUBCKT replica_column bl_0_0 bl_1_0 br_0_0 br_1_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 vdd gnd
*.PININFO bl_0_0:O bl_1_0:O br_0_0:O br_1_0:O wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I vdd:B gnd:B
* OUTPUT: bl_0_0 
* OUTPUT: bl_1_0 
* OUTPUT: br_0_0 
* OUTPUT: br_1_0 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* POWER : vdd 
* GROUND: gnd 
Xrbc_1 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_2 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_3 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_4 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_5 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_6 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_7 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_8 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_9 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_10 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_11 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_12 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_13 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_14 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_15 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_16 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_17 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_18 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_19 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_20 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_21 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_22 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_23 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_24 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_25 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_26 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_27 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_28 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_29 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_30 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_31 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_32 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_33 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_34 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_35 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_36 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_37 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_38 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_39 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_40 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_41 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_42 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_43 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_44 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_45 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_46 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_47 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_48 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_49 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_50 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_51 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_52 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_53 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_54 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_55 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_56 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_57 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_58 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_59 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_60 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_61 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_62 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_63 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_64 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_65 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_66 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
.ENDS replica_column

.SUBCKT dummy_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B wl_0_0:I wl_1_0:I vdd:B gnd:B
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* POWER : vdd 
* GROUND: gnd 
Xbit_r0_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
.ENDS dummy_array

.SUBCKT replica_bitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 rbl_wl_1_1 vdd gnd
*.PININFO rbl_bl_0_0:B rbl_bl_1_0:B rbl_br_0_0:B rbl_br_1_0:B bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I rbl_wl_1_1:I vdd:B gnd:B
* INOUT : rbl_bl_0_0 
* INOUT : rbl_bl_1_0 
* INOUT : rbl_br_0_0 
* INOUT : rbl_br_1_0 
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INPUT : rbl_wl_0_0 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
* rbl: [1, 1] left_rbl: [0] right_rbl: []
Xbitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 vdd gnd bitcell_array
Xreplica_col_0 rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 rbl_wl_0_0 gnd wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 gnd rbl_wl_1_1 vdd gnd replica_column
Xdummy_row_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 gnd vdd gnd dummy_array
Xdummy_row_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 gnd rbl_wl_1_1 vdd gnd dummy_array
.ENDS replica_bitcell_array

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=7.0 l=0.15 pd=14.30 ps=14.30 as=2.62u ad=2.62u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=1 w=7.0 l=0.15 pd=14.30 ps=14.30 as=2.62u ad=2.62u

.SUBCKT pinv_dec_1 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=7.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=7.0u l=0.15u
.ENDS pinv_dec_1

.SUBCKT wordline_buffer_array in_0 in_1 in_2 in_3 in_4 in_5 in_6 in_7 in_8 in_9 in_10 in_11 in_12 in_13 in_14 in_15 in_16 in_17 in_18 in_19 in_20 in_21 in_22 in_23 in_24 in_25 in_26 in_27 in_28 in_29 in_30 in_31 in_32 in_33 in_34 in_35 in_36 in_37 in_38 in_39 in_40 in_41 in_42 in_43 in_44 in_45 in_46 in_47 in_48 in_49 in_50 in_51 in_52 in_53 in_54 in_55 in_56 in_57 in_58 in_59 in_60 in_61 in_62 in_63 in_64 out_0 out_1 out_2 out_3 out_4 out_5 out_6 out_7 out_8 out_9 out_10 out_11 out_12 out_13 out_14 out_15 out_16 out_17 out_18 out_19 out_20 out_21 out_22 out_23 out_24 out_25 out_26 out_27 out_28 out_29 out_30 out_31 out_32 out_33 out_34 out_35 out_36 out_37 out_38 out_39 out_40 out_41 out_42 out_43 out_44 out_45 out_46 out_47 out_48 out_49 out_50 out_51 out_52 out_53 out_54 out_55 out_56 out_57 out_58 out_59 out_60 out_61 out_62 out_63 out_64 vdd gnd
*.PININFO in_0:I in_1:I in_2:I in_3:I in_4:I in_5:I in_6:I in_7:I in_8:I in_9:I in_10:I in_11:I in_12:I in_13:I in_14:I in_15:I in_16:I in_17:I in_18:I in_19:I in_20:I in_21:I in_22:I in_23:I in_24:I in_25:I in_26:I in_27:I in_28:I in_29:I in_30:I in_31:I in_32:I in_33:I in_34:I in_35:I in_36:I in_37:I in_38:I in_39:I in_40:I in_41:I in_42:I in_43:I in_44:I in_45:I in_46:I in_47:I in_48:I in_49:I in_50:I in_51:I in_52:I in_53:I in_54:I in_55:I in_56:I in_57:I in_58:I in_59:I in_60:I in_61:I in_62:I in_63:I in_64:I out_0:O out_1:O out_2:O out_3:O out_4:O out_5:O out_6:O out_7:O out_8:O out_9:O out_10:O out_11:O out_12:O out_13:O out_14:O out_15:O out_16:O out_17:O out_18:O out_19:O out_20:O out_21:O out_22:O out_23:O out_24:O out_25:O out_26:O out_27:O out_28:O out_29:O out_30:O out_31:O out_32:O out_33:O out_34:O out_35:O out_36:O out_37:O out_38:O out_39:O out_40:O out_41:O out_42:O out_43:O out_44:O out_45:O out_46:O out_47:O out_48:O out_49:O out_50:O out_51:O out_52:O out_53:O out_54:O out_55:O out_56:O out_57:O out_58:O out_59:O out_60:O out_61:O out_62:O out_63:O out_64:O vdd:B gnd:B
* INPUT : in_0 
* INPUT : in_1 
* INPUT : in_2 
* INPUT : in_3 
* INPUT : in_4 
* INPUT : in_5 
* INPUT : in_6 
* INPUT : in_7 
* INPUT : in_8 
* INPUT : in_9 
* INPUT : in_10 
* INPUT : in_11 
* INPUT : in_12 
* INPUT : in_13 
* INPUT : in_14 
* INPUT : in_15 
* INPUT : in_16 
* INPUT : in_17 
* INPUT : in_18 
* INPUT : in_19 
* INPUT : in_20 
* INPUT : in_21 
* INPUT : in_22 
* INPUT : in_23 
* INPUT : in_24 
* INPUT : in_25 
* INPUT : in_26 
* INPUT : in_27 
* INPUT : in_28 
* INPUT : in_29 
* INPUT : in_30 
* INPUT : in_31 
* INPUT : in_32 
* INPUT : in_33 
* INPUT : in_34 
* INPUT : in_35 
* INPUT : in_36 
* INPUT : in_37 
* INPUT : in_38 
* INPUT : in_39 
* INPUT : in_40 
* INPUT : in_41 
* INPUT : in_42 
* INPUT : in_43 
* INPUT : in_44 
* INPUT : in_45 
* INPUT : in_46 
* INPUT : in_47 
* INPUT : in_48 
* INPUT : in_49 
* INPUT : in_50 
* INPUT : in_51 
* INPUT : in_52 
* INPUT : in_53 
* INPUT : in_54 
* INPUT : in_55 
* INPUT : in_56 
* INPUT : in_57 
* INPUT : in_58 
* INPUT : in_59 
* INPUT : in_60 
* INPUT : in_61 
* INPUT : in_62 
* INPUT : in_63 
* INPUT : in_64 
* OUTPUT: out_0 
* OUTPUT: out_1 
* OUTPUT: out_2 
* OUTPUT: out_3 
* OUTPUT: out_4 
* OUTPUT: out_5 
* OUTPUT: out_6 
* OUTPUT: out_7 
* OUTPUT: out_8 
* OUTPUT: out_9 
* OUTPUT: out_10 
* OUTPUT: out_11 
* OUTPUT: out_12 
* OUTPUT: out_13 
* OUTPUT: out_14 
* OUTPUT: out_15 
* OUTPUT: out_16 
* OUTPUT: out_17 
* OUTPUT: out_18 
* OUTPUT: out_19 
* OUTPUT: out_20 
* OUTPUT: out_21 
* OUTPUT: out_22 
* OUTPUT: out_23 
* OUTPUT: out_24 
* OUTPUT: out_25 
* OUTPUT: out_26 
* OUTPUT: out_27 
* OUTPUT: out_28 
* OUTPUT: out_29 
* OUTPUT: out_30 
* OUTPUT: out_31 
* OUTPUT: out_32 
* OUTPUT: out_33 
* OUTPUT: out_34 
* OUTPUT: out_35 
* OUTPUT: out_36 
* OUTPUT: out_37 
* OUTPUT: out_38 
* OUTPUT: out_39 
* OUTPUT: out_40 
* OUTPUT: out_41 
* OUTPUT: out_42 
* OUTPUT: out_43 
* OUTPUT: out_44 
* OUTPUT: out_45 
* OUTPUT: out_46 
* OUTPUT: out_47 
* OUTPUT: out_48 
* OUTPUT: out_49 
* OUTPUT: out_50 
* OUTPUT: out_51 
* OUTPUT: out_52 
* OUTPUT: out_53 
* OUTPUT: out_54 
* OUTPUT: out_55 
* OUTPUT: out_56 
* OUTPUT: out_57 
* OUTPUT: out_58 
* OUTPUT: out_59 
* OUTPUT: out_60 
* OUTPUT: out_61 
* OUTPUT: out_62 
* OUTPUT: out_63 
* OUTPUT: out_64 
* POWER : vdd 
* GROUND: gnd 
* rows: 65 cols: 16
Xwld0 in_0 out_0 vdd gnd pinv_dec_1
Xwld1 in_1 out_1 vdd gnd pinv_dec_1
Xwld2 in_2 out_2 vdd gnd pinv_dec_1
Xwld3 in_3 out_3 vdd gnd pinv_dec_1
Xwld4 in_4 out_4 vdd gnd pinv_dec_1
Xwld5 in_5 out_5 vdd gnd pinv_dec_1
Xwld6 in_6 out_6 vdd gnd pinv_dec_1
Xwld7 in_7 out_7 vdd gnd pinv_dec_1
Xwld8 in_8 out_8 vdd gnd pinv_dec_1
Xwld9 in_9 out_9 vdd gnd pinv_dec_1
Xwld10 in_10 out_10 vdd gnd pinv_dec_1
Xwld11 in_11 out_11 vdd gnd pinv_dec_1
Xwld12 in_12 out_12 vdd gnd pinv_dec_1
Xwld13 in_13 out_13 vdd gnd pinv_dec_1
Xwld14 in_14 out_14 vdd gnd pinv_dec_1
Xwld15 in_15 out_15 vdd gnd pinv_dec_1
Xwld16 in_16 out_16 vdd gnd pinv_dec_1
Xwld17 in_17 out_17 vdd gnd pinv_dec_1
Xwld18 in_18 out_18 vdd gnd pinv_dec_1
Xwld19 in_19 out_19 vdd gnd pinv_dec_1
Xwld20 in_20 out_20 vdd gnd pinv_dec_1
Xwld21 in_21 out_21 vdd gnd pinv_dec_1
Xwld22 in_22 out_22 vdd gnd pinv_dec_1
Xwld23 in_23 out_23 vdd gnd pinv_dec_1
Xwld24 in_24 out_24 vdd gnd pinv_dec_1
Xwld25 in_25 out_25 vdd gnd pinv_dec_1
Xwld26 in_26 out_26 vdd gnd pinv_dec_1
Xwld27 in_27 out_27 vdd gnd pinv_dec_1
Xwld28 in_28 out_28 vdd gnd pinv_dec_1
Xwld29 in_29 out_29 vdd gnd pinv_dec_1
Xwld30 in_30 out_30 vdd gnd pinv_dec_1
Xwld31 in_31 out_31 vdd gnd pinv_dec_1
Xwld32 in_32 out_32 vdd gnd pinv_dec_1
Xwld33 in_33 out_33 vdd gnd pinv_dec_1
Xwld34 in_34 out_34 vdd gnd pinv_dec_1
Xwld35 in_35 out_35 vdd gnd pinv_dec_1
Xwld36 in_36 out_36 vdd gnd pinv_dec_1
Xwld37 in_37 out_37 vdd gnd pinv_dec_1
Xwld38 in_38 out_38 vdd gnd pinv_dec_1
Xwld39 in_39 out_39 vdd gnd pinv_dec_1
Xwld40 in_40 out_40 vdd gnd pinv_dec_1
Xwld41 in_41 out_41 vdd gnd pinv_dec_1
Xwld42 in_42 out_42 vdd gnd pinv_dec_1
Xwld43 in_43 out_43 vdd gnd pinv_dec_1
Xwld44 in_44 out_44 vdd gnd pinv_dec_1
Xwld45 in_45 out_45 vdd gnd pinv_dec_1
Xwld46 in_46 out_46 vdd gnd pinv_dec_1
Xwld47 in_47 out_47 vdd gnd pinv_dec_1
Xwld48 in_48 out_48 vdd gnd pinv_dec_1
Xwld49 in_49 out_49 vdd gnd pinv_dec_1
Xwld50 in_50 out_50 vdd gnd pinv_dec_1
Xwld51 in_51 out_51 vdd gnd pinv_dec_1
Xwld52 in_52 out_52 vdd gnd pinv_dec_1
Xwld53 in_53 out_53 vdd gnd pinv_dec_1
Xwld54 in_54 out_54 vdd gnd pinv_dec_1
Xwld55 in_55 out_55 vdd gnd pinv_dec_1
Xwld56 in_56 out_56 vdd gnd pinv_dec_1
Xwld57 in_57 out_57 vdd gnd pinv_dec_1
Xwld58 in_58 out_58 vdd gnd pinv_dec_1
Xwld59 in_59 out_59 vdd gnd pinv_dec_1
Xwld60 in_60 out_60 vdd gnd pinv_dec_1
Xwld61 in_61 out_61 vdd gnd pinv_dec_1
Xwld62 in_62 out_62 vdd gnd pinv_dec_1
Xwld63 in_63 out_63 vdd gnd pinv_dec_1
Xwld64 in_64 out_64 vdd gnd pinv_dec_1
.ENDS wordline_buffer_array

.SUBCKT local_bitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 rbl_wl_1_1 vdd gnd
*.PININFO rbl_bl_0_0:B rbl_bl_1_0:B rbl_br_0_0:B rbl_br_1_0:B bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_wl_0_0:I wl_0_0:I wl_0_1:I wl_0_2:I wl_0_3:I wl_0_4:I wl_0_5:I wl_0_6:I wl_0_7:I wl_0_8:I wl_0_9:I wl_0_10:I wl_0_11:I wl_0_12:I wl_0_13:I wl_0_14:I wl_0_15:I wl_0_16:I wl_0_17:I wl_0_18:I wl_0_19:I wl_0_20:I wl_0_21:I wl_0_22:I wl_0_23:I wl_0_24:I wl_0_25:I wl_0_26:I wl_0_27:I wl_0_28:I wl_0_29:I wl_0_30:I wl_0_31:I wl_0_32:I wl_0_33:I wl_0_34:I wl_0_35:I wl_0_36:I wl_0_37:I wl_0_38:I wl_0_39:I wl_0_40:I wl_0_41:I wl_0_42:I wl_0_43:I wl_0_44:I wl_0_45:I wl_0_46:I wl_0_47:I wl_0_48:I wl_0_49:I wl_0_50:I wl_0_51:I wl_0_52:I wl_0_53:I wl_0_54:I wl_0_55:I wl_0_56:I wl_0_57:I wl_0_58:I wl_0_59:I wl_0_60:I wl_0_61:I wl_0_62:I wl_0_63:I wl_1_0:I wl_1_1:I wl_1_2:I wl_1_3:I wl_1_4:I wl_1_5:I wl_1_6:I wl_1_7:I wl_1_8:I wl_1_9:I wl_1_10:I wl_1_11:I wl_1_12:I wl_1_13:I wl_1_14:I wl_1_15:I wl_1_16:I wl_1_17:I wl_1_18:I wl_1_19:I wl_1_20:I wl_1_21:I wl_1_22:I wl_1_23:I wl_1_24:I wl_1_25:I wl_1_26:I wl_1_27:I wl_1_28:I wl_1_29:I wl_1_30:I wl_1_31:I wl_1_32:I wl_1_33:I wl_1_34:I wl_1_35:I wl_1_36:I wl_1_37:I wl_1_38:I wl_1_39:I wl_1_40:I wl_1_41:I wl_1_42:I wl_1_43:I wl_1_44:I wl_1_45:I wl_1_46:I wl_1_47:I wl_1_48:I wl_1_49:I wl_1_50:I wl_1_51:I wl_1_52:I wl_1_53:I wl_1_54:I wl_1_55:I wl_1_56:I wl_1_57:I wl_1_58:I wl_1_59:I wl_1_60:I wl_1_61:I wl_1_62:I wl_1_63:I rbl_wl_1_1:I vdd:B gnd:B
* INOUT : rbl_bl_0_0 
* INOUT : rbl_bl_1_0 
* INOUT : rbl_br_0_0 
* INOUT : rbl_br_1_0 
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INPUT : rbl_wl_0_0 
* INPUT : wl_0_0 
* INPUT : wl_0_1 
* INPUT : wl_0_2 
* INPUT : wl_0_3 
* INPUT : wl_0_4 
* INPUT : wl_0_5 
* INPUT : wl_0_6 
* INPUT : wl_0_7 
* INPUT : wl_0_8 
* INPUT : wl_0_9 
* INPUT : wl_0_10 
* INPUT : wl_0_11 
* INPUT : wl_0_12 
* INPUT : wl_0_13 
* INPUT : wl_0_14 
* INPUT : wl_0_15 
* INPUT : wl_0_16 
* INPUT : wl_0_17 
* INPUT : wl_0_18 
* INPUT : wl_0_19 
* INPUT : wl_0_20 
* INPUT : wl_0_21 
* INPUT : wl_0_22 
* INPUT : wl_0_23 
* INPUT : wl_0_24 
* INPUT : wl_0_25 
* INPUT : wl_0_26 
* INPUT : wl_0_27 
* INPUT : wl_0_28 
* INPUT : wl_0_29 
* INPUT : wl_0_30 
* INPUT : wl_0_31 
* INPUT : wl_0_32 
* INPUT : wl_0_33 
* INPUT : wl_0_34 
* INPUT : wl_0_35 
* INPUT : wl_0_36 
* INPUT : wl_0_37 
* INPUT : wl_0_38 
* INPUT : wl_0_39 
* INPUT : wl_0_40 
* INPUT : wl_0_41 
* INPUT : wl_0_42 
* INPUT : wl_0_43 
* INPUT : wl_0_44 
* INPUT : wl_0_45 
* INPUT : wl_0_46 
* INPUT : wl_0_47 
* INPUT : wl_0_48 
* INPUT : wl_0_49 
* INPUT : wl_0_50 
* INPUT : wl_0_51 
* INPUT : wl_0_52 
* INPUT : wl_0_53 
* INPUT : wl_0_54 
* INPUT : wl_0_55 
* INPUT : wl_0_56 
* INPUT : wl_0_57 
* INPUT : wl_0_58 
* INPUT : wl_0_59 
* INPUT : wl_0_60 
* INPUT : wl_0_61 
* INPUT : wl_0_62 
* INPUT : wl_0_63 
* INPUT : wl_1_0 
* INPUT : wl_1_1 
* INPUT : wl_1_2 
* INPUT : wl_1_3 
* INPUT : wl_1_4 
* INPUT : wl_1_5 
* INPUT : wl_1_6 
* INPUT : wl_1_7 
* INPUT : wl_1_8 
* INPUT : wl_1_9 
* INPUT : wl_1_10 
* INPUT : wl_1_11 
* INPUT : wl_1_12 
* INPUT : wl_1_13 
* INPUT : wl_1_14 
* INPUT : wl_1_15 
* INPUT : wl_1_16 
* INPUT : wl_1_17 
* INPUT : wl_1_18 
* INPUT : wl_1_19 
* INPUT : wl_1_20 
* INPUT : wl_1_21 
* INPUT : wl_1_22 
* INPUT : wl_1_23 
* INPUT : wl_1_24 
* INPUT : wl_1_25 
* INPUT : wl_1_26 
* INPUT : wl_1_27 
* INPUT : wl_1_28 
* INPUT : wl_1_29 
* INPUT : wl_1_30 
* INPUT : wl_1_31 
* INPUT : wl_1_32 
* INPUT : wl_1_33 
* INPUT : wl_1_34 
* INPUT : wl_1_35 
* INPUT : wl_1_36 
* INPUT : wl_1_37 
* INPUT : wl_1_38 
* INPUT : wl_1_39 
* INPUT : wl_1_40 
* INPUT : wl_1_41 
* INPUT : wl_1_42 
* INPUT : wl_1_43 
* INPUT : wl_1_44 
* INPUT : wl_1_45 
* INPUT : wl_1_46 
* INPUT : wl_1_47 
* INPUT : wl_1_48 
* INPUT : wl_1_49 
* INPUT : wl_1_50 
* INPUT : wl_1_51 
* INPUT : wl_1_52 
* INPUT : wl_1_53 
* INPUT : wl_1_54 
* INPUT : wl_1_55 
* INPUT : wl_1_56 
* INPUT : wl_1_57 
* INPUT : wl_1_58 
* INPUT : wl_1_59 
* INPUT : wl_1_60 
* INPUT : wl_1_61 
* INPUT : wl_1_62 
* INPUT : wl_1_63 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xwl_driver0 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 rbl_wl_0_0i wl_0_0i wl_0_1i wl_0_2i wl_0_3i wl_0_4i wl_0_5i wl_0_6i wl_0_7i wl_0_8i wl_0_9i wl_0_10i wl_0_11i wl_0_12i wl_0_13i wl_0_14i wl_0_15i wl_0_16i wl_0_17i wl_0_18i wl_0_19i wl_0_20i wl_0_21i wl_0_22i wl_0_23i wl_0_24i wl_0_25i wl_0_26i wl_0_27i wl_0_28i wl_0_29i wl_0_30i wl_0_31i wl_0_32i wl_0_33i wl_0_34i wl_0_35i wl_0_36i wl_0_37i wl_0_38i wl_0_39i wl_0_40i wl_0_41i wl_0_42i wl_0_43i wl_0_44i wl_0_45i wl_0_46i wl_0_47i wl_0_48i wl_0_49i wl_0_50i wl_0_51i wl_0_52i wl_0_53i wl_0_54i wl_0_55i wl_0_56i wl_0_57i wl_0_58i wl_0_59i wl_0_60i wl_0_61i wl_0_62i wl_0_63i vdd gnd wordline_buffer_array
Xwl_driver1 rbl_wl_1_1 wl_1_63 wl_1_62 wl_1_61 wl_1_60 wl_1_59 wl_1_58 wl_1_57 wl_1_56 wl_1_55 wl_1_54 wl_1_53 wl_1_52 wl_1_51 wl_1_50 wl_1_49 wl_1_48 wl_1_47 wl_1_46 wl_1_45 wl_1_44 wl_1_43 wl_1_42 wl_1_41 wl_1_40 wl_1_39 wl_1_38 wl_1_37 wl_1_36 wl_1_35 wl_1_34 wl_1_33 wl_1_32 wl_1_31 wl_1_30 wl_1_29 wl_1_28 wl_1_27 wl_1_26 wl_1_25 wl_1_24 wl_1_23 wl_1_22 wl_1_21 wl_1_20 wl_1_19 wl_1_18 wl_1_17 wl_1_16 wl_1_15 wl_1_14 wl_1_13 wl_1_12 wl_1_11 wl_1_10 wl_1_9 wl_1_8 wl_1_7 wl_1_6 wl_1_5 wl_1_4 wl_1_3 wl_1_2 wl_1_1 wl_1_0 rbl_wl_1_1i wl_1_63i wl_1_62i wl_1_61i wl_1_60i wl_1_59i wl_1_58i wl_1_57i wl_1_56i wl_1_55i wl_1_54i wl_1_53i wl_1_52i wl_1_51i wl_1_50i wl_1_49i wl_1_48i wl_1_47i wl_1_46i wl_1_45i wl_1_44i wl_1_43i wl_1_42i wl_1_41i wl_1_40i wl_1_39i wl_1_38i wl_1_37i wl_1_36i wl_1_35i wl_1_34i wl_1_33i wl_1_32i wl_1_31i wl_1_30i wl_1_29i wl_1_28i wl_1_27i wl_1_26i wl_1_25i wl_1_24i wl_1_23i wl_1_22i wl_1_21i wl_1_20i wl_1_19i wl_1_18i wl_1_17i wl_1_16i wl_1_15i wl_1_14i wl_1_13i wl_1_12i wl_1_11i wl_1_10i wl_1_9i wl_1_8i wl_1_7i wl_1_6i wl_1_5i wl_1_4i wl_1_3i wl_1_2i wl_1_1i wl_1_0i vdd gnd wordline_buffer_array
Xarray rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0i wl_0_0i wl_1_0i wl_0_1i wl_1_1i wl_0_2i wl_1_2i wl_0_3i wl_1_3i wl_0_4i wl_1_4i wl_0_5i wl_1_5i wl_0_6i wl_1_6i wl_0_7i wl_1_7i wl_0_8i wl_1_8i wl_0_9i wl_1_9i wl_0_10i wl_1_10i wl_0_11i wl_1_11i wl_0_12i wl_1_12i wl_0_13i wl_1_13i wl_0_14i wl_1_14i wl_0_15i wl_1_15i wl_0_16i wl_1_16i wl_0_17i wl_1_17i wl_0_18i wl_1_18i wl_0_19i wl_1_19i wl_0_20i wl_1_20i wl_0_21i wl_1_21i wl_0_22i wl_1_22i wl_0_23i wl_1_23i wl_0_24i wl_1_24i wl_0_25i wl_1_25i wl_0_26i wl_1_26i wl_0_27i wl_1_27i wl_0_28i wl_1_28i wl_0_29i wl_1_29i wl_0_30i wl_1_30i wl_0_31i wl_1_31i wl_0_32i wl_1_32i wl_0_33i wl_1_33i wl_0_34i wl_1_34i wl_0_35i wl_1_35i wl_0_36i wl_1_36i wl_0_37i wl_1_37i wl_0_38i wl_1_38i wl_0_39i wl_1_39i wl_0_40i wl_1_40i wl_0_41i wl_1_41i wl_0_42i wl_1_42i wl_0_43i wl_1_43i wl_0_44i wl_1_44i wl_0_45i wl_1_45i wl_0_46i wl_1_46i wl_0_47i wl_1_47i wl_0_48i wl_1_48i wl_0_49i wl_1_49i wl_0_50i wl_1_50i wl_0_51i wl_1_51i wl_0_52i wl_1_52i wl_0_53i wl_1_53i wl_0_54i wl_1_54i wl_0_55i wl_1_55i wl_0_56i wl_1_56i wl_0_57i wl_1_57i wl_0_58i wl_1_58i wl_0_59i wl_1_59i wl_0_60i wl_1_60i wl_0_61i wl_1_61i wl_0_62i wl_1_62i wl_0_63i wl_1_63i rbl_wl_1_1i vdd gnd replica_bitcell_array
.ENDS local_bitcell_array

.SUBCKT bitcell_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B bl_0_16:B bl_1_16:B br_0_16:B br_1_16:B bl_0_17:B bl_1_17:B br_0_17:B br_1_17:B bl_0_18:B bl_1_18:B br_0_18:B br_1_18:B bl_0_19:B bl_1_19:B br_0_19:B br_1_19:B bl_0_20:B bl_1_20:B br_0_20:B br_1_20:B bl_0_21:B bl_1_21:B br_0_21:B br_1_21:B bl_0_22:B bl_1_22:B br_0_22:B br_1_22:B bl_0_23:B bl_1_23:B br_0_23:B br_1_23:B bl_0_24:B bl_1_24:B br_0_24:B br_1_24:B bl_0_25:B bl_1_25:B br_0_25:B br_1_25:B bl_0_26:B bl_1_26:B br_0_26:B br_1_26:B bl_0_27:B bl_1_27:B br_0_27:B br_1_27:B wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I vdd:B gnd:B
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INOUT : bl_0_16 
* INOUT : bl_1_16 
* INOUT : br_0_16 
* INOUT : br_1_16 
* INOUT : bl_0_17 
* INOUT : bl_1_17 
* INOUT : br_0_17 
* INOUT : br_1_17 
* INOUT : bl_0_18 
* INOUT : bl_1_18 
* INOUT : br_0_18 
* INOUT : br_1_18 
* INOUT : bl_0_19 
* INOUT : bl_1_19 
* INOUT : br_0_19 
* INOUT : br_1_19 
* INOUT : bl_0_20 
* INOUT : bl_1_20 
* INOUT : br_0_20 
* INOUT : br_1_20 
* INOUT : bl_0_21 
* INOUT : bl_1_21 
* INOUT : br_0_21 
* INOUT : br_1_21 
* INOUT : bl_0_22 
* INOUT : bl_1_22 
* INOUT : br_0_22 
* INOUT : br_1_22 
* INOUT : bl_0_23 
* INOUT : bl_1_23 
* INOUT : br_0_23 
* INOUT : br_1_23 
* INOUT : bl_0_24 
* INOUT : bl_1_24 
* INOUT : br_0_24 
* INOUT : br_1_24 
* INOUT : bl_0_25 
* INOUT : bl_1_25 
* INOUT : br_0_25 
* INOUT : br_1_25 
* INOUT : bl_0_26 
* INOUT : bl_1_26 
* INOUT : br_0_26 
* INOUT : br_1_26 
* INOUT : bl_0_27 
* INOUT : bl_1_27 
* INOUT : br_0_27 
* INOUT : br_1_27 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* POWER : vdd 
* GROUND: gnd 
* rows: 64 cols: 28
Xbit_r0_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r0_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r1_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r2_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r3_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r4_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r5_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r6_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r7_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r8_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r9_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r10_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r11_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r12_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r13_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r14_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r15_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r16_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r17_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r18_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r19_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r20_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r21_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r22_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r23_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r24_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r25_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r26_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r27_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r28_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r29_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r30_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r31_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r32_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r33_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r34_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r35_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r36_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r37_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r38_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r39_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r40_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r41_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r42_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r43_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r44_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r45_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r46_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r47_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r48_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r49_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r50_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r51_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r52_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r53_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r54_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r55_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r56_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r57_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r58_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r59_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r60_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r61_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r62_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r63_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell
.ENDS bitcell_array_0

.SUBCKT replica_column_0 bl_0_0 bl_1_0 br_0_0 br_1_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 vdd gnd
*.PININFO bl_0_0:O bl_1_0:O br_0_0:O br_1_0:O wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I vdd:B gnd:B
* OUTPUT: bl_0_0 
* OUTPUT: bl_1_0 
* OUTPUT: br_0_0 
* OUTPUT: br_1_0 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* POWER : vdd 
* GROUND: gnd 
Xrbc_1 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xrbc_2 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_1 wl_1_1 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_3 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_2 wl_1_2 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_4 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_3 wl_1_3 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_5 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_4 wl_1_4 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_6 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_5 wl_1_5 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_7 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_6 wl_1_6 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_8 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_7 wl_1_7 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_9 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_8 wl_1_8 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_10 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_9 wl_1_9 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_11 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_10 wl_1_10 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_12 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_11 wl_1_11 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_13 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_12 wl_1_12 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_14 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_13 wl_1_13 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_15 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_14 wl_1_14 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_16 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_15 wl_1_15 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_17 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_16 wl_1_16 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_18 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_17 wl_1_17 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_19 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_18 wl_1_18 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_20 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_19 wl_1_19 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_21 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_20 wl_1_20 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_22 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_21 wl_1_21 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_23 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_22 wl_1_22 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_24 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_23 wl_1_23 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_25 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_24 wl_1_24 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_26 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_25 wl_1_25 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_27 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_26 wl_1_26 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_28 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_27 wl_1_27 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_29 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_28 wl_1_28 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_30 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_29 wl_1_29 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_31 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_30 wl_1_30 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_32 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_31 wl_1_31 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_33 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_32 wl_1_32 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_34 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_33 wl_1_33 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_35 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_34 wl_1_34 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_36 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_35 wl_1_35 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_37 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_36 wl_1_36 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_38 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_37 wl_1_37 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_39 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_38 wl_1_38 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_40 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_39 wl_1_39 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_41 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_40 wl_1_40 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_42 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_41 wl_1_41 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_43 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_42 wl_1_42 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_44 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_43 wl_1_43 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_45 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_44 wl_1_44 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_46 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_45 wl_1_45 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_47 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_46 wl_1_46 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_48 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_47 wl_1_47 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_49 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_48 wl_1_48 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_50 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_49 wl_1_49 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_51 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_50 wl_1_50 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_52 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_51 wl_1_51 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_53 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_52 wl_1_52 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_54 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_53 wl_1_53 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_55 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_54 wl_1_54 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_56 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_55 wl_1_55 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_57 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_56 wl_1_56 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_58 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_57 wl_1_57 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_59 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_58 wl_1_58 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_60 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_59 wl_1_59 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_61 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_60 wl_1_60 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_62 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_61 wl_1_61 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_63 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_62 wl_1_62 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_64 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_63 wl_1_63 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_65 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_66 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
.ENDS replica_column_0

.SUBCKT dummy_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 wl_0_0 wl_1_0 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B bl_0_16:B bl_1_16:B br_0_16:B br_1_16:B bl_0_17:B bl_1_17:B br_0_17:B br_1_17:B bl_0_18:B bl_1_18:B br_0_18:B br_1_18:B bl_0_19:B bl_1_19:B br_0_19:B br_1_19:B bl_0_20:B bl_1_20:B br_0_20:B br_1_20:B bl_0_21:B bl_1_21:B br_0_21:B br_1_21:B bl_0_22:B bl_1_22:B br_0_22:B br_1_22:B bl_0_23:B bl_1_23:B br_0_23:B br_1_23:B bl_0_24:B bl_1_24:B br_0_24:B br_1_24:B bl_0_25:B bl_1_25:B br_0_25:B br_1_25:B bl_0_26:B bl_1_26:B br_0_26:B br_1_26:B bl_0_27:B bl_1_27:B br_0_27:B br_1_27:B wl_0_0:I wl_1_0:I vdd:B gnd:B
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INOUT : bl_0_16 
* INOUT : bl_1_16 
* INOUT : br_0_16 
* INOUT : br_1_16 
* INOUT : bl_0_17 
* INOUT : bl_1_17 
* INOUT : br_0_17 
* INOUT : br_1_17 
* INOUT : bl_0_18 
* INOUT : bl_1_18 
* INOUT : br_0_18 
* INOUT : br_1_18 
* INOUT : bl_0_19 
* INOUT : bl_1_19 
* INOUT : br_0_19 
* INOUT : br_1_19 
* INOUT : bl_0_20 
* INOUT : bl_1_20 
* INOUT : br_0_20 
* INOUT : br_1_20 
* INOUT : bl_0_21 
* INOUT : bl_1_21 
* INOUT : br_0_21 
* INOUT : br_1_21 
* INOUT : bl_0_22 
* INOUT : bl_1_22 
* INOUT : br_0_22 
* INOUT : br_1_22 
* INOUT : bl_0_23 
* INOUT : bl_1_23 
* INOUT : br_0_23 
* INOUT : br_1_23 
* INOUT : bl_0_24 
* INOUT : bl_1_24 
* INOUT : br_0_24 
* INOUT : br_1_24 
* INOUT : bl_0_25 
* INOUT : bl_1_25 
* INOUT : br_0_25 
* INOUT : br_1_25 
* INOUT : bl_0_26 
* INOUT : bl_1_26 
* INOUT : br_0_26 
* INOUT : br_1_26 
* INOUT : bl_0_27 
* INOUT : bl_1_27 
* INOUT : br_0_27 
* INOUT : br_1_27 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* POWER : vdd 
* GROUND: gnd 
Xbit_r0_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c16 bl_0_16 br_0_16 bl_1_16 br_1_16 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c17 bl_0_17 br_0_17 bl_1_17 br_1_17 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c18 bl_0_18 br_0_18 bl_1_18 br_1_18 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c19 bl_0_19 br_0_19 bl_1_19 br_1_19 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c20 bl_0_20 br_0_20 bl_1_20 br_1_20 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c21 bl_0_21 br_0_21 bl_1_21 br_1_21 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c22 bl_0_22 br_0_22 bl_1_22 br_1_22 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c23 bl_0_23 br_0_23 bl_1_23 br_1_23 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c24 bl_0_24 br_0_24 bl_1_24 br_1_24 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c25 bl_0_25 br_0_25 bl_1_25 br_1_25 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c26 bl_0_26 br_0_26 bl_1_26 br_1_26 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
Xbit_r0_c27 bl_0_27 br_0_27 bl_1_27 br_1_27 wl_0_0 wl_1_0 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
.ENDS dummy_array_0

.SUBCKT replica_bitcell_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 rbl_wl_1_1 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B bl_0_16:B bl_1_16:B br_0_16:B br_1_16:B bl_0_17:B bl_1_17:B br_0_17:B br_1_17:B bl_0_18:B bl_1_18:B br_0_18:B br_1_18:B bl_0_19:B bl_1_19:B br_0_19:B br_1_19:B bl_0_20:B bl_1_20:B br_0_20:B br_1_20:B bl_0_21:B bl_1_21:B br_0_21:B br_1_21:B bl_0_22:B bl_1_22:B br_0_22:B br_1_22:B bl_0_23:B bl_1_23:B br_0_23:B br_1_23:B bl_0_24:B bl_1_24:B br_0_24:B br_1_24:B bl_0_25:B bl_1_25:B br_0_25:B br_1_25:B bl_0_26:B bl_1_26:B br_0_26:B br_1_26:B bl_0_27:B bl_1_27:B br_0_27:B br_1_27:B rbl_bl_0_1:B rbl_bl_1_1:B rbl_br_0_1:B rbl_br_1_1:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I rbl_wl_1_1:I vdd:B gnd:B
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INOUT : bl_0_16 
* INOUT : bl_1_16 
* INOUT : br_0_16 
* INOUT : br_1_16 
* INOUT : bl_0_17 
* INOUT : bl_1_17 
* INOUT : br_0_17 
* INOUT : br_1_17 
* INOUT : bl_0_18 
* INOUT : bl_1_18 
* INOUT : br_0_18 
* INOUT : br_1_18 
* INOUT : bl_0_19 
* INOUT : bl_1_19 
* INOUT : br_0_19 
* INOUT : br_1_19 
* INOUT : bl_0_20 
* INOUT : bl_1_20 
* INOUT : br_0_20 
* INOUT : br_1_20 
* INOUT : bl_0_21 
* INOUT : bl_1_21 
* INOUT : br_0_21 
* INOUT : br_1_21 
* INOUT : bl_0_22 
* INOUT : bl_1_22 
* INOUT : br_0_22 
* INOUT : br_1_22 
* INOUT : bl_0_23 
* INOUT : bl_1_23 
* INOUT : br_0_23 
* INOUT : br_1_23 
* INOUT : bl_0_24 
* INOUT : bl_1_24 
* INOUT : br_0_24 
* INOUT : br_1_24 
* INOUT : bl_0_25 
* INOUT : bl_1_25 
* INOUT : br_0_25 
* INOUT : br_1_25 
* INOUT : bl_0_26 
* INOUT : bl_1_26 
* INOUT : br_0_26 
* INOUT : br_1_26 
* INOUT : bl_0_27 
* INOUT : bl_1_27 
* INOUT : br_0_27 
* INOUT : br_1_27 
* INOUT : rbl_bl_0_1 
* INOUT : rbl_bl_1_1 
* INOUT : rbl_br_0_1 
* INOUT : rbl_br_1_1 
* INPUT : rbl_wl_0_0 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
* rbl: [1, 1] left_rbl: [] right_rbl: [1]
Xbitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 vdd gnd bitcell_array_0
Xreplica_col_1 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 gnd wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 gnd rbl_wl_1_1 vdd gnd replica_column_0
Xdummy_row_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 rbl_wl_0_0 gnd vdd gnd dummy_array_0
Xdummy_row_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 gnd rbl_wl_1_1 vdd gnd dummy_array_0
.ENDS replica_bitcell_array_0

.SUBCKT pinv_dec_2 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=7.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=7.0u l=0.15u
.ENDS pinv_dec_2

.SUBCKT wordline_buffer_array_0 in_0 in_1 in_2 in_3 in_4 in_5 in_6 in_7 in_8 in_9 in_10 in_11 in_12 in_13 in_14 in_15 in_16 in_17 in_18 in_19 in_20 in_21 in_22 in_23 in_24 in_25 in_26 in_27 in_28 in_29 in_30 in_31 in_32 in_33 in_34 in_35 in_36 in_37 in_38 in_39 in_40 in_41 in_42 in_43 in_44 in_45 in_46 in_47 in_48 in_49 in_50 in_51 in_52 in_53 in_54 in_55 in_56 in_57 in_58 in_59 in_60 in_61 in_62 in_63 in_64 out_0 out_1 out_2 out_3 out_4 out_5 out_6 out_7 out_8 out_9 out_10 out_11 out_12 out_13 out_14 out_15 out_16 out_17 out_18 out_19 out_20 out_21 out_22 out_23 out_24 out_25 out_26 out_27 out_28 out_29 out_30 out_31 out_32 out_33 out_34 out_35 out_36 out_37 out_38 out_39 out_40 out_41 out_42 out_43 out_44 out_45 out_46 out_47 out_48 out_49 out_50 out_51 out_52 out_53 out_54 out_55 out_56 out_57 out_58 out_59 out_60 out_61 out_62 out_63 out_64 vdd gnd
*.PININFO in_0:I in_1:I in_2:I in_3:I in_4:I in_5:I in_6:I in_7:I in_8:I in_9:I in_10:I in_11:I in_12:I in_13:I in_14:I in_15:I in_16:I in_17:I in_18:I in_19:I in_20:I in_21:I in_22:I in_23:I in_24:I in_25:I in_26:I in_27:I in_28:I in_29:I in_30:I in_31:I in_32:I in_33:I in_34:I in_35:I in_36:I in_37:I in_38:I in_39:I in_40:I in_41:I in_42:I in_43:I in_44:I in_45:I in_46:I in_47:I in_48:I in_49:I in_50:I in_51:I in_52:I in_53:I in_54:I in_55:I in_56:I in_57:I in_58:I in_59:I in_60:I in_61:I in_62:I in_63:I in_64:I out_0:O out_1:O out_2:O out_3:O out_4:O out_5:O out_6:O out_7:O out_8:O out_9:O out_10:O out_11:O out_12:O out_13:O out_14:O out_15:O out_16:O out_17:O out_18:O out_19:O out_20:O out_21:O out_22:O out_23:O out_24:O out_25:O out_26:O out_27:O out_28:O out_29:O out_30:O out_31:O out_32:O out_33:O out_34:O out_35:O out_36:O out_37:O out_38:O out_39:O out_40:O out_41:O out_42:O out_43:O out_44:O out_45:O out_46:O out_47:O out_48:O out_49:O out_50:O out_51:O out_52:O out_53:O out_54:O out_55:O out_56:O out_57:O out_58:O out_59:O out_60:O out_61:O out_62:O out_63:O out_64:O vdd:B gnd:B
* INPUT : in_0 
* INPUT : in_1 
* INPUT : in_2 
* INPUT : in_3 
* INPUT : in_4 
* INPUT : in_5 
* INPUT : in_6 
* INPUT : in_7 
* INPUT : in_8 
* INPUT : in_9 
* INPUT : in_10 
* INPUT : in_11 
* INPUT : in_12 
* INPUT : in_13 
* INPUT : in_14 
* INPUT : in_15 
* INPUT : in_16 
* INPUT : in_17 
* INPUT : in_18 
* INPUT : in_19 
* INPUT : in_20 
* INPUT : in_21 
* INPUT : in_22 
* INPUT : in_23 
* INPUT : in_24 
* INPUT : in_25 
* INPUT : in_26 
* INPUT : in_27 
* INPUT : in_28 
* INPUT : in_29 
* INPUT : in_30 
* INPUT : in_31 
* INPUT : in_32 
* INPUT : in_33 
* INPUT : in_34 
* INPUT : in_35 
* INPUT : in_36 
* INPUT : in_37 
* INPUT : in_38 
* INPUT : in_39 
* INPUT : in_40 
* INPUT : in_41 
* INPUT : in_42 
* INPUT : in_43 
* INPUT : in_44 
* INPUT : in_45 
* INPUT : in_46 
* INPUT : in_47 
* INPUT : in_48 
* INPUT : in_49 
* INPUT : in_50 
* INPUT : in_51 
* INPUT : in_52 
* INPUT : in_53 
* INPUT : in_54 
* INPUT : in_55 
* INPUT : in_56 
* INPUT : in_57 
* INPUT : in_58 
* INPUT : in_59 
* INPUT : in_60 
* INPUT : in_61 
* INPUT : in_62 
* INPUT : in_63 
* INPUT : in_64 
* OUTPUT: out_0 
* OUTPUT: out_1 
* OUTPUT: out_2 
* OUTPUT: out_3 
* OUTPUT: out_4 
* OUTPUT: out_5 
* OUTPUT: out_6 
* OUTPUT: out_7 
* OUTPUT: out_8 
* OUTPUT: out_9 
* OUTPUT: out_10 
* OUTPUT: out_11 
* OUTPUT: out_12 
* OUTPUT: out_13 
* OUTPUT: out_14 
* OUTPUT: out_15 
* OUTPUT: out_16 
* OUTPUT: out_17 
* OUTPUT: out_18 
* OUTPUT: out_19 
* OUTPUT: out_20 
* OUTPUT: out_21 
* OUTPUT: out_22 
* OUTPUT: out_23 
* OUTPUT: out_24 
* OUTPUT: out_25 
* OUTPUT: out_26 
* OUTPUT: out_27 
* OUTPUT: out_28 
* OUTPUT: out_29 
* OUTPUT: out_30 
* OUTPUT: out_31 
* OUTPUT: out_32 
* OUTPUT: out_33 
* OUTPUT: out_34 
* OUTPUT: out_35 
* OUTPUT: out_36 
* OUTPUT: out_37 
* OUTPUT: out_38 
* OUTPUT: out_39 
* OUTPUT: out_40 
* OUTPUT: out_41 
* OUTPUT: out_42 
* OUTPUT: out_43 
* OUTPUT: out_44 
* OUTPUT: out_45 
* OUTPUT: out_46 
* OUTPUT: out_47 
* OUTPUT: out_48 
* OUTPUT: out_49 
* OUTPUT: out_50 
* OUTPUT: out_51 
* OUTPUT: out_52 
* OUTPUT: out_53 
* OUTPUT: out_54 
* OUTPUT: out_55 
* OUTPUT: out_56 
* OUTPUT: out_57 
* OUTPUT: out_58 
* OUTPUT: out_59 
* OUTPUT: out_60 
* OUTPUT: out_61 
* OUTPUT: out_62 
* OUTPUT: out_63 
* OUTPUT: out_64 
* POWER : vdd 
* GROUND: gnd 
* rows: 65 cols: 28
Xwld0 in_0 out_0 vdd gnd pinv_dec_2
Xwld1 in_1 out_1 vdd gnd pinv_dec_2
Xwld2 in_2 out_2 vdd gnd pinv_dec_2
Xwld3 in_3 out_3 vdd gnd pinv_dec_2
Xwld4 in_4 out_4 vdd gnd pinv_dec_2
Xwld5 in_5 out_5 vdd gnd pinv_dec_2
Xwld6 in_6 out_6 vdd gnd pinv_dec_2
Xwld7 in_7 out_7 vdd gnd pinv_dec_2
Xwld8 in_8 out_8 vdd gnd pinv_dec_2
Xwld9 in_9 out_9 vdd gnd pinv_dec_2
Xwld10 in_10 out_10 vdd gnd pinv_dec_2
Xwld11 in_11 out_11 vdd gnd pinv_dec_2
Xwld12 in_12 out_12 vdd gnd pinv_dec_2
Xwld13 in_13 out_13 vdd gnd pinv_dec_2
Xwld14 in_14 out_14 vdd gnd pinv_dec_2
Xwld15 in_15 out_15 vdd gnd pinv_dec_2
Xwld16 in_16 out_16 vdd gnd pinv_dec_2
Xwld17 in_17 out_17 vdd gnd pinv_dec_2
Xwld18 in_18 out_18 vdd gnd pinv_dec_2
Xwld19 in_19 out_19 vdd gnd pinv_dec_2
Xwld20 in_20 out_20 vdd gnd pinv_dec_2
Xwld21 in_21 out_21 vdd gnd pinv_dec_2
Xwld22 in_22 out_22 vdd gnd pinv_dec_2
Xwld23 in_23 out_23 vdd gnd pinv_dec_2
Xwld24 in_24 out_24 vdd gnd pinv_dec_2
Xwld25 in_25 out_25 vdd gnd pinv_dec_2
Xwld26 in_26 out_26 vdd gnd pinv_dec_2
Xwld27 in_27 out_27 vdd gnd pinv_dec_2
Xwld28 in_28 out_28 vdd gnd pinv_dec_2
Xwld29 in_29 out_29 vdd gnd pinv_dec_2
Xwld30 in_30 out_30 vdd gnd pinv_dec_2
Xwld31 in_31 out_31 vdd gnd pinv_dec_2
Xwld32 in_32 out_32 vdd gnd pinv_dec_2
Xwld33 in_33 out_33 vdd gnd pinv_dec_2
Xwld34 in_34 out_34 vdd gnd pinv_dec_2
Xwld35 in_35 out_35 vdd gnd pinv_dec_2
Xwld36 in_36 out_36 vdd gnd pinv_dec_2
Xwld37 in_37 out_37 vdd gnd pinv_dec_2
Xwld38 in_38 out_38 vdd gnd pinv_dec_2
Xwld39 in_39 out_39 vdd gnd pinv_dec_2
Xwld40 in_40 out_40 vdd gnd pinv_dec_2
Xwld41 in_41 out_41 vdd gnd pinv_dec_2
Xwld42 in_42 out_42 vdd gnd pinv_dec_2
Xwld43 in_43 out_43 vdd gnd pinv_dec_2
Xwld44 in_44 out_44 vdd gnd pinv_dec_2
Xwld45 in_45 out_45 vdd gnd pinv_dec_2
Xwld46 in_46 out_46 vdd gnd pinv_dec_2
Xwld47 in_47 out_47 vdd gnd pinv_dec_2
Xwld48 in_48 out_48 vdd gnd pinv_dec_2
Xwld49 in_49 out_49 vdd gnd pinv_dec_2
Xwld50 in_50 out_50 vdd gnd pinv_dec_2
Xwld51 in_51 out_51 vdd gnd pinv_dec_2
Xwld52 in_52 out_52 vdd gnd pinv_dec_2
Xwld53 in_53 out_53 vdd gnd pinv_dec_2
Xwld54 in_54 out_54 vdd gnd pinv_dec_2
Xwld55 in_55 out_55 vdd gnd pinv_dec_2
Xwld56 in_56 out_56 vdd gnd pinv_dec_2
Xwld57 in_57 out_57 vdd gnd pinv_dec_2
Xwld58 in_58 out_58 vdd gnd pinv_dec_2
Xwld59 in_59 out_59 vdd gnd pinv_dec_2
Xwld60 in_60 out_60 vdd gnd pinv_dec_2
Xwld61 in_61 out_61 vdd gnd pinv_dec_2
Xwld62 in_62 out_62 vdd gnd pinv_dec_2
Xwld63 in_63 out_63 vdd gnd pinv_dec_2
Xwld64 in_64 out_64 vdd gnd pinv_dec_2
.ENDS wordline_buffer_array_0

.SUBCKT local_bitcell_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 rbl_wl_1_1 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B bl_0_16:B bl_1_16:B br_0_16:B br_1_16:B bl_0_17:B bl_1_17:B br_0_17:B br_1_17:B bl_0_18:B bl_1_18:B br_0_18:B br_1_18:B bl_0_19:B bl_1_19:B br_0_19:B br_1_19:B bl_0_20:B bl_1_20:B br_0_20:B br_1_20:B bl_0_21:B bl_1_21:B br_0_21:B br_1_21:B bl_0_22:B bl_1_22:B br_0_22:B br_1_22:B bl_0_23:B bl_1_23:B br_0_23:B br_1_23:B bl_0_24:B bl_1_24:B br_0_24:B br_1_24:B bl_0_25:B bl_1_25:B br_0_25:B br_1_25:B bl_0_26:B bl_1_26:B br_0_26:B br_1_26:B bl_0_27:B bl_1_27:B br_0_27:B br_1_27:B rbl_bl_0_1:B rbl_bl_1_1:B rbl_br_0_1:B rbl_br_1_1:B rbl_wl_0_0:I wl_0_0:I wl_0_1:I wl_0_2:I wl_0_3:I wl_0_4:I wl_0_5:I wl_0_6:I wl_0_7:I wl_0_8:I wl_0_9:I wl_0_10:I wl_0_11:I wl_0_12:I wl_0_13:I wl_0_14:I wl_0_15:I wl_0_16:I wl_0_17:I wl_0_18:I wl_0_19:I wl_0_20:I wl_0_21:I wl_0_22:I wl_0_23:I wl_0_24:I wl_0_25:I wl_0_26:I wl_0_27:I wl_0_28:I wl_0_29:I wl_0_30:I wl_0_31:I wl_0_32:I wl_0_33:I wl_0_34:I wl_0_35:I wl_0_36:I wl_0_37:I wl_0_38:I wl_0_39:I wl_0_40:I wl_0_41:I wl_0_42:I wl_0_43:I wl_0_44:I wl_0_45:I wl_0_46:I wl_0_47:I wl_0_48:I wl_0_49:I wl_0_50:I wl_0_51:I wl_0_52:I wl_0_53:I wl_0_54:I wl_0_55:I wl_0_56:I wl_0_57:I wl_0_58:I wl_0_59:I wl_0_60:I wl_0_61:I wl_0_62:I wl_0_63:I wl_1_0:I wl_1_1:I wl_1_2:I wl_1_3:I wl_1_4:I wl_1_5:I wl_1_6:I wl_1_7:I wl_1_8:I wl_1_9:I wl_1_10:I wl_1_11:I wl_1_12:I wl_1_13:I wl_1_14:I wl_1_15:I wl_1_16:I wl_1_17:I wl_1_18:I wl_1_19:I wl_1_20:I wl_1_21:I wl_1_22:I wl_1_23:I wl_1_24:I wl_1_25:I wl_1_26:I wl_1_27:I wl_1_28:I wl_1_29:I wl_1_30:I wl_1_31:I wl_1_32:I wl_1_33:I wl_1_34:I wl_1_35:I wl_1_36:I wl_1_37:I wl_1_38:I wl_1_39:I wl_1_40:I wl_1_41:I wl_1_42:I wl_1_43:I wl_1_44:I wl_1_45:I wl_1_46:I wl_1_47:I wl_1_48:I wl_1_49:I wl_1_50:I wl_1_51:I wl_1_52:I wl_1_53:I wl_1_54:I wl_1_55:I wl_1_56:I wl_1_57:I wl_1_58:I wl_1_59:I wl_1_60:I wl_1_61:I wl_1_62:I wl_1_63:I rbl_wl_1_1:I vdd:B gnd:B
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INOUT : bl_0_16 
* INOUT : bl_1_16 
* INOUT : br_0_16 
* INOUT : br_1_16 
* INOUT : bl_0_17 
* INOUT : bl_1_17 
* INOUT : br_0_17 
* INOUT : br_1_17 
* INOUT : bl_0_18 
* INOUT : bl_1_18 
* INOUT : br_0_18 
* INOUT : br_1_18 
* INOUT : bl_0_19 
* INOUT : bl_1_19 
* INOUT : br_0_19 
* INOUT : br_1_19 
* INOUT : bl_0_20 
* INOUT : bl_1_20 
* INOUT : br_0_20 
* INOUT : br_1_20 
* INOUT : bl_0_21 
* INOUT : bl_1_21 
* INOUT : br_0_21 
* INOUT : br_1_21 
* INOUT : bl_0_22 
* INOUT : bl_1_22 
* INOUT : br_0_22 
* INOUT : br_1_22 
* INOUT : bl_0_23 
* INOUT : bl_1_23 
* INOUT : br_0_23 
* INOUT : br_1_23 
* INOUT : bl_0_24 
* INOUT : bl_1_24 
* INOUT : br_0_24 
* INOUT : br_1_24 
* INOUT : bl_0_25 
* INOUT : bl_1_25 
* INOUT : br_0_25 
* INOUT : br_1_25 
* INOUT : bl_0_26 
* INOUT : bl_1_26 
* INOUT : br_0_26 
* INOUT : br_1_26 
* INOUT : bl_0_27 
* INOUT : bl_1_27 
* INOUT : br_0_27 
* INOUT : br_1_27 
* INOUT : rbl_bl_0_1 
* INOUT : rbl_bl_1_1 
* INOUT : rbl_br_0_1 
* INOUT : rbl_br_1_1 
* INPUT : rbl_wl_0_0 
* INPUT : wl_0_0 
* INPUT : wl_0_1 
* INPUT : wl_0_2 
* INPUT : wl_0_3 
* INPUT : wl_0_4 
* INPUT : wl_0_5 
* INPUT : wl_0_6 
* INPUT : wl_0_7 
* INPUT : wl_0_8 
* INPUT : wl_0_9 
* INPUT : wl_0_10 
* INPUT : wl_0_11 
* INPUT : wl_0_12 
* INPUT : wl_0_13 
* INPUT : wl_0_14 
* INPUT : wl_0_15 
* INPUT : wl_0_16 
* INPUT : wl_0_17 
* INPUT : wl_0_18 
* INPUT : wl_0_19 
* INPUT : wl_0_20 
* INPUT : wl_0_21 
* INPUT : wl_0_22 
* INPUT : wl_0_23 
* INPUT : wl_0_24 
* INPUT : wl_0_25 
* INPUT : wl_0_26 
* INPUT : wl_0_27 
* INPUT : wl_0_28 
* INPUT : wl_0_29 
* INPUT : wl_0_30 
* INPUT : wl_0_31 
* INPUT : wl_0_32 
* INPUT : wl_0_33 
* INPUT : wl_0_34 
* INPUT : wl_0_35 
* INPUT : wl_0_36 
* INPUT : wl_0_37 
* INPUT : wl_0_38 
* INPUT : wl_0_39 
* INPUT : wl_0_40 
* INPUT : wl_0_41 
* INPUT : wl_0_42 
* INPUT : wl_0_43 
* INPUT : wl_0_44 
* INPUT : wl_0_45 
* INPUT : wl_0_46 
* INPUT : wl_0_47 
* INPUT : wl_0_48 
* INPUT : wl_0_49 
* INPUT : wl_0_50 
* INPUT : wl_0_51 
* INPUT : wl_0_52 
* INPUT : wl_0_53 
* INPUT : wl_0_54 
* INPUT : wl_0_55 
* INPUT : wl_0_56 
* INPUT : wl_0_57 
* INPUT : wl_0_58 
* INPUT : wl_0_59 
* INPUT : wl_0_60 
* INPUT : wl_0_61 
* INPUT : wl_0_62 
* INPUT : wl_0_63 
* INPUT : wl_1_0 
* INPUT : wl_1_1 
* INPUT : wl_1_2 
* INPUT : wl_1_3 
* INPUT : wl_1_4 
* INPUT : wl_1_5 
* INPUT : wl_1_6 
* INPUT : wl_1_7 
* INPUT : wl_1_8 
* INPUT : wl_1_9 
* INPUT : wl_1_10 
* INPUT : wl_1_11 
* INPUT : wl_1_12 
* INPUT : wl_1_13 
* INPUT : wl_1_14 
* INPUT : wl_1_15 
* INPUT : wl_1_16 
* INPUT : wl_1_17 
* INPUT : wl_1_18 
* INPUT : wl_1_19 
* INPUT : wl_1_20 
* INPUT : wl_1_21 
* INPUT : wl_1_22 
* INPUT : wl_1_23 
* INPUT : wl_1_24 
* INPUT : wl_1_25 
* INPUT : wl_1_26 
* INPUT : wl_1_27 
* INPUT : wl_1_28 
* INPUT : wl_1_29 
* INPUT : wl_1_30 
* INPUT : wl_1_31 
* INPUT : wl_1_32 
* INPUT : wl_1_33 
* INPUT : wl_1_34 
* INPUT : wl_1_35 
* INPUT : wl_1_36 
* INPUT : wl_1_37 
* INPUT : wl_1_38 
* INPUT : wl_1_39 
* INPUT : wl_1_40 
* INPUT : wl_1_41 
* INPUT : wl_1_42 
* INPUT : wl_1_43 
* INPUT : wl_1_44 
* INPUT : wl_1_45 
* INPUT : wl_1_46 
* INPUT : wl_1_47 
* INPUT : wl_1_48 
* INPUT : wl_1_49 
* INPUT : wl_1_50 
* INPUT : wl_1_51 
* INPUT : wl_1_52 
* INPUT : wl_1_53 
* INPUT : wl_1_54 
* INPUT : wl_1_55 
* INPUT : wl_1_56 
* INPUT : wl_1_57 
* INPUT : wl_1_58 
* INPUT : wl_1_59 
* INPUT : wl_1_60 
* INPUT : wl_1_61 
* INPUT : wl_1_62 
* INPUT : wl_1_63 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xwl_driver0 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 rbl_wl_0_0i wl_0_0i wl_0_1i wl_0_2i wl_0_3i wl_0_4i wl_0_5i wl_0_6i wl_0_7i wl_0_8i wl_0_9i wl_0_10i wl_0_11i wl_0_12i wl_0_13i wl_0_14i wl_0_15i wl_0_16i wl_0_17i wl_0_18i wl_0_19i wl_0_20i wl_0_21i wl_0_22i wl_0_23i wl_0_24i wl_0_25i wl_0_26i wl_0_27i wl_0_28i wl_0_29i wl_0_30i wl_0_31i wl_0_32i wl_0_33i wl_0_34i wl_0_35i wl_0_36i wl_0_37i wl_0_38i wl_0_39i wl_0_40i wl_0_41i wl_0_42i wl_0_43i wl_0_44i wl_0_45i wl_0_46i wl_0_47i wl_0_48i wl_0_49i wl_0_50i wl_0_51i wl_0_52i wl_0_53i wl_0_54i wl_0_55i wl_0_56i wl_0_57i wl_0_58i wl_0_59i wl_0_60i wl_0_61i wl_0_62i wl_0_63i vdd gnd wordline_buffer_array_0
Xwl_driver1 rbl_wl_1_1 wl_1_63 wl_1_62 wl_1_61 wl_1_60 wl_1_59 wl_1_58 wl_1_57 wl_1_56 wl_1_55 wl_1_54 wl_1_53 wl_1_52 wl_1_51 wl_1_50 wl_1_49 wl_1_48 wl_1_47 wl_1_46 wl_1_45 wl_1_44 wl_1_43 wl_1_42 wl_1_41 wl_1_40 wl_1_39 wl_1_38 wl_1_37 wl_1_36 wl_1_35 wl_1_34 wl_1_33 wl_1_32 wl_1_31 wl_1_30 wl_1_29 wl_1_28 wl_1_27 wl_1_26 wl_1_25 wl_1_24 wl_1_23 wl_1_22 wl_1_21 wl_1_20 wl_1_19 wl_1_18 wl_1_17 wl_1_16 wl_1_15 wl_1_14 wl_1_13 wl_1_12 wl_1_11 wl_1_10 wl_1_9 wl_1_8 wl_1_7 wl_1_6 wl_1_5 wl_1_4 wl_1_3 wl_1_2 wl_1_1 wl_1_0 rbl_wl_1_1i wl_1_63i wl_1_62i wl_1_61i wl_1_60i wl_1_59i wl_1_58i wl_1_57i wl_1_56i wl_1_55i wl_1_54i wl_1_53i wl_1_52i wl_1_51i wl_1_50i wl_1_49i wl_1_48i wl_1_47i wl_1_46i wl_1_45i wl_1_44i wl_1_43i wl_1_42i wl_1_41i wl_1_40i wl_1_39i wl_1_38i wl_1_37i wl_1_36i wl_1_35i wl_1_34i wl_1_33i wl_1_32i wl_1_31i wl_1_30i wl_1_29i wl_1_28i wl_1_27i wl_1_26i wl_1_25i wl_1_24i wl_1_23i wl_1_22i wl_1_21i wl_1_20i wl_1_19i wl_1_18i wl_1_17i wl_1_16i wl_1_15i wl_1_14i wl_1_13i wl_1_12i wl_1_11i wl_1_10i wl_1_9i wl_1_8i wl_1_7i wl_1_6i wl_1_5i wl_1_4i wl_1_3i wl_1_2i wl_1_1i wl_1_0i vdd gnd wordline_buffer_array_0
Xarray bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0i wl_0_0i wl_1_0i wl_0_1i wl_1_1i wl_0_2i wl_1_2i wl_0_3i wl_1_3i wl_0_4i wl_1_4i wl_0_5i wl_1_5i wl_0_6i wl_1_6i wl_0_7i wl_1_7i wl_0_8i wl_1_8i wl_0_9i wl_1_9i wl_0_10i wl_1_10i wl_0_11i wl_1_11i wl_0_12i wl_1_12i wl_0_13i wl_1_13i wl_0_14i wl_1_14i wl_0_15i wl_1_15i wl_0_16i wl_1_16i wl_0_17i wl_1_17i wl_0_18i wl_1_18i wl_0_19i wl_1_19i wl_0_20i wl_1_20i wl_0_21i wl_1_21i wl_0_22i wl_1_22i wl_0_23i wl_1_23i wl_0_24i wl_1_24i wl_0_25i wl_1_25i wl_0_26i wl_1_26i wl_0_27i wl_1_27i wl_0_28i wl_1_28i wl_0_29i wl_1_29i wl_0_30i wl_1_30i wl_0_31i wl_1_31i wl_0_32i wl_1_32i wl_0_33i wl_1_33i wl_0_34i wl_1_34i wl_0_35i wl_1_35i wl_0_36i wl_1_36i wl_0_37i wl_1_37i wl_0_38i wl_1_38i wl_0_39i wl_1_39i wl_0_40i wl_1_40i wl_0_41i wl_1_41i wl_0_42i wl_1_42i wl_0_43i wl_1_43i wl_0_44i wl_1_44i wl_0_45i wl_1_45i wl_0_46i wl_1_46i wl_0_47i wl_1_47i wl_0_48i wl_1_48i wl_0_49i wl_1_49i wl_0_50i wl_1_50i wl_0_51i wl_1_51i wl_0_52i wl_1_52i wl_0_53i wl_1_53i wl_0_54i wl_1_54i wl_0_55i wl_1_55i wl_0_56i wl_1_56i wl_0_57i wl_1_57i wl_0_58i wl_1_58i wl_0_59i wl_1_59i wl_0_60i wl_1_60i wl_0_61i wl_1_61i wl_0_62i wl_1_62i wl_0_63i wl_1_63i rbl_wl_1_1i vdd gnd replica_bitcell_array_0
.ENDS local_bitcell_array_0

.SUBCKT global_bitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 bl_0_28 bl_1_28 br_0_28 br_1_28 bl_0_29 bl_1_29 br_0_29 br_1_29 bl_0_30 bl_1_30 br_0_30 br_1_30 bl_0_31 bl_1_31 br_0_31 br_1_31 bl_0_32 bl_1_32 br_0_32 br_1_32 bl_0_33 bl_1_33 br_0_33 br_1_33 bl_0_34 bl_1_34 br_0_34 br_1_34 bl_0_35 bl_1_35 br_0_35 br_1_35 bl_0_36 bl_1_36 br_0_36 br_1_36 bl_0_37 bl_1_37 br_0_37 br_1_37 bl_0_38 bl_1_38 br_0_38 br_1_38 bl_0_39 bl_1_39 br_0_39 br_1_39 bl_0_40 bl_1_40 br_0_40 br_1_40 bl_0_41 bl_1_41 br_0_41 br_1_41 bl_0_42 bl_1_42 br_0_42 br_1_42 bl_0_43 bl_1_43 br_0_43 br_1_43 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 rbl_wl_1_1 vdd gnd
*.PININFO rbl_bl_0_0:B rbl_bl_1_0:B rbl_br_0_0:B rbl_br_1_0:B bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B bl_0_16:B bl_1_16:B br_0_16:B br_1_16:B bl_0_17:B bl_1_17:B br_0_17:B br_1_17:B bl_0_18:B bl_1_18:B br_0_18:B br_1_18:B bl_0_19:B bl_1_19:B br_0_19:B br_1_19:B bl_0_20:B bl_1_20:B br_0_20:B br_1_20:B bl_0_21:B bl_1_21:B br_0_21:B br_1_21:B bl_0_22:B bl_1_22:B br_0_22:B br_1_22:B bl_0_23:B bl_1_23:B br_0_23:B br_1_23:B bl_0_24:B bl_1_24:B br_0_24:B br_1_24:B bl_0_25:B bl_1_25:B br_0_25:B br_1_25:B bl_0_26:B bl_1_26:B br_0_26:B br_1_26:B bl_0_27:B bl_1_27:B br_0_27:B br_1_27:B bl_0_28:B bl_1_28:B br_0_28:B br_1_28:B bl_0_29:B bl_1_29:B br_0_29:B br_1_29:B bl_0_30:B bl_1_30:B br_0_30:B br_1_30:B bl_0_31:B bl_1_31:B br_0_31:B br_1_31:B bl_0_32:B bl_1_32:B br_0_32:B br_1_32:B bl_0_33:B bl_1_33:B br_0_33:B br_1_33:B bl_0_34:B bl_1_34:B br_0_34:B br_1_34:B bl_0_35:B bl_1_35:B br_0_35:B br_1_35:B bl_0_36:B bl_1_36:B br_0_36:B br_1_36:B bl_0_37:B bl_1_37:B br_0_37:B br_1_37:B bl_0_38:B bl_1_38:B br_0_38:B br_1_38:B bl_0_39:B bl_1_39:B br_0_39:B br_1_39:B bl_0_40:B bl_1_40:B br_0_40:B br_1_40:B bl_0_41:B bl_1_41:B br_0_41:B br_1_41:B bl_0_42:B bl_1_42:B br_0_42:B br_1_42:B bl_0_43:B bl_1_43:B br_0_43:B br_1_43:B rbl_bl_0_1:B rbl_bl_1_1:B rbl_br_0_1:B rbl_br_1_1:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I rbl_wl_1_1:I vdd:B gnd:B
* INOUT : rbl_bl_0_0 
* INOUT : rbl_bl_1_0 
* INOUT : rbl_br_0_0 
* INOUT : rbl_br_1_0 
* INOUT : bl_0_0 
* INOUT : bl_1_0 
* INOUT : br_0_0 
* INOUT : br_1_0 
* INOUT : bl_0_1 
* INOUT : bl_1_1 
* INOUT : br_0_1 
* INOUT : br_1_1 
* INOUT : bl_0_2 
* INOUT : bl_1_2 
* INOUT : br_0_2 
* INOUT : br_1_2 
* INOUT : bl_0_3 
* INOUT : bl_1_3 
* INOUT : br_0_3 
* INOUT : br_1_3 
* INOUT : bl_0_4 
* INOUT : bl_1_4 
* INOUT : br_0_4 
* INOUT : br_1_4 
* INOUT : bl_0_5 
* INOUT : bl_1_5 
* INOUT : br_0_5 
* INOUT : br_1_5 
* INOUT : bl_0_6 
* INOUT : bl_1_6 
* INOUT : br_0_6 
* INOUT : br_1_6 
* INOUT : bl_0_7 
* INOUT : bl_1_7 
* INOUT : br_0_7 
* INOUT : br_1_7 
* INOUT : bl_0_8 
* INOUT : bl_1_8 
* INOUT : br_0_8 
* INOUT : br_1_8 
* INOUT : bl_0_9 
* INOUT : bl_1_9 
* INOUT : br_0_9 
* INOUT : br_1_9 
* INOUT : bl_0_10 
* INOUT : bl_1_10 
* INOUT : br_0_10 
* INOUT : br_1_10 
* INOUT : bl_0_11 
* INOUT : bl_1_11 
* INOUT : br_0_11 
* INOUT : br_1_11 
* INOUT : bl_0_12 
* INOUT : bl_1_12 
* INOUT : br_0_12 
* INOUT : br_1_12 
* INOUT : bl_0_13 
* INOUT : bl_1_13 
* INOUT : br_0_13 
* INOUT : br_1_13 
* INOUT : bl_0_14 
* INOUT : bl_1_14 
* INOUT : br_0_14 
* INOUT : br_1_14 
* INOUT : bl_0_15 
* INOUT : bl_1_15 
* INOUT : br_0_15 
* INOUT : br_1_15 
* INOUT : bl_0_16 
* INOUT : bl_1_16 
* INOUT : br_0_16 
* INOUT : br_1_16 
* INOUT : bl_0_17 
* INOUT : bl_1_17 
* INOUT : br_0_17 
* INOUT : br_1_17 
* INOUT : bl_0_18 
* INOUT : bl_1_18 
* INOUT : br_0_18 
* INOUT : br_1_18 
* INOUT : bl_0_19 
* INOUT : bl_1_19 
* INOUT : br_0_19 
* INOUT : br_1_19 
* INOUT : bl_0_20 
* INOUT : bl_1_20 
* INOUT : br_0_20 
* INOUT : br_1_20 
* INOUT : bl_0_21 
* INOUT : bl_1_21 
* INOUT : br_0_21 
* INOUT : br_1_21 
* INOUT : bl_0_22 
* INOUT : bl_1_22 
* INOUT : br_0_22 
* INOUT : br_1_22 
* INOUT : bl_0_23 
* INOUT : bl_1_23 
* INOUT : br_0_23 
* INOUT : br_1_23 
* INOUT : bl_0_24 
* INOUT : bl_1_24 
* INOUT : br_0_24 
* INOUT : br_1_24 
* INOUT : bl_0_25 
* INOUT : bl_1_25 
* INOUT : br_0_25 
* INOUT : br_1_25 
* INOUT : bl_0_26 
* INOUT : bl_1_26 
* INOUT : br_0_26 
* INOUT : br_1_26 
* INOUT : bl_0_27 
* INOUT : bl_1_27 
* INOUT : br_0_27 
* INOUT : br_1_27 
* INOUT : bl_0_28 
* INOUT : bl_1_28 
* INOUT : br_0_28 
* INOUT : br_1_28 
* INOUT : bl_0_29 
* INOUT : bl_1_29 
* INOUT : br_0_29 
* INOUT : br_1_29 
* INOUT : bl_0_30 
* INOUT : bl_1_30 
* INOUT : br_0_30 
* INOUT : br_1_30 
* INOUT : bl_0_31 
* INOUT : bl_1_31 
* INOUT : br_0_31 
* INOUT : br_1_31 
* INOUT : bl_0_32 
* INOUT : bl_1_32 
* INOUT : br_0_32 
* INOUT : br_1_32 
* INOUT : bl_0_33 
* INOUT : bl_1_33 
* INOUT : br_0_33 
* INOUT : br_1_33 
* INOUT : bl_0_34 
* INOUT : bl_1_34 
* INOUT : br_0_34 
* INOUT : br_1_34 
* INOUT : bl_0_35 
* INOUT : bl_1_35 
* INOUT : br_0_35 
* INOUT : br_1_35 
* INOUT : bl_0_36 
* INOUT : bl_1_36 
* INOUT : br_0_36 
* INOUT : br_1_36 
* INOUT : bl_0_37 
* INOUT : bl_1_37 
* INOUT : br_0_37 
* INOUT : br_1_37 
* INOUT : bl_0_38 
* INOUT : bl_1_38 
* INOUT : br_0_38 
* INOUT : br_1_38 
* INOUT : bl_0_39 
* INOUT : bl_1_39 
* INOUT : br_0_39 
* INOUT : br_1_39 
* INOUT : bl_0_40 
* INOUT : bl_1_40 
* INOUT : br_0_40 
* INOUT : br_1_40 
* INOUT : bl_0_41 
* INOUT : bl_1_41 
* INOUT : br_0_41 
* INOUT : br_1_41 
* INOUT : bl_0_42 
* INOUT : bl_1_42 
* INOUT : br_0_42 
* INOUT : br_1_42 
* INOUT : bl_0_43 
* INOUT : bl_1_43 
* INOUT : br_0_43 
* INOUT : br_1_43 
* INOUT : rbl_bl_0_1 
* INOUT : rbl_bl_1_1 
* INOUT : rbl_br_0_1 
* INOUT : rbl_br_1_1 
* INPUT : rbl_wl_0_0 
* INPUT : wl_0_0 
* INPUT : wl_1_0 
* INPUT : wl_0_1 
* INPUT : wl_1_1 
* INPUT : wl_0_2 
* INPUT : wl_1_2 
* INPUT : wl_0_3 
* INPUT : wl_1_3 
* INPUT : wl_0_4 
* INPUT : wl_1_4 
* INPUT : wl_0_5 
* INPUT : wl_1_5 
* INPUT : wl_0_6 
* INPUT : wl_1_6 
* INPUT : wl_0_7 
* INPUT : wl_1_7 
* INPUT : wl_0_8 
* INPUT : wl_1_8 
* INPUT : wl_0_9 
* INPUT : wl_1_9 
* INPUT : wl_0_10 
* INPUT : wl_1_10 
* INPUT : wl_0_11 
* INPUT : wl_1_11 
* INPUT : wl_0_12 
* INPUT : wl_1_12 
* INPUT : wl_0_13 
* INPUT : wl_1_13 
* INPUT : wl_0_14 
* INPUT : wl_1_14 
* INPUT : wl_0_15 
* INPUT : wl_1_15 
* INPUT : wl_0_16 
* INPUT : wl_1_16 
* INPUT : wl_0_17 
* INPUT : wl_1_17 
* INPUT : wl_0_18 
* INPUT : wl_1_18 
* INPUT : wl_0_19 
* INPUT : wl_1_19 
* INPUT : wl_0_20 
* INPUT : wl_1_20 
* INPUT : wl_0_21 
* INPUT : wl_1_21 
* INPUT : wl_0_22 
* INPUT : wl_1_22 
* INPUT : wl_0_23 
* INPUT : wl_1_23 
* INPUT : wl_0_24 
* INPUT : wl_1_24 
* INPUT : wl_0_25 
* INPUT : wl_1_25 
* INPUT : wl_0_26 
* INPUT : wl_1_26 
* INPUT : wl_0_27 
* INPUT : wl_1_27 
* INPUT : wl_0_28 
* INPUT : wl_1_28 
* INPUT : wl_0_29 
* INPUT : wl_1_29 
* INPUT : wl_0_30 
* INPUT : wl_1_30 
* INPUT : wl_0_31 
* INPUT : wl_1_31 
* INPUT : wl_0_32 
* INPUT : wl_1_32 
* INPUT : wl_0_33 
* INPUT : wl_1_33 
* INPUT : wl_0_34 
* INPUT : wl_1_34 
* INPUT : wl_0_35 
* INPUT : wl_1_35 
* INPUT : wl_0_36 
* INPUT : wl_1_36 
* INPUT : wl_0_37 
* INPUT : wl_1_37 
* INPUT : wl_0_38 
* INPUT : wl_1_38 
* INPUT : wl_0_39 
* INPUT : wl_1_39 
* INPUT : wl_0_40 
* INPUT : wl_1_40 
* INPUT : wl_0_41 
* INPUT : wl_1_41 
* INPUT : wl_0_42 
* INPUT : wl_1_42 
* INPUT : wl_0_43 
* INPUT : wl_1_43 
* INPUT : wl_0_44 
* INPUT : wl_1_44 
* INPUT : wl_0_45 
* INPUT : wl_1_45 
* INPUT : wl_0_46 
* INPUT : wl_1_46 
* INPUT : wl_0_47 
* INPUT : wl_1_47 
* INPUT : wl_0_48 
* INPUT : wl_1_48 
* INPUT : wl_0_49 
* INPUT : wl_1_49 
* INPUT : wl_0_50 
* INPUT : wl_1_50 
* INPUT : wl_0_51 
* INPUT : wl_1_51 
* INPUT : wl_0_52 
* INPUT : wl_1_52 
* INPUT : wl_0_53 
* INPUT : wl_1_53 
* INPUT : wl_0_54 
* INPUT : wl_1_54 
* INPUT : wl_0_55 
* INPUT : wl_1_55 
* INPUT : wl_0_56 
* INPUT : wl_1_56 
* INPUT : wl_0_57 
* INPUT : wl_1_57 
* INPUT : wl_0_58 
* INPUT : wl_1_58 
* INPUT : wl_0_59 
* INPUT : wl_1_59 
* INPUT : wl_0_60 
* INPUT : wl_1_60 
* INPUT : wl_0_61 
* INPUT : wl_1_61 
* INPUT : wl_0_62 
* INPUT : wl_1_62 
* INPUT : wl_0_63 
* INPUT : wl_1_63 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xla_0 rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 rbl_wl_1_1 vdd gnd local_bitcell_array
Xla_16 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 bl_0_28 bl_1_28 br_0_28 br_1_28 bl_0_29 bl_1_29 br_0_29 br_1_29 bl_0_30 bl_1_30 br_0_30 br_1_30 bl_0_31 bl_1_31 br_0_31 br_1_31 bl_0_32 bl_1_32 br_0_32 br_1_32 bl_0_33 bl_1_33 br_0_33 br_1_33 bl_0_34 bl_1_34 br_0_34 br_1_34 bl_0_35 bl_1_35 br_0_35 br_1_35 bl_0_36 bl_1_36 br_0_36 br_1_36 bl_0_37 bl_1_37 br_0_37 br_1_37 bl_0_38 bl_1_38 br_0_38 br_1_38 bl_0_39 bl_1_39 br_0_39 br_1_39 bl_0_40 bl_1_40 br_0_40 br_1_40 bl_0_41 bl_1_41 br_0_41 br_1_41 bl_0_42 bl_1_42 br_0_42 br_1_42 bl_0_43 bl_1_43 br_0_43 br_1_43 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 rbl_wl_1_1 vdd gnd local_bitcell_array_0
.ENDS global_bitcell_array

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=1 w=0.55 l=0.15 pd=1.40 ps=1.40 as=0.21u ad=0.21u

.SUBCKT precharge_0 bl br en_bar vdd
*.PININFO bl:O br:O en_bar:I vdd:B
* OUTPUT: bl 
* OUTPUT: br 
* INPUT : en_bar 
* POWER : vdd 
Xlower_pmos bl en_bar br vdd sky130_fd_pr__pfet_01v8 m=1 w=0.55u l=0.15u
Xupper_pmos1 bl en_bar vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=0.55u l=0.15u
Xupper_pmos2 br en_bar vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=0.55u l=0.15u
.ENDS precharge_0

.SUBCKT precharge_array bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 en_bar vdd
*.PININFO bl_0:O br_0:O bl_1:O br_1:O bl_2:O br_2:O bl_3:O br_3:O bl_4:O br_4:O bl_5:O br_5:O bl_6:O br_6:O bl_7:O br_7:O bl_8:O br_8:O bl_9:O br_9:O bl_10:O br_10:O bl_11:O br_11:O bl_12:O br_12:O bl_13:O br_13:O bl_14:O br_14:O bl_15:O br_15:O bl_16:O br_16:O bl_17:O br_17:O bl_18:O br_18:O bl_19:O br_19:O bl_20:O br_20:O bl_21:O br_21:O bl_22:O br_22:O bl_23:O br_23:O bl_24:O br_24:O bl_25:O br_25:O bl_26:O br_26:O bl_27:O br_27:O bl_28:O br_28:O bl_29:O br_29:O bl_30:O br_30:O bl_31:O br_31:O bl_32:O br_32:O bl_33:O br_33:O bl_34:O br_34:O bl_35:O br_35:O bl_36:O br_36:O bl_37:O br_37:O bl_38:O br_38:O bl_39:O br_39:O bl_40:O br_40:O bl_41:O br_41:O bl_42:O br_42:O bl_43:O br_43:O bl_44:O br_44:O en_bar:I vdd:B
* OUTPUT: bl_0 
* OUTPUT: br_0 
* OUTPUT: bl_1 
* OUTPUT: br_1 
* OUTPUT: bl_2 
* OUTPUT: br_2 
* OUTPUT: bl_3 
* OUTPUT: br_3 
* OUTPUT: bl_4 
* OUTPUT: br_4 
* OUTPUT: bl_5 
* OUTPUT: br_5 
* OUTPUT: bl_6 
* OUTPUT: br_6 
* OUTPUT: bl_7 
* OUTPUT: br_7 
* OUTPUT: bl_8 
* OUTPUT: br_8 
* OUTPUT: bl_9 
* OUTPUT: br_9 
* OUTPUT: bl_10 
* OUTPUT: br_10 
* OUTPUT: bl_11 
* OUTPUT: br_11 
* OUTPUT: bl_12 
* OUTPUT: br_12 
* OUTPUT: bl_13 
* OUTPUT: br_13 
* OUTPUT: bl_14 
* OUTPUT: br_14 
* OUTPUT: bl_15 
* OUTPUT: br_15 
* OUTPUT: bl_16 
* OUTPUT: br_16 
* OUTPUT: bl_17 
* OUTPUT: br_17 
* OUTPUT: bl_18 
* OUTPUT: br_18 
* OUTPUT: bl_19 
* OUTPUT: br_19 
* OUTPUT: bl_20 
* OUTPUT: br_20 
* OUTPUT: bl_21 
* OUTPUT: br_21 
* OUTPUT: bl_22 
* OUTPUT: br_22 
* OUTPUT: bl_23 
* OUTPUT: br_23 
* OUTPUT: bl_24 
* OUTPUT: br_24 
* OUTPUT: bl_25 
* OUTPUT: br_25 
* OUTPUT: bl_26 
* OUTPUT: br_26 
* OUTPUT: bl_27 
* OUTPUT: br_27 
* OUTPUT: bl_28 
* OUTPUT: br_28 
* OUTPUT: bl_29 
* OUTPUT: br_29 
* OUTPUT: bl_30 
* OUTPUT: br_30 
* OUTPUT: bl_31 
* OUTPUT: br_31 
* OUTPUT: bl_32 
* OUTPUT: br_32 
* OUTPUT: bl_33 
* OUTPUT: br_33 
* OUTPUT: bl_34 
* OUTPUT: br_34 
* OUTPUT: bl_35 
* OUTPUT: br_35 
* OUTPUT: bl_36 
* OUTPUT: br_36 
* OUTPUT: bl_37 
* OUTPUT: br_37 
* OUTPUT: bl_38 
* OUTPUT: br_38 
* OUTPUT: bl_39 
* OUTPUT: br_39 
* OUTPUT: bl_40 
* OUTPUT: br_40 
* OUTPUT: bl_41 
* OUTPUT: br_41 
* OUTPUT: bl_42 
* OUTPUT: br_42 
* OUTPUT: bl_43 
* OUTPUT: br_43 
* OUTPUT: bl_44 
* OUTPUT: br_44 
* INPUT : en_bar 
* POWER : vdd 
* cols: 45 size: 1 bl: bl0 br: br0
Xpre_column_0 bl_0 br_0 en_bar vdd precharge_0
Xpre_column_1 bl_1 br_1 en_bar vdd precharge_0
Xpre_column_2 bl_2 br_2 en_bar vdd precharge_0
Xpre_column_3 bl_3 br_3 en_bar vdd precharge_0
Xpre_column_4 bl_4 br_4 en_bar vdd precharge_0
Xpre_column_5 bl_5 br_5 en_bar vdd precharge_0
Xpre_column_6 bl_6 br_6 en_bar vdd precharge_0
Xpre_column_7 bl_7 br_7 en_bar vdd precharge_0
Xpre_column_8 bl_8 br_8 en_bar vdd precharge_0
Xpre_column_9 bl_9 br_9 en_bar vdd precharge_0
Xpre_column_10 bl_10 br_10 en_bar vdd precharge_0
Xpre_column_11 bl_11 br_11 en_bar vdd precharge_0
Xpre_column_12 bl_12 br_12 en_bar vdd precharge_0
Xpre_column_13 bl_13 br_13 en_bar vdd precharge_0
Xpre_column_14 bl_14 br_14 en_bar vdd precharge_0
Xpre_column_15 bl_15 br_15 en_bar vdd precharge_0
Xpre_column_16 bl_16 br_16 en_bar vdd precharge_0
Xpre_column_17 bl_17 br_17 en_bar vdd precharge_0
Xpre_column_18 bl_18 br_18 en_bar vdd precharge_0
Xpre_column_19 bl_19 br_19 en_bar vdd precharge_0
Xpre_column_20 bl_20 br_20 en_bar vdd precharge_0
Xpre_column_21 bl_21 br_21 en_bar vdd precharge_0
Xpre_column_22 bl_22 br_22 en_bar vdd precharge_0
Xpre_column_23 bl_23 br_23 en_bar vdd precharge_0
Xpre_column_24 bl_24 br_24 en_bar vdd precharge_0
Xpre_column_25 bl_25 br_25 en_bar vdd precharge_0
Xpre_column_26 bl_26 br_26 en_bar vdd precharge_0
Xpre_column_27 bl_27 br_27 en_bar vdd precharge_0
Xpre_column_28 bl_28 br_28 en_bar vdd precharge_0
Xpre_column_29 bl_29 br_29 en_bar vdd precharge_0
Xpre_column_30 bl_30 br_30 en_bar vdd precharge_0
Xpre_column_31 bl_31 br_31 en_bar vdd precharge_0
Xpre_column_32 bl_32 br_32 en_bar vdd precharge_0
Xpre_column_33 bl_33 br_33 en_bar vdd precharge_0
Xpre_column_34 bl_34 br_34 en_bar vdd precharge_0
Xpre_column_35 bl_35 br_35 en_bar vdd precharge_0
Xpre_column_36 bl_36 br_36 en_bar vdd precharge_0
Xpre_column_37 bl_37 br_37 en_bar vdd precharge_0
Xpre_column_38 bl_38 br_38 en_bar vdd precharge_0
Xpre_column_39 bl_39 br_39 en_bar vdd precharge_0
Xpre_column_40 bl_40 br_40 en_bar vdd precharge_0
Xpre_column_41 bl_41 br_41 en_bar vdd precharge_0
Xpre_column_42 bl_42 br_42 en_bar vdd precharge_0
Xpre_column_43 bl_43 br_43 en_bar vdd precharge_0
Xpre_column_44 bl_44 br_44 en_bar vdd precharge_0
.ENDS precharge_array
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

*********************** "sky130_fd_bd_sram__openram_sense_amp" ******************************

.SUBCKT sky130_fd_bd_sram__openram_sense_amp BL BR DOUT EN VDD GND
X1000 GND EN a_56_432# GND sky130_fd_pr__nfet_01v8 W=0.65u L=0.15u m=1
X1001 a_56_432# dint_bar dint GND sky130_fd_pr__nfet_01v8 W=0.65u L=0.15u m=1
X1002 dint_bar dint a_56_432# GND sky130_fd_pr__nfet_01v8 W=0.65u L=0.15u m=1

X1003 VDD dint_bar dint VDD sky130_fd_pr__pfet_01v8 W=1.26u L=0.15u m=1
X1004 dint_bar dint VDD VDD sky130_fd_pr__pfet_01v8 W=1.26u L=0.15u m=1

X1005 BL EN dint VDD sky130_fd_pr__pfet_01v8 W=2u L=0.15u m=1
X1006 dint_bar EN BR VDD sky130_fd_pr__pfet_01v8 W=2u L=0.15u m=1

X1007 VDD dint_bar DOUT VDD sky130_fd_pr__pfet_01v8 W=1.26u L=0.15u m=1
X1008 DOUT dint_bar GND GND sky130_fd_pr__nfet_01v8 W=0.65u L=0.15u m=1

.ENDS sky130_fd_bd_sram__openram_sense_amp

.SUBCKT sense_amp_array data_0 bl_0 br_0 data_1 bl_1 br_1 data_2 bl_2 br_2 data_3 bl_3 br_3 data_4 bl_4 br_4 data_5 bl_5 br_5 data_6 bl_6 br_6 data_7 bl_7 br_7 data_8 bl_8 br_8 data_9 bl_9 br_9 data_10 bl_10 br_10 data_11 bl_11 br_11 data_12 bl_12 br_12 data_13 bl_13 br_13 data_14 bl_14 br_14 data_15 bl_15 br_15 data_16 bl_16 br_16 data_17 bl_17 br_17 data_18 bl_18 br_18 data_19 bl_19 br_19 data_20 bl_20 br_20 data_21 bl_21 br_21 data_22 bl_22 br_22 data_23 bl_23 br_23 data_24 bl_24 br_24 data_25 bl_25 br_25 data_26 bl_26 br_26 data_27 bl_27 br_27 data_28 bl_28 br_28 data_29 bl_29 br_29 data_30 bl_30 br_30 data_31 bl_31 br_31 data_32 bl_32 br_32 data_33 bl_33 br_33 data_34 bl_34 br_34 data_35 bl_35 br_35 data_36 bl_36 br_36 data_37 bl_37 br_37 data_38 bl_38 br_38 data_39 bl_39 br_39 data_40 bl_40 br_40 data_41 bl_41 br_41 data_42 bl_42 br_42 data_43 bl_43 br_43 en vdd gnd
*.PININFO data_0:O bl_0:I br_0:I data_1:O bl_1:I br_1:I data_2:O bl_2:I br_2:I data_3:O bl_3:I br_3:I data_4:O bl_4:I br_4:I data_5:O bl_5:I br_5:I data_6:O bl_6:I br_6:I data_7:O bl_7:I br_7:I data_8:O bl_8:I br_8:I data_9:O bl_9:I br_9:I data_10:O bl_10:I br_10:I data_11:O bl_11:I br_11:I data_12:O bl_12:I br_12:I data_13:O bl_13:I br_13:I data_14:O bl_14:I br_14:I data_15:O bl_15:I br_15:I data_16:O bl_16:I br_16:I data_17:O bl_17:I br_17:I data_18:O bl_18:I br_18:I data_19:O bl_19:I br_19:I data_20:O bl_20:I br_20:I data_21:O bl_21:I br_21:I data_22:O bl_22:I br_22:I data_23:O bl_23:I br_23:I data_24:O bl_24:I br_24:I data_25:O bl_25:I br_25:I data_26:O bl_26:I br_26:I data_27:O bl_27:I br_27:I data_28:O bl_28:I br_28:I data_29:O bl_29:I br_29:I data_30:O bl_30:I br_30:I data_31:O bl_31:I br_31:I data_32:O bl_32:I br_32:I data_33:O bl_33:I br_33:I data_34:O bl_34:I br_34:I data_35:O bl_35:I br_35:I data_36:O bl_36:I br_36:I data_37:O bl_37:I br_37:I data_38:O bl_38:I br_38:I data_39:O bl_39:I br_39:I data_40:O bl_40:I br_40:I data_41:O bl_41:I br_41:I data_42:O bl_42:I br_42:I data_43:O bl_43:I br_43:I en:I vdd:B gnd:B
* OUTPUT: data_0 
* INPUT : bl_0 
* INPUT : br_0 
* OUTPUT: data_1 
* INPUT : bl_1 
* INPUT : br_1 
* OUTPUT: data_2 
* INPUT : bl_2 
* INPUT : br_2 
* OUTPUT: data_3 
* INPUT : bl_3 
* INPUT : br_3 
* OUTPUT: data_4 
* INPUT : bl_4 
* INPUT : br_4 
* OUTPUT: data_5 
* INPUT : bl_5 
* INPUT : br_5 
* OUTPUT: data_6 
* INPUT : bl_6 
* INPUT : br_6 
* OUTPUT: data_7 
* INPUT : bl_7 
* INPUT : br_7 
* OUTPUT: data_8 
* INPUT : bl_8 
* INPUT : br_8 
* OUTPUT: data_9 
* INPUT : bl_9 
* INPUT : br_9 
* OUTPUT: data_10 
* INPUT : bl_10 
* INPUT : br_10 
* OUTPUT: data_11 
* INPUT : bl_11 
* INPUT : br_11 
* OUTPUT: data_12 
* INPUT : bl_12 
* INPUT : br_12 
* OUTPUT: data_13 
* INPUT : bl_13 
* INPUT : br_13 
* OUTPUT: data_14 
* INPUT : bl_14 
* INPUT : br_14 
* OUTPUT: data_15 
* INPUT : bl_15 
* INPUT : br_15 
* OUTPUT: data_16 
* INPUT : bl_16 
* INPUT : br_16 
* OUTPUT: data_17 
* INPUT : bl_17 
* INPUT : br_17 
* OUTPUT: data_18 
* INPUT : bl_18 
* INPUT : br_18 
* OUTPUT: data_19 
* INPUT : bl_19 
* INPUT : br_19 
* OUTPUT: data_20 
* INPUT : bl_20 
* INPUT : br_20 
* OUTPUT: data_21 
* INPUT : bl_21 
* INPUT : br_21 
* OUTPUT: data_22 
* INPUT : bl_22 
* INPUT : br_22 
* OUTPUT: data_23 
* INPUT : bl_23 
* INPUT : br_23 
* OUTPUT: data_24 
* INPUT : bl_24 
* INPUT : br_24 
* OUTPUT: data_25 
* INPUT : bl_25 
* INPUT : br_25 
* OUTPUT: data_26 
* INPUT : bl_26 
* INPUT : br_26 
* OUTPUT: data_27 
* INPUT : bl_27 
* INPUT : br_27 
* OUTPUT: data_28 
* INPUT : bl_28 
* INPUT : br_28 
* OUTPUT: data_29 
* INPUT : bl_29 
* INPUT : br_29 
* OUTPUT: data_30 
* INPUT : bl_30 
* INPUT : br_30 
* OUTPUT: data_31 
* INPUT : bl_31 
* INPUT : br_31 
* OUTPUT: data_32 
* INPUT : bl_32 
* INPUT : br_32 
* OUTPUT: data_33 
* INPUT : bl_33 
* INPUT : br_33 
* OUTPUT: data_34 
* INPUT : bl_34 
* INPUT : br_34 
* OUTPUT: data_35 
* INPUT : bl_35 
* INPUT : br_35 
* OUTPUT: data_36 
* INPUT : bl_36 
* INPUT : br_36 
* OUTPUT: data_37 
* INPUT : bl_37 
* INPUT : br_37 
* OUTPUT: data_38 
* INPUT : bl_38 
* INPUT : br_38 
* OUTPUT: data_39 
* INPUT : bl_39 
* INPUT : br_39 
* OUTPUT: data_40 
* INPUT : bl_40 
* INPUT : br_40 
* OUTPUT: data_41 
* INPUT : bl_41 
* INPUT : br_41 
* OUTPUT: data_42 
* INPUT : bl_42 
* INPUT : br_42 
* OUTPUT: data_43 
* INPUT : bl_43 
* INPUT : br_43 
* INPUT : en 
* POWER : vdd 
* GROUND: gnd 
* words_per_row: 1
Xsa_d0 bl_0 br_0 data_0 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d1 bl_1 br_1 data_1 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d2 bl_2 br_2 data_2 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d3 bl_3 br_3 data_3 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d4 bl_4 br_4 data_4 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d5 bl_5 br_5 data_5 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d6 bl_6 br_6 data_6 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d7 bl_7 br_7 data_7 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d8 bl_8 br_8 data_8 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d9 bl_9 br_9 data_9 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d10 bl_10 br_10 data_10 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d11 bl_11 br_11 data_11 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d12 bl_12 br_12 data_12 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d13 bl_13 br_13 data_13 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d14 bl_14 br_14 data_14 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d15 bl_15 br_15 data_15 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d16 bl_16 br_16 data_16 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d17 bl_17 br_17 data_17 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d18 bl_18 br_18 data_18 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d19 bl_19 br_19 data_19 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d20 bl_20 br_20 data_20 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d21 bl_21 br_21 data_21 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d22 bl_22 br_22 data_22 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d23 bl_23 br_23 data_23 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d24 bl_24 br_24 data_24 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d25 bl_25 br_25 data_25 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d26 bl_26 br_26 data_26 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d27 bl_27 br_27 data_27 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d28 bl_28 br_28 data_28 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d29 bl_29 br_29 data_29 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d30 bl_30 br_30 data_30 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d31 bl_31 br_31 data_31 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d32 bl_32 br_32 data_32 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d33 bl_33 br_33 data_33 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d34 bl_34 br_34 data_34 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d35 bl_35 br_35 data_35 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d36 bl_36 br_36 data_36 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d37 bl_37 br_37 data_37 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d38 bl_38 br_38 data_38 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d39 bl_39 br_39 data_39 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d40 bl_40 br_40 data_40 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d41 bl_41 br_41 data_41 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d42 bl_42 br_42 data_42 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d43 bl_43 br_43 data_43 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
.ENDS sense_amp_array
* Copyright 2020 The SkyWater PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* SPDX-License-Identifier: Apache-2.0

*********************** "sky130_fd_bd_sram__openram_write_driver" ******************************

.SUBCKT sky130_fd_bd_sram__openram_write_driver DIN BL BR EN VDD GND

**** Inverter to conver Data_in to data_in_bar ******
* din_bar = inv(DIN)
X_1 din_bar DIN GND GND sky130_fd_pr__nfet_01v8 W=0.36u L=0.15u m=1
X_2 din_bar DIN VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1

**** 2input nand gate follwed by inverter to drive BL ******
* din_bar_gated = nand(EN, DIN)
X_3 din_bar_gated EN net_7 GND sky130_fd_pr__nfet_01v8 W=0.55u L=0.15u m=1
X_4 net_7 DIN GND GND sky130_fd_pr__nfet_01v8 W=0.55u L=0.15u m=1
X_5 din_bar_gated EN VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1
X_6 din_bar_gated DIN VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1
* din_bar_gated_bar = inv(din_bar_gated)
X_7 din_bar_gated_bar din_bar_gated VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1
X_8 din_bar_gated_bar din_bar_gated GND GND sky130_fd_pr__nfet_01v8 W=0.36u L=0.15u m=1

**** 2input nand gate follwed by inverter to drive BR******
* din_gated = nand(EN, din_bar)
X_9 din_gated EN VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1
X_10 din_gated EN net_8 GND sky130_fd_pr__nfet_01v8 W=0.55u L=0.15u m=1
X_11 net_8 din_bar GND GND sky130_fd_pr__nfet_01v8 W=0.55u L=0.15u m=1
X_12 din_gated din_bar VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1
* din_gated_bar = inv(din_gated)
X_13 din_gated_bar din_gated VDD VDD sky130_fd_pr__pfet_01v8 W=0.55u L=0.15u m=1
X_14 din_gated_bar din_gated GND GND sky130_fd_pr__nfet_01v8 W=0.36u L=0.15u m=1

************************************************
* pull down with EN enable
X_15 BL din_gated_bar GND GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1
X_16 BR din_bar_gated_bar GND GND sky130_fd_pr__nfet_01v8 W=1u L=0.15u m=1

.ENDS sky130_fd_bd_sram__openram_write_driver

.SUBCKT write_driver_array data_0 data_1 data_2 data_3 data_4 data_5 data_6 data_7 data_8 data_9 data_10 data_11 data_12 data_13 data_14 data_15 data_16 data_17 data_18 data_19 data_20 data_21 data_22 data_23 data_24 data_25 data_26 data_27 data_28 data_29 data_30 data_31 data_32 data_33 data_34 data_35 data_36 data_37 data_38 data_39 data_40 data_41 data_42 data_43 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 en_0 en_1 en_2 en_3 en_4 en_5 vdd gnd
*.PININFO data_0:I data_1:I data_2:I data_3:I data_4:I data_5:I data_6:I data_7:I data_8:I data_9:I data_10:I data_11:I data_12:I data_13:I data_14:I data_15:I data_16:I data_17:I data_18:I data_19:I data_20:I data_21:I data_22:I data_23:I data_24:I data_25:I data_26:I data_27:I data_28:I data_29:I data_30:I data_31:I data_32:I data_33:I data_34:I data_35:I data_36:I data_37:I data_38:I data_39:I data_40:I data_41:I data_42:I data_43:I bl_0:O br_0:O bl_1:O br_1:O bl_2:O br_2:O bl_3:O br_3:O bl_4:O br_4:O bl_5:O br_5:O bl_6:O br_6:O bl_7:O br_7:O bl_8:O br_8:O bl_9:O br_9:O bl_10:O br_10:O bl_11:O br_11:O bl_12:O br_12:O bl_13:O br_13:O bl_14:O br_14:O bl_15:O br_15:O bl_16:O br_16:O bl_17:O br_17:O bl_18:O br_18:O bl_19:O br_19:O bl_20:O br_20:O bl_21:O br_21:O bl_22:O br_22:O bl_23:O br_23:O bl_24:O br_24:O bl_25:O br_25:O bl_26:O br_26:O bl_27:O br_27:O bl_28:O br_28:O bl_29:O br_29:O bl_30:O br_30:O bl_31:O br_31:O bl_32:O br_32:O bl_33:O br_33:O bl_34:O br_34:O bl_35:O br_35:O bl_36:O br_36:O bl_37:O br_37:O bl_38:O br_38:O bl_39:O br_39:O bl_40:O br_40:O bl_41:O br_41:O bl_42:O br_42:O bl_43:O br_43:O en_0:I en_1:I en_2:I en_3:I en_4:I en_5:I vdd:B gnd:B
* INPUT : data_0 
* INPUT : data_1 
* INPUT : data_2 
* INPUT : data_3 
* INPUT : data_4 
* INPUT : data_5 
* INPUT : data_6 
* INPUT : data_7 
* INPUT : data_8 
* INPUT : data_9 
* INPUT : data_10 
* INPUT : data_11 
* INPUT : data_12 
* INPUT : data_13 
* INPUT : data_14 
* INPUT : data_15 
* INPUT : data_16 
* INPUT : data_17 
* INPUT : data_18 
* INPUT : data_19 
* INPUT : data_20 
* INPUT : data_21 
* INPUT : data_22 
* INPUT : data_23 
* INPUT : data_24 
* INPUT : data_25 
* INPUT : data_26 
* INPUT : data_27 
* INPUT : data_28 
* INPUT : data_29 
* INPUT : data_30 
* INPUT : data_31 
* INPUT : data_32 
* INPUT : data_33 
* INPUT : data_34 
* INPUT : data_35 
* INPUT : data_36 
* INPUT : data_37 
* INPUT : data_38 
* INPUT : data_39 
* INPUT : data_40 
* INPUT : data_41 
* INPUT : data_42 
* INPUT : data_43 
* OUTPUT: bl_0 
* OUTPUT: br_0 
* OUTPUT: bl_1 
* OUTPUT: br_1 
* OUTPUT: bl_2 
* OUTPUT: br_2 
* OUTPUT: bl_3 
* OUTPUT: br_3 
* OUTPUT: bl_4 
* OUTPUT: br_4 
* OUTPUT: bl_5 
* OUTPUT: br_5 
* OUTPUT: bl_6 
* OUTPUT: br_6 
* OUTPUT: bl_7 
* OUTPUT: br_7 
* OUTPUT: bl_8 
* OUTPUT: br_8 
* OUTPUT: bl_9 
* OUTPUT: br_9 
* OUTPUT: bl_10 
* OUTPUT: br_10 
* OUTPUT: bl_11 
* OUTPUT: br_11 
* OUTPUT: bl_12 
* OUTPUT: br_12 
* OUTPUT: bl_13 
* OUTPUT: br_13 
* OUTPUT: bl_14 
* OUTPUT: br_14 
* OUTPUT: bl_15 
* OUTPUT: br_15 
* OUTPUT: bl_16 
* OUTPUT: br_16 
* OUTPUT: bl_17 
* OUTPUT: br_17 
* OUTPUT: bl_18 
* OUTPUT: br_18 
* OUTPUT: bl_19 
* OUTPUT: br_19 
* OUTPUT: bl_20 
* OUTPUT: br_20 
* OUTPUT: bl_21 
* OUTPUT: br_21 
* OUTPUT: bl_22 
* OUTPUT: br_22 
* OUTPUT: bl_23 
* OUTPUT: br_23 
* OUTPUT: bl_24 
* OUTPUT: br_24 
* OUTPUT: bl_25 
* OUTPUT: br_25 
* OUTPUT: bl_26 
* OUTPUT: br_26 
* OUTPUT: bl_27 
* OUTPUT: br_27 
* OUTPUT: bl_28 
* OUTPUT: br_28 
* OUTPUT: bl_29 
* OUTPUT: br_29 
* OUTPUT: bl_30 
* OUTPUT: br_30 
* OUTPUT: bl_31 
* OUTPUT: br_31 
* OUTPUT: bl_32 
* OUTPUT: br_32 
* OUTPUT: bl_33 
* OUTPUT: br_33 
* OUTPUT: bl_34 
* OUTPUT: br_34 
* OUTPUT: bl_35 
* OUTPUT: br_35 
* OUTPUT: bl_36 
* OUTPUT: br_36 
* OUTPUT: bl_37 
* OUTPUT: br_37 
* OUTPUT: bl_38 
* OUTPUT: br_38 
* OUTPUT: bl_39 
* OUTPUT: br_39 
* OUTPUT: bl_40 
* OUTPUT: br_40 
* OUTPUT: bl_41 
* OUTPUT: br_41 
* OUTPUT: bl_42 
* OUTPUT: br_42 
* OUTPUT: bl_43 
* OUTPUT: br_43 
* INPUT : en_0 
* INPUT : en_1 
* INPUT : en_2 
* INPUT : en_3 
* INPUT : en_4 
* INPUT : en_5 
* POWER : vdd 
* GROUND: gnd 
* word_size 44
Xwrite_driver0 data_0 bl_0 br_0 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver1 data_1 bl_1 br_1 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver2 data_2 bl_2 br_2 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver3 data_3 bl_3 br_3 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver4 data_4 bl_4 br_4 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver5 data_5 bl_5 br_5 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver6 data_6 bl_6 br_6 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver7 data_7 bl_7 br_7 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver8 data_8 bl_8 br_8 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver9 data_9 bl_9 br_9 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver10 data_10 bl_10 br_10 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver11 data_11 bl_11 br_11 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver12 data_12 bl_12 br_12 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver13 data_13 bl_13 br_13 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver14 data_14 bl_14 br_14 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver15 data_15 bl_15 br_15 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver16 data_16 bl_16 br_16 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver17 data_17 bl_17 br_17 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver18 data_18 bl_18 br_18 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver19 data_19 bl_19 br_19 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver20 data_20 bl_20 br_20 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver21 data_21 bl_21 br_21 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver22 data_22 bl_22 br_22 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver23 data_23 bl_23 br_23 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver24 data_24 bl_24 br_24 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver25 data_25 bl_25 br_25 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver26 data_26 bl_26 br_26 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver27 data_27 bl_27 br_27 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver28 data_28 bl_28 br_28 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver29 data_29 bl_29 br_29 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver30 data_30 bl_30 br_30 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver31 data_31 bl_31 br_31 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver32 data_32 bl_32 br_32 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver33 data_33 bl_33 br_33 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver34 data_34 bl_34 br_34 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver35 data_35 bl_35 br_35 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver36 data_36 bl_36 br_36 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver37 data_37 bl_37 br_37 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver38 data_38 bl_38 br_38 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver39 data_39 bl_39 br_39 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver40 data_40 bl_40 br_40 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver41 data_41 bl_41 br_41 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver42 data_42 bl_42 br_42 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver43 data_43 bl_43 br_43 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
.ENDS write_driver_array

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=0.74 l=0.15 pd=1.78 ps=1.78 as=0.28u ad=0.28u

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=0.74 l=0.15 pd=1.78 ps=1.78 as=0.28u ad=0.28u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=1 w=1.12 l=0.15 pd=2.54 ps=2.54 as=0.42u ad=0.42u

.SUBCKT pnand2 A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpnand2_pmos1 vdd A Z vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand2_pmos2 Z B vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand2_nmos1 Z B net1 gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
Xpnand2_nmos2 net1 A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
.ENDS pnand2

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=2 w=0.74 l=0.15 pd=1.78 ps=1.78 as=0.28u ad=0.28u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=2 w=1.26 l=0.15 pd=2.82 ps=2.82 as=0.47u ad=0.47u

.SUBCKT pinv A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=2 w=1.26u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=2 w=0.74u l=0.15u
.ENDS pinv

.SUBCKT pdriver A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [2.0]
Xbuf_inv1 A Z vdd gnd pinv
.ENDS pdriver

.SUBCKT pand2 A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpand2_nand A B zb_int vdd gnd pnand2
Xpand2_inv zb_int Z vdd gnd pdriver
.ENDS pand2

.SUBCKT write_mask_and_array wmask_in_0 wmask_in_1 wmask_in_2 wmask_in_3 wmask_in_4 wmask_in_5 en wmask_out_0 wmask_out_1 wmask_out_2 wmask_out_3 wmask_out_4 wmask_out_5 vdd gnd
*.PININFO wmask_in_0:I wmask_in_1:I wmask_in_2:I wmask_in_3:I wmask_in_4:I wmask_in_5:I en:I wmask_out_0:O wmask_out_1:O wmask_out_2:O wmask_out_3:O wmask_out_4:O wmask_out_5:O vdd:B gnd:B
* INPUT : wmask_in_0 
* INPUT : wmask_in_1 
* INPUT : wmask_in_2 
* INPUT : wmask_in_3 
* INPUT : wmask_in_4 
* INPUT : wmask_in_5 
* INPUT : en 
* OUTPUT: wmask_out_0 
* OUTPUT: wmask_out_1 
* OUTPUT: wmask_out_2 
* OUTPUT: wmask_out_3 
* OUTPUT: wmask_out_4 
* OUTPUT: wmask_out_5 
* POWER : vdd 
* GROUND: gnd 
* write_size 8
Xand2_0 wmask_in_0 en wmask_out_0 vdd gnd pand2
Xand2_1 wmask_in_1 en wmask_out_1 vdd gnd pand2
Xand2_2 wmask_in_2 en wmask_out_2 vdd gnd pand2
Xand2_3 wmask_in_3 en wmask_out_3 vdd gnd pand2
Xand2_4 wmask_in_4 en wmask_out_4 vdd gnd pand2
Xand2_5 wmask_in_5 en wmask_out_5 vdd gnd pand2
.ENDS write_mask_and_array

.SUBCKT port_data rbl_bl rbl_br bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 dout_8 dout_9 dout_10 dout_11 dout_12 dout_13 dout_14 dout_15 dout_16 dout_17 dout_18 dout_19 dout_20 dout_21 dout_22 dout_23 dout_24 dout_25 dout_26 dout_27 dout_28 dout_29 dout_30 dout_31 dout_32 dout_33 dout_34 dout_35 dout_36 dout_37 dout_38 dout_39 dout_40 dout_41 dout_42 dout_43 din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 din_8 din_9 din_10 din_11 din_12 din_13 din_14 din_15 din_16 din_17 din_18 din_19 din_20 din_21 din_22 din_23 din_24 din_25 din_26 din_27 din_28 din_29 din_30 din_31 din_32 din_33 din_34 din_35 din_36 din_37 din_38 din_39 din_40 din_41 din_42 din_43 s_en p_en_bar w_en bank_wmask_0 bank_wmask_1 bank_wmask_2 bank_wmask_3 bank_wmask_4 bank_wmask_5 vdd gnd
*.PININFO rbl_bl:B rbl_br:B bl_0:B br_0:B bl_1:B br_1:B bl_2:B br_2:B bl_3:B br_3:B bl_4:B br_4:B bl_5:B br_5:B bl_6:B br_6:B bl_7:B br_7:B bl_8:B br_8:B bl_9:B br_9:B bl_10:B br_10:B bl_11:B br_11:B bl_12:B br_12:B bl_13:B br_13:B bl_14:B br_14:B bl_15:B br_15:B bl_16:B br_16:B bl_17:B br_17:B bl_18:B br_18:B bl_19:B br_19:B bl_20:B br_20:B bl_21:B br_21:B bl_22:B br_22:B bl_23:B br_23:B bl_24:B br_24:B bl_25:B br_25:B bl_26:B br_26:B bl_27:B br_27:B bl_28:B br_28:B bl_29:B br_29:B bl_30:B br_30:B bl_31:B br_31:B bl_32:B br_32:B bl_33:B br_33:B bl_34:B br_34:B bl_35:B br_35:B bl_36:B br_36:B bl_37:B br_37:B bl_38:B br_38:B bl_39:B br_39:B bl_40:B br_40:B bl_41:B br_41:B bl_42:B br_42:B bl_43:B br_43:B dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O dout_8:O dout_9:O dout_10:O dout_11:O dout_12:O dout_13:O dout_14:O dout_15:O dout_16:O dout_17:O dout_18:O dout_19:O dout_20:O dout_21:O dout_22:O dout_23:O dout_24:O dout_25:O dout_26:O dout_27:O dout_28:O dout_29:O dout_30:O dout_31:O dout_32:O dout_33:O dout_34:O dout_35:O dout_36:O dout_37:O dout_38:O dout_39:O dout_40:O dout_41:O dout_42:O dout_43:O din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I din_6:I din_7:I din_8:I din_9:I din_10:I din_11:I din_12:I din_13:I din_14:I din_15:I din_16:I din_17:I din_18:I din_19:I din_20:I din_21:I din_22:I din_23:I din_24:I din_25:I din_26:I din_27:I din_28:I din_29:I din_30:I din_31:I din_32:I din_33:I din_34:I din_35:I din_36:I din_37:I din_38:I din_39:I din_40:I din_41:I din_42:I din_43:I s_en:I p_en_bar:I w_en:I bank_wmask_0:I bank_wmask_1:I bank_wmask_2:I bank_wmask_3:I bank_wmask_4:I bank_wmask_5:I vdd:B gnd:B
* INOUT : rbl_bl 
* INOUT : rbl_br 
* INOUT : bl_0 
* INOUT : br_0 
* INOUT : bl_1 
* INOUT : br_1 
* INOUT : bl_2 
* INOUT : br_2 
* INOUT : bl_3 
* INOUT : br_3 
* INOUT : bl_4 
* INOUT : br_4 
* INOUT : bl_5 
* INOUT : br_5 
* INOUT : bl_6 
* INOUT : br_6 
* INOUT : bl_7 
* INOUT : br_7 
* INOUT : bl_8 
* INOUT : br_8 
* INOUT : bl_9 
* INOUT : br_9 
* INOUT : bl_10 
* INOUT : br_10 
* INOUT : bl_11 
* INOUT : br_11 
* INOUT : bl_12 
* INOUT : br_12 
* INOUT : bl_13 
* INOUT : br_13 
* INOUT : bl_14 
* INOUT : br_14 
* INOUT : bl_15 
* INOUT : br_15 
* INOUT : bl_16 
* INOUT : br_16 
* INOUT : bl_17 
* INOUT : br_17 
* INOUT : bl_18 
* INOUT : br_18 
* INOUT : bl_19 
* INOUT : br_19 
* INOUT : bl_20 
* INOUT : br_20 
* INOUT : bl_21 
* INOUT : br_21 
* INOUT : bl_22 
* INOUT : br_22 
* INOUT : bl_23 
* INOUT : br_23 
* INOUT : bl_24 
* INOUT : br_24 
* INOUT : bl_25 
* INOUT : br_25 
* INOUT : bl_26 
* INOUT : br_26 
* INOUT : bl_27 
* INOUT : br_27 
* INOUT : bl_28 
* INOUT : br_28 
* INOUT : bl_29 
* INOUT : br_29 
* INOUT : bl_30 
* INOUT : br_30 
* INOUT : bl_31 
* INOUT : br_31 
* INOUT : bl_32 
* INOUT : br_32 
* INOUT : bl_33 
* INOUT : br_33 
* INOUT : bl_34 
* INOUT : br_34 
* INOUT : bl_35 
* INOUT : br_35 
* INOUT : bl_36 
* INOUT : br_36 
* INOUT : bl_37 
* INOUT : br_37 
* INOUT : bl_38 
* INOUT : br_38 
* INOUT : bl_39 
* INOUT : br_39 
* INOUT : bl_40 
* INOUT : br_40 
* INOUT : bl_41 
* INOUT : br_41 
* INOUT : bl_42 
* INOUT : br_42 
* INOUT : bl_43 
* INOUT : br_43 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* OUTPUT: dout_6 
* OUTPUT: dout_7 
* OUTPUT: dout_8 
* OUTPUT: dout_9 
* OUTPUT: dout_10 
* OUTPUT: dout_11 
* OUTPUT: dout_12 
* OUTPUT: dout_13 
* OUTPUT: dout_14 
* OUTPUT: dout_15 
* OUTPUT: dout_16 
* OUTPUT: dout_17 
* OUTPUT: dout_18 
* OUTPUT: dout_19 
* OUTPUT: dout_20 
* OUTPUT: dout_21 
* OUTPUT: dout_22 
* OUTPUT: dout_23 
* OUTPUT: dout_24 
* OUTPUT: dout_25 
* OUTPUT: dout_26 
* OUTPUT: dout_27 
* OUTPUT: dout_28 
* OUTPUT: dout_29 
* OUTPUT: dout_30 
* OUTPUT: dout_31 
* OUTPUT: dout_32 
* OUTPUT: dout_33 
* OUTPUT: dout_34 
* OUTPUT: dout_35 
* OUTPUT: dout_36 
* OUTPUT: dout_37 
* OUTPUT: dout_38 
* OUTPUT: dout_39 
* OUTPUT: dout_40 
* OUTPUT: dout_41 
* OUTPUT: dout_42 
* OUTPUT: dout_43 
* INPUT : din_0 
* INPUT : din_1 
* INPUT : din_2 
* INPUT : din_3 
* INPUT : din_4 
* INPUT : din_5 
* INPUT : din_6 
* INPUT : din_7 
* INPUT : din_8 
* INPUT : din_9 
* INPUT : din_10 
* INPUT : din_11 
* INPUT : din_12 
* INPUT : din_13 
* INPUT : din_14 
* INPUT : din_15 
* INPUT : din_16 
* INPUT : din_17 
* INPUT : din_18 
* INPUT : din_19 
* INPUT : din_20 
* INPUT : din_21 
* INPUT : din_22 
* INPUT : din_23 
* INPUT : din_24 
* INPUT : din_25 
* INPUT : din_26 
* INPUT : din_27 
* INPUT : din_28 
* INPUT : din_29 
* INPUT : din_30 
* INPUT : din_31 
* INPUT : din_32 
* INPUT : din_33 
* INPUT : din_34 
* INPUT : din_35 
* INPUT : din_36 
* INPUT : din_37 
* INPUT : din_38 
* INPUT : din_39 
* INPUT : din_40 
* INPUT : din_41 
* INPUT : din_42 
* INPUT : din_43 
* INPUT : s_en 
* INPUT : p_en_bar 
* INPUT : w_en 
* INPUT : bank_wmask_0 
* INPUT : bank_wmask_1 
* INPUT : bank_wmask_2 
* INPUT : bank_wmask_3 
* INPUT : bank_wmask_4 
* INPUT : bank_wmask_5 
* POWER : vdd 
* GROUND: gnd 
Xprecharge_array0 rbl_bl rbl_br bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 p_en_bar vdd precharge_array
Xsense_amp_array0 dout_0 bl_0 br_0 dout_1 bl_1 br_1 dout_2 bl_2 br_2 dout_3 bl_3 br_3 dout_4 bl_4 br_4 dout_5 bl_5 br_5 dout_6 bl_6 br_6 dout_7 bl_7 br_7 dout_8 bl_8 br_8 dout_9 bl_9 br_9 dout_10 bl_10 br_10 dout_11 bl_11 br_11 dout_12 bl_12 br_12 dout_13 bl_13 br_13 dout_14 bl_14 br_14 dout_15 bl_15 br_15 dout_16 bl_16 br_16 dout_17 bl_17 br_17 dout_18 bl_18 br_18 dout_19 bl_19 br_19 dout_20 bl_20 br_20 dout_21 bl_21 br_21 dout_22 bl_22 br_22 dout_23 bl_23 br_23 dout_24 bl_24 br_24 dout_25 bl_25 br_25 dout_26 bl_26 br_26 dout_27 bl_27 br_27 dout_28 bl_28 br_28 dout_29 bl_29 br_29 dout_30 bl_30 br_30 dout_31 bl_31 br_31 dout_32 bl_32 br_32 dout_33 bl_33 br_33 dout_34 bl_34 br_34 dout_35 bl_35 br_35 dout_36 bl_36 br_36 dout_37 bl_37 br_37 dout_38 bl_38 br_38 dout_39 bl_39 br_39 dout_40 bl_40 br_40 dout_41 bl_41 br_41 dout_42 bl_42 br_42 dout_43 bl_43 br_43 s_en vdd gnd sense_amp_array
Xwrite_driver_array0 din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 din_8 din_9 din_10 din_11 din_12 din_13 din_14 din_15 din_16 din_17 din_18 din_19 din_20 din_21 din_22 din_23 din_24 din_25 din_26 din_27 din_28 din_29 din_30 din_31 din_32 din_33 din_34 din_35 din_36 din_37 din_38 din_39 din_40 din_41 din_42 din_43 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 wdriver_sel_0 wdriver_sel_1 wdriver_sel_2 wdriver_sel_3 wdriver_sel_4 wdriver_sel_5 vdd gnd write_driver_array
Xwrite_mask_and_array0 bank_wmask_0 bank_wmask_1 bank_wmask_2 bank_wmask_3 bank_wmask_4 bank_wmask_5 w_en wdriver_sel_0 wdriver_sel_1 wdriver_sel_2 wdriver_sel_3 wdriver_sel_4 wdriver_sel_5 vdd gnd write_mask_and_array
.ENDS port_data

.SUBCKT precharge_1 bl br en_bar vdd
*.PININFO bl:O br:O en_bar:I vdd:B
* OUTPUT: bl 
* OUTPUT: br 
* INPUT : en_bar 
* POWER : vdd 
Xlower_pmos bl en_bar br vdd sky130_fd_pr__pfet_01v8 m=1 w=0.55u l=0.15u
Xupper_pmos1 bl en_bar vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=0.55u l=0.15u
Xupper_pmos2 br en_bar vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=0.55u l=0.15u
.ENDS precharge_1

.SUBCKT precharge_array_0 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 en_bar vdd
*.PININFO bl_0:O br_0:O bl_1:O br_1:O bl_2:O br_2:O bl_3:O br_3:O bl_4:O br_4:O bl_5:O br_5:O bl_6:O br_6:O bl_7:O br_7:O bl_8:O br_8:O bl_9:O br_9:O bl_10:O br_10:O bl_11:O br_11:O bl_12:O br_12:O bl_13:O br_13:O bl_14:O br_14:O bl_15:O br_15:O bl_16:O br_16:O bl_17:O br_17:O bl_18:O br_18:O bl_19:O br_19:O bl_20:O br_20:O bl_21:O br_21:O bl_22:O br_22:O bl_23:O br_23:O bl_24:O br_24:O bl_25:O br_25:O bl_26:O br_26:O bl_27:O br_27:O bl_28:O br_28:O bl_29:O br_29:O bl_30:O br_30:O bl_31:O br_31:O bl_32:O br_32:O bl_33:O br_33:O bl_34:O br_34:O bl_35:O br_35:O bl_36:O br_36:O bl_37:O br_37:O bl_38:O br_38:O bl_39:O br_39:O bl_40:O br_40:O bl_41:O br_41:O bl_42:O br_42:O bl_43:O br_43:O bl_44:O br_44:O en_bar:I vdd:B
* OUTPUT: bl_0 
* OUTPUT: br_0 
* OUTPUT: bl_1 
* OUTPUT: br_1 
* OUTPUT: bl_2 
* OUTPUT: br_2 
* OUTPUT: bl_3 
* OUTPUT: br_3 
* OUTPUT: bl_4 
* OUTPUT: br_4 
* OUTPUT: bl_5 
* OUTPUT: br_5 
* OUTPUT: bl_6 
* OUTPUT: br_6 
* OUTPUT: bl_7 
* OUTPUT: br_7 
* OUTPUT: bl_8 
* OUTPUT: br_8 
* OUTPUT: bl_9 
* OUTPUT: br_9 
* OUTPUT: bl_10 
* OUTPUT: br_10 
* OUTPUT: bl_11 
* OUTPUT: br_11 
* OUTPUT: bl_12 
* OUTPUT: br_12 
* OUTPUT: bl_13 
* OUTPUT: br_13 
* OUTPUT: bl_14 
* OUTPUT: br_14 
* OUTPUT: bl_15 
* OUTPUT: br_15 
* OUTPUT: bl_16 
* OUTPUT: br_16 
* OUTPUT: bl_17 
* OUTPUT: br_17 
* OUTPUT: bl_18 
* OUTPUT: br_18 
* OUTPUT: bl_19 
* OUTPUT: br_19 
* OUTPUT: bl_20 
* OUTPUT: br_20 
* OUTPUT: bl_21 
* OUTPUT: br_21 
* OUTPUT: bl_22 
* OUTPUT: br_22 
* OUTPUT: bl_23 
* OUTPUT: br_23 
* OUTPUT: bl_24 
* OUTPUT: br_24 
* OUTPUT: bl_25 
* OUTPUT: br_25 
* OUTPUT: bl_26 
* OUTPUT: br_26 
* OUTPUT: bl_27 
* OUTPUT: br_27 
* OUTPUT: bl_28 
* OUTPUT: br_28 
* OUTPUT: bl_29 
* OUTPUT: br_29 
* OUTPUT: bl_30 
* OUTPUT: br_30 
* OUTPUT: bl_31 
* OUTPUT: br_31 
* OUTPUT: bl_32 
* OUTPUT: br_32 
* OUTPUT: bl_33 
* OUTPUT: br_33 
* OUTPUT: bl_34 
* OUTPUT: br_34 
* OUTPUT: bl_35 
* OUTPUT: br_35 
* OUTPUT: bl_36 
* OUTPUT: br_36 
* OUTPUT: bl_37 
* OUTPUT: br_37 
* OUTPUT: bl_38 
* OUTPUT: br_38 
* OUTPUT: bl_39 
* OUTPUT: br_39 
* OUTPUT: bl_40 
* OUTPUT: br_40 
* OUTPUT: bl_41 
* OUTPUT: br_41 
* OUTPUT: bl_42 
* OUTPUT: br_42 
* OUTPUT: bl_43 
* OUTPUT: br_43 
* OUTPUT: bl_44 
* OUTPUT: br_44 
* INPUT : en_bar 
* POWER : vdd 
* cols: 45 size: 1 bl: bl1 br: br1
Xpre_column_0 bl_0 br_0 en_bar vdd precharge_1
Xpre_column_1 bl_1 br_1 en_bar vdd precharge_1
Xpre_column_2 bl_2 br_2 en_bar vdd precharge_1
Xpre_column_3 bl_3 br_3 en_bar vdd precharge_1
Xpre_column_4 bl_4 br_4 en_bar vdd precharge_1
Xpre_column_5 bl_5 br_5 en_bar vdd precharge_1
Xpre_column_6 bl_6 br_6 en_bar vdd precharge_1
Xpre_column_7 bl_7 br_7 en_bar vdd precharge_1
Xpre_column_8 bl_8 br_8 en_bar vdd precharge_1
Xpre_column_9 bl_9 br_9 en_bar vdd precharge_1
Xpre_column_10 bl_10 br_10 en_bar vdd precharge_1
Xpre_column_11 bl_11 br_11 en_bar vdd precharge_1
Xpre_column_12 bl_12 br_12 en_bar vdd precharge_1
Xpre_column_13 bl_13 br_13 en_bar vdd precharge_1
Xpre_column_14 bl_14 br_14 en_bar vdd precharge_1
Xpre_column_15 bl_15 br_15 en_bar vdd precharge_1
Xpre_column_16 bl_16 br_16 en_bar vdd precharge_1
Xpre_column_17 bl_17 br_17 en_bar vdd precharge_1
Xpre_column_18 bl_18 br_18 en_bar vdd precharge_1
Xpre_column_19 bl_19 br_19 en_bar vdd precharge_1
Xpre_column_20 bl_20 br_20 en_bar vdd precharge_1
Xpre_column_21 bl_21 br_21 en_bar vdd precharge_1
Xpre_column_22 bl_22 br_22 en_bar vdd precharge_1
Xpre_column_23 bl_23 br_23 en_bar vdd precharge_1
Xpre_column_24 bl_24 br_24 en_bar vdd precharge_1
Xpre_column_25 bl_25 br_25 en_bar vdd precharge_1
Xpre_column_26 bl_26 br_26 en_bar vdd precharge_1
Xpre_column_27 bl_27 br_27 en_bar vdd precharge_1
Xpre_column_28 bl_28 br_28 en_bar vdd precharge_1
Xpre_column_29 bl_29 br_29 en_bar vdd precharge_1
Xpre_column_30 bl_30 br_30 en_bar vdd precharge_1
Xpre_column_31 bl_31 br_31 en_bar vdd precharge_1
Xpre_column_32 bl_32 br_32 en_bar vdd precharge_1
Xpre_column_33 bl_33 br_33 en_bar vdd precharge_1
Xpre_column_34 bl_34 br_34 en_bar vdd precharge_1
Xpre_column_35 bl_35 br_35 en_bar vdd precharge_1
Xpre_column_36 bl_36 br_36 en_bar vdd precharge_1
Xpre_column_37 bl_37 br_37 en_bar vdd precharge_1
Xpre_column_38 bl_38 br_38 en_bar vdd precharge_1
Xpre_column_39 bl_39 br_39 en_bar vdd precharge_1
Xpre_column_40 bl_40 br_40 en_bar vdd precharge_1
Xpre_column_41 bl_41 br_41 en_bar vdd precharge_1
Xpre_column_42 bl_42 br_42 en_bar vdd precharge_1
Xpre_column_43 bl_43 br_43 en_bar vdd precharge_1
Xpre_column_44 bl_44 br_44 en_bar vdd precharge_1
.ENDS precharge_array_0

.SUBCKT port_data_0 rbl_bl rbl_br bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 dout_8 dout_9 dout_10 dout_11 dout_12 dout_13 dout_14 dout_15 dout_16 dout_17 dout_18 dout_19 dout_20 dout_21 dout_22 dout_23 dout_24 dout_25 dout_26 dout_27 dout_28 dout_29 dout_30 dout_31 dout_32 dout_33 dout_34 dout_35 dout_36 dout_37 dout_38 dout_39 dout_40 dout_41 dout_42 dout_43 s_en p_en_bar vdd gnd
*.PININFO rbl_bl:B rbl_br:B bl_0:B br_0:B bl_1:B br_1:B bl_2:B br_2:B bl_3:B br_3:B bl_4:B br_4:B bl_5:B br_5:B bl_6:B br_6:B bl_7:B br_7:B bl_8:B br_8:B bl_9:B br_9:B bl_10:B br_10:B bl_11:B br_11:B bl_12:B br_12:B bl_13:B br_13:B bl_14:B br_14:B bl_15:B br_15:B bl_16:B br_16:B bl_17:B br_17:B bl_18:B br_18:B bl_19:B br_19:B bl_20:B br_20:B bl_21:B br_21:B bl_22:B br_22:B bl_23:B br_23:B bl_24:B br_24:B bl_25:B br_25:B bl_26:B br_26:B bl_27:B br_27:B bl_28:B br_28:B bl_29:B br_29:B bl_30:B br_30:B bl_31:B br_31:B bl_32:B br_32:B bl_33:B br_33:B bl_34:B br_34:B bl_35:B br_35:B bl_36:B br_36:B bl_37:B br_37:B bl_38:B br_38:B bl_39:B br_39:B bl_40:B br_40:B bl_41:B br_41:B bl_42:B br_42:B bl_43:B br_43:B dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O dout_8:O dout_9:O dout_10:O dout_11:O dout_12:O dout_13:O dout_14:O dout_15:O dout_16:O dout_17:O dout_18:O dout_19:O dout_20:O dout_21:O dout_22:O dout_23:O dout_24:O dout_25:O dout_26:O dout_27:O dout_28:O dout_29:O dout_30:O dout_31:O dout_32:O dout_33:O dout_34:O dout_35:O dout_36:O dout_37:O dout_38:O dout_39:O dout_40:O dout_41:O dout_42:O dout_43:O s_en:I p_en_bar:I vdd:B gnd:B
* INOUT : rbl_bl 
* INOUT : rbl_br 
* INOUT : bl_0 
* INOUT : br_0 
* INOUT : bl_1 
* INOUT : br_1 
* INOUT : bl_2 
* INOUT : br_2 
* INOUT : bl_3 
* INOUT : br_3 
* INOUT : bl_4 
* INOUT : br_4 
* INOUT : bl_5 
* INOUT : br_5 
* INOUT : bl_6 
* INOUT : br_6 
* INOUT : bl_7 
* INOUT : br_7 
* INOUT : bl_8 
* INOUT : br_8 
* INOUT : bl_9 
* INOUT : br_9 
* INOUT : bl_10 
* INOUT : br_10 
* INOUT : bl_11 
* INOUT : br_11 
* INOUT : bl_12 
* INOUT : br_12 
* INOUT : bl_13 
* INOUT : br_13 
* INOUT : bl_14 
* INOUT : br_14 
* INOUT : bl_15 
* INOUT : br_15 
* INOUT : bl_16 
* INOUT : br_16 
* INOUT : bl_17 
* INOUT : br_17 
* INOUT : bl_18 
* INOUT : br_18 
* INOUT : bl_19 
* INOUT : br_19 
* INOUT : bl_20 
* INOUT : br_20 
* INOUT : bl_21 
* INOUT : br_21 
* INOUT : bl_22 
* INOUT : br_22 
* INOUT : bl_23 
* INOUT : br_23 
* INOUT : bl_24 
* INOUT : br_24 
* INOUT : bl_25 
* INOUT : br_25 
* INOUT : bl_26 
* INOUT : br_26 
* INOUT : bl_27 
* INOUT : br_27 
* INOUT : bl_28 
* INOUT : br_28 
* INOUT : bl_29 
* INOUT : br_29 
* INOUT : bl_30 
* INOUT : br_30 
* INOUT : bl_31 
* INOUT : br_31 
* INOUT : bl_32 
* INOUT : br_32 
* INOUT : bl_33 
* INOUT : br_33 
* INOUT : bl_34 
* INOUT : br_34 
* INOUT : bl_35 
* INOUT : br_35 
* INOUT : bl_36 
* INOUT : br_36 
* INOUT : bl_37 
* INOUT : br_37 
* INOUT : bl_38 
* INOUT : br_38 
* INOUT : bl_39 
* INOUT : br_39 
* INOUT : bl_40 
* INOUT : br_40 
* INOUT : bl_41 
* INOUT : br_41 
* INOUT : bl_42 
* INOUT : br_42 
* INOUT : bl_43 
* INOUT : br_43 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* OUTPUT: dout_6 
* OUTPUT: dout_7 
* OUTPUT: dout_8 
* OUTPUT: dout_9 
* OUTPUT: dout_10 
* OUTPUT: dout_11 
* OUTPUT: dout_12 
* OUTPUT: dout_13 
* OUTPUT: dout_14 
* OUTPUT: dout_15 
* OUTPUT: dout_16 
* OUTPUT: dout_17 
* OUTPUT: dout_18 
* OUTPUT: dout_19 
* OUTPUT: dout_20 
* OUTPUT: dout_21 
* OUTPUT: dout_22 
* OUTPUT: dout_23 
* OUTPUT: dout_24 
* OUTPUT: dout_25 
* OUTPUT: dout_26 
* OUTPUT: dout_27 
* OUTPUT: dout_28 
* OUTPUT: dout_29 
* OUTPUT: dout_30 
* OUTPUT: dout_31 
* OUTPUT: dout_32 
* OUTPUT: dout_33 
* OUTPUT: dout_34 
* OUTPUT: dout_35 
* OUTPUT: dout_36 
* OUTPUT: dout_37 
* OUTPUT: dout_38 
* OUTPUT: dout_39 
* OUTPUT: dout_40 
* OUTPUT: dout_41 
* OUTPUT: dout_42 
* OUTPUT: dout_43 
* INPUT : s_en 
* INPUT : p_en_bar 
* POWER : vdd 
* GROUND: gnd 
Xprecharge_array1 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 rbl_bl rbl_br p_en_bar vdd precharge_array_0
Xsense_amp_array1 dout_0 bl_0 br_0 dout_1 bl_1 br_1 dout_2 bl_2 br_2 dout_3 bl_3 br_3 dout_4 bl_4 br_4 dout_5 bl_5 br_5 dout_6 bl_6 br_6 dout_7 bl_7 br_7 dout_8 bl_8 br_8 dout_9 bl_9 br_9 dout_10 bl_10 br_10 dout_11 bl_11 br_11 dout_12 bl_12 br_12 dout_13 bl_13 br_13 dout_14 bl_14 br_14 dout_15 bl_15 br_15 dout_16 bl_16 br_16 dout_17 bl_17 br_17 dout_18 bl_18 br_18 dout_19 bl_19 br_19 dout_20 bl_20 br_20 dout_21 bl_21 br_21 dout_22 bl_22 br_22 dout_23 bl_23 br_23 dout_24 bl_24 br_24 dout_25 bl_25 br_25 dout_26 bl_26 br_26 dout_27 bl_27 br_27 dout_28 bl_28 br_28 dout_29 bl_29 br_29 dout_30 bl_30 br_30 dout_31 bl_31 br_31 dout_32 bl_32 br_32 dout_33 bl_33 br_33 dout_34 bl_34 br_34 dout_35 bl_35 br_35 dout_36 bl_36 br_36 dout_37 bl_37 br_37 dout_38 bl_38 br_38 dout_39 bl_39 br_39 dout_40 bl_40 br_40 dout_41 bl_41 br_41 dout_42 bl_42 br_42 dout_43 bl_43 br_43 s_en vdd gnd sense_amp_array
.ENDS port_data_0

.SUBCKT bank dout0_0 dout0_1 dout0_2 dout0_3 dout0_4 dout0_5 dout0_6 dout0_7 dout0_8 dout0_9 dout0_10 dout0_11 dout0_12 dout0_13 dout0_14 dout0_15 dout0_16 dout0_17 dout0_18 dout0_19 dout0_20 dout0_21 dout0_22 dout0_23 dout0_24 dout0_25 dout0_26 dout0_27 dout0_28 dout0_29 dout0_30 dout0_31 dout0_32 dout0_33 dout0_34 dout0_35 dout0_36 dout0_37 dout0_38 dout0_39 dout0_40 dout0_41 dout0_42 dout0_43 dout1_0 dout1_1 dout1_2 dout1_3 dout1_4 dout1_5 dout1_6 dout1_7 dout1_8 dout1_9 dout1_10 dout1_11 dout1_12 dout1_13 dout1_14 dout1_15 dout1_16 dout1_17 dout1_18 dout1_19 dout1_20 dout1_21 dout1_22 dout1_23 dout1_24 dout1_25 dout1_26 dout1_27 dout1_28 dout1_29 dout1_30 dout1_31 dout1_32 dout1_33 dout1_34 dout1_35 dout1_36 dout1_37 dout1_38 dout1_39 dout1_40 dout1_41 dout1_42 dout1_43 rbl_bl_0_0 rbl_bl_1_1 din0_0 din0_1 din0_2 din0_3 din0_4 din0_5 din0_6 din0_7 din0_8 din0_9 din0_10 din0_11 din0_12 din0_13 din0_14 din0_15 din0_16 din0_17 din0_18 din0_19 din0_20 din0_21 din0_22 din0_23 din0_24 din0_25 din0_26 din0_27 din0_28 din0_29 din0_30 din0_31 din0_32 din0_33 din0_34 din0_35 din0_36 din0_37 din0_38 din0_39 din0_40 din0_41 din0_42 din0_43 addr0_0 addr0_1 addr0_2 addr0_3 addr0_4 addr0_5 addr1_0 addr1_1 addr1_2 addr1_3 addr1_4 addr1_5 s_en0 s_en1 p_en_bar0 p_en_bar1 w_en0 bank_wmask0_0 bank_wmask0_1 bank_wmask0_2 bank_wmask0_3 bank_wmask0_4 bank_wmask0_5 wl_en0 wl_en1 vdd gnd
*.PININFO dout0_0:O dout0_1:O dout0_2:O dout0_3:O dout0_4:O dout0_5:O dout0_6:O dout0_7:O dout0_8:O dout0_9:O dout0_10:O dout0_11:O dout0_12:O dout0_13:O dout0_14:O dout0_15:O dout0_16:O dout0_17:O dout0_18:O dout0_19:O dout0_20:O dout0_21:O dout0_22:O dout0_23:O dout0_24:O dout0_25:O dout0_26:O dout0_27:O dout0_28:O dout0_29:O dout0_30:O dout0_31:O dout0_32:O dout0_33:O dout0_34:O dout0_35:O dout0_36:O dout0_37:O dout0_38:O dout0_39:O dout0_40:O dout0_41:O dout0_42:O dout0_43:O dout1_0:O dout1_1:O dout1_2:O dout1_3:O dout1_4:O dout1_5:O dout1_6:O dout1_7:O dout1_8:O dout1_9:O dout1_10:O dout1_11:O dout1_12:O dout1_13:O dout1_14:O dout1_15:O dout1_16:O dout1_17:O dout1_18:O dout1_19:O dout1_20:O dout1_21:O dout1_22:O dout1_23:O dout1_24:O dout1_25:O dout1_26:O dout1_27:O dout1_28:O dout1_29:O dout1_30:O dout1_31:O dout1_32:O dout1_33:O dout1_34:O dout1_35:O dout1_36:O dout1_37:O dout1_38:O dout1_39:O dout1_40:O dout1_41:O dout1_42:O dout1_43:O rbl_bl_0_0:O rbl_bl_1_1:O din0_0:I din0_1:I din0_2:I din0_3:I din0_4:I din0_5:I din0_6:I din0_7:I din0_8:I din0_9:I din0_10:I din0_11:I din0_12:I din0_13:I din0_14:I din0_15:I din0_16:I din0_17:I din0_18:I din0_19:I din0_20:I din0_21:I din0_22:I din0_23:I din0_24:I din0_25:I din0_26:I din0_27:I din0_28:I din0_29:I din0_30:I din0_31:I din0_32:I din0_33:I din0_34:I din0_35:I din0_36:I din0_37:I din0_38:I din0_39:I din0_40:I din0_41:I din0_42:I din0_43:I addr0_0:I addr0_1:I addr0_2:I addr0_3:I addr0_4:I addr0_5:I addr1_0:I addr1_1:I addr1_2:I addr1_3:I addr1_4:I addr1_5:I s_en0:I s_en1:I p_en_bar0:I p_en_bar1:I w_en0:I bank_wmask0_0:I bank_wmask0_1:I bank_wmask0_2:I bank_wmask0_3:I bank_wmask0_4:I bank_wmask0_5:I wl_en0:I wl_en1:I vdd:B gnd:B
* OUTPUT: dout0_0 
* OUTPUT: dout0_1 
* OUTPUT: dout0_2 
* OUTPUT: dout0_3 
* OUTPUT: dout0_4 
* OUTPUT: dout0_5 
* OUTPUT: dout0_6 
* OUTPUT: dout0_7 
* OUTPUT: dout0_8 
* OUTPUT: dout0_9 
* OUTPUT: dout0_10 
* OUTPUT: dout0_11 
* OUTPUT: dout0_12 
* OUTPUT: dout0_13 
* OUTPUT: dout0_14 
* OUTPUT: dout0_15 
* OUTPUT: dout0_16 
* OUTPUT: dout0_17 
* OUTPUT: dout0_18 
* OUTPUT: dout0_19 
* OUTPUT: dout0_20 
* OUTPUT: dout0_21 
* OUTPUT: dout0_22 
* OUTPUT: dout0_23 
* OUTPUT: dout0_24 
* OUTPUT: dout0_25 
* OUTPUT: dout0_26 
* OUTPUT: dout0_27 
* OUTPUT: dout0_28 
* OUTPUT: dout0_29 
* OUTPUT: dout0_30 
* OUTPUT: dout0_31 
* OUTPUT: dout0_32 
* OUTPUT: dout0_33 
* OUTPUT: dout0_34 
* OUTPUT: dout0_35 
* OUTPUT: dout0_36 
* OUTPUT: dout0_37 
* OUTPUT: dout0_38 
* OUTPUT: dout0_39 
* OUTPUT: dout0_40 
* OUTPUT: dout0_41 
* OUTPUT: dout0_42 
* OUTPUT: dout0_43 
* OUTPUT: dout1_0 
* OUTPUT: dout1_1 
* OUTPUT: dout1_2 
* OUTPUT: dout1_3 
* OUTPUT: dout1_4 
* OUTPUT: dout1_5 
* OUTPUT: dout1_6 
* OUTPUT: dout1_7 
* OUTPUT: dout1_8 
* OUTPUT: dout1_9 
* OUTPUT: dout1_10 
* OUTPUT: dout1_11 
* OUTPUT: dout1_12 
* OUTPUT: dout1_13 
* OUTPUT: dout1_14 
* OUTPUT: dout1_15 
* OUTPUT: dout1_16 
* OUTPUT: dout1_17 
* OUTPUT: dout1_18 
* OUTPUT: dout1_19 
* OUTPUT: dout1_20 
* OUTPUT: dout1_21 
* OUTPUT: dout1_22 
* OUTPUT: dout1_23 
* OUTPUT: dout1_24 
* OUTPUT: dout1_25 
* OUTPUT: dout1_26 
* OUTPUT: dout1_27 
* OUTPUT: dout1_28 
* OUTPUT: dout1_29 
* OUTPUT: dout1_30 
* OUTPUT: dout1_31 
* OUTPUT: dout1_32 
* OUTPUT: dout1_33 
* OUTPUT: dout1_34 
* OUTPUT: dout1_35 
* OUTPUT: dout1_36 
* OUTPUT: dout1_37 
* OUTPUT: dout1_38 
* OUTPUT: dout1_39 
* OUTPUT: dout1_40 
* OUTPUT: dout1_41 
* OUTPUT: dout1_42 
* OUTPUT: dout1_43 
* OUTPUT: rbl_bl_0_0 
* OUTPUT: rbl_bl_1_1 
* INPUT : din0_0 
* INPUT : din0_1 
* INPUT : din0_2 
* INPUT : din0_3 
* INPUT : din0_4 
* INPUT : din0_5 
* INPUT : din0_6 
* INPUT : din0_7 
* INPUT : din0_8 
* INPUT : din0_9 
* INPUT : din0_10 
* INPUT : din0_11 
* INPUT : din0_12 
* INPUT : din0_13 
* INPUT : din0_14 
* INPUT : din0_15 
* INPUT : din0_16 
* INPUT : din0_17 
* INPUT : din0_18 
* INPUT : din0_19 
* INPUT : din0_20 
* INPUT : din0_21 
* INPUT : din0_22 
* INPUT : din0_23 
* INPUT : din0_24 
* INPUT : din0_25 
* INPUT : din0_26 
* INPUT : din0_27 
* INPUT : din0_28 
* INPUT : din0_29 
* INPUT : din0_30 
* INPUT : din0_31 
* INPUT : din0_32 
* INPUT : din0_33 
* INPUT : din0_34 
* INPUT : din0_35 
* INPUT : din0_36 
* INPUT : din0_37 
* INPUT : din0_38 
* INPUT : din0_39 
* INPUT : din0_40 
* INPUT : din0_41 
* INPUT : din0_42 
* INPUT : din0_43 
* INPUT : addr0_0 
* INPUT : addr0_1 
* INPUT : addr0_2 
* INPUT : addr0_3 
* INPUT : addr0_4 
* INPUT : addr0_5 
* INPUT : addr1_0 
* INPUT : addr1_1 
* INPUT : addr1_2 
* INPUT : addr1_3 
* INPUT : addr1_4 
* INPUT : addr1_5 
* INPUT : s_en0 
* INPUT : s_en1 
* INPUT : p_en_bar0 
* INPUT : p_en_bar1 
* INPUT : w_en0 
* INPUT : bank_wmask0_0 
* INPUT : bank_wmask0_1 
* INPUT : bank_wmask0_2 
* INPUT : bank_wmask0_3 
* INPUT : bank_wmask0_4 
* INPUT : bank_wmask0_5 
* INPUT : wl_en0 
* INPUT : wl_en1 
* POWER : vdd 
* GROUND: gnd 
Xbitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 bl_0_28 bl_1_28 br_0_28 br_1_28 bl_0_29 bl_1_29 br_0_29 br_1_29 bl_0_30 bl_1_30 br_0_30 br_1_30 bl_0_31 bl_1_31 br_0_31 br_1_31 bl_0_32 bl_1_32 br_0_32 br_1_32 bl_0_33 bl_1_33 br_0_33 br_1_33 bl_0_34 bl_1_34 br_0_34 br_1_34 bl_0_35 bl_1_35 br_0_35 br_1_35 bl_0_36 bl_1_36 br_0_36 br_1_36 bl_0_37 bl_1_37 br_0_37 br_1_37 bl_0_38 bl_1_38 br_0_38 br_1_38 bl_0_39 bl_1_39 br_0_39 br_1_39 bl_0_40 bl_1_40 br_0_40 br_1_40 bl_0_41 bl_1_41 br_0_41 br_1_41 bl_0_42 bl_1_42 br_0_42 br_1_42 bl_0_43 bl_1_43 br_0_43 br_1_43 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 rbl_wl1 vdd gnd global_bitcell_array
Xport_data0 rbl_bl_0_0 rbl_br_0_0 bl_0_0 br_0_0 bl_0_1 br_0_1 bl_0_2 br_0_2 bl_0_3 br_0_3 bl_0_4 br_0_4 bl_0_5 br_0_5 bl_0_6 br_0_6 bl_0_7 br_0_7 bl_0_8 br_0_8 bl_0_9 br_0_9 bl_0_10 br_0_10 bl_0_11 br_0_11 bl_0_12 br_0_12 bl_0_13 br_0_13 bl_0_14 br_0_14 bl_0_15 br_0_15 bl_0_16 br_0_16 bl_0_17 br_0_17 bl_0_18 br_0_18 bl_0_19 br_0_19 bl_0_20 br_0_20 bl_0_21 br_0_21 bl_0_22 br_0_22 bl_0_23 br_0_23 bl_0_24 br_0_24 bl_0_25 br_0_25 bl_0_26 br_0_26 bl_0_27 br_0_27 bl_0_28 br_0_28 bl_0_29 br_0_29 bl_0_30 br_0_30 bl_0_31 br_0_31 bl_0_32 br_0_32 bl_0_33 br_0_33 bl_0_34 br_0_34 bl_0_35 br_0_35 bl_0_36 br_0_36 bl_0_37 br_0_37 bl_0_38 br_0_38 bl_0_39 br_0_39 bl_0_40 br_0_40 bl_0_41 br_0_41 bl_0_42 br_0_42 bl_0_43 br_0_43 dout0_0 dout0_1 dout0_2 dout0_3 dout0_4 dout0_5 dout0_6 dout0_7 dout0_8 dout0_9 dout0_10 dout0_11 dout0_12 dout0_13 dout0_14 dout0_15 dout0_16 dout0_17 dout0_18 dout0_19 dout0_20 dout0_21 dout0_22 dout0_23 dout0_24 dout0_25 dout0_26 dout0_27 dout0_28 dout0_29 dout0_30 dout0_31 dout0_32 dout0_33 dout0_34 dout0_35 dout0_36 dout0_37 dout0_38 dout0_39 dout0_40 dout0_41 dout0_42 dout0_43 din0_0 din0_1 din0_2 din0_3 din0_4 din0_5 din0_6 din0_7 din0_8 din0_9 din0_10 din0_11 din0_12 din0_13 din0_14 din0_15 din0_16 din0_17 din0_18 din0_19 din0_20 din0_21 din0_22 din0_23 din0_24 din0_25 din0_26 din0_27 din0_28 din0_29 din0_30 din0_31 din0_32 din0_33 din0_34 din0_35 din0_36 din0_37 din0_38 din0_39 din0_40 din0_41 din0_42 din0_43 s_en0 p_en_bar0 w_en0 bank_wmask0_0 bank_wmask0_1 bank_wmask0_2 bank_wmask0_3 bank_wmask0_4 bank_wmask0_5 vdd gnd port_data
Xport_data1 rbl_bl_1_1 rbl_br_1_1 bl_1_0 br_1_0 bl_1_1 br_1_1 bl_1_2 br_1_2 bl_1_3 br_1_3 bl_1_4 br_1_4 bl_1_5 br_1_5 bl_1_6 br_1_6 bl_1_7 br_1_7 bl_1_8 br_1_8 bl_1_9 br_1_9 bl_1_10 br_1_10 bl_1_11 br_1_11 bl_1_12 br_1_12 bl_1_13 br_1_13 bl_1_14 br_1_14 bl_1_15 br_1_15 bl_1_16 br_1_16 bl_1_17 br_1_17 bl_1_18 br_1_18 bl_1_19 br_1_19 bl_1_20 br_1_20 bl_1_21 br_1_21 bl_1_22 br_1_22 bl_1_23 br_1_23 bl_1_24 br_1_24 bl_1_25 br_1_25 bl_1_26 br_1_26 bl_1_27 br_1_27 bl_1_28 br_1_28 bl_1_29 br_1_29 bl_1_30 br_1_30 bl_1_31 br_1_31 bl_1_32 br_1_32 bl_1_33 br_1_33 bl_1_34 br_1_34 bl_1_35 br_1_35 bl_1_36 br_1_36 bl_1_37 br_1_37 bl_1_38 br_1_38 bl_1_39 br_1_39 bl_1_40 br_1_40 bl_1_41 br_1_41 bl_1_42 br_1_42 bl_1_43 br_1_43 dout1_0 dout1_1 dout1_2 dout1_3 dout1_4 dout1_5 dout1_6 dout1_7 dout1_8 dout1_9 dout1_10 dout1_11 dout1_12 dout1_13 dout1_14 dout1_15 dout1_16 dout1_17 dout1_18 dout1_19 dout1_20 dout1_21 dout1_22 dout1_23 dout1_24 dout1_25 dout1_26 dout1_27 dout1_28 dout1_29 dout1_30 dout1_31 dout1_32 dout1_33 dout1_34 dout1_35 dout1_36 dout1_37 dout1_38 dout1_39 dout1_40 dout1_41 dout1_42 dout1_43 s_en1 p_en_bar1 vdd gnd port_data_0
Xport_address0 addr0_0 addr0_1 addr0_2 addr0_3 addr0_4 addr0_5 wl_en0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 rbl_wl0 vdd gnd port_address
Xport_address1 addr1_0 addr1_1 addr1_2 addr1_3 addr1_4 addr1_5 wl_en1 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 rbl_wl1 vdd gnd port_address_0
.ENDS bank

.SUBCKT pinv_0 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=2 w=1.26u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=2 w=0.74u l=0.15u
.ENDS pinv_0

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=3 w=1.68 l=0.15 pd=3.66 ps=3.66 as=0.63u ad=0.63u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=3 w=1.68 l=0.15 pd=3.66 ps=3.66 as=0.63u ad=0.63u

.SUBCKT pinv_1 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=3 w=1.68u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=3 w=1.68u l=0.15u
.ENDS pinv_1

.SUBCKT dff_buf_0 D Q Qb clk vdd gnd
*.PININFO D:I Q:O Qb:O clk:I vdd:B gnd:B
* INPUT : D 
* OUTPUT: Q 
* OUTPUT: Qb 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* inv1: 2 inv2: 4
Xdff_buf_dff D qint clk vdd gnd sky130_fd_bd_sram__openram_sram_dff
Xdff_buf_inv1 qint Qb vdd gnd pinv_0
Xdff_buf_inv2 Qb Q vdd gnd pinv_1
.ENDS dff_buf_0

.SUBCKT dff_buf_array din_0 din_1 dout_0 dout_bar_0 dout_1 dout_bar_1 clk vdd gnd
*.PININFO din_0:I din_1:I dout_0:O dout_bar_0:O dout_1:O dout_bar_1:O clk:I vdd:B gnd:B
* INPUT : din_0 
* INPUT : din_1 
* OUTPUT: dout_0 
* OUTPUT: dout_bar_0 
* OUTPUT: dout_1 
* OUTPUT: dout_bar_1 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* inv1: 2 inv2: 4
Xdff_r0_c0 din_0 dout_0 dout_bar_0 clk vdd gnd dff_buf_0
Xdff_r1_c0 din_1 dout_1 dout_bar_1 clk vdd gnd dff_buf_0
.ENDS dff_buf_array

.SUBCKT pnand2_0 A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpnand2_pmos1 vdd A Z vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand2_pmos2 Z B vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand2_nmos1 Z B net1 gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
Xpnand2_nmos2 net1 A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
.ENDS pnand2_0

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=7 w=1.68 l=0.15 pd=3.66 ps=3.66 as=0.63u ad=0.63u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=7 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_2 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=7 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=7 w=1.68u l=0.15u
.ENDS pinv_2

.SUBCKT pdriver_0 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [12]
Xbuf_inv1 A Z vdd gnd pinv_2
.ENDS pdriver_0

.SUBCKT pand2_0 A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpand2_nand A B zb_int vdd gnd pnand2_0
Xpand2_inv zb_int Z vdd gnd pdriver_0
.ENDS pand2_0

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=6 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=6 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_3 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=6 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=6 w=2.0u l=0.15u
.ENDS pinv_3

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=24 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=24 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_4 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=24 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=24 w=2.0u l=0.15u
.ENDS pinv_4

.SUBCKT pbuf A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xbuf_inv1 A zb_int vdd gnd pinv_3
Xbuf_inv2 zb_int Z vdd gnd pinv_4
.ENDS pbuf

.SUBCKT pinv_5 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_5

.SUBCKT pinv_6 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_6

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=2 w=1.26 l=0.15 pd=2.82 ps=2.82 as=0.47u ad=0.47u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=2 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_7 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=2 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=2 w=1.26u l=0.15u
.ENDS pinv_7

.SUBCKT pinv_8 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=6 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=6 w=2.0u l=0.15u
.ENDS pinv_8

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=16 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=16 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_9 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=16 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=16 w=2.0u l=0.15u
.ENDS pinv_9

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=48 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=48 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_10 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=48 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=48 w=2.0u l=0.15u
.ENDS pinv_10

.SUBCKT pdriver_1 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 1, 3, 10, 29, 88]
Xbuf_inv1 A Zb1_int vdd gnd pinv_5
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_6
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_7
Xbuf_inv4 Zb3_int Zb4_int vdd gnd pinv_8
Xbuf_inv5 Zb4_int Zb5_int vdd gnd pinv_9
Xbuf_inv6 Zb5_int Z vdd gnd pinv_10
.ENDS pdriver_1

.SUBCKT pinv_11 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=2 w=1.26u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=2 w=0.74u l=0.15u
.ENDS pinv_11

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=4 w=1.26 l=0.15 pd=2.82 ps=2.82 as=0.47u ad=0.47u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=4 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_12 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=4 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=4 w=1.26u l=0.15u
.ENDS pinv_12

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=12 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=12 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_13 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=12 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=12 w=2.0u l=0.15u
.ENDS pinv_13

.SUBCKT pdriver_2 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 2, 7, 21]
Xbuf_inv1 A Zb1_int vdd gnd pinv_5
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_11
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_12
Xbuf_inv4 Zb3_int Z vdd gnd pinv_13
.ENDS pdriver_2

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=0.74 l=0.15 pd=1.78 ps=1.78 as=0.28u ad=0.28u

.SUBCKT pnand3 A B C Z vdd gnd
*.PININFO A:I B:I C:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* INPUT : C 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpnand3_pmos1 vdd A Z vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand3_pmos2 Z B vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand3_pmos3 Z C vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand3_nmos1 Z C net1 gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
Xpnand3_nmos2 net1 B net2 gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
Xpnand3_nmos3 net2 A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
.ENDS pnand3

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=29 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=29 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_14 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=29 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=29 w=2.0u l=0.15u
.ENDS pinv_14

.SUBCKT pdriver_3 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [52]
Xbuf_inv1 A Z vdd gnd pinv_14
.ENDS pdriver_3

.SUBCKT pand3 A B C Z vdd gnd
*.PININFO A:I B:I C:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* INPUT : C 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpand3_nand A B C zb_int vdd gnd pnand3
Xpand3_inv zb_int Z vdd gnd pdriver_3
.ENDS pand3

.SUBCKT pinv_15 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=24 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=24 w=2.0u l=0.15u
.ENDS pinv_15

.SUBCKT pdriver_4 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [44]
Xbuf_inv1 A Z vdd gnd pinv_15
.ENDS pdriver_4

.SUBCKT pand3_0 A B C Z vdd gnd
*.PININFO A:I B:I C:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* INPUT : C 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpand3_nand A B C zb_int vdd gnd pnand3
Xpand3_inv zb_int Z vdd gnd pdriver_4
.ENDS pand3_0

.SUBCKT pinv_16 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_16

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=3 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=3 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_17 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=3 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=3 w=2.0u l=0.15u
.ENDS pinv_17

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=9 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=9 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_18 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=9 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=9 w=2.0u l=0.15u
.ENDS pinv_18

.SUBCKT pdriver_5 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 2, 5, 15]
Xbuf_inv1 A Zb1_int vdd gnd pinv_5
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_11
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_17
Xbuf_inv4 Zb3_int Z vdd gnd pinv_18
.ENDS pdriver_5

.SUBCKT pnand2_1 A B Z vdd gnd
*.PININFO A:I B:I Z:O vdd:B gnd:B
* INPUT : A 
* INPUT : B 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpnand2_pmos1 vdd A Z vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand2_pmos2 Z B vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpnand2_nmos1 Z B net1 gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
Xpnand2_nmos2 net1 A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.74u l=0.15u
.ENDS pnand2_1

.SUBCKT pinv_19 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_19

.SUBCKT delay_chain in out vdd gnd
*.PININFO in:I out:O vdd:B gnd:B
* INPUT : in 
* OUTPUT: out 
* POWER : vdd 
* GROUND: gnd 
* fanouts: [4, 4, 4, 4, 4, 4, 4, 4, 4]
Xdinv0 in dout_1 vdd gnd pinv_19
Xdload_0_0 dout_1 n_0_0 vdd gnd pinv_19
Xdload_0_1 dout_1 n_0_1 vdd gnd pinv_19
Xdload_0_2 dout_1 n_0_2 vdd gnd pinv_19
Xdload_0_3 dout_1 n_0_3 vdd gnd pinv_19
Xdinv1 dout_1 dout_2 vdd gnd pinv_19
Xdload_1_0 dout_2 n_1_0 vdd gnd pinv_19
Xdload_1_1 dout_2 n_1_1 vdd gnd pinv_19
Xdload_1_2 dout_2 n_1_2 vdd gnd pinv_19
Xdload_1_3 dout_2 n_1_3 vdd gnd pinv_19
Xdinv2 dout_2 dout_3 vdd gnd pinv_19
Xdload_2_0 dout_3 n_2_0 vdd gnd pinv_19
Xdload_2_1 dout_3 n_2_1 vdd gnd pinv_19
Xdload_2_2 dout_3 n_2_2 vdd gnd pinv_19
Xdload_2_3 dout_3 n_2_3 vdd gnd pinv_19
Xdinv3 dout_3 dout_4 vdd gnd pinv_19
Xdload_3_0 dout_4 n_3_0 vdd gnd pinv_19
Xdload_3_1 dout_4 n_3_1 vdd gnd pinv_19
Xdload_3_2 dout_4 n_3_2 vdd gnd pinv_19
Xdload_3_3 dout_4 n_3_3 vdd gnd pinv_19
Xdinv4 dout_4 dout_5 vdd gnd pinv_19
Xdload_4_0 dout_5 n_4_0 vdd gnd pinv_19
Xdload_4_1 dout_5 n_4_1 vdd gnd pinv_19
Xdload_4_2 dout_5 n_4_2 vdd gnd pinv_19
Xdload_4_3 dout_5 n_4_3 vdd gnd pinv_19
Xdinv5 dout_5 dout_6 vdd gnd pinv_19
Xdload_5_0 dout_6 n_5_0 vdd gnd pinv_19
Xdload_5_1 dout_6 n_5_1 vdd gnd pinv_19
Xdload_5_2 dout_6 n_5_2 vdd gnd pinv_19
Xdload_5_3 dout_6 n_5_3 vdd gnd pinv_19
Xdinv6 dout_6 dout_7 vdd gnd pinv_19
Xdload_6_0 dout_7 n_6_0 vdd gnd pinv_19
Xdload_6_1 dout_7 n_6_1 vdd gnd pinv_19
Xdload_6_2 dout_7 n_6_2 vdd gnd pinv_19
Xdload_6_3 dout_7 n_6_3 vdd gnd pinv_19
Xdinv7 dout_7 dout_8 vdd gnd pinv_19
Xdload_7_0 dout_8 n_7_0 vdd gnd pinv_19
Xdload_7_1 dout_8 n_7_1 vdd gnd pinv_19
Xdload_7_2 dout_8 n_7_2 vdd gnd pinv_19
Xdload_7_3 dout_8 n_7_3 vdd gnd pinv_19
Xdinv8 dout_8 out vdd gnd pinv_19
Xdload_8_0 out n_8_0 vdd gnd pinv_19
Xdload_8_1 out n_8_1 vdd gnd pinv_19
Xdload_8_2 out n_8_2 vdd gnd pinv_19
Xdload_8_3 out n_8_3 vdd gnd pinv_19
.ENDS delay_chain

.SUBCKT control_logic_rw csb web clk rbl_bl s_en w_en p_en_bar wl_en clk_buf vdd gnd
*.PININFO csb:I web:I clk:I rbl_bl:I s_en:O w_en:O p_en_bar:O wl_en:O clk_buf:O vdd:B gnd:B
* INPUT : csb 
* INPUT : web 
* INPUT : clk 
* INPUT : rbl_bl 
* OUTPUT: s_en 
* OUTPUT: w_en 
* OUTPUT: p_en_bar 
* OUTPUT: wl_en 
* OUTPUT: clk_buf 
* POWER : vdd 
* GROUND: gnd 
* word_size 44
Xctrl_dffs csb web cs_bar cs we_bar we clk_buf vdd gnd dff_buf_array
Xclkbuf clk clk_buf vdd gnd pdriver_1
Xinv_clk_bar clk_buf clk_bar vdd gnd pinv_16
Xand2_gated_clk_bar clk_bar cs gated_clk_bar vdd gnd pand2_0
Xand2_gated_clk_buf clk_buf cs gated_clk_buf vdd gnd pand2_0
Xbuf_wl_en gated_clk_bar wl_en vdd gnd pdriver_2
Xrbl_bl_delay_inv rbl_bl_delay rbl_bl_delay_bar vdd gnd pinv_16
Xw_en_and we rbl_bl_delay_bar gated_clk_bar w_en vdd gnd pand3
Xbuf_s_en_and rbl_bl_delay gated_clk_bar we_bar s_en vdd gnd pand3_0
Xdelay_chain rbl_bl rbl_bl_delay vdd gnd delay_chain
Xnand_p_en_bar gated_clk_buf rbl_bl_delay p_en_bar_unbuf vdd gnd pnand2_1
Xbuf_p_en_bar p_en_bar_unbuf p_en_bar vdd gnd pdriver_5
.ENDS control_logic_rw

.SUBCKT dff_buf_array_0 din_0 dout_0 dout_bar_0 clk vdd gnd
*.PININFO din_0:I dout_0:O dout_bar_0:O clk:I vdd:B gnd:B
* INPUT : din_0 
* OUTPUT: dout_0 
* OUTPUT: dout_bar_0 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* inv1: 2 inv2: 4
Xdff_r0_c0 din_0 dout_0 dout_bar_0 clk vdd gnd dff_buf_0
.ENDS dff_buf_array_0

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=47 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=47 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_20 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=47 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=47 w=2.0u l=0.15u
.ENDS pinv_20

.SUBCKT pdriver_6 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 1, 3, 10, 29, 87]
Xbuf_inv1 A Zb1_int vdd gnd pinv_5
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_6
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_7
Xbuf_inv4 Zb3_int Zb4_int vdd gnd pinv_8
Xbuf_inv5 Zb4_int Zb5_int vdd gnd pinv_9
Xbuf_inv6 Zb5_int Z vdd gnd pinv_20
.ENDS pdriver_6

.SUBCKT control_logic_r csb clk rbl_bl s_en p_en_bar wl_en clk_buf vdd gnd
*.PININFO csb:I clk:I rbl_bl:I s_en:O p_en_bar:O wl_en:O clk_buf:O vdd:B gnd:B
* INPUT : csb 
* INPUT : clk 
* INPUT : rbl_bl 
* OUTPUT: s_en 
* OUTPUT: p_en_bar 
* OUTPUT: wl_en 
* OUTPUT: clk_buf 
* POWER : vdd 
* GROUND: gnd 
* word_size 44
Xctrl_dffs csb cs_bar cs clk_buf vdd gnd dff_buf_array_0
Xclkbuf clk clk_buf vdd gnd pdriver_6
Xinv_clk_bar clk_buf clk_bar vdd gnd pinv_16
Xand2_gated_clk_bar clk_bar cs gated_clk_bar vdd gnd pand2_0
Xand2_gated_clk_buf clk_buf cs gated_clk_buf vdd gnd pand2_0
Xbuf_wl_en gated_clk_bar wl_en vdd gnd pdriver_2
Xbuf_s_en_and rbl_bl_delay gated_clk_bar cs s_en vdd gnd pand3_0
Xdelay_chain rbl_bl rbl_bl_delay vdd gnd delay_chain
Xnand_p_en_bar gated_clk_buf rbl_bl_delay p_en_bar_unbuf vdd gnd pnand2_1
Xbuf_p_en_bar p_en_bar_unbuf p_en_bar vdd gnd pdriver_5
.ENDS control_logic_r

.SUBCKT sky130_sram_1rw1r_44x64_8 din0[0] din0[1] din0[2] din0[3] din0[4] din0[5] din0[6] din0[7] din0[8] din0[9] din0[10] din0[11] din0[12] din0[13] din0[14] din0[15] din0[16] din0[17] din0[18] din0[19] din0[20] din0[21] din0[22] din0[23] din0[24] din0[25] din0[26] din0[27] din0[28] din0[29] din0[30] din0[31] din0[32] din0[33] din0[34] din0[35] din0[36] din0[37] din0[38] din0[39] din0[40] din0[41] din0[42] din0[43] addr0[0] addr0[1] addr0[2] addr0[3] addr0[4] addr0[5] addr1[0] addr1[1] addr1[2] addr1[3] addr1[4] addr1[5] csb0 csb1 web0 clk0 clk1 wmask0[0] wmask0[1] wmask0[2] wmask0[3] wmask0[4] wmask0[5] dout0[0] dout0[1] dout0[2] dout0[3] dout0[4] dout0[5] dout0[6] dout0[7] dout0[8] dout0[9] dout0[10] dout0[11] dout0[12] dout0[13] dout0[14] dout0[15] dout0[16] dout0[17] dout0[18] dout0[19] dout0[20] dout0[21] dout0[22] dout0[23] dout0[24] dout0[25] dout0[26] dout0[27] dout0[28] dout0[29] dout0[30] dout0[31] dout0[32] dout0[33] dout0[34] dout0[35] dout0[36] dout0[37] dout0[38] dout0[39] dout0[40] dout0[41] dout0[42] dout0[43] dout1[0] dout1[1] dout1[2] dout1[3] dout1[4] dout1[5] dout1[6] dout1[7] dout1[8] dout1[9] dout1[10] dout1[11] dout1[12] dout1[13] dout1[14] dout1[15] dout1[16] dout1[17] dout1[18] dout1[19] dout1[20] dout1[21] dout1[22] dout1[23] dout1[24] dout1[25] dout1[26] dout1[27] dout1[28] dout1[29] dout1[30] dout1[31] dout1[32] dout1[33] dout1[34] dout1[35] dout1[36] dout1[37] dout1[38] dout1[39] dout1[40] dout1[41] dout1[42] dout1[43] vdd gnd
*.PININFO din0[0]:I din0[1]:I din0[2]:I din0[3]:I din0[4]:I din0[5]:I din0[6]:I din0[7]:I din0[8]:I din0[9]:I din0[10]:I din0[11]:I din0[12]:I din0[13]:I din0[14]:I din0[15]:I din0[16]:I din0[17]:I din0[18]:I din0[19]:I din0[20]:I din0[21]:I din0[22]:I din0[23]:I din0[24]:I din0[25]:I din0[26]:I din0[27]:I din0[28]:I din0[29]:I din0[30]:I din0[31]:I din0[32]:I din0[33]:I din0[34]:I din0[35]:I din0[36]:I din0[37]:I din0[38]:I din0[39]:I din0[40]:I din0[41]:I din0[42]:I din0[43]:I addr0[0]:I addr0[1]:I addr0[2]:I addr0[3]:I addr0[4]:I addr0[5]:I addr1[0]:I addr1[1]:I addr1[2]:I addr1[3]:I addr1[4]:I addr1[5]:I csb0:I csb1:I web0:I clk0:I clk1:I wmask0[0]:I wmask0[1]:I wmask0[2]:I wmask0[3]:I wmask0[4]:I wmask0[5]:I dout0[0]:O dout0[1]:O dout0[2]:O dout0[3]:O dout0[4]:O dout0[5]:O dout0[6]:O dout0[7]:O dout0[8]:O dout0[9]:O dout0[10]:O dout0[11]:O dout0[12]:O dout0[13]:O dout0[14]:O dout0[15]:O dout0[16]:O dout0[17]:O dout0[18]:O dout0[19]:O dout0[20]:O dout0[21]:O dout0[22]:O dout0[23]:O dout0[24]:O dout0[25]:O dout0[26]:O dout0[27]:O dout0[28]:O dout0[29]:O dout0[30]:O dout0[31]:O dout0[32]:O dout0[33]:O dout0[34]:O dout0[35]:O dout0[36]:O dout0[37]:O dout0[38]:O dout0[39]:O dout0[40]:O dout0[41]:O dout0[42]:O dout0[43]:O dout1[0]:O dout1[1]:O dout1[2]:O dout1[3]:O dout1[4]:O dout1[5]:O dout1[6]:O dout1[7]:O dout1[8]:O dout1[9]:O dout1[10]:O dout1[11]:O dout1[12]:O dout1[13]:O dout1[14]:O dout1[15]:O dout1[16]:O dout1[17]:O dout1[18]:O dout1[19]:O dout1[20]:O dout1[21]:O dout1[22]:O dout1[23]:O dout1[24]:O dout1[25]:O dout1[26]:O dout1[27]:O dout1[28]:O dout1[29]:O dout1[30]:O dout1[31]:O dout1[32]:O dout1[33]:O dout1[34]:O dout1[35]:O dout1[36]:O dout1[37]:O dout1[38]:O dout1[39]:O dout1[40]:O dout1[41]:O dout1[42]:O dout1[43]:O vdd:B gnd:B
* INPUT : din0[0] 
* INPUT : din0[1] 
* INPUT : din0[2] 
* INPUT : din0[3] 
* INPUT : din0[4] 
* INPUT : din0[5] 
* INPUT : din0[6] 
* INPUT : din0[7] 
* INPUT : din0[8] 
* INPUT : din0[9] 
* INPUT : din0[10] 
* INPUT : din0[11] 
* INPUT : din0[12] 
* INPUT : din0[13] 
* INPUT : din0[14] 
* INPUT : din0[15] 
* INPUT : din0[16] 
* INPUT : din0[17] 
* INPUT : din0[18] 
* INPUT : din0[19] 
* INPUT : din0[20] 
* INPUT : din0[21] 
* INPUT : din0[22] 
* INPUT : din0[23] 
* INPUT : din0[24] 
* INPUT : din0[25] 
* INPUT : din0[26] 
* INPUT : din0[27] 
* INPUT : din0[28] 
* INPUT : din0[29] 
* INPUT : din0[30] 
* INPUT : din0[31] 
* INPUT : din0[32] 
* INPUT : din0[33] 
* INPUT : din0[34] 
* INPUT : din0[35] 
* INPUT : din0[36] 
* INPUT : din0[37] 
* INPUT : din0[38] 
* INPUT : din0[39] 
* INPUT : din0[40] 
* INPUT : din0[41] 
* INPUT : din0[42] 
* INPUT : din0[43] 
* INPUT : addr0[0] 
* INPUT : addr0[1] 
* INPUT : addr0[2] 
* INPUT : addr0[3] 
* INPUT : addr0[4] 
* INPUT : addr0[5] 
* INPUT : addr1[0] 
* INPUT : addr1[1] 
* INPUT : addr1[2] 
* INPUT : addr1[3] 
* INPUT : addr1[4] 
* INPUT : addr1[5] 
* INPUT : csb0 
* INPUT : csb1 
* INPUT : web0 
* INPUT : clk0 
* INPUT : clk1 
* INPUT : wmask0[0] 
* INPUT : wmask0[1] 
* INPUT : wmask0[2] 
* INPUT : wmask0[3] 
* INPUT : wmask0[4] 
* INPUT : wmask0[5] 
* OUTPUT: dout0[0] 
* OUTPUT: dout0[1] 
* OUTPUT: dout0[2] 
* OUTPUT: dout0[3] 
* OUTPUT: dout0[4] 
* OUTPUT: dout0[5] 
* OUTPUT: dout0[6] 
* OUTPUT: dout0[7] 
* OUTPUT: dout0[8] 
* OUTPUT: dout0[9] 
* OUTPUT: dout0[10] 
* OUTPUT: dout0[11] 
* OUTPUT: dout0[12] 
* OUTPUT: dout0[13] 
* OUTPUT: dout0[14] 
* OUTPUT: dout0[15] 
* OUTPUT: dout0[16] 
* OUTPUT: dout0[17] 
* OUTPUT: dout0[18] 
* OUTPUT: dout0[19] 
* OUTPUT: dout0[20] 
* OUTPUT: dout0[21] 
* OUTPUT: dout0[22] 
* OUTPUT: dout0[23] 
* OUTPUT: dout0[24] 
* OUTPUT: dout0[25] 
* OUTPUT: dout0[26] 
* OUTPUT: dout0[27] 
* OUTPUT: dout0[28] 
* OUTPUT: dout0[29] 
* OUTPUT: dout0[30] 
* OUTPUT: dout0[31] 
* OUTPUT: dout0[32] 
* OUTPUT: dout0[33] 
* OUTPUT: dout0[34] 
* OUTPUT: dout0[35] 
* OUTPUT: dout0[36] 
* OUTPUT: dout0[37] 
* OUTPUT: dout0[38] 
* OUTPUT: dout0[39] 
* OUTPUT: dout0[40] 
* OUTPUT: dout0[41] 
* OUTPUT: dout0[42] 
* OUTPUT: dout0[43] 
* OUTPUT: dout1[0] 
* OUTPUT: dout1[1] 
* OUTPUT: dout1[2] 
* OUTPUT: dout1[3] 
* OUTPUT: dout1[4] 
* OUTPUT: dout1[5] 
* OUTPUT: dout1[6] 
* OUTPUT: dout1[7] 
* OUTPUT: dout1[8] 
* OUTPUT: dout1[9] 
* OUTPUT: dout1[10] 
* OUTPUT: dout1[11] 
* OUTPUT: dout1[12] 
* OUTPUT: dout1[13] 
* OUTPUT: dout1[14] 
* OUTPUT: dout1[15] 
* OUTPUT: dout1[16] 
* OUTPUT: dout1[17] 
* OUTPUT: dout1[18] 
* OUTPUT: dout1[19] 
* OUTPUT: dout1[20] 
* OUTPUT: dout1[21] 
* OUTPUT: dout1[22] 
* OUTPUT: dout1[23] 
* OUTPUT: dout1[24] 
* OUTPUT: dout1[25] 
* OUTPUT: dout1[26] 
* OUTPUT: dout1[27] 
* OUTPUT: dout1[28] 
* OUTPUT: dout1[29] 
* OUTPUT: dout1[30] 
* OUTPUT: dout1[31] 
* OUTPUT: dout1[32] 
* OUTPUT: dout1[33] 
* OUTPUT: dout1[34] 
* OUTPUT: dout1[35] 
* OUTPUT: dout1[36] 
* OUTPUT: dout1[37] 
* OUTPUT: dout1[38] 
* OUTPUT: dout1[39] 
* OUTPUT: dout1[40] 
* OUTPUT: dout1[41] 
* OUTPUT: dout1[42] 
* OUTPUT: dout1[43] 
* POWER : vdd 
* GROUND: gnd 
Xbank0 dout0[0] dout0[1] dout0[2] dout0[3] dout0[4] dout0[5] dout0[6] dout0[7] dout0[8] dout0[9] dout0[10] dout0[11] dout0[12] dout0[13] dout0[14] dout0[15] dout0[16] dout0[17] dout0[18] dout0[19] dout0[20] dout0[21] dout0[22] dout0[23] dout0[24] dout0[25] dout0[26] dout0[27] dout0[28] dout0[29] dout0[30] dout0[31] dout0[32] dout0[33] dout0[34] dout0[35] dout0[36] dout0[37] dout0[38] dout0[39] dout0[40] dout0[41] dout0[42] dout0[43] dout1[0] dout1[1] dout1[2] dout1[3] dout1[4] dout1[5] dout1[6] dout1[7] dout1[8] dout1[9] dout1[10] dout1[11] dout1[12] dout1[13] dout1[14] dout1[15] dout1[16] dout1[17] dout1[18] dout1[19] dout1[20] dout1[21] dout1[22] dout1[23] dout1[24] dout1[25] dout1[26] dout1[27] dout1[28] dout1[29] dout1[30] dout1[31] dout1[32] dout1[33] dout1[34] dout1[35] dout1[36] dout1[37] dout1[38] dout1[39] dout1[40] dout1[41] dout1[42] dout1[43] rbl_bl0 rbl_bl1 bank_din0[0] bank_din0[1] bank_din0[2] bank_din0[3] bank_din0[4] bank_din0[5] bank_din0[6] bank_din0[7] bank_din0[8] bank_din0[9] bank_din0[10] bank_din0[11] bank_din0[12] bank_din0[13] bank_din0[14] bank_din0[15] bank_din0[16] bank_din0[17] bank_din0[18] bank_din0[19] bank_din0[20] bank_din0[21] bank_din0[22] bank_din0[23] bank_din0[24] bank_din0[25] bank_din0[26] bank_din0[27] bank_din0[28] bank_din0[29] bank_din0[30] bank_din0[31] bank_din0[32] bank_din0[33] bank_din0[34] bank_din0[35] bank_din0[36] bank_din0[37] bank_din0[38] bank_din0[39] bank_din0[40] bank_din0[41] bank_din0[42] bank_din0[43] a0[0] a0[1] a0[2] a0[3] a0[4] a0[5] a1[0] a1[1] a1[2] a1[3] a1[4] a1[5] s_en0 s_en1 p_en_bar0 p_en_bar1 w_en0 bank_wmask0[0] bank_wmask0[1] bank_wmask0[2] bank_wmask0[3] bank_wmask0[4] bank_wmask0[5] wl_en0 wl_en1 vdd gnd bank
Xcontrol0 csb0 web0 clk0 rbl_bl0 s_en0 w_en0 p_en_bar0 wl_en0 clk_buf0 vdd gnd control_logic_rw
Xcontrol1 csb1 clk1 rbl_bl1 s_en1 p_en_bar1 wl_en1 clk_buf1 vdd gnd control_logic_r
Xrow_address0 addr0[0] addr0[1] addr0[2] addr0[3] addr0[4] addr0[5] a0[0] a0[1] a0[2] a0[3] a0[4] a0[5] clk_buf0 vdd gnd row_addr_dff
Xrow_address1 addr1[0] addr1[1] addr1[2] addr1[3] addr1[4] addr1[5] a1[0] a1[1] a1[2] a1[3] a1[4] a1[5] clk_buf1 vdd gnd row_addr_dff
Xwmask_dff0 wmask0[0] wmask0[1] wmask0[2] wmask0[3] wmask0[4] wmask0[5] bank_wmask0[0] bank_wmask0[1] bank_wmask0[2] bank_wmask0[3] bank_wmask0[4] bank_wmask0[5] clk_buf0 vdd gnd wmask_dff
Xdata_dff0 din0[0] din0[1] din0[2] din0[3] din0[4] din0[5] din0[6] din0[7] din0[8] din0[9] din0[10] din0[11] din0[12] din0[13] din0[14] din0[15] din0[16] din0[17] din0[18] din0[19] din0[20] din0[21] din0[22] din0[23] din0[24] din0[25] din0[26] din0[27] din0[28] din0[29] din0[30] din0[31] din0[32] din0[33] din0[34] din0[35] din0[36] din0[37] din0[38] din0[39] din0[40] din0[41] din0[42] din0[43] bank_din0[0] bank_din0[1] bank_din0[2] bank_din0[3] bank_din0[4] bank_din0[5] bank_din0[6] bank_din0[7] bank_din0[8] bank_din0[9] bank_din0[10] bank_din0[11] bank_din0[12] bank_din0[13] bank_din0[14] bank_din0[15] bank_din0[16] bank_din0[17] bank_din0[18] bank_din0[19] bank_din0[20] bank_din0[21] bank_din0[22] bank_din0[23] bank_din0[24] bank_din0[25] bank_din0[26] bank_din0[27] bank_din0[28] bank_din0[29] bank_din0[30] bank_din0[31] bank_din0[32] bank_din0[33] bank_din0[34] bank_din0[35] bank_din0[36] bank_din0[37] bank_din0[38] bank_din0[39] bank_din0[40] bank_din0[41] bank_din0[42] bank_din0[43] clk_buf0 vdd gnd data_dff
.ENDS sky130_sram_1rw1r_44x64_8
