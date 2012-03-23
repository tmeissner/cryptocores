// ======================================================================
// DES encryption/decryption
// algorithm according to FIPS 46-3 specification
// Copyright (C) 2007 Torsten Meissner
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



module des
  (
    input         reset_i,  // async reset
    input         clk_i,    // clock
    input         mode_i,   // des-mode: 0 = encrypt, 1 = decrypt
    input  [0:63] key_i,    // key input
    input  [0:63] data_i,   // data input
    input         valid_i,  // input key/data valid flag
    output [0:63] data_o,   // data output
    output        valid_o   // output data valid flag
  );


`include "des_pkg.v"

  reg [0:17] valid;
  reg [0:16] mode;


  wire valid_o = valid[17];

  always @(posedge clk_i, negedge reset_i) begin
    if(~reset_i) begin
      valid <= 0;
    end
    else begin
      // shift registers
      valid[1:17] <= valid[0:16];
      valid[0]    <= valid_i;
      mode[1:16]  <= mode[0:15];
      mode[0]     <= mode_i;
    end
  end




endmodule
