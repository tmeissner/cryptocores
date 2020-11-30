-- ======================================================================
-- AES Counter mode testbench
-- Copyright (C) 2020 Torsten Meissner
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

library osvvm;
  use osvvm.RandomPkg.all;

use std.env.all;


entity tb_ctraes is
end entity tb_ctraes;


architecture sim of tb_ctraes is


  constant C_NONCE_WIDTH : natural range 64 to 96 := 96;


  signal s_reset    : std_logic := '0';
  signal s_clk      : std_logic := '0';

  signal s_start    : std_logic := '0';
  signal s_nonce    : std_logic_vector(0 to C_NONCE_WIDTH-1) := (others => '0');
  signal s_key      : std_logic_vector(0 to 127) := (others => '0');
  signal s_datain   : std_logic_vector(0 to 127) := (others => '0');
  signal s_validin  : std_logic := '0';
  signal s_acceptin : std_logic;

  signal s_dataout   : std_logic_vector(0 to 127);
  signal s_validout  : std_logic := '0';
  signal s_acceptout : std_logic := '0';


begin


  i_ctraes : entity work.ctraes
  generic map (
    NONCE_WIDTH => C_NONCE_WIDTH
  )
  port map (
    reset_i  => s_reset,
    clk_i    => s_clk,
    start_i  => s_start,
    nonce_i  => s_nonce,
    key_i    => s_key,
    data_i   => s_datain,
    valid_i  => s_validin,
    accept_o => s_acceptin,
    data_o   => s_dataout,
    valid_o  => s_validout,
    accept_i => s_acceptout
  );


  s_clk   <= not(s_clk) after 10 ns;
  s_reset <= '1' after 100 ns;


  process is
    variable v_random  : RandomPType;
  begin
    v_random.InitSeed(v_random'instance_name);
    wait until s_reset = '1' and rising_edge(s_clk);
    -- ENCRYPTION TESTs
    report "Test encryption";
    for i in 0 to 31 loop
      if (i = 0) then
        s_start <= '1';
        s_nonce <= v_random.RandSlv(s_nonce'length);
      else
        s_start <= '0';
      end if;
      s_validin <= '1';
      s_key     <= v_random.RandSlv(128);
      s_datain  <= v_random.RandSlv(128);
      report "Test #" & to_string(i);
      wait until s_acceptin = '1' and rising_edge(s_clk);
      s_validin <= '0';
    end loop;
    -- Watchdog
    wait for 1 us;
    report "Watchdog error"
      severity failure;
  end process;


  process is
  begin
    s_acceptout <= '0';
    for i in 0 to 31 loop
    wait until s_validout = '1' and rising_edge(s_clk);
      s_acceptout <= '1';
      wait until rising_edge(s_clk);
      s_acceptout <= '0';
    end loop;
    report "Tests finished";
    wait for 100 ns;
    finish(0);
  end process;


end architecture sim;
