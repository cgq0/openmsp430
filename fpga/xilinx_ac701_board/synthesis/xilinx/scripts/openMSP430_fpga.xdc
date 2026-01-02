# Converted from openMSP430_fpga.ucf
# Review & adjust MOBILE_DDR / DIFF_MOBILE_DDR IOSTANDARD, RAM placements and any board-specific DDR/MIG constraints.

# ----------------------------
# PROGRAM MEMORY PLACEMENT
# ----------------------------
# The following RAMB16 instance placements from UCF are specific to Spartan-6
# and have no direct 1:1 mapping in Vivado/Artix-7. Recreate memory using
# Vivado IP (Block RAM / inferred) and use the MIG/Memory IP for external DDR.
# INST "..." LOC = "RAMB16_X0Y18";
# ... (omitted)

# ----------------------------
# VCCAUX (note: board power config)
# ----------------------------
# UCF: CONFIG VCCAUX=3.3;
# No direct equivalent in XDC — ensure board power/voltage rails and constraints
# are handled in device/board files or IP configuration.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_mmcm/inst/clk_in1_clk_wiz_0]

# ----------------------------
# User Reset Push Button
# ----------------------------
set_property PACKAGE_PIN U4 [get_ports USER_RESET]
set_property IOSTANDARD SSTL15 [get_ports USER_RESET]

# TIMING IGNORE in UCF (TIG) — if you want to mark as false path or similar, add here.

# ----------------------------
# SPI Flash (Micron N25Q128)
# ----------------------------

set_property PACKAGE_PIN P18 [get_ports SPI_CS_n]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_CS_n]

set_property PACKAGE_PIN R14 [get_ports SPI_MOSI_MISO0]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_MOSI_MISO0]

set_property PACKAGE_PIN R15 [get_ports SPI_MISO_MISO1]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_MISO_MISO1]

set_property PACKAGE_PIN P14 [get_ports SPI_Wn_MISO2]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_Wn_MISO2]

set_property PACKAGE_PIN N14 [get_ports SPI_HOLDn_MISO3]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_HOLDn_MISO3]

# ----------------------------
# CDCE913 Triple-Output PLL / Clocks
# ----------------------------
set_property PACKAGE_PIN P16 [get_ports USER_CLOCK]
set_property IOSTANDARD LVCMOS33 [get_ports USER_CLOCK]

# Clock constraint: USER_CLOCK = 90 MHz -> period 25.0 ns
#create_clock -period 11.000 -name USER_CLOCK [get_ports USER_CLOCK]
# If you use CLOCK_Y2 / CLOCK_Y3, add create_clock lines when needed.

# ----------------------------
# User DIP Switches
# ----------------------------
set_property PACKAGE_PIN R8 [get_ports GPIO_DIP1]
set_property IOSTANDARD SSTL15 [get_ports GPIO_DIP1]
set_property PULLDOWN true [get_ports GPIO_DIP1]

set_property PACKAGE_PIN P8 [get_ports GPIO_DIP2]
set_property IOSTANDARD SSTL15 [get_ports GPIO_DIP2]
set_property PULLDOWN true [get_ports GPIO_DIP2]

set_property PACKAGE_PIN R7 [get_ports GPIO_DIP3]
set_property IOSTANDARD SSTL15 [get_ports GPIO_DIP3]
set_property PULLDOWN true [get_ports GPIO_DIP3]

set_property PACKAGE_PIN R6 [get_ports GPIO_DIP4]
set_property IOSTANDARD SSTL15 [get_ports GPIO_DIP4]
set_property PULLDOWN true [get_ports GPIO_DIP4]

# ----------------------------
# User LEDs (note: LVCMOS18)
# ----------------------------
set_property PACKAGE_PIN M26 [get_ports GPIO_LED1]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_LED1]

set_property PACKAGE_PIN T24 [get_ports GPIO_LED2]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_LED2]

set_property PACKAGE_PIN T25 [get_ports GPIO_LED3]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_LED3]

set_property PACKAGE_PIN R26 [get_ports GPIO_LED4]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_LED4]

# ----------------------------
# USB-to-UART (CP2102)
# ----------------------------
set_property PACKAGE_PIN T19 [get_ports USB_RS232_RXD]
set_property IOSTANDARD LVCMOS18 [get_ports USB_RS232_RXD]

set_property PACKAGE_PIN U19 [get_ports USB_RS232_TXD]
set_property IOSTANDARD LVCMOS18 [get_ports USB_RS232_TXD]

# ----------------------------
# CDCE913 I2C (programming)
# ----------------------------
set_property PACKAGE_PIN P26 [get_ports SCL]
set_property IOSTANDARD LVCMOS33 [get_ports SCL]
set_property PULLUP true [get_ports SCL]

set_property PACKAGE_PIN T22 [get_ports SDA]
set_property IOSTANDARD LVCMOS33 [get_ports SDA]
set_property PULLUP true [get_ports SDA]

