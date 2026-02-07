#!/bin/bash
###############################################################################
#                                                                             #
#                       Xilinx RAM update script for LINUX                    #
#                                                                             #
###############################################################################

###############################################################################
#                            Parameter Check                                  #
###############################################################################
EXPECTED_ARGS=1
if [ $# -ne $EXPECTED_ARGS ]; then
    echo ""
    echo "ERROR          : wrong number of arguments"
    echo "USAGE          : ./3_program_fpga <prom name>"
    echo "EXAMPLE        : ./3_program_fpga    leds"
    echo ""
    echo "AVAILABLE TESTS:"
    for fullfile in ./bitstreams/*.mcs ; do
	filename=$(basename "$fullfile")
	filename="${filename%.*}"
	echo "                  - $filename"
    done
    echo ""
    exit 1
fi

###############################################################################
#                     Check if the required files exist                       #
###############################################################################
promfile=./bitstreams/$1.mcs;

if [ ! -e $promfile ]; then
    echo "Specified PROM file doesn't exist: $promfile"
    exit 1
fi

###############################################################################
#                           Update FPGA Bitstream                             #
###############################################################################

# Move to the XFLOW workspace
cd ./work

# Copy PROM & bitstream in working directory
cp -f ../bitstreams/$1.mcs .

# Program FPGA
# program_flash is a tool provided by Xilinx Vitis above 2020.1
# For older versions, please use the vivado hw_server and hw_client... etc.
program_flash -f $1.mcs -flash_type qspi-x4-single -verify

# Return to the root directory
cd ../
