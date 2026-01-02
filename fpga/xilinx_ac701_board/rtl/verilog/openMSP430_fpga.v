//----------------------------------------------------------------------------
// Copyright (C) 2011 Authors
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
// License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
//----------------------------------------------------------------------------
//
// *File Name: openMSP430_fpga.v
//
// *Module Description:
//                      openMSP430 FPGA Top-level for the Avnet LX9 Microboard
//
// *Author(s):
//              - Ricardo Ribalda,    ricardo.ribalda@gmail.com
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
`timescale 1ns / 100ps
`include "openmsp430/openMSP430_defines.v"

module openMSP430_fpga (

     //----------------------------------------------
     // User Reset Push Button
     //----------------------------------------------
     USER_RESET,

     //----------------------------------------------
     // Micron N25Q128 SPI Flash
     //   This is a Multi-I/O Flash.  Several pins
     //  have dual purposes depending on the mode.
     //----------------------------------------------
     //SPI_SCK,
     SPI_CS_n,
     SPI_MOSI_MISO0,
     SPI_MISO_MISO1,
     SPI_Wn_MISO2,
     SPI_HOLDn_MISO3,

     //----------------------------------------------
     // TI CDCE913 Triple-Output PLL Clock Chip
     //   Y1: 40 MHz, USER_CLOCK can be used as
     //              external configuration clock
     //   Y2: 66.667 MHz
     //   Y3: 100 MHz
     //----------------------------------------------
     USER_CLOCK,  

     //----------------------------------------------
     // User DIP Switch x4
     //----------------------------------------------
     GPIO_DIP1,
     GPIO_DIP2,
     GPIO_DIP3,
     GPIO_DIP4,

     //----------------------------------------------
     // User LEDs
     //----------------------------------------------
     GPIO_LED1,
     GPIO_LED2,
     GPIO_LED3,
     GPIO_LED4,

     //----------------------------------------------
     // Silicon Labs CP2102 USB-to-UART Bridge Chip
     //----------------------------------------------
     USB_RS232_RXD,
     USB_RS232_TXD,

     //----------------------------------------------
     // Texas Instruments CDCE913 programming port
     //----------------------------------------------
     SCL,
     SDA     
);

//----------------------------------------------
// User Reset Push Button
//----------------------------------------------
input    USER_RESET;

//----------------------------------------------
// Micron N25Q128 SPI Flash
//   This is a Multi-I/O Flash.  Several pins
//  have dual purposes depending on the mode.
//----------------------------------------------
//output   SPI_SCK;
output   SPI_CS_n;
inout    SPI_MOSI_MISO0;
inout    SPI_MISO_MISO1;
output   SPI_Wn_MISO2;
output   SPI_HOLDn_MISO3;

//----------------------------------------------
// TI CDCE913 Triple-Output PLL Clock Chip
//   Y1: 40 MHz; USER_CLOCK can be used as
//              external configuration clock
//   Y2: 66.667 MHz
//   Y3: 100 MHz
//----------------------------------------------
input    USER_CLOCK;

//----------------------------------------------
// User DIP Switch x4
//----------------------------------------------
input    GPIO_DIP1;
input    GPIO_DIP2;
input    GPIO_DIP3;
input    GPIO_DIP4;

//----------------------------------------------
// User LEDs
//----------------------------------------------
output   GPIO_LED1;
output   GPIO_LED2;
output   GPIO_LED3;
output   GPIO_LED4;

//----------------------------------------------
// Silicon Labs CP2102 USB-to-UART Bridge Chip
//----------------------------------------------
input    USB_RS232_RXD;
output   USB_RS232_TXD;

//----------------------------------------------
// SCL----PMOD0
// SDA----PMOD1
//----------------------------------------------
output   SCL;
inout    SDA;


//=============================================================================
// 1)  INTERNAL WIRES/REGISTERS/PARAMETERS DECLARATION
//=============================================================================

// Clock generation
wire               dcm_locked;
wire               dco_clk;

// Reset generation
wire               reset_pin;
wire               reset_n;

// Debug interface
wire               omsp_dbg_i2c_scl;
wire 	           omsp_dbg_i2c_sda_in;
wire               omsp_dbg_i2c_sda_out;
wire               omsp0_dbg_i2c_sda_out;
wire               omsp1_dbg_i2c_sda_out;
wire        [23:0] chipscope_trigger;

