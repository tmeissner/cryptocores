# ======================================================================
# CBC-TDES encryption/decryption
# algorithm according to FIPS 46-3 specification
# Copyright (C) 2020 Torsten Meissner
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


DESIGN_NAME := cbctdes
SRC_FILES   := ../../../des/rtl/vhdl/des_pkg.vhd \
               ../../../des/rtl/vhdl/des.vhd \
               ../../../tdes/rtl/vhdl/tdes.vhd \
               ../../rtl/vhdl/$(DESIGN_NAME).vhd
VHD_STD     := 08


.PHONY: all
all : $(DESIGN_NAME)_synth.vhd syn

.PHONY: syn
syn: $(DESIGN_NAME).json


$(DESIGN_NAME).o: $(SRC_FILES)
	ghdl -a --std=$(VHD_STD) $(SRC_FILES)

$(DESIGN_NAME)_synth.vhd: $(SRC_FILES)
	ghdl --synth --std=$(VHD_STD) $(SRC_FILES) -e $(DESIGN_NAME) > $@

$(DESIGN_NAME).json: $(DESIGN_NAME).o
	yosys -m ghdl -p 'ghdl --std=$(VHD_STD) --no-formal $(DESIGN_NAME); synth_ice40 -json $@'


clean :
	echo "# Cleaning files"
	rm -f *.o work*.cf $(DESIGN_NAME).json $(DESIGN_NAME)_synth.vhd