# ----------------------------
# LPDDR (MIG required) — TODO: migrate to MIG/IP constraints
# ----------------------------
# The UCF lists many LPDDR pins with IOSTANDARD = MOBILE_DDR / DIFF_MOBILE_DDR.
# For Artix-7 you must use MIG/Memory IP and follow the MIG pinout/constraints.
# Below are the lines converted but please DO NOT rely on these blindly — use MIG output XDC.
# Example single-ended mapping (may be invalid in Vivado for DDR IO):
# set_property PACKAGE_PIN J7 [get_ports LPDDR_A0]
# set_property IOSTANDARD MOBILE_DDR [get_ports LPDDR_A0]
# ...
# Differential clock (example):
# set_property PACKAGE_PIN G1 [get_ports LPDDR_CK_N]
# set_property IOSTANDARD DIFF_MOBILE_DDR [get_ports LPDDR_CK_N]
# set_property PACKAGE_PIN G3 [get_ports LPDDR_CK_P]
# set_property IOSTANDARD DIFF_MOBILE_DDR [get_ports LPDDR_CK_P]

# ----------------------------
# Ethernet PHY (DP83848J)
# ----------------------------


# ----------------------------
# PMOD Connectors
# ----------------------------


#create_property bmm_info_memory_device cell -type string
#set_property bmm_info_memory_device {[ 0: 3][0:8191]} [get_cells ram_16x8k_dp_pmem_shared/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/prim_noinit.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram]
#set_property bmm_info_memory_device {[ 4: 7][0:8191]} [get_cells ram_16x8k_dp_pmem_shared/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[1].ram.r/prim_noinit.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram]
#set_property bmm_info_memory_device {[ 8: 11][0:8191]} [get_cells ram_16x8k_dp_pmem_shared/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[2].ram.r/prim_noinit.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram]
#set_property bmm_info_memory_device {[ 12: 15][0:8191]} [get_cells ram_16x8k_dp_pmem_shared/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[3].ram.r/prim_noinit.ram/DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram]







connect_debug_port u_ila_0/probe4 [get_nets [list {pmem_read_addr_b[0]} {pmem_read_addr_b[1]} {pmem_read_addr_b[2]} {pmem_read_addr_b[3]} {pmem_read_addr_b[4]} {pmem_read_addr_b[5]} {pmem_read_addr_b[6]} {pmem_read_addr_b[7]} {pmem_read_addr_b[8]} {pmem_read_addr_b[9]} {pmem_read_addr_b[10]} {pmem_read_addr_b[11]} {pmem_read_addr_b[12]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list pmem_read_enb]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_mmcm/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 13 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {omsp1_pmem_addr[0]} {omsp1_pmem_addr[1]} {omsp1_pmem_addr[2]} {omsp1_pmem_addr[3]} {omsp1_pmem_addr[4]} {omsp1_pmem_addr[5]} {omsp1_pmem_addr[6]} {omsp1_pmem_addr[7]} {omsp1_pmem_addr[8]} {omsp1_pmem_addr[9]} {omsp1_pmem_addr[10]} {omsp1_pmem_addr[11]} {omsp1_pmem_addr[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {omsp1_pmem_dout[0]} {omsp1_pmem_dout[1]} {omsp1_pmem_dout[2]} {omsp1_pmem_dout[3]} {omsp1_pmem_dout[4]} {omsp1_pmem_dout[5]} {omsp1_pmem_dout[6]} {omsp1_pmem_dout[7]} {omsp1_pmem_dout[8]} {omsp1_pmem_dout[9]} {omsp1_pmem_dout[10]} {omsp1_pmem_dout[11]} {omsp1_pmem_dout[12]} {omsp1_pmem_dout[13]} {omsp1_pmem_dout[14]} {omsp1_pmem_dout[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {omsp0_pmem_dout[0]} {omsp0_pmem_dout[1]} {omsp0_pmem_dout[2]} {omsp0_pmem_dout[3]} {omsp0_pmem_dout[4]} {omsp0_pmem_dout[5]} {omsp0_pmem_dout[6]} {omsp0_pmem_dout[7]} {omsp0_pmem_dout[8]} {omsp0_pmem_dout[9]} {omsp0_pmem_dout[10]} {omsp0_pmem_dout[11]} {omsp0_pmem_dout[12]} {omsp0_pmem_dout[13]} {omsp0_pmem_dout[14]} {omsp0_pmem_dout[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 13 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {omsp0_pmem_addr[0]} {omsp0_pmem_addr[1]} {omsp0_pmem_addr[2]} {omsp0_pmem_addr[3]} {omsp0_pmem_addr[4]} {omsp0_pmem_addr[5]} {omsp0_pmem_addr[6]} {omsp0_pmem_addr[7]} {omsp0_pmem_addr[8]} {omsp0_pmem_addr[9]} {omsp0_pmem_addr[10]} {omsp0_pmem_addr[11]} {omsp0_pmem_addr[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list omsp0_pmem_cen]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list omsp1_pmem_cen]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dco_clk]
