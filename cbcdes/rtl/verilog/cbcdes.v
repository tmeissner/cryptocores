// ======================================================================
// CBC-DES encryption/decryption
// algorithm according to FIPS 46-3 specification
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


module cbcdes
  (
    input         reset_i,  // async reset
    input         clk_i,    // clock
    input         start_i,  // start cbc
    input         mode_i,   // des-mode: 0 = encrypt, 1 = decrypt
    input  [0:63] key_i,    // key input
    input  [0:63] iv_i,     // iv input
    input  [0:63] data_i,   // data input
    input         valid_i,  // input key/data valid flag
    output reg    ready_o,  // ready to encrypt/decrypt
    output reg [0:63] data_o,       // data output
    output        valid_o   // output data valid flag
  );


  reg         mode;
  wire        des_mode;
  reg         start;
  reg  [0:63] key;
  wire [0:63] des_key;
  reg  [0:63] iv;
  reg  [0:63] datain;
  reg  [0:63] datain_d;
  reg  [0:63] des_datain;
  wire        validin;
  wire [0:63] des_dataout;
  reg         reset;
  reg  [0:63] dataout;



  assign des_key  = (start_i) ? key_i  : key;
  assign des_mode = (start_i) ? mode_i : mode;

  assign validin = valid_i & ready_o;


  always @(*) begin
    if (~mode_i && start_i) begin
      des_datain = iv_i ^ data_i;
    end
    else if (~mode && ~start_i) begin
      des_datain = dataout ^ data_i;
    end
    else begin
      des_datain = data_i;
    end
  end


  always @(*) begin
    if (mode && start) begin
      data_o = iv ^ des_dataout;
    end
    else if (mode && ~start) begin
      data_o = datain_d ^ des_dataout;
    end
    else begin
      data_o = des_dataout;
    end
  end

  // input register
  always @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      reset    <= 0;
      mode     <= 0;
      start    <= 0;
      key      <= 0;
      iv       <= 0;
      datain   <= 0;
      datain_d <= 0;
    end
    else begin
      reset <= reset_i;
      if (valid_i && ready_o) begin
        start    <= start_i;
        datain   <= data_i;
        datain_d <= datain;
      end
      else if (valid_i && ready_o && start_i) begin
        mode <= mode_i;
        key  <= key_i;
        iv   <= iv_i;
      end
    end
  end


  // output register
  always @(posedge clk_i, negedge reset_i) begin
    if (~reset_i) begin
      ready_o <= 0;
      dataout <= 0;
    end
    else begin
      if (valid_i && ready_o) begin
        ready_o <= 0;
      end
      else if (valid_o || (reset_i && ~reset)) begin
        ready_o <= 1;
        dataout <= des_dataout;
      end
    end
  end


  // des instance
  des i_des (
    .reset_i(reset),
    .clk_i(clk_i),
    .mode_i(des_mode),
    .key_i(des_key),
    .data_i(des_datain),
    .valid_i(validin),
    .data_o(des_dataout),
    .valid_o(valid_o)
  );


endmodule