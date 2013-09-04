library ieee;
use ieee.std_logic_1164.all;

entity ddr_io_dq is
	generic (
		debug_delay : time := 0 ps;
		data_bytes : natural;
		byte_bits  : natural);
	port (
		ddr_io_clk : in std_logic := '0';
		ddr_io_dqz : in std_logic_vector(data_bytes-1 downto 0);
		ddr_io_dq_r : in std_logic_vector(data_bytes*byte_bits-1 downto 0);
		ddr_io_dq_f : in std_logic_vector(data_bytes*byte_bits-1 downto 0);
		ddr_io_dq  : inout std_logic_vector(data_bytes*byte_bits-1 downto 0);
		ddr_io_dqi : out std_logic_vector(data_bytes*byte_bits-1 downto 0));
end;

library ecp3;
use ecp3.components.all;

architecture ecp3ea of ddr_io_dq is
	attribute oddrapps : string;
	attribute oddrapps of oddrdq : label is "SCLK_ALIGNED";
begin
	bytes_g : for i in data_bytes-1 downto 0 generate
		bits_g : for j in byte_bits/2-1 downto 0 generate
			signal dqo : std_logic;
			signal dqz : std_logic;
			signal di : std_logic;
		begin

			--process (ddr_io_clk)
			--begin
				--if rising_edge(ddr_io_clk) then
					--dqz <= ddr_io_dqz(i);
				--end if;
			--end process;

			oddrt_i : ofd1s3ax
			port map (
				sclk => ddr_io_clk,
				d => ddr_io_dqz(i),
				q => dqz);

			oddrdq : oddrxd1
			port map (
				sclk => ddr_io_clk,
				da => ddr_io_dq_r(i*byte_bits+j),
				db => ddr_io_dq_f(i*byte_bits+j),
				q  => dqo);

			ddr_io_dq(i*byte_bits+j)  <= 'Z' when dqz='1' else dqo;
			ddr_io_dqi(i*byte_bits+j) <= ddr_io_dq(i*byte_bits+j);
		end generate;
	end generate;
end;
