# ======================================================================
# AES encryption/decryption
# Copyright (C) 2019 Torsten Meissner
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


RTL_SRC := \
  ../../rtl/vhdl/aes_pkg.vhd \
  ../../rtl/vhdl/aes.vhd     \
  ../../rtl/vhdl/aes_enc.vhd \
  ../../rtl/vhdl/aes_dec.vhd

SIM_SRC := \
  tb_aes.vhd


.PHONY: sim
sim: tb_aes.ghw


.PHONY: compile
compile: tb_aes


work:
	mkdir work


tb_aes: ${RTL_SRC} ${SIM_SRC} | work
	ghdl -a --std=08 -fpsl --workdir=work ${RTL_SRC} ${SIM_SRC}
	ghdl -e --std=08 -fpsl --workdir=work $@


tb_aes.ghw: tb_aes
	ghdl -r tb_aes --wave=$@ --assert-level=error \
	  --psl-report=$(basename $@)_psl_coverage_report.json


.PHONY: wave
wave: tb_aes.ghw
	gtkwave -S tb_aes.tcl tb_aes.ghw


.PHONY: clean
clean:
	echo "# cleaning simulation files"
	rm -f tb_aes
	rm -f tb_aes.ghw
	rm -f *.o
	rm -f *.json
	rm -rf work/

