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

DESIGN=cbcmac_des
TESTBENCH=tb_${DESIGN}
DES=../../../des/rtl/vhdl


all : sim wave

sim : ${TESTBENCH}.ghw


tb_cbcmac_des.ghw : ${DES}/*.vhd ../../rtl/vhdl/${DESIGN}.vhd ${TESTBENCH}.vhd
	ghdl -a ${DES}/des_pkg.vhd ${DES}/des.vhd ../../rtl/vhdl/${DESIGN}.vhd ${TESTBENCH}.vhd
	ghdl -e ${TESTBENCH}
	ghdl -r ${TESTBENCH} --wave=${TESTBENCH}.ghw --assert-level=error --stop-time=2us

wave : ${TESTBENCH}.ghw
	gtkwave -S ${TESTBENCH}.tcl ${TESTBENCH}.ghw

clean :
	echo "# cleaning simulation files"
	rm -f *.o
	rm -f ${TESTBENCH}.ghw
	rm -f ${TESTBENCH}
	rm -f work*.cf