// Data memory
wire [`DMEM_MSB:0] omsp0_dmem_addr;
wire               omsp0_dmem_cen;
wire               omsp0_dmem_cen_sp;
wire               omsp0_dmem_cen_dp;
wire        [15:0] omsp0_dmem_din;
wire         [1:0] omsp0_dmem_wen;
wire        [15:0] omsp0_dmem_dout;
wire        [15:0] omsp0_dmem_dout_sp;
wire        [15:0] omsp0_dmem_dout_dp;
reg                omsp0_dmem_dout_sel;

wire [`DMEM_MSB:0] omsp1_dmem_addr;
wire               omsp1_dmem_cen;
wire               omsp1_dmem_cen_sp;
wire               omsp1_dmem_cen_dp;
wire        [15:0] omsp1_dmem_din;
wire         [1:0] omsp1_dmem_wen;
wire        [15:0] omsp1_dmem_dout;
wire        [15:0] omsp1_dmem_dout_sp;
wire        [15:0] omsp1_dmem_dout_dp;
reg                omsp1_dmem_dout_sel;

// Program memory
(*mark_debug="true"*)  wire [`PMEM_MSB:0] omsp0_pmem_addr;
(*mark_debug="true"*)  wire               omsp0_pmem_cen;
wire        [15:0] omsp0_pmem_din;
wire         [1:0] omsp0_pmem_wen;
(*mark_debug="true"*)  wire        [15:0] omsp0_pmem_dout;

(*mark_debug="true"*)  wire [`PMEM_MSB:0] omsp1_pmem_addr;
(*mark_debug="true"*)  wire               omsp1_pmem_cen;
wire        [15:0] omsp1_pmem_din;
wire         [1:0] omsp1_pmem_wen;
(*mark_debug="true"*)  wire        [15:0] omsp1_pmem_dout;
// UART
wire               omsp0_uart_rxd;
wire               omsp0_uart_txd;

// LEDs & Switches
wire         [3:0] omsp_switch;
wire         [1:0] omsp0_led;
wire         [1:0] omsp1_led;


//=============================================================================
// 2)  RESET GENERATION & FPGA STARTUP
//=============================================================================

// Reset input buffer
IBUF   ibuf_reset_n   (.O(reset_pin), .I(USER_RESET));

// Release the reset only, if the DCM is locked
assign  reset_n =  dcm_locked;

// Top level reset generation
wire dco_rst;
omsp_sync_reset sync_reset_dco (.rst_s (dco_rst), .clk(dco_clk), .rst_a(!reset_n));


//=============================================================================
// 3)  CLOCK GENERATION
//=============================================================================

clk_wiz_0 u_mmcm(
    .clk_in1(USER_CLOCK),      // input clk_in1
    .reset(reset_pin),          // input reset
    .locked(dcm_locked),        // output locked
    .clk_out1(dco_clk)         // output clk_out1
);


//=============================================================================
// 4)  OPENMSP430 SYSTEM 0
//=============================================================================

