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


module tb_des;


  initial begin
     $dumpfile ("tb_des.vcd");
     $dumpvars (0, tb_des);
  end


  reg reset = 0;

  initial begin
    #20 reset = 1;
    #1000 $finish;
  end

  reg clk = 0;
  always #5 clk = !clk;

  reg mode;
  reg [0:63] key;
  reg [0:63] datain;
  reg validin;

  always @(posedge clk, reset) begin
    if(~reset) begin
      mode    <= 0;
      validin <= 0;
      key     <= 0;
      datain  <= 0;
    end
    else begin
      mode    <= 1;
      validin <= 1;
      key     <= key + 1;
      datain  <= datain + 1;
    end
  end

  wire [0:63] dataout;
  wire validout;

  des i_des (
    .reset_i(reset),
    .clk_i(clk),
    .mode_i(mode),
    .key_i(key),
    .data_i(datain),
    .valid_i(validin),
    .data_o(dataout),
    .valid_o(validout)
  );


endmodule
