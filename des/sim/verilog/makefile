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


SRC_FILES = ../../rtl/verilog/*.v tb_des.v
SIM_FILES = data_input.txt key_input.txt data_output.txt

.PHONY: all
all : sim_pipe sim_iter

.PHONY: sim_pipe
sim_pipe : tb_des_pipe.vcd

.PHONY: sim_iter
sim_iter : tb_des_iter.vcd

tb_des_pipe.vcd : $(SRC_FILES) $(SIM_FILES)
	iverilog -Wall -DPIPE -s tb_des -o tb_des_pipe tb_des.v ../../rtl/verilog/des.v
	vvp tb_des_pipe

tb_des_iter.vcd : $(SRC_FILES) $(SIM_FILES)
	iverilog -Wall -DITER -s tb_des -o tb_des_iter tb_des.v ../../rtl/verilog/des.v
	vvp tb_des_iter

.PHONY: wave_pipe
wave_pipe : tb_des_pipe.vcd
	gtkwave -S tb_des.tcl tb_des_pipe.vcd &

.PHONY: wave_iter
wave_iter : tb_des_iter.vcd
	gtkwave -S tb_des.tcl tb_des_iter.vcd &

.PHONY: clean
clean :
	echo "# cleaning simulation files"
	rm -f tb_des_*
	rm -f tb_des.vcd
