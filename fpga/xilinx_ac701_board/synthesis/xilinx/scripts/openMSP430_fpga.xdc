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

# ----------------------------
# User Reset Push Button
# ----------------------------
set_property PACKAGE_PIN V4 [get_ports USER_RESET]
set_property IOSTANDARD LVCMOS33 [get_ports USER_RESET]
set_property PULLDOWN true [get_ports USER_RESET]
# TIMING IGNORE in UCF (TIG) — if you want to mark as false path or similar, add here.

# ----------------------------
# SPI Flash (Micron N25Q128)
# ----------------------------
set_property PACKAGE_PIN R15 [get_ports SPI_SCK]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_SCK]

set_property PACKAGE_PIN V3 [get_ports SPI_CS_n]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_CS_n]

set_property PACKAGE_PIN T13 [get_ports SPI_MOSI_MISO0]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_MOSI_MISO0]

set_property PACKAGE_PIN R13 [get_ports SPI_MISO_MISO1]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_MISO_MISO1]

set_property PACKAGE_PIN T14 [get_ports SPI_Wn_MISO2]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_Wn_MISO2]

set_property PACKAGE_PIN V14 [get_ports SPI_HOLDn_MISO3]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_HOLDn_MISO3]

# ----------------------------
# CDCE913 Triple-Output PLL / Clocks
# ----------------------------
set_property PACKAGE_PIN V10 [get_ports USER_CLOCK]
set_property IOSTANDARD LVCMOS33 [get_ports USER_CLOCK]

set_property PACKAGE_PIN K15 [get_ports CLOCK_Y2]
set_property IOSTANDARD LVCMOS33 [get_ports CLOCK_Y2]

set_property PACKAGE_PIN C10 [get_ports CLOCK_Y3]
set_property IOSTANDARD LVCMOS33 [get_ports CLOCK_Y3]

# Clock constraint: USER_CLOCK = 40 MHz -> period 25.0 ns
create_clock -name USER_CLOCK -period 25.0 [get_ports USER_CLOCK]
# If you use CLOCK_Y2 / CLOCK_Y3, add create_clock lines when needed.

# ----------------------------
# Backup oscillator
# ----------------------------
set_property PACKAGE_PIN R8 [get_ports BACKUP_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports BACKUP_CLK]

# ----------------------------
# User DIP Switches
# ----------------------------
set_property PACKAGE_PIN B3 [get_ports GPIO_DIP1]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_DIP1]
set_property PULLDOWN true [get_ports GPIO_DIP1]

set_property PACKAGE_PIN A3 [get_ports GPIO_DIP2]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_DIP2]
set_property PULLDOWN true [get_ports GPIO_DIP2]

set_property PACKAGE_PIN B4 [get_ports GPIO_DIP3]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_DIP3]
set_property PULLDOWN true [get_ports GPIO_DIP3]

set_property PACKAGE_PIN A4 [get_ports GPIO_DIP4]
set_property IOSTANDARD LVCMOS33 [get_ports GPIO_DIP4]
set_property PULLDOWN true [get_ports GPIO_DIP4]

# ----------------------------
# User LEDs (note: LVCMOS18)
# ----------------------------
set_property PACKAGE_PIN P4 [get_ports GPIO_LED1]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED1]

set_property PACKAGE_PIN L6 [get_ports GPIO_LED2]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED2]

set_property PACKAGE_PIN F5 [get_ports GPIO_LED3]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED3]

set_property PACKAGE_PIN C2 [get_ports GPIO_LED4]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED4]

# ----------------------------
# USB-to-UART (CP2102)
# ----------------------------
set_property PACKAGE_PIN R7 [get_ports USB_RS232_RXD]
set_property IOSTANDARD LVCMOS33 [get_ports USB_RS232_RXD]

set_property PACKAGE_PIN T7 [get_ports USB_RS232_TXD]
set_property IOSTANDARD LVCMOS33 [get_ports USB_RS232_TXD]

# ----------------------------
# CDCE913 I2C (programming)
# ----------------------------
set_property PACKAGE_PIN P12 [get_ports SCL]
set_property IOSTANDARD LVCMOS33 [get_ports SCL]
set_property PULLUP true [get_ports SCL]

