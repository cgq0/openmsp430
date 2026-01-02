//----------------------------------------------------------------------------
// Copyright (C) 2001 Authors
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
// *File Name: tb_openMSP430_fpga.v
//
// *Module Description:
//                      openMSP430 FPGA testbench
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 111 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2011-05-20 22:39:02 +0200 (Fri, 20 May 2011) $
//----------------------------------------------------------------------------
`include "timescale.v"
`ifdef OMSP_NO_INCLUDE
`else
`include "openMSP430_defines.v"
`endif

module  tb_openMSP430_fpga;

//
// Wire & Register definition
//------------------------------

// Clock & Reset
reg               CLK_90MHz;
reg               CLK_66MHz;
reg               CLK_100MHz;
reg               USER_RESET;

// Slide Switches
reg               SW4;
reg               SW3;
reg               SW2;
reg               SW1;

// LEDs
wire              LED4;
wire              LED3;
wire              LED2;
wire              LED1;

// UART
reg               UART_RXD;
wire              UART_TXD;

// UART
wire 	          PMOD1_P1;
reg               PMOD1_P4;

// Core debug signals
wire   [8*32-1:0] omsp0_i_state;
wire   [8*32-1:0] omsp0_e_state;
wire       [31:0] omsp0_inst_cycle;
wire   [8*32-1:0] omsp0_inst_full;
wire       [31:0] omsp0_inst_number;
wire       [15:0] omsp0_inst_pc;
wire   [8*32-1:0] omsp0_inst_short;

wire   [8*32-1:0] omsp1_i_state;
wire   [8*32-1:0] omsp1_e_state;
wire       [31:0] omsp1_inst_cycle;
wire   [8*32-1:0] omsp1_inst_full;
wire       [31:0] omsp1_inst_number;
wire       [15:0] omsp1_inst_pc;
wire   [8*32-1:0] omsp1_inst_short;

// Testbench variables
integer           i;
integer           error;
reg               stimulus_done;


//
// Include files
//------------------------------

// CPU & Memory registers
`include "registers_omsp0.v"
`include "registers_omsp1.v"

// Verilog stimulus
`include "stimulus.v"

//
// Initialize Program Memory
//------------------------------

initial
   begin
      // Read memory file
      #10 $readmemh("./pmem.mem", pmem);

      // Update Xilinx memory banks
      for (i=0; i<8192; i=i+1)
	begin
	   dut.ram_16x8k_dp_pmem_shared.ram_dp_inst.mem[i] = pmem[i];
	end
  end

//
// Generate Clock & Reset
//------------------------------
initial
  begin
     CLK_90MHz = 1'b0;
     forever #5.5 CLK_90MHz <= ~CLK_90MHz; // 90 MHz
  end

initial
  begin
     CLK_66MHz = 1'b0;
     forever #7.57 CLK_66MHz <= ~CLK_66MHz;   // 66 MHz
  end

initial
  begin
     CLK_100MHz = 1'b0;
     forever #5 CLK_100MHz <= ~CLK_100MHz;  // 100 MHz
  end

initial
  begin
     USER_RESET         = 1'b0;
     #100 USER_RESET    = 1'b1;
     #600 USER_RESET    = 1'b0;
  end

//
// Global initialization
//------------------------------
initial
  begin
     error         = 0;
     stimulus_done = 1;
     SW4           = 1'b0;  // Slide Switches
     SW3           = 1'b0;
     SW2           = 1'b0;
     SW1           = 1'b0;
     UART_RXD      = 1'b1;  // UART
     PMOD1_P4      = 1'b1;
  end

//
// openMSP430 FPGA Instance
//----------------------------------

