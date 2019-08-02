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
package top_tb_case2_pkg is

	constant CaseName_c : string := "Self Triggered Mode";

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t);
					
end top_tb_case2_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body top_tb_case2_pkg is

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t) is
		constant SampleCount_c		: integer := 3;
		constant PreTrigger_c		: integer := 1;
		variable lastDoneCheck		: time;
	begin
		-- Print Message
		print("Test: " & CaseName_c);
		lastDoneCheck := now;
		
		-- Common configuration
		axi_single_write(Reg_Totspl_Addr_c, SampleCount_c, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, PreTrigger_c, ms, sm, aclk);
		axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_SelfIdx_c, ms, sm, aclk);	
		
		-- Ch0 only, exit, no signedness
		axi_single_write(Reg_SelftrigLo_Addr_c, -5, ms, sm, aclk);
		axi_single_expect(Reg_SelftrigLo_Addr_c, -5, ms, sm, aclk, "Selftrig-Lo Readback Neg", 31, 0, true);
		axi_single_write(Reg_SelftrigLo_Addr_c, 5, ms, sm, aclk);
		axi_single_expect(Reg_SelftrigLo_Addr_c, 5, ms, sm, aclk, "Selftrig-Lo Readback Pos");
		axi_single_write(Reg_SelftrigHi_Addr_c, -10, ms, sm, aclk);
		axi_single_expect(Reg_SelftrigHi_Addr_c, -10, ms, sm, aclk, "Selftrig-Hi Readback Neg", 31, 0, true);
		axi_single_write(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk);
		axi_single_expect(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk, "Selftrig-Hi Readback Pos");
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_ExitSft_c, ms, sm, aclk);
		axi_single_expect(Reg_SelftrigCfg_Addr_c, 1*2**0, ms, sm, aclk, "Selftrig-Cfg Readback - ENA", 7, 0);
		axi_single_expect(Reg_SelftrigCfg_Addr_c, 1, ms, sm, aclk, "Selftrig-Cfg Readback - EXIT", Reg_SelftrigCfg_ExitSft_c, Reg_SelftrigCfg_ExitSft_c);
		axi_single_expect(Reg_SelftrigCfg_Addr_c, 0, ms, sm, aclk, "Selftrig-Cfg Readback - ENTER", Reg_SelftrigCfg_EnterSft_c, Reg_SelftrigCfg_EnterSft_c);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 300 ns;
		assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;			-- done is only checked on first self-trigger
		lastDoneCheck := now;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, 0, 1, 1);
		wait for 100 ns;	
		assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;			-- done is only checked on first self-trigger
		lastDoneCheck := now;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 10, 1, 1, ms, sm, aclk);
		
		-- ch2 only, exit, no signedness
		axi_single_write(Reg_SelftrigLo_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**2+2**Reg_SelftrigCfg_ExitSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, 0, 1, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 10-2, 1, 1, ms, sm, aclk);	
		
		-- Ch0 only, enter, no signedness
		axi_single_write(Reg_SelftrigLo_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_EnterSft_c, ms, sm, aclk);
		axi_single_expect(Reg_SelftrigCfg_Addr_c, 0, ms, sm, aclk, "Selftrig-Cfg Readback - EXIT", Reg_SelftrigCfg_ExitSft_c, Reg_SelftrigCfg_ExitSft_c);
		axi_single_expect(Reg_SelftrigCfg_Addr_c, 1, ms, sm, aclk, "Selftrig-Cfg Readback - ENTER", Reg_SelftrigCfg_EnterSft_c, Reg_SelftrigCfg_EnterSft_c);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, 0, 1, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 4, 1, 1, ms, sm, aclk);		
		
		-- One of two channels, do not react on other channels
		axi_single_write(Reg_SelftrigLo_Addr_c, 0, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+1*2**1+2**Reg_SelftrigCfg_ExitSft_c, ms, sm, aclk);		
		-- Trigger on ch 0 
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, 0, 100, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 10, 100, 1, ms, sm, aclk);
		-- No trigger on ch 2
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -200, 100, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "Waiting Status", 3, 0);		
		-- Trigger on ch 1 
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -100, 100, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 10-100, 100, 1, ms, sm, aclk);	
		
		-- Ch0 only, exit wihtout hitting the border, no signedness
		axi_single_write(Reg_SelftrigLo_Addr_c, 0, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, 100, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_ExitSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, 5, 1, 10);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 95, 1, 10, ms, sm, aclk);		
		
		-- Signed range accross zero, exit
		axi_single_write(Reg_SelftrigLo_Addr_c, -10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_ExitSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -20, 1, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, 10, 1, 1, ms, sm, aclk);		

		-- Signed range accross zero, enter		
		axi_single_write(Reg_SelftrigLo_Addr_c, -10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_EnterSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -20, 1, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, -11, 1, 1, ms, sm, aclk);		
		
		-- signed range below zero, exit
		axi_single_write(Reg_SelftrigLo_Addr_c, -20, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, -10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_ExitSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -30, 1, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, -10, 1, 1, ms, sm, aclk);	
		
		-- signed range below zero, enter
		axi_single_write(Reg_SelftrigLo_Addr_c, -20, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, -10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_EnterSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -30, 1, 1);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, -21, 1, 1, ms, sm, aclk);	

		-- Check no effect if not enabled, trigger afterwards to enter idle status again to be ready for next test
		axi_single_write(Reg_TrigEna_Addr_c, 0, ms, sm, aclk);	
		axi_single_write(Reg_SelftrigLo_Addr_c, -20, ms, sm, aclk);
		axi_single_write(Reg_SelftrigHi_Addr_c, -10, ms, sm, aclk);
		axi_single_write(Reg_SelftrigCfg_Addr_c, 1*2**0+2**Reg_SelftrigCfg_EnterSft_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 200 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -30, 1, 1);		
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "No trigger when source disabled", 3, 0);
		axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_SelfIdx_c, ms, sm, aclk);	
		wait for 200 ns;
		InputSamplesNoCh(MemoryDepth_c*2, ToDut, Clk, -30, 1, 1);	
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		CheckDataNoCh(SampleCount_c, -21, 1, 1, ms, sm, aclk);			

		
	end procedure;
	
	
end top_tb_case2_pkg;

