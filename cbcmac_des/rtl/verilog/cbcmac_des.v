// ======================================================================
// CBC-MAC-DES
// Copyright (C) 2015 Torsten Meissner
//-----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
// ======================================================================


`timescale 1ns/1ps


module cbcmac_des (
  input         reset_i,
  input         clk_i,
  input         start_i,
  input  [0:63] key_i,
  input  [0:63] data_i,
  input         valid_i,
  output        accept_o,
  output [0:63] data_o,
  output        valid_o,
  input         accept_i
);

  // CBCMAC must have fix IV for security reasons
  reg  [0:63] iv = 0;

  reg  [0:63] key;
  wire [0:63] des_key;
  wire [0:63] des_datain;
  reg  [0:63] des_dataout_d;


  assign des_datain = start_i ? iv ^ data_i : des_dataout_d ^ data_i;
  assign des_key    = start_i ? key_i : key;


  // input register
  always @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      key <= 0;
    end
    else begin
      if (valid_i && accept_o && start_i) begin
        key <= key_i;
      end
    end
  end


  // output register
  always @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      des_dataout_d <= 0;
    end
    else begin
      if (valid_o) begin
        des_dataout_d <= data_o;
      end
    end
  end


  // des instance
  des i_des (
    .reset_i(reset_i),
    .clk_i(clk_i),
    .mode_i(1'b0),
    .key_i(des_key),
    .data_i(des_datain),
    .valid_i(valid_i),
    .data_o(data_o),
    .valid_o(valid_o)
  );


endmodule