omsp_system_0 omsp_system_0_inst (

// Clock & Reset
    .dco_clk           (dco_clk),                     // Fast oscillator (fast clock)
    .reset_n           (reset_n),                     // Reset Pin (low active, asynchronous and non-glitchy)

// Serial Debug Interface (I2C)
    .dbg_i2c_addr      (7'd50),                       // Debug interface: I2C Address
    .dbg_i2c_broadcast (7'd49),                       // Debug interface: I2C Broadcast Address (for multicore systems)
    .dbg_i2c_scl       (omsp_dbg_i2c_scl),            // Debug interface: I2C SCL
    .dbg_i2c_sda_in    (omsp_dbg_i2c_sda_in),         // Debug interface: I2C SDA IN
    .dbg_i2c_sda_out   (omsp0_dbg_i2c_sda_out),       // Debug interface: I2C SDA OUT

// Data Memory
    .dmem_addr         (omsp0_dmem_addr),             // Data Memory address
    .dmem_cen          (omsp0_dmem_cen),              // Data Memory chip enable (low active)
    .dmem_din          (omsp0_dmem_din),              // Data Memory data input
    .dmem_wen          (omsp0_dmem_wen),              // Data Memory write enable (low active)
    .dmem_dout         (omsp0_dmem_dout),             // Data Memory data output

// Program Memory
    .pmem_addr         (omsp0_pmem_addr),             // Program Memory address
    .pmem_cen          (omsp0_pmem_cen),              // Program Memory chip enable (low active)
    .pmem_din          (omsp0_pmem_din),              // Program Memory data input (optional)
    .pmem_wen          (omsp0_pmem_wen),              // Program Memory write enable (low active) (optional)
    .pmem_dout         (omsp0_pmem_dout),             // Program Memory data output

// UART
    .uart_rxd          (omsp0_uart_rxd),              // UART Data Receive (RXD)
    .uart_txd          (omsp0_uart_txd),              // UART Data Transmit (TXD)

// Switches & LEDs
    .switch            (omsp_switch),                 // Input switches
    .led               (omsp0_led)                    // LEDs
);


//=============================================================================
// 5)  OPENMSP430 SYSTEM 1
//=============================================================================

omsp_system_1 omsp_system_1_inst (

// Clock & Reset
    .dco_clk           (dco_clk),                     // Fast oscillator (fast clock)
    .reset_n           (reset_n),                     // Reset Pin (low active, asynchronous and non-glitchy)

// Serial Debug Interface (I2C)
    .dbg_i2c_addr      (7'd51),                       // Debug interface: I2C Address
    .dbg_i2c_broadcast (7'd49),                       // Debug interface: I2C Broadcast Address (for multicore systems)
    .dbg_i2c_scl       (omsp_dbg_i2c_scl),            // Debug interface: I2C SCL
    .dbg_i2c_sda_in    (omsp_dbg_i2c_sda_in),         // Debug interface: I2C SDA IN
    .dbg_i2c_sda_out   (omsp1_dbg_i2c_sda_out),       // Debug interface: I2C SDA OUT

// Data Memory
    .dmem_addr         (omsp1_dmem_addr),             // Data Memory address
    .dmem_cen          (omsp1_dmem_cen),              // Data Memory chip enable (low active)
    .dmem_din          (omsp1_dmem_din),              // Data Memory data input
    .dmem_wen          (omsp1_dmem_wen),              // Data Memory write enable (low active)
    .dmem_dout         (omsp1_dmem_dout),             // Data Memory data output

// Program Memory
    .pmem_addr         (omsp1_pmem_addr),             // Program Memory address
    .pmem_cen          (omsp1_pmem_cen),              // Program Memory chip enable (low active)
    .pmem_din          (omsp1_pmem_din),              // Program Memory data input (optional)
    .pmem_wen          (omsp1_pmem_wen),              // Program Memory write enable (low active) (optional)
    .pmem_dout         (omsp1_pmem_dout),             // Program Memory data output

// Switches & LEDs
    .switch            (omsp_switch),                 // Input switches
    .led               (omsp1_led)                    // LEDs
);


//=============================================================================
// 6)  PROGRAM AND DATA MEMORIES
//=============================================================================

// Memory muxing (CPU 0)
assign omsp0_dmem_cen_sp =  omsp0_dmem_addr[`DMEM_MSB] | omsp0_dmem_cen;
assign omsp0_dmem_cen_dp = ~omsp0_dmem_addr[`DMEM_MSB] | omsp0_dmem_cen;
assign omsp0_dmem_dout   =  omsp0_dmem_dout_sel ? omsp0_dmem_dout_sp : omsp0_dmem_dout_dp;

always @ (posedge dco_clk or posedge dco_rst)
  if (dco_rst)                  omsp0_dmem_dout_sel <=  1'b1;
  else if (~omsp0_dmem_cen_sp)  omsp0_dmem_dout_sel <=  1'b1;
  else if (~omsp0_dmem_cen_dp)  omsp0_dmem_dout_sel <=  1'b0;

// Memory muxing (CPU 1)
assign omsp1_dmem_cen_sp =  omsp1_dmem_addr[`DMEM_MSB] | omsp1_dmem_cen;
assign omsp1_dmem_cen_dp = ~omsp1_dmem_addr[`DMEM_MSB] | omsp1_dmem_cen;
assign omsp1_dmem_dout   =  omsp1_dmem_dout_sel ? omsp1_dmem_dout_sp : omsp1_dmem_dout_dp;

always @ (posedge dco_clk or posedge dco_rst)
  if (dco_rst)                  omsp1_dmem_dout_sel <=  1'b1;
  else if (~omsp1_dmem_cen_sp)  omsp1_dmem_dout_sel <=  1'b1;
  else if (~omsp1_dmem_cen_dp)  omsp1_dmem_dout_sel <=  1'b0;

// Data Memory (CPU 0)
ram_16x1k_sp ram_16x1k_sp_dmem_omsp0 (
    .clka           ( dco_clk),
    .ena            (~omsp0_dmem_cen_sp),
    .wea            (~omsp0_dmem_wen),
    .addra          ( omsp0_dmem_addr[`DMEM_MSB-1:0]),
    .dina           ( omsp0_dmem_din),
    .douta          ( omsp0_dmem_dout_sp)
);

// Data Memory (CPU 1)
ram_16x1k_sp ram_16x1k_sp_dmem_omsp1 (
    .clka           ( dco_clk),
    .ena            (~omsp1_dmem_cen_sp),
    .wea            (~omsp1_dmem_wen),
    .addra          ( omsp1_dmem_addr[`DMEM_MSB-1:0]),
    .dina           ( omsp1_dmem_din),
    .douta          ( omsp1_dmem_dout_sp)
);

// Shared Data Memory
ram_16x1k_dp ram_16x1k_dp_dmem_shared (
    .clka           ( dco_clk),
    .ena            (~omsp0_dmem_cen_dp),
    .wea            (~omsp0_dmem_wen),
    .addra          ( omsp0_dmem_addr[`DMEM_MSB-1:0]),
    .dina           ( omsp0_dmem_din),
    .douta          ( omsp0_dmem_dout_dp),
    .clkb           ( dco_clk),
    .enb            (~omsp1_dmem_cen_dp),
    .web            (~omsp1_dmem_wen),
    .addrb          ( omsp1_dmem_addr[`DMEM_MSB-1:0]),
    .dinb           ( omsp1_dmem_din),
    .doutb          ( omsp1_dmem_dout_dp)
);

// Shared Program Memory
//`define DEBUG_PMEM
`ifdef DEBUG_PMEM
    // Read-address counter for PMEM port B (used to sequentially read all contents)
    (*mark_debug="true"*) reg [`PMEM_MSB:0] pmem_read_addr_b;
    (*mark_debug="true"*) reg pmem_read_enb;
    ram_16x8k_dp ram_16x8k_dp_pmem_shared (
        .clka           ( dco_clk),
        .ena            (~omsp0_pmem_cen),
        .wea            (~omsp0_pmem_wen),    
        .addra          ( omsp0_pmem_addr),
        .dina           ( 16'haa55),
        .douta          ( omsp0_pmem_dout),
        .clkb           ( dco_clk),
        .enb            ( pmem_read_enb ),
        .web            ( 2'b00 ),
        .addrb          ( pmem_read_addr_b ),
        .dinb           ( 16'haa55),
        .doutb          ( omsp1_pmem_dout)
    );
    // Generate an enable that pulses every other clock and increment address on that pulse
    always @ (posedge dco_clk or posedge dco_rst)
    begin
        if (dco_rst) begin
            pmem_read_addr_b <= {(`PMEM_MSB+1){1'b0}};
            pmem_read_enb    <= 1'b0;
        end
        else begin
            pmem_read_enb <= ~pmem_read_enb; // toggle: read every other clock
            if (pmem_read_enb)
                pmem_read_addr_b <= pmem_read_addr_b + 1'b1;
        end
    end
`else
    ram_16x8k_dp ram_16x8k_dp_pmem_shared (
        .clka           ( dco_clk),
        .ena            (~omsp0_pmem_cen),
        .wea            (~omsp0_pmem_wen),
        .addra          ( omsp0_pmem_addr),
        .dina           ( omsp0_pmem_din),
        .douta          ( omsp0_pmem_dout),
        .clkb           ( dco_clk),
        .enb            (~omsp1_pmem_cen),
        .web            (~omsp1_pmem_wen),
        .addrb          ( omsp1_pmem_addr),
        .dinb           ( omsp1_pmem_din),
        .doutb          ( omsp1_pmem_dout)
    );
`endif


//=============================================================================
// 7)  I/O CELLS
//=============================================================================

//----------------------------------------------
// Micron N25Q128 SPI Flash
//   This is a Multi-I/O Flash.  Several pins
//  have dual purposes depending on the mode.
//----------------------------------------------
//OBUF  SPI_CLK_PIN        (.I(1'b0),                  .O(SPI_SCK));
OBUF  SPI_CSN_PIN        (.I(1'b1),                  .O(SPI_CS_n));
IOBUF SPI_MOSI_MISO0_PIN (.T(1'b0), .I(1'b0), .O(),  .IO(SPI_MOSI_MISO0));
IOBUF SPI_MISO_MISO1_PIN (.T(1'b0), .I(1'b0), .O(),  .IO(SPI_MISO_MISO1));
OBUF  SPI_WN_PIN         (.I(1'b1),                  .O(SPI_Wn_MISO2));
OBUF  SPI_HOLD_PIN       (.I(1'b1),                  .O(SPI_HOLDn_MISO3));

//----------------------------------------------
// User DIP Switch x4
//----------------------------------------------
IBUF  SW3_PIN            (.O(omsp_switch[3]),        .I(GPIO_DIP4));
IBUF  SW2_PIN            (.O(omsp_switch[2]),        .I(GPIO_DIP3));
IBUF  SW1_PIN            (.O(omsp_switch[1]),        .I(GPIO_DIP2));
IBUF  SW0_PIN            (.O(omsp_switch[0]),        .I(GPIO_DIP1));

//----------------------------------------------
// User LEDs
//----------------------------------------------
/*
reg[19:0] led_cnt;
always @ (posedge dco_clk or posedge dco_rst)
    if (dco_rst)       led_cnt <=  10'h000;
    else               led_cnt <=  led_cnt + 10'h001;
*/    

OBUF  LED3_PIN           (.I(omsp1_led[1]),          .O(GPIO_LED4));
//OBUF  LED3_PIN           (.I(led_cnt[19]),          .O(GPIO_LED4));
OBUF  LED2_PIN           (.I(omsp1_led[0]),          .O(GPIO_LED3));
OBUF  LED1_PIN           (.I(omsp0_led[1]),          .O(GPIO_LED2));
OBUF  LED0_PIN           (.I(omsp0_led[0]),          .O(GPIO_LED1));

//----------------------------------------------
// Silicon Labs CP2102 USB-to-UART Bridge Chip
//----------------------------------------------
IBUF  UART_RXD_PIN       (.O(omsp0_uart_rxd),        .I(USB_RS232_RXD));
OBUF  UART_TXD_PIN       (.I(omsp0_uart_txd),        .O(USB_RS232_TXD));

assign omsp_dbg_i2c_sda_out = omsp0_dbg_i2c_sda_out & omsp1_dbg_i2c_sda_out;
//----------------------------------------------
// Texas Instruments CDCE913 programming port
//----------------------------------------------
//IOBUF SCL_PIN            (.T(1'b0), .I(1'b1), .O(),  .IO(SCL));
IBUF  SCL_PIN       (  .O(SCL),     .I (omsp_dbg_i2c_scl));
IOBUF SDA_PIN            (.T(omsp_dbg_i2c_sda_out), .I(1'b0), .O(omsp_dbg_i2c_sda_in),  .IO(SDA));



//----------------------------------------------
// Peripheral Modules (PMODs) and GPIO
//     https://www.digilentinc.com/PMODs
//----------------------------------------------



// Connector J5
/*
IOBUF PMOD1_P1_PIN       (.T(1'b0),                  .I(1'b0), .O(),                     .IO(PMOD1_P1));
IOBUF PMOD1_P2_PIN       (.T(1'b0),                  .I(1'b0), .O(),                     .IO(PMOD1_P2));
IOBUF PMOD1_P3_PIN       (.T(omsp_dbg_i2c_sda_out),  .I(1'b0), .O(omsp_dbg_i2c_sda_in),  .IO(PMOD1_P3));
IBUF  PMOD1_P4_PIN       (                                     .O(omsp_dbg_i2c_scl),     .I (PMOD1_P4));
IOBUF PMOD1_P7_PIN       (.T(1'b0),                  .I(1'b0), .O(),                     .IO(PMOD1_P7));
IBUF  PMOD1_P8_PIN       (                                     .O(),                     .I (PMOD1_P8));
IOBUF PMOD1_P9_PIN       (.T(1'b0),                  .I(1'b0), .O(),                     .IO(PMOD1_P9));
IOBUF PMOD1_P10_PIN      (.T(1'b0),                  .I(1'b0), .O(),                     .IO(PMOD1_P10));
*/



//=============================================================================
//8)  CHIPSCOPE
//=============================================================================
//`define WITH_CHIPSCOPE
`ifdef WITH_CHIPSCOPE

// Sampling clock
reg [7:0] div_cnt;
always @ (posedge dco_clk or posedge dco_rst)
  if (dco_rst)           div_cnt <=  8'h00;
  else if (div_cnt > 10) div_cnt <=  8'h00;
  else                   div_cnt <=  div_cnt+8'h01;

reg clk_sample;
always @ (posedge dco_clk or posedge dco_rst)
  if (dco_rst) clk_sample <=  1'b0;
  else         clk_sample <=  (div_cnt==8'h00);


// ChipScope instance
wire        [35:0] chipscope_control;
chipscope_ila chipscope_ila (
    .CONTROL  (chipscope_control),
    .CLK      (clk_sample),
    .TRIG0    (chipscope_trigger)
);

chipscope_icon chipscope_icon (
    .CONTROL0 (chipscope_control)
);


assign chipscope_trigger[0]     = 1'b0;
assign chipscope_trigger[1]     = 1'b0;
assign chipscope_trigger[2]     = 1'b0;
assign chipscope_trigger[23:3]  = 21'h00_0000;
`endif

endmodule // openMSP430_fpga
