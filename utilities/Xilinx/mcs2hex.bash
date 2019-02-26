#!/bin/sh
# only edit the filename and promgen location
FNAME=GD_Fallback
PGENLOC=/e/Xilinx/14.6/ISE_DS/ISE/bin/nt64



$PGENLOC/promgen.exe -w -p hex -r $FNAME.mcs -o $FNAME.hex

