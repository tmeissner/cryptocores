-- ======================================================================
-- AES encryption/decryption
-- package file with functions
-- Copyright (C) 2011 Torsten Meissner
-------------------------------------------------------------------------
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-- ======================================================================


-- Revision 0.1  2011/10/22
-- Initial release



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package aes_pkg is

  FUNCTION ip  ( input_vector : std_logic_vector(0 TO 63) ) RETURN std_logic_vector;

end package aes_pkg;


package body aes_pkg is

  FUNCTION ip ( input_vector : std_logic_vector(0 TO 63) ) RETURN std_logic_vector IS
    TYPE matrix IS ARRAY (0 TO 63) OF natural RANGE 0 TO 63;
    VARIABLE table : matrix := (57, 49, 41, 33, 25, 17,  9, 1,
                                59, 51, 43, 35, 27, 19, 11, 3,
                                61, 53, 45, 37, 29, 21, 13, 5,
                                63, 55, 47, 39, 31, 23, 15, 7,
                                56, 48, 40, 32, 24, 16,  8, 0,
                                58, 50, 42, 34, 26, 18, 10, 2,
                                60, 52, 44, 36, 28, 20, 12, 4,
                                62, 54, 46, 38, 30, 22, 14, 6);
    VARIABLE result : std_logic_vector(0 TO 63);
  BEGIN
    FOR index IN 0 TO 63 LOOP
      result( index ) := input_vector( table( index ) );
    END LOOP;
    RETURN result;
  END FUNCTION ip;


end package body aes_pkg;
