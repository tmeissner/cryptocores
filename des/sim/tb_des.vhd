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

-- the testvectors in this file are taken from the project
-- "DES/Triple DES IP Cores" from Rudolf Usselmann, to find under
-- http://opencores.org/project,des
-- Copyright (C) 2001 Rudolf Usselmann (rudi@asics.ws) 
-- ======================================================================


-- Revision 1.0  2011/09/17
-- Initial release


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;


entity tb_des is
end entity tb_des;


architecture rtl of tb_des is


  type t_array is array (0 to 18) of std_logic_vector(0 to 63);
  
  signal s_key_values : t_array :=
	(x"7CA110454A1A6E57", x"0131D9619DC1376E", x"07A1133E4A0B2686",
     x"3849674C2602319E", x"04B915BA43FEB5B6", x"0113B970FD34F2CE",
 	 x"0170F175468FB5E6", x"43297FAD38E373FE", x"07A7137045DA2A16",
 	 x"04689104C2FD3B2F", x"37D06BB516CB7546", x"1F08260D1AC2465E",
	 x"584023641ABA6176", x"025816164629B007", x"49793EBC79B3258F",
	 x"4FB05E1515AB73A7", x"49E95D6D4CA229BF", x"018310DC409B26D6",
	 x"1C587F1C13924FEF");
	
  signal s_plain_values : t_array :=
    (x"01A1D6D039776742", x"5CD54CA83DEF57DA", x"0248D43806F67172",
	 x"51454B582DDF440A", x"42FD443059577FA2", x"059B5E0851CF143A",
	 x"0756D8E0774761D2", x"762514B829BF486A", x"3BDD119049372802",
	 x"26955F6835AF609A", x"164D5E404F275232", x"6B056E18759F5CCA",
	 x"004BD6EF09176062", x"480D39006EE762F2", x"437540C8698F3CFA",
	 x"072D43A077075292", x"02FE55778117F12A", x"1D9D5C5018F728C2",
	 x"305532286D6F295A");
	 
  signal s_crypt_values : t_array :=
  	(x"690F5B0D9A26939B", x"7A389D10354BD271", x"868EBB51CAB4599A",
 	 x"7178876E01F19B2A", x"AF37FB421F8C4095", x"86A560F10EC6D85B",
	 x"0CD3DA020021DC09", x"EA676B2CB7DB2B7A", x"DFD64A815CAF1A0F",
	 x"5C513C9C4886C088", x"0A2AEEAE3FF4AB77", x"EF1BF03E5DFA575A",
	 x"88BF0DB6D70DEE56", x"A1F9915541020B56", x"6FBF1CAFCFFD0556",
	 x"2F22E49BAB7CA1AC", x"5A6B612CC26CCE4A", x"5F4C038ED12B2E41",
	 x"63FAC0D034D9F793");


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
    report "# encryption test";
    for index in 0 to 18 loop
      wait until rising_edge(s_clk);
        s_mode    <= '0';
        s_validin <= '1';
        s_key     <= s_key_values(index);
        s_datain  <= s_plain_values(index);
    end loop;
    wait until rising_edge(s_clk);
    s_validin <= '0';
    wait for 100 ns;
    report "# decryption test";
    for index in 0 to 18 loop
      wait until rising_edge(s_clk);
        s_mode    <= '1';
        s_validin <= '1';
        s_key     <= s_key_values(index);
        s_datain  <= s_crypt_values(index);
    end loop;
    wait until rising_edge(s_clk);
    s_mode    <= '0';
    s_validin <= '0';
    wait;
  end process teststimuliP;
  
  
  testcheckerP : process is
  begin
    for index in 0 to 18 loop
      wait until rising_edge(s_clk) and s_validout = '1';
        if(s_dataout /= s_crypt_values(index)) then
          report "encryption error";
        end if;
    end loop;
    for index in 0 to 18 loop
      wait until rising_edge(s_clk) and s_validout = '1';
        if(s_dataout /= s_plain_values(index)) then
          report "decryption error";
        end if;
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