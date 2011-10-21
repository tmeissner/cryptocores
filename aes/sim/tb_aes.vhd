-- ======================================================================
-- AES encryption/decryption testbench
-- tests according to NIST special publication
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


-- Revision 0.1   2011/10/22
-- Initial release


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_aes is
end entity tb_aes;


architecture rtl of tb_aes is


  signal s_reset    : std_logic := '0';
  signal s_clk      : std_logic := '0';
  signal s_mode     : std_logic := '0';
  signal s_key      : std_logic_vector(0 to 127) := (others => '0');
  signal s_datain   : std_logic_vector(0 to 127) := (others => '0');
  signal s_validin  : std_logic := '0';
  signal s_dataout  : std_logic_vector(0 to 127);
  signal s_validout : std_logic;


  component aes is
    port (
      reset_i     : in  std_logic;
      clk_i       : in  std_logic;
      mode_i      : in  std_logic;
      key_i       : in  std_logic_vector(0 TO 127);
      data_i      : in  std_logic_vector(0 TO 127);
      valid_i     : in  std_logic;
      data_o      : out std_logic_vector(0 TO 127);
      valid_o     : out std_logic
    );
  end component aes;


begin


  s_clk   <= not(s_clk) after 10 ns;
  s_reset <= '1' after 100 ns;


  i_aes : aes
  port map (
    reset_i  => s_reset,
    clk_i    => s_clk,
    mode_i   => s_mode,
    key_i    => s_key,
    data_i   => s_datain,
    valid_i  => s_validin,               
    data_o   => s_dataout,
    valid_o  => s_validout
  );


end architecture rtl;
