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

sim : tb_tdes.ghw

tb_tdes.ghw : ../rtl/*.vhd tb_tdes.vhd
	ghdl -a ../rtl/des_pkg.vhd ../rtl/des.vhd ../rtl/tdes.vhd tb_tdes.vhd
	ghdl -e tb_tdes
	ghdl -r tb_tdes --wave=tb_tdes.ghw --assert-level=error --stop-time=45us
	
wave : tb_tdes.ghw
	gtkwave -T tb_tdes.tcl tb_tdes.ghw
	
clean :
	echo "# cleaning simulation files"
	rm -f *.ghw
	rm -f work*.cf
