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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl4fpga;

architecture ftod of testbench is

	signal rst : std_logic := '0';
	signal clk : std_logic := '0';

	signal bin_cnv : std_logic;
	signal bin_dv  : std_logic;
	signal bin_irdy  : std_logic;
	signal bin_di  : std_logic_vector(0 to 4-1);
	signal bcd_do  : std_logic_vector(0 to 4-1);

begin
	rst <= '1', '0' after 15 ns;
	clk <= not clk after 10 ns;

	process (clk)
		variable bin : unsigned(0 to 4*4-1);
	begin
		if rising_edge(clk) then
			if rst='1' then
				bin_cnv <= '0';
				bin     := x"10f5";
				bin_irdy <= '1';
			else
				bin_cnv <= '1';
				if bin_dv='1' then
					bin     := bin sll 4;
				end if;
				bin_irdy <= not bin_cnv or bin_dv;
			end if;
			bin_di <= std_logic_vector(bin(bin_di'range));
		end if;
	end process;

	du : entity hdl4fpga.ftod
	port map (
		clk      => clk,
		bin_frm  => bin_cnv,
		bin_trdy => bin_dv,
		bin_irdy => bin_irdy,
		bin_di   => bin_di,
		bin_exp  => b"1",
		bcd_do   => bcd_do);

end;