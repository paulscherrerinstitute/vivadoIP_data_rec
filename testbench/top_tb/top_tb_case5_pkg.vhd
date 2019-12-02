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
package top_tb_case5_pkg is

	constant CaseName_c : string := "Handling of multiple external triggers";

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t);
					
end top_tb_case5_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body top_tb_case5_pkg is

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t) is
		variable lastDoneCheck		: time;
		variable dataStart			: integer;
	begin
		-- Print Message
		print("Test: " & CaseName_c);
		lastDoneCheck := now;
		
		-- Common Configuration
		axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_ExtIdx_c, ms, sm, aclk);	
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 5, ms, sm, aclk);
		
		-- *** Test if unused trigger inputs are masked ***

		-- Loop through trigger inputs
		for ti_ena in 0 to TriggerInputs_c-1 loop
		
			-- enable only trigger input in question
			axi_single_write(Reg_EnableExtTrig_Addr_c, 1*2**ti_ena, ms, sm, aclk);
			
			-- trigger on each input and check correct behavior
			for ti_cur in 0 to TriggerInputs_c-1 loop
				dataStart := 100*ti_ena+ti_cur;
				axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
				wait for 200 ns;
				assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;
				lastDoneCheck := now;
				InputSamples(MemoryDepth_v*2, ToDut, Clk, dataStart, MemoryDepth_v, 1, ti_cur);
				wait for 100 ns;	
				-- check recording done if the trigger input is active
				if ti_cur = ti_ena then
					assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;
					lastDoneCheck := now;
					CheckData(10, dataStart+MemoryDepth_v-5, ms, sm, aclk);
					axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);	
				-- check no trigger if input is inactive
				else
					axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateWaitTrig_c, ms, sm, aclk, "Wait Status", 3, 0);
				end if;
			end loop;
				
		end loop;
		
		-- *** Test if multiple trigger inputs are ORed ***
		
		-- Enable all inputs
		axi_single_write(Reg_EnableExtTrig_Addr_c, 16#FFFFFFFF#, ms, sm, aclk);		
		
		-- check if all trigger inputs lead to a recording		
		for ti_cur in 0 to TriggerInputs_c-1 loop
			dataStart := 100+ti_cur;
			axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
			wait for 200 ns;
			assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;
			lastDoneCheck := now;
			InputSamples(MemoryDepth_v*2, ToDut, Clk, dataStart, MemoryDepth_v, 1, ti_cur);
			wait for 100 ns;	
			assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;
			lastDoneCheck := now;
			CheckData(10, dataStart+MemoryDepth_v-5, ms, sm, aclk);
			axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);	
		end loop;

			
				
	end procedure;
	
	
end top_tb_case5_pkg;

