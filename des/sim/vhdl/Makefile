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


TB := tb_des

RTL_SRC := \
  ../../rtl/vhdl/des_pkg.vhd \
  ../../rtl/vhdl/des.vhd


SIM_SRC   := ${TB}_pkg.vhd ${TB}.vhd
C_SRC     := ${TB}.c

OSVVM_DIR := ../../../lib/osvvm
OSVVM_SRC := \
  ${OSVVM_DIR}/NamePkg.vhd  \
  ${OSVVM_DIR}/OsvvmGlobalPkg.vhd  \
  ${OSVVM_DIR}/VendorCovApiPkg.vhd  \
  ${OSVVM_DIR}/TranscriptPkg.vhd  \
  ${OSVVM_DIR}/TextUtilPkg.vhd  \
  ${OSVVM_DIR}/AlertLogPkg.vhd  \
  ${OSVVM_DIR}/MessagePkg.vhd  \
  ${OSVVM_DIR}/SortListPkg_int.vhd  \
  ${OSVVM_DIR}/RandomBasePkg.vhd  \
  ${OSVVM_DIR}/RandomPkg.vhd  \
  ${OSVVM_DIR}/CoveragePkg.vhd  \
  ${OSVVM_DIR}/MemoryPkg.vhd  \
  ${OSVVM_DIR}/ScoreboardGenericPkg.vhd  \
  ${OSVVM_DIR}/ScoreboardPkg_slv.vhd  \
  ${OSVVM_DIR}/ScoreboardPkg_int.vhd  \
  ${OSVVM_DIR}/ResolutionPkg.vhd  \
  ${OSVVM_DIR}/TbUtilPkg.vhd  \
  ${OSVVM_DIR}/OsvvmContext.vhd

VHD_STD := 08


.PHONY: sim
sim: ${TB}.ghw


.PHONY: compile
compile: ${TB}


osvvm work:
	mkdir $@


osvvm/OsvvmContext.o: ${OSVVM_SRC} | osvvm
	@echo "Analyze OSVVM library ..."
	ghdl -a --std=${VHD_STD} -Wno-hide --work=osvvm --workdir=osvvm ${OSVVM_SRC}


${TB}: ${RTL_SRC} ${SIM_SRC} ${C_SRC} osvvm/OsvvmContext.o | work
	@echo "Analyze testbench & design ..."
	ghdl -a --std=${VHD_STD} -fpsl --workdir=work -P=osvvm ${RTL_SRC} ${SIM_SRC}
	@echo "Elaborate testbench & design ..."
	ghdl -e --std=${VHD_STD} -fpsl --workdir=work -P=osvvm -Wl,$@.c -Wl,-lcrypto -Wl,-lssl $@


${TB}.ghw: ${TB}
	@echo "Run testbench ..."
	ghdl -r $(basename $@) --wave=$@ --assert-level=error --psl-report=$(basename $@)_psl_report.json


.PHONY: wave
wave: ${TB}.ghw
	@echo "Run GTKwave ..."
	gtkwave -S ${TB}.tcl $@


.PHONY: clean
clean:
	@echo "Cleaning simulation files ..."
	rm -rf ${TB} ${TB}.ghw *.o *.json work/ osvvm/
