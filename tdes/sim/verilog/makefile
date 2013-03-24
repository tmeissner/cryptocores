# ======================================================================
# TDES encryption/decryption
# algorithm according to FIPS 46-3 specification
# Copyright (C) 2012 Torsten Meissner
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


SRC_FILES = tb_tdes.v ../../rtl/verilog/tdes.v ../../rtl/verilog/des.v
SIM_FILES = test_data.txt


all : sim wave

sim : tb_tdes.vcd


tb_tdes.vcd : $(SRC_FILES) $(SIM_FILES)
	iverilog -Wall -s tb_tdes -o tb_tdes $(SRC_FILES)
	vvp tb_tdes

wave : tb_tdes.vcd
	gtkwave -T tb_tdes.tcl tb_tdes.vcd
	
clean :
	echo "# cleaning simulation files"
	rm -f tb_tdes
	rm -f tb_tdes.vcd
