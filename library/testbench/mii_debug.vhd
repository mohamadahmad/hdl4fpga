--                                                                            --
-- Author(s):                                                                 --
--   Miguel Angel Sagreras                                                    --
--                                                                            --
-- Copyright (C) 2015                                                         --
--    Miguel Angel Sagreras                                                   --
--                                                                            --
-- This source file may be used and distributed without restriction provided  --
-- that this copyright statement is not removed from the file and that any    --
-- derivative work contains  the original copyright notice and the associated --
-- disclaimer.                                                                --
--                                                                            --
-- This source file is free software; you can redistribute it and/or modify   --
-- it under the terms of the GNU General Public License as published by the   --
-- Free Software Foundation, either version 3 of the License, or (at your     --
-- option) any later version.                                                 --
--                                                                            --
-- This source is distributed in the hope that it will be useful, but WITHOUT --
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      --
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for   --
-- more details at http://www.gnu.org/licenses/.                              --
--                                                                            --

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library hdl4fpga;
use hdl4fpga.std.all;

architecture mii_debug of testbench is
	signal rst  : std_logic := '1';
	signal clk  : std_logic := '1';
	signal rxd  : std_logic_vector(0 to 4-1);
	signal rxdv : std_logic;
	signal treq : std_logic;
	signal txd  : std_logic_vector(0 to 4-1);

begin

	clk <= not clk after 5 ns;
	rst <= '1', '0' after 20 ns;

	process (clk)
	begin
		if rising_edge(clk) then
			treq <= '1';
			if rst='1' then
				treq <= '0';
			end if;
		end if;
	end process;

	
	miipkt_e : entity hdl4fpga.mii_mem
	generic map (
		mem_data => reverse(
			x"55555555555555db" &
			x"004000010203",
			8))
	port map (
		mii_txc  => clk,
		mii_treq => treq,
		mii_trdy => open,
		mii_txen => rxdv,
		mii_txd  => rxd);

	du : entity hdl4fpga.mii_debug
	port map (
        mii_rxc  => clk,
		mii_rxdv => rxdv,
		mii_rxd  => rxd,

        mii_txc  => clk,
		mii_txd  => txd,
		mii_req  => '0',
	
		video_clk => '0');
end;
