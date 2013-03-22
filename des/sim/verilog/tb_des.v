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


module tb_des;

  // set dumpfile
  initial begin
     $dumpfile ("tb_des.vcd");
     $dumpvars (0, tb_des);
  end

  reg reset;
  reg clk = 0;
  reg mode;
  reg [0:63] key;
  reg [0:63] datain;
  reg validin;
  integer index;
  integer outdex;
  integer errors;
  wire [0:63] dataout;
  wire validout;

  reg [0:63] data_input  [0:127];
  reg [0:63] key_input   [0:127];
  reg [0:63] data_output [0:127];

  // read in test data files
  initial begin
    $readmemh("data_input.txt",  data_input);
    $readmemh("key_input.txt",   key_input);
    $readmemh("data_output.txt", data_output);
  end

  // setup simulation
  initial begin
    reset = 1;
    #1  reset = 0;
    #20 reset = 1;
    #2000 $finish;
  end

  // generate clock with 100 mhz
  always #5 clk = !clk;

  // init the register values
  initial
    forever @(negedge reset) begin
      disable stimuli;
      disable checker;
      mode    <= 0;
      validin <= 0;
      key     <= 0;
      datain  <= 0;
      errors  =  0;
    end

   // stimuli generator process
  always begin : stimuli
    wait (reset)
    @(posedge clk)
      // Variable plaintext known answer test
      for(index = 0; index < 128; index = index + 1)
      begin
        @(posedge clk)
          mode    <= 0;
          validin <= 1;
          datain  <= data_input[index];
          key     <= key_input[index];
      end
      validin <= 0;
  end

  // checker process
  always begin : checker
    wait (reset)
    // Variable plaintext known answer test
    wait (validout)
    for(outdex = 0; outdex < 128; outdex = outdex + 1)
    begin
      @(posedge clk)
      // detected an error -> print error message
      if (dataout != data_output[outdex]) begin
        $display ("error, output was %h - should have been %h", dataout, data_output[outdex]);
        errors = errors + 1;
      end
    end
    // simulation finished -> print messages and if an error was detected
    $display   ("#############");
    if (errors) begin
      $display ("test finished, there were %0d errors detected :(", errors);
    end else begin
      $display ("test finished, no errors detected :)");
    end
    $display   ("#############");
    @(posedge clk)
      $finish;
  end

  // dut
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
