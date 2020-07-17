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


begin


  IterG : if design_type = "ITER" generate


    signal s_round : t_dec_rounds;


  begin


    DeCryptP : process (reset_i, clk_i) is
      variable v_state      : t_datatable2d;
      type t_key_array is array (0 to 10) of t_key;
      variable v_round_keys : t_key_array;
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
              v_round_keys(0) := set_key(key_i);
              for i in t_key_rounds'low to t_key_rounds'high loop
                v_round_keys(i+1) := key_round(v_round_keys(i), i);
              end loop;
              s_round  <= s_round + 1;
            end if;

          when 1 =>
            v_state := addroundkey(v_state, v_round_keys(v_round_keys'length-s_round));
            s_round <= s_round + 1;

          when t_dec_rounds'high-1 =>
            v_state := invshiftrow(v_state);
            v_state := invsubbytes(v_state);
            v_state := addroundkey(v_state, v_round_keys(v_round_keys'length-s_round));
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
            v_state := addroundkey(v_state, v_round_keys(v_round_keys'length-s_round));
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

      default clock is rising_edge(Clk_i);

      cover {accept_o};
      assert always (accept_o -> s_round = 0);

      cover {valid_i and accept_o};
      assert always (valid_i and accept_o -> next not accept_o);

      cover {valid_o};
      assert always (valid_o -> s_round = t_dec_rounds'high);

      cover {valid_o and accept_i};
      assert always (valid_o and accept_i -> next not valid_o);

      cover {valid_o and not accept_i};
      assert always (valid_o and not accept_i -> next valid_o);
      assert always (valid_o and not accept_i -> next data_o = s_data);

    end block verification;
    -- synthesis on


  end generate IterG;



end architecture rtl;

