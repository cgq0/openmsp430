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
    echo "USAGE          : ./2_generate_prom_file.sh <bitstream name>"
    echo "EXAMPLE        : ./2_generate_prom_file.sh     leds"
    echo ""
    echo "AVAILABLE TESTS:"
    for fullfile in ./bitstreams/*.bit ; do
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
bitstreamfile=./bitstreams/$1.bit;

if [ ! -e $bitstreamfile ]; then
    echo "Specified bitstream file doesn't exist: $bitstreamfile"
    exit 1
fi

###############################################################################
#                           Update FPGA Bitstream                             #
###############################################################################

# Move to the XFLOW workspace
cd ./work

# Copy bitstream in working directory
cp -f ../bitstreams/$1.bit .
# Part number:"N25Q256A13ESF40G"
# Supply voltage: 3.3V
echo "write_cfgmem -format mcs -interface spix4 -size 32 -loadbit \"up 0x0 $1.bit\" -file $1.mcs" > ./generate_prom_file.tcl
# Create PROM image
vivado -mode batch -source ./generate_prom_file.tcl -nojournal -nolog

# Copy new PROM image in the proper directory
cp -f ./$1.mcs ../bitstreams

# Return to the root directory
cd ../

