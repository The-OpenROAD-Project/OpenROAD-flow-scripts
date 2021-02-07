**************************************************
* OpenRAM generated memory.
* Words: 256
* Data bits: 64
* Banks: 1
* Column mux: 2:1
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

.SUBCKT row_addr_dff din_0 din_1 din_2 din_3 din_4 din_5 din_6 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 clk vdd gnd
*.PININFO din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I din_6:I dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O clk:I vdd:B gnd:B
* INPUT : din_0 
* INPUT : din_1 
* INPUT : din_2 
* INPUT : din_3 
* INPUT : din_4 
* INPUT : din_5 
* INPUT : din_6 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* OUTPUT: dout_6 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 7 cols: 1
Xdff_r0_c0 din_0 dout_0 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r1_c0 din_1 dout_1 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r2_c0 din_2 dout_2 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r3_c0 din_3 dout_3 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r4_c0 din_4 dout_4 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r5_c0 din_5 dout_5 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r6_c0 din_6 dout_6 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
.ENDS row_addr_dff

.SUBCKT col_addr_dff din_0 dout_0 clk vdd gnd
*.PININFO din_0:I dout_0:O clk:I vdd:B gnd:B
* INPUT : din_0 
* OUTPUT: dout_0 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 1 cols: 1
Xdff_r0_c0 din_0 dout_0 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
.ENDS col_addr_dff

.SUBCKT data_dff din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 din_8 din_9 din_10 din_11 din_12 din_13 din_14 din_15 din_16 din_17 din_18 din_19 din_20 din_21 din_22 din_23 din_24 din_25 din_26 din_27 din_28 din_29 din_30 din_31 din_32 din_33 din_34 din_35 din_36 din_37 din_38 din_39 din_40 din_41 din_42 din_43 din_44 din_45 din_46 din_47 din_48 din_49 din_50 din_51 din_52 din_53 din_54 din_55 din_56 din_57 din_58 din_59 din_60 din_61 din_62 din_63 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 dout_8 dout_9 dout_10 dout_11 dout_12 dout_13 dout_14 dout_15 dout_16 dout_17 dout_18 dout_19 dout_20 dout_21 dout_22 dout_23 dout_24 dout_25 dout_26 dout_27 dout_28 dout_29 dout_30 dout_31 dout_32 dout_33 dout_34 dout_35 dout_36 dout_37 dout_38 dout_39 dout_40 dout_41 dout_42 dout_43 dout_44 dout_45 dout_46 dout_47 dout_48 dout_49 dout_50 dout_51 dout_52 dout_53 dout_54 dout_55 dout_56 dout_57 dout_58 dout_59 dout_60 dout_61 dout_62 dout_63 clk vdd gnd
*.PININFO din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I din_6:I din_7:I din_8:I din_9:I din_10:I din_11:I din_12:I din_13:I din_14:I din_15:I din_16:I din_17:I din_18:I din_19:I din_20:I din_21:I din_22:I din_23:I din_24:I din_25:I din_26:I din_27:I din_28:I din_29:I din_30:I din_31:I din_32:I din_33:I din_34:I din_35:I din_36:I din_37:I din_38:I din_39:I din_40:I din_41:I din_42:I din_43:I din_44:I din_45:I din_46:I din_47:I din_48:I din_49:I din_50:I din_51:I din_52:I din_53:I din_54:I din_55:I din_56:I din_57:I din_58:I din_59:I din_60:I din_61:I din_62:I din_63:I dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O dout_8:O dout_9:O dout_10:O dout_11:O dout_12:O dout_13:O dout_14:O dout_15:O dout_16:O dout_17:O dout_18:O dout_19:O dout_20:O dout_21:O dout_22:O dout_23:O dout_24:O dout_25:O dout_26:O dout_27:O dout_28:O dout_29:O dout_30:O dout_31:O dout_32:O dout_33:O dout_34:O dout_35:O dout_36:O dout_37:O dout_38:O dout_39:O dout_40:O dout_41:O dout_42:O dout_43:O dout_44:O dout_45:O dout_46:O dout_47:O dout_48:O dout_49:O dout_50:O dout_51:O dout_52:O dout_53:O dout_54:O dout_55:O dout_56:O dout_57:O dout_58:O dout_59:O dout_60:O dout_61:O dout_62:O dout_63:O clk:I vdd:B gnd:B
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
* INPUT : din_44 
* INPUT : din_45 
* INPUT : din_46 
* INPUT : din_47 
* INPUT : din_48 
* INPUT : din_49 
* INPUT : din_50 
* INPUT : din_51 
* INPUT : din_52 
* INPUT : din_53 
* INPUT : din_54 
* INPUT : din_55 
* INPUT : din_56 
* INPUT : din_57 
* INPUT : din_58 
* INPUT : din_59 
* INPUT : din_60 
* INPUT : din_61 
* INPUT : din_62 
* INPUT : din_63 
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
* OUTPUT: dout_44 
* OUTPUT: dout_45 
* OUTPUT: dout_46 
* OUTPUT: dout_47 
* OUTPUT: dout_48 
* OUTPUT: dout_49 
* OUTPUT: dout_50 
* OUTPUT: dout_51 
* OUTPUT: dout_52 
* OUTPUT: dout_53 
* OUTPUT: dout_54 
* OUTPUT: dout_55 
* OUTPUT: dout_56 
* OUTPUT: dout_57 
* OUTPUT: dout_58 
* OUTPUT: dout_59 
* OUTPUT: dout_60 
* OUTPUT: dout_61 
* OUTPUT: dout_62 
* OUTPUT: dout_63 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 1 cols: 64
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
Xdff_r0_c44 din_44 dout_44 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c45 din_45 dout_45 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c46 din_46 dout_46 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c47 din_47 dout_47 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c48 din_48 dout_48 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c49 din_49 dout_49 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c50 din_50 dout_50 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c51 din_51 dout_51 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c52 din_52 dout_52 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c53 din_53 dout_53 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c54 din_54 dout_54 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c55 din_55 dout_55 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c56 din_56 dout_56 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c57 din_57 dout_57 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c58 din_58 dout_58 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c59 din_59 dout_59 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c60 din_60 dout_60 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c61 din_61 dout_61 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c62 din_62 dout_62 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c63 din_63 dout_63 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
.ENDS data_dff

.SUBCKT wmask_dff din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 clk vdd gnd
*.PININFO din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I din_6:I din_7:I dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O clk:I vdd:B gnd:B
* INPUT : din_0 
* INPUT : din_1 
* INPUT : din_2 
* INPUT : din_3 
* INPUT : din_4 
* INPUT : din_5 
* INPUT : din_6 
* INPUT : din_7 
* OUTPUT: dout_0 
* OUTPUT: dout_1 
* OUTPUT: dout_2 
* OUTPUT: dout_3 
* OUTPUT: dout_4 
* OUTPUT: dout_5 
* OUTPUT: dout_6 
* OUTPUT: dout_7 
* INPUT : clk 
* POWER : vdd 
* GROUND: gnd 
* rows: 1 cols: 8
Xdff_r0_c0 din_0 dout_0 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c1 din_1 dout_1 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c2 din_2 dout_2 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c3 din_3 dout_3 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c4 din_4 dout_4 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c5 din_5 dout_5 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c6 din_6 dout_6 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
Xdff_r0_c7 din_7 dout_7 CLK VDD GND sky130_fd_bd_sram__openram_sram_dff
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

.SUBCKT hierarchical_decoder addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 addr_6 decode_0 decode_1 decode_2 decode_3 decode_4 decode_5 decode_6 decode_7 decode_8 decode_9 decode_10 decode_11 decode_12 decode_13 decode_14 decode_15 decode_16 decode_17 decode_18 decode_19 decode_20 decode_21 decode_22 decode_23 decode_24 decode_25 decode_26 decode_27 decode_28 decode_29 decode_30 decode_31 decode_32 decode_33 decode_34 decode_35 decode_36 decode_37 decode_38 decode_39 decode_40 decode_41 decode_42 decode_43 decode_44 decode_45 decode_46 decode_47 decode_48 decode_49 decode_50 decode_51 decode_52 decode_53 decode_54 decode_55 decode_56 decode_57 decode_58 decode_59 decode_60 decode_61 decode_62 decode_63 decode_64 decode_65 decode_66 decode_67 decode_68 decode_69 decode_70 decode_71 decode_72 decode_73 decode_74 decode_75 decode_76 decode_77 decode_78 decode_79 decode_80 decode_81 decode_82 decode_83 decode_84 decode_85 decode_86 decode_87 decode_88 decode_89 decode_90 decode_91 decode_92 decode_93 decode_94 decode_95 decode_96 decode_97 decode_98 decode_99 decode_100 decode_101 decode_102 decode_103 decode_104 decode_105 decode_106 decode_107 decode_108 decode_109 decode_110 decode_111 decode_112 decode_113 decode_114 decode_115 decode_116 decode_117 decode_118 decode_119 decode_120 decode_121 decode_122 decode_123 decode_124 decode_125 decode_126 decode_127 vdd gnd
*.PININFO addr_0:I addr_1:I addr_2:I addr_3:I addr_4:I addr_5:I addr_6:I decode_0:O decode_1:O decode_2:O decode_3:O decode_4:O decode_5:O decode_6:O decode_7:O decode_8:O decode_9:O decode_10:O decode_11:O decode_12:O decode_13:O decode_14:O decode_15:O decode_16:O decode_17:O decode_18:O decode_19:O decode_20:O decode_21:O decode_22:O decode_23:O decode_24:O decode_25:O decode_26:O decode_27:O decode_28:O decode_29:O decode_30:O decode_31:O decode_32:O decode_33:O decode_34:O decode_35:O decode_36:O decode_37:O decode_38:O decode_39:O decode_40:O decode_41:O decode_42:O decode_43:O decode_44:O decode_45:O decode_46:O decode_47:O decode_48:O decode_49:O decode_50:O decode_51:O decode_52:O decode_53:O decode_54:O decode_55:O decode_56:O decode_57:O decode_58:O decode_59:O decode_60:O decode_61:O decode_62:O decode_63:O decode_64:O decode_65:O decode_66:O decode_67:O decode_68:O decode_69:O decode_70:O decode_71:O decode_72:O decode_73:O decode_74:O decode_75:O decode_76:O decode_77:O decode_78:O decode_79:O decode_80:O decode_81:O decode_82:O decode_83:O decode_84:O decode_85:O decode_86:O decode_87:O decode_88:O decode_89:O decode_90:O decode_91:O decode_92:O decode_93:O decode_94:O decode_95:O decode_96:O decode_97:O decode_98:O decode_99:O decode_100:O decode_101:O decode_102:O decode_103:O decode_104:O decode_105:O decode_106:O decode_107:O decode_108:O decode_109:O decode_110:O decode_111:O decode_112:O decode_113:O decode_114:O decode_115:O decode_116:O decode_117:O decode_118:O decode_119:O decode_120:O decode_121:O decode_122:O decode_123:O decode_124:O decode_125:O decode_126:O decode_127:O vdd:B gnd:B
* INPUT : addr_0 
* INPUT : addr_1 
* INPUT : addr_2 
* INPUT : addr_3 
* INPUT : addr_4 
* INPUT : addr_5 
* INPUT : addr_6 
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
* OUTPUT: decode_64 
* OUTPUT: decode_65 
* OUTPUT: decode_66 
* OUTPUT: decode_67 
* OUTPUT: decode_68 
* OUTPUT: decode_69 
* OUTPUT: decode_70 
* OUTPUT: decode_71 
* OUTPUT: decode_72 
* OUTPUT: decode_73 
* OUTPUT: decode_74 
* OUTPUT: decode_75 
* OUTPUT: decode_76 
* OUTPUT: decode_77 
* OUTPUT: decode_78 
* OUTPUT: decode_79 
* OUTPUT: decode_80 
* OUTPUT: decode_81 
* OUTPUT: decode_82 
* OUTPUT: decode_83 
* OUTPUT: decode_84 
* OUTPUT: decode_85 
* OUTPUT: decode_86 
* OUTPUT: decode_87 
* OUTPUT: decode_88 
* OUTPUT: decode_89 
* OUTPUT: decode_90 
* OUTPUT: decode_91 
* OUTPUT: decode_92 
* OUTPUT: decode_93 
* OUTPUT: decode_94 
* OUTPUT: decode_95 
* OUTPUT: decode_96 
* OUTPUT: decode_97 
* OUTPUT: decode_98 
* OUTPUT: decode_99 
* OUTPUT: decode_100 
* OUTPUT: decode_101 
* OUTPUT: decode_102 
* OUTPUT: decode_103 
* OUTPUT: decode_104 
* OUTPUT: decode_105 
* OUTPUT: decode_106 
* OUTPUT: decode_107 
* OUTPUT: decode_108 
* OUTPUT: decode_109 
* OUTPUT: decode_110 
* OUTPUT: decode_111 
* OUTPUT: decode_112 
* OUTPUT: decode_113 
* OUTPUT: decode_114 
* OUTPUT: decode_115 
* OUTPUT: decode_116 
* OUTPUT: decode_117 
* OUTPUT: decode_118 
* OUTPUT: decode_119 
* OUTPUT: decode_120 
* OUTPUT: decode_121 
* OUTPUT: decode_122 
* OUTPUT: decode_123 
* OUTPUT: decode_124 
* OUTPUT: decode_125 
* OUTPUT: decode_126 
* OUTPUT: decode_127 
* POWER : vdd 
* GROUND: gnd 
Xpre_0 addr_0 addr_1 out_0 out_1 out_2 out_3 vdd gnd hierarchical_predecode2x4
Xpre_1 addr_2 addr_3 out_4 out_5 out_6 out_7 vdd gnd hierarchical_predecode2x4
Xpre3x8_0 addr_4 addr_5 addr_6 out_8 out_9 out_10 out_11 out_12 out_13 out_14 out_15 vdd gnd hierarchical_predecode3x8
XDEC_AND_0 out_0 out_4 out_8 decode_0 vdd gnd and3_dec
XDEC_AND_16 out_0 out_4 out_9 decode_16 vdd gnd and3_dec
XDEC_AND_32 out_0 out_4 out_10 decode_32 vdd gnd and3_dec
XDEC_AND_48 out_0 out_4 out_11 decode_48 vdd gnd and3_dec
XDEC_AND_64 out_0 out_4 out_12 decode_64 vdd gnd and3_dec
XDEC_AND_80 out_0 out_4 out_13 decode_80 vdd gnd and3_dec
XDEC_AND_96 out_0 out_4 out_14 decode_96 vdd gnd and3_dec
XDEC_AND_112 out_0 out_4 out_15 decode_112 vdd gnd and3_dec
XDEC_AND_4 out_0 out_5 out_8 decode_4 vdd gnd and3_dec
XDEC_AND_20 out_0 out_5 out_9 decode_20 vdd gnd and3_dec
XDEC_AND_36 out_0 out_5 out_10 decode_36 vdd gnd and3_dec
XDEC_AND_52 out_0 out_5 out_11 decode_52 vdd gnd and3_dec
XDEC_AND_68 out_0 out_5 out_12 decode_68 vdd gnd and3_dec
XDEC_AND_84 out_0 out_5 out_13 decode_84 vdd gnd and3_dec
XDEC_AND_100 out_0 out_5 out_14 decode_100 vdd gnd and3_dec
XDEC_AND_116 out_0 out_5 out_15 decode_116 vdd gnd and3_dec
XDEC_AND_8 out_0 out_6 out_8 decode_8 vdd gnd and3_dec
XDEC_AND_24 out_0 out_6 out_9 decode_24 vdd gnd and3_dec
XDEC_AND_40 out_0 out_6 out_10 decode_40 vdd gnd and3_dec
XDEC_AND_56 out_0 out_6 out_11 decode_56 vdd gnd and3_dec
XDEC_AND_72 out_0 out_6 out_12 decode_72 vdd gnd and3_dec
XDEC_AND_88 out_0 out_6 out_13 decode_88 vdd gnd and3_dec
XDEC_AND_104 out_0 out_6 out_14 decode_104 vdd gnd and3_dec
XDEC_AND_120 out_0 out_6 out_15 decode_120 vdd gnd and3_dec
XDEC_AND_12 out_0 out_7 out_8 decode_12 vdd gnd and3_dec
XDEC_AND_28 out_0 out_7 out_9 decode_28 vdd gnd and3_dec
XDEC_AND_44 out_0 out_7 out_10 decode_44 vdd gnd and3_dec
XDEC_AND_60 out_0 out_7 out_11 decode_60 vdd gnd and3_dec
XDEC_AND_76 out_0 out_7 out_12 decode_76 vdd gnd and3_dec
XDEC_AND_92 out_0 out_7 out_13 decode_92 vdd gnd and3_dec
XDEC_AND_108 out_0 out_7 out_14 decode_108 vdd gnd and3_dec
XDEC_AND_124 out_0 out_7 out_15 decode_124 vdd gnd and3_dec
XDEC_AND_1 out_1 out_4 out_8 decode_1 vdd gnd and3_dec
XDEC_AND_17 out_1 out_4 out_9 decode_17 vdd gnd and3_dec
XDEC_AND_33 out_1 out_4 out_10 decode_33 vdd gnd and3_dec
XDEC_AND_49 out_1 out_4 out_11 decode_49 vdd gnd and3_dec
XDEC_AND_65 out_1 out_4 out_12 decode_65 vdd gnd and3_dec
XDEC_AND_81 out_1 out_4 out_13 decode_81 vdd gnd and3_dec
XDEC_AND_97 out_1 out_4 out_14 decode_97 vdd gnd and3_dec
XDEC_AND_113 out_1 out_4 out_15 decode_113 vdd gnd and3_dec
XDEC_AND_5 out_1 out_5 out_8 decode_5 vdd gnd and3_dec
XDEC_AND_21 out_1 out_5 out_9 decode_21 vdd gnd and3_dec
XDEC_AND_37 out_1 out_5 out_10 decode_37 vdd gnd and3_dec
XDEC_AND_53 out_1 out_5 out_11 decode_53 vdd gnd and3_dec
XDEC_AND_69 out_1 out_5 out_12 decode_69 vdd gnd and3_dec
XDEC_AND_85 out_1 out_5 out_13 decode_85 vdd gnd and3_dec
XDEC_AND_101 out_1 out_5 out_14 decode_101 vdd gnd and3_dec
XDEC_AND_117 out_1 out_5 out_15 decode_117 vdd gnd and3_dec
XDEC_AND_9 out_1 out_6 out_8 decode_9 vdd gnd and3_dec
XDEC_AND_25 out_1 out_6 out_9 decode_25 vdd gnd and3_dec
XDEC_AND_41 out_1 out_6 out_10 decode_41 vdd gnd and3_dec
XDEC_AND_57 out_1 out_6 out_11 decode_57 vdd gnd and3_dec
XDEC_AND_73 out_1 out_6 out_12 decode_73 vdd gnd and3_dec
XDEC_AND_89 out_1 out_6 out_13 decode_89 vdd gnd and3_dec
XDEC_AND_105 out_1 out_6 out_14 decode_105 vdd gnd and3_dec
XDEC_AND_121 out_1 out_6 out_15 decode_121 vdd gnd and3_dec
XDEC_AND_13 out_1 out_7 out_8 decode_13 vdd gnd and3_dec
XDEC_AND_29 out_1 out_7 out_9 decode_29 vdd gnd and3_dec
XDEC_AND_45 out_1 out_7 out_10 decode_45 vdd gnd and3_dec
XDEC_AND_61 out_1 out_7 out_11 decode_61 vdd gnd and3_dec
XDEC_AND_77 out_1 out_7 out_12 decode_77 vdd gnd and3_dec
XDEC_AND_93 out_1 out_7 out_13 decode_93 vdd gnd and3_dec
XDEC_AND_109 out_1 out_7 out_14 decode_109 vdd gnd and3_dec
XDEC_AND_125 out_1 out_7 out_15 decode_125 vdd gnd and3_dec
XDEC_AND_2 out_2 out_4 out_8 decode_2 vdd gnd and3_dec
XDEC_AND_18 out_2 out_4 out_9 decode_18 vdd gnd and3_dec
XDEC_AND_34 out_2 out_4 out_10 decode_34 vdd gnd and3_dec
XDEC_AND_50 out_2 out_4 out_11 decode_50 vdd gnd and3_dec
XDEC_AND_66 out_2 out_4 out_12 decode_66 vdd gnd and3_dec
XDEC_AND_82 out_2 out_4 out_13 decode_82 vdd gnd and3_dec
XDEC_AND_98 out_2 out_4 out_14 decode_98 vdd gnd and3_dec
XDEC_AND_114 out_2 out_4 out_15 decode_114 vdd gnd and3_dec
XDEC_AND_6 out_2 out_5 out_8 decode_6 vdd gnd and3_dec
XDEC_AND_22 out_2 out_5 out_9 decode_22 vdd gnd and3_dec
XDEC_AND_38 out_2 out_5 out_10 decode_38 vdd gnd and3_dec
XDEC_AND_54 out_2 out_5 out_11 decode_54 vdd gnd and3_dec
XDEC_AND_70 out_2 out_5 out_12 decode_70 vdd gnd and3_dec
XDEC_AND_86 out_2 out_5 out_13 decode_86 vdd gnd and3_dec
XDEC_AND_102 out_2 out_5 out_14 decode_102 vdd gnd and3_dec
XDEC_AND_118 out_2 out_5 out_15 decode_118 vdd gnd and3_dec
XDEC_AND_10 out_2 out_6 out_8 decode_10 vdd gnd and3_dec
XDEC_AND_26 out_2 out_6 out_9 decode_26 vdd gnd and3_dec
XDEC_AND_42 out_2 out_6 out_10 decode_42 vdd gnd and3_dec
XDEC_AND_58 out_2 out_6 out_11 decode_58 vdd gnd and3_dec
XDEC_AND_74 out_2 out_6 out_12 decode_74 vdd gnd and3_dec
XDEC_AND_90 out_2 out_6 out_13 decode_90 vdd gnd and3_dec
XDEC_AND_106 out_2 out_6 out_14 decode_106 vdd gnd and3_dec
XDEC_AND_122 out_2 out_6 out_15 decode_122 vdd gnd and3_dec
XDEC_AND_14 out_2 out_7 out_8 decode_14 vdd gnd and3_dec
XDEC_AND_30 out_2 out_7 out_9 decode_30 vdd gnd and3_dec
XDEC_AND_46 out_2 out_7 out_10 decode_46 vdd gnd and3_dec
XDEC_AND_62 out_2 out_7 out_11 decode_62 vdd gnd and3_dec
XDEC_AND_78 out_2 out_7 out_12 decode_78 vdd gnd and3_dec
XDEC_AND_94 out_2 out_7 out_13 decode_94 vdd gnd and3_dec
XDEC_AND_110 out_2 out_7 out_14 decode_110 vdd gnd and3_dec
XDEC_AND_126 out_2 out_7 out_15 decode_126 vdd gnd and3_dec
XDEC_AND_3 out_3 out_4 out_8 decode_3 vdd gnd and3_dec
XDEC_AND_19 out_3 out_4 out_9 decode_19 vdd gnd and3_dec
XDEC_AND_35 out_3 out_4 out_10 decode_35 vdd gnd and3_dec
XDEC_AND_51 out_3 out_4 out_11 decode_51 vdd gnd and3_dec
XDEC_AND_67 out_3 out_4 out_12 decode_67 vdd gnd and3_dec
XDEC_AND_83 out_3 out_4 out_13 decode_83 vdd gnd and3_dec
XDEC_AND_99 out_3 out_4 out_14 decode_99 vdd gnd and3_dec
XDEC_AND_115 out_3 out_4 out_15 decode_115 vdd gnd and3_dec
XDEC_AND_7 out_3 out_5 out_8 decode_7 vdd gnd and3_dec
XDEC_AND_23 out_3 out_5 out_9 decode_23 vdd gnd and3_dec
XDEC_AND_39 out_3 out_5 out_10 decode_39 vdd gnd and3_dec
XDEC_AND_55 out_3 out_5 out_11 decode_55 vdd gnd and3_dec
XDEC_AND_71 out_3 out_5 out_12 decode_71 vdd gnd and3_dec
XDEC_AND_87 out_3 out_5 out_13 decode_87 vdd gnd and3_dec
XDEC_AND_103 out_3 out_5 out_14 decode_103 vdd gnd and3_dec
XDEC_AND_119 out_3 out_5 out_15 decode_119 vdd gnd and3_dec
XDEC_AND_11 out_3 out_6 out_8 decode_11 vdd gnd and3_dec
XDEC_AND_27 out_3 out_6 out_9 decode_27 vdd gnd and3_dec
XDEC_AND_43 out_3 out_6 out_10 decode_43 vdd gnd and3_dec
XDEC_AND_59 out_3 out_6 out_11 decode_59 vdd gnd and3_dec
XDEC_AND_75 out_3 out_6 out_12 decode_75 vdd gnd and3_dec
XDEC_AND_91 out_3 out_6 out_13 decode_91 vdd gnd and3_dec
XDEC_AND_107 out_3 out_6 out_14 decode_107 vdd gnd and3_dec
XDEC_AND_123 out_3 out_6 out_15 decode_123 vdd gnd and3_dec
XDEC_AND_15 out_3 out_7 out_8 decode_15 vdd gnd and3_dec
XDEC_AND_31 out_3 out_7 out_9 decode_31 vdd gnd and3_dec
XDEC_AND_47 out_3 out_7 out_10 decode_47 vdd gnd and3_dec
XDEC_AND_63 out_3 out_7 out_11 decode_63 vdd gnd and3_dec
XDEC_AND_79 out_3 out_7 out_12 decode_79 vdd gnd and3_dec
XDEC_AND_95 out_3 out_7 out_13 decode_95 vdd gnd and3_dec
XDEC_AND_111 out_3 out_7 out_14 decode_111 vdd gnd and3_dec
XDEC_AND_127 out_3 out_7 out_15 decode_127 vdd gnd and3_dec
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

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=3.0 l=0.15 pd=6.30 ps=6.30 as=1.12u ad=1.12u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=1 w=7.0 l=0.15 pd=14.30 ps=14.30 as=2.62u ad=2.62u

.SUBCKT pinv_dec_1 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=7.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=3.0u l=0.15u
.ENDS pinv_dec_1

.SUBCKT pbuf_dec A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xbuf_inv1 A zb_int vdd gnd pinv_dec_0
Xbuf_inv2 zb_int Z vdd gnd pinv_dec_1
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

.SUBCKT wordline_driver_array in_0 in_1 in_2 in_3 in_4 in_5 in_6 in_7 in_8 in_9 in_10 in_11 in_12 in_13 in_14 in_15 in_16 in_17 in_18 in_19 in_20 in_21 in_22 in_23 in_24 in_25 in_26 in_27 in_28 in_29 in_30 in_31 in_32 in_33 in_34 in_35 in_36 in_37 in_38 in_39 in_40 in_41 in_42 in_43 in_44 in_45 in_46 in_47 in_48 in_49 in_50 in_51 in_52 in_53 in_54 in_55 in_56 in_57 in_58 in_59 in_60 in_61 in_62 in_63 in_64 in_65 in_66 in_67 in_68 in_69 in_70 in_71 in_72 in_73 in_74 in_75 in_76 in_77 in_78 in_79 in_80 in_81 in_82 in_83 in_84 in_85 in_86 in_87 in_88 in_89 in_90 in_91 in_92 in_93 in_94 in_95 in_96 in_97 in_98 in_99 in_100 in_101 in_102 in_103 in_104 in_105 in_106 in_107 in_108 in_109 in_110 in_111 in_112 in_113 in_114 in_115 in_116 in_117 in_118 in_119 in_120 in_121 in_122 in_123 in_124 in_125 in_126 in_127 wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_64 wl_65 wl_66 wl_67 wl_68 wl_69 wl_70 wl_71 wl_72 wl_73 wl_74 wl_75 wl_76 wl_77 wl_78 wl_79 wl_80 wl_81 wl_82 wl_83 wl_84 wl_85 wl_86 wl_87 wl_88 wl_89 wl_90 wl_91 wl_92 wl_93 wl_94 wl_95 wl_96 wl_97 wl_98 wl_99 wl_100 wl_101 wl_102 wl_103 wl_104 wl_105 wl_106 wl_107 wl_108 wl_109 wl_110 wl_111 wl_112 wl_113 wl_114 wl_115 wl_116 wl_117 wl_118 wl_119 wl_120 wl_121 wl_122 wl_123 wl_124 wl_125 wl_126 wl_127 en vdd gnd
*.PININFO in_0:I in_1:I in_2:I in_3:I in_4:I in_5:I in_6:I in_7:I in_8:I in_9:I in_10:I in_11:I in_12:I in_13:I in_14:I in_15:I in_16:I in_17:I in_18:I in_19:I in_20:I in_21:I in_22:I in_23:I in_24:I in_25:I in_26:I in_27:I in_28:I in_29:I in_30:I in_31:I in_32:I in_33:I in_34:I in_35:I in_36:I in_37:I in_38:I in_39:I in_40:I in_41:I in_42:I in_43:I in_44:I in_45:I in_46:I in_47:I in_48:I in_49:I in_50:I in_51:I in_52:I in_53:I in_54:I in_55:I in_56:I in_57:I in_58:I in_59:I in_60:I in_61:I in_62:I in_63:I in_64:I in_65:I in_66:I in_67:I in_68:I in_69:I in_70:I in_71:I in_72:I in_73:I in_74:I in_75:I in_76:I in_77:I in_78:I in_79:I in_80:I in_81:I in_82:I in_83:I in_84:I in_85:I in_86:I in_87:I in_88:I in_89:I in_90:I in_91:I in_92:I in_93:I in_94:I in_95:I in_96:I in_97:I in_98:I in_99:I in_100:I in_101:I in_102:I in_103:I in_104:I in_105:I in_106:I in_107:I in_108:I in_109:I in_110:I in_111:I in_112:I in_113:I in_114:I in_115:I in_116:I in_117:I in_118:I in_119:I in_120:I in_121:I in_122:I in_123:I in_124:I in_125:I in_126:I in_127:I wl_0:O wl_1:O wl_2:O wl_3:O wl_4:O wl_5:O wl_6:O wl_7:O wl_8:O wl_9:O wl_10:O wl_11:O wl_12:O wl_13:O wl_14:O wl_15:O wl_16:O wl_17:O wl_18:O wl_19:O wl_20:O wl_21:O wl_22:O wl_23:O wl_24:O wl_25:O wl_26:O wl_27:O wl_28:O wl_29:O wl_30:O wl_31:O wl_32:O wl_33:O wl_34:O wl_35:O wl_36:O wl_37:O wl_38:O wl_39:O wl_40:O wl_41:O wl_42:O wl_43:O wl_44:O wl_45:O wl_46:O wl_47:O wl_48:O wl_49:O wl_50:O wl_51:O wl_52:O wl_53:O wl_54:O wl_55:O wl_56:O wl_57:O wl_58:O wl_59:O wl_60:O wl_61:O wl_62:O wl_63:O wl_64:O wl_65:O wl_66:O wl_67:O wl_68:O wl_69:O wl_70:O wl_71:O wl_72:O wl_73:O wl_74:O wl_75:O wl_76:O wl_77:O wl_78:O wl_79:O wl_80:O wl_81:O wl_82:O wl_83:O wl_84:O wl_85:O wl_86:O wl_87:O wl_88:O wl_89:O wl_90:O wl_91:O wl_92:O wl_93:O wl_94:O wl_95:O wl_96:O wl_97:O wl_98:O wl_99:O wl_100:O wl_101:O wl_102:O wl_103:O wl_104:O wl_105:O wl_106:O wl_107:O wl_108:O wl_109:O wl_110:O wl_111:O wl_112:O wl_113:O wl_114:O wl_115:O wl_116:O wl_117:O wl_118:O wl_119:O wl_120:O wl_121:O wl_122:O wl_123:O wl_124:O wl_125:O wl_126:O wl_127:O en:I vdd:B gnd:B
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
* INPUT : in_65 
* INPUT : in_66 
* INPUT : in_67 
* INPUT : in_68 
* INPUT : in_69 
* INPUT : in_70 
* INPUT : in_71 
* INPUT : in_72 
* INPUT : in_73 
* INPUT : in_74 
* INPUT : in_75 
* INPUT : in_76 
* INPUT : in_77 
* INPUT : in_78 
* INPUT : in_79 
* INPUT : in_80 
* INPUT : in_81 
* INPUT : in_82 
* INPUT : in_83 
* INPUT : in_84 
* INPUT : in_85 
* INPUT : in_86 
* INPUT : in_87 
* INPUT : in_88 
* INPUT : in_89 
* INPUT : in_90 
* INPUT : in_91 
* INPUT : in_92 
* INPUT : in_93 
* INPUT : in_94 
* INPUT : in_95 
* INPUT : in_96 
* INPUT : in_97 
* INPUT : in_98 
* INPUT : in_99 
* INPUT : in_100 
* INPUT : in_101 
* INPUT : in_102 
* INPUT : in_103 
* INPUT : in_104 
* INPUT : in_105 
* INPUT : in_106 
* INPUT : in_107 
* INPUT : in_108 
* INPUT : in_109 
* INPUT : in_110 
* INPUT : in_111 
* INPUT : in_112 
* INPUT : in_113 
* INPUT : in_114 
* INPUT : in_115 
* INPUT : in_116 
* INPUT : in_117 
* INPUT : in_118 
* INPUT : in_119 
* INPUT : in_120 
* INPUT : in_121 
* INPUT : in_122 
* INPUT : in_123 
* INPUT : in_124 
* INPUT : in_125 
* INPUT : in_126 
* INPUT : in_127 
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
* OUTPUT: wl_64 
* OUTPUT: wl_65 
* OUTPUT: wl_66 
* OUTPUT: wl_67 
* OUTPUT: wl_68 
* OUTPUT: wl_69 
* OUTPUT: wl_70 
* OUTPUT: wl_71 
* OUTPUT: wl_72 
* OUTPUT: wl_73 
* OUTPUT: wl_74 
* OUTPUT: wl_75 
* OUTPUT: wl_76 
* OUTPUT: wl_77 
* OUTPUT: wl_78 
* OUTPUT: wl_79 
* OUTPUT: wl_80 
* OUTPUT: wl_81 
* OUTPUT: wl_82 
* OUTPUT: wl_83 
* OUTPUT: wl_84 
* OUTPUT: wl_85 
* OUTPUT: wl_86 
* OUTPUT: wl_87 
* OUTPUT: wl_88 
* OUTPUT: wl_89 
* OUTPUT: wl_90 
* OUTPUT: wl_91 
* OUTPUT: wl_92 
* OUTPUT: wl_93 
* OUTPUT: wl_94 
* OUTPUT: wl_95 
* OUTPUT: wl_96 
* OUTPUT: wl_97 
* OUTPUT: wl_98 
* OUTPUT: wl_99 
* OUTPUT: wl_100 
* OUTPUT: wl_101 
* OUTPUT: wl_102 
* OUTPUT: wl_103 
* OUTPUT: wl_104 
* OUTPUT: wl_105 
* OUTPUT: wl_106 
* OUTPUT: wl_107 
* OUTPUT: wl_108 
* OUTPUT: wl_109 
* OUTPUT: wl_110 
* OUTPUT: wl_111 
* OUTPUT: wl_112 
* OUTPUT: wl_113 
* OUTPUT: wl_114 
* OUTPUT: wl_115 
* OUTPUT: wl_116 
* OUTPUT: wl_117 
* OUTPUT: wl_118 
* OUTPUT: wl_119 
* OUTPUT: wl_120 
* OUTPUT: wl_121 
* OUTPUT: wl_122 
* OUTPUT: wl_123 
* OUTPUT: wl_124 
* OUTPUT: wl_125 
* OUTPUT: wl_126 
* OUTPUT: wl_127 
* INPUT : en 
* POWER : vdd 
* GROUND: gnd 
* rows: 128 cols: 128
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
Xwl_driver_and64 in_64 en wl_64 vdd gnd wordline_driver
Xwl_driver_and65 in_65 en wl_65 vdd gnd wordline_driver
Xwl_driver_and66 in_66 en wl_66 vdd gnd wordline_driver
Xwl_driver_and67 in_67 en wl_67 vdd gnd wordline_driver
Xwl_driver_and68 in_68 en wl_68 vdd gnd wordline_driver
Xwl_driver_and69 in_69 en wl_69 vdd gnd wordline_driver
Xwl_driver_and70 in_70 en wl_70 vdd gnd wordline_driver
Xwl_driver_and71 in_71 en wl_71 vdd gnd wordline_driver
Xwl_driver_and72 in_72 en wl_72 vdd gnd wordline_driver
Xwl_driver_and73 in_73 en wl_73 vdd gnd wordline_driver
Xwl_driver_and74 in_74 en wl_74 vdd gnd wordline_driver
Xwl_driver_and75 in_75 en wl_75 vdd gnd wordline_driver
Xwl_driver_and76 in_76 en wl_76 vdd gnd wordline_driver
Xwl_driver_and77 in_77 en wl_77 vdd gnd wordline_driver
Xwl_driver_and78 in_78 en wl_78 vdd gnd wordline_driver
Xwl_driver_and79 in_79 en wl_79 vdd gnd wordline_driver
Xwl_driver_and80 in_80 en wl_80 vdd gnd wordline_driver
Xwl_driver_and81 in_81 en wl_81 vdd gnd wordline_driver
Xwl_driver_and82 in_82 en wl_82 vdd gnd wordline_driver
Xwl_driver_and83 in_83 en wl_83 vdd gnd wordline_driver
Xwl_driver_and84 in_84 en wl_84 vdd gnd wordline_driver
Xwl_driver_and85 in_85 en wl_85 vdd gnd wordline_driver
Xwl_driver_and86 in_86 en wl_86 vdd gnd wordline_driver
Xwl_driver_and87 in_87 en wl_87 vdd gnd wordline_driver
Xwl_driver_and88 in_88 en wl_88 vdd gnd wordline_driver
Xwl_driver_and89 in_89 en wl_89 vdd gnd wordline_driver
Xwl_driver_and90 in_90 en wl_90 vdd gnd wordline_driver
Xwl_driver_and91 in_91 en wl_91 vdd gnd wordline_driver
Xwl_driver_and92 in_92 en wl_92 vdd gnd wordline_driver
Xwl_driver_and93 in_93 en wl_93 vdd gnd wordline_driver
Xwl_driver_and94 in_94 en wl_94 vdd gnd wordline_driver
Xwl_driver_and95 in_95 en wl_95 vdd gnd wordline_driver
Xwl_driver_and96 in_96 en wl_96 vdd gnd wordline_driver
Xwl_driver_and97 in_97 en wl_97 vdd gnd wordline_driver
Xwl_driver_and98 in_98 en wl_98 vdd gnd wordline_driver
Xwl_driver_and99 in_99 en wl_99 vdd gnd wordline_driver
Xwl_driver_and100 in_100 en wl_100 vdd gnd wordline_driver
Xwl_driver_and101 in_101 en wl_101 vdd gnd wordline_driver
Xwl_driver_and102 in_102 en wl_102 vdd gnd wordline_driver
Xwl_driver_and103 in_103 en wl_103 vdd gnd wordline_driver
Xwl_driver_and104 in_104 en wl_104 vdd gnd wordline_driver
Xwl_driver_and105 in_105 en wl_105 vdd gnd wordline_driver
Xwl_driver_and106 in_106 en wl_106 vdd gnd wordline_driver
Xwl_driver_and107 in_107 en wl_107 vdd gnd wordline_driver
Xwl_driver_and108 in_108 en wl_108 vdd gnd wordline_driver
Xwl_driver_and109 in_109 en wl_109 vdd gnd wordline_driver
Xwl_driver_and110 in_110 en wl_110 vdd gnd wordline_driver
Xwl_driver_and111 in_111 en wl_111 vdd gnd wordline_driver
Xwl_driver_and112 in_112 en wl_112 vdd gnd wordline_driver
Xwl_driver_and113 in_113 en wl_113 vdd gnd wordline_driver
Xwl_driver_and114 in_114 en wl_114 vdd gnd wordline_driver
Xwl_driver_and115 in_115 en wl_115 vdd gnd wordline_driver
Xwl_driver_and116 in_116 en wl_116 vdd gnd wordline_driver
Xwl_driver_and117 in_117 en wl_117 vdd gnd wordline_driver
Xwl_driver_and118 in_118 en wl_118 vdd gnd wordline_driver
Xwl_driver_and119 in_119 en wl_119 vdd gnd wordline_driver
Xwl_driver_and120 in_120 en wl_120 vdd gnd wordline_driver
Xwl_driver_and121 in_121 en wl_121 vdd gnd wordline_driver
Xwl_driver_and122 in_122 en wl_122 vdd gnd wordline_driver
Xwl_driver_and123 in_123 en wl_123 vdd gnd wordline_driver
Xwl_driver_and124 in_124 en wl_124 vdd gnd wordline_driver
Xwl_driver_and125 in_125 en wl_125 vdd gnd wordline_driver
Xwl_driver_and126 in_126 en wl_126 vdd gnd wordline_driver
Xwl_driver_and127 in_127 en wl_127 vdd gnd wordline_driver
.ENDS wordline_driver_array

.SUBCKT port_address addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 addr_6 wl_en wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_64 wl_65 wl_66 wl_67 wl_68 wl_69 wl_70 wl_71 wl_72 wl_73 wl_74 wl_75 wl_76 wl_77 wl_78 wl_79 wl_80 wl_81 wl_82 wl_83 wl_84 wl_85 wl_86 wl_87 wl_88 wl_89 wl_90 wl_91 wl_92 wl_93 wl_94 wl_95 wl_96 wl_97 wl_98 wl_99 wl_100 wl_101 wl_102 wl_103 wl_104 wl_105 wl_106 wl_107 wl_108 wl_109 wl_110 wl_111 wl_112 wl_113 wl_114 wl_115 wl_116 wl_117 wl_118 wl_119 wl_120 wl_121 wl_122 wl_123 wl_124 wl_125 wl_126 wl_127 rbl_wl vdd gnd
*.PININFO addr_0:I addr_1:I addr_2:I addr_3:I addr_4:I addr_5:I addr_6:I wl_en:I wl_0:O wl_1:O wl_2:O wl_3:O wl_4:O wl_5:O wl_6:O wl_7:O wl_8:O wl_9:O wl_10:O wl_11:O wl_12:O wl_13:O wl_14:O wl_15:O wl_16:O wl_17:O wl_18:O wl_19:O wl_20:O wl_21:O wl_22:O wl_23:O wl_24:O wl_25:O wl_26:O wl_27:O wl_28:O wl_29:O wl_30:O wl_31:O wl_32:O wl_33:O wl_34:O wl_35:O wl_36:O wl_37:O wl_38:O wl_39:O wl_40:O wl_41:O wl_42:O wl_43:O wl_44:O wl_45:O wl_46:O wl_47:O wl_48:O wl_49:O wl_50:O wl_51:O wl_52:O wl_53:O wl_54:O wl_55:O wl_56:O wl_57:O wl_58:O wl_59:O wl_60:O wl_61:O wl_62:O wl_63:O wl_64:O wl_65:O wl_66:O wl_67:O wl_68:O wl_69:O wl_70:O wl_71:O wl_72:O wl_73:O wl_74:O wl_75:O wl_76:O wl_77:O wl_78:O wl_79:O wl_80:O wl_81:O wl_82:O wl_83:O wl_84:O wl_85:O wl_86:O wl_87:O wl_88:O wl_89:O wl_90:O wl_91:O wl_92:O wl_93:O wl_94:O wl_95:O wl_96:O wl_97:O wl_98:O wl_99:O wl_100:O wl_101:O wl_102:O wl_103:O wl_104:O wl_105:O wl_106:O wl_107:O wl_108:O wl_109:O wl_110:O wl_111:O wl_112:O wl_113:O wl_114:O wl_115:O wl_116:O wl_117:O wl_118:O wl_119:O wl_120:O wl_121:O wl_122:O wl_123:O wl_124:O wl_125:O wl_126:O wl_127:O rbl_wl:O vdd:B gnd:B
* INPUT : addr_0 
* INPUT : addr_1 
* INPUT : addr_2 
* INPUT : addr_3 
* INPUT : addr_4 
* INPUT : addr_5 
* INPUT : addr_6 
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
* OUTPUT: wl_64 
* OUTPUT: wl_65 
* OUTPUT: wl_66 
* OUTPUT: wl_67 
* OUTPUT: wl_68 
* OUTPUT: wl_69 
* OUTPUT: wl_70 
* OUTPUT: wl_71 
* OUTPUT: wl_72 
* OUTPUT: wl_73 
* OUTPUT: wl_74 
* OUTPUT: wl_75 
* OUTPUT: wl_76 
* OUTPUT: wl_77 
* OUTPUT: wl_78 
* OUTPUT: wl_79 
* OUTPUT: wl_80 
* OUTPUT: wl_81 
* OUTPUT: wl_82 
* OUTPUT: wl_83 
* OUTPUT: wl_84 
* OUTPUT: wl_85 
* OUTPUT: wl_86 
* OUTPUT: wl_87 
* OUTPUT: wl_88 
* OUTPUT: wl_89 
* OUTPUT: wl_90 
* OUTPUT: wl_91 
* OUTPUT: wl_92 
* OUTPUT: wl_93 
* OUTPUT: wl_94 
* OUTPUT: wl_95 
* OUTPUT: wl_96 
* OUTPUT: wl_97 
* OUTPUT: wl_98 
* OUTPUT: wl_99 
* OUTPUT: wl_100 
* OUTPUT: wl_101 
* OUTPUT: wl_102 
* OUTPUT: wl_103 
* OUTPUT: wl_104 
* OUTPUT: wl_105 
* OUTPUT: wl_106 
* OUTPUT: wl_107 
* OUTPUT: wl_108 
* OUTPUT: wl_109 
* OUTPUT: wl_110 
* OUTPUT: wl_111 
* OUTPUT: wl_112 
* OUTPUT: wl_113 
* OUTPUT: wl_114 
* OUTPUT: wl_115 
* OUTPUT: wl_116 
* OUTPUT: wl_117 
* OUTPUT: wl_118 
* OUTPUT: wl_119 
* OUTPUT: wl_120 
* OUTPUT: wl_121 
* OUTPUT: wl_122 
* OUTPUT: wl_123 
* OUTPUT: wl_124 
* OUTPUT: wl_125 
* OUTPUT: wl_126 
* OUTPUT: wl_127 
* OUTPUT: rbl_wl 
* POWER : vdd 
* GROUND: gnd 
Xrow_decoder addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 addr_6 dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 dec_out_64 dec_out_65 dec_out_66 dec_out_67 dec_out_68 dec_out_69 dec_out_70 dec_out_71 dec_out_72 dec_out_73 dec_out_74 dec_out_75 dec_out_76 dec_out_77 dec_out_78 dec_out_79 dec_out_80 dec_out_81 dec_out_82 dec_out_83 dec_out_84 dec_out_85 dec_out_86 dec_out_87 dec_out_88 dec_out_89 dec_out_90 dec_out_91 dec_out_92 dec_out_93 dec_out_94 dec_out_95 dec_out_96 dec_out_97 dec_out_98 dec_out_99 dec_out_100 dec_out_101 dec_out_102 dec_out_103 dec_out_104 dec_out_105 dec_out_106 dec_out_107 dec_out_108 dec_out_109 dec_out_110 dec_out_111 dec_out_112 dec_out_113 dec_out_114 dec_out_115 dec_out_116 dec_out_117 dec_out_118 dec_out_119 dec_out_120 dec_out_121 dec_out_122 dec_out_123 dec_out_124 dec_out_125 dec_out_126 dec_out_127 vdd gnd hierarchical_decoder
Xwordline_driver dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 dec_out_64 dec_out_65 dec_out_66 dec_out_67 dec_out_68 dec_out_69 dec_out_70 dec_out_71 dec_out_72 dec_out_73 dec_out_74 dec_out_75 dec_out_76 dec_out_77 dec_out_78 dec_out_79 dec_out_80 dec_out_81 dec_out_82 dec_out_83 dec_out_84 dec_out_85 dec_out_86 dec_out_87 dec_out_88 dec_out_89 dec_out_90 dec_out_91 dec_out_92 dec_out_93 dec_out_94 dec_out_95 dec_out_96 dec_out_97 dec_out_98 dec_out_99 dec_out_100 dec_out_101 dec_out_102 dec_out_103 dec_out_104 dec_out_105 dec_out_106 dec_out_107 dec_out_108 dec_out_109 dec_out_110 dec_out_111 dec_out_112 dec_out_113 dec_out_114 dec_out_115 dec_out_116 dec_out_117 dec_out_118 dec_out_119 dec_out_120 dec_out_121 dec_out_122 dec_out_123 dec_out_124 dec_out_125 dec_out_126 dec_out_127 wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_64 wl_65 wl_66 wl_67 wl_68 wl_69 wl_70 wl_71 wl_72 wl_73 wl_74 wl_75 wl_76 wl_77 wl_78 wl_79 wl_80 wl_81 wl_82 wl_83 wl_84 wl_85 wl_86 wl_87 wl_88 wl_89 wl_90 wl_91 wl_92 wl_93 wl_94 wl_95 wl_96 wl_97 wl_98 wl_99 wl_100 wl_101 wl_102 wl_103 wl_104 wl_105 wl_106 wl_107 wl_108 wl_109 wl_110 wl_111 wl_112 wl_113 wl_114 wl_115 wl_116 wl_117 wl_118 wl_119 wl_120 wl_121 wl_122 wl_123 wl_124 wl_125 wl_126 wl_127 wl_en vdd gnd wordline_driver_array
Xrbl_driver wl_en rbl_wl vdd gnd pinv_dec_1
.ENDS port_address

.SUBCKT port_address_0 addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 addr_6 wl_en wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_64 wl_65 wl_66 wl_67 wl_68 wl_69 wl_70 wl_71 wl_72 wl_73 wl_74 wl_75 wl_76 wl_77 wl_78 wl_79 wl_80 wl_81 wl_82 wl_83 wl_84 wl_85 wl_86 wl_87 wl_88 wl_89 wl_90 wl_91 wl_92 wl_93 wl_94 wl_95 wl_96 wl_97 wl_98 wl_99 wl_100 wl_101 wl_102 wl_103 wl_104 wl_105 wl_106 wl_107 wl_108 wl_109 wl_110 wl_111 wl_112 wl_113 wl_114 wl_115 wl_116 wl_117 wl_118 wl_119 wl_120 wl_121 wl_122 wl_123 wl_124 wl_125 wl_126 wl_127 rbl_wl vdd gnd
*.PININFO addr_0:I addr_1:I addr_2:I addr_3:I addr_4:I addr_5:I addr_6:I wl_en:I wl_0:O wl_1:O wl_2:O wl_3:O wl_4:O wl_5:O wl_6:O wl_7:O wl_8:O wl_9:O wl_10:O wl_11:O wl_12:O wl_13:O wl_14:O wl_15:O wl_16:O wl_17:O wl_18:O wl_19:O wl_20:O wl_21:O wl_22:O wl_23:O wl_24:O wl_25:O wl_26:O wl_27:O wl_28:O wl_29:O wl_30:O wl_31:O wl_32:O wl_33:O wl_34:O wl_35:O wl_36:O wl_37:O wl_38:O wl_39:O wl_40:O wl_41:O wl_42:O wl_43:O wl_44:O wl_45:O wl_46:O wl_47:O wl_48:O wl_49:O wl_50:O wl_51:O wl_52:O wl_53:O wl_54:O wl_55:O wl_56:O wl_57:O wl_58:O wl_59:O wl_60:O wl_61:O wl_62:O wl_63:O wl_64:O wl_65:O wl_66:O wl_67:O wl_68:O wl_69:O wl_70:O wl_71:O wl_72:O wl_73:O wl_74:O wl_75:O wl_76:O wl_77:O wl_78:O wl_79:O wl_80:O wl_81:O wl_82:O wl_83:O wl_84:O wl_85:O wl_86:O wl_87:O wl_88:O wl_89:O wl_90:O wl_91:O wl_92:O wl_93:O wl_94:O wl_95:O wl_96:O wl_97:O wl_98:O wl_99:O wl_100:O wl_101:O wl_102:O wl_103:O wl_104:O wl_105:O wl_106:O wl_107:O wl_108:O wl_109:O wl_110:O wl_111:O wl_112:O wl_113:O wl_114:O wl_115:O wl_116:O wl_117:O wl_118:O wl_119:O wl_120:O wl_121:O wl_122:O wl_123:O wl_124:O wl_125:O wl_126:O wl_127:O rbl_wl:O vdd:B gnd:B
* INPUT : addr_0 
* INPUT : addr_1 
* INPUT : addr_2 
* INPUT : addr_3 
* INPUT : addr_4 
* INPUT : addr_5 
* INPUT : addr_6 
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
* OUTPUT: wl_64 
* OUTPUT: wl_65 
* OUTPUT: wl_66 
* OUTPUT: wl_67 
* OUTPUT: wl_68 
* OUTPUT: wl_69 
* OUTPUT: wl_70 
* OUTPUT: wl_71 
* OUTPUT: wl_72 
* OUTPUT: wl_73 
* OUTPUT: wl_74 
* OUTPUT: wl_75 
* OUTPUT: wl_76 
* OUTPUT: wl_77 
* OUTPUT: wl_78 
* OUTPUT: wl_79 
* OUTPUT: wl_80 
* OUTPUT: wl_81 
* OUTPUT: wl_82 
* OUTPUT: wl_83 
* OUTPUT: wl_84 
* OUTPUT: wl_85 
* OUTPUT: wl_86 
* OUTPUT: wl_87 
* OUTPUT: wl_88 
* OUTPUT: wl_89 
* OUTPUT: wl_90 
* OUTPUT: wl_91 
* OUTPUT: wl_92 
* OUTPUT: wl_93 
* OUTPUT: wl_94 
* OUTPUT: wl_95 
* OUTPUT: wl_96 
* OUTPUT: wl_97 
* OUTPUT: wl_98 
* OUTPUT: wl_99 
* OUTPUT: wl_100 
* OUTPUT: wl_101 
* OUTPUT: wl_102 
* OUTPUT: wl_103 
* OUTPUT: wl_104 
* OUTPUT: wl_105 
* OUTPUT: wl_106 
* OUTPUT: wl_107 
* OUTPUT: wl_108 
* OUTPUT: wl_109 
* OUTPUT: wl_110 
* OUTPUT: wl_111 
* OUTPUT: wl_112 
* OUTPUT: wl_113 
* OUTPUT: wl_114 
* OUTPUT: wl_115 
* OUTPUT: wl_116 
* OUTPUT: wl_117 
* OUTPUT: wl_118 
* OUTPUT: wl_119 
* OUTPUT: wl_120 
* OUTPUT: wl_121 
* OUTPUT: wl_122 
* OUTPUT: wl_123 
* OUTPUT: wl_124 
* OUTPUT: wl_125 
* OUTPUT: wl_126 
* OUTPUT: wl_127 
* OUTPUT: rbl_wl 
* POWER : vdd 
* GROUND: gnd 
Xrow_decoder addr_0 addr_1 addr_2 addr_3 addr_4 addr_5 addr_6 dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 dec_out_64 dec_out_65 dec_out_66 dec_out_67 dec_out_68 dec_out_69 dec_out_70 dec_out_71 dec_out_72 dec_out_73 dec_out_74 dec_out_75 dec_out_76 dec_out_77 dec_out_78 dec_out_79 dec_out_80 dec_out_81 dec_out_82 dec_out_83 dec_out_84 dec_out_85 dec_out_86 dec_out_87 dec_out_88 dec_out_89 dec_out_90 dec_out_91 dec_out_92 dec_out_93 dec_out_94 dec_out_95 dec_out_96 dec_out_97 dec_out_98 dec_out_99 dec_out_100 dec_out_101 dec_out_102 dec_out_103 dec_out_104 dec_out_105 dec_out_106 dec_out_107 dec_out_108 dec_out_109 dec_out_110 dec_out_111 dec_out_112 dec_out_113 dec_out_114 dec_out_115 dec_out_116 dec_out_117 dec_out_118 dec_out_119 dec_out_120 dec_out_121 dec_out_122 dec_out_123 dec_out_124 dec_out_125 dec_out_126 dec_out_127 vdd gnd hierarchical_decoder
Xwordline_driver dec_out_0 dec_out_1 dec_out_2 dec_out_3 dec_out_4 dec_out_5 dec_out_6 dec_out_7 dec_out_8 dec_out_9 dec_out_10 dec_out_11 dec_out_12 dec_out_13 dec_out_14 dec_out_15 dec_out_16 dec_out_17 dec_out_18 dec_out_19 dec_out_20 dec_out_21 dec_out_22 dec_out_23 dec_out_24 dec_out_25 dec_out_26 dec_out_27 dec_out_28 dec_out_29 dec_out_30 dec_out_31 dec_out_32 dec_out_33 dec_out_34 dec_out_35 dec_out_36 dec_out_37 dec_out_38 dec_out_39 dec_out_40 dec_out_41 dec_out_42 dec_out_43 dec_out_44 dec_out_45 dec_out_46 dec_out_47 dec_out_48 dec_out_49 dec_out_50 dec_out_51 dec_out_52 dec_out_53 dec_out_54 dec_out_55 dec_out_56 dec_out_57 dec_out_58 dec_out_59 dec_out_60 dec_out_61 dec_out_62 dec_out_63 dec_out_64 dec_out_65 dec_out_66 dec_out_67 dec_out_68 dec_out_69 dec_out_70 dec_out_71 dec_out_72 dec_out_73 dec_out_74 dec_out_75 dec_out_76 dec_out_77 dec_out_78 dec_out_79 dec_out_80 dec_out_81 dec_out_82 dec_out_83 dec_out_84 dec_out_85 dec_out_86 dec_out_87 dec_out_88 dec_out_89 dec_out_90 dec_out_91 dec_out_92 dec_out_93 dec_out_94 dec_out_95 dec_out_96 dec_out_97 dec_out_98 dec_out_99 dec_out_100 dec_out_101 dec_out_102 dec_out_103 dec_out_104 dec_out_105 dec_out_106 dec_out_107 dec_out_108 dec_out_109 dec_out_110 dec_out_111 dec_out_112 dec_out_113 dec_out_114 dec_out_115 dec_out_116 dec_out_117 dec_out_118 dec_out_119 dec_out_120 dec_out_121 dec_out_122 dec_out_123 dec_out_124 dec_out_125 dec_out_126 dec_out_127 wl_0 wl_1 wl_2 wl_3 wl_4 wl_5 wl_6 wl_7 wl_8 wl_9 wl_10 wl_11 wl_12 wl_13 wl_14 wl_15 wl_16 wl_17 wl_18 wl_19 wl_20 wl_21 wl_22 wl_23 wl_24 wl_25 wl_26 wl_27 wl_28 wl_29 wl_30 wl_31 wl_32 wl_33 wl_34 wl_35 wl_36 wl_37 wl_38 wl_39 wl_40 wl_41 wl_42 wl_43 wl_44 wl_45 wl_46 wl_47 wl_48 wl_49 wl_50 wl_51 wl_52 wl_53 wl_54 wl_55 wl_56 wl_57 wl_58 wl_59 wl_60 wl_61 wl_62 wl_63 wl_64 wl_65 wl_66 wl_67 wl_68 wl_69 wl_70 wl_71 wl_72 wl_73 wl_74 wl_75 wl_76 wl_77 wl_78 wl_79 wl_80 wl_81 wl_82 wl_83 wl_84 wl_85 wl_86 wl_87 wl_88 wl_89 wl_90 wl_91 wl_92 wl_93 wl_94 wl_95 wl_96 wl_97 wl_98 wl_99 wl_100 wl_101 wl_102 wl_103 wl_104 wl_105 wl_106 wl_107 wl_108 wl_109 wl_110 wl_111 wl_112 wl_113 wl_114 wl_115 wl_116 wl_117 wl_118 wl_119 wl_120 wl_121 wl_122 wl_123 wl_124 wl_125 wl_126 wl_127 wl_en vdd gnd wordline_driver_array
Xrbl_driver wl_en rbl_wl vdd gnd pinv_dec_1
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

.SUBCKT bitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* POWER : vdd 
* GROUND: gnd 
* rows: 128 cols: 16
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
Xbit_r64_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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

.SUBCKT replica_column bl_0_0 bl_1_0 br_0_0 br_1_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 wl_0_128 wl_1_128 wl_0_129 wl_1_129 vdd gnd
*.PININFO bl_0_0:O bl_1_0:O br_0_0:O br_1_0:O wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I wl_0_128:I wl_1_128:I wl_0_129:I wl_1_129:I vdd:B gnd:B
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
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* INPUT : wl_0_128 
* INPUT : wl_1_128 
* INPUT : wl_0_129 
* INPUT : wl_1_129 
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
Xrbc_66 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_67 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_68 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_69 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_70 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_71 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_72 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_73 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_74 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_75 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_76 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_77 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_78 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_79 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_80 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_81 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_82 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_83 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_84 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_85 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_86 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_87 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_88 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_89 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_90 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_91 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_92 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_93 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_94 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_95 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_96 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_97 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_98 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_99 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_100 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_101 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_102 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_103 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_104 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_105 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_106 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_107 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_108 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_109 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_110 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_111 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_112 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_113 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_114 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_115 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_116 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_117 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_118 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_119 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_120 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_121 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_122 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_123 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_124 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_125 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_126 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_127 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_128 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_129 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_128 wl_1_128 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_130 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_129 wl_1_129 vdd gnd sky130_fd_bd_sram__openram_dp_cell_dummy
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

.SUBCKT replica_bitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO rbl_bl_0_0:B rbl_bl_1_0:B rbl_br_0_0:B rbl_br_1_0:B bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
* rbl: [1, 1] left_rbl: [0] right_rbl: []
Xbitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 vdd gnd bitcell_array
Xreplica_col_0 rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 rbl_wl_0_0 gnd wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 gnd rbl_wl_1_1 vdd gnd replica_column
Xdummy_row_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 gnd vdd gnd dummy_array
Xdummy_row_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 gnd rbl_wl_1_1 vdd gnd dummy_array
.ENDS replica_bitcell_array

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=7.0 l=0.15 pd=14.30 ps=14.30 as=2.62u ad=2.62u

.SUBCKT pinv_dec_2 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=7.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=7.0u l=0.15u
.ENDS pinv_dec_2

.SUBCKT wordline_buffer_array in_0 in_1 in_2 in_3 in_4 in_5 in_6 in_7 in_8 in_9 in_10 in_11 in_12 in_13 in_14 in_15 in_16 in_17 in_18 in_19 in_20 in_21 in_22 in_23 in_24 in_25 in_26 in_27 in_28 in_29 in_30 in_31 in_32 in_33 in_34 in_35 in_36 in_37 in_38 in_39 in_40 in_41 in_42 in_43 in_44 in_45 in_46 in_47 in_48 in_49 in_50 in_51 in_52 in_53 in_54 in_55 in_56 in_57 in_58 in_59 in_60 in_61 in_62 in_63 in_64 in_65 in_66 in_67 in_68 in_69 in_70 in_71 in_72 in_73 in_74 in_75 in_76 in_77 in_78 in_79 in_80 in_81 in_82 in_83 in_84 in_85 in_86 in_87 in_88 in_89 in_90 in_91 in_92 in_93 in_94 in_95 in_96 in_97 in_98 in_99 in_100 in_101 in_102 in_103 in_104 in_105 in_106 in_107 in_108 in_109 in_110 in_111 in_112 in_113 in_114 in_115 in_116 in_117 in_118 in_119 in_120 in_121 in_122 in_123 in_124 in_125 in_126 in_127 in_128 out_0 out_1 out_2 out_3 out_4 out_5 out_6 out_7 out_8 out_9 out_10 out_11 out_12 out_13 out_14 out_15 out_16 out_17 out_18 out_19 out_20 out_21 out_22 out_23 out_24 out_25 out_26 out_27 out_28 out_29 out_30 out_31 out_32 out_33 out_34 out_35 out_36 out_37 out_38 out_39 out_40 out_41 out_42 out_43 out_44 out_45 out_46 out_47 out_48 out_49 out_50 out_51 out_52 out_53 out_54 out_55 out_56 out_57 out_58 out_59 out_60 out_61 out_62 out_63 out_64 out_65 out_66 out_67 out_68 out_69 out_70 out_71 out_72 out_73 out_74 out_75 out_76 out_77 out_78 out_79 out_80 out_81 out_82 out_83 out_84 out_85 out_86 out_87 out_88 out_89 out_90 out_91 out_92 out_93 out_94 out_95 out_96 out_97 out_98 out_99 out_100 out_101 out_102 out_103 out_104 out_105 out_106 out_107 out_108 out_109 out_110 out_111 out_112 out_113 out_114 out_115 out_116 out_117 out_118 out_119 out_120 out_121 out_122 out_123 out_124 out_125 out_126 out_127 out_128 vdd gnd
*.PININFO in_0:I in_1:I in_2:I in_3:I in_4:I in_5:I in_6:I in_7:I in_8:I in_9:I in_10:I in_11:I in_12:I in_13:I in_14:I in_15:I in_16:I in_17:I in_18:I in_19:I in_20:I in_21:I in_22:I in_23:I in_24:I in_25:I in_26:I in_27:I in_28:I in_29:I in_30:I in_31:I in_32:I in_33:I in_34:I in_35:I in_36:I in_37:I in_38:I in_39:I in_40:I in_41:I in_42:I in_43:I in_44:I in_45:I in_46:I in_47:I in_48:I in_49:I in_50:I in_51:I in_52:I in_53:I in_54:I in_55:I in_56:I in_57:I in_58:I in_59:I in_60:I in_61:I in_62:I in_63:I in_64:I in_65:I in_66:I in_67:I in_68:I in_69:I in_70:I in_71:I in_72:I in_73:I in_74:I in_75:I in_76:I in_77:I in_78:I in_79:I in_80:I in_81:I in_82:I in_83:I in_84:I in_85:I in_86:I in_87:I in_88:I in_89:I in_90:I in_91:I in_92:I in_93:I in_94:I in_95:I in_96:I in_97:I in_98:I in_99:I in_100:I in_101:I in_102:I in_103:I in_104:I in_105:I in_106:I in_107:I in_108:I in_109:I in_110:I in_111:I in_112:I in_113:I in_114:I in_115:I in_116:I in_117:I in_118:I in_119:I in_120:I in_121:I in_122:I in_123:I in_124:I in_125:I in_126:I in_127:I in_128:I out_0:O out_1:O out_2:O out_3:O out_4:O out_5:O out_6:O out_7:O out_8:O out_9:O out_10:O out_11:O out_12:O out_13:O out_14:O out_15:O out_16:O out_17:O out_18:O out_19:O out_20:O out_21:O out_22:O out_23:O out_24:O out_25:O out_26:O out_27:O out_28:O out_29:O out_30:O out_31:O out_32:O out_33:O out_34:O out_35:O out_36:O out_37:O out_38:O out_39:O out_40:O out_41:O out_42:O out_43:O out_44:O out_45:O out_46:O out_47:O out_48:O out_49:O out_50:O out_51:O out_52:O out_53:O out_54:O out_55:O out_56:O out_57:O out_58:O out_59:O out_60:O out_61:O out_62:O out_63:O out_64:O out_65:O out_66:O out_67:O out_68:O out_69:O out_70:O out_71:O out_72:O out_73:O out_74:O out_75:O out_76:O out_77:O out_78:O out_79:O out_80:O out_81:O out_82:O out_83:O out_84:O out_85:O out_86:O out_87:O out_88:O out_89:O out_90:O out_91:O out_92:O out_93:O out_94:O out_95:O out_96:O out_97:O out_98:O out_99:O out_100:O out_101:O out_102:O out_103:O out_104:O out_105:O out_106:O out_107:O out_108:O out_109:O out_110:O out_111:O out_112:O out_113:O out_114:O out_115:O out_116:O out_117:O out_118:O out_119:O out_120:O out_121:O out_122:O out_123:O out_124:O out_125:O out_126:O out_127:O out_128:O vdd:B gnd:B
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
* INPUT : in_65 
* INPUT : in_66 
* INPUT : in_67 
* INPUT : in_68 
* INPUT : in_69 
* INPUT : in_70 
* INPUT : in_71 
* INPUT : in_72 
* INPUT : in_73 
* INPUT : in_74 
* INPUT : in_75 
* INPUT : in_76 
* INPUT : in_77 
* INPUT : in_78 
* INPUT : in_79 
* INPUT : in_80 
* INPUT : in_81 
* INPUT : in_82 
* INPUT : in_83 
* INPUT : in_84 
* INPUT : in_85 
* INPUT : in_86 
* INPUT : in_87 
* INPUT : in_88 
* INPUT : in_89 
* INPUT : in_90 
* INPUT : in_91 
* INPUT : in_92 
* INPUT : in_93 
* INPUT : in_94 
* INPUT : in_95 
* INPUT : in_96 
* INPUT : in_97 
* INPUT : in_98 
* INPUT : in_99 
* INPUT : in_100 
* INPUT : in_101 
* INPUT : in_102 
* INPUT : in_103 
* INPUT : in_104 
* INPUT : in_105 
* INPUT : in_106 
* INPUT : in_107 
* INPUT : in_108 
* INPUT : in_109 
* INPUT : in_110 
* INPUT : in_111 
* INPUT : in_112 
* INPUT : in_113 
* INPUT : in_114 
* INPUT : in_115 
* INPUT : in_116 
* INPUT : in_117 
* INPUT : in_118 
* INPUT : in_119 
* INPUT : in_120 
* INPUT : in_121 
* INPUT : in_122 
* INPUT : in_123 
* INPUT : in_124 
* INPUT : in_125 
* INPUT : in_126 
* INPUT : in_127 
* INPUT : in_128 
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
* OUTPUT: out_65 
* OUTPUT: out_66 
* OUTPUT: out_67 
* OUTPUT: out_68 
* OUTPUT: out_69 
* OUTPUT: out_70 
* OUTPUT: out_71 
* OUTPUT: out_72 
* OUTPUT: out_73 
* OUTPUT: out_74 
* OUTPUT: out_75 
* OUTPUT: out_76 
* OUTPUT: out_77 
* OUTPUT: out_78 
* OUTPUT: out_79 
* OUTPUT: out_80 
* OUTPUT: out_81 
* OUTPUT: out_82 
* OUTPUT: out_83 
* OUTPUT: out_84 
* OUTPUT: out_85 
* OUTPUT: out_86 
* OUTPUT: out_87 
* OUTPUT: out_88 
* OUTPUT: out_89 
* OUTPUT: out_90 
* OUTPUT: out_91 
* OUTPUT: out_92 
* OUTPUT: out_93 
* OUTPUT: out_94 
* OUTPUT: out_95 
* OUTPUT: out_96 
* OUTPUT: out_97 
* OUTPUT: out_98 
* OUTPUT: out_99 
* OUTPUT: out_100 
* OUTPUT: out_101 
* OUTPUT: out_102 
* OUTPUT: out_103 
* OUTPUT: out_104 
* OUTPUT: out_105 
* OUTPUT: out_106 
* OUTPUT: out_107 
* OUTPUT: out_108 
* OUTPUT: out_109 
* OUTPUT: out_110 
* OUTPUT: out_111 
* OUTPUT: out_112 
* OUTPUT: out_113 
* OUTPUT: out_114 
* OUTPUT: out_115 
* OUTPUT: out_116 
* OUTPUT: out_117 
* OUTPUT: out_118 
* OUTPUT: out_119 
* OUTPUT: out_120 
* OUTPUT: out_121 
* OUTPUT: out_122 
* OUTPUT: out_123 
* OUTPUT: out_124 
* OUTPUT: out_125 
* OUTPUT: out_126 
* OUTPUT: out_127 
* OUTPUT: out_128 
* POWER : vdd 
* GROUND: gnd 
* rows: 129 cols: 16
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
Xwld65 in_65 out_65 vdd gnd pinv_dec_2
Xwld66 in_66 out_66 vdd gnd pinv_dec_2
Xwld67 in_67 out_67 vdd gnd pinv_dec_2
Xwld68 in_68 out_68 vdd gnd pinv_dec_2
Xwld69 in_69 out_69 vdd gnd pinv_dec_2
Xwld70 in_70 out_70 vdd gnd pinv_dec_2
Xwld71 in_71 out_71 vdd gnd pinv_dec_2
Xwld72 in_72 out_72 vdd gnd pinv_dec_2
Xwld73 in_73 out_73 vdd gnd pinv_dec_2
Xwld74 in_74 out_74 vdd gnd pinv_dec_2
Xwld75 in_75 out_75 vdd gnd pinv_dec_2
Xwld76 in_76 out_76 vdd gnd pinv_dec_2
Xwld77 in_77 out_77 vdd gnd pinv_dec_2
Xwld78 in_78 out_78 vdd gnd pinv_dec_2
Xwld79 in_79 out_79 vdd gnd pinv_dec_2
Xwld80 in_80 out_80 vdd gnd pinv_dec_2
Xwld81 in_81 out_81 vdd gnd pinv_dec_2
Xwld82 in_82 out_82 vdd gnd pinv_dec_2
Xwld83 in_83 out_83 vdd gnd pinv_dec_2
Xwld84 in_84 out_84 vdd gnd pinv_dec_2
Xwld85 in_85 out_85 vdd gnd pinv_dec_2
Xwld86 in_86 out_86 vdd gnd pinv_dec_2
Xwld87 in_87 out_87 vdd gnd pinv_dec_2
Xwld88 in_88 out_88 vdd gnd pinv_dec_2
Xwld89 in_89 out_89 vdd gnd pinv_dec_2
Xwld90 in_90 out_90 vdd gnd pinv_dec_2
Xwld91 in_91 out_91 vdd gnd pinv_dec_2
Xwld92 in_92 out_92 vdd gnd pinv_dec_2
Xwld93 in_93 out_93 vdd gnd pinv_dec_2
Xwld94 in_94 out_94 vdd gnd pinv_dec_2
Xwld95 in_95 out_95 vdd gnd pinv_dec_2
Xwld96 in_96 out_96 vdd gnd pinv_dec_2
Xwld97 in_97 out_97 vdd gnd pinv_dec_2
Xwld98 in_98 out_98 vdd gnd pinv_dec_2
Xwld99 in_99 out_99 vdd gnd pinv_dec_2
Xwld100 in_100 out_100 vdd gnd pinv_dec_2
Xwld101 in_101 out_101 vdd gnd pinv_dec_2
Xwld102 in_102 out_102 vdd gnd pinv_dec_2
Xwld103 in_103 out_103 vdd gnd pinv_dec_2
Xwld104 in_104 out_104 vdd gnd pinv_dec_2
Xwld105 in_105 out_105 vdd gnd pinv_dec_2
Xwld106 in_106 out_106 vdd gnd pinv_dec_2
Xwld107 in_107 out_107 vdd gnd pinv_dec_2
Xwld108 in_108 out_108 vdd gnd pinv_dec_2
Xwld109 in_109 out_109 vdd gnd pinv_dec_2
Xwld110 in_110 out_110 vdd gnd pinv_dec_2
Xwld111 in_111 out_111 vdd gnd pinv_dec_2
Xwld112 in_112 out_112 vdd gnd pinv_dec_2
Xwld113 in_113 out_113 vdd gnd pinv_dec_2
Xwld114 in_114 out_114 vdd gnd pinv_dec_2
Xwld115 in_115 out_115 vdd gnd pinv_dec_2
Xwld116 in_116 out_116 vdd gnd pinv_dec_2
Xwld117 in_117 out_117 vdd gnd pinv_dec_2
Xwld118 in_118 out_118 vdd gnd pinv_dec_2
Xwld119 in_119 out_119 vdd gnd pinv_dec_2
Xwld120 in_120 out_120 vdd gnd pinv_dec_2
Xwld121 in_121 out_121 vdd gnd pinv_dec_2
Xwld122 in_122 out_122 vdd gnd pinv_dec_2
Xwld123 in_123 out_123 vdd gnd pinv_dec_2
Xwld124 in_124 out_124 vdd gnd pinv_dec_2
Xwld125 in_125 out_125 vdd gnd pinv_dec_2
Xwld126 in_126 out_126 vdd gnd pinv_dec_2
Xwld127 in_127 out_127 vdd gnd pinv_dec_2
Xwld128 in_128 out_128 vdd gnd pinv_dec_2
.ENDS wordline_buffer_array

.SUBCKT local_bitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO rbl_bl_0_0:B rbl_bl_1_0:B rbl_br_0_0:B rbl_br_1_0:B bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_wl_0_0:I wl_0_0:I wl_0_1:I wl_0_2:I wl_0_3:I wl_0_4:I wl_0_5:I wl_0_6:I wl_0_7:I wl_0_8:I wl_0_9:I wl_0_10:I wl_0_11:I wl_0_12:I wl_0_13:I wl_0_14:I wl_0_15:I wl_0_16:I wl_0_17:I wl_0_18:I wl_0_19:I wl_0_20:I wl_0_21:I wl_0_22:I wl_0_23:I wl_0_24:I wl_0_25:I wl_0_26:I wl_0_27:I wl_0_28:I wl_0_29:I wl_0_30:I wl_0_31:I wl_0_32:I wl_0_33:I wl_0_34:I wl_0_35:I wl_0_36:I wl_0_37:I wl_0_38:I wl_0_39:I wl_0_40:I wl_0_41:I wl_0_42:I wl_0_43:I wl_0_44:I wl_0_45:I wl_0_46:I wl_0_47:I wl_0_48:I wl_0_49:I wl_0_50:I wl_0_51:I wl_0_52:I wl_0_53:I wl_0_54:I wl_0_55:I wl_0_56:I wl_0_57:I wl_0_58:I wl_0_59:I wl_0_60:I wl_0_61:I wl_0_62:I wl_0_63:I wl_0_64:I wl_0_65:I wl_0_66:I wl_0_67:I wl_0_68:I wl_0_69:I wl_0_70:I wl_0_71:I wl_0_72:I wl_0_73:I wl_0_74:I wl_0_75:I wl_0_76:I wl_0_77:I wl_0_78:I wl_0_79:I wl_0_80:I wl_0_81:I wl_0_82:I wl_0_83:I wl_0_84:I wl_0_85:I wl_0_86:I wl_0_87:I wl_0_88:I wl_0_89:I wl_0_90:I wl_0_91:I wl_0_92:I wl_0_93:I wl_0_94:I wl_0_95:I wl_0_96:I wl_0_97:I wl_0_98:I wl_0_99:I wl_0_100:I wl_0_101:I wl_0_102:I wl_0_103:I wl_0_104:I wl_0_105:I wl_0_106:I wl_0_107:I wl_0_108:I wl_0_109:I wl_0_110:I wl_0_111:I wl_0_112:I wl_0_113:I wl_0_114:I wl_0_115:I wl_0_116:I wl_0_117:I wl_0_118:I wl_0_119:I wl_0_120:I wl_0_121:I wl_0_122:I wl_0_123:I wl_0_124:I wl_0_125:I wl_0_126:I wl_0_127:I wl_1_0:I wl_1_1:I wl_1_2:I wl_1_3:I wl_1_4:I wl_1_5:I wl_1_6:I wl_1_7:I wl_1_8:I wl_1_9:I wl_1_10:I wl_1_11:I wl_1_12:I wl_1_13:I wl_1_14:I wl_1_15:I wl_1_16:I wl_1_17:I wl_1_18:I wl_1_19:I wl_1_20:I wl_1_21:I wl_1_22:I wl_1_23:I wl_1_24:I wl_1_25:I wl_1_26:I wl_1_27:I wl_1_28:I wl_1_29:I wl_1_30:I wl_1_31:I wl_1_32:I wl_1_33:I wl_1_34:I wl_1_35:I wl_1_36:I wl_1_37:I wl_1_38:I wl_1_39:I wl_1_40:I wl_1_41:I wl_1_42:I wl_1_43:I wl_1_44:I wl_1_45:I wl_1_46:I wl_1_47:I wl_1_48:I wl_1_49:I wl_1_50:I wl_1_51:I wl_1_52:I wl_1_53:I wl_1_54:I wl_1_55:I wl_1_56:I wl_1_57:I wl_1_58:I wl_1_59:I wl_1_60:I wl_1_61:I wl_1_62:I wl_1_63:I wl_1_64:I wl_1_65:I wl_1_66:I wl_1_67:I wl_1_68:I wl_1_69:I wl_1_70:I wl_1_71:I wl_1_72:I wl_1_73:I wl_1_74:I wl_1_75:I wl_1_76:I wl_1_77:I wl_1_78:I wl_1_79:I wl_1_80:I wl_1_81:I wl_1_82:I wl_1_83:I wl_1_84:I wl_1_85:I wl_1_86:I wl_1_87:I wl_1_88:I wl_1_89:I wl_1_90:I wl_1_91:I wl_1_92:I wl_1_93:I wl_1_94:I wl_1_95:I wl_1_96:I wl_1_97:I wl_1_98:I wl_1_99:I wl_1_100:I wl_1_101:I wl_1_102:I wl_1_103:I wl_1_104:I wl_1_105:I wl_1_106:I wl_1_107:I wl_1_108:I wl_1_109:I wl_1_110:I wl_1_111:I wl_1_112:I wl_1_113:I wl_1_114:I wl_1_115:I wl_1_116:I wl_1_117:I wl_1_118:I wl_1_119:I wl_1_120:I wl_1_121:I wl_1_122:I wl_1_123:I wl_1_124:I wl_1_125:I wl_1_126:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_0_65 
* INPUT : wl_0_66 
* INPUT : wl_0_67 
* INPUT : wl_0_68 
* INPUT : wl_0_69 
* INPUT : wl_0_70 
* INPUT : wl_0_71 
* INPUT : wl_0_72 
* INPUT : wl_0_73 
* INPUT : wl_0_74 
* INPUT : wl_0_75 
* INPUT : wl_0_76 
* INPUT : wl_0_77 
* INPUT : wl_0_78 
* INPUT : wl_0_79 
* INPUT : wl_0_80 
* INPUT : wl_0_81 
* INPUT : wl_0_82 
* INPUT : wl_0_83 
* INPUT : wl_0_84 
* INPUT : wl_0_85 
* INPUT : wl_0_86 
* INPUT : wl_0_87 
* INPUT : wl_0_88 
* INPUT : wl_0_89 
* INPUT : wl_0_90 
* INPUT : wl_0_91 
* INPUT : wl_0_92 
* INPUT : wl_0_93 
* INPUT : wl_0_94 
* INPUT : wl_0_95 
* INPUT : wl_0_96 
* INPUT : wl_0_97 
* INPUT : wl_0_98 
* INPUT : wl_0_99 
* INPUT : wl_0_100 
* INPUT : wl_0_101 
* INPUT : wl_0_102 
* INPUT : wl_0_103 
* INPUT : wl_0_104 
* INPUT : wl_0_105 
* INPUT : wl_0_106 
* INPUT : wl_0_107 
* INPUT : wl_0_108 
* INPUT : wl_0_109 
* INPUT : wl_0_110 
* INPUT : wl_0_111 
* INPUT : wl_0_112 
* INPUT : wl_0_113 
* INPUT : wl_0_114 
* INPUT : wl_0_115 
* INPUT : wl_0_116 
* INPUT : wl_0_117 
* INPUT : wl_0_118 
* INPUT : wl_0_119 
* INPUT : wl_0_120 
* INPUT : wl_0_121 
* INPUT : wl_0_122 
* INPUT : wl_0_123 
* INPUT : wl_0_124 
* INPUT : wl_0_125 
* INPUT : wl_0_126 
* INPUT : wl_0_127 
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
* INPUT : wl_1_64 
* INPUT : wl_1_65 
* INPUT : wl_1_66 
* INPUT : wl_1_67 
* INPUT : wl_1_68 
* INPUT : wl_1_69 
* INPUT : wl_1_70 
* INPUT : wl_1_71 
* INPUT : wl_1_72 
* INPUT : wl_1_73 
* INPUT : wl_1_74 
* INPUT : wl_1_75 
* INPUT : wl_1_76 
* INPUT : wl_1_77 
* INPUT : wl_1_78 
* INPUT : wl_1_79 
* INPUT : wl_1_80 
* INPUT : wl_1_81 
* INPUT : wl_1_82 
* INPUT : wl_1_83 
* INPUT : wl_1_84 
* INPUT : wl_1_85 
* INPUT : wl_1_86 
* INPUT : wl_1_87 
* INPUT : wl_1_88 
* INPUT : wl_1_89 
* INPUT : wl_1_90 
* INPUT : wl_1_91 
* INPUT : wl_1_92 
* INPUT : wl_1_93 
* INPUT : wl_1_94 
* INPUT : wl_1_95 
* INPUT : wl_1_96 
* INPUT : wl_1_97 
* INPUT : wl_1_98 
* INPUT : wl_1_99 
* INPUT : wl_1_100 
* INPUT : wl_1_101 
* INPUT : wl_1_102 
* INPUT : wl_1_103 
* INPUT : wl_1_104 
* INPUT : wl_1_105 
* INPUT : wl_1_106 
* INPUT : wl_1_107 
* INPUT : wl_1_108 
* INPUT : wl_1_109 
* INPUT : wl_1_110 
* INPUT : wl_1_111 
* INPUT : wl_1_112 
* INPUT : wl_1_113 
* INPUT : wl_1_114 
* INPUT : wl_1_115 
* INPUT : wl_1_116 
* INPUT : wl_1_117 
* INPUT : wl_1_118 
* INPUT : wl_1_119 
* INPUT : wl_1_120 
* INPUT : wl_1_121 
* INPUT : wl_1_122 
* INPUT : wl_1_123 
* INPUT : wl_1_124 
* INPUT : wl_1_125 
* INPUT : wl_1_126 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xwl_driver0 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 rbl_wl_0_0i wl_0_0i wl_0_1i wl_0_2i wl_0_3i wl_0_4i wl_0_5i wl_0_6i wl_0_7i wl_0_8i wl_0_9i wl_0_10i wl_0_11i wl_0_12i wl_0_13i wl_0_14i wl_0_15i wl_0_16i wl_0_17i wl_0_18i wl_0_19i wl_0_20i wl_0_21i wl_0_22i wl_0_23i wl_0_24i wl_0_25i wl_0_26i wl_0_27i wl_0_28i wl_0_29i wl_0_30i wl_0_31i wl_0_32i wl_0_33i wl_0_34i wl_0_35i wl_0_36i wl_0_37i wl_0_38i wl_0_39i wl_0_40i wl_0_41i wl_0_42i wl_0_43i wl_0_44i wl_0_45i wl_0_46i wl_0_47i wl_0_48i wl_0_49i wl_0_50i wl_0_51i wl_0_52i wl_0_53i wl_0_54i wl_0_55i wl_0_56i wl_0_57i wl_0_58i wl_0_59i wl_0_60i wl_0_61i wl_0_62i wl_0_63i wl_0_64i wl_0_65i wl_0_66i wl_0_67i wl_0_68i wl_0_69i wl_0_70i wl_0_71i wl_0_72i wl_0_73i wl_0_74i wl_0_75i wl_0_76i wl_0_77i wl_0_78i wl_0_79i wl_0_80i wl_0_81i wl_0_82i wl_0_83i wl_0_84i wl_0_85i wl_0_86i wl_0_87i wl_0_88i wl_0_89i wl_0_90i wl_0_91i wl_0_92i wl_0_93i wl_0_94i wl_0_95i wl_0_96i wl_0_97i wl_0_98i wl_0_99i wl_0_100i wl_0_101i wl_0_102i wl_0_103i wl_0_104i wl_0_105i wl_0_106i wl_0_107i wl_0_108i wl_0_109i wl_0_110i wl_0_111i wl_0_112i wl_0_113i wl_0_114i wl_0_115i wl_0_116i wl_0_117i wl_0_118i wl_0_119i wl_0_120i wl_0_121i wl_0_122i wl_0_123i wl_0_124i wl_0_125i wl_0_126i wl_0_127i vdd gnd wordline_buffer_array
Xwl_driver1 rbl_wl_1_1 wl_1_127 wl_1_126 wl_1_125 wl_1_124 wl_1_123 wl_1_122 wl_1_121 wl_1_120 wl_1_119 wl_1_118 wl_1_117 wl_1_116 wl_1_115 wl_1_114 wl_1_113 wl_1_112 wl_1_111 wl_1_110 wl_1_109 wl_1_108 wl_1_107 wl_1_106 wl_1_105 wl_1_104 wl_1_103 wl_1_102 wl_1_101 wl_1_100 wl_1_99 wl_1_98 wl_1_97 wl_1_96 wl_1_95 wl_1_94 wl_1_93 wl_1_92 wl_1_91 wl_1_90 wl_1_89 wl_1_88 wl_1_87 wl_1_86 wl_1_85 wl_1_84 wl_1_83 wl_1_82 wl_1_81 wl_1_80 wl_1_79 wl_1_78 wl_1_77 wl_1_76 wl_1_75 wl_1_74 wl_1_73 wl_1_72 wl_1_71 wl_1_70 wl_1_69 wl_1_68 wl_1_67 wl_1_66 wl_1_65 wl_1_64 wl_1_63 wl_1_62 wl_1_61 wl_1_60 wl_1_59 wl_1_58 wl_1_57 wl_1_56 wl_1_55 wl_1_54 wl_1_53 wl_1_52 wl_1_51 wl_1_50 wl_1_49 wl_1_48 wl_1_47 wl_1_46 wl_1_45 wl_1_44 wl_1_43 wl_1_42 wl_1_41 wl_1_40 wl_1_39 wl_1_38 wl_1_37 wl_1_36 wl_1_35 wl_1_34 wl_1_33 wl_1_32 wl_1_31 wl_1_30 wl_1_29 wl_1_28 wl_1_27 wl_1_26 wl_1_25 wl_1_24 wl_1_23 wl_1_22 wl_1_21 wl_1_20 wl_1_19 wl_1_18 wl_1_17 wl_1_16 wl_1_15 wl_1_14 wl_1_13 wl_1_12 wl_1_11 wl_1_10 wl_1_9 wl_1_8 wl_1_7 wl_1_6 wl_1_5 wl_1_4 wl_1_3 wl_1_2 wl_1_1 wl_1_0 rbl_wl_1_1i wl_1_127i wl_1_126i wl_1_125i wl_1_124i wl_1_123i wl_1_122i wl_1_121i wl_1_120i wl_1_119i wl_1_118i wl_1_117i wl_1_116i wl_1_115i wl_1_114i wl_1_113i wl_1_112i wl_1_111i wl_1_110i wl_1_109i wl_1_108i wl_1_107i wl_1_106i wl_1_105i wl_1_104i wl_1_103i wl_1_102i wl_1_101i wl_1_100i wl_1_99i wl_1_98i wl_1_97i wl_1_96i wl_1_95i wl_1_94i wl_1_93i wl_1_92i wl_1_91i wl_1_90i wl_1_89i wl_1_88i wl_1_87i wl_1_86i wl_1_85i wl_1_84i wl_1_83i wl_1_82i wl_1_81i wl_1_80i wl_1_79i wl_1_78i wl_1_77i wl_1_76i wl_1_75i wl_1_74i wl_1_73i wl_1_72i wl_1_71i wl_1_70i wl_1_69i wl_1_68i wl_1_67i wl_1_66i wl_1_65i wl_1_64i wl_1_63i wl_1_62i wl_1_61i wl_1_60i wl_1_59i wl_1_58i wl_1_57i wl_1_56i wl_1_55i wl_1_54i wl_1_53i wl_1_52i wl_1_51i wl_1_50i wl_1_49i wl_1_48i wl_1_47i wl_1_46i wl_1_45i wl_1_44i wl_1_43i wl_1_42i wl_1_41i wl_1_40i wl_1_39i wl_1_38i wl_1_37i wl_1_36i wl_1_35i wl_1_34i wl_1_33i wl_1_32i wl_1_31i wl_1_30i wl_1_29i wl_1_28i wl_1_27i wl_1_26i wl_1_25i wl_1_24i wl_1_23i wl_1_22i wl_1_21i wl_1_20i wl_1_19i wl_1_18i wl_1_17i wl_1_16i wl_1_15i wl_1_14i wl_1_13i wl_1_12i wl_1_11i wl_1_10i wl_1_9i wl_1_8i wl_1_7i wl_1_6i wl_1_5i wl_1_4i wl_1_3i wl_1_2i wl_1_1i wl_1_0i vdd gnd wordline_buffer_array
Xarray rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0i wl_0_0i wl_1_0i wl_0_1i wl_1_1i wl_0_2i wl_1_2i wl_0_3i wl_1_3i wl_0_4i wl_1_4i wl_0_5i wl_1_5i wl_0_6i wl_1_6i wl_0_7i wl_1_7i wl_0_8i wl_1_8i wl_0_9i wl_1_9i wl_0_10i wl_1_10i wl_0_11i wl_1_11i wl_0_12i wl_1_12i wl_0_13i wl_1_13i wl_0_14i wl_1_14i wl_0_15i wl_1_15i wl_0_16i wl_1_16i wl_0_17i wl_1_17i wl_0_18i wl_1_18i wl_0_19i wl_1_19i wl_0_20i wl_1_20i wl_0_21i wl_1_21i wl_0_22i wl_1_22i wl_0_23i wl_1_23i wl_0_24i wl_1_24i wl_0_25i wl_1_25i wl_0_26i wl_1_26i wl_0_27i wl_1_27i wl_0_28i wl_1_28i wl_0_29i wl_1_29i wl_0_30i wl_1_30i wl_0_31i wl_1_31i wl_0_32i wl_1_32i wl_0_33i wl_1_33i wl_0_34i wl_1_34i wl_0_35i wl_1_35i wl_0_36i wl_1_36i wl_0_37i wl_1_37i wl_0_38i wl_1_38i wl_0_39i wl_1_39i wl_0_40i wl_1_40i wl_0_41i wl_1_41i wl_0_42i wl_1_42i wl_0_43i wl_1_43i wl_0_44i wl_1_44i wl_0_45i wl_1_45i wl_0_46i wl_1_46i wl_0_47i wl_1_47i wl_0_48i wl_1_48i wl_0_49i wl_1_49i wl_0_50i wl_1_50i wl_0_51i wl_1_51i wl_0_52i wl_1_52i wl_0_53i wl_1_53i wl_0_54i wl_1_54i wl_0_55i wl_1_55i wl_0_56i wl_1_56i wl_0_57i wl_1_57i wl_0_58i wl_1_58i wl_0_59i wl_1_59i wl_0_60i wl_1_60i wl_0_61i wl_1_61i wl_0_62i wl_1_62i wl_0_63i wl_1_63i wl_0_64i wl_1_64i wl_0_65i wl_1_65i wl_0_66i wl_1_66i wl_0_67i wl_1_67i wl_0_68i wl_1_68i wl_0_69i wl_1_69i wl_0_70i wl_1_70i wl_0_71i wl_1_71i wl_0_72i wl_1_72i wl_0_73i wl_1_73i wl_0_74i wl_1_74i wl_0_75i wl_1_75i wl_0_76i wl_1_76i wl_0_77i wl_1_77i wl_0_78i wl_1_78i wl_0_79i wl_1_79i wl_0_80i wl_1_80i wl_0_81i wl_1_81i wl_0_82i wl_1_82i wl_0_83i wl_1_83i wl_0_84i wl_1_84i wl_0_85i wl_1_85i wl_0_86i wl_1_86i wl_0_87i wl_1_87i wl_0_88i wl_1_88i wl_0_89i wl_1_89i wl_0_90i wl_1_90i wl_0_91i wl_1_91i wl_0_92i wl_1_92i wl_0_93i wl_1_93i wl_0_94i wl_1_94i wl_0_95i wl_1_95i wl_0_96i wl_1_96i wl_0_97i wl_1_97i wl_0_98i wl_1_98i wl_0_99i wl_1_99i wl_0_100i wl_1_100i wl_0_101i wl_1_101i wl_0_102i wl_1_102i wl_0_103i wl_1_103i wl_0_104i wl_1_104i wl_0_105i wl_1_105i wl_0_106i wl_1_106i wl_0_107i wl_1_107i wl_0_108i wl_1_108i wl_0_109i wl_1_109i wl_0_110i wl_1_110i wl_0_111i wl_1_111i wl_0_112i wl_1_112i wl_0_113i wl_1_113i wl_0_114i wl_1_114i wl_0_115i wl_1_115i wl_0_116i wl_1_116i wl_0_117i wl_1_117i wl_0_118i wl_1_118i wl_0_119i wl_1_119i wl_0_120i wl_1_120i wl_0_121i wl_1_121i wl_0_122i wl_1_122i wl_0_123i wl_1_123i wl_0_124i wl_1_124i wl_0_125i wl_1_125i wl_0_126i wl_1_126i wl_0_127i wl_1_127i rbl_wl_1_1i vdd gnd replica_bitcell_array
.ENDS local_bitcell_array

.SUBCKT bitcell_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* POWER : vdd 
* GROUND: gnd 
* rows: 128 cols: 16
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
Xbit_r64_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c0 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c1 bl_0_1 br_0_1 bl_1_1 br_1_1 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c2 bl_0_2 br_0_2 bl_1_2 br_1_2 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c3 bl_0_3 br_0_3 bl_1_3 br_1_3 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c4 bl_0_4 br_0_4 bl_1_4 br_1_4 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c5 bl_0_5 br_0_5 bl_1_5 br_1_5 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c6 bl_0_6 br_0_6 bl_1_6 br_1_6 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c7 bl_0_7 br_0_7 bl_1_7 br_1_7 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c8 bl_0_8 br_0_8 bl_1_8 br_1_8 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c9 bl_0_9 br_0_9 bl_1_9 br_1_9 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c10 bl_0_10 br_0_10 bl_1_10 br_1_10 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c11 bl_0_11 br_0_11 bl_1_11 br_1_11 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c12 bl_0_12 br_0_12 bl_1_12 br_1_12 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c13 bl_0_13 br_0_13 bl_1_13 br_1_13 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c14 bl_0_14 br_0_14 bl_1_14 br_1_14 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
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
Xbit_r64_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_64 wl_1_64 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r65_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_65 wl_1_65 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r66_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r67_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r68_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r69_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r70_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r71_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r72_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r73_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r74_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r75_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r76_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r77_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r78_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r79_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r80_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r81_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r82_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r83_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r84_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r85_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r86_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r87_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r88_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r89_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r90_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r91_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r92_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r93_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r94_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r95_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r96_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r97_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r98_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r99_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r100_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r101_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r102_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r103_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r104_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r105_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r106_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r107_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r108_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r109_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r110_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r111_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r112_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r113_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r114_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r115_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r116_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r117_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r118_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r119_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r120_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r121_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r122_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r123_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r124_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r125_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r126_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell
Xbit_r127_c15 bl_0_15 br_0_15 bl_1_15 br_1_15 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell
.ENDS bitcell_array_0

.SUBCKT dummy_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 vdd gnd
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
.ENDS dummy_array_0

.SUBCKT replica_bitcell_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
* rbl: [1, 1] left_rbl: [] right_rbl: []
Xbitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 vdd gnd bitcell_array_0
Xdummy_row_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 gnd vdd gnd dummy_array_0
Xdummy_row_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 gnd rbl_wl_1_1 vdd gnd dummy_array_0
.ENDS replica_bitcell_array_0

.SUBCKT local_bitcell_array_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_wl_0_0:I wl_0_0:I wl_0_1:I wl_0_2:I wl_0_3:I wl_0_4:I wl_0_5:I wl_0_6:I wl_0_7:I wl_0_8:I wl_0_9:I wl_0_10:I wl_0_11:I wl_0_12:I wl_0_13:I wl_0_14:I wl_0_15:I wl_0_16:I wl_0_17:I wl_0_18:I wl_0_19:I wl_0_20:I wl_0_21:I wl_0_22:I wl_0_23:I wl_0_24:I wl_0_25:I wl_0_26:I wl_0_27:I wl_0_28:I wl_0_29:I wl_0_30:I wl_0_31:I wl_0_32:I wl_0_33:I wl_0_34:I wl_0_35:I wl_0_36:I wl_0_37:I wl_0_38:I wl_0_39:I wl_0_40:I wl_0_41:I wl_0_42:I wl_0_43:I wl_0_44:I wl_0_45:I wl_0_46:I wl_0_47:I wl_0_48:I wl_0_49:I wl_0_50:I wl_0_51:I wl_0_52:I wl_0_53:I wl_0_54:I wl_0_55:I wl_0_56:I wl_0_57:I wl_0_58:I wl_0_59:I wl_0_60:I wl_0_61:I wl_0_62:I wl_0_63:I wl_0_64:I wl_0_65:I wl_0_66:I wl_0_67:I wl_0_68:I wl_0_69:I wl_0_70:I wl_0_71:I wl_0_72:I wl_0_73:I wl_0_74:I wl_0_75:I wl_0_76:I wl_0_77:I wl_0_78:I wl_0_79:I wl_0_80:I wl_0_81:I wl_0_82:I wl_0_83:I wl_0_84:I wl_0_85:I wl_0_86:I wl_0_87:I wl_0_88:I wl_0_89:I wl_0_90:I wl_0_91:I wl_0_92:I wl_0_93:I wl_0_94:I wl_0_95:I wl_0_96:I wl_0_97:I wl_0_98:I wl_0_99:I wl_0_100:I wl_0_101:I wl_0_102:I wl_0_103:I wl_0_104:I wl_0_105:I wl_0_106:I wl_0_107:I wl_0_108:I wl_0_109:I wl_0_110:I wl_0_111:I wl_0_112:I wl_0_113:I wl_0_114:I wl_0_115:I wl_0_116:I wl_0_117:I wl_0_118:I wl_0_119:I wl_0_120:I wl_0_121:I wl_0_122:I wl_0_123:I wl_0_124:I wl_0_125:I wl_0_126:I wl_0_127:I wl_1_0:I wl_1_1:I wl_1_2:I wl_1_3:I wl_1_4:I wl_1_5:I wl_1_6:I wl_1_7:I wl_1_8:I wl_1_9:I wl_1_10:I wl_1_11:I wl_1_12:I wl_1_13:I wl_1_14:I wl_1_15:I wl_1_16:I wl_1_17:I wl_1_18:I wl_1_19:I wl_1_20:I wl_1_21:I wl_1_22:I wl_1_23:I wl_1_24:I wl_1_25:I wl_1_26:I wl_1_27:I wl_1_28:I wl_1_29:I wl_1_30:I wl_1_31:I wl_1_32:I wl_1_33:I wl_1_34:I wl_1_35:I wl_1_36:I wl_1_37:I wl_1_38:I wl_1_39:I wl_1_40:I wl_1_41:I wl_1_42:I wl_1_43:I wl_1_44:I wl_1_45:I wl_1_46:I wl_1_47:I wl_1_48:I wl_1_49:I wl_1_50:I wl_1_51:I wl_1_52:I wl_1_53:I wl_1_54:I wl_1_55:I wl_1_56:I wl_1_57:I wl_1_58:I wl_1_59:I wl_1_60:I wl_1_61:I wl_1_62:I wl_1_63:I wl_1_64:I wl_1_65:I wl_1_66:I wl_1_67:I wl_1_68:I wl_1_69:I wl_1_70:I wl_1_71:I wl_1_72:I wl_1_73:I wl_1_74:I wl_1_75:I wl_1_76:I wl_1_77:I wl_1_78:I wl_1_79:I wl_1_80:I wl_1_81:I wl_1_82:I wl_1_83:I wl_1_84:I wl_1_85:I wl_1_86:I wl_1_87:I wl_1_88:I wl_1_89:I wl_1_90:I wl_1_91:I wl_1_92:I wl_1_93:I wl_1_94:I wl_1_95:I wl_1_96:I wl_1_97:I wl_1_98:I wl_1_99:I wl_1_100:I wl_1_101:I wl_1_102:I wl_1_103:I wl_1_104:I wl_1_105:I wl_1_106:I wl_1_107:I wl_1_108:I wl_1_109:I wl_1_110:I wl_1_111:I wl_1_112:I wl_1_113:I wl_1_114:I wl_1_115:I wl_1_116:I wl_1_117:I wl_1_118:I wl_1_119:I wl_1_120:I wl_1_121:I wl_1_122:I wl_1_123:I wl_1_124:I wl_1_125:I wl_1_126:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_0_65 
* INPUT : wl_0_66 
* INPUT : wl_0_67 
* INPUT : wl_0_68 
* INPUT : wl_0_69 
* INPUT : wl_0_70 
* INPUT : wl_0_71 
* INPUT : wl_0_72 
* INPUT : wl_0_73 
* INPUT : wl_0_74 
* INPUT : wl_0_75 
* INPUT : wl_0_76 
* INPUT : wl_0_77 
* INPUT : wl_0_78 
* INPUT : wl_0_79 
* INPUT : wl_0_80 
* INPUT : wl_0_81 
* INPUT : wl_0_82 
* INPUT : wl_0_83 
* INPUT : wl_0_84 
* INPUT : wl_0_85 
* INPUT : wl_0_86 
* INPUT : wl_0_87 
* INPUT : wl_0_88 
* INPUT : wl_0_89 
* INPUT : wl_0_90 
* INPUT : wl_0_91 
* INPUT : wl_0_92 
* INPUT : wl_0_93 
* INPUT : wl_0_94 
* INPUT : wl_0_95 
* INPUT : wl_0_96 
* INPUT : wl_0_97 
* INPUT : wl_0_98 
* INPUT : wl_0_99 
* INPUT : wl_0_100 
* INPUT : wl_0_101 
* INPUT : wl_0_102 
* INPUT : wl_0_103 
* INPUT : wl_0_104 
* INPUT : wl_0_105 
* INPUT : wl_0_106 
* INPUT : wl_0_107 
* INPUT : wl_0_108 
* INPUT : wl_0_109 
* INPUT : wl_0_110 
* INPUT : wl_0_111 
* INPUT : wl_0_112 
* INPUT : wl_0_113 
* INPUT : wl_0_114 
* INPUT : wl_0_115 
* INPUT : wl_0_116 
* INPUT : wl_0_117 
* INPUT : wl_0_118 
* INPUT : wl_0_119 
* INPUT : wl_0_120 
* INPUT : wl_0_121 
* INPUT : wl_0_122 
* INPUT : wl_0_123 
* INPUT : wl_0_124 
* INPUT : wl_0_125 
* INPUT : wl_0_126 
* INPUT : wl_0_127 
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
* INPUT : wl_1_64 
* INPUT : wl_1_65 
* INPUT : wl_1_66 
* INPUT : wl_1_67 
* INPUT : wl_1_68 
* INPUT : wl_1_69 
* INPUT : wl_1_70 
* INPUT : wl_1_71 
* INPUT : wl_1_72 
* INPUT : wl_1_73 
* INPUT : wl_1_74 
* INPUT : wl_1_75 
* INPUT : wl_1_76 
* INPUT : wl_1_77 
* INPUT : wl_1_78 
* INPUT : wl_1_79 
* INPUT : wl_1_80 
* INPUT : wl_1_81 
* INPUT : wl_1_82 
* INPUT : wl_1_83 
* INPUT : wl_1_84 
* INPUT : wl_1_85 
* INPUT : wl_1_86 
* INPUT : wl_1_87 
* INPUT : wl_1_88 
* INPUT : wl_1_89 
* INPUT : wl_1_90 
* INPUT : wl_1_91 
* INPUT : wl_1_92 
* INPUT : wl_1_93 
* INPUT : wl_1_94 
* INPUT : wl_1_95 
* INPUT : wl_1_96 
* INPUT : wl_1_97 
* INPUT : wl_1_98 
* INPUT : wl_1_99 
* INPUT : wl_1_100 
* INPUT : wl_1_101 
* INPUT : wl_1_102 
* INPUT : wl_1_103 
* INPUT : wl_1_104 
* INPUT : wl_1_105 
* INPUT : wl_1_106 
* INPUT : wl_1_107 
* INPUT : wl_1_108 
* INPUT : wl_1_109 
* INPUT : wl_1_110 
* INPUT : wl_1_111 
* INPUT : wl_1_112 
* INPUT : wl_1_113 
* INPUT : wl_1_114 
* INPUT : wl_1_115 
* INPUT : wl_1_116 
* INPUT : wl_1_117 
* INPUT : wl_1_118 
* INPUT : wl_1_119 
* INPUT : wl_1_120 
* INPUT : wl_1_121 
* INPUT : wl_1_122 
* INPUT : wl_1_123 
* INPUT : wl_1_124 
* INPUT : wl_1_125 
* INPUT : wl_1_126 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xwl_driver0 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 rbl_wl_0_0i wl_0_0i wl_0_1i wl_0_2i wl_0_3i wl_0_4i wl_0_5i wl_0_6i wl_0_7i wl_0_8i wl_0_9i wl_0_10i wl_0_11i wl_0_12i wl_0_13i wl_0_14i wl_0_15i wl_0_16i wl_0_17i wl_0_18i wl_0_19i wl_0_20i wl_0_21i wl_0_22i wl_0_23i wl_0_24i wl_0_25i wl_0_26i wl_0_27i wl_0_28i wl_0_29i wl_0_30i wl_0_31i wl_0_32i wl_0_33i wl_0_34i wl_0_35i wl_0_36i wl_0_37i wl_0_38i wl_0_39i wl_0_40i wl_0_41i wl_0_42i wl_0_43i wl_0_44i wl_0_45i wl_0_46i wl_0_47i wl_0_48i wl_0_49i wl_0_50i wl_0_51i wl_0_52i wl_0_53i wl_0_54i wl_0_55i wl_0_56i wl_0_57i wl_0_58i wl_0_59i wl_0_60i wl_0_61i wl_0_62i wl_0_63i wl_0_64i wl_0_65i wl_0_66i wl_0_67i wl_0_68i wl_0_69i wl_0_70i wl_0_71i wl_0_72i wl_0_73i wl_0_74i wl_0_75i wl_0_76i wl_0_77i wl_0_78i wl_0_79i wl_0_80i wl_0_81i wl_0_82i wl_0_83i wl_0_84i wl_0_85i wl_0_86i wl_0_87i wl_0_88i wl_0_89i wl_0_90i wl_0_91i wl_0_92i wl_0_93i wl_0_94i wl_0_95i wl_0_96i wl_0_97i wl_0_98i wl_0_99i wl_0_100i wl_0_101i wl_0_102i wl_0_103i wl_0_104i wl_0_105i wl_0_106i wl_0_107i wl_0_108i wl_0_109i wl_0_110i wl_0_111i wl_0_112i wl_0_113i wl_0_114i wl_0_115i wl_0_116i wl_0_117i wl_0_118i wl_0_119i wl_0_120i wl_0_121i wl_0_122i wl_0_123i wl_0_124i wl_0_125i wl_0_126i wl_0_127i vdd gnd wordline_buffer_array
Xwl_driver1 rbl_wl_1_1 wl_1_127 wl_1_126 wl_1_125 wl_1_124 wl_1_123 wl_1_122 wl_1_121 wl_1_120 wl_1_119 wl_1_118 wl_1_117 wl_1_116 wl_1_115 wl_1_114 wl_1_113 wl_1_112 wl_1_111 wl_1_110 wl_1_109 wl_1_108 wl_1_107 wl_1_106 wl_1_105 wl_1_104 wl_1_103 wl_1_102 wl_1_101 wl_1_100 wl_1_99 wl_1_98 wl_1_97 wl_1_96 wl_1_95 wl_1_94 wl_1_93 wl_1_92 wl_1_91 wl_1_90 wl_1_89 wl_1_88 wl_1_87 wl_1_86 wl_1_85 wl_1_84 wl_1_83 wl_1_82 wl_1_81 wl_1_80 wl_1_79 wl_1_78 wl_1_77 wl_1_76 wl_1_75 wl_1_74 wl_1_73 wl_1_72 wl_1_71 wl_1_70 wl_1_69 wl_1_68 wl_1_67 wl_1_66 wl_1_65 wl_1_64 wl_1_63 wl_1_62 wl_1_61 wl_1_60 wl_1_59 wl_1_58 wl_1_57 wl_1_56 wl_1_55 wl_1_54 wl_1_53 wl_1_52 wl_1_51 wl_1_50 wl_1_49 wl_1_48 wl_1_47 wl_1_46 wl_1_45 wl_1_44 wl_1_43 wl_1_42 wl_1_41 wl_1_40 wl_1_39 wl_1_38 wl_1_37 wl_1_36 wl_1_35 wl_1_34 wl_1_33 wl_1_32 wl_1_31 wl_1_30 wl_1_29 wl_1_28 wl_1_27 wl_1_26 wl_1_25 wl_1_24 wl_1_23 wl_1_22 wl_1_21 wl_1_20 wl_1_19 wl_1_18 wl_1_17 wl_1_16 wl_1_15 wl_1_14 wl_1_13 wl_1_12 wl_1_11 wl_1_10 wl_1_9 wl_1_8 wl_1_7 wl_1_6 wl_1_5 wl_1_4 wl_1_3 wl_1_2 wl_1_1 wl_1_0 rbl_wl_1_1i wl_1_127i wl_1_126i wl_1_125i wl_1_124i wl_1_123i wl_1_122i wl_1_121i wl_1_120i wl_1_119i wl_1_118i wl_1_117i wl_1_116i wl_1_115i wl_1_114i wl_1_113i wl_1_112i wl_1_111i wl_1_110i wl_1_109i wl_1_108i wl_1_107i wl_1_106i wl_1_105i wl_1_104i wl_1_103i wl_1_102i wl_1_101i wl_1_100i wl_1_99i wl_1_98i wl_1_97i wl_1_96i wl_1_95i wl_1_94i wl_1_93i wl_1_92i wl_1_91i wl_1_90i wl_1_89i wl_1_88i wl_1_87i wl_1_86i wl_1_85i wl_1_84i wl_1_83i wl_1_82i wl_1_81i wl_1_80i wl_1_79i wl_1_78i wl_1_77i wl_1_76i wl_1_75i wl_1_74i wl_1_73i wl_1_72i wl_1_71i wl_1_70i wl_1_69i wl_1_68i wl_1_67i wl_1_66i wl_1_65i wl_1_64i wl_1_63i wl_1_62i wl_1_61i wl_1_60i wl_1_59i wl_1_58i wl_1_57i wl_1_56i wl_1_55i wl_1_54i wl_1_53i wl_1_52i wl_1_51i wl_1_50i wl_1_49i wl_1_48i wl_1_47i wl_1_46i wl_1_45i wl_1_44i wl_1_43i wl_1_42i wl_1_41i wl_1_40i wl_1_39i wl_1_38i wl_1_37i wl_1_36i wl_1_35i wl_1_34i wl_1_33i wl_1_32i wl_1_31i wl_1_30i wl_1_29i wl_1_28i wl_1_27i wl_1_26i wl_1_25i wl_1_24i wl_1_23i wl_1_22i wl_1_21i wl_1_20i wl_1_19i wl_1_18i wl_1_17i wl_1_16i wl_1_15i wl_1_14i wl_1_13i wl_1_12i wl_1_11i wl_1_10i wl_1_9i wl_1_8i wl_1_7i wl_1_6i wl_1_5i wl_1_4i wl_1_3i wl_1_2i wl_1_1i wl_1_0i vdd gnd wordline_buffer_array
Xarray bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0i wl_0_0i wl_1_0i wl_0_1i wl_1_1i wl_0_2i wl_1_2i wl_0_3i wl_1_3i wl_0_4i wl_1_4i wl_0_5i wl_1_5i wl_0_6i wl_1_6i wl_0_7i wl_1_7i wl_0_8i wl_1_8i wl_0_9i wl_1_9i wl_0_10i wl_1_10i wl_0_11i wl_1_11i wl_0_12i wl_1_12i wl_0_13i wl_1_13i wl_0_14i wl_1_14i wl_0_15i wl_1_15i wl_0_16i wl_1_16i wl_0_17i wl_1_17i wl_0_18i wl_1_18i wl_0_19i wl_1_19i wl_0_20i wl_1_20i wl_0_21i wl_1_21i wl_0_22i wl_1_22i wl_0_23i wl_1_23i wl_0_24i wl_1_24i wl_0_25i wl_1_25i wl_0_26i wl_1_26i wl_0_27i wl_1_27i wl_0_28i wl_1_28i wl_0_29i wl_1_29i wl_0_30i wl_1_30i wl_0_31i wl_1_31i wl_0_32i wl_1_32i wl_0_33i wl_1_33i wl_0_34i wl_1_34i wl_0_35i wl_1_35i wl_0_36i wl_1_36i wl_0_37i wl_1_37i wl_0_38i wl_1_38i wl_0_39i wl_1_39i wl_0_40i wl_1_40i wl_0_41i wl_1_41i wl_0_42i wl_1_42i wl_0_43i wl_1_43i wl_0_44i wl_1_44i wl_0_45i wl_1_45i wl_0_46i wl_1_46i wl_0_47i wl_1_47i wl_0_48i wl_1_48i wl_0_49i wl_1_49i wl_0_50i wl_1_50i wl_0_51i wl_1_51i wl_0_52i wl_1_52i wl_0_53i wl_1_53i wl_0_54i wl_1_54i wl_0_55i wl_1_55i wl_0_56i wl_1_56i wl_0_57i wl_1_57i wl_0_58i wl_1_58i wl_0_59i wl_1_59i wl_0_60i wl_1_60i wl_0_61i wl_1_61i wl_0_62i wl_1_62i wl_0_63i wl_1_63i wl_0_64i wl_1_64i wl_0_65i wl_1_65i wl_0_66i wl_1_66i wl_0_67i wl_1_67i wl_0_68i wl_1_68i wl_0_69i wl_1_69i wl_0_70i wl_1_70i wl_0_71i wl_1_71i wl_0_72i wl_1_72i wl_0_73i wl_1_73i wl_0_74i wl_1_74i wl_0_75i wl_1_75i wl_0_76i wl_1_76i wl_0_77i wl_1_77i wl_0_78i wl_1_78i wl_0_79i wl_1_79i wl_0_80i wl_1_80i wl_0_81i wl_1_81i wl_0_82i wl_1_82i wl_0_83i wl_1_83i wl_0_84i wl_1_84i wl_0_85i wl_1_85i wl_0_86i wl_1_86i wl_0_87i wl_1_87i wl_0_88i wl_1_88i wl_0_89i wl_1_89i wl_0_90i wl_1_90i wl_0_91i wl_1_91i wl_0_92i wl_1_92i wl_0_93i wl_1_93i wl_0_94i wl_1_94i wl_0_95i wl_1_95i wl_0_96i wl_1_96i wl_0_97i wl_1_97i wl_0_98i wl_1_98i wl_0_99i wl_1_99i wl_0_100i wl_1_100i wl_0_101i wl_1_101i wl_0_102i wl_1_102i wl_0_103i wl_1_103i wl_0_104i wl_1_104i wl_0_105i wl_1_105i wl_0_106i wl_1_106i wl_0_107i wl_1_107i wl_0_108i wl_1_108i wl_0_109i wl_1_109i wl_0_110i wl_1_110i wl_0_111i wl_1_111i wl_0_112i wl_1_112i wl_0_113i wl_1_113i wl_0_114i wl_1_114i wl_0_115i wl_1_115i wl_0_116i wl_1_116i wl_0_117i wl_1_117i wl_0_118i wl_1_118i wl_0_119i wl_1_119i wl_0_120i wl_1_120i wl_0_121i wl_1_121i wl_0_122i wl_1_122i wl_0_123i wl_1_123i wl_0_124i wl_1_124i wl_0_125i wl_1_125i wl_0_126i wl_1_126i wl_0_127i wl_1_127i rbl_wl_1_1i vdd gnd replica_bitcell_array_0
.ENDS local_bitcell_array_0

.SUBCKT replica_column_0 bl_0_0 bl_1_0 br_0_0 br_1_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 wl_0_128 wl_1_128 wl_0_129 wl_1_129 vdd gnd
*.PININFO bl_0_0:O bl_1_0:O br_0_0:O br_1_0:O wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I wl_0_128:I wl_1_128:I wl_0_129:I wl_1_129:I vdd:B gnd:B
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
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* INPUT : wl_0_128 
* INPUT : wl_1_128 
* INPUT : wl_0_129 
* INPUT : wl_1_129 
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
Xrbc_67 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_66 wl_1_66 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_68 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_67 wl_1_67 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_69 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_68 wl_1_68 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_70 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_69 wl_1_69 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_71 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_70 wl_1_70 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_72 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_71 wl_1_71 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_73 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_72 wl_1_72 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_74 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_73 wl_1_73 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_75 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_74 wl_1_74 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_76 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_75 wl_1_75 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_77 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_76 wl_1_76 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_78 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_77 wl_1_77 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_79 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_78 wl_1_78 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_80 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_79 wl_1_79 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_81 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_80 wl_1_80 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_82 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_81 wl_1_81 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_83 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_82 wl_1_82 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_84 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_83 wl_1_83 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_85 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_84 wl_1_84 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_86 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_85 wl_1_85 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_87 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_86 wl_1_86 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_88 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_87 wl_1_87 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_89 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_88 wl_1_88 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_90 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_89 wl_1_89 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_91 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_90 wl_1_90 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_92 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_91 wl_1_91 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_93 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_92 wl_1_92 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_94 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_93 wl_1_93 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_95 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_94 wl_1_94 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_96 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_95 wl_1_95 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_97 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_96 wl_1_96 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_98 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_97 wl_1_97 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_99 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_98 wl_1_98 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_100 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_99 wl_1_99 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_101 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_100 wl_1_100 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_102 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_101 wl_1_101 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_103 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_102 wl_1_102 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_104 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_103 wl_1_103 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_105 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_104 wl_1_104 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_106 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_105 wl_1_105 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_107 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_106 wl_1_106 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_108 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_107 wl_1_107 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_109 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_108 wl_1_108 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_110 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_109 wl_1_109 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_111 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_110 wl_1_110 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_112 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_111 wl_1_111 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_113 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_112 wl_1_112 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_114 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_113 wl_1_113 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_115 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_114 wl_1_114 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_116 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_115 wl_1_115 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_117 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_116 wl_1_116 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_118 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_117 wl_1_117 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_119 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_118 wl_1_118 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_120 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_119 wl_1_119 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_121 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_120 wl_1_120 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_122 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_121 wl_1_121 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_123 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_122 wl_1_122 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_124 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_123 wl_1_123 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_125 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_124 wl_1_124 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_126 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_125 wl_1_125 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_127 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_126 wl_1_126 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_128 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_127 wl_1_127 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_129 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_128 wl_1_128 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
Xrbc_130 bl_0_0 br_0_0 bl_1_0 br_1_0 wl_0_129 wl_1_129 vdd gnd sky130_fd_bd_sram__openram_dp_cell_replica
.ENDS replica_column_0

.SUBCKT replica_bitcell_array_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_bl_0_1:B rbl_bl_1_1:B rbl_br_0_1:B rbl_br_1_1:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
* rbl: [1, 1] left_rbl: [] right_rbl: [1]
Xbitcell_array bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 vdd gnd bitcell_array_0
Xreplica_col_1 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 gnd wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 gnd rbl_wl_1_1 vdd gnd replica_column_0
Xdummy_row_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 gnd vdd gnd dummy_array_0
Xdummy_row_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 gnd rbl_wl_1_1 vdd gnd dummy_array_0
.ENDS replica_bitcell_array_1

.SUBCKT local_bitcell_array_1 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B rbl_bl_0_1:B rbl_bl_1_1:B rbl_br_0_1:B rbl_br_1_1:B rbl_wl_0_0:I wl_0_0:I wl_0_1:I wl_0_2:I wl_0_3:I wl_0_4:I wl_0_5:I wl_0_6:I wl_0_7:I wl_0_8:I wl_0_9:I wl_0_10:I wl_0_11:I wl_0_12:I wl_0_13:I wl_0_14:I wl_0_15:I wl_0_16:I wl_0_17:I wl_0_18:I wl_0_19:I wl_0_20:I wl_0_21:I wl_0_22:I wl_0_23:I wl_0_24:I wl_0_25:I wl_0_26:I wl_0_27:I wl_0_28:I wl_0_29:I wl_0_30:I wl_0_31:I wl_0_32:I wl_0_33:I wl_0_34:I wl_0_35:I wl_0_36:I wl_0_37:I wl_0_38:I wl_0_39:I wl_0_40:I wl_0_41:I wl_0_42:I wl_0_43:I wl_0_44:I wl_0_45:I wl_0_46:I wl_0_47:I wl_0_48:I wl_0_49:I wl_0_50:I wl_0_51:I wl_0_52:I wl_0_53:I wl_0_54:I wl_0_55:I wl_0_56:I wl_0_57:I wl_0_58:I wl_0_59:I wl_0_60:I wl_0_61:I wl_0_62:I wl_0_63:I wl_0_64:I wl_0_65:I wl_0_66:I wl_0_67:I wl_0_68:I wl_0_69:I wl_0_70:I wl_0_71:I wl_0_72:I wl_0_73:I wl_0_74:I wl_0_75:I wl_0_76:I wl_0_77:I wl_0_78:I wl_0_79:I wl_0_80:I wl_0_81:I wl_0_82:I wl_0_83:I wl_0_84:I wl_0_85:I wl_0_86:I wl_0_87:I wl_0_88:I wl_0_89:I wl_0_90:I wl_0_91:I wl_0_92:I wl_0_93:I wl_0_94:I wl_0_95:I wl_0_96:I wl_0_97:I wl_0_98:I wl_0_99:I wl_0_100:I wl_0_101:I wl_0_102:I wl_0_103:I wl_0_104:I wl_0_105:I wl_0_106:I wl_0_107:I wl_0_108:I wl_0_109:I wl_0_110:I wl_0_111:I wl_0_112:I wl_0_113:I wl_0_114:I wl_0_115:I wl_0_116:I wl_0_117:I wl_0_118:I wl_0_119:I wl_0_120:I wl_0_121:I wl_0_122:I wl_0_123:I wl_0_124:I wl_0_125:I wl_0_126:I wl_0_127:I wl_1_0:I wl_1_1:I wl_1_2:I wl_1_3:I wl_1_4:I wl_1_5:I wl_1_6:I wl_1_7:I wl_1_8:I wl_1_9:I wl_1_10:I wl_1_11:I wl_1_12:I wl_1_13:I wl_1_14:I wl_1_15:I wl_1_16:I wl_1_17:I wl_1_18:I wl_1_19:I wl_1_20:I wl_1_21:I wl_1_22:I wl_1_23:I wl_1_24:I wl_1_25:I wl_1_26:I wl_1_27:I wl_1_28:I wl_1_29:I wl_1_30:I wl_1_31:I wl_1_32:I wl_1_33:I wl_1_34:I wl_1_35:I wl_1_36:I wl_1_37:I wl_1_38:I wl_1_39:I wl_1_40:I wl_1_41:I wl_1_42:I wl_1_43:I wl_1_44:I wl_1_45:I wl_1_46:I wl_1_47:I wl_1_48:I wl_1_49:I wl_1_50:I wl_1_51:I wl_1_52:I wl_1_53:I wl_1_54:I wl_1_55:I wl_1_56:I wl_1_57:I wl_1_58:I wl_1_59:I wl_1_60:I wl_1_61:I wl_1_62:I wl_1_63:I wl_1_64:I wl_1_65:I wl_1_66:I wl_1_67:I wl_1_68:I wl_1_69:I wl_1_70:I wl_1_71:I wl_1_72:I wl_1_73:I wl_1_74:I wl_1_75:I wl_1_76:I wl_1_77:I wl_1_78:I wl_1_79:I wl_1_80:I wl_1_81:I wl_1_82:I wl_1_83:I wl_1_84:I wl_1_85:I wl_1_86:I wl_1_87:I wl_1_88:I wl_1_89:I wl_1_90:I wl_1_91:I wl_1_92:I wl_1_93:I wl_1_94:I wl_1_95:I wl_1_96:I wl_1_97:I wl_1_98:I wl_1_99:I wl_1_100:I wl_1_101:I wl_1_102:I wl_1_103:I wl_1_104:I wl_1_105:I wl_1_106:I wl_1_107:I wl_1_108:I wl_1_109:I wl_1_110:I wl_1_111:I wl_1_112:I wl_1_113:I wl_1_114:I wl_1_115:I wl_1_116:I wl_1_117:I wl_1_118:I wl_1_119:I wl_1_120:I wl_1_121:I wl_1_122:I wl_1_123:I wl_1_124:I wl_1_125:I wl_1_126:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INPUT : wl_0_64 
* INPUT : wl_0_65 
* INPUT : wl_0_66 
* INPUT : wl_0_67 
* INPUT : wl_0_68 
* INPUT : wl_0_69 
* INPUT : wl_0_70 
* INPUT : wl_0_71 
* INPUT : wl_0_72 
* INPUT : wl_0_73 
* INPUT : wl_0_74 
* INPUT : wl_0_75 
* INPUT : wl_0_76 
* INPUT : wl_0_77 
* INPUT : wl_0_78 
* INPUT : wl_0_79 
* INPUT : wl_0_80 
* INPUT : wl_0_81 
* INPUT : wl_0_82 
* INPUT : wl_0_83 
* INPUT : wl_0_84 
* INPUT : wl_0_85 
* INPUT : wl_0_86 
* INPUT : wl_0_87 
* INPUT : wl_0_88 
* INPUT : wl_0_89 
* INPUT : wl_0_90 
* INPUT : wl_0_91 
* INPUT : wl_0_92 
* INPUT : wl_0_93 
* INPUT : wl_0_94 
* INPUT : wl_0_95 
* INPUT : wl_0_96 
* INPUT : wl_0_97 
* INPUT : wl_0_98 
* INPUT : wl_0_99 
* INPUT : wl_0_100 
* INPUT : wl_0_101 
* INPUT : wl_0_102 
* INPUT : wl_0_103 
* INPUT : wl_0_104 
* INPUT : wl_0_105 
* INPUT : wl_0_106 
* INPUT : wl_0_107 
* INPUT : wl_0_108 
* INPUT : wl_0_109 
* INPUT : wl_0_110 
* INPUT : wl_0_111 
* INPUT : wl_0_112 
* INPUT : wl_0_113 
* INPUT : wl_0_114 
* INPUT : wl_0_115 
* INPUT : wl_0_116 
* INPUT : wl_0_117 
* INPUT : wl_0_118 
* INPUT : wl_0_119 
* INPUT : wl_0_120 
* INPUT : wl_0_121 
* INPUT : wl_0_122 
* INPUT : wl_0_123 
* INPUT : wl_0_124 
* INPUT : wl_0_125 
* INPUT : wl_0_126 
* INPUT : wl_0_127 
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
* INPUT : wl_1_64 
* INPUT : wl_1_65 
* INPUT : wl_1_66 
* INPUT : wl_1_67 
* INPUT : wl_1_68 
* INPUT : wl_1_69 
* INPUT : wl_1_70 
* INPUT : wl_1_71 
* INPUT : wl_1_72 
* INPUT : wl_1_73 
* INPUT : wl_1_74 
* INPUT : wl_1_75 
* INPUT : wl_1_76 
* INPUT : wl_1_77 
* INPUT : wl_1_78 
* INPUT : wl_1_79 
* INPUT : wl_1_80 
* INPUT : wl_1_81 
* INPUT : wl_1_82 
* INPUT : wl_1_83 
* INPUT : wl_1_84 
* INPUT : wl_1_85 
* INPUT : wl_1_86 
* INPUT : wl_1_87 
* INPUT : wl_1_88 
* INPUT : wl_1_89 
* INPUT : wl_1_90 
* INPUT : wl_1_91 
* INPUT : wl_1_92 
* INPUT : wl_1_93 
* INPUT : wl_1_94 
* INPUT : wl_1_95 
* INPUT : wl_1_96 
* INPUT : wl_1_97 
* INPUT : wl_1_98 
* INPUT : wl_1_99 
* INPUT : wl_1_100 
* INPUT : wl_1_101 
* INPUT : wl_1_102 
* INPUT : wl_1_103 
* INPUT : wl_1_104 
* INPUT : wl_1_105 
* INPUT : wl_1_106 
* INPUT : wl_1_107 
* INPUT : wl_1_108 
* INPUT : wl_1_109 
* INPUT : wl_1_110 
* INPUT : wl_1_111 
* INPUT : wl_1_112 
* INPUT : wl_1_113 
* INPUT : wl_1_114 
* INPUT : wl_1_115 
* INPUT : wl_1_116 
* INPUT : wl_1_117 
* INPUT : wl_1_118 
* INPUT : wl_1_119 
* INPUT : wl_1_120 
* INPUT : wl_1_121 
* INPUT : wl_1_122 
* INPUT : wl_1_123 
* INPUT : wl_1_124 
* INPUT : wl_1_125 
* INPUT : wl_1_126 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xwl_driver0 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 rbl_wl_0_0i wl_0_0i wl_0_1i wl_0_2i wl_0_3i wl_0_4i wl_0_5i wl_0_6i wl_0_7i wl_0_8i wl_0_9i wl_0_10i wl_0_11i wl_0_12i wl_0_13i wl_0_14i wl_0_15i wl_0_16i wl_0_17i wl_0_18i wl_0_19i wl_0_20i wl_0_21i wl_0_22i wl_0_23i wl_0_24i wl_0_25i wl_0_26i wl_0_27i wl_0_28i wl_0_29i wl_0_30i wl_0_31i wl_0_32i wl_0_33i wl_0_34i wl_0_35i wl_0_36i wl_0_37i wl_0_38i wl_0_39i wl_0_40i wl_0_41i wl_0_42i wl_0_43i wl_0_44i wl_0_45i wl_0_46i wl_0_47i wl_0_48i wl_0_49i wl_0_50i wl_0_51i wl_0_52i wl_0_53i wl_0_54i wl_0_55i wl_0_56i wl_0_57i wl_0_58i wl_0_59i wl_0_60i wl_0_61i wl_0_62i wl_0_63i wl_0_64i wl_0_65i wl_0_66i wl_0_67i wl_0_68i wl_0_69i wl_0_70i wl_0_71i wl_0_72i wl_0_73i wl_0_74i wl_0_75i wl_0_76i wl_0_77i wl_0_78i wl_0_79i wl_0_80i wl_0_81i wl_0_82i wl_0_83i wl_0_84i wl_0_85i wl_0_86i wl_0_87i wl_0_88i wl_0_89i wl_0_90i wl_0_91i wl_0_92i wl_0_93i wl_0_94i wl_0_95i wl_0_96i wl_0_97i wl_0_98i wl_0_99i wl_0_100i wl_0_101i wl_0_102i wl_0_103i wl_0_104i wl_0_105i wl_0_106i wl_0_107i wl_0_108i wl_0_109i wl_0_110i wl_0_111i wl_0_112i wl_0_113i wl_0_114i wl_0_115i wl_0_116i wl_0_117i wl_0_118i wl_0_119i wl_0_120i wl_0_121i wl_0_122i wl_0_123i wl_0_124i wl_0_125i wl_0_126i wl_0_127i vdd gnd wordline_buffer_array
Xwl_driver1 rbl_wl_1_1 wl_1_127 wl_1_126 wl_1_125 wl_1_124 wl_1_123 wl_1_122 wl_1_121 wl_1_120 wl_1_119 wl_1_118 wl_1_117 wl_1_116 wl_1_115 wl_1_114 wl_1_113 wl_1_112 wl_1_111 wl_1_110 wl_1_109 wl_1_108 wl_1_107 wl_1_106 wl_1_105 wl_1_104 wl_1_103 wl_1_102 wl_1_101 wl_1_100 wl_1_99 wl_1_98 wl_1_97 wl_1_96 wl_1_95 wl_1_94 wl_1_93 wl_1_92 wl_1_91 wl_1_90 wl_1_89 wl_1_88 wl_1_87 wl_1_86 wl_1_85 wl_1_84 wl_1_83 wl_1_82 wl_1_81 wl_1_80 wl_1_79 wl_1_78 wl_1_77 wl_1_76 wl_1_75 wl_1_74 wl_1_73 wl_1_72 wl_1_71 wl_1_70 wl_1_69 wl_1_68 wl_1_67 wl_1_66 wl_1_65 wl_1_64 wl_1_63 wl_1_62 wl_1_61 wl_1_60 wl_1_59 wl_1_58 wl_1_57 wl_1_56 wl_1_55 wl_1_54 wl_1_53 wl_1_52 wl_1_51 wl_1_50 wl_1_49 wl_1_48 wl_1_47 wl_1_46 wl_1_45 wl_1_44 wl_1_43 wl_1_42 wl_1_41 wl_1_40 wl_1_39 wl_1_38 wl_1_37 wl_1_36 wl_1_35 wl_1_34 wl_1_33 wl_1_32 wl_1_31 wl_1_30 wl_1_29 wl_1_28 wl_1_27 wl_1_26 wl_1_25 wl_1_24 wl_1_23 wl_1_22 wl_1_21 wl_1_20 wl_1_19 wl_1_18 wl_1_17 wl_1_16 wl_1_15 wl_1_14 wl_1_13 wl_1_12 wl_1_11 wl_1_10 wl_1_9 wl_1_8 wl_1_7 wl_1_6 wl_1_5 wl_1_4 wl_1_3 wl_1_2 wl_1_1 wl_1_0 rbl_wl_1_1i wl_1_127i wl_1_126i wl_1_125i wl_1_124i wl_1_123i wl_1_122i wl_1_121i wl_1_120i wl_1_119i wl_1_118i wl_1_117i wl_1_116i wl_1_115i wl_1_114i wl_1_113i wl_1_112i wl_1_111i wl_1_110i wl_1_109i wl_1_108i wl_1_107i wl_1_106i wl_1_105i wl_1_104i wl_1_103i wl_1_102i wl_1_101i wl_1_100i wl_1_99i wl_1_98i wl_1_97i wl_1_96i wl_1_95i wl_1_94i wl_1_93i wl_1_92i wl_1_91i wl_1_90i wl_1_89i wl_1_88i wl_1_87i wl_1_86i wl_1_85i wl_1_84i wl_1_83i wl_1_82i wl_1_81i wl_1_80i wl_1_79i wl_1_78i wl_1_77i wl_1_76i wl_1_75i wl_1_74i wl_1_73i wl_1_72i wl_1_71i wl_1_70i wl_1_69i wl_1_68i wl_1_67i wl_1_66i wl_1_65i wl_1_64i wl_1_63i wl_1_62i wl_1_61i wl_1_60i wl_1_59i wl_1_58i wl_1_57i wl_1_56i wl_1_55i wl_1_54i wl_1_53i wl_1_52i wl_1_51i wl_1_50i wl_1_49i wl_1_48i wl_1_47i wl_1_46i wl_1_45i wl_1_44i wl_1_43i wl_1_42i wl_1_41i wl_1_40i wl_1_39i wl_1_38i wl_1_37i wl_1_36i wl_1_35i wl_1_34i wl_1_33i wl_1_32i wl_1_31i wl_1_30i wl_1_29i wl_1_28i wl_1_27i wl_1_26i wl_1_25i wl_1_24i wl_1_23i wl_1_22i wl_1_21i wl_1_20i wl_1_19i wl_1_18i wl_1_17i wl_1_16i wl_1_15i wl_1_14i wl_1_13i wl_1_12i wl_1_11i wl_1_10i wl_1_9i wl_1_8i wl_1_7i wl_1_6i wl_1_5i wl_1_4i wl_1_3i wl_1_2i wl_1_1i wl_1_0i vdd gnd wordline_buffer_array
Xarray bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0i wl_0_0i wl_1_0i wl_0_1i wl_1_1i wl_0_2i wl_1_2i wl_0_3i wl_1_3i wl_0_4i wl_1_4i wl_0_5i wl_1_5i wl_0_6i wl_1_6i wl_0_7i wl_1_7i wl_0_8i wl_1_8i wl_0_9i wl_1_9i wl_0_10i wl_1_10i wl_0_11i wl_1_11i wl_0_12i wl_1_12i wl_0_13i wl_1_13i wl_0_14i wl_1_14i wl_0_15i wl_1_15i wl_0_16i wl_1_16i wl_0_17i wl_1_17i wl_0_18i wl_1_18i wl_0_19i wl_1_19i wl_0_20i wl_1_20i wl_0_21i wl_1_21i wl_0_22i wl_1_22i wl_0_23i wl_1_23i wl_0_24i wl_1_24i wl_0_25i wl_1_25i wl_0_26i wl_1_26i wl_0_27i wl_1_27i wl_0_28i wl_1_28i wl_0_29i wl_1_29i wl_0_30i wl_1_30i wl_0_31i wl_1_31i wl_0_32i wl_1_32i wl_0_33i wl_1_33i wl_0_34i wl_1_34i wl_0_35i wl_1_35i wl_0_36i wl_1_36i wl_0_37i wl_1_37i wl_0_38i wl_1_38i wl_0_39i wl_1_39i wl_0_40i wl_1_40i wl_0_41i wl_1_41i wl_0_42i wl_1_42i wl_0_43i wl_1_43i wl_0_44i wl_1_44i wl_0_45i wl_1_45i wl_0_46i wl_1_46i wl_0_47i wl_1_47i wl_0_48i wl_1_48i wl_0_49i wl_1_49i wl_0_50i wl_1_50i wl_0_51i wl_1_51i wl_0_52i wl_1_52i wl_0_53i wl_1_53i wl_0_54i wl_1_54i wl_0_55i wl_1_55i wl_0_56i wl_1_56i wl_0_57i wl_1_57i wl_0_58i wl_1_58i wl_0_59i wl_1_59i wl_0_60i wl_1_60i wl_0_61i wl_1_61i wl_0_62i wl_1_62i wl_0_63i wl_1_63i wl_0_64i wl_1_64i wl_0_65i wl_1_65i wl_0_66i wl_1_66i wl_0_67i wl_1_67i wl_0_68i wl_1_68i wl_0_69i wl_1_69i wl_0_70i wl_1_70i wl_0_71i wl_1_71i wl_0_72i wl_1_72i wl_0_73i wl_1_73i wl_0_74i wl_1_74i wl_0_75i wl_1_75i wl_0_76i wl_1_76i wl_0_77i wl_1_77i wl_0_78i wl_1_78i wl_0_79i wl_1_79i wl_0_80i wl_1_80i wl_0_81i wl_1_81i wl_0_82i wl_1_82i wl_0_83i wl_1_83i wl_0_84i wl_1_84i wl_0_85i wl_1_85i wl_0_86i wl_1_86i wl_0_87i wl_1_87i wl_0_88i wl_1_88i wl_0_89i wl_1_89i wl_0_90i wl_1_90i wl_0_91i wl_1_91i wl_0_92i wl_1_92i wl_0_93i wl_1_93i wl_0_94i wl_1_94i wl_0_95i wl_1_95i wl_0_96i wl_1_96i wl_0_97i wl_1_97i wl_0_98i wl_1_98i wl_0_99i wl_1_99i wl_0_100i wl_1_100i wl_0_101i wl_1_101i wl_0_102i wl_1_102i wl_0_103i wl_1_103i wl_0_104i wl_1_104i wl_0_105i wl_1_105i wl_0_106i wl_1_106i wl_0_107i wl_1_107i wl_0_108i wl_1_108i wl_0_109i wl_1_109i wl_0_110i wl_1_110i wl_0_111i wl_1_111i wl_0_112i wl_1_112i wl_0_113i wl_1_113i wl_0_114i wl_1_114i wl_0_115i wl_1_115i wl_0_116i wl_1_116i wl_0_117i wl_1_117i wl_0_118i wl_1_118i wl_0_119i wl_1_119i wl_0_120i wl_1_120i wl_0_121i wl_1_121i wl_0_122i wl_1_122i wl_0_123i wl_1_123i wl_0_124i wl_1_124i wl_0_125i wl_1_125i wl_0_126i wl_1_126i wl_0_127i wl_1_127i rbl_wl_1_1i vdd gnd replica_bitcell_array_1
.ENDS local_bitcell_array_1

.SUBCKT global_bitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 bl_0_28 bl_1_28 br_0_28 br_1_28 bl_0_29 bl_1_29 br_0_29 br_1_29 bl_0_30 bl_1_30 br_0_30 br_1_30 bl_0_31 bl_1_31 br_0_31 br_1_31 bl_0_32 bl_1_32 br_0_32 br_1_32 bl_0_33 bl_1_33 br_0_33 br_1_33 bl_0_34 bl_1_34 br_0_34 br_1_34 bl_0_35 bl_1_35 br_0_35 br_1_35 bl_0_36 bl_1_36 br_0_36 br_1_36 bl_0_37 bl_1_37 br_0_37 br_1_37 bl_0_38 bl_1_38 br_0_38 br_1_38 bl_0_39 bl_1_39 br_0_39 br_1_39 bl_0_40 bl_1_40 br_0_40 br_1_40 bl_0_41 bl_1_41 br_0_41 br_1_41 bl_0_42 bl_1_42 br_0_42 br_1_42 bl_0_43 bl_1_43 br_0_43 br_1_43 bl_0_44 bl_1_44 br_0_44 br_1_44 bl_0_45 bl_1_45 br_0_45 br_1_45 bl_0_46 bl_1_46 br_0_46 br_1_46 bl_0_47 bl_1_47 br_0_47 br_1_47 bl_0_48 bl_1_48 br_0_48 br_1_48 bl_0_49 bl_1_49 br_0_49 br_1_49 bl_0_50 bl_1_50 br_0_50 br_1_50 bl_0_51 bl_1_51 br_0_51 br_1_51 bl_0_52 bl_1_52 br_0_52 br_1_52 bl_0_53 bl_1_53 br_0_53 br_1_53 bl_0_54 bl_1_54 br_0_54 br_1_54 bl_0_55 bl_1_55 br_0_55 br_1_55 bl_0_56 bl_1_56 br_0_56 br_1_56 bl_0_57 bl_1_57 br_0_57 br_1_57 bl_0_58 bl_1_58 br_0_58 br_1_58 bl_0_59 bl_1_59 br_0_59 br_1_59 bl_0_60 bl_1_60 br_0_60 br_1_60 bl_0_61 bl_1_61 br_0_61 br_1_61 bl_0_62 bl_1_62 br_0_62 br_1_62 bl_0_63 bl_1_63 br_0_63 br_1_63 bl_0_64 bl_1_64 br_0_64 br_1_64 bl_0_65 bl_1_65 br_0_65 br_1_65 bl_0_66 bl_1_66 br_0_66 br_1_66 bl_0_67 bl_1_67 br_0_67 br_1_67 bl_0_68 bl_1_68 br_0_68 br_1_68 bl_0_69 bl_1_69 br_0_69 br_1_69 bl_0_70 bl_1_70 br_0_70 br_1_70 bl_0_71 bl_1_71 br_0_71 br_1_71 bl_0_72 bl_1_72 br_0_72 br_1_72 bl_0_73 bl_1_73 br_0_73 br_1_73 bl_0_74 bl_1_74 br_0_74 br_1_74 bl_0_75 bl_1_75 br_0_75 br_1_75 bl_0_76 bl_1_76 br_0_76 br_1_76 bl_0_77 bl_1_77 br_0_77 br_1_77 bl_0_78 bl_1_78 br_0_78 br_1_78 bl_0_79 bl_1_79 br_0_79 br_1_79 bl_0_80 bl_1_80 br_0_80 br_1_80 bl_0_81 bl_1_81 br_0_81 br_1_81 bl_0_82 bl_1_82 br_0_82 br_1_82 bl_0_83 bl_1_83 br_0_83 br_1_83 bl_0_84 bl_1_84 br_0_84 br_1_84 bl_0_85 bl_1_85 br_0_85 br_1_85 bl_0_86 bl_1_86 br_0_86 br_1_86 bl_0_87 bl_1_87 br_0_87 br_1_87 bl_0_88 bl_1_88 br_0_88 br_1_88 bl_0_89 bl_1_89 br_0_89 br_1_89 bl_0_90 bl_1_90 br_0_90 br_1_90 bl_0_91 bl_1_91 br_0_91 br_1_91 bl_0_92 bl_1_92 br_0_92 br_1_92 bl_0_93 bl_1_93 br_0_93 br_1_93 bl_0_94 bl_1_94 br_0_94 br_1_94 bl_0_95 bl_1_95 br_0_95 br_1_95 bl_0_96 bl_1_96 br_0_96 br_1_96 bl_0_97 bl_1_97 br_0_97 br_1_97 bl_0_98 bl_1_98 br_0_98 br_1_98 bl_0_99 bl_1_99 br_0_99 br_1_99 bl_0_100 bl_1_100 br_0_100 br_1_100 bl_0_101 bl_1_101 br_0_101 br_1_101 bl_0_102 bl_1_102 br_0_102 br_1_102 bl_0_103 bl_1_103 br_0_103 br_1_103 bl_0_104 bl_1_104 br_0_104 br_1_104 bl_0_105 bl_1_105 br_0_105 br_1_105 bl_0_106 bl_1_106 br_0_106 br_1_106 bl_0_107 bl_1_107 br_0_107 br_1_107 bl_0_108 bl_1_108 br_0_108 br_1_108 bl_0_109 bl_1_109 br_0_109 br_1_109 bl_0_110 bl_1_110 br_0_110 br_1_110 bl_0_111 bl_1_111 br_0_111 br_1_111 bl_0_112 bl_1_112 br_0_112 br_1_112 bl_0_113 bl_1_113 br_0_113 br_1_113 bl_0_114 bl_1_114 br_0_114 br_1_114 bl_0_115 bl_1_115 br_0_115 br_1_115 bl_0_116 bl_1_116 br_0_116 br_1_116 bl_0_117 bl_1_117 br_0_117 br_1_117 bl_0_118 bl_1_118 br_0_118 br_1_118 bl_0_119 bl_1_119 br_0_119 br_1_119 bl_0_120 bl_1_120 br_0_120 br_1_120 bl_0_121 bl_1_121 br_0_121 br_1_121 bl_0_122 bl_1_122 br_0_122 br_1_122 bl_0_123 bl_1_123 br_0_123 br_1_123 bl_0_124 bl_1_124 br_0_124 br_1_124 bl_0_125 bl_1_125 br_0_125 br_1_125 bl_0_126 bl_1_126 br_0_126 br_1_126 bl_0_127 bl_1_127 br_0_127 br_1_127 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 rbl_wl_1_1 vdd gnd
*.PININFO rbl_bl_0_0:B rbl_bl_1_0:B rbl_br_0_0:B rbl_br_1_0:B bl_0_0:B bl_1_0:B br_0_0:B br_1_0:B bl_0_1:B bl_1_1:B br_0_1:B br_1_1:B bl_0_2:B bl_1_2:B br_0_2:B br_1_2:B bl_0_3:B bl_1_3:B br_0_3:B br_1_3:B bl_0_4:B bl_1_4:B br_0_4:B br_1_4:B bl_0_5:B bl_1_5:B br_0_5:B br_1_5:B bl_0_6:B bl_1_6:B br_0_6:B br_1_6:B bl_0_7:B bl_1_7:B br_0_7:B br_1_7:B bl_0_8:B bl_1_8:B br_0_8:B br_1_8:B bl_0_9:B bl_1_9:B br_0_9:B br_1_9:B bl_0_10:B bl_1_10:B br_0_10:B br_1_10:B bl_0_11:B bl_1_11:B br_0_11:B br_1_11:B bl_0_12:B bl_1_12:B br_0_12:B br_1_12:B bl_0_13:B bl_1_13:B br_0_13:B br_1_13:B bl_0_14:B bl_1_14:B br_0_14:B br_1_14:B bl_0_15:B bl_1_15:B br_0_15:B br_1_15:B bl_0_16:B bl_1_16:B br_0_16:B br_1_16:B bl_0_17:B bl_1_17:B br_0_17:B br_1_17:B bl_0_18:B bl_1_18:B br_0_18:B br_1_18:B bl_0_19:B bl_1_19:B br_0_19:B br_1_19:B bl_0_20:B bl_1_20:B br_0_20:B br_1_20:B bl_0_21:B bl_1_21:B br_0_21:B br_1_21:B bl_0_22:B bl_1_22:B br_0_22:B br_1_22:B bl_0_23:B bl_1_23:B br_0_23:B br_1_23:B bl_0_24:B bl_1_24:B br_0_24:B br_1_24:B bl_0_25:B bl_1_25:B br_0_25:B br_1_25:B bl_0_26:B bl_1_26:B br_0_26:B br_1_26:B bl_0_27:B bl_1_27:B br_0_27:B br_1_27:B bl_0_28:B bl_1_28:B br_0_28:B br_1_28:B bl_0_29:B bl_1_29:B br_0_29:B br_1_29:B bl_0_30:B bl_1_30:B br_0_30:B br_1_30:B bl_0_31:B bl_1_31:B br_0_31:B br_1_31:B bl_0_32:B bl_1_32:B br_0_32:B br_1_32:B bl_0_33:B bl_1_33:B br_0_33:B br_1_33:B bl_0_34:B bl_1_34:B br_0_34:B br_1_34:B bl_0_35:B bl_1_35:B br_0_35:B br_1_35:B bl_0_36:B bl_1_36:B br_0_36:B br_1_36:B bl_0_37:B bl_1_37:B br_0_37:B br_1_37:B bl_0_38:B bl_1_38:B br_0_38:B br_1_38:B bl_0_39:B bl_1_39:B br_0_39:B br_1_39:B bl_0_40:B bl_1_40:B br_0_40:B br_1_40:B bl_0_41:B bl_1_41:B br_0_41:B br_1_41:B bl_0_42:B bl_1_42:B br_0_42:B br_1_42:B bl_0_43:B bl_1_43:B br_0_43:B br_1_43:B bl_0_44:B bl_1_44:B br_0_44:B br_1_44:B bl_0_45:B bl_1_45:B br_0_45:B br_1_45:B bl_0_46:B bl_1_46:B br_0_46:B br_1_46:B bl_0_47:B bl_1_47:B br_0_47:B br_1_47:B bl_0_48:B bl_1_48:B br_0_48:B br_1_48:B bl_0_49:B bl_1_49:B br_0_49:B br_1_49:B bl_0_50:B bl_1_50:B br_0_50:B br_1_50:B bl_0_51:B bl_1_51:B br_0_51:B br_1_51:B bl_0_52:B bl_1_52:B br_0_52:B br_1_52:B bl_0_53:B bl_1_53:B br_0_53:B br_1_53:B bl_0_54:B bl_1_54:B br_0_54:B br_1_54:B bl_0_55:B bl_1_55:B br_0_55:B br_1_55:B bl_0_56:B bl_1_56:B br_0_56:B br_1_56:B bl_0_57:B bl_1_57:B br_0_57:B br_1_57:B bl_0_58:B bl_1_58:B br_0_58:B br_1_58:B bl_0_59:B bl_1_59:B br_0_59:B br_1_59:B bl_0_60:B bl_1_60:B br_0_60:B br_1_60:B bl_0_61:B bl_1_61:B br_0_61:B br_1_61:B bl_0_62:B bl_1_62:B br_0_62:B br_1_62:B bl_0_63:B bl_1_63:B br_0_63:B br_1_63:B bl_0_64:B bl_1_64:B br_0_64:B br_1_64:B bl_0_65:B bl_1_65:B br_0_65:B br_1_65:B bl_0_66:B bl_1_66:B br_0_66:B br_1_66:B bl_0_67:B bl_1_67:B br_0_67:B br_1_67:B bl_0_68:B bl_1_68:B br_0_68:B br_1_68:B bl_0_69:B bl_1_69:B br_0_69:B br_1_69:B bl_0_70:B bl_1_70:B br_0_70:B br_1_70:B bl_0_71:B bl_1_71:B br_0_71:B br_1_71:B bl_0_72:B bl_1_72:B br_0_72:B br_1_72:B bl_0_73:B bl_1_73:B br_0_73:B br_1_73:B bl_0_74:B bl_1_74:B br_0_74:B br_1_74:B bl_0_75:B bl_1_75:B br_0_75:B br_1_75:B bl_0_76:B bl_1_76:B br_0_76:B br_1_76:B bl_0_77:B bl_1_77:B br_0_77:B br_1_77:B bl_0_78:B bl_1_78:B br_0_78:B br_1_78:B bl_0_79:B bl_1_79:B br_0_79:B br_1_79:B bl_0_80:B bl_1_80:B br_0_80:B br_1_80:B bl_0_81:B bl_1_81:B br_0_81:B br_1_81:B bl_0_82:B bl_1_82:B br_0_82:B br_1_82:B bl_0_83:B bl_1_83:B br_0_83:B br_1_83:B bl_0_84:B bl_1_84:B br_0_84:B br_1_84:B bl_0_85:B bl_1_85:B br_0_85:B br_1_85:B bl_0_86:B bl_1_86:B br_0_86:B br_1_86:B bl_0_87:B bl_1_87:B br_0_87:B br_1_87:B bl_0_88:B bl_1_88:B br_0_88:B br_1_88:B bl_0_89:B bl_1_89:B br_0_89:B br_1_89:B bl_0_90:B bl_1_90:B br_0_90:B br_1_90:B bl_0_91:B bl_1_91:B br_0_91:B br_1_91:B bl_0_92:B bl_1_92:B br_0_92:B br_1_92:B bl_0_93:B bl_1_93:B br_0_93:B br_1_93:B bl_0_94:B bl_1_94:B br_0_94:B br_1_94:B bl_0_95:B bl_1_95:B br_0_95:B br_1_95:B bl_0_96:B bl_1_96:B br_0_96:B br_1_96:B bl_0_97:B bl_1_97:B br_0_97:B br_1_97:B bl_0_98:B bl_1_98:B br_0_98:B br_1_98:B bl_0_99:B bl_1_99:B br_0_99:B br_1_99:B bl_0_100:B bl_1_100:B br_0_100:B br_1_100:B bl_0_101:B bl_1_101:B br_0_101:B br_1_101:B bl_0_102:B bl_1_102:B br_0_102:B br_1_102:B bl_0_103:B bl_1_103:B br_0_103:B br_1_103:B bl_0_104:B bl_1_104:B br_0_104:B br_1_104:B bl_0_105:B bl_1_105:B br_0_105:B br_1_105:B bl_0_106:B bl_1_106:B br_0_106:B br_1_106:B bl_0_107:B bl_1_107:B br_0_107:B br_1_107:B bl_0_108:B bl_1_108:B br_0_108:B br_1_108:B bl_0_109:B bl_1_109:B br_0_109:B br_1_109:B bl_0_110:B bl_1_110:B br_0_110:B br_1_110:B bl_0_111:B bl_1_111:B br_0_111:B br_1_111:B bl_0_112:B bl_1_112:B br_0_112:B br_1_112:B bl_0_113:B bl_1_113:B br_0_113:B br_1_113:B bl_0_114:B bl_1_114:B br_0_114:B br_1_114:B bl_0_115:B bl_1_115:B br_0_115:B br_1_115:B bl_0_116:B bl_1_116:B br_0_116:B br_1_116:B bl_0_117:B bl_1_117:B br_0_117:B br_1_117:B bl_0_118:B bl_1_118:B br_0_118:B br_1_118:B bl_0_119:B bl_1_119:B br_0_119:B br_1_119:B bl_0_120:B bl_1_120:B br_0_120:B br_1_120:B bl_0_121:B bl_1_121:B br_0_121:B br_1_121:B bl_0_122:B bl_1_122:B br_0_122:B br_1_122:B bl_0_123:B bl_1_123:B br_0_123:B br_1_123:B bl_0_124:B bl_1_124:B br_0_124:B br_1_124:B bl_0_125:B bl_1_125:B br_0_125:B br_1_125:B bl_0_126:B bl_1_126:B br_0_126:B br_1_126:B bl_0_127:B bl_1_127:B br_0_127:B br_1_127:B rbl_bl_0_1:B rbl_bl_1_1:B rbl_br_0_1:B rbl_br_1_1:B rbl_wl_0_0:I wl_0_0:I wl_1_0:I wl_0_1:I wl_1_1:I wl_0_2:I wl_1_2:I wl_0_3:I wl_1_3:I wl_0_4:I wl_1_4:I wl_0_5:I wl_1_5:I wl_0_6:I wl_1_6:I wl_0_7:I wl_1_7:I wl_0_8:I wl_1_8:I wl_0_9:I wl_1_9:I wl_0_10:I wl_1_10:I wl_0_11:I wl_1_11:I wl_0_12:I wl_1_12:I wl_0_13:I wl_1_13:I wl_0_14:I wl_1_14:I wl_0_15:I wl_1_15:I wl_0_16:I wl_1_16:I wl_0_17:I wl_1_17:I wl_0_18:I wl_1_18:I wl_0_19:I wl_1_19:I wl_0_20:I wl_1_20:I wl_0_21:I wl_1_21:I wl_0_22:I wl_1_22:I wl_0_23:I wl_1_23:I wl_0_24:I wl_1_24:I wl_0_25:I wl_1_25:I wl_0_26:I wl_1_26:I wl_0_27:I wl_1_27:I wl_0_28:I wl_1_28:I wl_0_29:I wl_1_29:I wl_0_30:I wl_1_30:I wl_0_31:I wl_1_31:I wl_0_32:I wl_1_32:I wl_0_33:I wl_1_33:I wl_0_34:I wl_1_34:I wl_0_35:I wl_1_35:I wl_0_36:I wl_1_36:I wl_0_37:I wl_1_37:I wl_0_38:I wl_1_38:I wl_0_39:I wl_1_39:I wl_0_40:I wl_1_40:I wl_0_41:I wl_1_41:I wl_0_42:I wl_1_42:I wl_0_43:I wl_1_43:I wl_0_44:I wl_1_44:I wl_0_45:I wl_1_45:I wl_0_46:I wl_1_46:I wl_0_47:I wl_1_47:I wl_0_48:I wl_1_48:I wl_0_49:I wl_1_49:I wl_0_50:I wl_1_50:I wl_0_51:I wl_1_51:I wl_0_52:I wl_1_52:I wl_0_53:I wl_1_53:I wl_0_54:I wl_1_54:I wl_0_55:I wl_1_55:I wl_0_56:I wl_1_56:I wl_0_57:I wl_1_57:I wl_0_58:I wl_1_58:I wl_0_59:I wl_1_59:I wl_0_60:I wl_1_60:I wl_0_61:I wl_1_61:I wl_0_62:I wl_1_62:I wl_0_63:I wl_1_63:I wl_0_64:I wl_1_64:I wl_0_65:I wl_1_65:I wl_0_66:I wl_1_66:I wl_0_67:I wl_1_67:I wl_0_68:I wl_1_68:I wl_0_69:I wl_1_69:I wl_0_70:I wl_1_70:I wl_0_71:I wl_1_71:I wl_0_72:I wl_1_72:I wl_0_73:I wl_1_73:I wl_0_74:I wl_1_74:I wl_0_75:I wl_1_75:I wl_0_76:I wl_1_76:I wl_0_77:I wl_1_77:I wl_0_78:I wl_1_78:I wl_0_79:I wl_1_79:I wl_0_80:I wl_1_80:I wl_0_81:I wl_1_81:I wl_0_82:I wl_1_82:I wl_0_83:I wl_1_83:I wl_0_84:I wl_1_84:I wl_0_85:I wl_1_85:I wl_0_86:I wl_1_86:I wl_0_87:I wl_1_87:I wl_0_88:I wl_1_88:I wl_0_89:I wl_1_89:I wl_0_90:I wl_1_90:I wl_0_91:I wl_1_91:I wl_0_92:I wl_1_92:I wl_0_93:I wl_1_93:I wl_0_94:I wl_1_94:I wl_0_95:I wl_1_95:I wl_0_96:I wl_1_96:I wl_0_97:I wl_1_97:I wl_0_98:I wl_1_98:I wl_0_99:I wl_1_99:I wl_0_100:I wl_1_100:I wl_0_101:I wl_1_101:I wl_0_102:I wl_1_102:I wl_0_103:I wl_1_103:I wl_0_104:I wl_1_104:I wl_0_105:I wl_1_105:I wl_0_106:I wl_1_106:I wl_0_107:I wl_1_107:I wl_0_108:I wl_1_108:I wl_0_109:I wl_1_109:I wl_0_110:I wl_1_110:I wl_0_111:I wl_1_111:I wl_0_112:I wl_1_112:I wl_0_113:I wl_1_113:I wl_0_114:I wl_1_114:I wl_0_115:I wl_1_115:I wl_0_116:I wl_1_116:I wl_0_117:I wl_1_117:I wl_0_118:I wl_1_118:I wl_0_119:I wl_1_119:I wl_0_120:I wl_1_120:I wl_0_121:I wl_1_121:I wl_0_122:I wl_1_122:I wl_0_123:I wl_1_123:I wl_0_124:I wl_1_124:I wl_0_125:I wl_1_125:I wl_0_126:I wl_1_126:I wl_0_127:I wl_1_127:I rbl_wl_1_1:I vdd:B gnd:B
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
* INOUT : bl_0_44 
* INOUT : bl_1_44 
* INOUT : br_0_44 
* INOUT : br_1_44 
* INOUT : bl_0_45 
* INOUT : bl_1_45 
* INOUT : br_0_45 
* INOUT : br_1_45 
* INOUT : bl_0_46 
* INOUT : bl_1_46 
* INOUT : br_0_46 
* INOUT : br_1_46 
* INOUT : bl_0_47 
* INOUT : bl_1_47 
* INOUT : br_0_47 
* INOUT : br_1_47 
* INOUT : bl_0_48 
* INOUT : bl_1_48 
* INOUT : br_0_48 
* INOUT : br_1_48 
* INOUT : bl_0_49 
* INOUT : bl_1_49 
* INOUT : br_0_49 
* INOUT : br_1_49 
* INOUT : bl_0_50 
* INOUT : bl_1_50 
* INOUT : br_0_50 
* INOUT : br_1_50 
* INOUT : bl_0_51 
* INOUT : bl_1_51 
* INOUT : br_0_51 
* INOUT : br_1_51 
* INOUT : bl_0_52 
* INOUT : bl_1_52 
* INOUT : br_0_52 
* INOUT : br_1_52 
* INOUT : bl_0_53 
* INOUT : bl_1_53 
* INOUT : br_0_53 
* INOUT : br_1_53 
* INOUT : bl_0_54 
* INOUT : bl_1_54 
* INOUT : br_0_54 
* INOUT : br_1_54 
* INOUT : bl_0_55 
* INOUT : bl_1_55 
* INOUT : br_0_55 
* INOUT : br_1_55 
* INOUT : bl_0_56 
* INOUT : bl_1_56 
* INOUT : br_0_56 
* INOUT : br_1_56 
* INOUT : bl_0_57 
* INOUT : bl_1_57 
* INOUT : br_0_57 
* INOUT : br_1_57 
* INOUT : bl_0_58 
* INOUT : bl_1_58 
* INOUT : br_0_58 
* INOUT : br_1_58 
* INOUT : bl_0_59 
* INOUT : bl_1_59 
* INOUT : br_0_59 
* INOUT : br_1_59 
* INOUT : bl_0_60 
* INOUT : bl_1_60 
* INOUT : br_0_60 
* INOUT : br_1_60 
* INOUT : bl_0_61 
* INOUT : bl_1_61 
* INOUT : br_0_61 
* INOUT : br_1_61 
* INOUT : bl_0_62 
* INOUT : bl_1_62 
* INOUT : br_0_62 
* INOUT : br_1_62 
* INOUT : bl_0_63 
* INOUT : bl_1_63 
* INOUT : br_0_63 
* INOUT : br_1_63 
* INOUT : bl_0_64 
* INOUT : bl_1_64 
* INOUT : br_0_64 
* INOUT : br_1_64 
* INOUT : bl_0_65 
* INOUT : bl_1_65 
* INOUT : br_0_65 
* INOUT : br_1_65 
* INOUT : bl_0_66 
* INOUT : bl_1_66 
* INOUT : br_0_66 
* INOUT : br_1_66 
* INOUT : bl_0_67 
* INOUT : bl_1_67 
* INOUT : br_0_67 
* INOUT : br_1_67 
* INOUT : bl_0_68 
* INOUT : bl_1_68 
* INOUT : br_0_68 
* INOUT : br_1_68 
* INOUT : bl_0_69 
* INOUT : bl_1_69 
* INOUT : br_0_69 
* INOUT : br_1_69 
* INOUT : bl_0_70 
* INOUT : bl_1_70 
* INOUT : br_0_70 
* INOUT : br_1_70 
* INOUT : bl_0_71 
* INOUT : bl_1_71 
* INOUT : br_0_71 
* INOUT : br_1_71 
* INOUT : bl_0_72 
* INOUT : bl_1_72 
* INOUT : br_0_72 
* INOUT : br_1_72 
* INOUT : bl_0_73 
* INOUT : bl_1_73 
* INOUT : br_0_73 
* INOUT : br_1_73 
* INOUT : bl_0_74 
* INOUT : bl_1_74 
* INOUT : br_0_74 
* INOUT : br_1_74 
* INOUT : bl_0_75 
* INOUT : bl_1_75 
* INOUT : br_0_75 
* INOUT : br_1_75 
* INOUT : bl_0_76 
* INOUT : bl_1_76 
* INOUT : br_0_76 
* INOUT : br_1_76 
* INOUT : bl_0_77 
* INOUT : bl_1_77 
* INOUT : br_0_77 
* INOUT : br_1_77 
* INOUT : bl_0_78 
* INOUT : bl_1_78 
* INOUT : br_0_78 
* INOUT : br_1_78 
* INOUT : bl_0_79 
* INOUT : bl_1_79 
* INOUT : br_0_79 
* INOUT : br_1_79 
* INOUT : bl_0_80 
* INOUT : bl_1_80 
* INOUT : br_0_80 
* INOUT : br_1_80 
* INOUT : bl_0_81 
* INOUT : bl_1_81 
* INOUT : br_0_81 
* INOUT : br_1_81 
* INOUT : bl_0_82 
* INOUT : bl_1_82 
* INOUT : br_0_82 
* INOUT : br_1_82 
* INOUT : bl_0_83 
* INOUT : bl_1_83 
* INOUT : br_0_83 
* INOUT : br_1_83 
* INOUT : bl_0_84 
* INOUT : bl_1_84 
* INOUT : br_0_84 
* INOUT : br_1_84 
* INOUT : bl_0_85 
* INOUT : bl_1_85 
* INOUT : br_0_85 
* INOUT : br_1_85 
* INOUT : bl_0_86 
* INOUT : bl_1_86 
* INOUT : br_0_86 
* INOUT : br_1_86 
* INOUT : bl_0_87 
* INOUT : bl_1_87 
* INOUT : br_0_87 
* INOUT : br_1_87 
* INOUT : bl_0_88 
* INOUT : bl_1_88 
* INOUT : br_0_88 
* INOUT : br_1_88 
* INOUT : bl_0_89 
* INOUT : bl_1_89 
* INOUT : br_0_89 
* INOUT : br_1_89 
* INOUT : bl_0_90 
* INOUT : bl_1_90 
* INOUT : br_0_90 
* INOUT : br_1_90 
* INOUT : bl_0_91 
* INOUT : bl_1_91 
* INOUT : br_0_91 
* INOUT : br_1_91 
* INOUT : bl_0_92 
* INOUT : bl_1_92 
* INOUT : br_0_92 
* INOUT : br_1_92 
* INOUT : bl_0_93 
* INOUT : bl_1_93 
* INOUT : br_0_93 
* INOUT : br_1_93 
* INOUT : bl_0_94 
* INOUT : bl_1_94 
* INOUT : br_0_94 
* INOUT : br_1_94 
* INOUT : bl_0_95 
* INOUT : bl_1_95 
* INOUT : br_0_95 
* INOUT : br_1_95 
* INOUT : bl_0_96 
* INOUT : bl_1_96 
* INOUT : br_0_96 
* INOUT : br_1_96 
* INOUT : bl_0_97 
* INOUT : bl_1_97 
* INOUT : br_0_97 
* INOUT : br_1_97 
* INOUT : bl_0_98 
* INOUT : bl_1_98 
* INOUT : br_0_98 
* INOUT : br_1_98 
* INOUT : bl_0_99 
* INOUT : bl_1_99 
* INOUT : br_0_99 
* INOUT : br_1_99 
* INOUT : bl_0_100 
* INOUT : bl_1_100 
* INOUT : br_0_100 
* INOUT : br_1_100 
* INOUT : bl_0_101 
* INOUT : bl_1_101 
* INOUT : br_0_101 
* INOUT : br_1_101 
* INOUT : bl_0_102 
* INOUT : bl_1_102 
* INOUT : br_0_102 
* INOUT : br_1_102 
* INOUT : bl_0_103 
* INOUT : bl_1_103 
* INOUT : br_0_103 
* INOUT : br_1_103 
* INOUT : bl_0_104 
* INOUT : bl_1_104 
* INOUT : br_0_104 
* INOUT : br_1_104 
* INOUT : bl_0_105 
* INOUT : bl_1_105 
* INOUT : br_0_105 
* INOUT : br_1_105 
* INOUT : bl_0_106 
* INOUT : bl_1_106 
* INOUT : br_0_106 
* INOUT : br_1_106 
* INOUT : bl_0_107 
* INOUT : bl_1_107 
* INOUT : br_0_107 
* INOUT : br_1_107 
* INOUT : bl_0_108 
* INOUT : bl_1_108 
* INOUT : br_0_108 
* INOUT : br_1_108 
* INOUT : bl_0_109 
* INOUT : bl_1_109 
* INOUT : br_0_109 
* INOUT : br_1_109 
* INOUT : bl_0_110 
* INOUT : bl_1_110 
* INOUT : br_0_110 
* INOUT : br_1_110 
* INOUT : bl_0_111 
* INOUT : bl_1_111 
* INOUT : br_0_111 
* INOUT : br_1_111 
* INOUT : bl_0_112 
* INOUT : bl_1_112 
* INOUT : br_0_112 
* INOUT : br_1_112 
* INOUT : bl_0_113 
* INOUT : bl_1_113 
* INOUT : br_0_113 
* INOUT : br_1_113 
* INOUT : bl_0_114 
* INOUT : bl_1_114 
* INOUT : br_0_114 
* INOUT : br_1_114 
* INOUT : bl_0_115 
* INOUT : bl_1_115 
* INOUT : br_0_115 
* INOUT : br_1_115 
* INOUT : bl_0_116 
* INOUT : bl_1_116 
* INOUT : br_0_116 
* INOUT : br_1_116 
* INOUT : bl_0_117 
* INOUT : bl_1_117 
* INOUT : br_0_117 
* INOUT : br_1_117 
* INOUT : bl_0_118 
* INOUT : bl_1_118 
* INOUT : br_0_118 
* INOUT : br_1_118 
* INOUT : bl_0_119 
* INOUT : bl_1_119 
* INOUT : br_0_119 
* INOUT : br_1_119 
* INOUT : bl_0_120 
* INOUT : bl_1_120 
* INOUT : br_0_120 
* INOUT : br_1_120 
* INOUT : bl_0_121 
* INOUT : bl_1_121 
* INOUT : br_0_121 
* INOUT : br_1_121 
* INOUT : bl_0_122 
* INOUT : bl_1_122 
* INOUT : br_0_122 
* INOUT : br_1_122 
* INOUT : bl_0_123 
* INOUT : bl_1_123 
* INOUT : br_0_123 
* INOUT : br_1_123 
* INOUT : bl_0_124 
* INOUT : bl_1_124 
* INOUT : br_0_124 
* INOUT : br_1_124 
* INOUT : bl_0_125 
* INOUT : bl_1_125 
* INOUT : br_0_125 
* INOUT : br_1_125 
* INOUT : bl_0_126 
* INOUT : bl_1_126 
* INOUT : br_0_126 
* INOUT : br_1_126 
* INOUT : bl_0_127 
* INOUT : bl_1_127 
* INOUT : br_0_127 
* INOUT : br_1_127 
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
* INPUT : wl_0_64 
* INPUT : wl_1_64 
* INPUT : wl_0_65 
* INPUT : wl_1_65 
* INPUT : wl_0_66 
* INPUT : wl_1_66 
* INPUT : wl_0_67 
* INPUT : wl_1_67 
* INPUT : wl_0_68 
* INPUT : wl_1_68 
* INPUT : wl_0_69 
* INPUT : wl_1_69 
* INPUT : wl_0_70 
* INPUT : wl_1_70 
* INPUT : wl_0_71 
* INPUT : wl_1_71 
* INPUT : wl_0_72 
* INPUT : wl_1_72 
* INPUT : wl_0_73 
* INPUT : wl_1_73 
* INPUT : wl_0_74 
* INPUT : wl_1_74 
* INPUT : wl_0_75 
* INPUT : wl_1_75 
* INPUT : wl_0_76 
* INPUT : wl_1_76 
* INPUT : wl_0_77 
* INPUT : wl_1_77 
* INPUT : wl_0_78 
* INPUT : wl_1_78 
* INPUT : wl_0_79 
* INPUT : wl_1_79 
* INPUT : wl_0_80 
* INPUT : wl_1_80 
* INPUT : wl_0_81 
* INPUT : wl_1_81 
* INPUT : wl_0_82 
* INPUT : wl_1_82 
* INPUT : wl_0_83 
* INPUT : wl_1_83 
* INPUT : wl_0_84 
* INPUT : wl_1_84 
* INPUT : wl_0_85 
* INPUT : wl_1_85 
* INPUT : wl_0_86 
* INPUT : wl_1_86 
* INPUT : wl_0_87 
* INPUT : wl_1_87 
* INPUT : wl_0_88 
* INPUT : wl_1_88 
* INPUT : wl_0_89 
* INPUT : wl_1_89 
* INPUT : wl_0_90 
* INPUT : wl_1_90 
* INPUT : wl_0_91 
* INPUT : wl_1_91 
* INPUT : wl_0_92 
* INPUT : wl_1_92 
* INPUT : wl_0_93 
* INPUT : wl_1_93 
* INPUT : wl_0_94 
* INPUT : wl_1_94 
* INPUT : wl_0_95 
* INPUT : wl_1_95 
* INPUT : wl_0_96 
* INPUT : wl_1_96 
* INPUT : wl_0_97 
* INPUT : wl_1_97 
* INPUT : wl_0_98 
* INPUT : wl_1_98 
* INPUT : wl_0_99 
* INPUT : wl_1_99 
* INPUT : wl_0_100 
* INPUT : wl_1_100 
* INPUT : wl_0_101 
* INPUT : wl_1_101 
* INPUT : wl_0_102 
* INPUT : wl_1_102 
* INPUT : wl_0_103 
* INPUT : wl_1_103 
* INPUT : wl_0_104 
* INPUT : wl_1_104 
* INPUT : wl_0_105 
* INPUT : wl_1_105 
* INPUT : wl_0_106 
* INPUT : wl_1_106 
* INPUT : wl_0_107 
* INPUT : wl_1_107 
* INPUT : wl_0_108 
* INPUT : wl_1_108 
* INPUT : wl_0_109 
* INPUT : wl_1_109 
* INPUT : wl_0_110 
* INPUT : wl_1_110 
* INPUT : wl_0_111 
* INPUT : wl_1_111 
* INPUT : wl_0_112 
* INPUT : wl_1_112 
* INPUT : wl_0_113 
* INPUT : wl_1_113 
* INPUT : wl_0_114 
* INPUT : wl_1_114 
* INPUT : wl_0_115 
* INPUT : wl_1_115 
* INPUT : wl_0_116 
* INPUT : wl_1_116 
* INPUT : wl_0_117 
* INPUT : wl_1_117 
* INPUT : wl_0_118 
* INPUT : wl_1_118 
* INPUT : wl_0_119 
* INPUT : wl_1_119 
* INPUT : wl_0_120 
* INPUT : wl_1_120 
* INPUT : wl_0_121 
* INPUT : wl_1_121 
* INPUT : wl_0_122 
* INPUT : wl_1_122 
* INPUT : wl_0_123 
* INPUT : wl_1_123 
* INPUT : wl_0_124 
* INPUT : wl_1_124 
* INPUT : wl_0_125 
* INPUT : wl_1_125 
* INPUT : wl_0_126 
* INPUT : wl_1_126 
* INPUT : wl_0_127 
* INPUT : wl_1_127 
* INPUT : rbl_wl_1_1 
* POWER : vdd 
* GROUND: gnd 
Xla_0 rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array
Xla_16 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 bl_0_28 bl_1_28 br_0_28 br_1_28 bl_0_29 bl_1_29 br_0_29 br_1_29 bl_0_30 bl_1_30 br_0_30 br_1_30 bl_0_31 bl_1_31 br_0_31 br_1_31 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_0
Xla_32 bl_0_32 bl_1_32 br_0_32 br_1_32 bl_0_33 bl_1_33 br_0_33 br_1_33 bl_0_34 bl_1_34 br_0_34 br_1_34 bl_0_35 bl_1_35 br_0_35 br_1_35 bl_0_36 bl_1_36 br_0_36 br_1_36 bl_0_37 bl_1_37 br_0_37 br_1_37 bl_0_38 bl_1_38 br_0_38 br_1_38 bl_0_39 bl_1_39 br_0_39 br_1_39 bl_0_40 bl_1_40 br_0_40 br_1_40 bl_0_41 bl_1_41 br_0_41 br_1_41 bl_0_42 bl_1_42 br_0_42 br_1_42 bl_0_43 bl_1_43 br_0_43 br_1_43 bl_0_44 bl_1_44 br_0_44 br_1_44 bl_0_45 bl_1_45 br_0_45 br_1_45 bl_0_46 bl_1_46 br_0_46 br_1_46 bl_0_47 bl_1_47 br_0_47 br_1_47 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_0
Xla_48 bl_0_48 bl_1_48 br_0_48 br_1_48 bl_0_49 bl_1_49 br_0_49 br_1_49 bl_0_50 bl_1_50 br_0_50 br_1_50 bl_0_51 bl_1_51 br_0_51 br_1_51 bl_0_52 bl_1_52 br_0_52 br_1_52 bl_0_53 bl_1_53 br_0_53 br_1_53 bl_0_54 bl_1_54 br_0_54 br_1_54 bl_0_55 bl_1_55 br_0_55 br_1_55 bl_0_56 bl_1_56 br_0_56 br_1_56 bl_0_57 bl_1_57 br_0_57 br_1_57 bl_0_58 bl_1_58 br_0_58 br_1_58 bl_0_59 bl_1_59 br_0_59 br_1_59 bl_0_60 bl_1_60 br_0_60 br_1_60 bl_0_61 bl_1_61 br_0_61 br_1_61 bl_0_62 bl_1_62 br_0_62 br_1_62 bl_0_63 bl_1_63 br_0_63 br_1_63 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_0
Xla_64 bl_0_64 bl_1_64 br_0_64 br_1_64 bl_0_65 bl_1_65 br_0_65 br_1_65 bl_0_66 bl_1_66 br_0_66 br_1_66 bl_0_67 bl_1_67 br_0_67 br_1_67 bl_0_68 bl_1_68 br_0_68 br_1_68 bl_0_69 bl_1_69 br_0_69 br_1_69 bl_0_70 bl_1_70 br_0_70 br_1_70 bl_0_71 bl_1_71 br_0_71 br_1_71 bl_0_72 bl_1_72 br_0_72 br_1_72 bl_0_73 bl_1_73 br_0_73 br_1_73 bl_0_74 bl_1_74 br_0_74 br_1_74 bl_0_75 bl_1_75 br_0_75 br_1_75 bl_0_76 bl_1_76 br_0_76 br_1_76 bl_0_77 bl_1_77 br_0_77 br_1_77 bl_0_78 bl_1_78 br_0_78 br_1_78 bl_0_79 bl_1_79 br_0_79 br_1_79 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_0
Xla_80 bl_0_80 bl_1_80 br_0_80 br_1_80 bl_0_81 bl_1_81 br_0_81 br_1_81 bl_0_82 bl_1_82 br_0_82 br_1_82 bl_0_83 bl_1_83 br_0_83 br_1_83 bl_0_84 bl_1_84 br_0_84 br_1_84 bl_0_85 bl_1_85 br_0_85 br_1_85 bl_0_86 bl_1_86 br_0_86 br_1_86 bl_0_87 bl_1_87 br_0_87 br_1_87 bl_0_88 bl_1_88 br_0_88 br_1_88 bl_0_89 bl_1_89 br_0_89 br_1_89 bl_0_90 bl_1_90 br_0_90 br_1_90 bl_0_91 bl_1_91 br_0_91 br_1_91 bl_0_92 bl_1_92 br_0_92 br_1_92 bl_0_93 bl_1_93 br_0_93 br_1_93 bl_0_94 bl_1_94 br_0_94 br_1_94 bl_0_95 bl_1_95 br_0_95 br_1_95 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_0
Xla_96 bl_0_96 bl_1_96 br_0_96 br_1_96 bl_0_97 bl_1_97 br_0_97 br_1_97 bl_0_98 bl_1_98 br_0_98 br_1_98 bl_0_99 bl_1_99 br_0_99 br_1_99 bl_0_100 bl_1_100 br_0_100 br_1_100 bl_0_101 bl_1_101 br_0_101 br_1_101 bl_0_102 bl_1_102 br_0_102 br_1_102 bl_0_103 bl_1_103 br_0_103 br_1_103 bl_0_104 bl_1_104 br_0_104 br_1_104 bl_0_105 bl_1_105 br_0_105 br_1_105 bl_0_106 bl_1_106 br_0_106 br_1_106 bl_0_107 bl_1_107 br_0_107 br_1_107 bl_0_108 bl_1_108 br_0_108 br_1_108 bl_0_109 bl_1_109 br_0_109 br_1_109 bl_0_110 bl_1_110 br_0_110 br_1_110 bl_0_111 bl_1_111 br_0_111 br_1_111 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_0
Xla_112 bl_0_112 bl_1_112 br_0_112 br_1_112 bl_0_113 bl_1_113 br_0_113 br_1_113 bl_0_114 bl_1_114 br_0_114 br_1_114 bl_0_115 bl_1_115 br_0_115 br_1_115 bl_0_116 bl_1_116 br_0_116 br_1_116 bl_0_117 bl_1_117 br_0_117 br_1_117 bl_0_118 bl_1_118 br_0_118 br_1_118 bl_0_119 bl_1_119 br_0_119 br_1_119 bl_0_120 bl_1_120 br_0_120 br_1_120 bl_0_121 bl_1_121 br_0_121 br_1_121 bl_0_122 bl_1_122 br_0_122 br_1_122 bl_0_123 bl_1_123 br_0_123 br_1_123 bl_0_124 bl_1_124 br_0_124 br_1_124 bl_0_125 bl_1_125 br_0_125 br_1_125 bl_0_126 bl_1_126 br_0_126 br_1_126 bl_0_127 bl_1_127 br_0_127 br_1_127 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl_0_0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl_1_1 vdd gnd local_bitcell_array_1
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

.SUBCKT precharge_array bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 bl_128 br_128 en_bar vdd
*.PININFO bl_0:O br_0:O bl_1:O br_1:O bl_2:O br_2:O bl_3:O br_3:O bl_4:O br_4:O bl_5:O br_5:O bl_6:O br_6:O bl_7:O br_7:O bl_8:O br_8:O bl_9:O br_9:O bl_10:O br_10:O bl_11:O br_11:O bl_12:O br_12:O bl_13:O br_13:O bl_14:O br_14:O bl_15:O br_15:O bl_16:O br_16:O bl_17:O br_17:O bl_18:O br_18:O bl_19:O br_19:O bl_20:O br_20:O bl_21:O br_21:O bl_22:O br_22:O bl_23:O br_23:O bl_24:O br_24:O bl_25:O br_25:O bl_26:O br_26:O bl_27:O br_27:O bl_28:O br_28:O bl_29:O br_29:O bl_30:O br_30:O bl_31:O br_31:O bl_32:O br_32:O bl_33:O br_33:O bl_34:O br_34:O bl_35:O br_35:O bl_36:O br_36:O bl_37:O br_37:O bl_38:O br_38:O bl_39:O br_39:O bl_40:O br_40:O bl_41:O br_41:O bl_42:O br_42:O bl_43:O br_43:O bl_44:O br_44:O bl_45:O br_45:O bl_46:O br_46:O bl_47:O br_47:O bl_48:O br_48:O bl_49:O br_49:O bl_50:O br_50:O bl_51:O br_51:O bl_52:O br_52:O bl_53:O br_53:O bl_54:O br_54:O bl_55:O br_55:O bl_56:O br_56:O bl_57:O br_57:O bl_58:O br_58:O bl_59:O br_59:O bl_60:O br_60:O bl_61:O br_61:O bl_62:O br_62:O bl_63:O br_63:O bl_64:O br_64:O bl_65:O br_65:O bl_66:O br_66:O bl_67:O br_67:O bl_68:O br_68:O bl_69:O br_69:O bl_70:O br_70:O bl_71:O br_71:O bl_72:O br_72:O bl_73:O br_73:O bl_74:O br_74:O bl_75:O br_75:O bl_76:O br_76:O bl_77:O br_77:O bl_78:O br_78:O bl_79:O br_79:O bl_80:O br_80:O bl_81:O br_81:O bl_82:O br_82:O bl_83:O br_83:O bl_84:O br_84:O bl_85:O br_85:O bl_86:O br_86:O bl_87:O br_87:O bl_88:O br_88:O bl_89:O br_89:O bl_90:O br_90:O bl_91:O br_91:O bl_92:O br_92:O bl_93:O br_93:O bl_94:O br_94:O bl_95:O br_95:O bl_96:O br_96:O bl_97:O br_97:O bl_98:O br_98:O bl_99:O br_99:O bl_100:O br_100:O bl_101:O br_101:O bl_102:O br_102:O bl_103:O br_103:O bl_104:O br_104:O bl_105:O br_105:O bl_106:O br_106:O bl_107:O br_107:O bl_108:O br_108:O bl_109:O br_109:O bl_110:O br_110:O bl_111:O br_111:O bl_112:O br_112:O bl_113:O br_113:O bl_114:O br_114:O bl_115:O br_115:O bl_116:O br_116:O bl_117:O br_117:O bl_118:O br_118:O bl_119:O br_119:O bl_120:O br_120:O bl_121:O br_121:O bl_122:O br_122:O bl_123:O br_123:O bl_124:O br_124:O bl_125:O br_125:O bl_126:O br_126:O bl_127:O br_127:O bl_128:O br_128:O en_bar:I vdd:B
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
* OUTPUT: bl_45 
* OUTPUT: br_45 
* OUTPUT: bl_46 
* OUTPUT: br_46 
* OUTPUT: bl_47 
* OUTPUT: br_47 
* OUTPUT: bl_48 
* OUTPUT: br_48 
* OUTPUT: bl_49 
* OUTPUT: br_49 
* OUTPUT: bl_50 
* OUTPUT: br_50 
* OUTPUT: bl_51 
* OUTPUT: br_51 
* OUTPUT: bl_52 
* OUTPUT: br_52 
* OUTPUT: bl_53 
* OUTPUT: br_53 
* OUTPUT: bl_54 
* OUTPUT: br_54 
* OUTPUT: bl_55 
* OUTPUT: br_55 
* OUTPUT: bl_56 
* OUTPUT: br_56 
* OUTPUT: bl_57 
* OUTPUT: br_57 
* OUTPUT: bl_58 
* OUTPUT: br_58 
* OUTPUT: bl_59 
* OUTPUT: br_59 
* OUTPUT: bl_60 
* OUTPUT: br_60 
* OUTPUT: bl_61 
* OUTPUT: br_61 
* OUTPUT: bl_62 
* OUTPUT: br_62 
* OUTPUT: bl_63 
* OUTPUT: br_63 
* OUTPUT: bl_64 
* OUTPUT: br_64 
* OUTPUT: bl_65 
* OUTPUT: br_65 
* OUTPUT: bl_66 
* OUTPUT: br_66 
* OUTPUT: bl_67 
* OUTPUT: br_67 
* OUTPUT: bl_68 
* OUTPUT: br_68 
* OUTPUT: bl_69 
* OUTPUT: br_69 
* OUTPUT: bl_70 
* OUTPUT: br_70 
* OUTPUT: bl_71 
* OUTPUT: br_71 
* OUTPUT: bl_72 
* OUTPUT: br_72 
* OUTPUT: bl_73 
* OUTPUT: br_73 
* OUTPUT: bl_74 
* OUTPUT: br_74 
* OUTPUT: bl_75 
* OUTPUT: br_75 
* OUTPUT: bl_76 
* OUTPUT: br_76 
* OUTPUT: bl_77 
* OUTPUT: br_77 
* OUTPUT: bl_78 
* OUTPUT: br_78 
* OUTPUT: bl_79 
* OUTPUT: br_79 
* OUTPUT: bl_80 
* OUTPUT: br_80 
* OUTPUT: bl_81 
* OUTPUT: br_81 
* OUTPUT: bl_82 
* OUTPUT: br_82 
* OUTPUT: bl_83 
* OUTPUT: br_83 
* OUTPUT: bl_84 
* OUTPUT: br_84 
* OUTPUT: bl_85 
* OUTPUT: br_85 
* OUTPUT: bl_86 
* OUTPUT: br_86 
* OUTPUT: bl_87 
* OUTPUT: br_87 
* OUTPUT: bl_88 
* OUTPUT: br_88 
* OUTPUT: bl_89 
* OUTPUT: br_89 
* OUTPUT: bl_90 
* OUTPUT: br_90 
* OUTPUT: bl_91 
* OUTPUT: br_91 
* OUTPUT: bl_92 
* OUTPUT: br_92 
* OUTPUT: bl_93 
* OUTPUT: br_93 
* OUTPUT: bl_94 
* OUTPUT: br_94 
* OUTPUT: bl_95 
* OUTPUT: br_95 
* OUTPUT: bl_96 
* OUTPUT: br_96 
* OUTPUT: bl_97 
* OUTPUT: br_97 
* OUTPUT: bl_98 
* OUTPUT: br_98 
* OUTPUT: bl_99 
* OUTPUT: br_99 
* OUTPUT: bl_100 
* OUTPUT: br_100 
* OUTPUT: bl_101 
* OUTPUT: br_101 
* OUTPUT: bl_102 
* OUTPUT: br_102 
* OUTPUT: bl_103 
* OUTPUT: br_103 
* OUTPUT: bl_104 
* OUTPUT: br_104 
* OUTPUT: bl_105 
* OUTPUT: br_105 
* OUTPUT: bl_106 
* OUTPUT: br_106 
* OUTPUT: bl_107 
* OUTPUT: br_107 
* OUTPUT: bl_108 
* OUTPUT: br_108 
* OUTPUT: bl_109 
* OUTPUT: br_109 
* OUTPUT: bl_110 
* OUTPUT: br_110 
* OUTPUT: bl_111 
* OUTPUT: br_111 
* OUTPUT: bl_112 
* OUTPUT: br_112 
* OUTPUT: bl_113 
* OUTPUT: br_113 
* OUTPUT: bl_114 
* OUTPUT: br_114 
* OUTPUT: bl_115 
* OUTPUT: br_115 
* OUTPUT: bl_116 
* OUTPUT: br_116 
* OUTPUT: bl_117 
* OUTPUT: br_117 
* OUTPUT: bl_118 
* OUTPUT: br_118 
* OUTPUT: bl_119 
* OUTPUT: br_119 
* OUTPUT: bl_120 
* OUTPUT: br_120 
* OUTPUT: bl_121 
* OUTPUT: br_121 
* OUTPUT: bl_122 
* OUTPUT: br_122 
* OUTPUT: bl_123 
* OUTPUT: br_123 
* OUTPUT: bl_124 
* OUTPUT: br_124 
* OUTPUT: bl_125 
* OUTPUT: br_125 
* OUTPUT: bl_126 
* OUTPUT: br_126 
* OUTPUT: bl_127 
* OUTPUT: br_127 
* OUTPUT: bl_128 
* OUTPUT: br_128 
* INPUT : en_bar 
* POWER : vdd 
* cols: 129 size: 1 bl: bl0 br: br0
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
Xpre_column_45 bl_45 br_45 en_bar vdd precharge_0
Xpre_column_46 bl_46 br_46 en_bar vdd precharge_0
Xpre_column_47 bl_47 br_47 en_bar vdd precharge_0
Xpre_column_48 bl_48 br_48 en_bar vdd precharge_0
Xpre_column_49 bl_49 br_49 en_bar vdd precharge_0
Xpre_column_50 bl_50 br_50 en_bar vdd precharge_0
Xpre_column_51 bl_51 br_51 en_bar vdd precharge_0
Xpre_column_52 bl_52 br_52 en_bar vdd precharge_0
Xpre_column_53 bl_53 br_53 en_bar vdd precharge_0
Xpre_column_54 bl_54 br_54 en_bar vdd precharge_0
Xpre_column_55 bl_55 br_55 en_bar vdd precharge_0
Xpre_column_56 bl_56 br_56 en_bar vdd precharge_0
Xpre_column_57 bl_57 br_57 en_bar vdd precharge_0
Xpre_column_58 bl_58 br_58 en_bar vdd precharge_0
Xpre_column_59 bl_59 br_59 en_bar vdd precharge_0
Xpre_column_60 bl_60 br_60 en_bar vdd precharge_0
Xpre_column_61 bl_61 br_61 en_bar vdd precharge_0
Xpre_column_62 bl_62 br_62 en_bar vdd precharge_0
Xpre_column_63 bl_63 br_63 en_bar vdd precharge_0
Xpre_column_64 bl_64 br_64 en_bar vdd precharge_0
Xpre_column_65 bl_65 br_65 en_bar vdd precharge_0
Xpre_column_66 bl_66 br_66 en_bar vdd precharge_0
Xpre_column_67 bl_67 br_67 en_bar vdd precharge_0
Xpre_column_68 bl_68 br_68 en_bar vdd precharge_0
Xpre_column_69 bl_69 br_69 en_bar vdd precharge_0
Xpre_column_70 bl_70 br_70 en_bar vdd precharge_0
Xpre_column_71 bl_71 br_71 en_bar vdd precharge_0
Xpre_column_72 bl_72 br_72 en_bar vdd precharge_0
Xpre_column_73 bl_73 br_73 en_bar vdd precharge_0
Xpre_column_74 bl_74 br_74 en_bar vdd precharge_0
Xpre_column_75 bl_75 br_75 en_bar vdd precharge_0
Xpre_column_76 bl_76 br_76 en_bar vdd precharge_0
Xpre_column_77 bl_77 br_77 en_bar vdd precharge_0
Xpre_column_78 bl_78 br_78 en_bar vdd precharge_0
Xpre_column_79 bl_79 br_79 en_bar vdd precharge_0
Xpre_column_80 bl_80 br_80 en_bar vdd precharge_0
Xpre_column_81 bl_81 br_81 en_bar vdd precharge_0
Xpre_column_82 bl_82 br_82 en_bar vdd precharge_0
Xpre_column_83 bl_83 br_83 en_bar vdd precharge_0
Xpre_column_84 bl_84 br_84 en_bar vdd precharge_0
Xpre_column_85 bl_85 br_85 en_bar vdd precharge_0
Xpre_column_86 bl_86 br_86 en_bar vdd precharge_0
Xpre_column_87 bl_87 br_87 en_bar vdd precharge_0
Xpre_column_88 bl_88 br_88 en_bar vdd precharge_0
Xpre_column_89 bl_89 br_89 en_bar vdd precharge_0
Xpre_column_90 bl_90 br_90 en_bar vdd precharge_0
Xpre_column_91 bl_91 br_91 en_bar vdd precharge_0
Xpre_column_92 bl_92 br_92 en_bar vdd precharge_0
Xpre_column_93 bl_93 br_93 en_bar vdd precharge_0
Xpre_column_94 bl_94 br_94 en_bar vdd precharge_0
Xpre_column_95 bl_95 br_95 en_bar vdd precharge_0
Xpre_column_96 bl_96 br_96 en_bar vdd precharge_0
Xpre_column_97 bl_97 br_97 en_bar vdd precharge_0
Xpre_column_98 bl_98 br_98 en_bar vdd precharge_0
Xpre_column_99 bl_99 br_99 en_bar vdd precharge_0
Xpre_column_100 bl_100 br_100 en_bar vdd precharge_0
Xpre_column_101 bl_101 br_101 en_bar vdd precharge_0
Xpre_column_102 bl_102 br_102 en_bar vdd precharge_0
Xpre_column_103 bl_103 br_103 en_bar vdd precharge_0
Xpre_column_104 bl_104 br_104 en_bar vdd precharge_0
Xpre_column_105 bl_105 br_105 en_bar vdd precharge_0
Xpre_column_106 bl_106 br_106 en_bar vdd precharge_0
Xpre_column_107 bl_107 br_107 en_bar vdd precharge_0
Xpre_column_108 bl_108 br_108 en_bar vdd precharge_0
Xpre_column_109 bl_109 br_109 en_bar vdd precharge_0
Xpre_column_110 bl_110 br_110 en_bar vdd precharge_0
Xpre_column_111 bl_111 br_111 en_bar vdd precharge_0
Xpre_column_112 bl_112 br_112 en_bar vdd precharge_0
Xpre_column_113 bl_113 br_113 en_bar vdd precharge_0
Xpre_column_114 bl_114 br_114 en_bar vdd precharge_0
Xpre_column_115 bl_115 br_115 en_bar vdd precharge_0
Xpre_column_116 bl_116 br_116 en_bar vdd precharge_0
Xpre_column_117 bl_117 br_117 en_bar vdd precharge_0
Xpre_column_118 bl_118 br_118 en_bar vdd precharge_0
Xpre_column_119 bl_119 br_119 en_bar vdd precharge_0
Xpre_column_120 bl_120 br_120 en_bar vdd precharge_0
Xpre_column_121 bl_121 br_121 en_bar vdd precharge_0
Xpre_column_122 bl_122 br_122 en_bar vdd precharge_0
Xpre_column_123 bl_123 br_123 en_bar vdd precharge_0
Xpre_column_124 bl_124 br_124 en_bar vdd precharge_0
Xpre_column_125 bl_125 br_125 en_bar vdd precharge_0
Xpre_column_126 bl_126 br_126 en_bar vdd precharge_0
Xpre_column_127 bl_127 br_127 en_bar vdd precharge_0
Xpre_column_128 bl_128 br_128 en_bar vdd precharge_0
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

.SUBCKT sense_amp_array data_0 bl_0 br_0 data_1 bl_1 br_1 data_2 bl_2 br_2 data_3 bl_3 br_3 data_4 bl_4 br_4 data_5 bl_5 br_5 data_6 bl_6 br_6 data_7 bl_7 br_7 data_8 bl_8 br_8 data_9 bl_9 br_9 data_10 bl_10 br_10 data_11 bl_11 br_11 data_12 bl_12 br_12 data_13 bl_13 br_13 data_14 bl_14 br_14 data_15 bl_15 br_15 data_16 bl_16 br_16 data_17 bl_17 br_17 data_18 bl_18 br_18 data_19 bl_19 br_19 data_20 bl_20 br_20 data_21 bl_21 br_21 data_22 bl_22 br_22 data_23 bl_23 br_23 data_24 bl_24 br_24 data_25 bl_25 br_25 data_26 bl_26 br_26 data_27 bl_27 br_27 data_28 bl_28 br_28 data_29 bl_29 br_29 data_30 bl_30 br_30 data_31 bl_31 br_31 data_32 bl_32 br_32 data_33 bl_33 br_33 data_34 bl_34 br_34 data_35 bl_35 br_35 data_36 bl_36 br_36 data_37 bl_37 br_37 data_38 bl_38 br_38 data_39 bl_39 br_39 data_40 bl_40 br_40 data_41 bl_41 br_41 data_42 bl_42 br_42 data_43 bl_43 br_43 data_44 bl_44 br_44 data_45 bl_45 br_45 data_46 bl_46 br_46 data_47 bl_47 br_47 data_48 bl_48 br_48 data_49 bl_49 br_49 data_50 bl_50 br_50 data_51 bl_51 br_51 data_52 bl_52 br_52 data_53 bl_53 br_53 data_54 bl_54 br_54 data_55 bl_55 br_55 data_56 bl_56 br_56 data_57 bl_57 br_57 data_58 bl_58 br_58 data_59 bl_59 br_59 data_60 bl_60 br_60 data_61 bl_61 br_61 data_62 bl_62 br_62 data_63 bl_63 br_63 en vdd gnd
*.PININFO data_0:O bl_0:I br_0:I data_1:O bl_1:I br_1:I data_2:O bl_2:I br_2:I data_3:O bl_3:I br_3:I data_4:O bl_4:I br_4:I data_5:O bl_5:I br_5:I data_6:O bl_6:I br_6:I data_7:O bl_7:I br_7:I data_8:O bl_8:I br_8:I data_9:O bl_9:I br_9:I data_10:O bl_10:I br_10:I data_11:O bl_11:I br_11:I data_12:O bl_12:I br_12:I data_13:O bl_13:I br_13:I data_14:O bl_14:I br_14:I data_15:O bl_15:I br_15:I data_16:O bl_16:I br_16:I data_17:O bl_17:I br_17:I data_18:O bl_18:I br_18:I data_19:O bl_19:I br_19:I data_20:O bl_20:I br_20:I data_21:O bl_21:I br_21:I data_22:O bl_22:I br_22:I data_23:O bl_23:I br_23:I data_24:O bl_24:I br_24:I data_25:O bl_25:I br_25:I data_26:O bl_26:I br_26:I data_27:O bl_27:I br_27:I data_28:O bl_28:I br_28:I data_29:O bl_29:I br_29:I data_30:O bl_30:I br_30:I data_31:O bl_31:I br_31:I data_32:O bl_32:I br_32:I data_33:O bl_33:I br_33:I data_34:O bl_34:I br_34:I data_35:O bl_35:I br_35:I data_36:O bl_36:I br_36:I data_37:O bl_37:I br_37:I data_38:O bl_38:I br_38:I data_39:O bl_39:I br_39:I data_40:O bl_40:I br_40:I data_41:O bl_41:I br_41:I data_42:O bl_42:I br_42:I data_43:O bl_43:I br_43:I data_44:O bl_44:I br_44:I data_45:O bl_45:I br_45:I data_46:O bl_46:I br_46:I data_47:O bl_47:I br_47:I data_48:O bl_48:I br_48:I data_49:O bl_49:I br_49:I data_50:O bl_50:I br_50:I data_51:O bl_51:I br_51:I data_52:O bl_52:I br_52:I data_53:O bl_53:I br_53:I data_54:O bl_54:I br_54:I data_55:O bl_55:I br_55:I data_56:O bl_56:I br_56:I data_57:O bl_57:I br_57:I data_58:O bl_58:I br_58:I data_59:O bl_59:I br_59:I data_60:O bl_60:I br_60:I data_61:O bl_61:I br_61:I data_62:O bl_62:I br_62:I data_63:O bl_63:I br_63:I en:I vdd:B gnd:B
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
* OUTPUT: data_44 
* INPUT : bl_44 
* INPUT : br_44 
* OUTPUT: data_45 
* INPUT : bl_45 
* INPUT : br_45 
* OUTPUT: data_46 
* INPUT : bl_46 
* INPUT : br_46 
* OUTPUT: data_47 
* INPUT : bl_47 
* INPUT : br_47 
* OUTPUT: data_48 
* INPUT : bl_48 
* INPUT : br_48 
* OUTPUT: data_49 
* INPUT : bl_49 
* INPUT : br_49 
* OUTPUT: data_50 
* INPUT : bl_50 
* INPUT : br_50 
* OUTPUT: data_51 
* INPUT : bl_51 
* INPUT : br_51 
* OUTPUT: data_52 
* INPUT : bl_52 
* INPUT : br_52 
* OUTPUT: data_53 
* INPUT : bl_53 
* INPUT : br_53 
* OUTPUT: data_54 
* INPUT : bl_54 
* INPUT : br_54 
* OUTPUT: data_55 
* INPUT : bl_55 
* INPUT : br_55 
* OUTPUT: data_56 
* INPUT : bl_56 
* INPUT : br_56 
* OUTPUT: data_57 
* INPUT : bl_57 
* INPUT : br_57 
* OUTPUT: data_58 
* INPUT : bl_58 
* INPUT : br_58 
* OUTPUT: data_59 
* INPUT : bl_59 
* INPUT : br_59 
* OUTPUT: data_60 
* INPUT : bl_60 
* INPUT : br_60 
* OUTPUT: data_61 
* INPUT : bl_61 
* INPUT : br_61 
* OUTPUT: data_62 
* INPUT : bl_62 
* INPUT : br_62 
* OUTPUT: data_63 
* INPUT : bl_63 
* INPUT : br_63 
* INPUT : en 
* POWER : vdd 
* GROUND: gnd 
* words_per_row: 2
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
Xsa_d44 bl_44 br_44 data_44 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d45 bl_45 br_45 data_45 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d46 bl_46 br_46 data_46 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d47 bl_47 br_47 data_47 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d48 bl_48 br_48 data_48 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d49 bl_49 br_49 data_49 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d50 bl_50 br_50 data_50 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d51 bl_51 br_51 data_51 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d52 bl_52 br_52 data_52 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d53 bl_53 br_53 data_53 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d54 bl_54 br_54 data_54 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d55 bl_55 br_55 data_55 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d56 bl_56 br_56 data_56 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d57 bl_57 br_57 data_57 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d58 bl_58 br_58 data_58 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d59 bl_59 br_59 data_59 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d60 bl_60 br_60 data_60 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d61 bl_61 br_61 data_61 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d62 bl_62 br_62 data_62 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
Xsa_d63 bl_63 br_63 data_63 en vdd gnd sky130_fd_bd_sram__openram_sense_amp
.ENDS sense_amp_array

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=1 w=2.88 l=0.15 pd=6.06 ps=6.06 as=1.08u ad=1.08u

.SUBCKT column_mux bl br bl_out br_out sel gnd
*.PININFO bl:B br:B bl_out:B br_out:B sel:B gnd:B
* INOUT : bl 
* INOUT : br 
* INOUT : bl_out 
* INOUT : br_out 
* INOUT : sel 
* INOUT : gnd 
Xmux_tx1 bl sel bl_out gnd sky130_fd_pr__nfet_01v8 m=1 w=2.88u l=0.15u
Xmux_tx2 br sel br_out gnd sky130_fd_pr__nfet_01v8 m=1 w=2.88u l=0.15u
.ENDS column_mux

.SUBCKT column_mux_array bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 sel_0 sel_1 bl_out_0 br_out_0 bl_out_1 br_out_1 bl_out_2 br_out_2 bl_out_3 br_out_3 bl_out_4 br_out_4 bl_out_5 br_out_5 bl_out_6 br_out_6 bl_out_7 br_out_7 bl_out_8 br_out_8 bl_out_9 br_out_9 bl_out_10 br_out_10 bl_out_11 br_out_11 bl_out_12 br_out_12 bl_out_13 br_out_13 bl_out_14 br_out_14 bl_out_15 br_out_15 bl_out_16 br_out_16 bl_out_17 br_out_17 bl_out_18 br_out_18 bl_out_19 br_out_19 bl_out_20 br_out_20 bl_out_21 br_out_21 bl_out_22 br_out_22 bl_out_23 br_out_23 bl_out_24 br_out_24 bl_out_25 br_out_25 bl_out_26 br_out_26 bl_out_27 br_out_27 bl_out_28 br_out_28 bl_out_29 br_out_29 bl_out_30 br_out_30 bl_out_31 br_out_31 bl_out_32 br_out_32 bl_out_33 br_out_33 bl_out_34 br_out_34 bl_out_35 br_out_35 bl_out_36 br_out_36 bl_out_37 br_out_37 bl_out_38 br_out_38 bl_out_39 br_out_39 bl_out_40 br_out_40 bl_out_41 br_out_41 bl_out_42 br_out_42 bl_out_43 br_out_43 bl_out_44 br_out_44 bl_out_45 br_out_45 bl_out_46 br_out_46 bl_out_47 br_out_47 bl_out_48 br_out_48 bl_out_49 br_out_49 bl_out_50 br_out_50 bl_out_51 br_out_51 bl_out_52 br_out_52 bl_out_53 br_out_53 bl_out_54 br_out_54 bl_out_55 br_out_55 bl_out_56 br_out_56 bl_out_57 br_out_57 bl_out_58 br_out_58 bl_out_59 br_out_59 bl_out_60 br_out_60 bl_out_61 br_out_61 bl_out_62 br_out_62 bl_out_63 br_out_63 gnd
*.PININFO bl_0:B br_0:B bl_1:B br_1:B bl_2:B br_2:B bl_3:B br_3:B bl_4:B br_4:B bl_5:B br_5:B bl_6:B br_6:B bl_7:B br_7:B bl_8:B br_8:B bl_9:B br_9:B bl_10:B br_10:B bl_11:B br_11:B bl_12:B br_12:B bl_13:B br_13:B bl_14:B br_14:B bl_15:B br_15:B bl_16:B br_16:B bl_17:B br_17:B bl_18:B br_18:B bl_19:B br_19:B bl_20:B br_20:B bl_21:B br_21:B bl_22:B br_22:B bl_23:B br_23:B bl_24:B br_24:B bl_25:B br_25:B bl_26:B br_26:B bl_27:B br_27:B bl_28:B br_28:B bl_29:B br_29:B bl_30:B br_30:B bl_31:B br_31:B bl_32:B br_32:B bl_33:B br_33:B bl_34:B br_34:B bl_35:B br_35:B bl_36:B br_36:B bl_37:B br_37:B bl_38:B br_38:B bl_39:B br_39:B bl_40:B br_40:B bl_41:B br_41:B bl_42:B br_42:B bl_43:B br_43:B bl_44:B br_44:B bl_45:B br_45:B bl_46:B br_46:B bl_47:B br_47:B bl_48:B br_48:B bl_49:B br_49:B bl_50:B br_50:B bl_51:B br_51:B bl_52:B br_52:B bl_53:B br_53:B bl_54:B br_54:B bl_55:B br_55:B bl_56:B br_56:B bl_57:B br_57:B bl_58:B br_58:B bl_59:B br_59:B bl_60:B br_60:B bl_61:B br_61:B bl_62:B br_62:B bl_63:B br_63:B bl_64:B br_64:B bl_65:B br_65:B bl_66:B br_66:B bl_67:B br_67:B bl_68:B br_68:B bl_69:B br_69:B bl_70:B br_70:B bl_71:B br_71:B bl_72:B br_72:B bl_73:B br_73:B bl_74:B br_74:B bl_75:B br_75:B bl_76:B br_76:B bl_77:B br_77:B bl_78:B br_78:B bl_79:B br_79:B bl_80:B br_80:B bl_81:B br_81:B bl_82:B br_82:B bl_83:B br_83:B bl_84:B br_84:B bl_85:B br_85:B bl_86:B br_86:B bl_87:B br_87:B bl_88:B br_88:B bl_89:B br_89:B bl_90:B br_90:B bl_91:B br_91:B bl_92:B br_92:B bl_93:B br_93:B bl_94:B br_94:B bl_95:B br_95:B bl_96:B br_96:B bl_97:B br_97:B bl_98:B br_98:B bl_99:B br_99:B bl_100:B br_100:B bl_101:B br_101:B bl_102:B br_102:B bl_103:B br_103:B bl_104:B br_104:B bl_105:B br_105:B bl_106:B br_106:B bl_107:B br_107:B bl_108:B br_108:B bl_109:B br_109:B bl_110:B br_110:B bl_111:B br_111:B bl_112:B br_112:B bl_113:B br_113:B bl_114:B br_114:B bl_115:B br_115:B bl_116:B br_116:B bl_117:B br_117:B bl_118:B br_118:B bl_119:B br_119:B bl_120:B br_120:B bl_121:B br_121:B bl_122:B br_122:B bl_123:B br_123:B bl_124:B br_124:B bl_125:B br_125:B bl_126:B br_126:B bl_127:B br_127:B sel_0:B sel_1:B bl_out_0:B br_out_0:B bl_out_1:B br_out_1:B bl_out_2:B br_out_2:B bl_out_3:B br_out_3:B bl_out_4:B br_out_4:B bl_out_5:B br_out_5:B bl_out_6:B br_out_6:B bl_out_7:B br_out_7:B bl_out_8:B br_out_8:B bl_out_9:B br_out_9:B bl_out_10:B br_out_10:B bl_out_11:B br_out_11:B bl_out_12:B br_out_12:B bl_out_13:B br_out_13:B bl_out_14:B br_out_14:B bl_out_15:B br_out_15:B bl_out_16:B br_out_16:B bl_out_17:B br_out_17:B bl_out_18:B br_out_18:B bl_out_19:B br_out_19:B bl_out_20:B br_out_20:B bl_out_21:B br_out_21:B bl_out_22:B br_out_22:B bl_out_23:B br_out_23:B bl_out_24:B br_out_24:B bl_out_25:B br_out_25:B bl_out_26:B br_out_26:B bl_out_27:B br_out_27:B bl_out_28:B br_out_28:B bl_out_29:B br_out_29:B bl_out_30:B br_out_30:B bl_out_31:B br_out_31:B bl_out_32:B br_out_32:B bl_out_33:B br_out_33:B bl_out_34:B br_out_34:B bl_out_35:B br_out_35:B bl_out_36:B br_out_36:B bl_out_37:B br_out_37:B bl_out_38:B br_out_38:B bl_out_39:B br_out_39:B bl_out_40:B br_out_40:B bl_out_41:B br_out_41:B bl_out_42:B br_out_42:B bl_out_43:B br_out_43:B bl_out_44:B br_out_44:B bl_out_45:B br_out_45:B bl_out_46:B br_out_46:B bl_out_47:B br_out_47:B bl_out_48:B br_out_48:B bl_out_49:B br_out_49:B bl_out_50:B br_out_50:B bl_out_51:B br_out_51:B bl_out_52:B br_out_52:B bl_out_53:B br_out_53:B bl_out_54:B br_out_54:B bl_out_55:B br_out_55:B bl_out_56:B br_out_56:B bl_out_57:B br_out_57:B bl_out_58:B br_out_58:B bl_out_59:B br_out_59:B bl_out_60:B br_out_60:B bl_out_61:B br_out_61:B bl_out_62:B br_out_62:B bl_out_63:B br_out_63:B gnd:B
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
* INOUT : bl_44 
* INOUT : br_44 
* INOUT : bl_45 
* INOUT : br_45 
* INOUT : bl_46 
* INOUT : br_46 
* INOUT : bl_47 
* INOUT : br_47 
* INOUT : bl_48 
* INOUT : br_48 
* INOUT : bl_49 
* INOUT : br_49 
* INOUT : bl_50 
* INOUT : br_50 
* INOUT : bl_51 
* INOUT : br_51 
* INOUT : bl_52 
* INOUT : br_52 
* INOUT : bl_53 
* INOUT : br_53 
* INOUT : bl_54 
* INOUT : br_54 
* INOUT : bl_55 
* INOUT : br_55 
* INOUT : bl_56 
* INOUT : br_56 
* INOUT : bl_57 
* INOUT : br_57 
* INOUT : bl_58 
* INOUT : br_58 
* INOUT : bl_59 
* INOUT : br_59 
* INOUT : bl_60 
* INOUT : br_60 
* INOUT : bl_61 
* INOUT : br_61 
* INOUT : bl_62 
* INOUT : br_62 
* INOUT : bl_63 
* INOUT : br_63 
* INOUT : bl_64 
* INOUT : br_64 
* INOUT : bl_65 
* INOUT : br_65 
* INOUT : bl_66 
* INOUT : br_66 
* INOUT : bl_67 
* INOUT : br_67 
* INOUT : bl_68 
* INOUT : br_68 
* INOUT : bl_69 
* INOUT : br_69 
* INOUT : bl_70 
* INOUT : br_70 
* INOUT : bl_71 
* INOUT : br_71 
* INOUT : bl_72 
* INOUT : br_72 
* INOUT : bl_73 
* INOUT : br_73 
* INOUT : bl_74 
* INOUT : br_74 
* INOUT : bl_75 
* INOUT : br_75 
* INOUT : bl_76 
* INOUT : br_76 
* INOUT : bl_77 
* INOUT : br_77 
* INOUT : bl_78 
* INOUT : br_78 
* INOUT : bl_79 
* INOUT : br_79 
* INOUT : bl_80 
* INOUT : br_80 
* INOUT : bl_81 
* INOUT : br_81 
* INOUT : bl_82 
* INOUT : br_82 
* INOUT : bl_83 
* INOUT : br_83 
* INOUT : bl_84 
* INOUT : br_84 
* INOUT : bl_85 
* INOUT : br_85 
* INOUT : bl_86 
* INOUT : br_86 
* INOUT : bl_87 
* INOUT : br_87 
* INOUT : bl_88 
* INOUT : br_88 
* INOUT : bl_89 
* INOUT : br_89 
* INOUT : bl_90 
* INOUT : br_90 
* INOUT : bl_91 
* INOUT : br_91 
* INOUT : bl_92 
* INOUT : br_92 
* INOUT : bl_93 
* INOUT : br_93 
* INOUT : bl_94 
* INOUT : br_94 
* INOUT : bl_95 
* INOUT : br_95 
* INOUT : bl_96 
* INOUT : br_96 
* INOUT : bl_97 
* INOUT : br_97 
* INOUT : bl_98 
* INOUT : br_98 
* INOUT : bl_99 
* INOUT : br_99 
* INOUT : bl_100 
* INOUT : br_100 
* INOUT : bl_101 
* INOUT : br_101 
* INOUT : bl_102 
* INOUT : br_102 
* INOUT : bl_103 
* INOUT : br_103 
* INOUT : bl_104 
* INOUT : br_104 
* INOUT : bl_105 
* INOUT : br_105 
* INOUT : bl_106 
* INOUT : br_106 
* INOUT : bl_107 
* INOUT : br_107 
* INOUT : bl_108 
* INOUT : br_108 
* INOUT : bl_109 
* INOUT : br_109 
* INOUT : bl_110 
* INOUT : br_110 
* INOUT : bl_111 
* INOUT : br_111 
* INOUT : bl_112 
* INOUT : br_112 
* INOUT : bl_113 
* INOUT : br_113 
* INOUT : bl_114 
* INOUT : br_114 
* INOUT : bl_115 
* INOUT : br_115 
* INOUT : bl_116 
* INOUT : br_116 
* INOUT : bl_117 
* INOUT : br_117 
* INOUT : bl_118 
* INOUT : br_118 
* INOUT : bl_119 
* INOUT : br_119 
* INOUT : bl_120 
* INOUT : br_120 
* INOUT : bl_121 
* INOUT : br_121 
* INOUT : bl_122 
* INOUT : br_122 
* INOUT : bl_123 
* INOUT : br_123 
* INOUT : bl_124 
* INOUT : br_124 
* INOUT : bl_125 
* INOUT : br_125 
* INOUT : bl_126 
* INOUT : br_126 
* INOUT : bl_127 
* INOUT : br_127 
* INOUT : sel_0 
* INOUT : sel_1 
* INOUT : bl_out_0 
* INOUT : br_out_0 
* INOUT : bl_out_1 
* INOUT : br_out_1 
* INOUT : bl_out_2 
* INOUT : br_out_2 
* INOUT : bl_out_3 
* INOUT : br_out_3 
* INOUT : bl_out_4 
* INOUT : br_out_4 
* INOUT : bl_out_5 
* INOUT : br_out_5 
* INOUT : bl_out_6 
* INOUT : br_out_6 
* INOUT : bl_out_7 
* INOUT : br_out_7 
* INOUT : bl_out_8 
* INOUT : br_out_8 
* INOUT : bl_out_9 
* INOUT : br_out_9 
* INOUT : bl_out_10 
* INOUT : br_out_10 
* INOUT : bl_out_11 
* INOUT : br_out_11 
* INOUT : bl_out_12 
* INOUT : br_out_12 
* INOUT : bl_out_13 
* INOUT : br_out_13 
* INOUT : bl_out_14 
* INOUT : br_out_14 
* INOUT : bl_out_15 
* INOUT : br_out_15 
* INOUT : bl_out_16 
* INOUT : br_out_16 
* INOUT : bl_out_17 
* INOUT : br_out_17 
* INOUT : bl_out_18 
* INOUT : br_out_18 
* INOUT : bl_out_19 
* INOUT : br_out_19 
* INOUT : bl_out_20 
* INOUT : br_out_20 
* INOUT : bl_out_21 
* INOUT : br_out_21 
* INOUT : bl_out_22 
* INOUT : br_out_22 
* INOUT : bl_out_23 
* INOUT : br_out_23 
* INOUT : bl_out_24 
* INOUT : br_out_24 
* INOUT : bl_out_25 
* INOUT : br_out_25 
* INOUT : bl_out_26 
* INOUT : br_out_26 
* INOUT : bl_out_27 
* INOUT : br_out_27 
* INOUT : bl_out_28 
* INOUT : br_out_28 
* INOUT : bl_out_29 
* INOUT : br_out_29 
* INOUT : bl_out_30 
* INOUT : br_out_30 
* INOUT : bl_out_31 
* INOUT : br_out_31 
* INOUT : bl_out_32 
* INOUT : br_out_32 
* INOUT : bl_out_33 
* INOUT : br_out_33 
* INOUT : bl_out_34 
* INOUT : br_out_34 
* INOUT : bl_out_35 
* INOUT : br_out_35 
* INOUT : bl_out_36 
* INOUT : br_out_36 
* INOUT : bl_out_37 
* INOUT : br_out_37 
* INOUT : bl_out_38 
* INOUT : br_out_38 
* INOUT : bl_out_39 
* INOUT : br_out_39 
* INOUT : bl_out_40 
* INOUT : br_out_40 
* INOUT : bl_out_41 
* INOUT : br_out_41 
* INOUT : bl_out_42 
* INOUT : br_out_42 
* INOUT : bl_out_43 
* INOUT : br_out_43 
* INOUT : bl_out_44 
* INOUT : br_out_44 
* INOUT : bl_out_45 
* INOUT : br_out_45 
* INOUT : bl_out_46 
* INOUT : br_out_46 
* INOUT : bl_out_47 
* INOUT : br_out_47 
* INOUT : bl_out_48 
* INOUT : br_out_48 
* INOUT : bl_out_49 
* INOUT : br_out_49 
* INOUT : bl_out_50 
* INOUT : br_out_50 
* INOUT : bl_out_51 
* INOUT : br_out_51 
* INOUT : bl_out_52 
* INOUT : br_out_52 
* INOUT : bl_out_53 
* INOUT : br_out_53 
* INOUT : bl_out_54 
* INOUT : br_out_54 
* INOUT : bl_out_55 
* INOUT : br_out_55 
* INOUT : bl_out_56 
* INOUT : br_out_56 
* INOUT : bl_out_57 
* INOUT : br_out_57 
* INOUT : bl_out_58 
* INOUT : br_out_58 
* INOUT : bl_out_59 
* INOUT : br_out_59 
* INOUT : bl_out_60 
* INOUT : br_out_60 
* INOUT : bl_out_61 
* INOUT : br_out_61 
* INOUT : bl_out_62 
* INOUT : br_out_62 
* INOUT : bl_out_63 
* INOUT : br_out_63 
* INOUT : gnd 
* cols: 128 word_size: 64 bl: bl0 br: br0
XXMUX0 bl_0 br_0 bl_out_0 br_out_0 sel_0 gnd column_mux
XXMUX1 bl_1 br_1 bl_out_0 br_out_0 sel_1 gnd column_mux
XXMUX2 bl_2 br_2 bl_out_1 br_out_1 sel_0 gnd column_mux
XXMUX3 bl_3 br_3 bl_out_1 br_out_1 sel_1 gnd column_mux
XXMUX4 bl_4 br_4 bl_out_2 br_out_2 sel_0 gnd column_mux
XXMUX5 bl_5 br_5 bl_out_2 br_out_2 sel_1 gnd column_mux
XXMUX6 bl_6 br_6 bl_out_3 br_out_3 sel_0 gnd column_mux
XXMUX7 bl_7 br_7 bl_out_3 br_out_3 sel_1 gnd column_mux
XXMUX8 bl_8 br_8 bl_out_4 br_out_4 sel_0 gnd column_mux
XXMUX9 bl_9 br_9 bl_out_4 br_out_4 sel_1 gnd column_mux
XXMUX10 bl_10 br_10 bl_out_5 br_out_5 sel_0 gnd column_mux
XXMUX11 bl_11 br_11 bl_out_5 br_out_5 sel_1 gnd column_mux
XXMUX12 bl_12 br_12 bl_out_6 br_out_6 sel_0 gnd column_mux
XXMUX13 bl_13 br_13 bl_out_6 br_out_6 sel_1 gnd column_mux
XXMUX14 bl_14 br_14 bl_out_7 br_out_7 sel_0 gnd column_mux
XXMUX15 bl_15 br_15 bl_out_7 br_out_7 sel_1 gnd column_mux
XXMUX16 bl_16 br_16 bl_out_8 br_out_8 sel_0 gnd column_mux
XXMUX17 bl_17 br_17 bl_out_8 br_out_8 sel_1 gnd column_mux
XXMUX18 bl_18 br_18 bl_out_9 br_out_9 sel_0 gnd column_mux
XXMUX19 bl_19 br_19 bl_out_9 br_out_9 sel_1 gnd column_mux
XXMUX20 bl_20 br_20 bl_out_10 br_out_10 sel_0 gnd column_mux
XXMUX21 bl_21 br_21 bl_out_10 br_out_10 sel_1 gnd column_mux
XXMUX22 bl_22 br_22 bl_out_11 br_out_11 sel_0 gnd column_mux
XXMUX23 bl_23 br_23 bl_out_11 br_out_11 sel_1 gnd column_mux
XXMUX24 bl_24 br_24 bl_out_12 br_out_12 sel_0 gnd column_mux
XXMUX25 bl_25 br_25 bl_out_12 br_out_12 sel_1 gnd column_mux
XXMUX26 bl_26 br_26 bl_out_13 br_out_13 sel_0 gnd column_mux
XXMUX27 bl_27 br_27 bl_out_13 br_out_13 sel_1 gnd column_mux
XXMUX28 bl_28 br_28 bl_out_14 br_out_14 sel_0 gnd column_mux
XXMUX29 bl_29 br_29 bl_out_14 br_out_14 sel_1 gnd column_mux
XXMUX30 bl_30 br_30 bl_out_15 br_out_15 sel_0 gnd column_mux
XXMUX31 bl_31 br_31 bl_out_15 br_out_15 sel_1 gnd column_mux
XXMUX32 bl_32 br_32 bl_out_16 br_out_16 sel_0 gnd column_mux
XXMUX33 bl_33 br_33 bl_out_16 br_out_16 sel_1 gnd column_mux
XXMUX34 bl_34 br_34 bl_out_17 br_out_17 sel_0 gnd column_mux
XXMUX35 bl_35 br_35 bl_out_17 br_out_17 sel_1 gnd column_mux
XXMUX36 bl_36 br_36 bl_out_18 br_out_18 sel_0 gnd column_mux
XXMUX37 bl_37 br_37 bl_out_18 br_out_18 sel_1 gnd column_mux
XXMUX38 bl_38 br_38 bl_out_19 br_out_19 sel_0 gnd column_mux
XXMUX39 bl_39 br_39 bl_out_19 br_out_19 sel_1 gnd column_mux
XXMUX40 bl_40 br_40 bl_out_20 br_out_20 sel_0 gnd column_mux
XXMUX41 bl_41 br_41 bl_out_20 br_out_20 sel_1 gnd column_mux
XXMUX42 bl_42 br_42 bl_out_21 br_out_21 sel_0 gnd column_mux
XXMUX43 bl_43 br_43 bl_out_21 br_out_21 sel_1 gnd column_mux
XXMUX44 bl_44 br_44 bl_out_22 br_out_22 sel_0 gnd column_mux
XXMUX45 bl_45 br_45 bl_out_22 br_out_22 sel_1 gnd column_mux
XXMUX46 bl_46 br_46 bl_out_23 br_out_23 sel_0 gnd column_mux
XXMUX47 bl_47 br_47 bl_out_23 br_out_23 sel_1 gnd column_mux
XXMUX48 bl_48 br_48 bl_out_24 br_out_24 sel_0 gnd column_mux
XXMUX49 bl_49 br_49 bl_out_24 br_out_24 sel_1 gnd column_mux
XXMUX50 bl_50 br_50 bl_out_25 br_out_25 sel_0 gnd column_mux
XXMUX51 bl_51 br_51 bl_out_25 br_out_25 sel_1 gnd column_mux
XXMUX52 bl_52 br_52 bl_out_26 br_out_26 sel_0 gnd column_mux
XXMUX53 bl_53 br_53 bl_out_26 br_out_26 sel_1 gnd column_mux
XXMUX54 bl_54 br_54 bl_out_27 br_out_27 sel_0 gnd column_mux
XXMUX55 bl_55 br_55 bl_out_27 br_out_27 sel_1 gnd column_mux
XXMUX56 bl_56 br_56 bl_out_28 br_out_28 sel_0 gnd column_mux
XXMUX57 bl_57 br_57 bl_out_28 br_out_28 sel_1 gnd column_mux
XXMUX58 bl_58 br_58 bl_out_29 br_out_29 sel_0 gnd column_mux
XXMUX59 bl_59 br_59 bl_out_29 br_out_29 sel_1 gnd column_mux
XXMUX60 bl_60 br_60 bl_out_30 br_out_30 sel_0 gnd column_mux
XXMUX61 bl_61 br_61 bl_out_30 br_out_30 sel_1 gnd column_mux
XXMUX62 bl_62 br_62 bl_out_31 br_out_31 sel_0 gnd column_mux
XXMUX63 bl_63 br_63 bl_out_31 br_out_31 sel_1 gnd column_mux
XXMUX64 bl_64 br_64 bl_out_32 br_out_32 sel_0 gnd column_mux
XXMUX65 bl_65 br_65 bl_out_32 br_out_32 sel_1 gnd column_mux
XXMUX66 bl_66 br_66 bl_out_33 br_out_33 sel_0 gnd column_mux
XXMUX67 bl_67 br_67 bl_out_33 br_out_33 sel_1 gnd column_mux
XXMUX68 bl_68 br_68 bl_out_34 br_out_34 sel_0 gnd column_mux
XXMUX69 bl_69 br_69 bl_out_34 br_out_34 sel_1 gnd column_mux
XXMUX70 bl_70 br_70 bl_out_35 br_out_35 sel_0 gnd column_mux
XXMUX71 bl_71 br_71 bl_out_35 br_out_35 sel_1 gnd column_mux
XXMUX72 bl_72 br_72 bl_out_36 br_out_36 sel_0 gnd column_mux
XXMUX73 bl_73 br_73 bl_out_36 br_out_36 sel_1 gnd column_mux
XXMUX74 bl_74 br_74 bl_out_37 br_out_37 sel_0 gnd column_mux
XXMUX75 bl_75 br_75 bl_out_37 br_out_37 sel_1 gnd column_mux
XXMUX76 bl_76 br_76 bl_out_38 br_out_38 sel_0 gnd column_mux
XXMUX77 bl_77 br_77 bl_out_38 br_out_38 sel_1 gnd column_mux
XXMUX78 bl_78 br_78 bl_out_39 br_out_39 sel_0 gnd column_mux
XXMUX79 bl_79 br_79 bl_out_39 br_out_39 sel_1 gnd column_mux
XXMUX80 bl_80 br_80 bl_out_40 br_out_40 sel_0 gnd column_mux
XXMUX81 bl_81 br_81 bl_out_40 br_out_40 sel_1 gnd column_mux
XXMUX82 bl_82 br_82 bl_out_41 br_out_41 sel_0 gnd column_mux
XXMUX83 bl_83 br_83 bl_out_41 br_out_41 sel_1 gnd column_mux
XXMUX84 bl_84 br_84 bl_out_42 br_out_42 sel_0 gnd column_mux
XXMUX85 bl_85 br_85 bl_out_42 br_out_42 sel_1 gnd column_mux
XXMUX86 bl_86 br_86 bl_out_43 br_out_43 sel_0 gnd column_mux
XXMUX87 bl_87 br_87 bl_out_43 br_out_43 sel_1 gnd column_mux
XXMUX88 bl_88 br_88 bl_out_44 br_out_44 sel_0 gnd column_mux
XXMUX89 bl_89 br_89 bl_out_44 br_out_44 sel_1 gnd column_mux
XXMUX90 bl_90 br_90 bl_out_45 br_out_45 sel_0 gnd column_mux
XXMUX91 bl_91 br_91 bl_out_45 br_out_45 sel_1 gnd column_mux
XXMUX92 bl_92 br_92 bl_out_46 br_out_46 sel_0 gnd column_mux
XXMUX93 bl_93 br_93 bl_out_46 br_out_46 sel_1 gnd column_mux
XXMUX94 bl_94 br_94 bl_out_47 br_out_47 sel_0 gnd column_mux
XXMUX95 bl_95 br_95 bl_out_47 br_out_47 sel_1 gnd column_mux
XXMUX96 bl_96 br_96 bl_out_48 br_out_48 sel_0 gnd column_mux
XXMUX97 bl_97 br_97 bl_out_48 br_out_48 sel_1 gnd column_mux
XXMUX98 bl_98 br_98 bl_out_49 br_out_49 sel_0 gnd column_mux
XXMUX99 bl_99 br_99 bl_out_49 br_out_49 sel_1 gnd column_mux
XXMUX100 bl_100 br_100 bl_out_50 br_out_50 sel_0 gnd column_mux
XXMUX101 bl_101 br_101 bl_out_50 br_out_50 sel_1 gnd column_mux
XXMUX102 bl_102 br_102 bl_out_51 br_out_51 sel_0 gnd column_mux
XXMUX103 bl_103 br_103 bl_out_51 br_out_51 sel_1 gnd column_mux
XXMUX104 bl_104 br_104 bl_out_52 br_out_52 sel_0 gnd column_mux
XXMUX105 bl_105 br_105 bl_out_52 br_out_52 sel_1 gnd column_mux
XXMUX106 bl_106 br_106 bl_out_53 br_out_53 sel_0 gnd column_mux
XXMUX107 bl_107 br_107 bl_out_53 br_out_53 sel_1 gnd column_mux
XXMUX108 bl_108 br_108 bl_out_54 br_out_54 sel_0 gnd column_mux
XXMUX109 bl_109 br_109 bl_out_54 br_out_54 sel_1 gnd column_mux
XXMUX110 bl_110 br_110 bl_out_55 br_out_55 sel_0 gnd column_mux
XXMUX111 bl_111 br_111 bl_out_55 br_out_55 sel_1 gnd column_mux
XXMUX112 bl_112 br_112 bl_out_56 br_out_56 sel_0 gnd column_mux
XXMUX113 bl_113 br_113 bl_out_56 br_out_56 sel_1 gnd column_mux
XXMUX114 bl_114 br_114 bl_out_57 br_out_57 sel_0 gnd column_mux
XXMUX115 bl_115 br_115 bl_out_57 br_out_57 sel_1 gnd column_mux
XXMUX116 bl_116 br_116 bl_out_58 br_out_58 sel_0 gnd column_mux
XXMUX117 bl_117 br_117 bl_out_58 br_out_58 sel_1 gnd column_mux
XXMUX118 bl_118 br_118 bl_out_59 br_out_59 sel_0 gnd column_mux
XXMUX119 bl_119 br_119 bl_out_59 br_out_59 sel_1 gnd column_mux
XXMUX120 bl_120 br_120 bl_out_60 br_out_60 sel_0 gnd column_mux
XXMUX121 bl_121 br_121 bl_out_60 br_out_60 sel_1 gnd column_mux
XXMUX122 bl_122 br_122 bl_out_61 br_out_61 sel_0 gnd column_mux
XXMUX123 bl_123 br_123 bl_out_61 br_out_61 sel_1 gnd column_mux
XXMUX124 bl_124 br_124 bl_out_62 br_out_62 sel_0 gnd column_mux
XXMUX125 bl_125 br_125 bl_out_62 br_out_62 sel_1 gnd column_mux
XXMUX126 bl_126 br_126 bl_out_63 br_out_63 sel_0 gnd column_mux
XXMUX127 bl_127 br_127 bl_out_63 br_out_63 sel_1 gnd column_mux
.ENDS column_mux_array
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

.SUBCKT write_driver_array data_0 data_1 data_2 data_3 data_4 data_5 data_6 data_7 data_8 data_9 data_10 data_11 data_12 data_13 data_14 data_15 data_16 data_17 data_18 data_19 data_20 data_21 data_22 data_23 data_24 data_25 data_26 data_27 data_28 data_29 data_30 data_31 data_32 data_33 data_34 data_35 data_36 data_37 data_38 data_39 data_40 data_41 data_42 data_43 data_44 data_45 data_46 data_47 data_48 data_49 data_50 data_51 data_52 data_53 data_54 data_55 data_56 data_57 data_58 data_59 data_60 data_61 data_62 data_63 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 en_0 en_1 en_2 en_3 en_4 en_5 en_6 en_7 vdd gnd
*.PININFO data_0:I data_1:I data_2:I data_3:I data_4:I data_5:I data_6:I data_7:I data_8:I data_9:I data_10:I data_11:I data_12:I data_13:I data_14:I data_15:I data_16:I data_17:I data_18:I data_19:I data_20:I data_21:I data_22:I data_23:I data_24:I data_25:I data_26:I data_27:I data_28:I data_29:I data_30:I data_31:I data_32:I data_33:I data_34:I data_35:I data_36:I data_37:I data_38:I data_39:I data_40:I data_41:I data_42:I data_43:I data_44:I data_45:I data_46:I data_47:I data_48:I data_49:I data_50:I data_51:I data_52:I data_53:I data_54:I data_55:I data_56:I data_57:I data_58:I data_59:I data_60:I data_61:I data_62:I data_63:I bl_0:O br_0:O bl_1:O br_1:O bl_2:O br_2:O bl_3:O br_3:O bl_4:O br_4:O bl_5:O br_5:O bl_6:O br_6:O bl_7:O br_7:O bl_8:O br_8:O bl_9:O br_9:O bl_10:O br_10:O bl_11:O br_11:O bl_12:O br_12:O bl_13:O br_13:O bl_14:O br_14:O bl_15:O br_15:O bl_16:O br_16:O bl_17:O br_17:O bl_18:O br_18:O bl_19:O br_19:O bl_20:O br_20:O bl_21:O br_21:O bl_22:O br_22:O bl_23:O br_23:O bl_24:O br_24:O bl_25:O br_25:O bl_26:O br_26:O bl_27:O br_27:O bl_28:O br_28:O bl_29:O br_29:O bl_30:O br_30:O bl_31:O br_31:O bl_32:O br_32:O bl_33:O br_33:O bl_34:O br_34:O bl_35:O br_35:O bl_36:O br_36:O bl_37:O br_37:O bl_38:O br_38:O bl_39:O br_39:O bl_40:O br_40:O bl_41:O br_41:O bl_42:O br_42:O bl_43:O br_43:O bl_44:O br_44:O bl_45:O br_45:O bl_46:O br_46:O bl_47:O br_47:O bl_48:O br_48:O bl_49:O br_49:O bl_50:O br_50:O bl_51:O br_51:O bl_52:O br_52:O bl_53:O br_53:O bl_54:O br_54:O bl_55:O br_55:O bl_56:O br_56:O bl_57:O br_57:O bl_58:O br_58:O bl_59:O br_59:O bl_60:O br_60:O bl_61:O br_61:O bl_62:O br_62:O bl_63:O br_63:O en_0:I en_1:I en_2:I en_3:I en_4:I en_5:I en_6:I en_7:I vdd:B gnd:B
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
* INPUT : data_44 
* INPUT : data_45 
* INPUT : data_46 
* INPUT : data_47 
* INPUT : data_48 
* INPUT : data_49 
* INPUT : data_50 
* INPUT : data_51 
* INPUT : data_52 
* INPUT : data_53 
* INPUT : data_54 
* INPUT : data_55 
* INPUT : data_56 
* INPUT : data_57 
* INPUT : data_58 
* INPUT : data_59 
* INPUT : data_60 
* INPUT : data_61 
* INPUT : data_62 
* INPUT : data_63 
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
* OUTPUT: bl_45 
* OUTPUT: br_45 
* OUTPUT: bl_46 
* OUTPUT: br_46 
* OUTPUT: bl_47 
* OUTPUT: br_47 
* OUTPUT: bl_48 
* OUTPUT: br_48 
* OUTPUT: bl_49 
* OUTPUT: br_49 
* OUTPUT: bl_50 
* OUTPUT: br_50 
* OUTPUT: bl_51 
* OUTPUT: br_51 
* OUTPUT: bl_52 
* OUTPUT: br_52 
* OUTPUT: bl_53 
* OUTPUT: br_53 
* OUTPUT: bl_54 
* OUTPUT: br_54 
* OUTPUT: bl_55 
* OUTPUT: br_55 
* OUTPUT: bl_56 
* OUTPUT: br_56 
* OUTPUT: bl_57 
* OUTPUT: br_57 
* OUTPUT: bl_58 
* OUTPUT: br_58 
* OUTPUT: bl_59 
* OUTPUT: br_59 
* OUTPUT: bl_60 
* OUTPUT: br_60 
* OUTPUT: bl_61 
* OUTPUT: br_61 
* OUTPUT: bl_62 
* OUTPUT: br_62 
* OUTPUT: bl_63 
* OUTPUT: br_63 
* INPUT : en_0 
* INPUT : en_1 
* INPUT : en_2 
* INPUT : en_3 
* INPUT : en_4 
* INPUT : en_5 
* INPUT : en_6 
* INPUT : en_7 
* POWER : vdd 
* GROUND: gnd 
* word_size 64
Xwrite_driver0 data_0 bl_0 br_0 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver2 data_1 bl_1 br_1 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver4 data_2 bl_2 br_2 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver6 data_3 bl_3 br_3 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver8 data_4 bl_4 br_4 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver10 data_5 bl_5 br_5 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver12 data_6 bl_6 br_6 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver14 data_7 bl_7 br_7 en_0 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver16 data_8 bl_8 br_8 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver18 data_9 bl_9 br_9 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver20 data_10 bl_10 br_10 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver22 data_11 bl_11 br_11 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver24 data_12 bl_12 br_12 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver26 data_13 bl_13 br_13 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver28 data_14 bl_14 br_14 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver30 data_15 bl_15 br_15 en_1 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver32 data_16 bl_16 br_16 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver34 data_17 bl_17 br_17 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver36 data_18 bl_18 br_18 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver38 data_19 bl_19 br_19 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver40 data_20 bl_20 br_20 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver42 data_21 bl_21 br_21 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver44 data_22 bl_22 br_22 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver46 data_23 bl_23 br_23 en_2 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver48 data_24 bl_24 br_24 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver50 data_25 bl_25 br_25 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver52 data_26 bl_26 br_26 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver54 data_27 bl_27 br_27 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver56 data_28 bl_28 br_28 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver58 data_29 bl_29 br_29 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver60 data_30 bl_30 br_30 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver62 data_31 bl_31 br_31 en_3 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver64 data_32 bl_32 br_32 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver66 data_33 bl_33 br_33 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver68 data_34 bl_34 br_34 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver70 data_35 bl_35 br_35 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver72 data_36 bl_36 br_36 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver74 data_37 bl_37 br_37 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver76 data_38 bl_38 br_38 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver78 data_39 bl_39 br_39 en_4 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver80 data_40 bl_40 br_40 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver82 data_41 bl_41 br_41 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver84 data_42 bl_42 br_42 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver86 data_43 bl_43 br_43 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver88 data_44 bl_44 br_44 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver90 data_45 bl_45 br_45 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver92 data_46 bl_46 br_46 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver94 data_47 bl_47 br_47 en_5 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver96 data_48 bl_48 br_48 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver98 data_49 bl_49 br_49 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver100 data_50 bl_50 br_50 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver102 data_51 bl_51 br_51 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver104 data_52 bl_52 br_52 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver106 data_53 bl_53 br_53 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver108 data_54 bl_54 br_54 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver110 data_55 bl_55 br_55 en_6 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver112 data_56 bl_56 br_56 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver114 data_57 bl_57 br_57 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver116 data_58 bl_58 br_58 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver118 data_59 bl_59 br_59 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver120 data_60 bl_60 br_60 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver122 data_61 bl_61 br_61 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver124 data_62 bl_62 br_62 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
Xwrite_driver126 data_63 bl_63 br_63 en_7 vdd gnd sky130_fd_bd_sram__openram_write_driver
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

.SUBCKT write_mask_and_array wmask_in_0 wmask_in_1 wmask_in_2 wmask_in_3 wmask_in_4 wmask_in_5 wmask_in_6 wmask_in_7 en wmask_out_0 wmask_out_1 wmask_out_2 wmask_out_3 wmask_out_4 wmask_out_5 wmask_out_6 wmask_out_7 vdd gnd
*.PININFO wmask_in_0:I wmask_in_1:I wmask_in_2:I wmask_in_3:I wmask_in_4:I wmask_in_5:I wmask_in_6:I wmask_in_7:I en:I wmask_out_0:O wmask_out_1:O wmask_out_2:O wmask_out_3:O wmask_out_4:O wmask_out_5:O wmask_out_6:O wmask_out_7:O vdd:B gnd:B
* INPUT : wmask_in_0 
* INPUT : wmask_in_1 
* INPUT : wmask_in_2 
* INPUT : wmask_in_3 
* INPUT : wmask_in_4 
* INPUT : wmask_in_5 
* INPUT : wmask_in_6 
* INPUT : wmask_in_7 
* INPUT : en 
* OUTPUT: wmask_out_0 
* OUTPUT: wmask_out_1 
* OUTPUT: wmask_out_2 
* OUTPUT: wmask_out_3 
* OUTPUT: wmask_out_4 
* OUTPUT: wmask_out_5 
* OUTPUT: wmask_out_6 
* OUTPUT: wmask_out_7 
* POWER : vdd 
* GROUND: gnd 
* write_size 8
Xand2_0 wmask_in_0 en wmask_out_0 vdd gnd pand2
Xand2_1 wmask_in_1 en wmask_out_1 vdd gnd pand2
Xand2_2 wmask_in_2 en wmask_out_2 vdd gnd pand2
Xand2_3 wmask_in_3 en wmask_out_3 vdd gnd pand2
Xand2_4 wmask_in_4 en wmask_out_4 vdd gnd pand2
Xand2_5 wmask_in_5 en wmask_out_5 vdd gnd pand2
Xand2_6 wmask_in_6 en wmask_out_6 vdd gnd pand2
Xand2_7 wmask_in_7 en wmask_out_7 vdd gnd pand2
.ENDS write_mask_and_array

.SUBCKT port_data rbl_bl rbl_br bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 dout_8 dout_9 dout_10 dout_11 dout_12 dout_13 dout_14 dout_15 dout_16 dout_17 dout_18 dout_19 dout_20 dout_21 dout_22 dout_23 dout_24 dout_25 dout_26 dout_27 dout_28 dout_29 dout_30 dout_31 dout_32 dout_33 dout_34 dout_35 dout_36 dout_37 dout_38 dout_39 dout_40 dout_41 dout_42 dout_43 dout_44 dout_45 dout_46 dout_47 dout_48 dout_49 dout_50 dout_51 dout_52 dout_53 dout_54 dout_55 dout_56 dout_57 dout_58 dout_59 dout_60 dout_61 dout_62 dout_63 din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 din_8 din_9 din_10 din_11 din_12 din_13 din_14 din_15 din_16 din_17 din_18 din_19 din_20 din_21 din_22 din_23 din_24 din_25 din_26 din_27 din_28 din_29 din_30 din_31 din_32 din_33 din_34 din_35 din_36 din_37 din_38 din_39 din_40 din_41 din_42 din_43 din_44 din_45 din_46 din_47 din_48 din_49 din_50 din_51 din_52 din_53 din_54 din_55 din_56 din_57 din_58 din_59 din_60 din_61 din_62 din_63 sel_0 sel_1 s_en p_en_bar w_en bank_wmask_0 bank_wmask_1 bank_wmask_2 bank_wmask_3 bank_wmask_4 bank_wmask_5 bank_wmask_6 bank_wmask_7 vdd gnd
*.PININFO rbl_bl:B rbl_br:B bl_0:B br_0:B bl_1:B br_1:B bl_2:B br_2:B bl_3:B br_3:B bl_4:B br_4:B bl_5:B br_5:B bl_6:B br_6:B bl_7:B br_7:B bl_8:B br_8:B bl_9:B br_9:B bl_10:B br_10:B bl_11:B br_11:B bl_12:B br_12:B bl_13:B br_13:B bl_14:B br_14:B bl_15:B br_15:B bl_16:B br_16:B bl_17:B br_17:B bl_18:B br_18:B bl_19:B br_19:B bl_20:B br_20:B bl_21:B br_21:B bl_22:B br_22:B bl_23:B br_23:B bl_24:B br_24:B bl_25:B br_25:B bl_26:B br_26:B bl_27:B br_27:B bl_28:B br_28:B bl_29:B br_29:B bl_30:B br_30:B bl_31:B br_31:B bl_32:B br_32:B bl_33:B br_33:B bl_34:B br_34:B bl_35:B br_35:B bl_36:B br_36:B bl_37:B br_37:B bl_38:B br_38:B bl_39:B br_39:B bl_40:B br_40:B bl_41:B br_41:B bl_42:B br_42:B bl_43:B br_43:B bl_44:B br_44:B bl_45:B br_45:B bl_46:B br_46:B bl_47:B br_47:B bl_48:B br_48:B bl_49:B br_49:B bl_50:B br_50:B bl_51:B br_51:B bl_52:B br_52:B bl_53:B br_53:B bl_54:B br_54:B bl_55:B br_55:B bl_56:B br_56:B bl_57:B br_57:B bl_58:B br_58:B bl_59:B br_59:B bl_60:B br_60:B bl_61:B br_61:B bl_62:B br_62:B bl_63:B br_63:B bl_64:B br_64:B bl_65:B br_65:B bl_66:B br_66:B bl_67:B br_67:B bl_68:B br_68:B bl_69:B br_69:B bl_70:B br_70:B bl_71:B br_71:B bl_72:B br_72:B bl_73:B br_73:B bl_74:B br_74:B bl_75:B br_75:B bl_76:B br_76:B bl_77:B br_77:B bl_78:B br_78:B bl_79:B br_79:B bl_80:B br_80:B bl_81:B br_81:B bl_82:B br_82:B bl_83:B br_83:B bl_84:B br_84:B bl_85:B br_85:B bl_86:B br_86:B bl_87:B br_87:B bl_88:B br_88:B bl_89:B br_89:B bl_90:B br_90:B bl_91:B br_91:B bl_92:B br_92:B bl_93:B br_93:B bl_94:B br_94:B bl_95:B br_95:B bl_96:B br_96:B bl_97:B br_97:B bl_98:B br_98:B bl_99:B br_99:B bl_100:B br_100:B bl_101:B br_101:B bl_102:B br_102:B bl_103:B br_103:B bl_104:B br_104:B bl_105:B br_105:B bl_106:B br_106:B bl_107:B br_107:B bl_108:B br_108:B bl_109:B br_109:B bl_110:B br_110:B bl_111:B br_111:B bl_112:B br_112:B bl_113:B br_113:B bl_114:B br_114:B bl_115:B br_115:B bl_116:B br_116:B bl_117:B br_117:B bl_118:B br_118:B bl_119:B br_119:B bl_120:B br_120:B bl_121:B br_121:B bl_122:B br_122:B bl_123:B br_123:B bl_124:B br_124:B bl_125:B br_125:B bl_126:B br_126:B bl_127:B br_127:B dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O dout_8:O dout_9:O dout_10:O dout_11:O dout_12:O dout_13:O dout_14:O dout_15:O dout_16:O dout_17:O dout_18:O dout_19:O dout_20:O dout_21:O dout_22:O dout_23:O dout_24:O dout_25:O dout_26:O dout_27:O dout_28:O dout_29:O dout_30:O dout_31:O dout_32:O dout_33:O dout_34:O dout_35:O dout_36:O dout_37:O dout_38:O dout_39:O dout_40:O dout_41:O dout_42:O dout_43:O dout_44:O dout_45:O dout_46:O dout_47:O dout_48:O dout_49:O dout_50:O dout_51:O dout_52:O dout_53:O dout_54:O dout_55:O dout_56:O dout_57:O dout_58:O dout_59:O dout_60:O dout_61:O dout_62:O dout_63:O din_0:I din_1:I din_2:I din_3:I din_4:I din_5:I din_6:I din_7:I din_8:I din_9:I din_10:I din_11:I din_12:I din_13:I din_14:I din_15:I din_16:I din_17:I din_18:I din_19:I din_20:I din_21:I din_22:I din_23:I din_24:I din_25:I din_26:I din_27:I din_28:I din_29:I din_30:I din_31:I din_32:I din_33:I din_34:I din_35:I din_36:I din_37:I din_38:I din_39:I din_40:I din_41:I din_42:I din_43:I din_44:I din_45:I din_46:I din_47:I din_48:I din_49:I din_50:I din_51:I din_52:I din_53:I din_54:I din_55:I din_56:I din_57:I din_58:I din_59:I din_60:I din_61:I din_62:I din_63:I sel_0:I sel_1:I s_en:I p_en_bar:I w_en:I bank_wmask_0:I bank_wmask_1:I bank_wmask_2:I bank_wmask_3:I bank_wmask_4:I bank_wmask_5:I bank_wmask_6:I bank_wmask_7:I vdd:B gnd:B
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
* INOUT : bl_44 
* INOUT : br_44 
* INOUT : bl_45 
* INOUT : br_45 
* INOUT : bl_46 
* INOUT : br_46 
* INOUT : bl_47 
* INOUT : br_47 
* INOUT : bl_48 
* INOUT : br_48 
* INOUT : bl_49 
* INOUT : br_49 
* INOUT : bl_50 
* INOUT : br_50 
* INOUT : bl_51 
* INOUT : br_51 
* INOUT : bl_52 
* INOUT : br_52 
* INOUT : bl_53 
* INOUT : br_53 
* INOUT : bl_54 
* INOUT : br_54 
* INOUT : bl_55 
* INOUT : br_55 
* INOUT : bl_56 
* INOUT : br_56 
* INOUT : bl_57 
* INOUT : br_57 
* INOUT : bl_58 
* INOUT : br_58 
* INOUT : bl_59 
* INOUT : br_59 
* INOUT : bl_60 
* INOUT : br_60 
* INOUT : bl_61 
* INOUT : br_61 
* INOUT : bl_62 
* INOUT : br_62 
* INOUT : bl_63 
* INOUT : br_63 
* INOUT : bl_64 
* INOUT : br_64 
* INOUT : bl_65 
* INOUT : br_65 
* INOUT : bl_66 
* INOUT : br_66 
* INOUT : bl_67 
* INOUT : br_67 
* INOUT : bl_68 
* INOUT : br_68 
* INOUT : bl_69 
* INOUT : br_69 
* INOUT : bl_70 
* INOUT : br_70 
* INOUT : bl_71 
* INOUT : br_71 
* INOUT : bl_72 
* INOUT : br_72 
* INOUT : bl_73 
* INOUT : br_73 
* INOUT : bl_74 
* INOUT : br_74 
* INOUT : bl_75 
* INOUT : br_75 
* INOUT : bl_76 
* INOUT : br_76 
* INOUT : bl_77 
* INOUT : br_77 
* INOUT : bl_78 
* INOUT : br_78 
* INOUT : bl_79 
* INOUT : br_79 
* INOUT : bl_80 
* INOUT : br_80 
* INOUT : bl_81 
* INOUT : br_81 
* INOUT : bl_82 
* INOUT : br_82 
* INOUT : bl_83 
* INOUT : br_83 
* INOUT : bl_84 
* INOUT : br_84 
* INOUT : bl_85 
* INOUT : br_85 
* INOUT : bl_86 
* INOUT : br_86 
* INOUT : bl_87 
* INOUT : br_87 
* INOUT : bl_88 
* INOUT : br_88 
* INOUT : bl_89 
* INOUT : br_89 
* INOUT : bl_90 
* INOUT : br_90 
* INOUT : bl_91 
* INOUT : br_91 
* INOUT : bl_92 
* INOUT : br_92 
* INOUT : bl_93 
* INOUT : br_93 
* INOUT : bl_94 
* INOUT : br_94 
* INOUT : bl_95 
* INOUT : br_95 
* INOUT : bl_96 
* INOUT : br_96 
* INOUT : bl_97 
* INOUT : br_97 
* INOUT : bl_98 
* INOUT : br_98 
* INOUT : bl_99 
* INOUT : br_99 
* INOUT : bl_100 
* INOUT : br_100 
* INOUT : bl_101 
* INOUT : br_101 
* INOUT : bl_102 
* INOUT : br_102 
* INOUT : bl_103 
* INOUT : br_103 
* INOUT : bl_104 
* INOUT : br_104 
* INOUT : bl_105 
* INOUT : br_105 
* INOUT : bl_106 
* INOUT : br_106 
* INOUT : bl_107 
* INOUT : br_107 
* INOUT : bl_108 
* INOUT : br_108 
* INOUT : bl_109 
* INOUT : br_109 
* INOUT : bl_110 
* INOUT : br_110 
* INOUT : bl_111 
* INOUT : br_111 
* INOUT : bl_112 
* INOUT : br_112 
* INOUT : bl_113 
* INOUT : br_113 
* INOUT : bl_114 
* INOUT : br_114 
* INOUT : bl_115 
* INOUT : br_115 
* INOUT : bl_116 
* INOUT : br_116 
* INOUT : bl_117 
* INOUT : br_117 
* INOUT : bl_118 
* INOUT : br_118 
* INOUT : bl_119 
* INOUT : br_119 
* INOUT : bl_120 
* INOUT : br_120 
* INOUT : bl_121 
* INOUT : br_121 
* INOUT : bl_122 
* INOUT : br_122 
* INOUT : bl_123 
* INOUT : br_123 
* INOUT : bl_124 
* INOUT : br_124 
* INOUT : bl_125 
* INOUT : br_125 
* INOUT : bl_126 
* INOUT : br_126 
* INOUT : bl_127 
* INOUT : br_127 
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
* OUTPUT: dout_44 
* OUTPUT: dout_45 
* OUTPUT: dout_46 
* OUTPUT: dout_47 
* OUTPUT: dout_48 
* OUTPUT: dout_49 
* OUTPUT: dout_50 
* OUTPUT: dout_51 
* OUTPUT: dout_52 
* OUTPUT: dout_53 
* OUTPUT: dout_54 
* OUTPUT: dout_55 
* OUTPUT: dout_56 
* OUTPUT: dout_57 
* OUTPUT: dout_58 
* OUTPUT: dout_59 
* OUTPUT: dout_60 
* OUTPUT: dout_61 
* OUTPUT: dout_62 
* OUTPUT: dout_63 
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
* INPUT : din_44 
* INPUT : din_45 
* INPUT : din_46 
* INPUT : din_47 
* INPUT : din_48 
* INPUT : din_49 
* INPUT : din_50 
* INPUT : din_51 
* INPUT : din_52 
* INPUT : din_53 
* INPUT : din_54 
* INPUT : din_55 
* INPUT : din_56 
* INPUT : din_57 
* INPUT : din_58 
* INPUT : din_59 
* INPUT : din_60 
* INPUT : din_61 
* INPUT : din_62 
* INPUT : din_63 
* INPUT : sel_0 
* INPUT : sel_1 
* INPUT : s_en 
* INPUT : p_en_bar 
* INPUT : w_en 
* INPUT : bank_wmask_0 
* INPUT : bank_wmask_1 
* INPUT : bank_wmask_2 
* INPUT : bank_wmask_3 
* INPUT : bank_wmask_4 
* INPUT : bank_wmask_5 
* INPUT : bank_wmask_6 
* INPUT : bank_wmask_7 
* POWER : vdd 
* GROUND: gnd 
Xprecharge_array0 rbl_bl rbl_br bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 p_en_bar vdd precharge_array
Xsense_amp_array0 dout_0 bl_out_0 br_out_0 dout_1 bl_out_1 br_out_1 dout_2 bl_out_2 br_out_2 dout_3 bl_out_3 br_out_3 dout_4 bl_out_4 br_out_4 dout_5 bl_out_5 br_out_5 dout_6 bl_out_6 br_out_6 dout_7 bl_out_7 br_out_7 dout_8 bl_out_8 br_out_8 dout_9 bl_out_9 br_out_9 dout_10 bl_out_10 br_out_10 dout_11 bl_out_11 br_out_11 dout_12 bl_out_12 br_out_12 dout_13 bl_out_13 br_out_13 dout_14 bl_out_14 br_out_14 dout_15 bl_out_15 br_out_15 dout_16 bl_out_16 br_out_16 dout_17 bl_out_17 br_out_17 dout_18 bl_out_18 br_out_18 dout_19 bl_out_19 br_out_19 dout_20 bl_out_20 br_out_20 dout_21 bl_out_21 br_out_21 dout_22 bl_out_22 br_out_22 dout_23 bl_out_23 br_out_23 dout_24 bl_out_24 br_out_24 dout_25 bl_out_25 br_out_25 dout_26 bl_out_26 br_out_26 dout_27 bl_out_27 br_out_27 dout_28 bl_out_28 br_out_28 dout_29 bl_out_29 br_out_29 dout_30 bl_out_30 br_out_30 dout_31 bl_out_31 br_out_31 dout_32 bl_out_32 br_out_32 dout_33 bl_out_33 br_out_33 dout_34 bl_out_34 br_out_34 dout_35 bl_out_35 br_out_35 dout_36 bl_out_36 br_out_36 dout_37 bl_out_37 br_out_37 dout_38 bl_out_38 br_out_38 dout_39 bl_out_39 br_out_39 dout_40 bl_out_40 br_out_40 dout_41 bl_out_41 br_out_41 dout_42 bl_out_42 br_out_42 dout_43 bl_out_43 br_out_43 dout_44 bl_out_44 br_out_44 dout_45 bl_out_45 br_out_45 dout_46 bl_out_46 br_out_46 dout_47 bl_out_47 br_out_47 dout_48 bl_out_48 br_out_48 dout_49 bl_out_49 br_out_49 dout_50 bl_out_50 br_out_50 dout_51 bl_out_51 br_out_51 dout_52 bl_out_52 br_out_52 dout_53 bl_out_53 br_out_53 dout_54 bl_out_54 br_out_54 dout_55 bl_out_55 br_out_55 dout_56 bl_out_56 br_out_56 dout_57 bl_out_57 br_out_57 dout_58 bl_out_58 br_out_58 dout_59 bl_out_59 br_out_59 dout_60 bl_out_60 br_out_60 dout_61 bl_out_61 br_out_61 dout_62 bl_out_62 br_out_62 dout_63 bl_out_63 br_out_63 s_en vdd gnd sense_amp_array
Xwrite_driver_array0 din_0 din_1 din_2 din_3 din_4 din_5 din_6 din_7 din_8 din_9 din_10 din_11 din_12 din_13 din_14 din_15 din_16 din_17 din_18 din_19 din_20 din_21 din_22 din_23 din_24 din_25 din_26 din_27 din_28 din_29 din_30 din_31 din_32 din_33 din_34 din_35 din_36 din_37 din_38 din_39 din_40 din_41 din_42 din_43 din_44 din_45 din_46 din_47 din_48 din_49 din_50 din_51 din_52 din_53 din_54 din_55 din_56 din_57 din_58 din_59 din_60 din_61 din_62 din_63 bl_out_0 br_out_0 bl_out_1 br_out_1 bl_out_2 br_out_2 bl_out_3 br_out_3 bl_out_4 br_out_4 bl_out_5 br_out_5 bl_out_6 br_out_6 bl_out_7 br_out_7 bl_out_8 br_out_8 bl_out_9 br_out_9 bl_out_10 br_out_10 bl_out_11 br_out_11 bl_out_12 br_out_12 bl_out_13 br_out_13 bl_out_14 br_out_14 bl_out_15 br_out_15 bl_out_16 br_out_16 bl_out_17 br_out_17 bl_out_18 br_out_18 bl_out_19 br_out_19 bl_out_20 br_out_20 bl_out_21 br_out_21 bl_out_22 br_out_22 bl_out_23 br_out_23 bl_out_24 br_out_24 bl_out_25 br_out_25 bl_out_26 br_out_26 bl_out_27 br_out_27 bl_out_28 br_out_28 bl_out_29 br_out_29 bl_out_30 br_out_30 bl_out_31 br_out_31 bl_out_32 br_out_32 bl_out_33 br_out_33 bl_out_34 br_out_34 bl_out_35 br_out_35 bl_out_36 br_out_36 bl_out_37 br_out_37 bl_out_38 br_out_38 bl_out_39 br_out_39 bl_out_40 br_out_40 bl_out_41 br_out_41 bl_out_42 br_out_42 bl_out_43 br_out_43 bl_out_44 br_out_44 bl_out_45 br_out_45 bl_out_46 br_out_46 bl_out_47 br_out_47 bl_out_48 br_out_48 bl_out_49 br_out_49 bl_out_50 br_out_50 bl_out_51 br_out_51 bl_out_52 br_out_52 bl_out_53 br_out_53 bl_out_54 br_out_54 bl_out_55 br_out_55 bl_out_56 br_out_56 bl_out_57 br_out_57 bl_out_58 br_out_58 bl_out_59 br_out_59 bl_out_60 br_out_60 bl_out_61 br_out_61 bl_out_62 br_out_62 bl_out_63 br_out_63 wdriver_sel_0 wdriver_sel_1 wdriver_sel_2 wdriver_sel_3 wdriver_sel_4 wdriver_sel_5 wdriver_sel_6 wdriver_sel_7 vdd gnd write_driver_array
Xwrite_mask_and_array0 bank_wmask_0 bank_wmask_1 bank_wmask_2 bank_wmask_3 bank_wmask_4 bank_wmask_5 bank_wmask_6 bank_wmask_7 w_en wdriver_sel_0 wdriver_sel_1 wdriver_sel_2 wdriver_sel_3 wdriver_sel_4 wdriver_sel_5 wdriver_sel_6 wdriver_sel_7 vdd gnd write_mask_and_array
Xcolumn_mux_array0 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 sel_0 sel_1 bl_out_0 br_out_0 bl_out_1 br_out_1 bl_out_2 br_out_2 bl_out_3 br_out_3 bl_out_4 br_out_4 bl_out_5 br_out_5 bl_out_6 br_out_6 bl_out_7 br_out_7 bl_out_8 br_out_8 bl_out_9 br_out_9 bl_out_10 br_out_10 bl_out_11 br_out_11 bl_out_12 br_out_12 bl_out_13 br_out_13 bl_out_14 br_out_14 bl_out_15 br_out_15 bl_out_16 br_out_16 bl_out_17 br_out_17 bl_out_18 br_out_18 bl_out_19 br_out_19 bl_out_20 br_out_20 bl_out_21 br_out_21 bl_out_22 br_out_22 bl_out_23 br_out_23 bl_out_24 br_out_24 bl_out_25 br_out_25 bl_out_26 br_out_26 bl_out_27 br_out_27 bl_out_28 br_out_28 bl_out_29 br_out_29 bl_out_30 br_out_30 bl_out_31 br_out_31 bl_out_32 br_out_32 bl_out_33 br_out_33 bl_out_34 br_out_34 bl_out_35 br_out_35 bl_out_36 br_out_36 bl_out_37 br_out_37 bl_out_38 br_out_38 bl_out_39 br_out_39 bl_out_40 br_out_40 bl_out_41 br_out_41 bl_out_42 br_out_42 bl_out_43 br_out_43 bl_out_44 br_out_44 bl_out_45 br_out_45 bl_out_46 br_out_46 bl_out_47 br_out_47 bl_out_48 br_out_48 bl_out_49 br_out_49 bl_out_50 br_out_50 bl_out_51 br_out_51 bl_out_52 br_out_52 bl_out_53 br_out_53 bl_out_54 br_out_54 bl_out_55 br_out_55 bl_out_56 br_out_56 bl_out_57 br_out_57 bl_out_58 br_out_58 bl_out_59 br_out_59 bl_out_60 br_out_60 bl_out_61 br_out_61 bl_out_62 br_out_62 bl_out_63 br_out_63 gnd column_mux_array
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

.SUBCKT precharge_array_0 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 bl_128 br_128 en_bar vdd
*.PININFO bl_0:O br_0:O bl_1:O br_1:O bl_2:O br_2:O bl_3:O br_3:O bl_4:O br_4:O bl_5:O br_5:O bl_6:O br_6:O bl_7:O br_7:O bl_8:O br_8:O bl_9:O br_9:O bl_10:O br_10:O bl_11:O br_11:O bl_12:O br_12:O bl_13:O br_13:O bl_14:O br_14:O bl_15:O br_15:O bl_16:O br_16:O bl_17:O br_17:O bl_18:O br_18:O bl_19:O br_19:O bl_20:O br_20:O bl_21:O br_21:O bl_22:O br_22:O bl_23:O br_23:O bl_24:O br_24:O bl_25:O br_25:O bl_26:O br_26:O bl_27:O br_27:O bl_28:O br_28:O bl_29:O br_29:O bl_30:O br_30:O bl_31:O br_31:O bl_32:O br_32:O bl_33:O br_33:O bl_34:O br_34:O bl_35:O br_35:O bl_36:O br_36:O bl_37:O br_37:O bl_38:O br_38:O bl_39:O br_39:O bl_40:O br_40:O bl_41:O br_41:O bl_42:O br_42:O bl_43:O br_43:O bl_44:O br_44:O bl_45:O br_45:O bl_46:O br_46:O bl_47:O br_47:O bl_48:O br_48:O bl_49:O br_49:O bl_50:O br_50:O bl_51:O br_51:O bl_52:O br_52:O bl_53:O br_53:O bl_54:O br_54:O bl_55:O br_55:O bl_56:O br_56:O bl_57:O br_57:O bl_58:O br_58:O bl_59:O br_59:O bl_60:O br_60:O bl_61:O br_61:O bl_62:O br_62:O bl_63:O br_63:O bl_64:O br_64:O bl_65:O br_65:O bl_66:O br_66:O bl_67:O br_67:O bl_68:O br_68:O bl_69:O br_69:O bl_70:O br_70:O bl_71:O br_71:O bl_72:O br_72:O bl_73:O br_73:O bl_74:O br_74:O bl_75:O br_75:O bl_76:O br_76:O bl_77:O br_77:O bl_78:O br_78:O bl_79:O br_79:O bl_80:O br_80:O bl_81:O br_81:O bl_82:O br_82:O bl_83:O br_83:O bl_84:O br_84:O bl_85:O br_85:O bl_86:O br_86:O bl_87:O br_87:O bl_88:O br_88:O bl_89:O br_89:O bl_90:O br_90:O bl_91:O br_91:O bl_92:O br_92:O bl_93:O br_93:O bl_94:O br_94:O bl_95:O br_95:O bl_96:O br_96:O bl_97:O br_97:O bl_98:O br_98:O bl_99:O br_99:O bl_100:O br_100:O bl_101:O br_101:O bl_102:O br_102:O bl_103:O br_103:O bl_104:O br_104:O bl_105:O br_105:O bl_106:O br_106:O bl_107:O br_107:O bl_108:O br_108:O bl_109:O br_109:O bl_110:O br_110:O bl_111:O br_111:O bl_112:O br_112:O bl_113:O br_113:O bl_114:O br_114:O bl_115:O br_115:O bl_116:O br_116:O bl_117:O br_117:O bl_118:O br_118:O bl_119:O br_119:O bl_120:O br_120:O bl_121:O br_121:O bl_122:O br_122:O bl_123:O br_123:O bl_124:O br_124:O bl_125:O br_125:O bl_126:O br_126:O bl_127:O br_127:O bl_128:O br_128:O en_bar:I vdd:B
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
* OUTPUT: bl_45 
* OUTPUT: br_45 
* OUTPUT: bl_46 
* OUTPUT: br_46 
* OUTPUT: bl_47 
* OUTPUT: br_47 
* OUTPUT: bl_48 
* OUTPUT: br_48 
* OUTPUT: bl_49 
* OUTPUT: br_49 
* OUTPUT: bl_50 
* OUTPUT: br_50 
* OUTPUT: bl_51 
* OUTPUT: br_51 
* OUTPUT: bl_52 
* OUTPUT: br_52 
* OUTPUT: bl_53 
* OUTPUT: br_53 
* OUTPUT: bl_54 
* OUTPUT: br_54 
* OUTPUT: bl_55 
* OUTPUT: br_55 
* OUTPUT: bl_56 
* OUTPUT: br_56 
* OUTPUT: bl_57 
* OUTPUT: br_57 
* OUTPUT: bl_58 
* OUTPUT: br_58 
* OUTPUT: bl_59 
* OUTPUT: br_59 
* OUTPUT: bl_60 
* OUTPUT: br_60 
* OUTPUT: bl_61 
* OUTPUT: br_61 
* OUTPUT: bl_62 
* OUTPUT: br_62 
* OUTPUT: bl_63 
* OUTPUT: br_63 
* OUTPUT: bl_64 
* OUTPUT: br_64 
* OUTPUT: bl_65 
* OUTPUT: br_65 
* OUTPUT: bl_66 
* OUTPUT: br_66 
* OUTPUT: bl_67 
* OUTPUT: br_67 
* OUTPUT: bl_68 
* OUTPUT: br_68 
* OUTPUT: bl_69 
* OUTPUT: br_69 
* OUTPUT: bl_70 
* OUTPUT: br_70 
* OUTPUT: bl_71 
* OUTPUT: br_71 
* OUTPUT: bl_72 
* OUTPUT: br_72 
* OUTPUT: bl_73 
* OUTPUT: br_73 
* OUTPUT: bl_74 
* OUTPUT: br_74 
* OUTPUT: bl_75 
* OUTPUT: br_75 
* OUTPUT: bl_76 
* OUTPUT: br_76 
* OUTPUT: bl_77 
* OUTPUT: br_77 
* OUTPUT: bl_78 
* OUTPUT: br_78 
* OUTPUT: bl_79 
* OUTPUT: br_79 
* OUTPUT: bl_80 
* OUTPUT: br_80 
* OUTPUT: bl_81 
* OUTPUT: br_81 
* OUTPUT: bl_82 
* OUTPUT: br_82 
* OUTPUT: bl_83 
* OUTPUT: br_83 
* OUTPUT: bl_84 
* OUTPUT: br_84 
* OUTPUT: bl_85 
* OUTPUT: br_85 
* OUTPUT: bl_86 
* OUTPUT: br_86 
* OUTPUT: bl_87 
* OUTPUT: br_87 
* OUTPUT: bl_88 
* OUTPUT: br_88 
* OUTPUT: bl_89 
* OUTPUT: br_89 
* OUTPUT: bl_90 
* OUTPUT: br_90 
* OUTPUT: bl_91 
* OUTPUT: br_91 
* OUTPUT: bl_92 
* OUTPUT: br_92 
* OUTPUT: bl_93 
* OUTPUT: br_93 
* OUTPUT: bl_94 
* OUTPUT: br_94 
* OUTPUT: bl_95 
* OUTPUT: br_95 
* OUTPUT: bl_96 
* OUTPUT: br_96 
* OUTPUT: bl_97 
* OUTPUT: br_97 
* OUTPUT: bl_98 
* OUTPUT: br_98 
* OUTPUT: bl_99 
* OUTPUT: br_99 
* OUTPUT: bl_100 
* OUTPUT: br_100 
* OUTPUT: bl_101 
* OUTPUT: br_101 
* OUTPUT: bl_102 
* OUTPUT: br_102 
* OUTPUT: bl_103 
* OUTPUT: br_103 
* OUTPUT: bl_104 
* OUTPUT: br_104 
* OUTPUT: bl_105 
* OUTPUT: br_105 
* OUTPUT: bl_106 
* OUTPUT: br_106 
* OUTPUT: bl_107 
* OUTPUT: br_107 
* OUTPUT: bl_108 
* OUTPUT: br_108 
* OUTPUT: bl_109 
* OUTPUT: br_109 
* OUTPUT: bl_110 
* OUTPUT: br_110 
* OUTPUT: bl_111 
* OUTPUT: br_111 
* OUTPUT: bl_112 
* OUTPUT: br_112 
* OUTPUT: bl_113 
* OUTPUT: br_113 
* OUTPUT: bl_114 
* OUTPUT: br_114 
* OUTPUT: bl_115 
* OUTPUT: br_115 
* OUTPUT: bl_116 
* OUTPUT: br_116 
* OUTPUT: bl_117 
* OUTPUT: br_117 
* OUTPUT: bl_118 
* OUTPUT: br_118 
* OUTPUT: bl_119 
* OUTPUT: br_119 
* OUTPUT: bl_120 
* OUTPUT: br_120 
* OUTPUT: bl_121 
* OUTPUT: br_121 
* OUTPUT: bl_122 
* OUTPUT: br_122 
* OUTPUT: bl_123 
* OUTPUT: br_123 
* OUTPUT: bl_124 
* OUTPUT: br_124 
* OUTPUT: bl_125 
* OUTPUT: br_125 
* OUTPUT: bl_126 
* OUTPUT: br_126 
* OUTPUT: bl_127 
* OUTPUT: br_127 
* OUTPUT: bl_128 
* OUTPUT: br_128 
* INPUT : en_bar 
* POWER : vdd 
* cols: 129 size: 1 bl: bl1 br: br1
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
Xpre_column_45 bl_45 br_45 en_bar vdd precharge_1
Xpre_column_46 bl_46 br_46 en_bar vdd precharge_1
Xpre_column_47 bl_47 br_47 en_bar vdd precharge_1
Xpre_column_48 bl_48 br_48 en_bar vdd precharge_1
Xpre_column_49 bl_49 br_49 en_bar vdd precharge_1
Xpre_column_50 bl_50 br_50 en_bar vdd precharge_1
Xpre_column_51 bl_51 br_51 en_bar vdd precharge_1
Xpre_column_52 bl_52 br_52 en_bar vdd precharge_1
Xpre_column_53 bl_53 br_53 en_bar vdd precharge_1
Xpre_column_54 bl_54 br_54 en_bar vdd precharge_1
Xpre_column_55 bl_55 br_55 en_bar vdd precharge_1
Xpre_column_56 bl_56 br_56 en_bar vdd precharge_1
Xpre_column_57 bl_57 br_57 en_bar vdd precharge_1
Xpre_column_58 bl_58 br_58 en_bar vdd precharge_1
Xpre_column_59 bl_59 br_59 en_bar vdd precharge_1
Xpre_column_60 bl_60 br_60 en_bar vdd precharge_1
Xpre_column_61 bl_61 br_61 en_bar vdd precharge_1
Xpre_column_62 bl_62 br_62 en_bar vdd precharge_1
Xpre_column_63 bl_63 br_63 en_bar vdd precharge_1
Xpre_column_64 bl_64 br_64 en_bar vdd precharge_1
Xpre_column_65 bl_65 br_65 en_bar vdd precharge_1
Xpre_column_66 bl_66 br_66 en_bar vdd precharge_1
Xpre_column_67 bl_67 br_67 en_bar vdd precharge_1
Xpre_column_68 bl_68 br_68 en_bar vdd precharge_1
Xpre_column_69 bl_69 br_69 en_bar vdd precharge_1
Xpre_column_70 bl_70 br_70 en_bar vdd precharge_1
Xpre_column_71 bl_71 br_71 en_bar vdd precharge_1
Xpre_column_72 bl_72 br_72 en_bar vdd precharge_1
Xpre_column_73 bl_73 br_73 en_bar vdd precharge_1
Xpre_column_74 bl_74 br_74 en_bar vdd precharge_1
Xpre_column_75 bl_75 br_75 en_bar vdd precharge_1
Xpre_column_76 bl_76 br_76 en_bar vdd precharge_1
Xpre_column_77 bl_77 br_77 en_bar vdd precharge_1
Xpre_column_78 bl_78 br_78 en_bar vdd precharge_1
Xpre_column_79 bl_79 br_79 en_bar vdd precharge_1
Xpre_column_80 bl_80 br_80 en_bar vdd precharge_1
Xpre_column_81 bl_81 br_81 en_bar vdd precharge_1
Xpre_column_82 bl_82 br_82 en_bar vdd precharge_1
Xpre_column_83 bl_83 br_83 en_bar vdd precharge_1
Xpre_column_84 bl_84 br_84 en_bar vdd precharge_1
Xpre_column_85 bl_85 br_85 en_bar vdd precharge_1
Xpre_column_86 bl_86 br_86 en_bar vdd precharge_1
Xpre_column_87 bl_87 br_87 en_bar vdd precharge_1
Xpre_column_88 bl_88 br_88 en_bar vdd precharge_1
Xpre_column_89 bl_89 br_89 en_bar vdd precharge_1
Xpre_column_90 bl_90 br_90 en_bar vdd precharge_1
Xpre_column_91 bl_91 br_91 en_bar vdd precharge_1
Xpre_column_92 bl_92 br_92 en_bar vdd precharge_1
Xpre_column_93 bl_93 br_93 en_bar vdd precharge_1
Xpre_column_94 bl_94 br_94 en_bar vdd precharge_1
Xpre_column_95 bl_95 br_95 en_bar vdd precharge_1
Xpre_column_96 bl_96 br_96 en_bar vdd precharge_1
Xpre_column_97 bl_97 br_97 en_bar vdd precharge_1
Xpre_column_98 bl_98 br_98 en_bar vdd precharge_1
Xpre_column_99 bl_99 br_99 en_bar vdd precharge_1
Xpre_column_100 bl_100 br_100 en_bar vdd precharge_1
Xpre_column_101 bl_101 br_101 en_bar vdd precharge_1
Xpre_column_102 bl_102 br_102 en_bar vdd precharge_1
Xpre_column_103 bl_103 br_103 en_bar vdd precharge_1
Xpre_column_104 bl_104 br_104 en_bar vdd precharge_1
Xpre_column_105 bl_105 br_105 en_bar vdd precharge_1
Xpre_column_106 bl_106 br_106 en_bar vdd precharge_1
Xpre_column_107 bl_107 br_107 en_bar vdd precharge_1
Xpre_column_108 bl_108 br_108 en_bar vdd precharge_1
Xpre_column_109 bl_109 br_109 en_bar vdd precharge_1
Xpre_column_110 bl_110 br_110 en_bar vdd precharge_1
Xpre_column_111 bl_111 br_111 en_bar vdd precharge_1
Xpre_column_112 bl_112 br_112 en_bar vdd precharge_1
Xpre_column_113 bl_113 br_113 en_bar vdd precharge_1
Xpre_column_114 bl_114 br_114 en_bar vdd precharge_1
Xpre_column_115 bl_115 br_115 en_bar vdd precharge_1
Xpre_column_116 bl_116 br_116 en_bar vdd precharge_1
Xpre_column_117 bl_117 br_117 en_bar vdd precharge_1
Xpre_column_118 bl_118 br_118 en_bar vdd precharge_1
Xpre_column_119 bl_119 br_119 en_bar vdd precharge_1
Xpre_column_120 bl_120 br_120 en_bar vdd precharge_1
Xpre_column_121 bl_121 br_121 en_bar vdd precharge_1
Xpre_column_122 bl_122 br_122 en_bar vdd precharge_1
Xpre_column_123 bl_123 br_123 en_bar vdd precharge_1
Xpre_column_124 bl_124 br_124 en_bar vdd precharge_1
Xpre_column_125 bl_125 br_125 en_bar vdd precharge_1
Xpre_column_126 bl_126 br_126 en_bar vdd precharge_1
Xpre_column_127 bl_127 br_127 en_bar vdd precharge_1
Xpre_column_128 bl_128 br_128 en_bar vdd precharge_1
.ENDS precharge_array_0

.SUBCKT column_mux_0 bl br bl_out br_out sel gnd
*.PININFO bl:B br:B bl_out:B br_out:B sel:B gnd:B
* INOUT : bl 
* INOUT : br 
* INOUT : bl_out 
* INOUT : br_out 
* INOUT : sel 
* INOUT : gnd 
Xmux_tx1 bl sel bl_out gnd sky130_fd_pr__nfet_01v8 m=1 w=2.88u l=0.15u
Xmux_tx2 br sel br_out gnd sky130_fd_pr__nfet_01v8 m=1 w=2.88u l=0.15u
.ENDS column_mux_0

.SUBCKT column_mux_array_0 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 sel_0 sel_1 bl_out_0 br_out_0 bl_out_1 br_out_1 bl_out_2 br_out_2 bl_out_3 br_out_3 bl_out_4 br_out_4 bl_out_5 br_out_5 bl_out_6 br_out_6 bl_out_7 br_out_7 bl_out_8 br_out_8 bl_out_9 br_out_9 bl_out_10 br_out_10 bl_out_11 br_out_11 bl_out_12 br_out_12 bl_out_13 br_out_13 bl_out_14 br_out_14 bl_out_15 br_out_15 bl_out_16 br_out_16 bl_out_17 br_out_17 bl_out_18 br_out_18 bl_out_19 br_out_19 bl_out_20 br_out_20 bl_out_21 br_out_21 bl_out_22 br_out_22 bl_out_23 br_out_23 bl_out_24 br_out_24 bl_out_25 br_out_25 bl_out_26 br_out_26 bl_out_27 br_out_27 bl_out_28 br_out_28 bl_out_29 br_out_29 bl_out_30 br_out_30 bl_out_31 br_out_31 bl_out_32 br_out_32 bl_out_33 br_out_33 bl_out_34 br_out_34 bl_out_35 br_out_35 bl_out_36 br_out_36 bl_out_37 br_out_37 bl_out_38 br_out_38 bl_out_39 br_out_39 bl_out_40 br_out_40 bl_out_41 br_out_41 bl_out_42 br_out_42 bl_out_43 br_out_43 bl_out_44 br_out_44 bl_out_45 br_out_45 bl_out_46 br_out_46 bl_out_47 br_out_47 bl_out_48 br_out_48 bl_out_49 br_out_49 bl_out_50 br_out_50 bl_out_51 br_out_51 bl_out_52 br_out_52 bl_out_53 br_out_53 bl_out_54 br_out_54 bl_out_55 br_out_55 bl_out_56 br_out_56 bl_out_57 br_out_57 bl_out_58 br_out_58 bl_out_59 br_out_59 bl_out_60 br_out_60 bl_out_61 br_out_61 bl_out_62 br_out_62 bl_out_63 br_out_63 gnd
*.PININFO bl_0:B br_0:B bl_1:B br_1:B bl_2:B br_2:B bl_3:B br_3:B bl_4:B br_4:B bl_5:B br_5:B bl_6:B br_6:B bl_7:B br_7:B bl_8:B br_8:B bl_9:B br_9:B bl_10:B br_10:B bl_11:B br_11:B bl_12:B br_12:B bl_13:B br_13:B bl_14:B br_14:B bl_15:B br_15:B bl_16:B br_16:B bl_17:B br_17:B bl_18:B br_18:B bl_19:B br_19:B bl_20:B br_20:B bl_21:B br_21:B bl_22:B br_22:B bl_23:B br_23:B bl_24:B br_24:B bl_25:B br_25:B bl_26:B br_26:B bl_27:B br_27:B bl_28:B br_28:B bl_29:B br_29:B bl_30:B br_30:B bl_31:B br_31:B bl_32:B br_32:B bl_33:B br_33:B bl_34:B br_34:B bl_35:B br_35:B bl_36:B br_36:B bl_37:B br_37:B bl_38:B br_38:B bl_39:B br_39:B bl_40:B br_40:B bl_41:B br_41:B bl_42:B br_42:B bl_43:B br_43:B bl_44:B br_44:B bl_45:B br_45:B bl_46:B br_46:B bl_47:B br_47:B bl_48:B br_48:B bl_49:B br_49:B bl_50:B br_50:B bl_51:B br_51:B bl_52:B br_52:B bl_53:B br_53:B bl_54:B br_54:B bl_55:B br_55:B bl_56:B br_56:B bl_57:B br_57:B bl_58:B br_58:B bl_59:B br_59:B bl_60:B br_60:B bl_61:B br_61:B bl_62:B br_62:B bl_63:B br_63:B bl_64:B br_64:B bl_65:B br_65:B bl_66:B br_66:B bl_67:B br_67:B bl_68:B br_68:B bl_69:B br_69:B bl_70:B br_70:B bl_71:B br_71:B bl_72:B br_72:B bl_73:B br_73:B bl_74:B br_74:B bl_75:B br_75:B bl_76:B br_76:B bl_77:B br_77:B bl_78:B br_78:B bl_79:B br_79:B bl_80:B br_80:B bl_81:B br_81:B bl_82:B br_82:B bl_83:B br_83:B bl_84:B br_84:B bl_85:B br_85:B bl_86:B br_86:B bl_87:B br_87:B bl_88:B br_88:B bl_89:B br_89:B bl_90:B br_90:B bl_91:B br_91:B bl_92:B br_92:B bl_93:B br_93:B bl_94:B br_94:B bl_95:B br_95:B bl_96:B br_96:B bl_97:B br_97:B bl_98:B br_98:B bl_99:B br_99:B bl_100:B br_100:B bl_101:B br_101:B bl_102:B br_102:B bl_103:B br_103:B bl_104:B br_104:B bl_105:B br_105:B bl_106:B br_106:B bl_107:B br_107:B bl_108:B br_108:B bl_109:B br_109:B bl_110:B br_110:B bl_111:B br_111:B bl_112:B br_112:B bl_113:B br_113:B bl_114:B br_114:B bl_115:B br_115:B bl_116:B br_116:B bl_117:B br_117:B bl_118:B br_118:B bl_119:B br_119:B bl_120:B br_120:B bl_121:B br_121:B bl_122:B br_122:B bl_123:B br_123:B bl_124:B br_124:B bl_125:B br_125:B bl_126:B br_126:B bl_127:B br_127:B sel_0:B sel_1:B bl_out_0:B br_out_0:B bl_out_1:B br_out_1:B bl_out_2:B br_out_2:B bl_out_3:B br_out_3:B bl_out_4:B br_out_4:B bl_out_5:B br_out_5:B bl_out_6:B br_out_6:B bl_out_7:B br_out_7:B bl_out_8:B br_out_8:B bl_out_9:B br_out_9:B bl_out_10:B br_out_10:B bl_out_11:B br_out_11:B bl_out_12:B br_out_12:B bl_out_13:B br_out_13:B bl_out_14:B br_out_14:B bl_out_15:B br_out_15:B bl_out_16:B br_out_16:B bl_out_17:B br_out_17:B bl_out_18:B br_out_18:B bl_out_19:B br_out_19:B bl_out_20:B br_out_20:B bl_out_21:B br_out_21:B bl_out_22:B br_out_22:B bl_out_23:B br_out_23:B bl_out_24:B br_out_24:B bl_out_25:B br_out_25:B bl_out_26:B br_out_26:B bl_out_27:B br_out_27:B bl_out_28:B br_out_28:B bl_out_29:B br_out_29:B bl_out_30:B br_out_30:B bl_out_31:B br_out_31:B bl_out_32:B br_out_32:B bl_out_33:B br_out_33:B bl_out_34:B br_out_34:B bl_out_35:B br_out_35:B bl_out_36:B br_out_36:B bl_out_37:B br_out_37:B bl_out_38:B br_out_38:B bl_out_39:B br_out_39:B bl_out_40:B br_out_40:B bl_out_41:B br_out_41:B bl_out_42:B br_out_42:B bl_out_43:B br_out_43:B bl_out_44:B br_out_44:B bl_out_45:B br_out_45:B bl_out_46:B br_out_46:B bl_out_47:B br_out_47:B bl_out_48:B br_out_48:B bl_out_49:B br_out_49:B bl_out_50:B br_out_50:B bl_out_51:B br_out_51:B bl_out_52:B br_out_52:B bl_out_53:B br_out_53:B bl_out_54:B br_out_54:B bl_out_55:B br_out_55:B bl_out_56:B br_out_56:B bl_out_57:B br_out_57:B bl_out_58:B br_out_58:B bl_out_59:B br_out_59:B bl_out_60:B br_out_60:B bl_out_61:B br_out_61:B bl_out_62:B br_out_62:B bl_out_63:B br_out_63:B gnd:B
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
* INOUT : bl_44 
* INOUT : br_44 
* INOUT : bl_45 
* INOUT : br_45 
* INOUT : bl_46 
* INOUT : br_46 
* INOUT : bl_47 
* INOUT : br_47 
* INOUT : bl_48 
* INOUT : br_48 
* INOUT : bl_49 
* INOUT : br_49 
* INOUT : bl_50 
* INOUT : br_50 
* INOUT : bl_51 
* INOUT : br_51 
* INOUT : bl_52 
* INOUT : br_52 
* INOUT : bl_53 
* INOUT : br_53 
* INOUT : bl_54 
* INOUT : br_54 
* INOUT : bl_55 
* INOUT : br_55 
* INOUT : bl_56 
* INOUT : br_56 
* INOUT : bl_57 
* INOUT : br_57 
* INOUT : bl_58 
* INOUT : br_58 
* INOUT : bl_59 
* INOUT : br_59 
* INOUT : bl_60 
* INOUT : br_60 
* INOUT : bl_61 
* INOUT : br_61 
* INOUT : bl_62 
* INOUT : br_62 
* INOUT : bl_63 
* INOUT : br_63 
* INOUT : bl_64 
* INOUT : br_64 
* INOUT : bl_65 
* INOUT : br_65 
* INOUT : bl_66 
* INOUT : br_66 
* INOUT : bl_67 
* INOUT : br_67 
* INOUT : bl_68 
* INOUT : br_68 
* INOUT : bl_69 
* INOUT : br_69 
* INOUT : bl_70 
* INOUT : br_70 
* INOUT : bl_71 
* INOUT : br_71 
* INOUT : bl_72 
* INOUT : br_72 
* INOUT : bl_73 
* INOUT : br_73 
* INOUT : bl_74 
* INOUT : br_74 
* INOUT : bl_75 
* INOUT : br_75 
* INOUT : bl_76 
* INOUT : br_76 
* INOUT : bl_77 
* INOUT : br_77 
* INOUT : bl_78 
* INOUT : br_78 
* INOUT : bl_79 
* INOUT : br_79 
* INOUT : bl_80 
* INOUT : br_80 
* INOUT : bl_81 
* INOUT : br_81 
* INOUT : bl_82 
* INOUT : br_82 
* INOUT : bl_83 
* INOUT : br_83 
* INOUT : bl_84 
* INOUT : br_84 
* INOUT : bl_85 
* INOUT : br_85 
* INOUT : bl_86 
* INOUT : br_86 
* INOUT : bl_87 
* INOUT : br_87 
* INOUT : bl_88 
* INOUT : br_88 
* INOUT : bl_89 
* INOUT : br_89 
* INOUT : bl_90 
* INOUT : br_90 
* INOUT : bl_91 
* INOUT : br_91 
* INOUT : bl_92 
* INOUT : br_92 
* INOUT : bl_93 
* INOUT : br_93 
* INOUT : bl_94 
* INOUT : br_94 
* INOUT : bl_95 
* INOUT : br_95 
* INOUT : bl_96 
* INOUT : br_96 
* INOUT : bl_97 
* INOUT : br_97 
* INOUT : bl_98 
* INOUT : br_98 
* INOUT : bl_99 
* INOUT : br_99 
* INOUT : bl_100 
* INOUT : br_100 
* INOUT : bl_101 
* INOUT : br_101 
* INOUT : bl_102 
* INOUT : br_102 
* INOUT : bl_103 
* INOUT : br_103 
* INOUT : bl_104 
* INOUT : br_104 
* INOUT : bl_105 
* INOUT : br_105 
* INOUT : bl_106 
* INOUT : br_106 
* INOUT : bl_107 
* INOUT : br_107 
* INOUT : bl_108 
* INOUT : br_108 
* INOUT : bl_109 
* INOUT : br_109 
* INOUT : bl_110 
* INOUT : br_110 
* INOUT : bl_111 
* INOUT : br_111 
* INOUT : bl_112 
* INOUT : br_112 
* INOUT : bl_113 
* INOUT : br_113 
* INOUT : bl_114 
* INOUT : br_114 
* INOUT : bl_115 
* INOUT : br_115 
* INOUT : bl_116 
* INOUT : br_116 
* INOUT : bl_117 
* INOUT : br_117 
* INOUT : bl_118 
* INOUT : br_118 
* INOUT : bl_119 
* INOUT : br_119 
* INOUT : bl_120 
* INOUT : br_120 
* INOUT : bl_121 
* INOUT : br_121 
* INOUT : bl_122 
* INOUT : br_122 
* INOUT : bl_123 
* INOUT : br_123 
* INOUT : bl_124 
* INOUT : br_124 
* INOUT : bl_125 
* INOUT : br_125 
* INOUT : bl_126 
* INOUT : br_126 
* INOUT : bl_127 
* INOUT : br_127 
* INOUT : sel_0 
* INOUT : sel_1 
* INOUT : bl_out_0 
* INOUT : br_out_0 
* INOUT : bl_out_1 
* INOUT : br_out_1 
* INOUT : bl_out_2 
* INOUT : br_out_2 
* INOUT : bl_out_3 
* INOUT : br_out_3 
* INOUT : bl_out_4 
* INOUT : br_out_4 
* INOUT : bl_out_5 
* INOUT : br_out_5 
* INOUT : bl_out_6 
* INOUT : br_out_6 
* INOUT : bl_out_7 
* INOUT : br_out_7 
* INOUT : bl_out_8 
* INOUT : br_out_8 
* INOUT : bl_out_9 
* INOUT : br_out_9 
* INOUT : bl_out_10 
* INOUT : br_out_10 
* INOUT : bl_out_11 
* INOUT : br_out_11 
* INOUT : bl_out_12 
* INOUT : br_out_12 
* INOUT : bl_out_13 
* INOUT : br_out_13 
* INOUT : bl_out_14 
* INOUT : br_out_14 
* INOUT : bl_out_15 
* INOUT : br_out_15 
* INOUT : bl_out_16 
* INOUT : br_out_16 
* INOUT : bl_out_17 
* INOUT : br_out_17 
* INOUT : bl_out_18 
* INOUT : br_out_18 
* INOUT : bl_out_19 
* INOUT : br_out_19 
* INOUT : bl_out_20 
* INOUT : br_out_20 
* INOUT : bl_out_21 
* INOUT : br_out_21 
* INOUT : bl_out_22 
* INOUT : br_out_22 
* INOUT : bl_out_23 
* INOUT : br_out_23 
* INOUT : bl_out_24 
* INOUT : br_out_24 
* INOUT : bl_out_25 
* INOUT : br_out_25 
* INOUT : bl_out_26 
* INOUT : br_out_26 
* INOUT : bl_out_27 
* INOUT : br_out_27 
* INOUT : bl_out_28 
* INOUT : br_out_28 
* INOUT : bl_out_29 
* INOUT : br_out_29 
* INOUT : bl_out_30 
* INOUT : br_out_30 
* INOUT : bl_out_31 
* INOUT : br_out_31 
* INOUT : bl_out_32 
* INOUT : br_out_32 
* INOUT : bl_out_33 
* INOUT : br_out_33 
* INOUT : bl_out_34 
* INOUT : br_out_34 
* INOUT : bl_out_35 
* INOUT : br_out_35 
* INOUT : bl_out_36 
* INOUT : br_out_36 
* INOUT : bl_out_37 
* INOUT : br_out_37 
* INOUT : bl_out_38 
* INOUT : br_out_38 
* INOUT : bl_out_39 
* INOUT : br_out_39 
* INOUT : bl_out_40 
* INOUT : br_out_40 
* INOUT : bl_out_41 
* INOUT : br_out_41 
* INOUT : bl_out_42 
* INOUT : br_out_42 
* INOUT : bl_out_43 
* INOUT : br_out_43 
* INOUT : bl_out_44 
* INOUT : br_out_44 
* INOUT : bl_out_45 
* INOUT : br_out_45 
* INOUT : bl_out_46 
* INOUT : br_out_46 
* INOUT : bl_out_47 
* INOUT : br_out_47 
* INOUT : bl_out_48 
* INOUT : br_out_48 
* INOUT : bl_out_49 
* INOUT : br_out_49 
* INOUT : bl_out_50 
* INOUT : br_out_50 
* INOUT : bl_out_51 
* INOUT : br_out_51 
* INOUT : bl_out_52 
* INOUT : br_out_52 
* INOUT : bl_out_53 
* INOUT : br_out_53 
* INOUT : bl_out_54 
* INOUT : br_out_54 
* INOUT : bl_out_55 
* INOUT : br_out_55 
* INOUT : bl_out_56 
* INOUT : br_out_56 
* INOUT : bl_out_57 
* INOUT : br_out_57 
* INOUT : bl_out_58 
* INOUT : br_out_58 
* INOUT : bl_out_59 
* INOUT : br_out_59 
* INOUT : bl_out_60 
* INOUT : br_out_60 
* INOUT : bl_out_61 
* INOUT : br_out_61 
* INOUT : bl_out_62 
* INOUT : br_out_62 
* INOUT : bl_out_63 
* INOUT : br_out_63 
* INOUT : gnd 
* cols: 128 word_size: 64 bl: bl1 br: br1
XXMUX0 bl_0 br_0 bl_out_0 br_out_0 sel_0 gnd column_mux_0
XXMUX1 bl_1 br_1 bl_out_0 br_out_0 sel_1 gnd column_mux_0
XXMUX2 bl_2 br_2 bl_out_1 br_out_1 sel_0 gnd column_mux_0
XXMUX3 bl_3 br_3 bl_out_1 br_out_1 sel_1 gnd column_mux_0
XXMUX4 bl_4 br_4 bl_out_2 br_out_2 sel_0 gnd column_mux_0
XXMUX5 bl_5 br_5 bl_out_2 br_out_2 sel_1 gnd column_mux_0
XXMUX6 bl_6 br_6 bl_out_3 br_out_3 sel_0 gnd column_mux_0
XXMUX7 bl_7 br_7 bl_out_3 br_out_3 sel_1 gnd column_mux_0
XXMUX8 bl_8 br_8 bl_out_4 br_out_4 sel_0 gnd column_mux_0
XXMUX9 bl_9 br_9 bl_out_4 br_out_4 sel_1 gnd column_mux_0
XXMUX10 bl_10 br_10 bl_out_5 br_out_5 sel_0 gnd column_mux_0
XXMUX11 bl_11 br_11 bl_out_5 br_out_5 sel_1 gnd column_mux_0
XXMUX12 bl_12 br_12 bl_out_6 br_out_6 sel_0 gnd column_mux_0
XXMUX13 bl_13 br_13 bl_out_6 br_out_6 sel_1 gnd column_mux_0
XXMUX14 bl_14 br_14 bl_out_7 br_out_7 sel_0 gnd column_mux_0
XXMUX15 bl_15 br_15 bl_out_7 br_out_7 sel_1 gnd column_mux_0
XXMUX16 bl_16 br_16 bl_out_8 br_out_8 sel_0 gnd column_mux_0
XXMUX17 bl_17 br_17 bl_out_8 br_out_8 sel_1 gnd column_mux_0
XXMUX18 bl_18 br_18 bl_out_9 br_out_9 sel_0 gnd column_mux_0
XXMUX19 bl_19 br_19 bl_out_9 br_out_9 sel_1 gnd column_mux_0
XXMUX20 bl_20 br_20 bl_out_10 br_out_10 sel_0 gnd column_mux_0
XXMUX21 bl_21 br_21 bl_out_10 br_out_10 sel_1 gnd column_mux_0
XXMUX22 bl_22 br_22 bl_out_11 br_out_11 sel_0 gnd column_mux_0
XXMUX23 bl_23 br_23 bl_out_11 br_out_11 sel_1 gnd column_mux_0
XXMUX24 bl_24 br_24 bl_out_12 br_out_12 sel_0 gnd column_mux_0
XXMUX25 bl_25 br_25 bl_out_12 br_out_12 sel_1 gnd column_mux_0
XXMUX26 bl_26 br_26 bl_out_13 br_out_13 sel_0 gnd column_mux_0
XXMUX27 bl_27 br_27 bl_out_13 br_out_13 sel_1 gnd column_mux_0
XXMUX28 bl_28 br_28 bl_out_14 br_out_14 sel_0 gnd column_mux_0
XXMUX29 bl_29 br_29 bl_out_14 br_out_14 sel_1 gnd column_mux_0
XXMUX30 bl_30 br_30 bl_out_15 br_out_15 sel_0 gnd column_mux_0
XXMUX31 bl_31 br_31 bl_out_15 br_out_15 sel_1 gnd column_mux_0
XXMUX32 bl_32 br_32 bl_out_16 br_out_16 sel_0 gnd column_mux_0
XXMUX33 bl_33 br_33 bl_out_16 br_out_16 sel_1 gnd column_mux_0
XXMUX34 bl_34 br_34 bl_out_17 br_out_17 sel_0 gnd column_mux_0
XXMUX35 bl_35 br_35 bl_out_17 br_out_17 sel_1 gnd column_mux_0
XXMUX36 bl_36 br_36 bl_out_18 br_out_18 sel_0 gnd column_mux_0
XXMUX37 bl_37 br_37 bl_out_18 br_out_18 sel_1 gnd column_mux_0
XXMUX38 bl_38 br_38 bl_out_19 br_out_19 sel_0 gnd column_mux_0
XXMUX39 bl_39 br_39 bl_out_19 br_out_19 sel_1 gnd column_mux_0
XXMUX40 bl_40 br_40 bl_out_20 br_out_20 sel_0 gnd column_mux_0
XXMUX41 bl_41 br_41 bl_out_20 br_out_20 sel_1 gnd column_mux_0
XXMUX42 bl_42 br_42 bl_out_21 br_out_21 sel_0 gnd column_mux_0
XXMUX43 bl_43 br_43 bl_out_21 br_out_21 sel_1 gnd column_mux_0
XXMUX44 bl_44 br_44 bl_out_22 br_out_22 sel_0 gnd column_mux_0
XXMUX45 bl_45 br_45 bl_out_22 br_out_22 sel_1 gnd column_mux_0
XXMUX46 bl_46 br_46 bl_out_23 br_out_23 sel_0 gnd column_mux_0
XXMUX47 bl_47 br_47 bl_out_23 br_out_23 sel_1 gnd column_mux_0
XXMUX48 bl_48 br_48 bl_out_24 br_out_24 sel_0 gnd column_mux_0
XXMUX49 bl_49 br_49 bl_out_24 br_out_24 sel_1 gnd column_mux_0
XXMUX50 bl_50 br_50 bl_out_25 br_out_25 sel_0 gnd column_mux_0
XXMUX51 bl_51 br_51 bl_out_25 br_out_25 sel_1 gnd column_mux_0
XXMUX52 bl_52 br_52 bl_out_26 br_out_26 sel_0 gnd column_mux_0
XXMUX53 bl_53 br_53 bl_out_26 br_out_26 sel_1 gnd column_mux_0
XXMUX54 bl_54 br_54 bl_out_27 br_out_27 sel_0 gnd column_mux_0
XXMUX55 bl_55 br_55 bl_out_27 br_out_27 sel_1 gnd column_mux_0
XXMUX56 bl_56 br_56 bl_out_28 br_out_28 sel_0 gnd column_mux_0
XXMUX57 bl_57 br_57 bl_out_28 br_out_28 sel_1 gnd column_mux_0
XXMUX58 bl_58 br_58 bl_out_29 br_out_29 sel_0 gnd column_mux_0
XXMUX59 bl_59 br_59 bl_out_29 br_out_29 sel_1 gnd column_mux_0
XXMUX60 bl_60 br_60 bl_out_30 br_out_30 sel_0 gnd column_mux_0
XXMUX61 bl_61 br_61 bl_out_30 br_out_30 sel_1 gnd column_mux_0
XXMUX62 bl_62 br_62 bl_out_31 br_out_31 sel_0 gnd column_mux_0
XXMUX63 bl_63 br_63 bl_out_31 br_out_31 sel_1 gnd column_mux_0
XXMUX64 bl_64 br_64 bl_out_32 br_out_32 sel_0 gnd column_mux_0
XXMUX65 bl_65 br_65 bl_out_32 br_out_32 sel_1 gnd column_mux_0
XXMUX66 bl_66 br_66 bl_out_33 br_out_33 sel_0 gnd column_mux_0
XXMUX67 bl_67 br_67 bl_out_33 br_out_33 sel_1 gnd column_mux_0
XXMUX68 bl_68 br_68 bl_out_34 br_out_34 sel_0 gnd column_mux_0
XXMUX69 bl_69 br_69 bl_out_34 br_out_34 sel_1 gnd column_mux_0
XXMUX70 bl_70 br_70 bl_out_35 br_out_35 sel_0 gnd column_mux_0
XXMUX71 bl_71 br_71 bl_out_35 br_out_35 sel_1 gnd column_mux_0
XXMUX72 bl_72 br_72 bl_out_36 br_out_36 sel_0 gnd column_mux_0
XXMUX73 bl_73 br_73 bl_out_36 br_out_36 sel_1 gnd column_mux_0
XXMUX74 bl_74 br_74 bl_out_37 br_out_37 sel_0 gnd column_mux_0
XXMUX75 bl_75 br_75 bl_out_37 br_out_37 sel_1 gnd column_mux_0
XXMUX76 bl_76 br_76 bl_out_38 br_out_38 sel_0 gnd column_mux_0
XXMUX77 bl_77 br_77 bl_out_38 br_out_38 sel_1 gnd column_mux_0
XXMUX78 bl_78 br_78 bl_out_39 br_out_39 sel_0 gnd column_mux_0
XXMUX79 bl_79 br_79 bl_out_39 br_out_39 sel_1 gnd column_mux_0
XXMUX80 bl_80 br_80 bl_out_40 br_out_40 sel_0 gnd column_mux_0
XXMUX81 bl_81 br_81 bl_out_40 br_out_40 sel_1 gnd column_mux_0
XXMUX82 bl_82 br_82 bl_out_41 br_out_41 sel_0 gnd column_mux_0
XXMUX83 bl_83 br_83 bl_out_41 br_out_41 sel_1 gnd column_mux_0
XXMUX84 bl_84 br_84 bl_out_42 br_out_42 sel_0 gnd column_mux_0
XXMUX85 bl_85 br_85 bl_out_42 br_out_42 sel_1 gnd column_mux_0
XXMUX86 bl_86 br_86 bl_out_43 br_out_43 sel_0 gnd column_mux_0
XXMUX87 bl_87 br_87 bl_out_43 br_out_43 sel_1 gnd column_mux_0
XXMUX88 bl_88 br_88 bl_out_44 br_out_44 sel_0 gnd column_mux_0
XXMUX89 bl_89 br_89 bl_out_44 br_out_44 sel_1 gnd column_mux_0
XXMUX90 bl_90 br_90 bl_out_45 br_out_45 sel_0 gnd column_mux_0
XXMUX91 bl_91 br_91 bl_out_45 br_out_45 sel_1 gnd column_mux_0
XXMUX92 bl_92 br_92 bl_out_46 br_out_46 sel_0 gnd column_mux_0
XXMUX93 bl_93 br_93 bl_out_46 br_out_46 sel_1 gnd column_mux_0
XXMUX94 bl_94 br_94 bl_out_47 br_out_47 sel_0 gnd column_mux_0
XXMUX95 bl_95 br_95 bl_out_47 br_out_47 sel_1 gnd column_mux_0
XXMUX96 bl_96 br_96 bl_out_48 br_out_48 sel_0 gnd column_mux_0
XXMUX97 bl_97 br_97 bl_out_48 br_out_48 sel_1 gnd column_mux_0
XXMUX98 bl_98 br_98 bl_out_49 br_out_49 sel_0 gnd column_mux_0
XXMUX99 bl_99 br_99 bl_out_49 br_out_49 sel_1 gnd column_mux_0
XXMUX100 bl_100 br_100 bl_out_50 br_out_50 sel_0 gnd column_mux_0
XXMUX101 bl_101 br_101 bl_out_50 br_out_50 sel_1 gnd column_mux_0
XXMUX102 bl_102 br_102 bl_out_51 br_out_51 sel_0 gnd column_mux_0
XXMUX103 bl_103 br_103 bl_out_51 br_out_51 sel_1 gnd column_mux_0
XXMUX104 bl_104 br_104 bl_out_52 br_out_52 sel_0 gnd column_mux_0
XXMUX105 bl_105 br_105 bl_out_52 br_out_52 sel_1 gnd column_mux_0
XXMUX106 bl_106 br_106 bl_out_53 br_out_53 sel_0 gnd column_mux_0
XXMUX107 bl_107 br_107 bl_out_53 br_out_53 sel_1 gnd column_mux_0
XXMUX108 bl_108 br_108 bl_out_54 br_out_54 sel_0 gnd column_mux_0
XXMUX109 bl_109 br_109 bl_out_54 br_out_54 sel_1 gnd column_mux_0
XXMUX110 bl_110 br_110 bl_out_55 br_out_55 sel_0 gnd column_mux_0
XXMUX111 bl_111 br_111 bl_out_55 br_out_55 sel_1 gnd column_mux_0
XXMUX112 bl_112 br_112 bl_out_56 br_out_56 sel_0 gnd column_mux_0
XXMUX113 bl_113 br_113 bl_out_56 br_out_56 sel_1 gnd column_mux_0
XXMUX114 bl_114 br_114 bl_out_57 br_out_57 sel_0 gnd column_mux_0
XXMUX115 bl_115 br_115 bl_out_57 br_out_57 sel_1 gnd column_mux_0
XXMUX116 bl_116 br_116 bl_out_58 br_out_58 sel_0 gnd column_mux_0
XXMUX117 bl_117 br_117 bl_out_58 br_out_58 sel_1 gnd column_mux_0
XXMUX118 bl_118 br_118 bl_out_59 br_out_59 sel_0 gnd column_mux_0
XXMUX119 bl_119 br_119 bl_out_59 br_out_59 sel_1 gnd column_mux_0
XXMUX120 bl_120 br_120 bl_out_60 br_out_60 sel_0 gnd column_mux_0
XXMUX121 bl_121 br_121 bl_out_60 br_out_60 sel_1 gnd column_mux_0
XXMUX122 bl_122 br_122 bl_out_61 br_out_61 sel_0 gnd column_mux_0
XXMUX123 bl_123 br_123 bl_out_61 br_out_61 sel_1 gnd column_mux_0
XXMUX124 bl_124 br_124 bl_out_62 br_out_62 sel_0 gnd column_mux_0
XXMUX125 bl_125 br_125 bl_out_62 br_out_62 sel_1 gnd column_mux_0
XXMUX126 bl_126 br_126 bl_out_63 br_out_63 sel_0 gnd column_mux_0
XXMUX127 bl_127 br_127 bl_out_63 br_out_63 sel_1 gnd column_mux_0
.ENDS column_mux_array_0

.SUBCKT port_data_0 rbl_bl rbl_br bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 dout_0 dout_1 dout_2 dout_3 dout_4 dout_5 dout_6 dout_7 dout_8 dout_9 dout_10 dout_11 dout_12 dout_13 dout_14 dout_15 dout_16 dout_17 dout_18 dout_19 dout_20 dout_21 dout_22 dout_23 dout_24 dout_25 dout_26 dout_27 dout_28 dout_29 dout_30 dout_31 dout_32 dout_33 dout_34 dout_35 dout_36 dout_37 dout_38 dout_39 dout_40 dout_41 dout_42 dout_43 dout_44 dout_45 dout_46 dout_47 dout_48 dout_49 dout_50 dout_51 dout_52 dout_53 dout_54 dout_55 dout_56 dout_57 dout_58 dout_59 dout_60 dout_61 dout_62 dout_63 sel_0 sel_1 s_en p_en_bar vdd gnd
*.PININFO rbl_bl:B rbl_br:B bl_0:B br_0:B bl_1:B br_1:B bl_2:B br_2:B bl_3:B br_3:B bl_4:B br_4:B bl_5:B br_5:B bl_6:B br_6:B bl_7:B br_7:B bl_8:B br_8:B bl_9:B br_9:B bl_10:B br_10:B bl_11:B br_11:B bl_12:B br_12:B bl_13:B br_13:B bl_14:B br_14:B bl_15:B br_15:B bl_16:B br_16:B bl_17:B br_17:B bl_18:B br_18:B bl_19:B br_19:B bl_20:B br_20:B bl_21:B br_21:B bl_22:B br_22:B bl_23:B br_23:B bl_24:B br_24:B bl_25:B br_25:B bl_26:B br_26:B bl_27:B br_27:B bl_28:B br_28:B bl_29:B br_29:B bl_30:B br_30:B bl_31:B br_31:B bl_32:B br_32:B bl_33:B br_33:B bl_34:B br_34:B bl_35:B br_35:B bl_36:B br_36:B bl_37:B br_37:B bl_38:B br_38:B bl_39:B br_39:B bl_40:B br_40:B bl_41:B br_41:B bl_42:B br_42:B bl_43:B br_43:B bl_44:B br_44:B bl_45:B br_45:B bl_46:B br_46:B bl_47:B br_47:B bl_48:B br_48:B bl_49:B br_49:B bl_50:B br_50:B bl_51:B br_51:B bl_52:B br_52:B bl_53:B br_53:B bl_54:B br_54:B bl_55:B br_55:B bl_56:B br_56:B bl_57:B br_57:B bl_58:B br_58:B bl_59:B br_59:B bl_60:B br_60:B bl_61:B br_61:B bl_62:B br_62:B bl_63:B br_63:B bl_64:B br_64:B bl_65:B br_65:B bl_66:B br_66:B bl_67:B br_67:B bl_68:B br_68:B bl_69:B br_69:B bl_70:B br_70:B bl_71:B br_71:B bl_72:B br_72:B bl_73:B br_73:B bl_74:B br_74:B bl_75:B br_75:B bl_76:B br_76:B bl_77:B br_77:B bl_78:B br_78:B bl_79:B br_79:B bl_80:B br_80:B bl_81:B br_81:B bl_82:B br_82:B bl_83:B br_83:B bl_84:B br_84:B bl_85:B br_85:B bl_86:B br_86:B bl_87:B br_87:B bl_88:B br_88:B bl_89:B br_89:B bl_90:B br_90:B bl_91:B br_91:B bl_92:B br_92:B bl_93:B br_93:B bl_94:B br_94:B bl_95:B br_95:B bl_96:B br_96:B bl_97:B br_97:B bl_98:B br_98:B bl_99:B br_99:B bl_100:B br_100:B bl_101:B br_101:B bl_102:B br_102:B bl_103:B br_103:B bl_104:B br_104:B bl_105:B br_105:B bl_106:B br_106:B bl_107:B br_107:B bl_108:B br_108:B bl_109:B br_109:B bl_110:B br_110:B bl_111:B br_111:B bl_112:B br_112:B bl_113:B br_113:B bl_114:B br_114:B bl_115:B br_115:B bl_116:B br_116:B bl_117:B br_117:B bl_118:B br_118:B bl_119:B br_119:B bl_120:B br_120:B bl_121:B br_121:B bl_122:B br_122:B bl_123:B br_123:B bl_124:B br_124:B bl_125:B br_125:B bl_126:B br_126:B bl_127:B br_127:B dout_0:O dout_1:O dout_2:O dout_3:O dout_4:O dout_5:O dout_6:O dout_7:O dout_8:O dout_9:O dout_10:O dout_11:O dout_12:O dout_13:O dout_14:O dout_15:O dout_16:O dout_17:O dout_18:O dout_19:O dout_20:O dout_21:O dout_22:O dout_23:O dout_24:O dout_25:O dout_26:O dout_27:O dout_28:O dout_29:O dout_30:O dout_31:O dout_32:O dout_33:O dout_34:O dout_35:O dout_36:O dout_37:O dout_38:O dout_39:O dout_40:O dout_41:O dout_42:O dout_43:O dout_44:O dout_45:O dout_46:O dout_47:O dout_48:O dout_49:O dout_50:O dout_51:O dout_52:O dout_53:O dout_54:O dout_55:O dout_56:O dout_57:O dout_58:O dout_59:O dout_60:O dout_61:O dout_62:O dout_63:O sel_0:I sel_1:I s_en:I p_en_bar:I vdd:B gnd:B
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
* INOUT : bl_44 
* INOUT : br_44 
* INOUT : bl_45 
* INOUT : br_45 
* INOUT : bl_46 
* INOUT : br_46 
* INOUT : bl_47 
* INOUT : br_47 
* INOUT : bl_48 
* INOUT : br_48 
* INOUT : bl_49 
* INOUT : br_49 
* INOUT : bl_50 
* INOUT : br_50 
* INOUT : bl_51 
* INOUT : br_51 
* INOUT : bl_52 
* INOUT : br_52 
* INOUT : bl_53 
* INOUT : br_53 
* INOUT : bl_54 
* INOUT : br_54 
* INOUT : bl_55 
* INOUT : br_55 
* INOUT : bl_56 
* INOUT : br_56 
* INOUT : bl_57 
* INOUT : br_57 
* INOUT : bl_58 
* INOUT : br_58 
* INOUT : bl_59 
* INOUT : br_59 
* INOUT : bl_60 
* INOUT : br_60 
* INOUT : bl_61 
* INOUT : br_61 
* INOUT : bl_62 
* INOUT : br_62 
* INOUT : bl_63 
* INOUT : br_63 
* INOUT : bl_64 
* INOUT : br_64 
* INOUT : bl_65 
* INOUT : br_65 
* INOUT : bl_66 
* INOUT : br_66 
* INOUT : bl_67 
* INOUT : br_67 
* INOUT : bl_68 
* INOUT : br_68 
* INOUT : bl_69 
* INOUT : br_69 
* INOUT : bl_70 
* INOUT : br_70 
* INOUT : bl_71 
* INOUT : br_71 
* INOUT : bl_72 
* INOUT : br_72 
* INOUT : bl_73 
* INOUT : br_73 
* INOUT : bl_74 
* INOUT : br_74 
* INOUT : bl_75 
* INOUT : br_75 
* INOUT : bl_76 
* INOUT : br_76 
* INOUT : bl_77 
* INOUT : br_77 
* INOUT : bl_78 
* INOUT : br_78 
* INOUT : bl_79 
* INOUT : br_79 
* INOUT : bl_80 
* INOUT : br_80 
* INOUT : bl_81 
* INOUT : br_81 
* INOUT : bl_82 
* INOUT : br_82 
* INOUT : bl_83 
* INOUT : br_83 
* INOUT : bl_84 
* INOUT : br_84 
* INOUT : bl_85 
* INOUT : br_85 
* INOUT : bl_86 
* INOUT : br_86 
* INOUT : bl_87 
* INOUT : br_87 
* INOUT : bl_88 
* INOUT : br_88 
* INOUT : bl_89 
* INOUT : br_89 
* INOUT : bl_90 
* INOUT : br_90 
* INOUT : bl_91 
* INOUT : br_91 
* INOUT : bl_92 
* INOUT : br_92 
* INOUT : bl_93 
* INOUT : br_93 
* INOUT : bl_94 
* INOUT : br_94 
* INOUT : bl_95 
* INOUT : br_95 
* INOUT : bl_96 
* INOUT : br_96 
* INOUT : bl_97 
* INOUT : br_97 
* INOUT : bl_98 
* INOUT : br_98 
* INOUT : bl_99 
* INOUT : br_99 
* INOUT : bl_100 
* INOUT : br_100 
* INOUT : bl_101 
* INOUT : br_101 
* INOUT : bl_102 
* INOUT : br_102 
* INOUT : bl_103 
* INOUT : br_103 
* INOUT : bl_104 
* INOUT : br_104 
* INOUT : bl_105 
* INOUT : br_105 
* INOUT : bl_106 
* INOUT : br_106 
* INOUT : bl_107 
* INOUT : br_107 
* INOUT : bl_108 
* INOUT : br_108 
* INOUT : bl_109 
* INOUT : br_109 
* INOUT : bl_110 
* INOUT : br_110 
* INOUT : bl_111 
* INOUT : br_111 
* INOUT : bl_112 
* INOUT : br_112 
* INOUT : bl_113 
* INOUT : br_113 
* INOUT : bl_114 
* INOUT : br_114 
* INOUT : bl_115 
* INOUT : br_115 
* INOUT : bl_116 
* INOUT : br_116 
* INOUT : bl_117 
* INOUT : br_117 
* INOUT : bl_118 
* INOUT : br_118 
* INOUT : bl_119 
* INOUT : br_119 
* INOUT : bl_120 
* INOUT : br_120 
* INOUT : bl_121 
* INOUT : br_121 
* INOUT : bl_122 
* INOUT : br_122 
* INOUT : bl_123 
* INOUT : br_123 
* INOUT : bl_124 
* INOUT : br_124 
* INOUT : bl_125 
* INOUT : br_125 
* INOUT : bl_126 
* INOUT : br_126 
* INOUT : bl_127 
* INOUT : br_127 
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
* OUTPUT: dout_44 
* OUTPUT: dout_45 
* OUTPUT: dout_46 
* OUTPUT: dout_47 
* OUTPUT: dout_48 
* OUTPUT: dout_49 
* OUTPUT: dout_50 
* OUTPUT: dout_51 
* OUTPUT: dout_52 
* OUTPUT: dout_53 
* OUTPUT: dout_54 
* OUTPUT: dout_55 
* OUTPUT: dout_56 
* OUTPUT: dout_57 
* OUTPUT: dout_58 
* OUTPUT: dout_59 
* OUTPUT: dout_60 
* OUTPUT: dout_61 
* OUTPUT: dout_62 
* OUTPUT: dout_63 
* INPUT : sel_0 
* INPUT : sel_1 
* INPUT : s_en 
* INPUT : p_en_bar 
* POWER : vdd 
* GROUND: gnd 
Xprecharge_array1 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 rbl_bl rbl_br p_en_bar vdd precharge_array_0
Xsense_amp_array1 dout_0 bl_out_0 br_out_0 dout_1 bl_out_1 br_out_1 dout_2 bl_out_2 br_out_2 dout_3 bl_out_3 br_out_3 dout_4 bl_out_4 br_out_4 dout_5 bl_out_5 br_out_5 dout_6 bl_out_6 br_out_6 dout_7 bl_out_7 br_out_7 dout_8 bl_out_8 br_out_8 dout_9 bl_out_9 br_out_9 dout_10 bl_out_10 br_out_10 dout_11 bl_out_11 br_out_11 dout_12 bl_out_12 br_out_12 dout_13 bl_out_13 br_out_13 dout_14 bl_out_14 br_out_14 dout_15 bl_out_15 br_out_15 dout_16 bl_out_16 br_out_16 dout_17 bl_out_17 br_out_17 dout_18 bl_out_18 br_out_18 dout_19 bl_out_19 br_out_19 dout_20 bl_out_20 br_out_20 dout_21 bl_out_21 br_out_21 dout_22 bl_out_22 br_out_22 dout_23 bl_out_23 br_out_23 dout_24 bl_out_24 br_out_24 dout_25 bl_out_25 br_out_25 dout_26 bl_out_26 br_out_26 dout_27 bl_out_27 br_out_27 dout_28 bl_out_28 br_out_28 dout_29 bl_out_29 br_out_29 dout_30 bl_out_30 br_out_30 dout_31 bl_out_31 br_out_31 dout_32 bl_out_32 br_out_32 dout_33 bl_out_33 br_out_33 dout_34 bl_out_34 br_out_34 dout_35 bl_out_35 br_out_35 dout_36 bl_out_36 br_out_36 dout_37 bl_out_37 br_out_37 dout_38 bl_out_38 br_out_38 dout_39 bl_out_39 br_out_39 dout_40 bl_out_40 br_out_40 dout_41 bl_out_41 br_out_41 dout_42 bl_out_42 br_out_42 dout_43 bl_out_43 br_out_43 dout_44 bl_out_44 br_out_44 dout_45 bl_out_45 br_out_45 dout_46 bl_out_46 br_out_46 dout_47 bl_out_47 br_out_47 dout_48 bl_out_48 br_out_48 dout_49 bl_out_49 br_out_49 dout_50 bl_out_50 br_out_50 dout_51 bl_out_51 br_out_51 dout_52 bl_out_52 br_out_52 dout_53 bl_out_53 br_out_53 dout_54 bl_out_54 br_out_54 dout_55 bl_out_55 br_out_55 dout_56 bl_out_56 br_out_56 dout_57 bl_out_57 br_out_57 dout_58 bl_out_58 br_out_58 dout_59 bl_out_59 br_out_59 dout_60 bl_out_60 br_out_60 dout_61 bl_out_61 br_out_61 dout_62 bl_out_62 br_out_62 dout_63 bl_out_63 br_out_63 s_en vdd gnd sense_amp_array
Xcolumn_mux_array1 bl_0 br_0 bl_1 br_1 bl_2 br_2 bl_3 br_3 bl_4 br_4 bl_5 br_5 bl_6 br_6 bl_7 br_7 bl_8 br_8 bl_9 br_9 bl_10 br_10 bl_11 br_11 bl_12 br_12 bl_13 br_13 bl_14 br_14 bl_15 br_15 bl_16 br_16 bl_17 br_17 bl_18 br_18 bl_19 br_19 bl_20 br_20 bl_21 br_21 bl_22 br_22 bl_23 br_23 bl_24 br_24 bl_25 br_25 bl_26 br_26 bl_27 br_27 bl_28 br_28 bl_29 br_29 bl_30 br_30 bl_31 br_31 bl_32 br_32 bl_33 br_33 bl_34 br_34 bl_35 br_35 bl_36 br_36 bl_37 br_37 bl_38 br_38 bl_39 br_39 bl_40 br_40 bl_41 br_41 bl_42 br_42 bl_43 br_43 bl_44 br_44 bl_45 br_45 bl_46 br_46 bl_47 br_47 bl_48 br_48 bl_49 br_49 bl_50 br_50 bl_51 br_51 bl_52 br_52 bl_53 br_53 bl_54 br_54 bl_55 br_55 bl_56 br_56 bl_57 br_57 bl_58 br_58 bl_59 br_59 bl_60 br_60 bl_61 br_61 bl_62 br_62 bl_63 br_63 bl_64 br_64 bl_65 br_65 bl_66 br_66 bl_67 br_67 bl_68 br_68 bl_69 br_69 bl_70 br_70 bl_71 br_71 bl_72 br_72 bl_73 br_73 bl_74 br_74 bl_75 br_75 bl_76 br_76 bl_77 br_77 bl_78 br_78 bl_79 br_79 bl_80 br_80 bl_81 br_81 bl_82 br_82 bl_83 br_83 bl_84 br_84 bl_85 br_85 bl_86 br_86 bl_87 br_87 bl_88 br_88 bl_89 br_89 bl_90 br_90 bl_91 br_91 bl_92 br_92 bl_93 br_93 bl_94 br_94 bl_95 br_95 bl_96 br_96 bl_97 br_97 bl_98 br_98 bl_99 br_99 bl_100 br_100 bl_101 br_101 bl_102 br_102 bl_103 br_103 bl_104 br_104 bl_105 br_105 bl_106 br_106 bl_107 br_107 bl_108 br_108 bl_109 br_109 bl_110 br_110 bl_111 br_111 bl_112 br_112 bl_113 br_113 bl_114 br_114 bl_115 br_115 bl_116 br_116 bl_117 br_117 bl_118 br_118 bl_119 br_119 bl_120 br_120 bl_121 br_121 bl_122 br_122 bl_123 br_123 bl_124 br_124 bl_125 br_125 bl_126 br_126 bl_127 br_127 sel_0 sel_1 bl_out_0 br_out_0 bl_out_1 br_out_1 bl_out_2 br_out_2 bl_out_3 br_out_3 bl_out_4 br_out_4 bl_out_5 br_out_5 bl_out_6 br_out_6 bl_out_7 br_out_7 bl_out_8 br_out_8 bl_out_9 br_out_9 bl_out_10 br_out_10 bl_out_11 br_out_11 bl_out_12 br_out_12 bl_out_13 br_out_13 bl_out_14 br_out_14 bl_out_15 br_out_15 bl_out_16 br_out_16 bl_out_17 br_out_17 bl_out_18 br_out_18 bl_out_19 br_out_19 bl_out_20 br_out_20 bl_out_21 br_out_21 bl_out_22 br_out_22 bl_out_23 br_out_23 bl_out_24 br_out_24 bl_out_25 br_out_25 bl_out_26 br_out_26 bl_out_27 br_out_27 bl_out_28 br_out_28 bl_out_29 br_out_29 bl_out_30 br_out_30 bl_out_31 br_out_31 bl_out_32 br_out_32 bl_out_33 br_out_33 bl_out_34 br_out_34 bl_out_35 br_out_35 bl_out_36 br_out_36 bl_out_37 br_out_37 bl_out_38 br_out_38 bl_out_39 br_out_39 bl_out_40 br_out_40 bl_out_41 br_out_41 bl_out_42 br_out_42 bl_out_43 br_out_43 bl_out_44 br_out_44 bl_out_45 br_out_45 bl_out_46 br_out_46 bl_out_47 br_out_47 bl_out_48 br_out_48 bl_out_49 br_out_49 bl_out_50 br_out_50 bl_out_51 br_out_51 bl_out_52 br_out_52 bl_out_53 br_out_53 bl_out_54 br_out_54 bl_out_55 br_out_55 bl_out_56 br_out_56 bl_out_57 br_out_57 bl_out_58 br_out_58 bl_out_59 br_out_59 bl_out_60 br_out_60 bl_out_61 br_out_61 bl_out_62 br_out_62 bl_out_63 br_out_63 gnd column_mux_array_0
.ENDS port_data_0

.SUBCKT pinv_0 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_0

.SUBCKT pinv_1 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=2 w=1.26u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=2 w=0.74u l=0.15u
.ENDS pinv_1

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=3 w=1.68 l=0.15 pd=3.66 ps=3.66 as=0.63u ad=0.63u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=3 w=1.68 l=0.15 pd=3.66 ps=3.66 as=0.63u ad=0.63u

.SUBCKT pinv_2 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=3 w=1.68u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=3 w=1.68u l=0.15u
.ENDS pinv_2

.SUBCKT pinvbuf A Zb Z vdd gnd
*.PININFO A:B Zb:B Z:B vdd:B gnd:B
* INOUT : A 
* INOUT : Zb 
* INOUT : Z 
* INOUT : vdd 
* INOUT : gnd 
Xbuf_inv1 A zb_int vdd gnd pinv_0
Xbuf_inv2 zb_int z_int vdd gnd pinv_1
Xbuf_inv3 z_int Zb vdd gnd pinv_2
Xbuf_inv4 zb_int Z vdd gnd pinv_2
.ENDS pinvbuf

.SUBCKT bank dout0_0 dout0_1 dout0_2 dout0_3 dout0_4 dout0_5 dout0_6 dout0_7 dout0_8 dout0_9 dout0_10 dout0_11 dout0_12 dout0_13 dout0_14 dout0_15 dout0_16 dout0_17 dout0_18 dout0_19 dout0_20 dout0_21 dout0_22 dout0_23 dout0_24 dout0_25 dout0_26 dout0_27 dout0_28 dout0_29 dout0_30 dout0_31 dout0_32 dout0_33 dout0_34 dout0_35 dout0_36 dout0_37 dout0_38 dout0_39 dout0_40 dout0_41 dout0_42 dout0_43 dout0_44 dout0_45 dout0_46 dout0_47 dout0_48 dout0_49 dout0_50 dout0_51 dout0_52 dout0_53 dout0_54 dout0_55 dout0_56 dout0_57 dout0_58 dout0_59 dout0_60 dout0_61 dout0_62 dout0_63 dout1_0 dout1_1 dout1_2 dout1_3 dout1_4 dout1_5 dout1_6 dout1_7 dout1_8 dout1_9 dout1_10 dout1_11 dout1_12 dout1_13 dout1_14 dout1_15 dout1_16 dout1_17 dout1_18 dout1_19 dout1_20 dout1_21 dout1_22 dout1_23 dout1_24 dout1_25 dout1_26 dout1_27 dout1_28 dout1_29 dout1_30 dout1_31 dout1_32 dout1_33 dout1_34 dout1_35 dout1_36 dout1_37 dout1_38 dout1_39 dout1_40 dout1_41 dout1_42 dout1_43 dout1_44 dout1_45 dout1_46 dout1_47 dout1_48 dout1_49 dout1_50 dout1_51 dout1_52 dout1_53 dout1_54 dout1_55 dout1_56 dout1_57 dout1_58 dout1_59 dout1_60 dout1_61 dout1_62 dout1_63 rbl_bl_0_0 rbl_bl_1_1 din0_0 din0_1 din0_2 din0_3 din0_4 din0_5 din0_6 din0_7 din0_8 din0_9 din0_10 din0_11 din0_12 din0_13 din0_14 din0_15 din0_16 din0_17 din0_18 din0_19 din0_20 din0_21 din0_22 din0_23 din0_24 din0_25 din0_26 din0_27 din0_28 din0_29 din0_30 din0_31 din0_32 din0_33 din0_34 din0_35 din0_36 din0_37 din0_38 din0_39 din0_40 din0_41 din0_42 din0_43 din0_44 din0_45 din0_46 din0_47 din0_48 din0_49 din0_50 din0_51 din0_52 din0_53 din0_54 din0_55 din0_56 din0_57 din0_58 din0_59 din0_60 din0_61 din0_62 din0_63 addr0_0 addr0_1 addr0_2 addr0_3 addr0_4 addr0_5 addr0_6 addr0_7 addr1_0 addr1_1 addr1_2 addr1_3 addr1_4 addr1_5 addr1_6 addr1_7 s_en0 s_en1 p_en_bar0 p_en_bar1 w_en0 bank_wmask0_0 bank_wmask0_1 bank_wmask0_2 bank_wmask0_3 bank_wmask0_4 bank_wmask0_5 bank_wmask0_6 bank_wmask0_7 wl_en0 wl_en1 vdd gnd
*.PININFO dout0_0:O dout0_1:O dout0_2:O dout0_3:O dout0_4:O dout0_5:O dout0_6:O dout0_7:O dout0_8:O dout0_9:O dout0_10:O dout0_11:O dout0_12:O dout0_13:O dout0_14:O dout0_15:O dout0_16:O dout0_17:O dout0_18:O dout0_19:O dout0_20:O dout0_21:O dout0_22:O dout0_23:O dout0_24:O dout0_25:O dout0_26:O dout0_27:O dout0_28:O dout0_29:O dout0_30:O dout0_31:O dout0_32:O dout0_33:O dout0_34:O dout0_35:O dout0_36:O dout0_37:O dout0_38:O dout0_39:O dout0_40:O dout0_41:O dout0_42:O dout0_43:O dout0_44:O dout0_45:O dout0_46:O dout0_47:O dout0_48:O dout0_49:O dout0_50:O dout0_51:O dout0_52:O dout0_53:O dout0_54:O dout0_55:O dout0_56:O dout0_57:O dout0_58:O dout0_59:O dout0_60:O dout0_61:O dout0_62:O dout0_63:O dout1_0:O dout1_1:O dout1_2:O dout1_3:O dout1_4:O dout1_5:O dout1_6:O dout1_7:O dout1_8:O dout1_9:O dout1_10:O dout1_11:O dout1_12:O dout1_13:O dout1_14:O dout1_15:O dout1_16:O dout1_17:O dout1_18:O dout1_19:O dout1_20:O dout1_21:O dout1_22:O dout1_23:O dout1_24:O dout1_25:O dout1_26:O dout1_27:O dout1_28:O dout1_29:O dout1_30:O dout1_31:O dout1_32:O dout1_33:O dout1_34:O dout1_35:O dout1_36:O dout1_37:O dout1_38:O dout1_39:O dout1_40:O dout1_41:O dout1_42:O dout1_43:O dout1_44:O dout1_45:O dout1_46:O dout1_47:O dout1_48:O dout1_49:O dout1_50:O dout1_51:O dout1_52:O dout1_53:O dout1_54:O dout1_55:O dout1_56:O dout1_57:O dout1_58:O dout1_59:O dout1_60:O dout1_61:O dout1_62:O dout1_63:O rbl_bl_0_0:O rbl_bl_1_1:O din0_0:I din0_1:I din0_2:I din0_3:I din0_4:I din0_5:I din0_6:I din0_7:I din0_8:I din0_9:I din0_10:I din0_11:I din0_12:I din0_13:I din0_14:I din0_15:I din0_16:I din0_17:I din0_18:I din0_19:I din0_20:I din0_21:I din0_22:I din0_23:I din0_24:I din0_25:I din0_26:I din0_27:I din0_28:I din0_29:I din0_30:I din0_31:I din0_32:I din0_33:I din0_34:I din0_35:I din0_36:I din0_37:I din0_38:I din0_39:I din0_40:I din0_41:I din0_42:I din0_43:I din0_44:I din0_45:I din0_46:I din0_47:I din0_48:I din0_49:I din0_50:I din0_51:I din0_52:I din0_53:I din0_54:I din0_55:I din0_56:I din0_57:I din0_58:I din0_59:I din0_60:I din0_61:I din0_62:I din0_63:I addr0_0:I addr0_1:I addr0_2:I addr0_3:I addr0_4:I addr0_5:I addr0_6:I addr0_7:I addr1_0:I addr1_1:I addr1_2:I addr1_3:I addr1_4:I addr1_5:I addr1_6:I addr1_7:I s_en0:I s_en1:I p_en_bar0:I p_en_bar1:I w_en0:I bank_wmask0_0:I bank_wmask0_1:I bank_wmask0_2:I bank_wmask0_3:I bank_wmask0_4:I bank_wmask0_5:I bank_wmask0_6:I bank_wmask0_7:I wl_en0:I wl_en1:I vdd:B gnd:B
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
* OUTPUT: dout0_44 
* OUTPUT: dout0_45 
* OUTPUT: dout0_46 
* OUTPUT: dout0_47 
* OUTPUT: dout0_48 
* OUTPUT: dout0_49 
* OUTPUT: dout0_50 
* OUTPUT: dout0_51 
* OUTPUT: dout0_52 
* OUTPUT: dout0_53 
* OUTPUT: dout0_54 
* OUTPUT: dout0_55 
* OUTPUT: dout0_56 
* OUTPUT: dout0_57 
* OUTPUT: dout0_58 
* OUTPUT: dout0_59 
* OUTPUT: dout0_60 
* OUTPUT: dout0_61 
* OUTPUT: dout0_62 
* OUTPUT: dout0_63 
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
* OUTPUT: dout1_44 
* OUTPUT: dout1_45 
* OUTPUT: dout1_46 
* OUTPUT: dout1_47 
* OUTPUT: dout1_48 
* OUTPUT: dout1_49 
* OUTPUT: dout1_50 
* OUTPUT: dout1_51 
* OUTPUT: dout1_52 
* OUTPUT: dout1_53 
* OUTPUT: dout1_54 
* OUTPUT: dout1_55 
* OUTPUT: dout1_56 
* OUTPUT: dout1_57 
* OUTPUT: dout1_58 
* OUTPUT: dout1_59 
* OUTPUT: dout1_60 
* OUTPUT: dout1_61 
* OUTPUT: dout1_62 
* OUTPUT: dout1_63 
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
* INPUT : din0_44 
* INPUT : din0_45 
* INPUT : din0_46 
* INPUT : din0_47 
* INPUT : din0_48 
* INPUT : din0_49 
* INPUT : din0_50 
* INPUT : din0_51 
* INPUT : din0_52 
* INPUT : din0_53 
* INPUT : din0_54 
* INPUT : din0_55 
* INPUT : din0_56 
* INPUT : din0_57 
* INPUT : din0_58 
* INPUT : din0_59 
* INPUT : din0_60 
* INPUT : din0_61 
* INPUT : din0_62 
* INPUT : din0_63 
* INPUT : addr0_0 
* INPUT : addr0_1 
* INPUT : addr0_2 
* INPUT : addr0_3 
* INPUT : addr0_4 
* INPUT : addr0_5 
* INPUT : addr0_6 
* INPUT : addr0_7 
* INPUT : addr1_0 
* INPUT : addr1_1 
* INPUT : addr1_2 
* INPUT : addr1_3 
* INPUT : addr1_4 
* INPUT : addr1_5 
* INPUT : addr1_6 
* INPUT : addr1_7 
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
* INPUT : bank_wmask0_6 
* INPUT : bank_wmask0_7 
* INPUT : wl_en0 
* INPUT : wl_en1 
* POWER : vdd 
* GROUND: gnd 
Xbitcell_array rbl_bl_0_0 rbl_bl_1_0 rbl_br_0_0 rbl_br_1_0 bl_0_0 bl_1_0 br_0_0 br_1_0 bl_0_1 bl_1_1 br_0_1 br_1_1 bl_0_2 bl_1_2 br_0_2 br_1_2 bl_0_3 bl_1_3 br_0_3 br_1_3 bl_0_4 bl_1_4 br_0_4 br_1_4 bl_0_5 bl_1_5 br_0_5 br_1_5 bl_0_6 bl_1_6 br_0_6 br_1_6 bl_0_7 bl_1_7 br_0_7 br_1_7 bl_0_8 bl_1_8 br_0_8 br_1_8 bl_0_9 bl_1_9 br_0_9 br_1_9 bl_0_10 bl_1_10 br_0_10 br_1_10 bl_0_11 bl_1_11 br_0_11 br_1_11 bl_0_12 bl_1_12 br_0_12 br_1_12 bl_0_13 bl_1_13 br_0_13 br_1_13 bl_0_14 bl_1_14 br_0_14 br_1_14 bl_0_15 bl_1_15 br_0_15 br_1_15 bl_0_16 bl_1_16 br_0_16 br_1_16 bl_0_17 bl_1_17 br_0_17 br_1_17 bl_0_18 bl_1_18 br_0_18 br_1_18 bl_0_19 bl_1_19 br_0_19 br_1_19 bl_0_20 bl_1_20 br_0_20 br_1_20 bl_0_21 bl_1_21 br_0_21 br_1_21 bl_0_22 bl_1_22 br_0_22 br_1_22 bl_0_23 bl_1_23 br_0_23 br_1_23 bl_0_24 bl_1_24 br_0_24 br_1_24 bl_0_25 bl_1_25 br_0_25 br_1_25 bl_0_26 bl_1_26 br_0_26 br_1_26 bl_0_27 bl_1_27 br_0_27 br_1_27 bl_0_28 bl_1_28 br_0_28 br_1_28 bl_0_29 bl_1_29 br_0_29 br_1_29 bl_0_30 bl_1_30 br_0_30 br_1_30 bl_0_31 bl_1_31 br_0_31 br_1_31 bl_0_32 bl_1_32 br_0_32 br_1_32 bl_0_33 bl_1_33 br_0_33 br_1_33 bl_0_34 bl_1_34 br_0_34 br_1_34 bl_0_35 bl_1_35 br_0_35 br_1_35 bl_0_36 bl_1_36 br_0_36 br_1_36 bl_0_37 bl_1_37 br_0_37 br_1_37 bl_0_38 bl_1_38 br_0_38 br_1_38 bl_0_39 bl_1_39 br_0_39 br_1_39 bl_0_40 bl_1_40 br_0_40 br_1_40 bl_0_41 bl_1_41 br_0_41 br_1_41 bl_0_42 bl_1_42 br_0_42 br_1_42 bl_0_43 bl_1_43 br_0_43 br_1_43 bl_0_44 bl_1_44 br_0_44 br_1_44 bl_0_45 bl_1_45 br_0_45 br_1_45 bl_0_46 bl_1_46 br_0_46 br_1_46 bl_0_47 bl_1_47 br_0_47 br_1_47 bl_0_48 bl_1_48 br_0_48 br_1_48 bl_0_49 bl_1_49 br_0_49 br_1_49 bl_0_50 bl_1_50 br_0_50 br_1_50 bl_0_51 bl_1_51 br_0_51 br_1_51 bl_0_52 bl_1_52 br_0_52 br_1_52 bl_0_53 bl_1_53 br_0_53 br_1_53 bl_0_54 bl_1_54 br_0_54 br_1_54 bl_0_55 bl_1_55 br_0_55 br_1_55 bl_0_56 bl_1_56 br_0_56 br_1_56 bl_0_57 bl_1_57 br_0_57 br_1_57 bl_0_58 bl_1_58 br_0_58 br_1_58 bl_0_59 bl_1_59 br_0_59 br_1_59 bl_0_60 bl_1_60 br_0_60 br_1_60 bl_0_61 bl_1_61 br_0_61 br_1_61 bl_0_62 bl_1_62 br_0_62 br_1_62 bl_0_63 bl_1_63 br_0_63 br_1_63 bl_0_64 bl_1_64 br_0_64 br_1_64 bl_0_65 bl_1_65 br_0_65 br_1_65 bl_0_66 bl_1_66 br_0_66 br_1_66 bl_0_67 bl_1_67 br_0_67 br_1_67 bl_0_68 bl_1_68 br_0_68 br_1_68 bl_0_69 bl_1_69 br_0_69 br_1_69 bl_0_70 bl_1_70 br_0_70 br_1_70 bl_0_71 bl_1_71 br_0_71 br_1_71 bl_0_72 bl_1_72 br_0_72 br_1_72 bl_0_73 bl_1_73 br_0_73 br_1_73 bl_0_74 bl_1_74 br_0_74 br_1_74 bl_0_75 bl_1_75 br_0_75 br_1_75 bl_0_76 bl_1_76 br_0_76 br_1_76 bl_0_77 bl_1_77 br_0_77 br_1_77 bl_0_78 bl_1_78 br_0_78 br_1_78 bl_0_79 bl_1_79 br_0_79 br_1_79 bl_0_80 bl_1_80 br_0_80 br_1_80 bl_0_81 bl_1_81 br_0_81 br_1_81 bl_0_82 bl_1_82 br_0_82 br_1_82 bl_0_83 bl_1_83 br_0_83 br_1_83 bl_0_84 bl_1_84 br_0_84 br_1_84 bl_0_85 bl_1_85 br_0_85 br_1_85 bl_0_86 bl_1_86 br_0_86 br_1_86 bl_0_87 bl_1_87 br_0_87 br_1_87 bl_0_88 bl_1_88 br_0_88 br_1_88 bl_0_89 bl_1_89 br_0_89 br_1_89 bl_0_90 bl_1_90 br_0_90 br_1_90 bl_0_91 bl_1_91 br_0_91 br_1_91 bl_0_92 bl_1_92 br_0_92 br_1_92 bl_0_93 bl_1_93 br_0_93 br_1_93 bl_0_94 bl_1_94 br_0_94 br_1_94 bl_0_95 bl_1_95 br_0_95 br_1_95 bl_0_96 bl_1_96 br_0_96 br_1_96 bl_0_97 bl_1_97 br_0_97 br_1_97 bl_0_98 bl_1_98 br_0_98 br_1_98 bl_0_99 bl_1_99 br_0_99 br_1_99 bl_0_100 bl_1_100 br_0_100 br_1_100 bl_0_101 bl_1_101 br_0_101 br_1_101 bl_0_102 bl_1_102 br_0_102 br_1_102 bl_0_103 bl_1_103 br_0_103 br_1_103 bl_0_104 bl_1_104 br_0_104 br_1_104 bl_0_105 bl_1_105 br_0_105 br_1_105 bl_0_106 bl_1_106 br_0_106 br_1_106 bl_0_107 bl_1_107 br_0_107 br_1_107 bl_0_108 bl_1_108 br_0_108 br_1_108 bl_0_109 bl_1_109 br_0_109 br_1_109 bl_0_110 bl_1_110 br_0_110 br_1_110 bl_0_111 bl_1_111 br_0_111 br_1_111 bl_0_112 bl_1_112 br_0_112 br_1_112 bl_0_113 bl_1_113 br_0_113 br_1_113 bl_0_114 bl_1_114 br_0_114 br_1_114 bl_0_115 bl_1_115 br_0_115 br_1_115 bl_0_116 bl_1_116 br_0_116 br_1_116 bl_0_117 bl_1_117 br_0_117 br_1_117 bl_0_118 bl_1_118 br_0_118 br_1_118 bl_0_119 bl_1_119 br_0_119 br_1_119 bl_0_120 bl_1_120 br_0_120 br_1_120 bl_0_121 bl_1_121 br_0_121 br_1_121 bl_0_122 bl_1_122 br_0_122 br_1_122 bl_0_123 bl_1_123 br_0_123 br_1_123 bl_0_124 bl_1_124 br_0_124 br_1_124 bl_0_125 bl_1_125 br_0_125 br_1_125 bl_0_126 bl_1_126 br_0_126 br_1_126 bl_0_127 bl_1_127 br_0_127 br_1_127 rbl_bl_0_1 rbl_bl_1_1 rbl_br_0_1 rbl_br_1_1 rbl_wl0 wl_0_0 wl_1_0 wl_0_1 wl_1_1 wl_0_2 wl_1_2 wl_0_3 wl_1_3 wl_0_4 wl_1_4 wl_0_5 wl_1_5 wl_0_6 wl_1_6 wl_0_7 wl_1_7 wl_0_8 wl_1_8 wl_0_9 wl_1_9 wl_0_10 wl_1_10 wl_0_11 wl_1_11 wl_0_12 wl_1_12 wl_0_13 wl_1_13 wl_0_14 wl_1_14 wl_0_15 wl_1_15 wl_0_16 wl_1_16 wl_0_17 wl_1_17 wl_0_18 wl_1_18 wl_0_19 wl_1_19 wl_0_20 wl_1_20 wl_0_21 wl_1_21 wl_0_22 wl_1_22 wl_0_23 wl_1_23 wl_0_24 wl_1_24 wl_0_25 wl_1_25 wl_0_26 wl_1_26 wl_0_27 wl_1_27 wl_0_28 wl_1_28 wl_0_29 wl_1_29 wl_0_30 wl_1_30 wl_0_31 wl_1_31 wl_0_32 wl_1_32 wl_0_33 wl_1_33 wl_0_34 wl_1_34 wl_0_35 wl_1_35 wl_0_36 wl_1_36 wl_0_37 wl_1_37 wl_0_38 wl_1_38 wl_0_39 wl_1_39 wl_0_40 wl_1_40 wl_0_41 wl_1_41 wl_0_42 wl_1_42 wl_0_43 wl_1_43 wl_0_44 wl_1_44 wl_0_45 wl_1_45 wl_0_46 wl_1_46 wl_0_47 wl_1_47 wl_0_48 wl_1_48 wl_0_49 wl_1_49 wl_0_50 wl_1_50 wl_0_51 wl_1_51 wl_0_52 wl_1_52 wl_0_53 wl_1_53 wl_0_54 wl_1_54 wl_0_55 wl_1_55 wl_0_56 wl_1_56 wl_0_57 wl_1_57 wl_0_58 wl_1_58 wl_0_59 wl_1_59 wl_0_60 wl_1_60 wl_0_61 wl_1_61 wl_0_62 wl_1_62 wl_0_63 wl_1_63 wl_0_64 wl_1_64 wl_0_65 wl_1_65 wl_0_66 wl_1_66 wl_0_67 wl_1_67 wl_0_68 wl_1_68 wl_0_69 wl_1_69 wl_0_70 wl_1_70 wl_0_71 wl_1_71 wl_0_72 wl_1_72 wl_0_73 wl_1_73 wl_0_74 wl_1_74 wl_0_75 wl_1_75 wl_0_76 wl_1_76 wl_0_77 wl_1_77 wl_0_78 wl_1_78 wl_0_79 wl_1_79 wl_0_80 wl_1_80 wl_0_81 wl_1_81 wl_0_82 wl_1_82 wl_0_83 wl_1_83 wl_0_84 wl_1_84 wl_0_85 wl_1_85 wl_0_86 wl_1_86 wl_0_87 wl_1_87 wl_0_88 wl_1_88 wl_0_89 wl_1_89 wl_0_90 wl_1_90 wl_0_91 wl_1_91 wl_0_92 wl_1_92 wl_0_93 wl_1_93 wl_0_94 wl_1_94 wl_0_95 wl_1_95 wl_0_96 wl_1_96 wl_0_97 wl_1_97 wl_0_98 wl_1_98 wl_0_99 wl_1_99 wl_0_100 wl_1_100 wl_0_101 wl_1_101 wl_0_102 wl_1_102 wl_0_103 wl_1_103 wl_0_104 wl_1_104 wl_0_105 wl_1_105 wl_0_106 wl_1_106 wl_0_107 wl_1_107 wl_0_108 wl_1_108 wl_0_109 wl_1_109 wl_0_110 wl_1_110 wl_0_111 wl_1_111 wl_0_112 wl_1_112 wl_0_113 wl_1_113 wl_0_114 wl_1_114 wl_0_115 wl_1_115 wl_0_116 wl_1_116 wl_0_117 wl_1_117 wl_0_118 wl_1_118 wl_0_119 wl_1_119 wl_0_120 wl_1_120 wl_0_121 wl_1_121 wl_0_122 wl_1_122 wl_0_123 wl_1_123 wl_0_124 wl_1_124 wl_0_125 wl_1_125 wl_0_126 wl_1_126 wl_0_127 wl_1_127 rbl_wl1 vdd gnd global_bitcell_array
Xport_data0 rbl_bl_0_0 rbl_br_0_0 bl_0_0 br_0_0 bl_0_1 br_0_1 bl_0_2 br_0_2 bl_0_3 br_0_3 bl_0_4 br_0_4 bl_0_5 br_0_5 bl_0_6 br_0_6 bl_0_7 br_0_7 bl_0_8 br_0_8 bl_0_9 br_0_9 bl_0_10 br_0_10 bl_0_11 br_0_11 bl_0_12 br_0_12 bl_0_13 br_0_13 bl_0_14 br_0_14 bl_0_15 br_0_15 bl_0_16 br_0_16 bl_0_17 br_0_17 bl_0_18 br_0_18 bl_0_19 br_0_19 bl_0_20 br_0_20 bl_0_21 br_0_21 bl_0_22 br_0_22 bl_0_23 br_0_23 bl_0_24 br_0_24 bl_0_25 br_0_25 bl_0_26 br_0_26 bl_0_27 br_0_27 bl_0_28 br_0_28 bl_0_29 br_0_29 bl_0_30 br_0_30 bl_0_31 br_0_31 bl_0_32 br_0_32 bl_0_33 br_0_33 bl_0_34 br_0_34 bl_0_35 br_0_35 bl_0_36 br_0_36 bl_0_37 br_0_37 bl_0_38 br_0_38 bl_0_39 br_0_39 bl_0_40 br_0_40 bl_0_41 br_0_41 bl_0_42 br_0_42 bl_0_43 br_0_43 bl_0_44 br_0_44 bl_0_45 br_0_45 bl_0_46 br_0_46 bl_0_47 br_0_47 bl_0_48 br_0_48 bl_0_49 br_0_49 bl_0_50 br_0_50 bl_0_51 br_0_51 bl_0_52 br_0_52 bl_0_53 br_0_53 bl_0_54 br_0_54 bl_0_55 br_0_55 bl_0_56 br_0_56 bl_0_57 br_0_57 bl_0_58 br_0_58 bl_0_59 br_0_59 bl_0_60 br_0_60 bl_0_61 br_0_61 bl_0_62 br_0_62 bl_0_63 br_0_63 bl_0_64 br_0_64 bl_0_65 br_0_65 bl_0_66 br_0_66 bl_0_67 br_0_67 bl_0_68 br_0_68 bl_0_69 br_0_69 bl_0_70 br_0_70 bl_0_71 br_0_71 bl_0_72 br_0_72 bl_0_73 br_0_73 bl_0_74 br_0_74 bl_0_75 br_0_75 bl_0_76 br_0_76 bl_0_77 br_0_77 bl_0_78 br_0_78 bl_0_79 br_0_79 bl_0_80 br_0_80 bl_0_81 br_0_81 bl_0_82 br_0_82 bl_0_83 br_0_83 bl_0_84 br_0_84 bl_0_85 br_0_85 bl_0_86 br_0_86 bl_0_87 br_0_87 bl_0_88 br_0_88 bl_0_89 br_0_89 bl_0_90 br_0_90 bl_0_91 br_0_91 bl_0_92 br_0_92 bl_0_93 br_0_93 bl_0_94 br_0_94 bl_0_95 br_0_95 bl_0_96 br_0_96 bl_0_97 br_0_97 bl_0_98 br_0_98 bl_0_99 br_0_99 bl_0_100 br_0_100 bl_0_101 br_0_101 bl_0_102 br_0_102 bl_0_103 br_0_103 bl_0_104 br_0_104 bl_0_105 br_0_105 bl_0_106 br_0_106 bl_0_107 br_0_107 bl_0_108 br_0_108 bl_0_109 br_0_109 bl_0_110 br_0_110 bl_0_111 br_0_111 bl_0_112 br_0_112 bl_0_113 br_0_113 bl_0_114 br_0_114 bl_0_115 br_0_115 bl_0_116 br_0_116 bl_0_117 br_0_117 bl_0_118 br_0_118 bl_0_119 br_0_119 bl_0_120 br_0_120 bl_0_121 br_0_121 bl_0_122 br_0_122 bl_0_123 br_0_123 bl_0_124 br_0_124 bl_0_125 br_0_125 bl_0_126 br_0_126 bl_0_127 br_0_127 dout0_0 dout0_1 dout0_2 dout0_3 dout0_4 dout0_5 dout0_6 dout0_7 dout0_8 dout0_9 dout0_10 dout0_11 dout0_12 dout0_13 dout0_14 dout0_15 dout0_16 dout0_17 dout0_18 dout0_19 dout0_20 dout0_21 dout0_22 dout0_23 dout0_24 dout0_25 dout0_26 dout0_27 dout0_28 dout0_29 dout0_30 dout0_31 dout0_32 dout0_33 dout0_34 dout0_35 dout0_36 dout0_37 dout0_38 dout0_39 dout0_40 dout0_41 dout0_42 dout0_43 dout0_44 dout0_45 dout0_46 dout0_47 dout0_48 dout0_49 dout0_50 dout0_51 dout0_52 dout0_53 dout0_54 dout0_55 dout0_56 dout0_57 dout0_58 dout0_59 dout0_60 dout0_61 dout0_62 dout0_63 din0_0 din0_1 din0_2 din0_3 din0_4 din0_5 din0_6 din0_7 din0_8 din0_9 din0_10 din0_11 din0_12 din0_13 din0_14 din0_15 din0_16 din0_17 din0_18 din0_19 din0_20 din0_21 din0_22 din0_23 din0_24 din0_25 din0_26 din0_27 din0_28 din0_29 din0_30 din0_31 din0_32 din0_33 din0_34 din0_35 din0_36 din0_37 din0_38 din0_39 din0_40 din0_41 din0_42 din0_43 din0_44 din0_45 din0_46 din0_47 din0_48 din0_49 din0_50 din0_51 din0_52 din0_53 din0_54 din0_55 din0_56 din0_57 din0_58 din0_59 din0_60 din0_61 din0_62 din0_63 sel0_0 sel0_1 s_en0 p_en_bar0 w_en0 bank_wmask0_0 bank_wmask0_1 bank_wmask0_2 bank_wmask0_3 bank_wmask0_4 bank_wmask0_5 bank_wmask0_6 bank_wmask0_7 vdd gnd port_data
Xport_data1 rbl_bl_1_1 rbl_br_1_1 bl_1_0 br_1_0 bl_1_1 br_1_1 bl_1_2 br_1_2 bl_1_3 br_1_3 bl_1_4 br_1_4 bl_1_5 br_1_5 bl_1_6 br_1_6 bl_1_7 br_1_7 bl_1_8 br_1_8 bl_1_9 br_1_9 bl_1_10 br_1_10 bl_1_11 br_1_11 bl_1_12 br_1_12 bl_1_13 br_1_13 bl_1_14 br_1_14 bl_1_15 br_1_15 bl_1_16 br_1_16 bl_1_17 br_1_17 bl_1_18 br_1_18 bl_1_19 br_1_19 bl_1_20 br_1_20 bl_1_21 br_1_21 bl_1_22 br_1_22 bl_1_23 br_1_23 bl_1_24 br_1_24 bl_1_25 br_1_25 bl_1_26 br_1_26 bl_1_27 br_1_27 bl_1_28 br_1_28 bl_1_29 br_1_29 bl_1_30 br_1_30 bl_1_31 br_1_31 bl_1_32 br_1_32 bl_1_33 br_1_33 bl_1_34 br_1_34 bl_1_35 br_1_35 bl_1_36 br_1_36 bl_1_37 br_1_37 bl_1_38 br_1_38 bl_1_39 br_1_39 bl_1_40 br_1_40 bl_1_41 br_1_41 bl_1_42 br_1_42 bl_1_43 br_1_43 bl_1_44 br_1_44 bl_1_45 br_1_45 bl_1_46 br_1_46 bl_1_47 br_1_47 bl_1_48 br_1_48 bl_1_49 br_1_49 bl_1_50 br_1_50 bl_1_51 br_1_51 bl_1_52 br_1_52 bl_1_53 br_1_53 bl_1_54 br_1_54 bl_1_55 br_1_55 bl_1_56 br_1_56 bl_1_57 br_1_57 bl_1_58 br_1_58 bl_1_59 br_1_59 bl_1_60 br_1_60 bl_1_61 br_1_61 bl_1_62 br_1_62 bl_1_63 br_1_63 bl_1_64 br_1_64 bl_1_65 br_1_65 bl_1_66 br_1_66 bl_1_67 br_1_67 bl_1_68 br_1_68 bl_1_69 br_1_69 bl_1_70 br_1_70 bl_1_71 br_1_71 bl_1_72 br_1_72 bl_1_73 br_1_73 bl_1_74 br_1_74 bl_1_75 br_1_75 bl_1_76 br_1_76 bl_1_77 br_1_77 bl_1_78 br_1_78 bl_1_79 br_1_79 bl_1_80 br_1_80 bl_1_81 br_1_81 bl_1_82 br_1_82 bl_1_83 br_1_83 bl_1_84 br_1_84 bl_1_85 br_1_85 bl_1_86 br_1_86 bl_1_87 br_1_87 bl_1_88 br_1_88 bl_1_89 br_1_89 bl_1_90 br_1_90 bl_1_91 br_1_91 bl_1_92 br_1_92 bl_1_93 br_1_93 bl_1_94 br_1_94 bl_1_95 br_1_95 bl_1_96 br_1_96 bl_1_97 br_1_97 bl_1_98 br_1_98 bl_1_99 br_1_99 bl_1_100 br_1_100 bl_1_101 br_1_101 bl_1_102 br_1_102 bl_1_103 br_1_103 bl_1_104 br_1_104 bl_1_105 br_1_105 bl_1_106 br_1_106 bl_1_107 br_1_107 bl_1_108 br_1_108 bl_1_109 br_1_109 bl_1_110 br_1_110 bl_1_111 br_1_111 bl_1_112 br_1_112 bl_1_113 br_1_113 bl_1_114 br_1_114 bl_1_115 br_1_115 bl_1_116 br_1_116 bl_1_117 br_1_117 bl_1_118 br_1_118 bl_1_119 br_1_119 bl_1_120 br_1_120 bl_1_121 br_1_121 bl_1_122 br_1_122 bl_1_123 br_1_123 bl_1_124 br_1_124 bl_1_125 br_1_125 bl_1_126 br_1_126 bl_1_127 br_1_127 dout1_0 dout1_1 dout1_2 dout1_3 dout1_4 dout1_5 dout1_6 dout1_7 dout1_8 dout1_9 dout1_10 dout1_11 dout1_12 dout1_13 dout1_14 dout1_15 dout1_16 dout1_17 dout1_18 dout1_19 dout1_20 dout1_21 dout1_22 dout1_23 dout1_24 dout1_25 dout1_26 dout1_27 dout1_28 dout1_29 dout1_30 dout1_31 dout1_32 dout1_33 dout1_34 dout1_35 dout1_36 dout1_37 dout1_38 dout1_39 dout1_40 dout1_41 dout1_42 dout1_43 dout1_44 dout1_45 dout1_46 dout1_47 dout1_48 dout1_49 dout1_50 dout1_51 dout1_52 dout1_53 dout1_54 dout1_55 dout1_56 dout1_57 dout1_58 dout1_59 dout1_60 dout1_61 dout1_62 dout1_63 sel1_0 sel1_1 s_en1 p_en_bar1 vdd gnd port_data_0
Xport_address0 addr0_1 addr0_2 addr0_3 addr0_4 addr0_5 addr0_6 addr0_7 wl_en0 wl_0_0 wl_0_1 wl_0_2 wl_0_3 wl_0_4 wl_0_5 wl_0_6 wl_0_7 wl_0_8 wl_0_9 wl_0_10 wl_0_11 wl_0_12 wl_0_13 wl_0_14 wl_0_15 wl_0_16 wl_0_17 wl_0_18 wl_0_19 wl_0_20 wl_0_21 wl_0_22 wl_0_23 wl_0_24 wl_0_25 wl_0_26 wl_0_27 wl_0_28 wl_0_29 wl_0_30 wl_0_31 wl_0_32 wl_0_33 wl_0_34 wl_0_35 wl_0_36 wl_0_37 wl_0_38 wl_0_39 wl_0_40 wl_0_41 wl_0_42 wl_0_43 wl_0_44 wl_0_45 wl_0_46 wl_0_47 wl_0_48 wl_0_49 wl_0_50 wl_0_51 wl_0_52 wl_0_53 wl_0_54 wl_0_55 wl_0_56 wl_0_57 wl_0_58 wl_0_59 wl_0_60 wl_0_61 wl_0_62 wl_0_63 wl_0_64 wl_0_65 wl_0_66 wl_0_67 wl_0_68 wl_0_69 wl_0_70 wl_0_71 wl_0_72 wl_0_73 wl_0_74 wl_0_75 wl_0_76 wl_0_77 wl_0_78 wl_0_79 wl_0_80 wl_0_81 wl_0_82 wl_0_83 wl_0_84 wl_0_85 wl_0_86 wl_0_87 wl_0_88 wl_0_89 wl_0_90 wl_0_91 wl_0_92 wl_0_93 wl_0_94 wl_0_95 wl_0_96 wl_0_97 wl_0_98 wl_0_99 wl_0_100 wl_0_101 wl_0_102 wl_0_103 wl_0_104 wl_0_105 wl_0_106 wl_0_107 wl_0_108 wl_0_109 wl_0_110 wl_0_111 wl_0_112 wl_0_113 wl_0_114 wl_0_115 wl_0_116 wl_0_117 wl_0_118 wl_0_119 wl_0_120 wl_0_121 wl_0_122 wl_0_123 wl_0_124 wl_0_125 wl_0_126 wl_0_127 rbl_wl0 vdd gnd port_address
Xport_address1 addr1_1 addr1_2 addr1_3 addr1_4 addr1_5 addr1_6 addr1_7 wl_en1 wl_1_0 wl_1_1 wl_1_2 wl_1_3 wl_1_4 wl_1_5 wl_1_6 wl_1_7 wl_1_8 wl_1_9 wl_1_10 wl_1_11 wl_1_12 wl_1_13 wl_1_14 wl_1_15 wl_1_16 wl_1_17 wl_1_18 wl_1_19 wl_1_20 wl_1_21 wl_1_22 wl_1_23 wl_1_24 wl_1_25 wl_1_26 wl_1_27 wl_1_28 wl_1_29 wl_1_30 wl_1_31 wl_1_32 wl_1_33 wl_1_34 wl_1_35 wl_1_36 wl_1_37 wl_1_38 wl_1_39 wl_1_40 wl_1_41 wl_1_42 wl_1_43 wl_1_44 wl_1_45 wl_1_46 wl_1_47 wl_1_48 wl_1_49 wl_1_50 wl_1_51 wl_1_52 wl_1_53 wl_1_54 wl_1_55 wl_1_56 wl_1_57 wl_1_58 wl_1_59 wl_1_60 wl_1_61 wl_1_62 wl_1_63 wl_1_64 wl_1_65 wl_1_66 wl_1_67 wl_1_68 wl_1_69 wl_1_70 wl_1_71 wl_1_72 wl_1_73 wl_1_74 wl_1_75 wl_1_76 wl_1_77 wl_1_78 wl_1_79 wl_1_80 wl_1_81 wl_1_82 wl_1_83 wl_1_84 wl_1_85 wl_1_86 wl_1_87 wl_1_88 wl_1_89 wl_1_90 wl_1_91 wl_1_92 wl_1_93 wl_1_94 wl_1_95 wl_1_96 wl_1_97 wl_1_98 wl_1_99 wl_1_100 wl_1_101 wl_1_102 wl_1_103 wl_1_104 wl_1_105 wl_1_106 wl_1_107 wl_1_108 wl_1_109 wl_1_110 wl_1_111 wl_1_112 wl_1_113 wl_1_114 wl_1_115 wl_1_116 wl_1_117 wl_1_118 wl_1_119 wl_1_120 wl_1_121 wl_1_122 wl_1_123 wl_1_124 wl_1_125 wl_1_126 wl_1_127 rbl_wl1 vdd gnd port_address_0
Xcol_address_decoder0 addr0_0 sel0_0 sel0_1 vdd gnd pinvbuf
Xcol_address_decoder1 addr1_0 sel1_0 sel1_1 vdd gnd pinvbuf
.ENDS bank

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
Xdff_buf_inv1 qint Qb vdd gnd pinv_1
Xdff_buf_inv2 Qb Q vdd gnd pinv_2
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

.SUBCKT pinv_3 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=7 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=7 w=1.68u l=0.15u
.ENDS pinv_3

.SUBCKT pdriver_0 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [12]
Xbuf_inv1 A Z vdd gnd pinv_3
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

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=18 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=18 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_4 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=18 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=18 w=2.0u l=0.15u
.ENDS pinv_4

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=70 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=70 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_5 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=70 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=70 w=2.0u l=0.15u
.ENDS pinv_5

.SUBCKT pbuf A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xbuf_inv1 A zb_int vdd gnd pinv_4
Xbuf_inv2 zb_int Z vdd gnd pinv_5
.ENDS pbuf

.SUBCKT pinv_6 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_6

.SUBCKT pinv_7 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_7

.SUBCKT pinv_8 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=2 w=1.26u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=2 w=0.74u l=0.15u
.ENDS pinv_8

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=3 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=3 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_9 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=3 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=3 w=2.0u l=0.15u
.ENDS pinv_9

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=8 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=8 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_10 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=8 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=8 w=2.0u l=0.15u
.ENDS pinv_10

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=23 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=23 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_11 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=23 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=23 w=2.0u l=0.15u
.ENDS pinv_11

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=69 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=69 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_12 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=69 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=69 w=2.0u l=0.15u
.ENDS pinv_12

.SUBCKT pdriver_1 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 1, 1, 2, 5, 14, 42, 127]
Xbuf_inv1 A Zb1_int vdd gnd pinv_6
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_7
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_7
Xbuf_inv4 Zb3_int Zb4_int vdd gnd pinv_8
Xbuf_inv5 Zb4_int Zb5_int vdd gnd pinv_9
Xbuf_inv6 Zb5_int Zb6_int vdd gnd pinv_10
Xbuf_inv7 Zb6_int Zb7_int vdd gnd pinv_11
Xbuf_inv8 Zb7_int Z vdd gnd pinv_12
.ENDS pdriver_1

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=24 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=24 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_13 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=24 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=24 w=2.0u l=0.15u
.ENDS pinv_13

.SUBCKT pdriver_2 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 1, 2, 5, 14, 43]
Xbuf_inv1 A Zb1_int vdd gnd pinv_6
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_7
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_8
Xbuf_inv4 Zb3_int Zb4_int vdd gnd pinv_9
Xbuf_inv5 Zb4_int Zb5_int vdd gnd pinv_10
Xbuf_inv6 Zb5_int Z vdd gnd pinv_13
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

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=39 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=39 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_14 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=39 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=39 w=2.0u l=0.15u
.ENDS pinv_14

.SUBCKT pdriver_3 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [72]
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

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=35 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=35 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_15 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=35 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=35 w=2.0u l=0.15u
.ENDS pinv_15

.SUBCKT pdriver_4 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [64]
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

.SUBCKT pinv_16 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=1 w=1.12u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=1 w=0.36u l=0.15u
.ENDS pinv_16

.SUBCKT delay_chain in out vdd gnd
*.PININFO in:I out:O vdd:B gnd:B
* INPUT : in 
* OUTPUT: out 
* POWER : vdd 
* GROUND: gnd 
* fanouts: [4, 4, 4, 4, 4, 4, 4, 4, 4]
Xdinv0 in dout_1 vdd gnd pinv_16
Xdload_0_0 dout_1 n_0_0 vdd gnd pinv_16
Xdload_0_1 dout_1 n_0_1 vdd gnd pinv_16
Xdload_0_2 dout_1 n_0_2 vdd gnd pinv_16
Xdload_0_3 dout_1 n_0_3 vdd gnd pinv_16
Xdinv1 dout_1 dout_2 vdd gnd pinv_16
Xdload_1_0 dout_2 n_1_0 vdd gnd pinv_16
Xdload_1_1 dout_2 n_1_1 vdd gnd pinv_16
Xdload_1_2 dout_2 n_1_2 vdd gnd pinv_16
Xdload_1_3 dout_2 n_1_3 vdd gnd pinv_16
Xdinv2 dout_2 dout_3 vdd gnd pinv_16
Xdload_2_0 dout_3 n_2_0 vdd gnd pinv_16
Xdload_2_1 dout_3 n_2_1 vdd gnd pinv_16
Xdload_2_2 dout_3 n_2_2 vdd gnd pinv_16
Xdload_2_3 dout_3 n_2_3 vdd gnd pinv_16
Xdinv3 dout_3 dout_4 vdd gnd pinv_16
Xdload_3_0 dout_4 n_3_0 vdd gnd pinv_16
Xdload_3_1 dout_4 n_3_1 vdd gnd pinv_16
Xdload_3_2 dout_4 n_3_2 vdd gnd pinv_16
Xdload_3_3 dout_4 n_3_3 vdd gnd pinv_16
Xdinv4 dout_4 dout_5 vdd gnd pinv_16
Xdload_4_0 dout_5 n_4_0 vdd gnd pinv_16
Xdload_4_1 dout_5 n_4_1 vdd gnd pinv_16
Xdload_4_2 dout_5 n_4_2 vdd gnd pinv_16
Xdload_4_3 dout_5 n_4_3 vdd gnd pinv_16
Xdinv5 dout_5 dout_6 vdd gnd pinv_16
Xdload_5_0 dout_6 n_5_0 vdd gnd pinv_16
Xdload_5_1 dout_6 n_5_1 vdd gnd pinv_16
Xdload_5_2 dout_6 n_5_2 vdd gnd pinv_16
Xdload_5_3 dout_6 n_5_3 vdd gnd pinv_16
Xdinv6 dout_6 dout_7 vdd gnd pinv_16
Xdload_6_0 dout_7 n_6_0 vdd gnd pinv_16
Xdload_6_1 dout_7 n_6_1 vdd gnd pinv_16
Xdload_6_2 dout_7 n_6_2 vdd gnd pinv_16
Xdload_6_3 dout_7 n_6_3 vdd gnd pinv_16
Xdinv7 dout_7 dout_8 vdd gnd pinv_16
Xdload_7_0 dout_8 n_7_0 vdd gnd pinv_16
Xdload_7_1 dout_8 n_7_1 vdd gnd pinv_16
Xdload_7_2 dout_8 n_7_2 vdd gnd pinv_16
Xdload_7_3 dout_8 n_7_3 vdd gnd pinv_16
Xdinv8 dout_8 out vdd gnd pinv_16
Xdload_8_0 out n_8_0 vdd gnd pinv_16
Xdload_8_1 out n_8_1 vdd gnd pinv_16
Xdload_8_2 out n_8_2 vdd gnd pinv_16
Xdload_8_3 out n_8_3 vdd gnd pinv_16
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
* word_size 64
Xctrl_dffs csb web cs_bar cs we_bar we clk_buf vdd gnd dff_buf_array
Xclkbuf clk clk_buf vdd gnd pdriver_1
Xinv_clk_bar clk_buf clk_bar vdd gnd pinv_0
Xand2_gated_clk_bar clk_bar cs gated_clk_bar vdd gnd pand2_0
Xand2_gated_clk_buf clk_buf cs gated_clk_buf vdd gnd pand2_0
Xbuf_wl_en gated_clk_bar wl_en vdd gnd pdriver_2
Xrbl_bl_delay_inv rbl_bl_delay rbl_bl_delay_bar vdd gnd pinv_0
Xw_en_and we rbl_bl_delay_bar gated_clk_bar w_en vdd gnd pand3
Xbuf_s_en_and rbl_bl_delay gated_clk_bar we_bar s_en vdd gnd pand3_0
Xdelay_chain rbl_bl rbl_bl_delay vdd gnd delay_chain
Xnand_p_en_bar gated_clk_buf rbl_bl_delay p_en_bar_unbuf vdd gnd pnand2_1
Xbuf_p_en_bar p_en_bar_unbuf p_en_bar vdd gnd pdriver_2
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

* spice ptx X{0} {1} sky130_fd_pr__nfet_01v8 m=68 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

* spice ptx X{0} {1} sky130_fd_pr__pfet_01v8 m=68 w=2.0 l=0.15 pd=4.30 ps=4.30 as=0.75u ad=0.75u

.SUBCKT pinv_17 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
Xpinv_pmos Z A vdd vdd sky130_fd_pr__pfet_01v8 m=68 w=2.0u l=0.15u
Xpinv_nmos Z A gnd gnd sky130_fd_pr__nfet_01v8 m=68 w=2.0u l=0.15u
.ENDS pinv_17

.SUBCKT pdriver_5 A Z vdd gnd
*.PININFO A:I Z:O vdd:B gnd:B
* INPUT : A 
* OUTPUT: Z 
* POWER : vdd 
* GROUND: gnd 
* sizes: [1, 1, 1, 2, 5, 14, 42, 125]
Xbuf_inv1 A Zb1_int vdd gnd pinv_6
Xbuf_inv2 Zb1_int Zb2_int vdd gnd pinv_7
Xbuf_inv3 Zb2_int Zb3_int vdd gnd pinv_7
Xbuf_inv4 Zb3_int Zb4_int vdd gnd pinv_8
Xbuf_inv5 Zb4_int Zb5_int vdd gnd pinv_9
Xbuf_inv6 Zb5_int Zb6_int vdd gnd pinv_10
Xbuf_inv7 Zb6_int Zb7_int vdd gnd pinv_11
Xbuf_inv8 Zb7_int Z vdd gnd pinv_17
.ENDS pdriver_5

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
* word_size 64
Xctrl_dffs csb cs_bar cs clk_buf vdd gnd dff_buf_array_0
Xclkbuf clk clk_buf vdd gnd pdriver_5
Xinv_clk_bar clk_buf clk_bar vdd gnd pinv_0
Xand2_gated_clk_bar clk_bar cs gated_clk_bar vdd gnd pand2_0
Xand2_gated_clk_buf clk_buf cs gated_clk_buf vdd gnd pand2_0
Xbuf_wl_en gated_clk_bar wl_en vdd gnd pdriver_2
Xbuf_s_en_and rbl_bl_delay gated_clk_bar cs s_en vdd gnd pand3_0
Xdelay_chain rbl_bl rbl_bl_delay vdd gnd delay_chain
Xnand_p_en_bar gated_clk_buf rbl_bl_delay p_en_bar_unbuf vdd gnd pnand2_1
Xbuf_p_en_bar p_en_bar_unbuf p_en_bar vdd gnd pdriver_2
.ENDS control_logic_r

.SUBCKT sky130_sram_1rw1r_64x256_8 din0[0] din0[1] din0[2] din0[3] din0[4] din0[5] din0[6] din0[7] din0[8] din0[9] din0[10] din0[11] din0[12] din0[13] din0[14] din0[15] din0[16] din0[17] din0[18] din0[19] din0[20] din0[21] din0[22] din0[23] din0[24] din0[25] din0[26] din0[27] din0[28] din0[29] din0[30] din0[31] din0[32] din0[33] din0[34] din0[35] din0[36] din0[37] din0[38] din0[39] din0[40] din0[41] din0[42] din0[43] din0[44] din0[45] din0[46] din0[47] din0[48] din0[49] din0[50] din0[51] din0[52] din0[53] din0[54] din0[55] din0[56] din0[57] din0[58] din0[59] din0[60] din0[61] din0[62] din0[63] addr0[0] addr0[1] addr0[2] addr0[3] addr0[4] addr0[5] addr0[6] addr0[7] addr1[0] addr1[1] addr1[2] addr1[3] addr1[4] addr1[5] addr1[6] addr1[7] csb0 csb1 web0 clk0 clk1 wmask0[0] wmask0[1] wmask0[2] wmask0[3] wmask0[4] wmask0[5] wmask0[6] wmask0[7] dout0[0] dout0[1] dout0[2] dout0[3] dout0[4] dout0[5] dout0[6] dout0[7] dout0[8] dout0[9] dout0[10] dout0[11] dout0[12] dout0[13] dout0[14] dout0[15] dout0[16] dout0[17] dout0[18] dout0[19] dout0[20] dout0[21] dout0[22] dout0[23] dout0[24] dout0[25] dout0[26] dout0[27] dout0[28] dout0[29] dout0[30] dout0[31] dout0[32] dout0[33] dout0[34] dout0[35] dout0[36] dout0[37] dout0[38] dout0[39] dout0[40] dout0[41] dout0[42] dout0[43] dout0[44] dout0[45] dout0[46] dout0[47] dout0[48] dout0[49] dout0[50] dout0[51] dout0[52] dout0[53] dout0[54] dout0[55] dout0[56] dout0[57] dout0[58] dout0[59] dout0[60] dout0[61] dout0[62] dout0[63] dout1[0] dout1[1] dout1[2] dout1[3] dout1[4] dout1[5] dout1[6] dout1[7] dout1[8] dout1[9] dout1[10] dout1[11] dout1[12] dout1[13] dout1[14] dout1[15] dout1[16] dout1[17] dout1[18] dout1[19] dout1[20] dout1[21] dout1[22] dout1[23] dout1[24] dout1[25] dout1[26] dout1[27] dout1[28] dout1[29] dout1[30] dout1[31] dout1[32] dout1[33] dout1[34] dout1[35] dout1[36] dout1[37] dout1[38] dout1[39] dout1[40] dout1[41] dout1[42] dout1[43] dout1[44] dout1[45] dout1[46] dout1[47] dout1[48] dout1[49] dout1[50] dout1[51] dout1[52] dout1[53] dout1[54] dout1[55] dout1[56] dout1[57] dout1[58] dout1[59] dout1[60] dout1[61] dout1[62] dout1[63] vdd gnd
*.PININFO din0[0]:I din0[1]:I din0[2]:I din0[3]:I din0[4]:I din0[5]:I din0[6]:I din0[7]:I din0[8]:I din0[9]:I din0[10]:I din0[11]:I din0[12]:I din0[13]:I din0[14]:I din0[15]:I din0[16]:I din0[17]:I din0[18]:I din0[19]:I din0[20]:I din0[21]:I din0[22]:I din0[23]:I din0[24]:I din0[25]:I din0[26]:I din0[27]:I din0[28]:I din0[29]:I din0[30]:I din0[31]:I din0[32]:I din0[33]:I din0[34]:I din0[35]:I din0[36]:I din0[37]:I din0[38]:I din0[39]:I din0[40]:I din0[41]:I din0[42]:I din0[43]:I din0[44]:I din0[45]:I din0[46]:I din0[47]:I din0[48]:I din0[49]:I din0[50]:I din0[51]:I din0[52]:I din0[53]:I din0[54]:I din0[55]:I din0[56]:I din0[57]:I din0[58]:I din0[59]:I din0[60]:I din0[61]:I din0[62]:I din0[63]:I addr0[0]:I addr0[1]:I addr0[2]:I addr0[3]:I addr0[4]:I addr0[5]:I addr0[6]:I addr0[7]:I addr1[0]:I addr1[1]:I addr1[2]:I addr1[3]:I addr1[4]:I addr1[5]:I addr1[6]:I addr1[7]:I csb0:I csb1:I web0:I clk0:I clk1:I wmask0[0]:I wmask0[1]:I wmask0[2]:I wmask0[3]:I wmask0[4]:I wmask0[5]:I wmask0[6]:I wmask0[7]:I dout0[0]:O dout0[1]:O dout0[2]:O dout0[3]:O dout0[4]:O dout0[5]:O dout0[6]:O dout0[7]:O dout0[8]:O dout0[9]:O dout0[10]:O dout0[11]:O dout0[12]:O dout0[13]:O dout0[14]:O dout0[15]:O dout0[16]:O dout0[17]:O dout0[18]:O dout0[19]:O dout0[20]:O dout0[21]:O dout0[22]:O dout0[23]:O dout0[24]:O dout0[25]:O dout0[26]:O dout0[27]:O dout0[28]:O dout0[29]:O dout0[30]:O dout0[31]:O dout0[32]:O dout0[33]:O dout0[34]:O dout0[35]:O dout0[36]:O dout0[37]:O dout0[38]:O dout0[39]:O dout0[40]:O dout0[41]:O dout0[42]:O dout0[43]:O dout0[44]:O dout0[45]:O dout0[46]:O dout0[47]:O dout0[48]:O dout0[49]:O dout0[50]:O dout0[51]:O dout0[52]:O dout0[53]:O dout0[54]:O dout0[55]:O dout0[56]:O dout0[57]:O dout0[58]:O dout0[59]:O dout0[60]:O dout0[61]:O dout0[62]:O dout0[63]:O dout1[0]:O dout1[1]:O dout1[2]:O dout1[3]:O dout1[4]:O dout1[5]:O dout1[6]:O dout1[7]:O dout1[8]:O dout1[9]:O dout1[10]:O dout1[11]:O dout1[12]:O dout1[13]:O dout1[14]:O dout1[15]:O dout1[16]:O dout1[17]:O dout1[18]:O dout1[19]:O dout1[20]:O dout1[21]:O dout1[22]:O dout1[23]:O dout1[24]:O dout1[25]:O dout1[26]:O dout1[27]:O dout1[28]:O dout1[29]:O dout1[30]:O dout1[31]:O dout1[32]:O dout1[33]:O dout1[34]:O dout1[35]:O dout1[36]:O dout1[37]:O dout1[38]:O dout1[39]:O dout1[40]:O dout1[41]:O dout1[42]:O dout1[43]:O dout1[44]:O dout1[45]:O dout1[46]:O dout1[47]:O dout1[48]:O dout1[49]:O dout1[50]:O dout1[51]:O dout1[52]:O dout1[53]:O dout1[54]:O dout1[55]:O dout1[56]:O dout1[57]:O dout1[58]:O dout1[59]:O dout1[60]:O dout1[61]:O dout1[62]:O dout1[63]:O vdd:B gnd:B
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
* INPUT : din0[44] 
* INPUT : din0[45] 
* INPUT : din0[46] 
* INPUT : din0[47] 
* INPUT : din0[48] 
* INPUT : din0[49] 
* INPUT : din0[50] 
* INPUT : din0[51] 
* INPUT : din0[52] 
* INPUT : din0[53] 
* INPUT : din0[54] 
* INPUT : din0[55] 
* INPUT : din0[56] 
* INPUT : din0[57] 
* INPUT : din0[58] 
* INPUT : din0[59] 
* INPUT : din0[60] 
* INPUT : din0[61] 
* INPUT : din0[62] 
* INPUT : din0[63] 
* INPUT : addr0[0] 
* INPUT : addr0[1] 
* INPUT : addr0[2] 
* INPUT : addr0[3] 
* INPUT : addr0[4] 
* INPUT : addr0[5] 
* INPUT : addr0[6] 
* INPUT : addr0[7] 
* INPUT : addr1[0] 
* INPUT : addr1[1] 
* INPUT : addr1[2] 
* INPUT : addr1[3] 
* INPUT : addr1[4] 
* INPUT : addr1[5] 
* INPUT : addr1[6] 
* INPUT : addr1[7] 
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
* INPUT : wmask0[6] 
* INPUT : wmask0[7] 
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
* OUTPUT: dout0[44] 
* OUTPUT: dout0[45] 
* OUTPUT: dout0[46] 
* OUTPUT: dout0[47] 
* OUTPUT: dout0[48] 
* OUTPUT: dout0[49] 
* OUTPUT: dout0[50] 
* OUTPUT: dout0[51] 
* OUTPUT: dout0[52] 
* OUTPUT: dout0[53] 
* OUTPUT: dout0[54] 
* OUTPUT: dout0[55] 
* OUTPUT: dout0[56] 
* OUTPUT: dout0[57] 
* OUTPUT: dout0[58] 
* OUTPUT: dout0[59] 
* OUTPUT: dout0[60] 
* OUTPUT: dout0[61] 
* OUTPUT: dout0[62] 
* OUTPUT: dout0[63] 
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
* OUTPUT: dout1[44] 
* OUTPUT: dout1[45] 
* OUTPUT: dout1[46] 
* OUTPUT: dout1[47] 
* OUTPUT: dout1[48] 
* OUTPUT: dout1[49] 
* OUTPUT: dout1[50] 
* OUTPUT: dout1[51] 
* OUTPUT: dout1[52] 
* OUTPUT: dout1[53] 
* OUTPUT: dout1[54] 
* OUTPUT: dout1[55] 
* OUTPUT: dout1[56] 
* OUTPUT: dout1[57] 
* OUTPUT: dout1[58] 
* OUTPUT: dout1[59] 
* OUTPUT: dout1[60] 
* OUTPUT: dout1[61] 
* OUTPUT: dout1[62] 
* OUTPUT: dout1[63] 
* POWER : vdd 
* GROUND: gnd 
Xbank0 dout0[0] dout0[1] dout0[2] dout0[3] dout0[4] dout0[5] dout0[6] dout0[7] dout0[8] dout0[9] dout0[10] dout0[11] dout0[12] dout0[13] dout0[14] dout0[15] dout0[16] dout0[17] dout0[18] dout0[19] dout0[20] dout0[21] dout0[22] dout0[23] dout0[24] dout0[25] dout0[26] dout0[27] dout0[28] dout0[29] dout0[30] dout0[31] dout0[32] dout0[33] dout0[34] dout0[35] dout0[36] dout0[37] dout0[38] dout0[39] dout0[40] dout0[41] dout0[42] dout0[43] dout0[44] dout0[45] dout0[46] dout0[47] dout0[48] dout0[49] dout0[50] dout0[51] dout0[52] dout0[53] dout0[54] dout0[55] dout0[56] dout0[57] dout0[58] dout0[59] dout0[60] dout0[61] dout0[62] dout0[63] dout1[0] dout1[1] dout1[2] dout1[3] dout1[4] dout1[5] dout1[6] dout1[7] dout1[8] dout1[9] dout1[10] dout1[11] dout1[12] dout1[13] dout1[14] dout1[15] dout1[16] dout1[17] dout1[18] dout1[19] dout1[20] dout1[21] dout1[22] dout1[23] dout1[24] dout1[25] dout1[26] dout1[27] dout1[28] dout1[29] dout1[30] dout1[31] dout1[32] dout1[33] dout1[34] dout1[35] dout1[36] dout1[37] dout1[38] dout1[39] dout1[40] dout1[41] dout1[42] dout1[43] dout1[44] dout1[45] dout1[46] dout1[47] dout1[48] dout1[49] dout1[50] dout1[51] dout1[52] dout1[53] dout1[54] dout1[55] dout1[56] dout1[57] dout1[58] dout1[59] dout1[60] dout1[61] dout1[62] dout1[63] rbl_bl0 rbl_bl1 bank_din0[0] bank_din0[1] bank_din0[2] bank_din0[3] bank_din0[4] bank_din0[5] bank_din0[6] bank_din0[7] bank_din0[8] bank_din0[9] bank_din0[10] bank_din0[11] bank_din0[12] bank_din0[13] bank_din0[14] bank_din0[15] bank_din0[16] bank_din0[17] bank_din0[18] bank_din0[19] bank_din0[20] bank_din0[21] bank_din0[22] bank_din0[23] bank_din0[24] bank_din0[25] bank_din0[26] bank_din0[27] bank_din0[28] bank_din0[29] bank_din0[30] bank_din0[31] bank_din0[32] bank_din0[33] bank_din0[34] bank_din0[35] bank_din0[36] bank_din0[37] bank_din0[38] bank_din0[39] bank_din0[40] bank_din0[41] bank_din0[42] bank_din0[43] bank_din0[44] bank_din0[45] bank_din0[46] bank_din0[47] bank_din0[48] bank_din0[49] bank_din0[50] bank_din0[51] bank_din0[52] bank_din0[53] bank_din0[54] bank_din0[55] bank_din0[56] bank_din0[57] bank_din0[58] bank_din0[59] bank_din0[60] bank_din0[61] bank_din0[62] bank_din0[63] a0[0] a0[1] a0[2] a0[3] a0[4] a0[5] a0[6] a0[7] a1[0] a1[1] a1[2] a1[3] a1[4] a1[5] a1[6] a1[7] s_en0 s_en1 p_en_bar0 p_en_bar1 w_en0 bank_wmask0[0] bank_wmask0[1] bank_wmask0[2] bank_wmask0[3] bank_wmask0[4] bank_wmask0[5] bank_wmask0[6] bank_wmask0[7] wl_en0 wl_en1 vdd gnd bank
Xcontrol0 csb0 web0 clk0 rbl_bl0 s_en0 w_en0 p_en_bar0 wl_en0 clk_buf0 vdd gnd control_logic_rw
Xcontrol1 csb1 clk1 rbl_bl1 s_en1 p_en_bar1 wl_en1 clk_buf1 vdd gnd control_logic_r
Xrow_address0 addr0[1] addr0[2] addr0[3] addr0[4] addr0[5] addr0[6] addr0[7] a0[1] a0[2] a0[3] a0[4] a0[5] a0[6] a0[7] clk_buf0 vdd gnd row_addr_dff
Xrow_address1 addr1[1] addr1[2] addr1[3] addr1[4] addr1[5] addr1[6] addr1[7] a1[1] a1[2] a1[3] a1[4] a1[5] a1[6] a1[7] clk_buf1 vdd gnd row_addr_dff
Xcol_address0 addr0[0] a0[0] clk_buf0 vdd gnd col_addr_dff
Xcol_address1 addr1[0] a1[0] clk_buf1 vdd gnd col_addr_dff
Xwmask_dff0 wmask0[0] wmask0[1] wmask0[2] wmask0[3] wmask0[4] wmask0[5] wmask0[6] wmask0[7] bank_wmask0[0] bank_wmask0[1] bank_wmask0[2] bank_wmask0[3] bank_wmask0[4] bank_wmask0[5] bank_wmask0[6] bank_wmask0[7] clk_buf0 vdd gnd wmask_dff
Xdata_dff0 din0[0] din0[1] din0[2] din0[3] din0[4] din0[5] din0[6] din0[7] din0[8] din0[9] din0[10] din0[11] din0[12] din0[13] din0[14] din0[15] din0[16] din0[17] din0[18] din0[19] din0[20] din0[21] din0[22] din0[23] din0[24] din0[25] din0[26] din0[27] din0[28] din0[29] din0[30] din0[31] din0[32] din0[33] din0[34] din0[35] din0[36] din0[37] din0[38] din0[39] din0[40] din0[41] din0[42] din0[43] din0[44] din0[45] din0[46] din0[47] din0[48] din0[49] din0[50] din0[51] din0[52] din0[53] din0[54] din0[55] din0[56] din0[57] din0[58] din0[59] din0[60] din0[61] din0[62] din0[63] bank_din0[0] bank_din0[1] bank_din0[2] bank_din0[3] bank_din0[4] bank_din0[5] bank_din0[6] bank_din0[7] bank_din0[8] bank_din0[9] bank_din0[10] bank_din0[11] bank_din0[12] bank_din0[13] bank_din0[14] bank_din0[15] bank_din0[16] bank_din0[17] bank_din0[18] bank_din0[19] bank_din0[20] bank_din0[21] bank_din0[22] bank_din0[23] bank_din0[24] bank_din0[25] bank_din0[26] bank_din0[27] bank_din0[28] bank_din0[29] bank_din0[30] bank_din0[31] bank_din0[32] bank_din0[33] bank_din0[34] bank_din0[35] bank_din0[36] bank_din0[37] bank_din0[38] bank_din0[39] bank_din0[40] bank_din0[41] bank_din0[42] bank_din0[43] bank_din0[44] bank_din0[45] bank_din0[46] bank_din0[47] bank_din0[48] bank_din0[49] bank_din0[50] bank_din0[51] bank_din0[52] bank_din0[53] bank_din0[54] bank_din0[55] bank_din0[56] bank_din0[57] bank_din0[58] bank_din0[59] bank_din0[60] bank_din0[61] bank_din0[62] bank_din0[63] clk_buf0 vdd gnd data_dff
.ENDS sky130_sram_1rw1r_64x256_8
