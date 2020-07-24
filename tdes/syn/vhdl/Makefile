# ======================================================================
# TDES encryption/decryption
# algorithm according to FIPS 46-3 specification
# Copyright (C) 2020 Torsten Meissner
#-----------------------------------------------------------------------
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# ======================================================================


DES_SRC_FILES  := ../../../des/rtl/vhdl/des_pkg.vhd ../../../des/rtl/vhdl/des.vhd
TDES_SRC_FILES := ../../rtl/vhdl/tdes.vhd
SRC_FILES      := $(DES_SRC_FILES) $(TDES_SRC_FILES)
VHD_STD        := 08


.PHONY: all
all : tdes_synth.vhd syn

.PHONY: syn
syn: tdes.json


tdes.o: $(SRC_FILES)
	ghdl -a --std=$(VHD_STD) $(SRC_FILES)

tdes_synth.vhd: $(SRC_FILES)
	ghdl --synth --std=$(VHD_STD) $(SRC_FILES) -e tdes > $@

tdes.json: tdes.o
	yosys -m ghdl -p 'ghdl --std=08 --no-formal tdes; synth_ice40 -json $@'


clean :
	echo "# Cleaning files"
	rm -f *.o work*.cf tdes.json tdes_synth.vhd
