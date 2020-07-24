# ======================================================================
# DES encryption/decryption
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


SRC_FILES := ../../rtl/vhdl/des_pkg.vhd ../../rtl/vhdl/des.vhd
VHD_STD   := 08


.PHONY: all
all: des_synth.vhd syn

.PHONY: syn
syn: des.json


des.o: $(SRC_FILES)
	ghdl -a --std=$(VHD_STD) $(SRC_FILES)

des_synth.vhd: $(SRC_FILES)
	ghdl --synth --std=$(VHD_STD) $(SRC_FILES) -e des > $@

des.json: des.o
	yosys -m ghdl -p 'ghdl --std=08 --no-formal des; synth_ice40 -json $@'


clean :
	echo "# Cleaning files"
	rm -f *.o work*.cf des.json des_synth.vhd
