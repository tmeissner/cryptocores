# ======================================================================
# DES encryption/decryption
# algorithm according to FIPS 46-3 specification
# Copyright (C) 2011 Torsten Meissner
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

sim : tb_des.ghw


tb_des.ghw : ../../rtl/vhdl/*.vhd tb_des.vhd
	ghdl -a ../../rtl/vhdl/des_pkg.vhd ../../rtl/vhdl/des.vhd tb_des.vhd
	ghdl -e tb_des
	ghdl -r tb_des --wave=tb_des.ghw --assert-level=error --stop-time=11us

wave : tb_des.ghw
	gtkwave -S tb_des.tcl tb_des.ghw
	
clean :
	echo "# cleaning simulation files"
	rm -f tb_des.ghw
	rm -f work*.cf
