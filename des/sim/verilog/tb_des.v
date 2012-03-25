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

  reg reset;
  reg clk = 0;
  reg mode;
  reg [0:63] key;
  reg [0:63] datain;
  reg validin;
  integer index;
  integer outdex;
  wire [0:63] dataout;
  wire validout;

  reg [0:63] variable_plaintext_known_answers [0:63];

  initial begin
    $readmemh("stimuli.txt", variable_plaintext_known_answers);
  end

  initial begin
    reset = 1;
    #1  reset = 0;
    #20 reset = 1;
    #1000 $finish;
  end

  always #5 clk = !clk;

  initial
    forever @(negedge reset) begin
      disable stimuli;
      disable checker;
      mode    <= 0;
      validin <= 0;
      key     <= 0;
      datain  <= 0;
    end

  always begin : stimuli
    wait (reset)
    @(posedge clk)
      // Variable plaintext known answer test
      datain <= 64'h8000000000000000;
      mode    <= 0;
      validin <= 1;
      key     <= 64'h0101010101010101;
      for(index = 0; index < 64; index = index + 1)
      begin
        @(posedge clk)
          datain  <= {1'b0, datain[0:62]};
      end
      validin <= 0;
  end

  always begin : checker
    wait (reset)
    // Variable plaintext known answer test
    wait (validout)
    for(outdex = 0; outdex < 64; outdex = outdex + 1)
    begin
      @(posedge clk)
      if (dataout == variable_plaintext_known_answers[outdex]) begin
        $display ("okay");
      end else begin
        $display ("error, output was %h - should have been %h", dataout, variable_plaintext_known_answers[outdex]);
      end
    end
    @(posedge clk)
      $finish;
  end

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
