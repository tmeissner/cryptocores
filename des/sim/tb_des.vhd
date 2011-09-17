-- ======================================================================
-- DES encryption/decryption
-- algorithm according to FIPS 46-3 specification
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


-- Revision 1.0  2011/09/17
-- Initial release


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;


entity tb_des is
end entity tb_des;


architecture rtl of tb_des is


  signal s_clk      : std_logic : := '0';
  signal s_des1_key      : std_logic_vector(0 to 63);
  signal s_des1_datain   : std_logic_vector(0 to 63);
  signal s_des1_validin  : std_logic;
  signal s_des1_dataout  : std_logic_vector(0 to 63);
  signal s_des1_validout : std_logic;
  
  signal s_des2_key      : std_logic_vector(0 to 63);
  signal s_des2_dataout  : std_logic_vector(0 to 63);
  signal s_des2_validout : std_logic;


  component des is
    port (
      clk_i       : IN  std_logic;
      mode_i      : IN  std_logic;                  -- des-modus: 0 = encrypt, 1 = decrypt
      key_i       : IN  std_logic_vector(0 TO 63);
      data_i      : IN  std_logic_vector(0 TO 63);
      valid_i     : IN  std_logic;
      data_o      : OUT std_logic_vector(0 TO 63);
      valid_o     : OUT std_logic
    );
  end component des;


begin


  s_clk <= not(s_clk) after 10 ns;
  
  
  testinputP : process is
  begin
    for index in 0 to 31 loop
      wait until s_clk = '1';
      s_valid <= '1';
      s_mode
  end process testinputP;
  

  testoutputP : process is
  begin
    wait until s_clk = '1';
  end process testoutputP;
  


  i1_des : des
  port map (
    clk_i    => s_clk,
    mode_i   => '0',
    key_i    => s_des1_key,
    data_i   => s_des1_datain,
    valid_i  => s_des1_validin,               
    data_o   => s_des1_dataout,
    valid_o  => s_des1_validout
  );
  
  
  i2_des : des
  port map (
    clk_i    => s_clk,
    mode_i   => '1',
    key_i    => s_des2_key,
    data_i   => s_des1_dataout,
    valid_i  => s_des1_validout,               
    data_o   => s_des2_dataout,
    valid_o  => s_des2_validout
  );    


end architecture rtl;