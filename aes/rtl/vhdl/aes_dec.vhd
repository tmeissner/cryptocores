-- ======================================================================
-- AES encryption/decryption
-- Copyright (C) 2019 Torsten Meissner
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



entity aes_dec is
  generic (
    design_type : string := "ITER"
  );
  port (
    reset_i     : in  std_logic;                   -- async reset
    clk_i       : in  std_logic;                   -- clock
    key_i       : in  std_logic_vector(0 to 127);  -- key input
    data_i      : in  std_logic_vector(0 to 127);  -- data input
    valid_i     : in  std_logic;                   -- input key/data valid flag
    accept_o    : out std_logic;
    data_o      : out std_logic_vector(0 to 127);  -- data output
    valid_o     : out std_logic;                   -- output data valid flag
    accept_i    : in  std_logic
  );
end entity aes_dec;



architecture rtl of aes_dec is


  -- Fixed round keys for verification until key schedule is implemented
  type t_key_array is array (11 downto 1) of t_key;
  constant c_round_keys : t_key_array := (
    (x"2b7e1516", x"28aed2a6", x"abf71588", x"09cf4f3c"),
    (x"a0fafe17", x"88542cb1", x"23a33939", x"2a6c7605"),
    (x"f2c295f2", x"7a96b943", x"5935807a", x"7359f67f"),
    (x"3d80477d", x"4716fe3e", x"1e237e44", x"6d7a883b"),
    (x"ef44a541", x"a8525b7f", x"b671253b", x"db0bad00"),
    (x"d4d1c6f8", x"7c839d87", x"caf2b8bc", x"11f915bc"),
    (x"6d88a37a", x"110b3efd", x"dbf98641", x"ca0093fd"),
    (x"4e54f70e", x"5f5fc9f3", x"84a64fb2", x"4ea6dc4f"),
    (x"ead27321", x"b58dbad2", x"312bf560", x"7f8d292f"),
    (x"ac7766f3", x"19fadc21", x"28d12941", x"575c006e"),
    (x"d014f9a8", x"c9ee2589", x"e13f0cc8", x"b6630ca6")
  );
  signal s_round_key : t_key := (others => (others => '0'));


begin


  -- psl default clock is rising_edge(Clk_i);


  IterG : if design_type = "ITER" generate


    signal s_round : t_dec_rounds;


  begin


    s_round_key <= c_round_keys(s_round) when s_round >= 1 and s_round <= 11 else
                   (others => (others => '0'));

    DeCryptP : process (reset_i, clk_i) is
      variable v_state : t_datatable2d;
    begin
      if (reset_i = '0') then
        v_state  := (others => (others => (others => '0')));
        s_round  <= 0;
        accept_o <= '0';
        data_o   <= (others => '0');
        valid_o  <= '0';
      elsif (rising_edge(clk_i)) then
        case s_round is

          when 0 =>
            accept_o <= '1';
            if (accept_o = '1' and valid_i = '1') then
              accept_o <= '0';
              v_state  := set_state(data_i);
              s_round  <= s_round + 1;
            end if;

          when 1 =>
            v_state := addroundkey(v_state, s_round_key);
            s_round <= s_round + 1;

          when t_dec_rounds'high-1 =>
            v_state := invshiftrow(v_state);
            v_state := invsubbytes(v_state);
            v_state := addroundkey(v_state, s_round_key);
            s_round <= s_round + 1;
            -- set data & valid to save one cycle
            valid_o <= '1';
            data_o  <= get_state(v_state);

          when t_dec_rounds'high =>
            if (valid_o = '1' and accept_i = '1') then
              valid_o <= '0';
              data_o  <= (others => '0');
              s_round <= 0;
              -- Set accept to save one cycle
              accept_o <= '1';
            end if;

          when others =>
            v_state := invshiftrow(v_state);
            v_state := invsubbytes(v_state);
            v_state := addroundkey(v_state, s_round_key);
            v_state := invmixcolumns(v_state);
            s_round <= s_round + 1;

        end case;
      end if;
    end process DeCryptP;


    -- synthesis off
    verification : block is

      signal s_data : std_logic_vector(0 to 127);

    begin

      s_data <= data_o  when rising_edge(clk_i) else
                128x"0" when reset_i = '0';

      -- psl cover accept_o;
      -- psl assert always (accept_o -> s_round = 0);

      -- psl cover valid_i and accept_o;
      -- psl assert always (valid_i and accept_o -> next not accept_o);

      -- psl cover valid_o;
      -- psl assert always (valid_o -> s_round = t_dec_rounds'high);

      -- psl cover valid_o and accept_i;
      -- psl assert always (valid_o and accept_i -> next not valid_o);

      -- psl cover valid_o and not accept_i;
      -- psl assert always (valid_o and not accept_i -> next valid_o);
      -- psl assert always (valid_o and not accept_i -> next data_o = s_data);

    end block verification;
    -- synthesis on


  end generate IterG;
  


end architecture rtl;
