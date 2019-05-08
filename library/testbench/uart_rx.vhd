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

architecture uart_rx of testbench is
	constant n : natural := 2;

	signal rst       : std_logic := '1';
	signal clk       : std_logic := '1';
	signal xclk      : std_logic := '1';

	signal uart_rxc  : std_logic;
	signal uart_sin  : std_logic;
	signal uart_rxdv : std_logic;
	signal uart_rxd  : std_logic_vector(8-1 downto 0);

	constant mesg : string := "hello world hola mundo";

begin

	rst  <= '1', '0' after 100 ns;
	clk  <= not clk after 10 ns;
	xclk <= not xclk after 1000000000 ns/(2*2500*1000);

	process (rst, xclk)
		variable data : unsigned(mesg'length*10-1 downto 0);
	begin
		if rst='1' then
			for i in mesg'range loop
				data(10-1 downto 0) := to_unsigned(character'pos(mesg(i)),8) & b"01";
				data := data ror 10;
			end loop;
		elsif rising_edge(xclk) then
			data := data ror 1;
		end if;
		uart_sin <= data(0);
	end process;

	process (clk)
		constant period : natural := 50000000/(2**n*2500*1000);
		variable cntr   : unsigned(0 to unsigned_num_bits(period-1)-1) := (others => '0');
	begin
		if rising_edge(clk) then
			if cntr < (period/2) then
				uart_rxc <= '0';
			else
				uart_rxc <= '1';
			end if;

			if cntr < period-1 then
				cntr := cntr + 1;
			else
				cntr := (others => '0');
			end if;
		end if;
	end process;

	uartrx_e : entity hdl4fpga.uart_rx
	generic map (
		bit_rate => n)
	port map (
		uart_rxc  => uart_rxc,
		uart_sin  => uart_sin,
		uart_rxdv => uart_rxdv,
		uart_rxd  => uart_rxd);

	process (rst, uart_rxc)
		variable data : unsigned(mesg'length*8-1 downto 0);
	begin
		if rst='1' then
			for i in mesg'range loop
				data(8-1 downto 0) := to_unsigned(character'pos(mesg(i)),8);
				data := data ror 8;
			end loop;
		elsif rising_edge(uart_rxc) then
			if uart_rxdv='1' then
				assert uart_rxd=std_logic_vector(data(8-1 downto 0))
					report "DATA ERROR"
					severity FAILURE;
				data := data ror 8;
			end if;
		end if;
	end process;

end;