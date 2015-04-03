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


SRC_FILES = tb_cbcmac_des.v ../../rtl/verilog/cbcmac_des.v ../../../des/rtl/verilog/des.v
SIM_FILES = data_input.txt data_output.txt

.PHONY: all
all : sim wave

.PHONY: sim
sim : tb_cbcmac_des.vcd

tb_cbcmac_des.vcd : $(SRC_FILES) $(SIM_FILES)
	iverilog -Wall -s tb_cbcmac_des -o tb_cbcmac_des $(SRC_FILES)
	vvp tb_cbcmac_des

.PHONY: wave
wave : tb_cbcmac_des.vcd
	gtkwave -S tb_cbcmac_des.tcl tb_cbcmac_des.vcd &

.PHONY: clean
clean :
	echo "# cleaning simulation files"
	rm -f tb_cbcmac_des
	rm -f tb_cbcmac_des.vcd
