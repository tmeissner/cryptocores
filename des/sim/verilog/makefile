# ======================================================================
# DES encryption/decryption
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


all : sim wave

sim : tb_des.vcd


tb_des.vcd : ../../rtl/verilog/*.v tb_des.v
	iverilog -Wall -s tb_des -o tb_des tb_des.v ../../rtl/verilog/des.v
	vvp tb_des

wave : tb_des.vcd
	gtkwave -T tb_des.tcl tb_des.vcd
	
clean :
	echo "# cleaning simulation files"
	rm -f tb_des
	rm -f tb_des.vcd
