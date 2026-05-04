# IHP SG13G2 Platform for OpenROAD-flow-scripts

## Overview

The IHP SG13G2 is a **130 nm BiCMOS open PDK** developed by
[IHP – Innovations for High Performance Microelectronics](https://www.ihp-microelectronics.com/)
and released under the Apache 2.0 licence.  It is one of the few fully open
silicon PDKs that includes not only standard CMOS logic cells but also
heterojunction bipolar transistors (HBTs), RF MOS devices, MIM capacitors,
spiral inductors, and ESD protection structures.

Core supply voltage is **1.2 V**; the I/O ring operates at **3.3 V**.

---

## Metal Stack

The process provides **7 routing layers**:

| Layer      | Direction  | Min. Width | Pitch   | Notes                         |
|------------|------------|------------|---------|-------------------------------|
| Metal1     | Horizontal | 0.16 µm    | 0.42 µm | Signal / PDN follow-pins      |
| Metal2     | Vertical   | 0.16 µm    | 0.42 µm | Signal                        |
| Metal3     | Horizontal | 0.16 µm    | –       | Signal                        |
| Metal4     | Vertical   | 0.16 µm    | –       | Signal                        |
| Metal5     | Horizontal | 0.16 µm    | –       | Signal (default MAX_ROUTING)  |
| TopMetal1  | Vertical   | thicker    | –       | PDN rings & stripes           |
| TopMetal2  | Horizontal | thicker    | –       | PDN rings & stripes / bumps   |

The default routing range for digital designs is **Metal2 – Metal5**.
Designs that use a padframe (see below) typically extend routing up to
**TopMetal2** so the PDN ring can connect to the IO power pads.

The manufacturing grid is **0.005 µm**.

---

## Standard-Cell Library

The `sg13g2_stdcell` library ships three timing corners.  The IO library
(`sg13g2_io`) follows the same corner names with separate core/IO voltages:

| Corner  | Core VDD | IO VDD | Temp   |
|---------|----------|--------|--------|
| Typical | 1.20 V   | 3.3 V  | 25 °C  |
| Slow    | 1.08 V   | 3.0 V  | 125 °C |
| Fast    | 1.32 V   | 3.6 V  | −40 °C |

Latch and clock-gate synthesis mappings are provided via `cells_latch.v` and
`cells_clkgate.v`.

Fill / decap cells: `sg13g2_fill_1`, `sg13g2_fill_2`, `sg13g2_decap_4`,
`sg13g2_decap_8`.

---

## SRAM Macros

SRAM macros are available in the following configurations and are ready to use
as hard macros (single-port today; dual-port variants are forthcoming).  Each
variant ships LEF, LIB (slow/typ/fast), and is covered by the
`GDS_ALLOW_EMPTY` pattern for the internal placeholder cells that appear
during GDS merge.

| Macro name                         | Depth × Width |
|------------------------------------|---------------|
| RM_IHPSG13_1P_64x64_c2_bm_bist    | 64 × 64 bit   |
| RM_IHPSG13_1P_256x48_c2_bm_bist   | 256 × 48 bit  |
| RM_IHPSG13_1P_256x64_c2_bm_bist   | 256 × 64 bit  |
| RM_IHPSG13_1P_512x64_c2_bm_bist   | 512 × 64 bit  |
| RM_IHPSG13_1P_1024x8_c2_bm_bist   | 1024 × 8 bit  |
| RM_IHPSG13_1P_1024x16_c2_bm_bist  | 1024 × 16 bit |
| RM_IHPSG13_1P_1024x64_c2_bm_bist  | 1024 × 64 bit |
| RM_IHPSG13_1P_2048x64_c2_bm_bist  | 2048 × 64 bit |
| RM_IHPSG13_1P_4096x8_c3_bm_bist   | 4096 × 8 bit  |
| RM_IHPSG13_1P_4096x16_c3_bm_bist  | 4096 × 16 bit |

To include a macro in your design, add the corresponding LEF to
`ADDITIONAL_LEFS` and the three `.lib` files to the respective
`ADDITIONAL_SLOW_LIBS` / `ADDITIONAL_TYP_LIBS` / `ADDITIONAL_FAST_LIBS`
variables in your design's `config.mk`.

---

## Padframe

The SG13G2 IO library (`sg13g2_io`) provides mixed-signal GPIO pads that
operate at 3.3 V on the outside and 1.2 V on the core side.  Wire-bond
designs use `bondpad_70x70` (70 × 70 µm) pads placed immediately outside
the IO ring.

### How it works

The platform's `pad.tcl` script drives the entire padframe flow when
`FOOTPRINT_TCL` is set in the design's `config.mk`.  Setting that variable
also causes `config.mk` to automatically add the IO LEF, LIB, and GDS files.

`pad.tcl` performs the following steps in order:

1. Computes the IO offset from `IO_BONDPAD_SIZE` (default 70 µm) and
   `IO_SEALRING_OFFSET` (default 70 µm).
2. Creates fake IO sites (`IOLibSite` 1 × 180 µm, `IOLibCSite` 180 × 180 µm).
3. Instantiates IO rows on all four sides with `make_io_sites`.
4. Places the IO pads listed in `IO_{NORTH,EAST,SOUTH,WEST}_PINS` with
   `place_pads`.
5. Places corner cells (`sg13g2_Corner`) and fills the remaining gaps with
   the `sg13g2_Filler*` series.
6. Calls `connect_by_abutment` to wire the power rails that run through the
   IO ring.
7. Places bondpads at offset `(5.0, −70)` relative to each `sg13g2_IOPad*`
   instance.
8. Removes the temporary IO rows.

### Design config.mk snippet

```makefile
# Point to the platform pad script to enable the padframe flow
export FOOTPRINT_TCL = $(PLATFORM_DIR)/pad.tcl

# Ordered pad instance names, one entry per side
export IO_NORTH_PINS = sg13g2_IOPad_foo sg13g2_IOPad_bar
export IO_EAST_PINS  = sg13g2_IOPadVdd_inst sg13g2_IOPadVss_inst \
                       sg13g2_IOPad_baz
export IO_SOUTH_PINS = sg13g2_IOPad_clk sg13g2_IOPad_rst
export IO_WEST_PINS  = sg13g2_IOPad_gpio_0 sg13g2_IOPadIOVss_inst \
                       sg13g2_IOPadIOVdd_inst

# Die area must be large enough to accommodate the padframe
# IO ring = 180 µm deep; sealring offset = 70 µm; bondpad = 70 µm
# -> minimum margin from die edge to core edge ≈ 320 µm per side
export DIE_AREA  = 0.0 0.0 1050.24 1050.84
export CORE_AREA = 351.36 351.54 699.84 699.3

# Extend routing to TopMetal2 so the PDN ring reaches the IO power pads
export MAX_ROUTING_LAYER = TopMetal2

# Optional sealring GDS (merged in the final step)
export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/sealring.gds.gz
```

The sealring GDS can be generated with the IHP SG13G2 sealring Pcell in
KLayout, sized to match `DIE_AREA`.
