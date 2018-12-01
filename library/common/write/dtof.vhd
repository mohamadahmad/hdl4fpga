library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl4fpga;
use hdl4fpga.std.all;

entity dtof is
	port (
		clk      : in  std_logic;
		bin_frm  : in  std_logic;
		bin_irdy : in  std_logic := '1';
		bin_trdy : out std_logic;
		bin_exp  : in  std_logic_vector;
		bin_di   : in  std_logic_vector;

		mem_full  : in  std_logic;
		mem_left  : inout std_logic_vector(size-1 downto 0);
		mem_left_up  : out std_logic;
		mem_left_ena : out std_logic;
		mem_right : inout std_logic_vector(size-1 downto 0);
		mem_right_up  : out std_logic;
		mem_right_ena : out std_logic;

		mem_addr  : out std_logic_vector(size-1 downto 0);
		mem_do    : in  std_logic_vector(bcd_do'range);
		mem_di    : out std_logic_vector(vector_do'range));
end;

architecture def of dtof is

	constant up : std_logic := '1';
	constant dn : std_logic := '0';

	signal dtof_ena : std_logic;
	signal dtof_dcy : std_logic;
	signal dtof_dv  : std_logic;

	signal addr : unsigned(vector_addr'range);
begin

	dtof_e : entity hdl4fpga.dtof
	port map (
		clk     => clk,
		bcd_exp => bin_di,
		bcd_ena => dtof_ena,
		bcd_dv  => dtof_dv,
		bcd_di  => mem_do,
		bcd_do  => mem_di,
		bcd_cy  => dtof_dcy);

	addr_p : process (addr, mem_right, dtof_ena, dtof_dcy)
	begin
		if dtof_ena='1' then
			if addr = unsigned(mem_right(mem_addr'range)) then
				if dtof_dcy='1' then
					addr <= unsigned(mem_left(mem_addr'range));
				else
					addr <= unsigned(mem_left(mem_addr'range));
				end if;
			else
				addr <= addr - 1;
			end if;
		end if;
	end process;
	mem_addr <= std_logic_vector(addr);

	left_p : process(addr, mem_left, mem_di)
		variable up  : std_logic;
		variable ena : std_logic;
	begin
		updn <= '-';
		ena  <= '0';
		if addr=unsigned(mem_left(mem_addr'range)) then
			if mem_di=(mem_di'range => '0') then
				up  <= dn;
				ena <= '1';
			end if;
		end if;
		mem_left_up  <= up;
		mem_left_ena <= ena;
	end process;

	right_p : process(mem_full, dtof_dcy)
		variable up : std_logic;
		variable en : std_logic;
	begin
		up  <= '-';
		ena <= '0';
		if mem_full='0' then
			if dtof_dcy='1' then
				up  <= dn;
				ena <= '1';
			end if;
		end if;
		mem_right_up  <= updn;
		mem_right_ena <= ena;
	end process;

end;