// ======================================================================
// DES encryption/decryption testbench
// tests according to NIST 800-17 special publication
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

`timescale 1ns/1ps



module tb_cbcdes;


  // set dumpfile
  initial begin
     $dumpfile ("tb_cbcdes.vcd");
     $dumpvars (0, tb_cbcdes);
  end


  reg reset;
  reg clk = 0;
  reg mode;
  reg [0:63] key;
  reg [0:63] datain;
  reg validin;
  reg start;
  reg [0:63] iv;
  wire [0:63] dataout;
  wire validout;
  wire readyout;


  // setup simulation
  initial begin
    reset = 1;
    #1  reset = 0;
    #20 reset = 1;
  end


  // generate clock with 100 mhz
  always #5 clk = !clk;


  // dut
  cbcdes i_cbcdes (
    .reset_i(reset),
    .clk_i(clk),
    .start_i(start),
    .mode_i(mode),
    .key_i(key),
    .iv_i(iv),
    .data_i(datain),
    .valid_i(validin),
    .ready_o(readyout),
    .data_o(dataout),
    .valid_o(validout)
  );


endmodule
