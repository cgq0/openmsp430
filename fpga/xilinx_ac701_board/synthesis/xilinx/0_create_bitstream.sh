#!/bin/bash
######################################################
#                                                    #
# Vivado Synthesis, Implementation & Bitstream for   #
# Artix-7 (non-interactive batch)                    #
#                                                    #
######################################################

set -e

PROJECT=openMSP430_fpga

# Cleanup
rm -rf work
mkdir work
cd work

# Create links for RAM & ROM (原来的 ngc 文件)
#ln -s ../../../rtl/verilog/coregen/ram_16x1k_sp.ngc  || true
#ln -s ../../../rtl/verilog/coregen/ram_16x1k_dp.ngc  || true
#ln -s ../../../rtl/verilog/coregen/ram_16x8k_dp.ngc  || true

# Create links for Chipscope ngc files (注意：Vivado 推荐使用 Integrated Logic Analyzer IP)
#ln -s ../../../rtl/verilog/coregen_chipscope/chipscope_icon.ngc || true
#ln -s ../../../rtl/verilog/coregen_chipscope/chipscope_ila.ngc  || true

# Generate Vivado TCL to create project, add files and run flow.


# Run Vivado in batch mode (no GUI). 请确保 vivado 在 PATH 中或使用绝对路径。
vivado -mode batch -source ../scripts/vivado_run.tcl -nojournal -nolog

# Copy bitstream out
if [ -f "./openMSP430_fpga.bit" ] ; then
    mkdir -p ../bitstreams
    cp -f ./openMSP430_fpga.bit ../bitstreams/
    echo "Bitstream written to ../bitstreams/openMSP430_fpga.bit"
else
    echo "ERROR: bitstream not found; check Vivado output."
    exit 1
fi

cd ..