set_property PACKAGE_PIN U13 [get_ports SDA]
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
set_property PACKAGE_PIN M18 [get_ports ETH_COL]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_COL]
set_property PULLDOWN true [get_ports ETH_COL]

set_property PACKAGE_PIN N17 [get_ports ETH_CRS]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_CRS]
set_property PULLDOWN true [get_ports ETH_CRS]

set_property PACKAGE_PIN M16 [get_ports ETH_MDC]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_MDC]

set_property PACKAGE_PIN L18 [get_ports ETH_MDIO]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_MDIO]

set_property PACKAGE_PIN T18 [get_ports ETH_RESET_n]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RESET_n]
# UCF had TIG on ETH_RESET#; if you need special timing or set as pull/no-connect, adjust here.

set_property PACKAGE_PIN L15 [get_ports ETH_RX_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_CLK]

set_property PACKAGE_PIN T17 [get_ports ETH_RX_D0]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_D0]
set_property PULLUP true [get_ports ETH_RX_D0]

set_property PACKAGE_PIN N16 [get_ports ETH_RX_D1]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_D1]
set_property PULLUP true [get_ports ETH_RX_D1]

set_property PACKAGE_PIN N15 [get_ports ETH_RX_D2]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_D2]
set_property PULLUP true [get_ports ETH_RX_D2]

set_property PACKAGE_PIN P18 [get_ports ETH_RX_D3]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_D3]
set_property PULLUP true [get_ports ETH_RX_D3]

set_property PACKAGE_PIN P17 [get_ports ETH_RX_DV]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_DV]

set_property PACKAGE_PIN N18 [get_ports ETH_RX_ER]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RX_ER]

set_property PACKAGE_PIN H17 [get_ports ETH_TX_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TX_CLK]

set_property PACKAGE_PIN K18 [get_ports ETH_TX_D0]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TX_D0]

set_property PACKAGE_PIN K17 [get_ports ETH_TX_D1]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TX_D1]

set_property PACKAGE_PIN J18 [get_ports ETH_TX_D2]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TX_D2]

set_property PACKAGE_PIN J16 [get_ports ETH_TX_D3]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TX_D3]

set_property PACKAGE_PIN L17 [get_ports ETH_TX_EN]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TX_EN]

# ----------------------------
# PMOD Connectors
# ----------------------------
set_property PACKAGE_PIN F15 [get_ports PMOD1_P1]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1_P1]

set_property PACKAGE_PIN F16 [get_ports PMOD1_P2]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1_P2]

set_property PACKAGE_PIN C17 [get_ports PMOD1_P3]
set_property IOSTANDARD I2C [get_ports PMOD1_P3]
set_property PULLUP true [get_ports PMOD1_P3]

set_property PACKAGE_PIN C18 [get_ports PMOD1_P4]
set_property IOSTANDARD I2C [get_ports PMOD1_P4]
set_property PULLUP true [get_ports PMOD1_P4]

set_property PACKAGE_PIN F14 [get_ports PMOD1_P7]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1_P7]

set_property PACKAGE_PIN G14 [get_ports PMOD1_P8]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1_P8]

set_property PACKAGE_PIN D17 [get_ports PMOD1_P9]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1_P9]

set_property PACKAGE_PIN D18 [get_ports PMOD1_P10]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1_P10]

set_property PACKAGE_PIN H12 [get_ports PMOD2_P1]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P1]

set_property PACKAGE_PIN G13 [get_ports PMOD2_P2]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P2]

set_property PACKAGE_PIN E16 [get_ports PMOD2_P3]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P3]

set_property PACKAGE_PIN E18 [get_ports PMOD2_P4]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P4]

set_property PACKAGE_PIN K12 [get_ports PMOD2_P7]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P7]

set_property PACKAGE_PIN K13 [get_ports PMOD2_P8]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P8]

set_property PACKAGE_PIN F17 [get_ports PMOD2_P9]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P9]

set_property PACKAGE_PIN F18 [get_ports PMOD2_P10]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD2_P10]

# ----------------------------
# End of file
# ----------------------------

# Notes:
# - Verify all top-level port names match those used in your RTL.
# - For DDR/LPDDR/MCB sections use Vivado's Memory Interface Generator (MIG) to produce correct constraints.
# - Replace any non-supported IOSTANDARD strings with Vivado-supported ones for your target Artix-7 device.