openMSP430_fpga dut (

     //----------------------------------------------
     // User Reset Push Button
     //----------------------------------------------
     .USER_RESET      (USER_RESET),

     //----------------------------------------------
     // Micron N25Q128 SPI Flash
     //   This is a Multi-I/O Flash.  Several pins
     //  have dual purposes depending on the mode.
     //----------------------------------------------
     //.SPI_SCK         (),
     .SPI_CS_n        (),
     .SPI_MOSI_MISO0  (),
     .SPI_MISO_MISO1  (),
     .SPI_Wn_MISO2    (),
     .SPI_HOLDn_MISO3 (),

     //----------------------------------------------
     // TI CDCE913 Triple-Output PLL Clock Chip
     //   Y1: 40 MHz, USER_CLOCK can be used as
     //              external configuration clock
     //   Y2: 66.667 MHz
     //   Y3: 100 MHz
     //----------------------------------------------
     .USER_CLOCK      (CLK_90MHz),
    

     //----------------------------------------------
     // The following oscillator is not populated
     // in production but the footprint is compatible
     // with the Maxim DS1088LU
     //----------------------------------------------
   

     //----------------------------------------------
     // User DIP Switch x4
     //----------------------------------------------
     .GPIO_DIP1       (SW1),
     .GPIO_DIP2       (SW2),
     .GPIO_DIP3       (SW3),
     .GPIO_DIP4       (SW4),

     //----------------------------------------------
     // User LEDs
     //----------------------------------------------
     .GPIO_LED1       (LED1),
     .GPIO_LED2       (LED2),
     .GPIO_LED3       (LED3),
     .GPIO_LED4       (LED4),

     //----------------------------------------------
     // Silicon Labs CP2102 USB-to-UART Bridge Chip
     //----------------------------------------------
     .USB_RS232_RXD   (UART_RXD),
     .USB_RS232_TXD   (UART_TXD),

     //----------------------------------------------
     // Texas Instruments CDCE913 programming port
     //----------------------------------------------
     .SCL             (),
     .SDA             ()

     //----------------------------------------------
     // Micron MT46H32M16LFBF-5 LPDDR
     //----------------------------------------------

     

     //----------------------------------------------
     // Peripheral Modules (PMODs) and GPIO
     //     https://www.digilentinc.com/PMODs
     //----------------------------------------------

     
);


// Debug utility signals
//----------------------------------------
msp_debug msp_debug_omsp0 (

// OUTPUTs
    .e_state      (omsp0_e_state),       // Execution state
    .i_state      (omsp0_i_state),       // Instruction fetch state
    .inst_cycle   (omsp0_inst_cycle),    // Cycle number within current instruction
    .inst_full    (omsp0_inst_full),     // Currently executed instruction (full version)
    .inst_number  (omsp0_inst_number),   // Instruction number since last system reset
    .inst_pc      (omsp0_inst_pc),       // Instruction Program counter
    .inst_short   (omsp0_inst_short),    // Currently executed instruction (short version)

// INPUTs
    .core_select  (1'b0)                 // Core selection
);

msp_debug msp_debug_omsp1 (

// OUTPUTs
    .e_state      (omsp1_e_state),       // Execution state
    .i_state      (omsp1_i_state),       // Instruction fetch state
    .inst_cycle   (omsp1_inst_cycle),    // Cycle number within current instruction
    .inst_full    (omsp1_inst_full),     // Currently executed instruction (full version)
    .inst_number  (omsp1_inst_number),   // Instruction number since last system reset
    .inst_pc      (omsp1_inst_pc),       // Instruction Program counter
    .inst_short   (omsp1_inst_short),    // Currently executed instruction (short version)

// INPUTs
    .core_select  (1'b1)                 // Core selection
);

//
// Generate Waveform
//----------------------------------------
initial
  begin
   `ifdef VPD_FILE
     $vcdplusfile("tb_openMSP430_fpga.vpd");
     $vcdpluson();
   `else
     `ifdef TRN_FILE
        $recordfile ("tb_openMSP430_fpga.trn");
        $recordvars;
     `else
        $dumpfile("tb_openMSP430_fpga.vcd");
        $dumpvars(0, tb_openMSP430_fpga);
     `endif
   `endif
  end

//
// End of simulation
//----------------------------------------

initial // Timeout
  begin
     #500000;
     $display(" ===============================================");
     $display("|               SIMULATION FAILED               |");
     $display("|              (simulation Timeout)             |");
     $display(" ===============================================");
     $finish;
  end

initial // Normal end of test
  begin
     @(omsp0_inst_pc===16'hffff)
     $display(" ===============================================");
     if (error!=0)
       begin
	  $display("|               SIMULATION FAILED               |");
	  $display("|     (some verilog stimulus checks failed)     |");
       end
     else if (~stimulus_done)
       begin
	  $display("|               SIMULATION FAILED               |");
	  $display("|     (the verilog stimulus didn't complete)    |");
       end
     else
       begin
	  $display("|               SIMULATION PASSED               |");
       end
     $display(" ===============================================");
     $finish;
  end


//
// Tasks Definition
//------------------------------

   task tb_error;
      input [65*8:0] error_string;
      begin
	 $display("ERROR: %s %t", error_string, $time);
	 error = error+1;
      end
   endtask


endmodule
