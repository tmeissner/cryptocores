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
    accept_o    : out std_logic;
    data_o      : out std_logic_vector(0 TO 127);  -- data output
    valid_o     : out std_logic;                   -- output data valid flag
    accept_i    : in  std_logic
  );
end entity aes;



architecture rtl of aes is


  signal s_fsm_state : t_rounds;
  signal s_aes_state : t_datatable2d;
  signal s_accept : std_logic;
  signal s_key_sched_done : boolean;


begin


  KeySchedP : process (reset_i, clk_i) is
  begin

  end process KeySchedP;


  AesIter: process (reset_i, clk_i) is
    variable v_mode      : std_logic;
    variable v_round_cnt : t_rounds;
    variable v_key       : t_key;
  begin
    if(reset_i = '0') then
      s_accept    <= '1';
      data_o      <= (others => '0');
      valid_o     <= '0';
      v_mode      := '0';
      v_key       := (others => (others => '0'));
      v_round_cnt := t_rounds'low;
    elsif rising_edge(clk_i) then
      FsmC : case s_fsm_state is

        when 0 =>
          if(s_accept = '1' and valid_i = '1') then
            v_mode := mode_i;
          end if;

      end case FsmC;
    end if;
  end process AesIter;


  accept_o <= s_accept;


end architecture rtl;
