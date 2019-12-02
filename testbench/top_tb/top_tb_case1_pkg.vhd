------------------------------------------------------------------------------
--  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Libraries
------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
library std;
	use std.textio.all;
	
library work;
	use work.psi_tb_axi_pkg.all;
	use work.psi_tb_txt_util.all;
	use work.top_tb_pkg.all;
	use work.data_rec_register_pkg.all;

------------------------------------------------------------------------------
-- Package Header
------------------------------------------------------------------------------
package top_tb_case1_pkg is

	constant CaseName_c : string := "Corner Conditions";

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t);
					
end top_tb_case1_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body top_tb_case1_pkg is

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t) is
		constant DefaultSamples_c	: integer := MemoryDepth_v*3/4;
		variable DutyCycle_v		: integer;
	begin
		-- Print Message
		print("Test: " & CaseName_c);
		
		-- Test with different duty cycles
		for d in 0 to 1 loop
			DutyCycle_v := d*10+1;
			
			-- Normal Samples, Zero Pre-Trigger
			axi_single_write(Reg_Totspl_Addr_c, DefaultSamples_c, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, 0, ms, sm, aclk);
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(MemoryDepth_v*2, ToDut, Clk, 0, MemoryDepth_v, DutyCycle_v);
			wait for 250 ns;	
			CheckData(DefaultSamples_c, MemoryDepth_v, ms, sm, aclk);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
			
			-- Normal Samples, Maximum Pre-Trigger
			axi_single_write(Reg_Totspl_Addr_c, DefaultSamples_c, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, DefaultSamples_c-1, ms, sm, aclk);
			wait for 100 ns;
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StatePreTrig_c, ms, sm, aclk, "Direct Re-Arm without PreTrig Status", 3, 0);
			InputSamples(MemoryDepth_v*2, ToDut, Clk, 0, MemoryDepth_v, DutyCycle_v);
			wait for 250 ns;	
			CheckData(DefaultSamples_c, MemoryDepth_v-DefaultSamples_c+1, ms, sm, aclk);	
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
			
			-- Only one sample (in the middle)
			axi_single_write(Reg_Totspl_Addr_c, 1, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, 0, ms, sm, aclk);	
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);	
			wait for 250 ns;		
			InputSamples(MemoryDepth_v*2, ToDut, Clk, 0, MemoryDepth_v, DutyCycle_v);
			wait for 250 ns;	
			CheckData(1, MemoryDepth_v, ms, sm, aclk);			
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
			
			-- Only one sample (first one)
			axi_single_write(Reg_Totspl_Addr_c, 1, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, 0, ms, sm, aclk);	
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);	
			wait for 250 ns;		
			InputSamples(1, ToDut, Clk, 100, 0, DutyCycle_v);
			wait for 250 ns;	
			CheckData(1, 100, ms, sm, aclk);			
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
			
			-- Normal Samples, no additional samples arrive
			axi_single_write(Reg_Totspl_Addr_c, DefaultSamples_c, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, 10, ms, sm, aclk);
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(DefaultSamples_c, ToDut, Clk, 0, 10, DutyCycle_v);
			wait for 250 ns;	
			CheckData(DefaultSamples_c, 0, ms, sm, aclk);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);		
			
			-- Maximum sample count, normal pre trigger
			axi_single_write(Reg_Totspl_Addr_c, MemoryDepth_v, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, MemoryDepth_v/2, ms, sm, aclk);
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(MemoryDepth_v*2, ToDut, Clk, 0, MemoryDepth_v, DutyCycle_v);
			wait for 250 ns;	
			CheckData(DefaultSamples_c, MemoryDepth_v-MemoryDepth_v/2, ms, sm, aclk);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);		
			
			-- Maximum sample count, max pre-trigger
			axi_single_write(Reg_Totspl_Addr_c, MemoryDepth_v, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, MemoryDepth_v-1, ms, sm, aclk);
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(MemoryDepth_v*2, ToDut, Clk, 0, MemoryDepth_v, DutyCycle_v);
			wait for 250 ns;	
			CheckData(DefaultSamples_c, 1, ms, sm, aclk);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);			
			
			-- Maximum sample count, no pre-trigger
			axi_single_write(Reg_Totspl_Addr_c, MemoryDepth_v, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, 0, ms, sm, aclk);
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(MemoryDepth_v*2, ToDut, Clk, 0, MemoryDepth_v, DutyCycle_v);
			wait for 250 ns;	
			CheckData(DefaultSamples_c, MemoryDepth_v, ms, sm, aclk);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);		
			
			-- Minimum Trigger Recording Period not respected
			axi_single_write(Reg_MinRecPeriod_Addr_c, integer((50 us)/ClockPeriod_c), ms, sm, aclk);
			axi_single_write(Reg_Totspl_Addr_c, 1, ms, sm, aclk);
			axi_single_write(Reg_Pretrig_Addr_c, 0, ms, sm, aclk);
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(10, ToDut, Clk, 0, 2);
			wait for 250 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done For first recording", 3, 0);	
			wait for 250 ns;
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 250 ns;
			InputSamples(10, ToDut, Clk, 0, 2);
			wait for 250 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "Period Not Respected", 3, 0);	-- No trigger period not respected
			wait for 50 us;
			InputSamples(10, ToDut, Clk, 0, 2);
			wait for 250 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Recording happens after period", 3, 0);	-- No trigger period not respected
			axi_single_write(Reg_MinRecPeriod_Addr_c, 0, ms, sm, aclk);
			
			
		end loop;
		
		
	end procedure;
	
	
end top_tb_case1_pkg;

