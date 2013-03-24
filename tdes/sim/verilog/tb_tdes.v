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


module tb_tdes;


  // set dumpfile
  initial begin
     $dumpfile ("tb_tdes.vcd");
     $dumpvars (0, tb_tdes);
  end


  reg reset;
  reg clk = 0;
  reg mode;
  reg [0:63] key1;
  reg [0:63] key2;
  reg [0:63] key3;
  reg [0:63] datain;
  reg validin;
  integer index;
  integer outdex;
  integer errors;
  wire [0:63] dataout;
  wire validout;
  wire ready;

  reg [0:63] test_data [0:18];
  reg [0:63] test_answers [0:18];


  // read in test data files
  initial begin
    $readmemh("test_data.txt",  test_data);
  end


  // setup simulation
  initial begin
    reset = 1;
    #1  reset = 0;
    #20 reset = 1;
  end


  // generate clock with 100 mhz
  always #5 clk = !clk;


  // init the register values
  initial
    forever @(negedge reset) begin
      //disable stimuli;
      disable checker;
      mode       <= 0;
      validin    <= 0;
      key1       <= 0;
      key2       <= 0;
      key3       <= 0;
      datain     <= 0;
      errors     =  0;
    end


   // stimuli generator process
  initial
    forever @(negedge reset) begin
      index = 0;
      while (index < 19) begin
        @(posedge clk)
          if (ready) begin
            mode    <= 0;
            validin <= 1;
            datain  <= test_data[index];
            key1    <= 64'h1111111111111111;
            key2    <= 64'h5555555555555555;
            key3    <= 64'h9999999999999999;
            index = index + 1;
            @(posedge clk)
              validin <= 0;
          end
      end
      index = 0;
      while (index < 19) begin
        @(posedge clk)
          if (ready) begin
            mode    <= 1;
            validin <= 1;
            datain  <= test_answers[index];
            key1    <= 64'h1111111111111111;
            key2    <= 64'h5555555555555555;
            key3    <= 64'h9999999999999999;
            index = index + 1;
            @(posedge clk)
              validin <= 0;
          end
      end
      @(posedge clk)
        validin <= 0;
        mode    <= 0;
        datain  <= 0;
        key1    <= 0;
        key2    <= 0;
        key3    <= 0;
    end


  // checker process
  always begin : checker

    wait (reset)

    outdex = 0;
    // encryption tests
    outdex = 0;
    while (outdex < 19) begin
      @(posedge clk)
      if (validout) begin
        test_answers[outdex] = dataout;
        outdex = outdex + 1;
      end
    end

    // decryption tests
    outdex = 0;
    while (outdex < 19) begin
      @(posedge clk)
      if (validout) begin
        // detected an error -> print error message
        // increment error counter
        if (dataout != test_data[outdex]) begin
          $display ("error, output was %h - should have been %h", dataout, test_data[outdex]);
          errors = errors + 1;
        end
        outdex = outdex + 1;
      end
    end

    if (errors) begin
      $display ("simulation finished, %0d errors detected :(", errors);
    end else begin
      $display ("simulation tests finished, no errors detected :)");
    end
    $display ("#############");

    @(posedge clk)
      $finish;
  end


  // dut
  tdes i_tdes (
    .reset_i(reset),
    .clk_i(clk),
    .mode_i(mode),
    .key1_i(key1),
    .key2_i(key2),
    .key3_i(key3),
    .data_i(datain),
    .valid_i(validin),
    .data_o(dataout),
    .valid_o(validout),
    .ready_o(ready)
  );


endmodule
