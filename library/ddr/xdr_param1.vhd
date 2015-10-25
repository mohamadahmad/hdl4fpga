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
use hdl4fpga.xdr_db.all;

package xdr_param is
	component xdr_cfg is
		generic (
			cRP  : natural := 10;
			cMRD : natural := 11;
		    cRFC : natural := 13;
		    cMOD : natural := 13;

			a  : natural := 13;
			ba : natural := 2);
		port (
			xdr_cfg_ods : in  std_logic := '0';
			xdr_cfg_rtt : in  std_logic_vector(1 downto 0) := "01";
			xdr_cfg_bl  : in  std_logic_vector(0 to 2);
			xdr_cfg_cl  : in  std_logic_vector(0 to 2);
			xdr_cfg_wr  : in  std_logic_vector(0 to 2) := (others => '0');
			xdr_cfg_cwl : in  std_logic_vector(0 to 2) := (others => '0');
			xdr_cfg_pl  : in  std_logic_vector(0 to 2) := (others => '0');
			xdr_cfg_dqsn : in std_logic := '0';

			xdr_cfg_clk : in  std_logic;
			xdr_cfg_req : in  std_logic;
			xdr_cfg_rdy : out std_logic := '1';
			xdr_cfg_dll : out std_logic := '1';
			xdr_cfg_odt : out std_logic := '0';
			xdr_cfg_ras : out std_logic := '1';
			xdr_cfg_cas : out std_logic := '1';
			xdr_cfg_we  : out std_logic := '1';
			xdr_cfg_a   : out std_logic_vector( a-1 downto 0) := (others => '1');
			xdr_cfg_b   : out std_logic_vector(ba-1 downto 0) := (others => '1'));
	end component;

--	type tmrk_ids is (ANY, M6T, M15E);
--	type tmng_ids is (ANY, tPreRST, tPstRST, tXPR, tWR, tRP, tRCD, tRFC, tMRD, tREFI);
--	type latr_ids is (ANY, CL, BL, WRL, CWL);
--	type cltabs_ids  is (STRT,  RWNT);
--	type cwltabs_ids is (WWNT, DQSZT, DQST, DQSZXT, DQZT, DQZXT);
--	type laty_ids is (ANY, cDLL, MRD, MODu, XPR, STRL, RWNL, DQSZL, DQSL, DQZL, WWNL,
--		STRXL, RWNXL, DQSZXL, DQSXL, DQZXL, WWNXL, WIDL, ZQINIT);

