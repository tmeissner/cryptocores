-- ======================================================================
-- AES encryption/decryption
-- algorithm according to FIPS 197 specification
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_pkg.all;



entity aes is
  port (
    reset_i     : in  std_logic;                   -- async reset
    clk_i       : in  std_logic;                   -- clock
    mode_i      : in  std_logic;                   -- aes-modus: 0 = encrypt, 1 = decrypt
    key_i       : in  std_logic_vector(0 TO 127);  -- key input
    data_i      : in  std_logic_vector(0 TO 127);  -- data input
    valid_i     : in  std_logic;                   -- input key/data valid flag
    data_o      : out std_logic_vector(0 TO 127);  -- data output
    valid_o     : out std_logic                    -- output data valid flag
  );
end entity aes;



architecture rtl of aes is


begin


end architecture rtl;
