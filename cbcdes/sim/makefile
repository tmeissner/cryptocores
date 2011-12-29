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


# Revision 1.0  2011/09/23
# Initial release


all : sim wave

sim : tb_cbcdes.ghw

tb_cbcdes.ghw : ../rtl/*.vhd tb_cbcdes.vhd
	ghdl -a ../rtl/des_pkg.vhd ../rtl/des.vhd ../rtl/cbcdes.vhd tb_cbcdes.vhd
	ghdl -e tb_cbcdes
	ghdl -r tb_cbcdes --wave=tb_cbcdes.ghw --assert-level=error --stop-time=220us
	
wave : tb_cbcdes.ghw
	gtkwave -T tb_cbcdes.tcl tb_cbcdes.ghw
	
clean :
	echo "# cleaning simulation files"
	rm -f *.ghw
	rm -f work*.cf
