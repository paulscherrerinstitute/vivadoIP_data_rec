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
package top_tb_case0_pkg is

	constant CaseName_c : string := "Basic Functionality";

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t);
					
end top_tb_case0_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body top_tb_case0_pkg is

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t) is
		constant Samples_c 		: integer := MemoryDepth_c-4;
		constant PreTrigger_c	: integer := MemoryDepth_c/2;
		constant PostTrigger	: integer := Samples_c-PreTrigger_c;
		constant UnusedSamples	: integer := 4;
		variable startTime		: time;
		variable doneTime		: time;
		variable lastDoneCheck	: time;
	begin
		-- Print Message
		print("Test: " & CaseName_c);
		
		-- check reset status
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateIdle_c, ms, sm, aclk, "Reset Status", 3, 0);
		axi_single_expect(Reg_TrigCnt_Addr_c, 0, ms, sm, aclk, "Reset Trigger Counter");
		axi_single_expect(Reg_DoneTime_Addr_c, 0, ms, sm, aclk, "Reset Done Counter");
		axi_single_expect(Reg_TrigEna_Addr_c, 0, ms, sm, aclk, "Reset Trigger Enable");
		assert FromDut.Done_Irq = '0' report "Initial State of Done_Irq was high" severity error;
		
		-- configure
		axi_single_write(Reg_Pretrig_Addr_c, PreTrigger_c, ms, sm, aclk);
		axi_single_expect(Reg_Pretrig_Addr_c, PreTrigger_c, ms, sm, aclk, "Pretrigger Readback");
		axi_single_write(Reg_Totspl_Addr_c, Samples_c, ms, sm, aclk);
		axi_single_expect(Reg_Totspl_Addr_c, Samples_c, ms, sm, aclk, "Totspl Readback");
		lastDoneCheck := now;
		
		
		-- Do two recordings to ensure things work not only once after reset
		for i in 0 to 1 loop
			-- Set trigger to high to check edge-sensitivity (and not level sensitivity)
			ToDut.Trig_In(0) <= '1';			
		
			-- ARM
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 200 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StatePreTrig_c, ms, sm, aclk, "Pre Trigger Status", 3, 0);
			assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;
			lastDoneCheck := now;
					
			-- add pre trigger
			InputSamples(PreTrigger_c+UnusedSamples, ToDut, Clk, 0);
			wait for 100 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "Wait Trigger Status", 3, 0);	
			assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after pre-trigger" severity error;
			lastDoneCheck := now;
			
			-- Reset trigger to generate edges (if trigger was level sensitive, it would already have caused the recorder to trigger)
			ToDut.Trig_In(0) <= '0';	
			
			-- No effect if disabled
			axi_single_write(Reg_TrigEna_Addr_c, 0, ms, sm, aclk);
			wait for 200 ns;
			wait until rising_edge(Clk);
			ToDut.Trig_In(0) <= '1';
			wait until rising_edge(Clk);
			ToDut.Trig_In(0) <= '0';
			wait for 200 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "External Trigger Disabled, still Wait-Trigger", 3, 0);
			wait for 200 ns;
			axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_ExtIdx_c, ms, sm, aclk);	
			axi_single_expect(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_ExtIdx_c, ms, sm, aclk, "Trigger Enable Readback");			
			wait for 200 ns;
			
			-- start post trigger data			
			InputSamples(1, ToDut, Clk, -1, 0);
			wait for 100 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StatePostTrig_c, ms, sm, aclk, "Post Trigger Status", 3, 0);
			assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after start post-trigger" severity error;
			lastDoneCheck := now;
			
			-- end recording
			InputSamples(PostTrigger, ToDut, Clk);
			startTime := now;
			InputSamples(MemoryDepth_c*1/2, ToDut, Clk);
			wait for 10 us;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
			doneTime := now - startTime;
			axi_single_expect(Reg_DoneTime_Addr_c, integer(doneTime/ClockPeriod_c), ms, sm, aclk, "Done Time 1", 31, 0, false, 15);
			assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;
			lastDoneCheck := now;
			wait for 10 us;
			axi_single_expect(Reg_DoneTime_Addr_c, integer(doneTime/ClockPeriod_c), ms, sm, aclk, "Done Time 2", 31, 0, false, 15);
			-- automatic return to idle after reading done
			wait for 400 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateIdle_c, ms, sm, aclk, "Idle Status 2", 3, 0);
			axi_single_expect(Reg_TrigCnt_Addr_c, i+1, ms, sm, aclk, "Trigger Counter Counted");
		
			
					
			
			-- Additional samples don't hurt
			InputSamples(MemoryDepth_c*1/2, ToDut, Clk);
			wait for 100 ns;
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateIdle_c, ms, sm, aclk, "Idle Status 3", 3, 0);
			assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after going back to idle" severity error;
			lastDoneCheck := now;
			
			-- Read data
			CheckData(Samples_c, UnusedSamples, ms, sm, aclk);
			assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after reading data" severity error;
			lastDoneCheck := now;
		end loop;
		
		-- Trigger Counter Reset
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_TrgCntClr_Idx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_expect(Reg_TrigCnt_Addr_c, 0, ms, sm, aclk, "Trigger Counter Clear");
		
		
		
	end procedure;
	
	
end top_tb_case0_pkg;

