// ======================================================================
// DES encryption/decryption
// algorithm according:FIPS 46-3 specification
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
// along with this program; if not, write:the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
// ======================================================================


`timescale 1ns/1ps


module des
  (
    input             reset_i,  // async reset
    input             clk_i,    // clock
    input             mode_i,   // des-mode: 0 = encrypt, 1 = decrypt
    input      [0:63] key_i,    // key input
    input      [0:63] data_i,   // data input
    input             valid_i,  // input key/data valid flag
    output reg        accept_o,
    output reg [0:63] data_o,   // data output
    output            valid_o,  // output data valid flag
    input             accept_i
  );


`include "../../../des/rtl/verilog/des_pkg.v"


  `ifdef PIPE

    // valid, mode register
    reg [0:18] valid;
    reg [0:17] mode;

    // algorithm pipeline register
    // key calculation register
    reg [0:27] c0;
    reg [0:27] c1;
    reg [0:27] c2;
    reg [0:27] c3;
    reg [0:27] c4;
    reg [0:27] c5;
    reg [0:27] c6;
    reg [0:27] c7;
    reg [0:27] c8;
    reg [0:27] c9;
    reg [0:27] c10;
    reg [0:27] c11;
    reg [0:27] c12;
    reg [0:27] c13;
    reg [0:27] c14;
    reg [0:27] c15;
    reg [0:27] c16;
    reg [0:27] d0;
    reg [0:27] d1;
    reg [0:27] d2;
    reg [0:27] d3;
    reg [0:27] d4;
    reg [0:27] d5;
    reg [0:27] d6;
    reg [0:27] d7;
    reg [0:27] d8;
    reg [0:27] d9;
    reg [0:27] d10;
    reg [0:27] d11;
    reg [0:27] d12;
    reg [0:27] d13;
    reg [0:27] d14;
    reg [0:27] d15;
    reg [0:27] d16;
    // key register
    wire [0:47] key1;
    wire [0:47] key2;
    wire [0:47] key3;
    wire [0:47] key4;
    wire [0:47] key5;
    wire [0:47] key6;
    wire [0:47] key7;
    wire [0:47] key8;
    wire [0:47] key9;
    wire [0:47] key10;
    wire [0:47] key11;
    wire [0:47] key12;
    wire [0:47] key13;
    wire [0:47] key14;
    wire [0:47] key15;
    wire [0:47] key16;
    // register for left, right data blocks
    reg [0:31] l;
    reg [0:31] l0;
    reg [0:31] l1;
    reg [0:31] l2;
    reg [0:31] l3;
    reg [0:31] l4;
    reg [0:31] l5;
    reg [0:31] l6;
    reg [0:31] l7;
    reg [0:31] l8;
    reg [0:31] l9;
    reg [0:31] l10;
    reg [0:31] l11;
    reg [0:31] l12;
    reg [0:31] l13;
    reg [0:31] l14;
    reg [0:31] l15;
    reg [0:31] l16;
    reg [0:31] r;
    reg [0:31] r0;
    reg [0:31] r1;
    reg [0:31] r2;
    reg [0:31] r3;
    reg [0:31] r4;
    reg [0:31] r5;
    reg [0:31] r6;
    reg [0:31] r7;
    reg [0:31] r8;
    reg [0:31] r9;
    reg [0:31] r10;
    reg [0:31] r11;
    reg [0:31] r12;
    reg [0:31] r13;
    reg [0:31] r14;
    reg [0:31] r15;
    reg [0:31] r16;

    wire valid_o = valid[18];


    // valid, mode register
    always @(posedge clk_i, negedge reset_i) begin
      if(~reset_i) begin
        valid    <= 0;
        mode     <= 0;
        accept_o <= 0;
      end
      else begin
        // shift registers
        valid[1:18] <= valid[0:17];
        valid[0]    <= valid_i;
        mode[1:17]  <= mode[0:16];
        mode[0]     <= mode_i;
        accept_o    <= 1;
      end
    end

    // des algorithm pipeline
    always @(posedge clk_i, negedge reset_i) begin
      if(~reset_i) begin
        l      <= 0;
        r      <= 0;
        l0     <= 0;
        l1     <= 0;
        l2     <= 0;
        l3     <= 0;
        l4     <= 0;
        l5     <= 0;
        l6     <= 0;
        l7     <= 0;
        l8     <= 0;
        l9     <= 0;
        l10    <= 0;
        l11    <= 0;
        l12    <= 0;
        l13    <= 0;
        l14    <= 0;
        l15    <= 0;
        l16    <= 0;
        r0     <= 0;
        r1     <= 0;
        r2     <= 0;
        r3     <= 0;
        r4     <= 0;
        r5     <= 0;
        r6     <= 0;
        r7     <= 0;
        r8     <= 0;
        r9     <= 0;
        r10    <= 0;
        r11    <= 0;
        r12    <= 0;
        r13    <= 0;
        r14    <= 0;
        r15    <= 0;
        r16    <= 0;
        data_o <= 0;
      end
      else begin
        // output stage
        data_o <= ipn({r16, l16});
        // 16. stage
        l16   <= r15;
        r16   <= l15 ^ (f(r15, key16));
        // 15. stage
        l15   <= r14;
        r15   <= l14 ^ (f(r14, key15));
        // 14. stage
        l14   <= r13;
        r14   <= l13 ^ (f(r13, key14));
        // 13. stage
        l13   <= r12;
        r13   <= l12 ^ (f(r12, key13));
        // 12. stage
        l12   <= r11;
        r12   <= l11 ^ (f(r11, key12));
        // 11. stage
        l11   <= r10;
        r11   <= l10 ^ (f(r10, key11));
        // 10. stage
        l10   <= r9;
        r10   <= l9 ^ (f(r9, key10));
        // 9. stage
        l9   <= r8;
        r9   <= l8 ^ (f(r8, key9));
        // 8. stage
        l8   <= r7;
        r8   <= l7 ^ (f(r7, key8));
        // 7. stage
        l7   <= r6;
        r7   <= l6 ^ (f(r6, key7));
        // 6. stage
        l6   <= r5;
        r6   <= l5 ^ (f(r5, key6));
        // 5. stage
        l5   <= r4;
        r5   <= l4 ^ (f(r4, key5));
        // 4. stage
        l4   <= r3;
        r4   <= l3 ^ (f(r3, key4));
        // 3. stage
        l3   <= r2;
        r3   <= l2 ^ (f(r2, key3));
        // 2. stage
        l2   <= r1;
        r2   <= l1 ^ (f(r1, key2));
        // 1. stage
        l1   <= r0;
        r1   <= l0 ^ (f(r0, key1));
        // 1. state
        l0   <= l;
        r0   <= r;
        // input stage
        l   <= ip0(data_i);
        r   <= ip1(data_i);
      end
    end

    // des key pipeline
    always @(posedge clk_i, negedge reset_i) begin
      if(~reset_i) begin
        c0     <= 0;
        c1     <= 0;
        c2     <= 0;
        c3     <= 0;
        c4     <= 0;
        c5     <= 0;
        c6     <= 0;
        c7     <= 0;
        c8     <= 0;
        c9     <= 0;
        c10    <= 0;
        c11    <= 0;
        c12    <= 0;
        c13    <= 0;
        c14    <= 0;
        c15    <= 0;
        c16    <= 0;
        d0     <= 0;
        d1     <= 0;
        d2     <= 0;
        d3     <= 0;
        d4     <= 0;
        d5     <= 0;
        d6     <= 0;
        d7     <= 0;
        d8     <= 0;
        d9     <= 0;
        d10    <= 0;
        d11    <= 0;
        d12    <= 0;
        d13    <= 0;
        d14    <= 0;
        d15    <= 0;
        d16    <= 0;
      end
      else begin
        // input stage
        c0 <= pc1_c(key_i);
        d0 <= pc1_d(key_i);
        // 1st stage
        if (~mode[0]) begin
          c1 <= {c0[1:27], c0[0]};
          d1 <= {d0[1:27], d0[0]};
        end
        else begin
          c1 <= c0;
          d1 <= d0;
        end
        // 2nd stage
        if (~mode[1]) begin
          c2 <= {c1[1:27], c1[0]};
          d2 <= {d1[1:27], d1[0]};
        end
        else begin
          c2 <= {c1[27], c1[0:26]};
          d2 <= {d1[27], d1[0:26]};
        end
        // 3rd stage
        if (~mode[2]) begin
          c3 <= {c2[2:27], c2[0:1]};
          d3 <= {d2[2:27], d2[0:1]};
        end
        else begin
          c3 <= {c2[26:27], c2[0:25]};
          d3 <= {d2[26:27], d2[0:25]};
        end
        // 4th stage
        if (~mode[3]) begin
          c4 <= {c3[2:27], c3[0:1]};
          d4 <= {d3[2:27], d3[0:1]};
        end
        else begin
          c4 <= {c3[26:27], c3[0:25]};
          d4 <= {d3[26:27], d3[0:25]};
        end
        // 5th stage
        if (~mode[4]) begin
          c5 <= {c4[2:27], c4[0:1]};
          d5 <= {d4[2:27], d4[0:1]};
        end
        else begin
          c5 <= {c4[26:27], c4[0:25]};
          d5 <= {d4[26:27], d4[0:25]};
        end
        // 6. stage
        if (~mode[5]) begin
          c6 <= {c5[2:27], c5[0:1]};
          d6 <= {d5[2:27], d5[0:1]};
        end
        else begin
          c6 <= {c5[26:27], c5[0:25]};
          d6 <= {d5[26:27], d5[0:25]};
        end
        // 7. stage
        if (~mode[6]) begin
          c7 <= {c6[2:27], c6[0:1]};
          d7 <= {d6[2:27], d6[0:1]};
        end
        else begin
          c7 <= {c6[26:27], c6[0:25]};
          d7 <= {d6[26:27], d6[0:25]};
        end
        // 8. stage
        if (~mode[7]) begin
          c8 <= {c7[2:27], c7[0:1]};
          d8 <= {d7[2:27], d7[0:1]};
        end
        else begin
          c8 <= {c7[26:27], c7[0:25]};
          d8 <= {d7[26:27], d7[0:25]};
        end
        // 9. stage
        if (~mode[8]) begin
          c9 <= {c8[1:27], c8[0]};
          d9 <= {d8[1:27], d8[0]};
        end
        else begin
          c9 <= {c8[27], c8[0:26]};
          d9 <= {d8[27], d8[0:26]};
        end
        // 10. stage
        if (~mode[9]) begin
          c10 <= {c9[2:27], c9[0:1]};
          d10 <= {d9[2:27], d9[0:1]};
        end
        else begin
          c10 <= {c9[26:27], c9[0:25]};
          d10 <= {d9[26:27], d9[0:25]};
        end
        // 6. stage
        if (~mode[10]) begin
          c11 <= {c10[2:27], c10[0:1]};
          d11 <= {d10[2:27], d10[0:1]};
        end
        else begin
          c11 <= {c10[26:27], c10[0:25]};
          d11 <= {d10[26:27], d10[0:25]};
        end
        // 6. stage
        if (~mode[11]) begin
          c12 <= {c11[2:27], c11[0:1]};
          d12 <= {d11[2:27], d11[0:1]};
        end
        else begin
          c12 <= {c11[26:27], c11[0:25]};
          d12 <= {d11[26:27], d11[0:25]};
        end
        // 6. stage
        if (~mode[12]) begin
          c13 <= {c12[2:27], c12[0:1]};
          d13 <= {d12[2:27], d12[0:1]};
        end
        else begin
          c13 <= {c12[26:27], c12[0:25]};
          d13 <= {d12[26:27], d12[0:25]};
        end
        // 6. stage
        if (~mode[13]) begin
          c14 <= {c13[2:27], c13[0:1]};
          d14 <= {d13[2:27], d13[0:1]};
        end
        else begin
          c14 <= {c13[26:27], c13[0:25]};
          d14 <= {d13[26:27], d13[0:25]};
        end
        // 6. stage
        if (~mode[14]) begin
          c15 <= {c14[2:27], c14[0:1]};
          d15 <= {d14[2:27], d14[0:1]};
        end
        else begin
          c15 <= {c14[26:27], c14[0:25]};
          d15 <= {d14[26:27], d14[0:25]};
        end
        // 6. stage
        if (~mode[15]) begin
          c16 <= {c15[1:27], c15[0]};
          d16 <= {d15[1:27], d15[0]};
        end
        else begin
          c16 <= {c15[27], c15[0:26]};
          d16 <= {d15[27], d15[0:26]};
        end
      end
    end

    // key assignments
    assign key1  = pc2({c1, d1});
    assign key2  = pc2({c2, d2});
    assign key3  = pc2({c3, d3});
    assign key4  = pc2({c4, d4});
    assign key5  = pc2({c5, d5});
    assign key6  = pc2({c6, d6});
    assign key7  = pc2({c7, d7});
    assign key8  = pc2({c8, d8});
    assign key9  = pc2({c9, d9});
    assign key10 = pc2({c10, d10});
    assign key11 = pc2({c11, d11});
    assign key12 = pc2({c12, d12});
    assign key13 = pc2({c13, d13});
    assign key14 = pc2({c14, d14});
    assign key15 = pc2({c15, d15});
    assign key16 = pc2({c16, d16});

  `endif


  `ifdef ITER


    // mode register
    reg valid;
    reg mode;
    integer state;

    // algorithm pipeline register
    // key calculation register
    reg [0:27] c;
    reg [0:27] d;
    // key register
    reg [0:47] key;
    // register for left, right data blocks
    reg [0:31] l;
    reg [0:31] r;

    wire valid_o = valid;


    always @(posedge clk_i, negedge reset_i) begin
      if (~reset_i) begin
        c <= 0;
        d <= 0;
      end else begin
        case (state)

          3, 4, 5, 6, 7, 8 , 10, 11, 12, 13, 14, 15 : begin
            if (mode) begin
              c <= {c[26:27], c[0:25]};
              d <= {d[26:27], d[0:25]};
            end else begin
              c <= {c[2:27], c[0:1]};
              d <= {d[2:27], d[0:1]};
            end
          end

          1 : begin
            if (~mode) begin
              c <= {c[1:27], c[0]};
              d <= {c[0], d[1:27], d[0]};
            end
          end

          2, 9, 16 : begin
            if (mode) begin
              c <= {c[27], c[0:26]};
              d <= {d[27], d[0:26]};
            end else begin
              c <= {c[1:27], c[0]};
              d <= {d[1:27], d[0]};
            end
          end

        endcase
      end
    end


    always @(posedge clk_i, negedge reset_i) begin
      if(~reset_i) begin
        l        <= 0;
        r        <= 0;
        key      <= 0;
        state    <= 0;
        mode     <= 0;
        valid    <= 0;
        accept_o <= 0;
        data_o   <= 0;
      end
      else begin

        case (state)

          0 : begin
            l        <= 0;
            r        <= 0;
            key      <= 0;
            mode     <= 0;
            valid    <= 0;
            accept_o <= 1;
            if (valid_i && accept_o) begin
              accept_o <= 0;
              mode     <= mode_i;
              l        <= ip0(data_i);
              r        <= ip1(data_i);
              c        <= pc1_c(key_i);
              d        <= pc1_d(key_i);
              state    <= state + 1;
            end
          end

          1 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c, d}));
            end else begin
              r <= l ^ f(r, pc2({c[1:27], c[0], d[1:27], d[0]}));
            end
            l     <= r;
            state <= state + 1;
          end

          2 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[27], c[0:26], d[27], d[0:26]}));
            end else begin
              r <= l ^ f(r, pc2({c[1:27], c[0], d[1:27], d[0]}));
            end
            l     <= r;
            state <= state + 1;
          end

          3 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          4 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          5 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          6 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          7 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          8 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          9 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[27], c[0:26], d[27], d[0:26]}));
            end else begin
              r <= l ^ f(r, pc2({c[1:27], c[0], d[1:27], d[0]}));
            end
            l     <= r;
            state <= state + 1;
          end

          10 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          11 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          12 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          13 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          14 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          15 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[26:27], c[0:25], d[26:27], d[0:25]}));
            end else begin
              r <= l ^ f(r, pc2({c[2:27], c[0:1], d[2:27], d[0:1]}));
            end
            l     <= r;
            state <= state + 1;
          end

          16 : begin
            if (mode) begin
              r <= l ^ f(r, pc2({c[27], c[0:26], d[27], d[0:26]}));
            end else begin
              r <= l ^ f(r, pc2({c[1:27], c[0], d[1:27], d[0]}));
            end
            l     <= r;
            state <= state + 1;
          end

          17 : begin
            valid <= 1;
            data_o <= ipn({r, l});
            if (valid && accept_i) begin
              valid <= 0;
              state <= 0;
            end
          end

          default :
            state <= 0;

        endcase
      end
    end

    assign valid_o = valid;


  `endif


endmodule