--	constant code_size : natural := 3;
--	subtype code_t is std_logic_vector(0 to code_size-1);
--	type cnfglat_record is record
--		stdr : positive;
--		reg  : latr_ids;
--		lat  : integer;
--		code : code_t;
--	end record;
--	type cnfglat_tab is array (natural range <>) of cnfglat_record;

	function xdr_cnfglat (
		constant stdr : positive;
		constant reg : latr_ids;
		constant lat : positive)	-- DDR1 CL must be multiplied by 2 before looking it up
		return std_logic_vector;

	function xdr_timing (
		constant timing_db : timing_tab;
		constant mark  : tmrk_ids;
		constant param : tmng_ids) 
		return natural;

	function xdr_latency (
		constant stdr   : natural;
		constant param : laty_ids;
		constant tCP  : natural :=  250;
		constant tDDR : natural := 1000;
		constant roundon : boolean := false)
		return integer;

	function xdr_query_size (
		constant stdr : natural;
		constant reg : latr_ids)
		return natural;

	function xdr_query_data (
		constant stdr : natural;
		constant reg : latr_ids)
		return cnfglat_tab;

	function xdr_stdr (
		mark : tmrk_ids) 
		return natural;

	function to_xdrlatency (
		period : natural;
		timing : natural)
		return natural;

	function to_xdrlatency (
		constant timing_db : timing_tab;
		constant period : natural;
		constant mark   : tmrk_ids;
		constant param  : tmng_ids)
		return natural;

	function xdr_lattab (
		constant stdr : natural;
		constant reg  : natural;
		constant tCP  : natural :=  250;
		constant tDDR : natural := 1000)
		return natural_vector;

	function xdr_lattab (
		constant stdr  : natural;
		constant tabid : natural;
		constant tCP   : natural :=  250;
		constant tDDR  : natural := 1000)
		return natural_vector;

	function xdr_lattab (
		constant stdr  : natural;
		constant tabid : natural;
		constant tCP   : natural :=  250;
		constant tDDR  : natural := 1000)
		return natural_vector;

	function xdr_latcod (
		constant stdr : natural;
		constant reg  : natural)
		return std_logic_vector;

	function xdr_rotval (
		constant line_size : natural;
		constant word_size : natural;
		constant lat_val : std_logic_vector;
		constant lat_cod : std_logic_vector;
		constant lat_tab : natural_vector)
		return std_logic_vector;

	function xdr_task (
		constant line_size : natural;
		constant word_size : natural;
		constant lat_val : std_logic_vector;
		constant lat_cod : std_logic_vector;
		constant lat_tab : natural_vector;
		constant lat_sch : std_logic_vector;
		constant lat_ext : natural := 0;
		constant lat_wid : natural := 1)
		return std_logic_vector;

	function xdr_selcwl (
		constant stdr : natural)
		return latr_ids;

	function xdr_combclks (
		constant iclks : std_logic_vector;
		constant iclks_phases : natural;
		constant oclks_phases : natural)
		return std_logic_vector;

	type field_desc is record
		dbase : natural;
		sbase : natural;
		size  : natural;
	end record;

	type fielddesc_vector is array (natural range <>) of field_desc;

	type ddr3_ccmd is record
		cmd  : std_logic_vector( 3 downto 0);
		bank : std_logic_vector( 2 downto 0);
		addr : natural_vector(13 downto 0);
	end record;

	subtype ddr_mr is std_logic_vector(3-1 downto 0);
	constant mrx : ddr_mr := (others => '1');
	constant mr0 : ddr_mr := "000";
	constant mr1 : ddr_mr := "001";
	constant mr2 : ddr_mr := "010";
	constant mr3 : ddr_mr := "011";
	constant mrz : ddr_mr := "100";

	type ddrmr_vector is array (natural range <>) of ddr_mr;

	type ddr_cmd is record
		cs  : std_logic;
		ras : std_logic;
		cas : std_logic;
		we  : std_logic;
	end record;

	type ddr_tid is (TMR_RST, TMR_WLC, TMR_WLDQSEN, TMR_RRDY, TMR_CKE, TMR_MRD, TMR_MOD, TMR_DLL, TMR_ZQINIT, TMR_REF);
	type ddrtid_vector is array (ddr_tid) of natural;

	constant ddr_nop : ddr_cmd := (cs => '0', ras => '1', cas => '1', we => '1');
	constant ddr_mrs : ddr_cmd := (cs => '0', ras => '0', cas => '0', we => '0');
	constant ddr_zqc : ddr_cmd := (cs => '0', ras => '1', cas => '1', we => '0');

	function round_lat (
		constant dly : natural;
		constant clk : natural) 
		return natural;

	function floor_lat (
		constant dly : natural;
		constant clk : natural) 
		return natural;

end package;

library hdl4fpga;
use hdl4fpga.std.all;

package body xdr_param is

--	type tmark_record is record
--		mark : tmrk_ids;
--		stdr  : natural;
--	end record;
--
--	type tmark_tab is array (natural range <>) of tmark_record;
--
--	constant tmark_db : tmark_tab (1 to 2) :=
--		tmark_record'(mark => M6T,  stdr => 1) &
--		tmark_record'(mark => M15E, stdr => 3);

