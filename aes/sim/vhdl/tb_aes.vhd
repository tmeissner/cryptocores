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



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.aes_pkg.all;



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

  type t_byte_array is array (natural range <>) of std_logic_vector(7 downto 0);

  constant C_LTABLE : t_byte_array := (
    x"00", x"ff", x"c8", x"08", x"91", x"10", x"d0", x"36",
    x"5a", x"3e", x"d8", x"43", x"99", x"77", x"fe", x"18",
    x"23", x"20", x"07", x"70", x"a1", x"6c", x"0c", x"7f",
    x"62", x"8b", x"40", x"46", x"c7", x"4b", x"e0", x"0e",
    x"eb", x"16", x"e8", x"ad", x"cf", x"cd", x"39", x"53",
    x"6a", x"27", x"35", x"93", x"d4", x"4e", x"48", x"c3",
    x"2b", x"79", x"54", x"28", x"09", x"78", x"0f", x"21",
    x"90", x"87", x"14", x"2a", x"a9", x"9c", x"d6", x"74",
    x"b4", x"7c", x"de", x"ed", x"b1", x"86", x"76", x"a4",
    x"98", x"e2", x"96", x"8f", x"02", x"32", x"1c", x"c1",
    x"33", x"ee", x"ef", x"81", x"fd", x"30", x"5c", x"13",
    x"9d", x"29", x"17", x"c4", x"11", x"44", x"8c", x"80",
    x"f3", x"73", x"42", x"1e", x"1d", x"b5", x"f0", x"12",
    x"d1", x"5b", x"41", x"a2", x"d7", x"2c", x"e9", x"d5",
    x"59", x"cb", x"50", x"a8", x"dc", x"fc", x"f2", x"56",
    x"72", x"a6", x"65", x"2f", x"9f", x"9b", x"3d", x"ba",
    x"7d", x"c2", x"45", x"82", x"a7", x"57", x"b6", x"a3",
    x"7a", x"75", x"4f", x"ae", x"3f", x"37", x"6d", x"47",
    x"61", x"be", x"ab", x"d3", x"5f", x"b0", x"58", x"af",
    x"ca", x"5e", x"fa", x"85", x"e4", x"4d", x"8a", x"05",
    x"fb", x"60", x"b7", x"7b", x"b8", x"26", x"4a", x"67",
    x"c6", x"1a", x"f8", x"69", x"25", x"b3", x"db", x"bd",
    x"66", x"dd", x"f1", x"d2", x"df", x"03", x"8d", x"34",
    x"d9", x"92", x"0d", x"63", x"55", x"aa", x"49", x"ec",
    x"bc", x"95", x"3c", x"84", x"0b", x"f5", x"e6", x"e7",
    x"e5", x"ac", x"7e", x"6e", x"b9", x"f9", x"da", x"8e",
    x"9a", x"c9", x"24", x"e1", x"0a", x"15", x"6b", x"3a",
    x"a0", x"51", x"f4", x"ea", x"b2", x"97", x"9e", x"5d",
    x"22", x"88", x"94", x"ce", x"19", x"01", x"71", x"4c",
    x"a5", x"e3", x"c5", x"31", x"bb", x"cc", x"1f", x"2d",
    x"3b", x"52", x"6f", x"f6", x"2e", x"89", x"f7", x"c0",
    x"68", x"1b", x"64", x"04", x"06", x"bf", x"83", x"38");

  constant C_ATABLE : t_byte_array := (
    x"01", x"e5", x"4c", x"b5", x"fb", x"9f", x"fc", x"12",
    x"03", x"34", x"d4", x"c4", x"16", x"ba", x"1f", x"36",
    x"05", x"5c", x"67", x"57", x"3a", x"d5", x"21", x"5a",
    x"0f", x"e4", x"a9", x"f9", x"4e", x"64", x"63", x"ee",
    x"11", x"37", x"e0", x"10", x"d2", x"ac", x"a5", x"29",
    x"33", x"59", x"3b", x"30", x"6d", x"ef", x"f4", x"7b",
    x"55", x"eb", x"4d", x"50", x"b7", x"2a", x"07", x"8d",
    x"ff", x"26", x"d7", x"f0", x"c2", x"7e", x"09", x"8c",
    x"1a", x"6a", x"62", x"0b", x"5d", x"82", x"1b", x"8f",
    x"2e", x"be", x"a6", x"1d", x"e7", x"9d", x"2d", x"8a",
    x"72", x"d9", x"f1", x"27", x"32", x"bc", x"77", x"85",
    x"96", x"70", x"08", x"69", x"56", x"df", x"99", x"94",
    x"a1", x"90", x"18", x"bb", x"fa", x"7a", x"b0", x"a7",
    x"f8", x"ab", x"28", x"d6", x"15", x"8e", x"cb", x"f2",
    x"13", x"e6", x"78", x"61", x"3f", x"89", x"46", x"0d",
    x"35", x"31", x"88", x"a3", x"41", x"80", x"ca", x"17",
    x"5f", x"53", x"83", x"fe", x"c3", x"9b", x"45", x"39",
    x"e1", x"f5", x"9e", x"19", x"5e", x"b6", x"cf", x"4b",
    x"38", x"04", x"b9", x"2b", x"e2", x"c1", x"4a", x"dd",
    x"48", x"0c", x"d0", x"7d", x"3d", x"58", x"de", x"7c",
    x"d8", x"14", x"6b", x"87", x"47", x"e8", x"79", x"84",
    x"73", x"3c", x"bd", x"92", x"c9", x"23", x"8b", x"97",
    x"95", x"44", x"dc", x"ad", x"40", x"65", x"86", x"a2",
    x"a4", x"cc", x"7f", x"ec", x"c0", x"af", x"91", x"fd",
    x"f7", x"4f", x"81", x"2f", x"5b", x"ea", x"a8", x"1c",
    x"02", x"d1", x"98", x"71", x"ed", x"25", x"e3", x"24",
    x"06", x"68", x"b3", x"93", x"2c", x"6f", x"3e", x"6c",
    x"0a", x"b8", x"ce", x"ae", x"74", x"b1", x"42", x"b4",
    x"1e", x"d3", x"49", x"e9", x"9c", x"c8", x"c6", x"c7",
    x"22", x"6e", x"db", x"20", x"bf", x"43", x"51", x"52",
    x"66", x"b2", x"76", x"60", x"da", x"c5", x"f3", x"f6",
    x"aa", x"cd", x"9a", x"a0", x"75", x"54", x"0e", x"01");


  function gmul_a(a : std_logic_vector(7 downto 0); b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable v_s : unsigned(7 downto 0) := x"00";
  begin
    v_s := unsigned(C_LTABLE(to_integer(unsigned(a)))) + unsigned(C_LTABLE(to_integer(unsigned(b))));
    v_s := unsigned(C_ATABLE(to_integer(v_s)));
    if (a = x"00" or b = x"00") then
      return x"00";
    else
      return std_logic_vector(v_s);
    end if;
  end function gmul_a;

  signal s_a : std_logic_vector(7 downto 0);
  signal s_b : std_logic_vector(7 downto 0);
  signal s_i : std_logic_vector(7 downto 0);
  signal s_j : std_logic_vector(7 downto 0);

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


  -- check gmul function
  gmulcheckP : process is
    variable v_a : std_logic_vector(7 downto 0) := x"00";
    variable v_b : std_logic_vector(7 downto 0) := x"00";
  begin
    for i in 0 to 255 loop
      for j in 0 to 255 loop
        s_i <= std_logic_vector(to_unsigned(i, 8));
        s_j <= std_logic_vector(to_unsigned(j, 8));
        wait until rising_edge(s_clk);
        s_a <= gmul(s_i, s_j);
        s_b <= gmul_a(s_i, s_j);
      end loop;
    end loop;
  end process gmulcheckP;


end architecture rtl;
