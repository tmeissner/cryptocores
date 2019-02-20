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

-- aes implementation
-- key length: 128 bit -> Nk = 4
-- data width: 128 bit -> Nb = 4
-- round number Nr = 10


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;



package aes_pkg is


  -- constants for AES128
  constant c_nk : natural := 4;   -- key size
  constant c_nb : natural := 4;   -- number of bytes
  constant c_nr : natural := 10;  -- number of rounds

  subtype t_rounds is natural range 0 to c_nr + 1;
  subtype t_key_rounds is natural range c_nk to c_nb * (c_nr + 1);

  type t_datatable1d is array (0 to 3) of std_logic_vector(7 downto 0);
  type t_datatable2d is array (0 to 3) of t_datatable1d;

  type t_stable1d is array (0 to 15) of std_logic_vector(7 downto 0);
  type t_stable2d is array (0 to 15) of t_stable1d;

  type t_key is array (0 to 3) of std_logic_vector(31 downto 0);
  
  type t_rcon is array (0 to 9) of t_datatable1d;

  constant c_sbox : t_stable2d := (
    -- 0     1      2      3      4      5      6      7      8      9      A      B      C      D      E      F
    (x"63", x"7c", x"77", x"7b", x"f2", x"6b", x"6f", x"c5", x"30", x"01", x"67", x"2b", x"fe", x"d7", x"ab", x"76"), -- 0
    (x"ca", x"82", x"c9", x"7d", x"fa", x"59", x"47", x"f0", x"ad", x"d4", x"a2", x"af", x"9c", x"a4", x"72", x"c0"), -- 1
    (x"b7", x"fd", x"93", x"26", x"36", x"3f", x"f7", x"cc", x"34", x"a5", x"e5", x"f1", x"71", x"d8", x"31", x"15"), -- 2
    (x"04", x"c7", x"23", x"c3", x"18", x"96", x"05", x"9a", x"07", x"12", x"80", x"e2", x"eb", x"27", x"b2", x"75"), -- 3
    (x"09", x"83", x"2c", x"1a", x"1b", x"6e", x"5a", x"a0", x"52", x"3b", x"d6", x"b3", x"29", x"e3", x"2f", x"84"), -- 4
    (x"53", x"d1", x"00", x"ed", x"20", x"fc", x"b1", x"5b", x"6a", x"cb", x"be", x"39", x"4a", x"4c", x"58", x"cf"), -- 5
    (x"d0", x"ef", x"aa", x"fb", x"43", x"4d", x"33", x"85", x"45", x"f9", x"02", x"7f", x"50", x"3c", x"9f", x"a8"), -- 6
    (x"51", x"a3", x"40", x"8f", x"92", x"9d", x"38", x"f5", x"bc", x"b6", x"da", x"21", x"10", x"ff", x"f3", x"d2"), -- 7
    (x"cd", x"0c", x"13", x"ec", x"5f", x"97", x"44", x"17", x"c4", x"a7", x"7e", x"3d", x"64", x"5d", x"19", x"73"), -- 8
    (x"60", x"81", x"4f", x"dc", x"22", x"2a", x"90", x"88", x"46", x"ee", x"b8", x"14", x"de", x"5e", x"0b", x"db"), -- 9
    (x"e0", x"32", x"3a", x"0a", x"49", x"06", x"24", x"5c", x"c2", x"d3", x"ac", x"62", x"91", x"95", x"e4", x"79"), -- A
    (x"e7", x"c8", x"37", x"6d", x"8d", x"d5", x"4e", x"a9", x"6c", x"56", x"f4", x"ea", x"65", x"7a", x"ae", x"08"), -- B
    (x"ba", x"78", x"25", x"2e", x"1c", x"a6", x"b4", x"c6", x"e8", x"dd", x"74", x"1f", x"4b", x"bd", x"8b", x"8a"), -- C
    (x"70", x"3e", x"b5", x"66", x"48", x"03", x"f6", x"0e", x"61", x"35", x"57", x"b9", x"86", x"c1", x"1d", x"9e"), -- D
    (x"e1", x"f8", x"98", x"11", x"69", x"d9", x"8e", x"94", x"9b", x"1e", x"87", x"e9", x"ce", x"55", x"28", x"df"), -- E
    (x"8c", x"a1", x"89", x"0d", x"bf", x"e6", x"42", x"68", x"41", x"99", x"2d", x"0f", x"b0", x"54", x"bb", x"16")); -- F

  constant c_sbox_invers : t_stable2d := (
    -- 0     1      2      3      4      5      6      7      8      9      A      B      C      D      E      F
    (x"52", x"09", x"6a", x"d5", x"30", x"36", x"a5", x"38", x"bf", x"40", x"a3", x"9e", x"81", x"f3", x"d7", x"fb"), -- 0
    (x"7c", x"e3", x"39", x"82", x"9b", x"2f", x"ff", x"87", x"34", x"8e", x"43", x"44", x"c4", x"de", x"e9", x"cb"), -- 1
    (x"54", x"7b", x"94", x"32", x"a6", x"c2", x"23", x"3d", x"ee", x"4c", x"95", x"0b", x"42", x"fa", x"c3", x"4e"), -- 2
    (x"08", x"2e", x"a1", x"66", x"28", x"d9", x"24", x"b2", x"76", x"5b", x"a2", x"49", x"6d", x"8b", x"d1", x"25"), -- 3
    (x"72", x"f8", x"f6", x"64", x"86", x"68", x"98", x"16", x"d4", x"a4", x"5c", x"cc", x"5d", x"65", x"b6", x"92"), -- 4
    (x"6c", x"70", x"48", x"50", x"fd", x"ed", x"b9", x"da", x"5e", x"15", x"46", x"57", x"a7", x"8d", x"9d", x"84"), -- 5
    (x"90", x"d8", x"ab", x"00", x"8c", x"bc", x"d3", x"0a", x"f7", x"e4", x"58", x"05", x"b8", x"b3", x"45", x"06"), -- 6
    (x"d0", x"2c", x"1e", x"8f", x"ca", x"3f", x"0f", x"02", x"c1", x"af", x"bd", x"03", x"01", x"13", x"8a", x"6b"), -- 7
    (x"3a", x"91", x"11", x"41", x"4f", x"67", x"dc", x"ea", x"97", x"f2", x"cf", x"ce", x"f0", x"b4", x"e6", x"73"), -- 8
    (x"96", x"ac", x"74", x"22", x"e7", x"ad", x"35", x"85", x"e2", x"f9", x"37", x"e8", x"1c", x"75", x"df", x"6e"), -- 9
    (x"47", x"f1", x"1a", x"71", x"1d", x"29", x"c5", x"89", x"6f", x"b7", x"62", x"0e", x"aa", x"18", x"be", x"1b"), -- A
    (x"fc", x"56", x"3e", x"4b", x"c6", x"d2", x"79", x"20", x"9a", x"db", x"c0", x"fe", x"78", x"cd", x"5a", x"f4"), -- B
    (x"1f", x"dd", x"a8", x"33", x"88", x"07", x"c7", x"31", x"b1", x"12", x"10", x"59", x"27", x"80", x"ec", x"5f"), -- C
    (x"60", x"51", x"7f", x"a9", x"19", x"b5", x"4a", x"0d", x"2d", x"e5", x"7a", x"9f", x"93", x"c9", x"9c", x"ef"), -- D
    (x"a0", x"e0", x"3b", x"4d", x"ae", x"2a", x"f5", x"b0", x"c8", x"eb", x"bb", x"3c", x"83", x"53", x"99", x"61"), -- E
    (x"17", x"2b", x"04", x"7e", x"ba", x"77", x"d6", x"26", x"e1", x"69", x"14", x"63", x"55", x"21", x"0c", x"7d"));-- F

  constant c_rcon : t_rcon := (
    (x"01", x"00", x"00", x"00"),
    (x"02", x"00", x"00", x"00"),
    (x"04", x"00", x"00", x"00"),
    (x"08", x"00", x"00", x"00"),
    (x"10", x"00", x"00", x"00"),
    (x"20", x"00", x"00", x"00"),
    (x"40", x"00", x"00", x"00"),
    (x"80", x"00", x"00", x"00"),
    (x"1B", x"00", x"00", x"00"),
    (x"36", x"00", x"00", x"00"));


  function bytesub    (input : std_logic_vector(7 downto 0)) return std_logic_vector;
  function invbytesub (input : std_logic_vector(7 downto 0)) return std_logic_vector;

  function shiftrow    (input : t_datatable2d) return t_datatable2d;
  function invshiftrow (input : t_datatable2d) return t_datatable2d;

  function mixcolumns (input : t_datatable2d; column : natural) return t_datatable2d;
  function invmixcolumns (input : t_datatable2d; column : natural) return t_datatable2d;

  function sortdata (input : std_logic_vector(127 downto 0)) return t_datatable2d;

  function gmul (a : std_logic_vector(7 downto 0); b : std_logic_vector(7 downto 0)) return std_logic_vector;

  function addroundkey (input : in t_datatable2d; key : in t_key) return t_datatable2d;

  function subword (input : in t_datatable1d) return t_datatable1d;

  function rotword (input : in t_datatable1d) return t_datatable1d;


