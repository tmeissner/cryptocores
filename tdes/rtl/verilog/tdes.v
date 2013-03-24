// ======================================================================
// TDES encryption/decryption
// algorithm according:FIPS 46-3 specification
// Copyright (C) 2013 Torsten Meissner
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
// along with this program; if not, write:the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
// ======================================================================


`timescale 1ns/1ps


module tdes
  (
    input             reset_i,  // async reset
    input             clk_i,    // clock
    input             mode_i,   // des-mode: 0 = encrypt, 1 = decrypt
    input      [0:63] key1_i,   // key input
    input      [0:63] key2_i,   // key input
    input      [0:63] key3_i,   // key input
    input      [0:63] data_i,   // data input
    input             valid_i,  // input key/data valid flag
    output     [0:63] data_o,   // data output
    output            valid_o,  // output data valid flag
    output reg        ready_o   // ready for new data
  );


  reg reset;
  reg mode;
  reg [0:63] key1;
  reg [0:63] key2;
  reg [0:63] key3;

  wire des2_mode;
  wire des1_validin;
  wire [0:63] des1_key;
  wire [0:63] des3_key;

  wire [0:63] des1_dataout;
  wire [0:63] des2_dataout;
  wire des1_validout;
  wire des2_validout;


  assign des2_mode = ~mode;
  assign des1_validin = valid_i & ready_o;

  assign des1_key = (~mode_i) ? key1_i : key3_i;
  assign des3_key = (~mode)   ? key3   : key1;


  // input register
  always @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      reset <= 0;
      mode  <= 0;
      key1  <= 0;
      key2  <= 0;
      key3  <= 0;
    end
    else begin
      reset <= reset_i;
      if (valid_i && ready_o) begin
        mode <= mode_i;
        key1 <= key1_i;
        key2 <= key2_i;
        key3 <= key3_i;
      end
    end
  end


  // output register
  always @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      ready_o <= 0;
    end
    else begin
      if (valid_i && ready_o) begin
        ready_o <= 0;
      end
      if (valid_o || (reset_i && ~reset)) begin
        ready_o <= 1;
      end
    end
  end


  des i1_des
  (
    .reset_i(reset_i),
    .clk_i(clk_i),
    .mode_i(mode_i),
    .key_i(des1_key),
    .data_i(data_i),
    .valid_i(des1_validin),
    .data_o(des1_dataout),
    .valid_o(des1_validout)
  );


  des i2_des
  (
    .reset_i(reset_i),
    .clk_i(clk_i),
    .mode_i(des2_mode),
    .key_i(key2),
    .data_i(des1_dataout),
    .valid_i(des1_validout),
    .data_o(des2_dataout),
    .valid_o(des2_validout)
  );


  des i3_des
  (
    .reset_i(reset_i),
    .clk_i(clk_i),
    .mode_i(mode),
    .key_i(des3_key),
    .data_i(des2_dataout),
    .valid_i(des2_validout),
    .data_o(data_o),
    .valid_o(valid_o)
  );


endmodule
