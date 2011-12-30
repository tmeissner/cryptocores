# ======================================================================
# AES encryption/decryption
# algorithm according to FIPS 197 specification
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


# Revision 0.1  2011/10/22
# Initial release


all : sim wave

sim : tb_aes.ghw

tb_aes.ghw : ../rtl/*.vhd tb_aes.vhd
	ghdl -a ../rtl/aes_pkg.vhd ../rtl/aes.vhd tb_aes.vhd
	ghdl -e tb_aes
	ghdl -r tb_aes --wave=tb_aes.ghw --assert-level=error --stop-time=10us
	
wave : tb_aes.ghw
	gtkwave -T tb_aes.tcl tb_aes.ghw
	
clean :
	echo "# cleaning simulation files"
	rm -f tb_aes.ghw
	rm -f work*.cf