--	type latency_record is record
--		stdr   : positive;
--		param : laty_ids;
--		value : integer;
--	end record;
--
--	type latency_tab is array (positive range <>) of latency_record;
--
--	constant latency_db : latency_tab  := 
--		latency_record'(stdr => 1, param => cDLL,  value => 200) &
--		latency_record'(stdr => 1, param => STRL,  value => 4*0) &
--		latency_record'(stdr => 1, param => RWNL,  value => 4*0) &
--		latency_record'(stdr => 1, param => DQSZL, value => 4*2) &
--		latency_record'(stdr => 1, param => DQSL,  value =>   2) &
--		latency_record'(stdr => 1, param => DQZL,  value =>   1) &
--		latency_record'(stdr => 1, param => WWNL,  value =>   1) &
--		latency_record'(stdr => 1, param => STRXL, value =>   2) &
--		latency_record'(stdr => 1, param => RWNXL, value => 4*0) &
--		latency_record'(stdr => 1, param => DQSZXL, value =>  2) &
--		latency_record'(stdr => 1, param => DQSXL, value =>   2) &
--		latency_record'(stdr => 1, param => DQZXL, value =>   1) &
--		latency_record'(stdr => 1, param => WWNXL, value =>   1) &
--		latency_record'(stdr => 1, param => WIDL,  value =>   4) &
--
--		latency_record'(stdr => 2, param => cDLL,  value => 200) &
--		latency_record'(stdr => 2, param => STRL,  value =>  -3) &
--		latency_record'(stdr => 2, param => RWNL,  value =>   8) &
--		latency_record'(stdr => 2, param => DQSZL, value =>  -8) &
--		latency_record'(stdr => 2, param => DQSL,  value =>  -2) &
--		latency_record'(stdr => 2, param => DQZL,  value =>  -7) &
--		latency_record'(stdr => 2, param => WWNL,  value =>  -3) &
--		latency_record'(stdr => 2, param => STRXL, value =>   4) &
--		latency_record'(stdr => 2, param => RWNXL, value =>   4) &
--		latency_record'(stdr => 2, param => DQSZXL, value =>  8) &
--		latency_record'(stdr => 2, param => DQSXL, value =>   4) &
--		latency_record'(stdr => 2, param => DQZXL, value =>   4) &
--		latency_record'(stdr => 2, param => WWNXL, value =>   4) &
--		latency_record'(stdr => 2, param => WIDL,  value =>   8) &
--
--		latency_record'(stdr => 3, param => cDLL,  value => 500) &
--		latency_record'(stdr => 3, param => STRL,  value => 4*0) &
--		latency_record'(stdr => 3, param => RWNL,  value => 4*2) &
--		latency_record'(stdr => 3, param => DQSL,  value =>  -4) &
--		latency_record'(stdr => 3, param => DQSZL, value =>  -4) &
--		latency_record'(stdr => 3, param => DQZL,  value =>  -4) &
--		latency_record'(stdr => 3, param => WWNL,  value =>  -8) &
--		latency_record'(stdr => 3, param => STRXL, value =>   2) &
--		latency_record'(stdr => 3, param => RWNXL, value => 4*0) &
--		latency_record'(stdr => 3, param => DQSXL, value =>   2) &
--		latency_record'(stdr => 3, param => DQSZXL, value =>  2) &
--		latency_record'(stdr => 3, param => DQZXL, value =>   4) &
--		latency_record'(stdr => 3, param => WWNXL, value =>   1) &
--		latency_record'(stdr => 3, param => ZQINIT, value =>  500) &
--		latency_record'(stdr => 3, param => MRD,   value =>   4) &
--		latency_record'(stdr => 3, param => MODu,  value =>  12) &
--		latency_record'(stdr => 3, param => XPR,   value =>   5) &
--		latency_record'(stdr => 3, param => WIDL,  value =>   8);
--
--	type timing_record is record
--		mark  : tmrk_ids;
--		param : tmng_ids;
--		value : natural;
--	end record;
--
--	type timing_tab is array (natural range <>) of timing_record;
--
--	constant timing_db : timing_tab(0 to 16-1) := 
--		timing_record'(mark => M6T,  param => tPreRST, value => 200000000) &
--		timing_record'(mark => M6T,  param => tWR,   value => 15000) &
--		timing_record'(mark => M6T,  param => tRP,   value => 15000) &
--		timing_record'(mark => M6T,  param => tRCD,  value => 15000) &
--		timing_record'(mark => M6T,  param => tRFC,  value => 72000) &
--		timing_record'(mark => M6T,  param => tMRD,  value => 12000) &
--		timing_record'(mark => M6T,  param => tREFI, value => 7000000) &
--		timing_record'(mark => M15E, param => tPreRST, value => 200000000) &
--		timing_record'(mark => M15E, param => tPstRST, value => 500000000) &
----		timing_record'(mark => M15E, param => tPreRST, value => 2000000) &
----		timing_record'(mark => M15E, param => tPstRST, value => 2000000) &
--		timing_record'(mark => M15E, param => tWR,   value => 15000) &
--		timing_record'(mark => M15E, param => tRCD,  value => 13910) &
--		timing_record'(mark => M15E, param => tRP,   value => 13910) &
--		timing_record'(mark => M15E, param => tMRD,  value => 15000) &
--		timing_record'(mark => M15E, param => tRFC,  value => 110000) &
--		timing_record'(mark => M15E, param => tXPR,  value => 110000 + 10000) &
--		timing_record'(mark => M15E, param => tREFI, value => 7800000);
--
--	constant cnfglat_db : cnfglat_tab :=
--
--		-- DDR1 standard --
--		-------------------
--
--		-- CL register --
--
--		cnfglat_record'(stdr => 1, reg => CL,  lat =>  4*2, code => "010") &
--		cnfglat_record'(stdr => 1, reg => CL,  lat =>  2*5, code => "110") &
--		cnfglat_record'(stdr => 1, reg => CL,  lat =>  4*3, code => "011") &
--
--		-- BL register --
--
--		cnfglat_record'(stdr => 1, reg => BL,  lat =>  2*2, code => "001") &
--		cnfglat_record'(stdr => 1, reg => BL,  lat =>  2*4, code => "010") &
--		cnfglat_record'(stdr => 1, reg => BL,  lat =>  2*8, code => "011") &
--
--		-- CWL register --
--
--		cnfglat_record'(stdr => 1, reg => CWL, lat =>  4*1, code => "---") &
--
--		-- DDR2 standard --
--		-------------------
--
--		-- CL register --
--
--		cnfglat_record'(stdr => 2, reg => CL,  lat =>  4*3, code => "011") &
--		cnfglat_record'(stdr => 2, reg => CL,  lat =>  4*4, code => "100") &
--		cnfglat_record'(stdr => 2, reg => CL,  lat =>  4*5, code => "101") &
--		cnfglat_record'(stdr => 2, reg => CL,  lat =>  4*6, code => "110") &
--		cnfglat_record'(stdr => 2, reg => CL,  lat =>  4*7, code => "111") &
--
--		-- BL register --
--
--		cnfglat_record'(stdr => 2, reg => BL,  lat =>  4, code => "010") &
--		cnfglat_record'(stdr => 2, reg => BL,  lat =>  8, code => "011") &
--
--		-- CWL register --
--
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*2, code => "001") &
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*3, code => "010") &
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*4, code => "011") &
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*5, code => "100") &
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*6, code => "101") &
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*7, code => "110") &
--		cnfglat_record'(stdr => 2, reg => WRL, lat =>  4*8, code => "111") &
--
--		-- DDR3 standard --
--		-------------------
--
--		-- CL register --
--
--		cnfglat_record'(stdr => 3, reg => CL, lat =>  4*5, code => "001") &
--		cnfglat_record'(stdr => 3, reg => CL, lat =>  4*6, code => "010") &
--		cnfglat_record'(stdr => 3, reg => CL, lat =>  4*7, code => "011") &
--		cnfglat_record'(stdr => 3, reg => CL, lat =>  4*8, code => "100") &
--		cnfglat_record'(stdr => 3, reg => CL, lat =>  4*9, code => "101") &
--		cnfglat_record'(stdr => 3, reg => CL, lat => 4*10, code => "110") &
--		cnfglat_record'(stdr => 3, reg => CL, lat => 4*11, code => "111") &
--
--		-- BL register --
--
--		cnfglat_record'(stdr => 3, reg => BL, lat => 2*8, code => "000") &
--		cnfglat_record'(stdr => 3, reg => BL, lat => 2*8, code => "001") &
--		cnfglat_record'(stdr => 3, reg => BL, lat => 2*8, code => "010") &
--
--		-- WRL register --
--
--		cnfglat_record'(stdr => 3, reg => WRL, lat =>  4*5, code => "001") &
--		cnfglat_record'(stdr => 3, reg => WRL, lat =>  4*6, code => "010") &
--		cnfglat_record'(stdr => 3, reg => WRL, lat =>  4*7, code => "011") &
--		cnfglat_record'(stdr => 3, reg => WRL, lat =>  4*8, code => "100") &
--		cnfglat_record'(stdr => 3, reg => WRL, lat => 4*10, code => "101") &
--		cnfglat_record'(stdr => 3, reg => WRL, lat => 4*12, code => "110") &
--
--		-- CWL register --
--
--		cnfglat_record'(stdr => 3, reg => CWL, lat =>  4*5, code => "000") &
--		cnfglat_record'(stdr => 3, reg => CWL, lat =>  4*6, code => "001") &
--		cnfglat_record'(stdr => 3, reg => CWL, lat =>  4*7, code => "010") &
--		cnfglat_record'(stdr => 3, reg => CWL, lat =>  4*8, code => "011");
--
	function xdr_cnfglat (
		constant stdr : positive;
		constant reg : latr_ids;
		constant lat : positive)	-- DDR1 CL must be multiplied by 2 before looking up
		return std_logic_vector is
	begin
		for i in cnfglat_db'range loop
			if cnfglat_db(i).stdr = stdr then
				if cnfglat_db(i).reg = reg then
					if cnfglat_db(i).lat = lat then
						return cnfglat_db(i).code;
					end if;
				end if;
			end if;
		end loop;

		return "XXX";
	end;

	function xdr_timing (
		constant timing_db : timing_tab;
		constant mark  : tmrk_ids;
		constant param : tmng_ids) 
		return natural is
	begin
		for i in timing_db'range loop
			if timing_db(i).mark = mark then
				if timing_db(i).param = param then
					return timing_db(i).value;
				end if;
			end if;
		end loop;

		return 0;
	end;

	function xdr_latency (
		constant stdr   : natural;
		constant param : laty_ids; 
		constant tCP  : natural :=  250;
		constant tDDR : natural := 1000;
		constant roundon : boolean := false)
		return integer is
		variable msg : line;
	begin
		for i in latency_db'range loop
			if latency_db(i).stdr = stdr then
				if latency_db(i).param = param then
					if roundon then
						if (latency_db(i).value*tDDR) mod (4*tCP) = 0  then
							return (latency_db(i).value*tDDR)/(4*tCP);
						else
							return (latency_db(i).value*tDDR)/(4*tCP)+1;
						end if;
					else
						return (latency_db(i).value*tDDR)/(4*tCP);
					end if;
				end if;
			end if;
		end loop;

		return 0;
	end;

	function to_xdrlatency (
		period : natural;
		timing : natural)
		return natural is
	begin
		if (timing/period)*period < timing then
			return (timing+period)/period;
		else
			return timing/period;
		end if;
	end;

	function to_xdrlatency (
		constant timing_db : timing_tab;
		constant period : natural;
		constant mark   : tmrk_ids;
		constant param  : tmng_ids)
		return natural is
	begin
		return to_xdrlatency(period, xdr_timing(timing_db, mark, param));
	end;

	function xdr_query_size (
		constant stdr : natural;
		constant reg : latr_ids)
		return natural is
		variable val : natural := 0;
	begin
		for i in cnfglat_db'range loop
			if cnfglat_db(i).stdr = stdr then
				if cnfglat_db(i).reg = reg then
					val := val + 1;
				end if;
			end if;
		end loop;
		return val;
	end;

	function xdr_query_data (
		constant stdr : natural;
		constant reg : latr_ids)
		return cnfglat_tab is
		constant query_size : natural := xdr_query_size(stdr, reg);
		variable query_data : cnfglat_tab (1 to query_size);
		variable query_row  : natural := 0;
	begin
		for i in cnfglat_db'range loop
			if cnfglat_db(i).stdr = stdr then
				if cnfglat_db(i).reg = reg then
					query_row := query_row + 1;
					query_data(query_row) := cnfglat_db(i);
				end if;
			end if;
		end loop;
		return query_data;
	end;

	function xdr_lattab (
		constant stdr : natural;
		constant reg : latr_ids;
		constant tCP  : natural :=  250;
		constant tDDR : natural := 1000)
		return natural_vector is
		constant query_size : natural := xdr_query_size(stdr, reg);
		constant query_data : cnfglat_tab(0 to query_size-1) := xdr_query_data(stdr, reg);
		variable lattab : natural_vector(0 to query_size-1);
	begin
		for i in lattab'range loop
			lattab(i) := (query_data(i).lat*tDDR)/(4*tCP);
		end loop;
		return lattab;
	end;

	function xdr_lattab (
		constant stdr : natural;
		constant tabid : cltabs_ids;
		constant tCP  : natural :=  250;
		constant tDDR : natural := 1000)
		return natural_vector is

		type latid_vector is array (cltabs_ids) of laty_ids;
		constant tab2laty : latid_vector := (STRT => STRL, RWNT => RWNL);

		constant lat : integer := xdr_latency(stdr, tab2laty(tabid));
		constant tab : natural_vector := xdr_lattab(stdr, CL, tDDR, 4*tDDR);
		variable val : natural_vector(tab'range);

	begin
		for i in tab'range loop
			val(i) := ((tab(i)+lat)*tDDR)/(4*tCP);
		end loop;
		return val;
	end;

	function xdr_lattab (
		constant stdr   : natural;
		constant tabid : cwltabs_ids;
		constant tCP  : natural :=  250;
		constant tDDR : natural := 1000)
		return natural_vector is

		type latid_vector is array (cwltabs_ids) of laty_ids;
		constant tab2laty : latid_vector := (WWNT => WWNL, DQSZT => DQSZL, DQST => DQSL, DQSZXT => DQSZXL, DQZT => DQZL, DQZXT => DQZXL);

		variable lat    : integer := xdr_latency(stdr, tab2laty(tabid));
		constant cltab  : natural_vector := xdr_lattab(stdr, CL);
		variable clval  : natural_vector(cltab'range);
		variable aux : natural;
		constant cwltab : natural_vector := xdr_lattab(stdr, CWL);
		variable cwlval : natural_vector(cwltab'range);
		variable latx   : integer := 0;

		variable mesg : line;
	begin
		if stdr = 2 then
			for i in cltab'range loop
				clval(i) := ((cltab(i)+lat-4)*tDDR)/(4*tCP);
			end loop;
			return clval;
		else
			case tabid is
			when DQZXT =>
				latx := lat;
				lat  := xdr_latency(stdr, DQZXL);
				for i in cwltab'range loop
					aux := ((cwltab(i)+lat )*tDDR) mod (4*tCP);
					cwlval(i) := (latx*tDDR+aux+4*tCP-1) / (4*tCP);
				end loop;
			when DQSZXT =>
				latx := lat;
				lat  := xdr_latency(stdr, DQSZXL);
				for i in cwltab'range loop
					aux := ((cwltab(i)+lat )*tDDR) mod (4*tCP);
					cwlval(i) := (latx*tDDR+aux+4*tCP-1) / (4*tCP);
				end loop;
			when others =>
				for i in cwltab'range loop
					cwlval(i) := ((cwltab(i)+lat)*tDDR)/(4*tCP);
				end loop;
			end case;
			return cwlval;
		end if;
	end;

	function xdr_latcod (
		constant stdr : natural;
		constant reg : latr_ids)
		return std_logic_vector is
		constant query_size : natural := xdr_query_size(stdr, reg);
		constant query_data : cnfglat_tab(0 to query_size-1) := xdr_query_data(stdr, reg);
		variable latcode : std_logic_vector(0 to code_size*query_size-1);
	begin
		for i in query_data'reverse_range loop
			latcode := latcode srl code_size;
			latcode(code_t'range) := query_data(i).code;
		end loop;
		return latcode;
	end;

	function xdr_rotval (
		constant line_size : natural;
		constant word_size : natural;
		constant lat_val : std_logic_vector;
		constant lat_cod : std_logic_vector;
		constant lat_tab : natural_vector)
		return std_logic_vector is

		subtype word is std_logic_vector(unsigned_num_bits(line_size/word_size-1)-1 downto 0);
		type word_vector is array(natural range <>) of word;
		
		subtype latword is std_logic_vector(0 to lat_val'length-1);
		type latword_vector is array (natural range <>) of latword;

		constant algn : natural := unsigned_num_bits(word_size-1);
		
		function to_latwordvector(
			constant arg : std_logic_vector)
			return latword_vector is
			variable aux : std_logic_vector(0 to arg'length-1) := arg;
			variable val : latword_vector(0 to arg'length/latword'length-1);
		begin
			for i in val'range loop
				val(i) := aux(latword'range);
				aux := aux sll latword'length;
			end loop;
			return val;
		end;

		function select_lat (
			constant lat_val : std_logic_vector;
			constant lat_cod : latword_vector;
			constant lat_sch : word_vector)
			return std_logic_vector is
			variable val : word;
		begin
			val := (others => '-');
			for i in 0 to lat_tab'length-1 loop
				if lat_val = lat_cod(i) then
					for j in word'range loop
						val(j) := lat_sch(i)(j);
					end loop;
				end if;
			end loop;
			return val;
		end;
		
		constant lc   : latword_vector := to_latwordvector(lat_cod);
		
		variable sel_sch : word_vector(lc'range);
		variable val : std_logic_vector(unsigned_num_bits(line_size-1)-1 downto 0) := (others => '0');
		variable disp : natural;
		variable msg : line;

	begin

		setup_l : for i in 0 to lat_tab'length-1 loop
	--        sel_sch(i) := to_unsigned((line_size/word_size-(lat_tab(i) mod (line_size/word_size)) mod (line_size/word_size)), word'length);
			sel_sch(i) := to_unsigned(lat_tab(i) mod (line_size/word_size), word'length);
	--		write (msg, sel_sch(i));
	--		write (msg, lat_tab(i));
	--		writeline (output, msg);
		end loop;
	--	report "termine"
	--	severity FAILURE;
		
		val(word'range) := select_lat(lat_val, lc, sel_sch);
		val := std_logic_vector'(unsigned(val) sll algn);
		return val;
	end;

	function xdr_task (
		constant line_size : natural;
		constant word_size : natural;
		constant lat_val : std_logic_vector;
		constant lat_cod : std_logic_vector;
		constant lat_tab : natural_vector;
		constant lat_sch : std_logic_vector;
		constant lat_ext : natural := 0;
		constant lat_wid : natural := 1)
		return std_logic_vector is

		subtype word is std_logic_vector(0 to line_size/word_size-1);
		type word_vector is array (natural range <>) of word;

		subtype latword is std_logic_vector(0 to lat_val'length-1);
		type latword_vector is array (natural range <>) of latword;

		function to_latwordvector(
			constant arg : std_logic_vector)
			return latword_vector is
			variable aux : std_logic_vector(0 to arg'length-1) := arg;
			variable val : latword_vector(0 to arg'length/latword'length-1);
		begin
			for i in val'range loop
				val(i) := aux(latword'range);
				aux := aux sll latword'length;
			end loop;
			return val;
		end;

		function select_lat (
			constant lat_val : std_logic_vector;
			constant lat_cod : latword_vector;
			constant lat_sch : word_vector)
			return std_logic_vector is
			variable val : word;
		begin
			val := (others => '-');
			for i in 0 to lat_tab'length-1 loop
				if lat_val = lat_cod(i) then
					for j in word'range loop
						val(j) := lat_sch(i)(j);
					end loop;
				end if;
			end loop;
			return val;
		end;

		constant lat_cod1 : latword_vector := to_latwordvector(lat_cod);
		variable sel_sch : word_vector(lat_cod1'range);

	begin
		sel_sch := (others => (others => '-'));
		for i in 0 to lat_tab'length-1 loop
			sel_sch(i) := pulse_delay (
				phase     => lat_sch,
				latency   => lat_tab(i),
				word_size => word'length,
				extension => lat_ext,
				width     => lat_wid);
		end loop;
		return select_lat(lat_val, lat_cod1, sel_sch);
	end;

	function xdr_selcwl (
		constant stdr : natural)
		return latr_ids is
	begin
		if stdr = 2 then
			return CL;
		else
			return CWL;
		end if;
	end;

	function xdr_combclks (
		constant iclks : std_logic_vector;
		constant iclks_phases : natural;
		constant oclks_phases : natural)
		return std_logic_vector is
		variable aux : std_logic_vector(0 to iclks'length-1) := iclks;
		variable val : std_logic_vector(0 to iclks'length/(iclks_phases/oclks_phases)-1);
	begin
		for i in val'range loop
			val(i) := aux(i*(iclks_phases/oclks_phases));
		end loop;
		return val;
	end;

	-- DDR init

	function mov (
		constant desc : field_desc)
		return natural_vector is
		variable tab : natural_vector(13 downto 0) := (others => 0);
	begin
		for j in 0 to desc.size-1 loop
			tab(desc.dbase+j) := desc.sbase+j;
		end loop;
		return tab;
	end function;

	function max (
		constant desc : fielddesc_vector)
		return natural is
		variable val : natural := 0;
	begin
		for i in desc'range loop
			if desc(i).dbase > val then
				val := desc(i).dbase;
			end if;
		end loop;
		return val;
	end;

	function min (
		constant desc : fielddesc_vector)
		return natural is
		variable val : natural := 0;
	begin
		for i in desc'range loop
			if desc(i).dbase < val then
				val := desc(i).dbase;
			end if;
		end loop;
		return val;
	end;

	function mov (
		constant desc : fielddesc_vector)
		return natural_vector is
		variable val : natural_vector(13 downto 0) := (others => 0);
		variable aux : natural_vector(val'range) := (others => 0);
		variable msg : line;
	begin
		for i in desc'range loop
			aux := mov(desc(i));
			for j in aux'range loop
				if aux(j) > 1 then
					val(j) := aux(j);
				end if;
			end loop;
		end loop;
--			for k in aux'range loop
--				write (msg, val(k));
--				write (msg, string'(","));
--			end loop;
--			writeline (output, msg);
--			report "val"
--			severity failure;
		return val;
	end function;

	function round_lat (
		constant dly : natural;
		constant clk : natural) 
		return natural is
	begin
		return (dly+clk-1)/clk;
	end;

	function floor_lat (
		constant dly : natural;
		constant clk : natural) 
		return natural is
	begin
		return dly/clk;
	end;

end package body;
