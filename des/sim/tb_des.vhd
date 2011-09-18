-- ======================================================================
-- DES encryption/decryption testbench
-- tests according to NIST 800-16 special publication
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


-- Revision 1.0   2011/09/17
-- Initial release
-- Revision 1.0.1 2011/09/18
-- tests partial adopted to NIST 800-16 publication


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_des is
end entity tb_des;


architecture rtl of tb_des is


  type t_array is array (natural range <>) of std_logic_vector(0 to 63);
  
  signal s_variable_plaintext_known_answers : t_array(0 to 63) :=
    (x"95F8A5E5DD31D900", x"DD7F121CA5015619", x"2E8653104F3834EA",
     x"4BD388FF6CD81D4F", x"20B9E767B2FB1456", x"55579380D77138EF",
     x"6CC5DEFAAF04512F", x"0D9F279BA5D87260", x"D9031B0271BD5A0A",
     x"424250B37C3DD951", x"B8061B7ECD9A21E5", x"F15D0F286B65BD28",
     x"ADD0CC8D6E5DEBA1", x"E6D5F82752AD63D1", x"ECBFE3BD3F591A5E",
     x"F356834379D165CD", x"2B9F982F20037FA9", x"889DE068A16F0BE6",
     x"E19E275D846A1298", x"329A8ED523D71AEC", x"E7FCE22557D23C97",
     x"12A9F5817FF2D65D", x"A484C3AD38DC9C19", x"FBE00A8A1EF8AD72",
     x"750D079407521363", x"64FEED9C724C2FAF", x"F02B263B328E2B60",
     x"9D64555A9A10B852", x"D106FF0BED5255D7", x"E1652C6B138C64A5",
     x"E428581186EC8F46", x"AEB5F5EDE22D1A36", x"E943D7568AEC0C5C",
     x"DF98C8276F54B04B", x"B160E4680F6C696F", x"FA0752B07D9C4AB8",
     x"CA3A2B036DBC8502", x"5E0905517BB59BCF", x"814EEB3B91D90726",
     x"4D49DB1532919C9F", x"25EB5FC3F8CF0621", x"AB6A20C0620D1C6F", 
     x"79E90DBC98F92CCA", x"866ECEDD8072BB0E", x"8B54536F2F3E64A8",
     x"EA51D3975595B86B", x"CAFFC6AC4542DE31", x"8DD45A2DDF90796C",
     x"1029D55E880EC2D0", x"5D86CB23639DBEA9", x"1D1CA853AE7C0C5F",
     x"CE332329248F3228", x"8405D1ABE24FB942", x"E643D78090CA4207",
     x"48221B9937748A23", x"DD7C0BBD61FAFD54", x"2FBC291A570DB5C4",
     x"E07C30D7E4E26E12", x"0953E2258E8E90A1", x"5B711BC4CEEBF2EE",
     x"CC083F1E6D9E85F6", x"D2FD8867D50D2DFE", x"06E7EA22CE92708F",
     x"166B40B44ABA4BD6");



  signal s_clk      : std_logic := '0';
  signal s_mode     : std_logic := '0';
  signal s_key      : std_logic_vector(0 to 63) := (others => '0');
  signal s_datain   : std_logic_vector(0 to 63) := (others => '0');
  signal s_validin  : std_logic := '0';
  signal s_dataout  : std_logic_vector(0 to 63);
  signal s_validout : std_logic;


  component des is
    port (
      clk_i       : in  std_logic;
      mode_i      : in  std_logic;
      key_i       : in  std_logic_vector(0 TO 63);
      data_i      : in  std_logic_vector(0 TO 63);
      valid_i     : in  std_logic;
      data_o      : out std_logic_vector(0 TO 63);
      valid_o     : out std_logic
    );
  end component des;


begin


  s_clk <= not(s_clk) after 10 ns;
  
  
  teststimuliP : process is
  begin
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= x"5555555555555555";
    s_datain  <= x"8000000000000000";
    report "# encryption test";
    for index in s_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk);
        s_validin <= '1';
        if(index /= 0) then
          s_datain <= '0' & s_datain(0 to 62);
        end if;
    end loop;
    wait until rising_edge(s_clk);
    s_validin <= '0';
    wait for 100 ns;
    report "# decryption test";
    for index in s_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk);
        s_mode    <= '1';
        s_validin <= '1';
        s_datain  <= s_variable_plaintext_known_answers(index);
    end loop;
    wait until rising_edge(s_clk);
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait;
  end process teststimuliP;
  
  
  testcheckerP : process is
    variable v_variable_ciphertext_known_answers : std_logic_vector(0 to 63) := x"8000000000000000";
  begin
    for index in s_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        if(s_dataout /= s_variable_plaintext_known_answers(index)) then
          report "encryption error";
        end if;
    end loop;
    for index in s_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        if(s_dataout /= v_variable_ciphertext_known_answers) then
          report "decryption error";
        end if;
        v_variable_ciphertext_known_answers := '0' & v_variable_ciphertext_known_answers(0 to 62);
    end loop;
    wait;
  end process testcheckerP;


  i_des : des
  port map (
    clk_i    => s_clk,
    mode_i   => s_mode,
    key_i    => s_key,
    data_i   => s_datain,
    valid_i  => s_validin,               
    data_o   => s_dataout,
    valid_o  => s_validout
  );


end architecture rtl;
