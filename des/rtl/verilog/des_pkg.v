// ======================================================================
// DES encryption/decryption
// package file with functions
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


function [0:31] ip0 (input [0:63] data);
begin
  ip0 = {data[57], data[49], data[41], data[33], data[25], data[17], data[ 9], data[1],
        data[59], data[51], data[43], data[35], data[27], data[19], data[11], data[3],
        data[61], data[53], data[45], data[37], data[29], data[21], data[13], data[5],
        data[63], data[55], data[47], data[39], data[31], data[23], data[15], data[7]};
end
endfunction


function [0:61] ip1 (input [0:63] data);
begin
  ip1 = {data[56], data[48], data[40], data[32], data[24], data[16], data[ 8], data[0],
        data[58], data[50], data[42], data[34], data[26], data[18], data[10], data[2],
        data[60], data[52], data[44], data[36], data[28], data[20], data[12], data[4],
        data[62], data[54], data[46], data[38], data[30], data[22], data[14], data[6]};
end
endfunction


function [0:63] ipn (input [0:63] data);
begin
  ipn = {data[39],  data[7], data[47], data[15], data[55], data[23], data[63], data[31],
         data[38],  data[6], data[46], data[14], data[54], data[22], data[62], data[30],
         data[37],  data[5], data[45], data[13], data[53], data[21], data[61], data[29],
         data[36],  data[4], data[44], data[12], data[52], data[20], data[60], data[28],
         data[35],  data[3], data[43], data[11], data[51], data[19], data[59], data[27],
         data[34],  data[2], data[42], data[10], data[50], data[18], data[58], data[26],
         data[33],  data[1], data[41], data[ 9], data[49], data[17], data[57], data[25],
         data[32],  data[0], data[40], data[ 8], data[48], data[16], data[56], data[24]};
end
endfunction


function [0:47] e (input [0:31] data);
begin
  e = {data[31], data[ 0], data[ 1], data[ 2], data[ 3], data[ 4],
       data[ 3], data[ 4], data[ 5], data[ 6], data[ 7], data[ 8],
       data[ 7], data[ 8], data[ 9], data[10], data[11], data[12],
       data[11], data[12], data[13], data[14], data[15], data[16],
       data[15], data[16], data[17], data[18], data[19], data[20],
       data[19], data[20], data[21], data[22], data[23], data[24],
       data[23], data[24], data[25], data[26], data[27], data[28],
       data[27], data[28], data[29], data[30], data[31], data[ 0]};
end
endfunction


function [0:3] s1 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'hE4D12FB83A6C5907_0F74E2D1A6CB9538_41E8D62BFC973A50_FC8249175B3EA06D;
  s1 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s2 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'hF18E6B34972DC05A_3D47F28DC01A69B5_0E7BA4D158C6932F_D8A13F42B67C05E9;
  s2 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s3 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'hA09E63F51DC7B428_D709346A285ECBF1_D6498F30B12C5AE7_1AD069874FE3B52C;
  s3 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s4 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'h7DE3069A1285BC4F_D8B56F03472C1AE9_A690CB7DF13E5284_3F06A1D8945BC72E;
  s4 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s5 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'h2C417AB6853FD0E9_EB2C47D150FA3986_421BAD78F9C5630E_B8C71E2D6F09A453;
  s5 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s6 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'hC1AF92680D34E75B_AF427C9561DE0B38_9EF528C3704A1DB6_432C95FABE17608D;
  s6 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s7 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'h4B2EF08D3C975A61_D0B7491AE35C2F86_14BDC37EAF680592_6BD814A7950FE23C;
  s7 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:3] s8 (input [0:5] data);
  reg [0:255] matrix;
begin
  matrix = 256'hD2846FB1A93E50C7_1FD8A374C56B0E92_7B419CE206ADF358_21E74A8DFC90356B;
  s8 = matrix[{data[0],data[5]}*16 + data[1:4]];
end
endfunction


function [0:31] p (input [0:31] data);
begin
  p = {data[15], data[ 6], data[19], data[20],
       data[28], data[11], data[27], data[16],
       data[ 0], data[14], data[22], data[25],
       data[ 4], data[17], data[30], data[ 9],
       data[ 1], data[ 7], data[23], data[13],
       data[31], data[26], data[ 2], data[ 8],
       data[18], data[12], data[29], data[ 5],
       data[21], data[10], data[ 3], data[24]};
end
endfunction


function [0:31] f (input [0:31] data, input [0:47] key);
  reg [0:47] intern;
begin
  intern = e(data) ^ key;
  f      = p({s1(intern[0:5]), s2(intern[6:11]), s3(intern[12:17]), s4(intern[18:23]),
              s5(intern[24:29]), s6(intern[30:35]), s7(intern[36:41]), s8(intern[42:47])});
end
endfunction


function [0:27] pc1_c (input [0:63] data);
begin
  pc1_c = {data[56], data[48], data[40], data[32], data[24], data[16], data[ 8],
           data[ 0], data[57], data[49], data[41], data[33], data[25], data[17],
           data[ 9], data[ 1], data[58], data[50], data[42], data[34], data[26],
           data[18], data[10], data[ 2], data[59], data[51], data[43], data[35]};
end
endfunction


function [0:27] pc1_d (input [0:63] data);
begin
  pc1_d = {data[62], data[54], data[46], data[38], data[30], data[22], data[14],
           data[ 6], data[61], data[53], data[45], data[37], data[29], data[21],
           data[13], data[ 5], data[60], data[52], data[44], data[36], data[28],
           data[20], data[12], data[ 4], data[27], data[19], data[11], data[ 3]};
end
endfunction


function [0:47] pc2 (input [0:55] data);
begin
  pc2 = {data[13], data[16], data[10], data[23], data[ 0], data[ 4],
         data[ 2], data[27], data[14], data[ 5], data[20], data[ 9],
         data[22], data[18], data[11], data[ 3], data[25], data[ 7],
         data[15], data[ 6], data[26], data[19], data[12], data[ 1],
         data[40], data[51], data[30], data[36], data[46], data[54],
         data[29], data[39], data[50], data[44], data[32], data[47],
         data[43], data[48], data[38], data[55], data[33], data[52],
         data[45], data[41], data[49], data[35], data[28], data[31]};
end
endfunction

