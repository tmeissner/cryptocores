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

  integer index;
  integer outdex;
  integer enc_errors;
  integer dec_errors;

  reg [0:63] data_input  [0:469];
  reg [0:63] key_input   [0:469];
  reg [0:63] data_output [0:469];


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
  end


  // generate clock with 100 mhz
  always #5 clk = !clk;


   // stimuli generator process
  initial
    forever @(negedge reset) begin
      @(posedge clk)
        for (index = 0; index < 235; index = index + 1)
        begin
          @(posedge clk)
            mode    <= 0;
            validin <= 1;
            datain  <= data_input[index];
            key     <= key_input[index];
        end
        for (index = 0; index < 10; index = index + 1)
        begin
          @(posedge clk)
            validin <= 0;
        end
        for (index = 235; index < 470; index = index + 1)
        begin
          @(posedge clk)
            mode    <= 1;
            validin <= 1;
            datain  <= data_input[index];
            key     <= key_input[index];
        end
        @(posedge clk)
          validin <= 0;
          mode    <= 0;
    end


  // checker process
  always begin : checker

    wait (reset)

    // encryption tests
    @(posedge validout)
    for(outdex = 0; outdex < 235; outdex = outdex + 1)
    begin
      @(posedge clk)
      // detected an error -> print error message
      // increment error counter
      if (dataout != data_output[outdex]) begin
        $display ("error, output was %h - should have been %h", dataout, data_output[outdex]);
        enc_errors = enc_errors + 1;
      end
    end

    // simulation finished -> print messages and if an error was detected
    $display   ("#############");
    if (enc_errors) begin
      $display ("encryption tests finished, %0d errors detected :(", enc_errors);
    end else begin
      $display ("encryption tests finished, no errors detected :)");
    end

    // decryption tests
    @(posedge validout)
    for(outdex = 235; outdex < 470; outdex = outdex + 1)
    begin
      @(posedge clk)
      // detected an error -> print error message
      // increment error counter
       if (dataout != data_output[outdex]) begin
         $display ("error, output was %h - should have been %h", dataout, data_output[outdex]);
         dec_errors = dec_errors + 1;
       end
    end

    // simulation finished -> print messages and if an error was detected
    $display   ("#############");
    if (dec_errors) begin
      $display ("decryption tests finished, %0d errors detected :(", dec_errors);
    end else begin
      $display ("decryption tests finished, no errors detected :)");
    end
    $display   ("#############");

    if (dec_errors | enc_errors) begin
      $display ("simulation finished, %0d errors detected :(", enc_errors + dec_errors);
    end else begin
      $display ("simulation tests finished, no errors detected :)");
    end
    $display ("#############");

    @(posedge clk)
      $finish;
  end


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
