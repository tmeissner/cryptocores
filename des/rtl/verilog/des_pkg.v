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


function [0:63] ip (input [0:63] data);
begin
  ip = {data[57], data[49], data[41], data[33], data[25], data[17], data[ 9], data[1],
        data[59], data[51], data[43], data[35], data[27], data[19], data[11], data[3],
        data[61], data[53], data[45], data[37], data[29], data[21], data[13], data[5],
        data[63], data[55], data[47], data[39], data[31], data[23], data[15], data[7],
        data[56], data[48], data[40], data[32], data[24], data[16], data[ 8], data[0],
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

