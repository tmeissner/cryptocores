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


DESIGN_NAME := cbcdes
SRC_FILES   := ../../../des/rtl/vhdl/des_pkg.vhd \
               ../../../des/rtl/vhdl/des.vhd \
               ../../rtl/vhdl/$(DESIGN_NAME).vhd
VHD_STD     := 08


.PHONY: sim
sim : tb_$(DESIGN_NAME).ghw

.PHONY: all
all : wave


tb_$(DESIGN_NAME).o: $(SRC_FILES) tb_$(DESIGN_NAME).vhd
	ghdl -a --std=$(VHD_STD) $(SRC_FILES) tb_$(DESIGN_NAME).vhd

tb_$(DESIGN_NAME).ghw : tb_$(DESIGN_NAME).o
	ghdl -e --std=$(VHD_STD) tb_$(DESIGN_NAME)
	ghdl -r tb_$(DESIGN_NAME) --wave=tb_$(DESIGN_NAME).ghw --assert-level=error

wave : tb_$(DESIGN_NAME).ghw
	gtkwave -S tb_$(DESIGN_NAME).tcl tb_$(DESIGN_NAME).ghw


clean :
	echo "# Cleaning files"
	rm -f *.ghw *.o tb_$(DESIGN_NAME) work*.cf