end package aes_pkg;



package body aes_pkg is


  function sortdata (input : std_logic_vector(127 downto 0)) return t_datatable2d is
    variable v_datamatrix : t_datatable2d;
  begin
    for outdex in 0 to 3 loop
      for index in 0 to 3 loop
        v_datamatrix(index)(outdex) := input(outdex*32+(index+1)*7 downto outdex*32+index*8);
      end loop;
    end loop;
    return v_datamatrix;
  end function sortdata;


  function bytesub (input : std_logic_vector(7 downto 0)) return std_logic_vector is
  begin
    return(c_sbox(to_integer(unsigned(input(7 downto 4))))(to_integer(unsigned(input(3 downto 0)))));
  end function bytesub;


  function invbytesub (input : std_logic_vector(7 downto 0)) return std_logic_vector is
  begin
    return(c_sbox_invers(to_integer(unsigned(input(7 downto 4))))(to_integer(unsigned(input(3 downto 0)))));
  end function invbytesub;


  function shiftrow (input : t_datatable2d) return t_datatable2d is
    variable v_datamatrix : t_datatable2d;
  begin
    -- copy input in internal matrix
    v_datamatrix := input;
    -- 2nd row
    v_datamatrix(1)(1) := input(1)(0);
    v_datamatrix(1)(2) := input(1)(1);
    v_datamatrix(1)(3) := input(1)(2);
    -- 3rd row
    v_datamatrix(2)(2) := input(2)(0);
    v_datamatrix(2)(3) := input(2)(1);
    -- 4rd row
    v_datamatrix(3)(3) := input(3)(0);
    -- return manipulated internal matrix
    return v_datamatrix;
  end function shiftrow;


  function invshiftrow (input : t_datatable2d) return t_datatable2d is
    variable v_datamatrix : t_datatable2d;
  begin
    -- copy input in internal matrix
    v_datamatrix := input;
    -- 2nd row
    v_datamatrix(1)(0) := input(1)(1);
    v_datamatrix(1)(1) := input(1)(2);
    v_datamatrix(1)(2) := input(1)(3);
    -- 3rd row
    v_datamatrix(2)(0) := input(2)(2);
    v_datamatrix(2)(1) := input(2)(3);
    -- 4rd row
    v_datamatrix(3)(0) := input(3)(3);
    -- return manipulated internal matrix
    return v_datamatrix;
  end function invshiftrow;


  -- trivial algorithmus to multiply two bytes in the GF(2^8) finite field defined
  -- by the polynomial x^8 + x^4 + x^3 + x + 1
  -- taken from http://www.codeplanet.eu/tutorials/cpp/51-advanced-encryption-standard.html
  -- and ported to vhdl
  function gmul (a : std_logic_vector(7 downto 0); b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable v_a, v_b     : std_logic_vector(7 downto 0);
    variable v_data       : std_logic_vector(7 downto 0) := (others => '0');
    variable v_hi_bit_set : boolean;
  begin
    v_a := a;
    v_b := b;
    for index in 0 to 7 loop
      if(v_b(0) = '1') then
        v_data := v_data xor v_a;
      end if;
      v_hi_bit_set := v_a(7) = '1';
      v_a          := v_a(6 downto 0) & '0';
      if (v_hi_bit_set) then
        v_a := v_a xor x"1B";
      end if;
      v_b := '0' & v_b(7 downto 1);
    end loop;
    return v_data;
  end function gmul;


  -- matrix columns manipulation
  function mixcolumns (input : t_datatable2d; column : natural) return t_datatable2d is
    variable v_data : t_datatable2d;
  begin
    for index in 0 to 3 loop
      v_data(index)(0) := gmul(x"02", input(index)(0)) xor gmul(x"03", input(index)(1)) xor input(index)(2) xor input(index)(3);
      v_data(index)(1) := input(index)(0) xor gmul(x"02", input(index)(1)) xor gmul(x"03",input(index)(2))  xor input(index)(3);
      v_data(index)(2) := input(index)(0) xor input(index)(1) xor gmul(x"02",input(index)(2))  xor gmul(x"03",input(index)(3));
      v_data(index)(3) := gmul(x"03", input(index)(0)) xor input(index)(1) xor input(index)(2) xor gmul(x"02",input(index)(3));
    end loop;
    return v_data;
  end function mixcolumns;


  -- matrix columns manipulation
  function invmixcolumns (input : t_datatable2d; column : natural) return t_datatable2d is
    variable v_data : t_datatable2d;
  begin
    for index in 0 to 3 loop
      v_data(index)(0) := gmul(x"0E", input(index)(0)) xor gmul(x"0B", input(index)(1)) xor gmul(x"0D", input(index)(2)) xor gmul(x"09", input(index)(3));
      v_data(index)(1) := gmul(x"09", input(index)(0)) xor gmul(x"0E", input(index)(1)) xor gmul(x"0B", input(index)(2)) xor gmul(x"0D", input(index)(3));
      v_data(index)(2) := gmul(x"0D", input(index)(0)) xor gmul(x"09", input(index)(1)) xor gmul(x"0E", input(index)(2)) xor gmul(x"0B", input(index)(3));
      v_data(index)(3) := gmul(x"0B", input(index)(0)) xor gmul(x"0D", input(index)(1)) xor gmul(x"09", input(index)(2)) xor gmul(x"0E", input(index)(3));
    end loop;
    return v_data;
  end function invmixcolumns;


  function addroundkey (input : in t_datatable2d; key : in t_key) return t_datatable2d is
    variable v_data : t_datatable2d;
    variable v_key  : t_datatable1d;
  begin
    for i in 0 to 3 loop
      v_key := (key(i)(7 downto 0), key(i)(15 downto 8), key(i)(23 downto 16), key(i)(31 downto 24));
      for j in 0 to 3 loop
        v_data(i)(j) := input(i)(j) xor v_key(j);
      end loop;
    end loop;
    return v_data;
  end function addroundkey;


  function subword (input : in t_datatable1d) return t_datatable1d is
    variable v_data : t_datatable1d;
  begin
    for i in 0 to 3 loop
      v_data(i) := c_sbox(to_integer(unsigned(input(i)(7 downto 4))))(to_integer(unsigned(input(i)(3 downto 0))));
    end loop;
    return v_data;
  end function subword;


  function rotword (input : in t_datatable1d) return t_datatable1d is
  begin
    return(input(2), input(1), input(0), input(3));
  end function rotword;


end package body aes_pkg;
