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
package top_tb_case3_pkg is

	constant CaseName_c : string := "SW Trigger";

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t);
					
end top_tb_case3_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body top_tb_case3_pkg is

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t) is
		variable lastDoneCheck		: time;
	begin
		-- Print Message
		print("Test: " & CaseName_c);
		lastDoneCheck := now;
		
		-- configure
		axi_single_write(Reg_Pretrig_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_SwIdx_c, ms, sm, aclk);	
		
		-- Check SW trigger between samples
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 200 ns;
		assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;			-- done is only checked on first sw trigger
		lastDoneCheck := now;
		InputSamples(100, ToDut, Clk, 0);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		wait for 200 ns;
		InputSamples(100, ToDut, Clk);
		assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;			-- done is only checked on first sw-trigger
		lastDoneCheck := now;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status 1", 3, 0);
		CheckData(10, 95, ms, sm, aclk);
		
		-- Check correctness on second execution
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		InputSamples(100, ToDut, Clk, 100);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		wait for 100 ns;
		InputSamples(100, ToDut, Clk);
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status 2", 3, 0);
		CheckData(10, 195, ms, sm, aclk);	
		
		-- Check SW trigger during samples
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		for i in 0 to NumOfInputs_c-1 loop
			ToDut.In_Data(i) <= std_logic_vector(to_unsigned(i+1, InputWidth_c));
		end loop;
		ToDut.In_Vld <= '1';
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status 3", 3, 0);
		CheckDataNoCh(10, 1, 1, 0, ms, sm, aclk);
		ToDut.In_Vld <= '0';	
		
		-- Check SW trigger when unarmed (no action)
		InputSamples(100, ToDut, Clk, 0);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateIdle_c, ms, sm, aclk, "Idle Status", 3, 0);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateIdle_c, ms, sm, aclk, "Idle Status", 3, 0);		
		for i in 0 to 20 loop
			InputSamples(1, ToDut, Clk, 0);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateIdle_c, ms, sm, aclk, "Idle Status", 3, 0);
		end loop;

		-- Check SW Trigger, maximum samples, no pre-trigger
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 0, ms, sm, aclk);
		axi_single_write(Reg_Totspl_Addr_c, MemoryDepth_v, ms, sm, aclk);
		InputSamples(100, ToDut, Clk, 0);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		wait for 200 ns;
		InputSamples(100, ToDut, Clk);
		CheckData(MemoryDepth_v, 100, ms, sm, aclk);

		-- Check no effect if SW trigger disabled as source
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		axi_single_write(Reg_TrigEna_Addr_c, 0, ms, sm, aclk);	
		wait for 200 ns;
		InputSamples(100, ToDut, Clk, 100);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		InputSamples(100, ToDut, Clk);	
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "No effect when disabled", 3, 0);
		axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_SwIdx_c, ms, sm, aclk);	
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		wait for 200 ns;
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);
		InputSamples(100, ToDut, Clk);		
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status 5", 3, 0);

		-- Check SW trigger set before arming (triggers since SW trigger is sticky)
		axi_single_write(Reg_Pretrig_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_SwTrig_Addr_c, 1*2**Reg_SwTrig_TrigIdx_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);	
		wait for 200 ns;		
		InputSamples(15, ToDut, Clk, 5);	
		wait for 200 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status 6", 3, 0);
		CheckData(10, 5, ms, sm, aclk);		
		InputSamples(15, ToDut, Clk, 100);
		wait for 200 ns;
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);	
		wait for 200 ns;
		InputSamples(15, ToDut, Clk, 30);
		wait for 200 ns;		
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status 7", 3, 0);
		CheckData(10, 30, ms, sm, aclk);
		axi_single_write(Reg_SwTrig_Addr_c, 0, ms, sm, aclk);		
				
	end procedure;
	
	
end top_tb_case3_pkg;

