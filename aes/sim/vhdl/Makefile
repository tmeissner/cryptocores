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

SIM_SRC   := tb_aes.vhd
C_SRC     := tb_aes.c
OSVVM_SRC := ../../../lib/osvvm
VHD_STD   := 08


.PHONY: sim
sim: tb_aes.ghw


.PHONY: compile
compile: tb_aes


osvvm work:
	mkdir $@


osvvm/OsvvmContext.o: $(OSVVM_SRC)/*.vhd | osvvm
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/NamePkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/OsvvmGlobalPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/VendorCovApiPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/TranscriptPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/TextUtilPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/AlertLogPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/MessagePkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/SortListPkg_int.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/RandomBasePkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/RandomPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/CoveragePkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/MemoryPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/ScoreboardGenericPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/ScoreboardPkg_slv.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/ScoreboardPkg_int.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/ResolutionPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/TbUtilPkg.vhd
	ghdl -a --std=$(VHD_STD) -Wno-hide --work=osvvm --workdir=osvvm $(OSVVM_SRC)/OsvvmContext.vhd


tb_aes: ${RTL_SRC} ${SIM_SRC} ${C_SRC} osvvm/OsvvmContext.o | work
	ghdl -a --std=$(VHD_STD) -fpsl --workdir=work -P=osvvm ${RTL_SRC} ${SIM_SRC}
	ghdl -e --std=$(VHD_STD) -fpsl --workdir=work -P=osvvm -Wl,-lcrypto -Wl,-lssl -Wl,tb_aes.c $@


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
	rm -rf osvvm/

