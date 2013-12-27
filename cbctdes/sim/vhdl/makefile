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

sim : tb_cbctdes.ghw

tb_cbctdes.ghw : ../../rtl/vhdl/*.vhd tb_cbctdes.vhd
	ghdl -a ../../rtl/vhdl/des_pkg.vhd ../../rtl/vhdl/des.vhd ../../rtl/vhdl/tdes.vhd ../../rtl/vhdl/cbctdes.vhd tb_cbctdes.vhd 
	ghdl -e tb_cbctdes
	ghdl -r tb_cbctdes --wave=tb_cbctdes.ghw --assert-level=error --stop-time=45us
	
wave : tb_cbctdes.ghw
	gtkwave -T tb_cbctdes.tcl tb_cbctdes.ghw
	
clean :
	echo "# cleaning simulation files"
	rm -f *.ghw
	rm -f work*.cf
