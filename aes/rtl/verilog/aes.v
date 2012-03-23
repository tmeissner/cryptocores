// ======================================================================
// AES encryption/decryption
// algorithm according to FIPS 197 specification
// Copyright (C) 2012 Torsten Meissner
//-----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
// ======================================================================


module aes
  #(
    parameter ovl_enable = 0
  )
  (
    input          reset_i,  // async reset
    input          clk_i,    // clock
    input          mode_i,   // aes-modus: 0 = encrypt, 1 = decrypt
    input  [0:127] key_i,    // key input
    input  [0:127] data_i,   // data input
    input          valid_i,  // input key/data valid flag
    output [0:127] data_o,   // data output
    output         valid_o   // output data valid flag
  );


`include aes_pkg.v;


endmodule
