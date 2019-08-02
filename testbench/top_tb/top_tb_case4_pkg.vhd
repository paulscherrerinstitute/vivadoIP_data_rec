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
package top_tb_case4_pkg is

	constant CaseName_c : string := "Recovery from illegal configurations";

	procedure run(	signal ms		: out	axi_ms_r;
					signal sm		: in	axi_sm_r;
					signal aclk		: in	std_logic;
					signal Clk 		: in 	std_logic;
					signal ToDut	: out	In_t;
					signal FromDut	: in	Out_t);
					
end top_tb_case4_pkg;

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body top_tb_case4_pkg is

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
		
		-- Common Configuration
		axi_single_write(Reg_TrigEna_Addr_c, 1*2**Reg_TrigEna_ExtIdx_c, ms, sm, aclk);	
		
		-- Arm when already armed
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		InputSamples(MemoryDepth_c*2, ToDut, Clk, 0, MemoryDepth_c);
		wait for 100 ns;	
		CheckData(10, MemoryDepth_c-5, ms, sm, aclk);
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);

		-- Pre-Trigger > Total
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 15, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StatePreTrig_c, ms, sm, aclk, "PreTrig Status", 3, 0);	
		InputSamples(MemoryDepth_c*2, ToDut, Clk, 0, MemoryDepth_c);
		wait for 100 ns;	
		-- data is not important but clean recovery is
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		lastDoneCheck := now;
		
		-- check correct behavior after recovery
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 200 ns;
		assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;
		lastDoneCheck := now;
		InputSamples(MemoryDepth_c*2, ToDut, Clk, 100, MemoryDepth_c);
		wait for 100 ns;	
		assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;
		lastDoneCheck := now;
		CheckData(10, 100+MemoryDepth_c-5, ms, sm, aclk);
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);		
		
		-- Total Samples = 0
		axi_single_write(Reg_Totspl_Addr_c, 0, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 15, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 100 ns;
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StatePreTrig_c, ms, sm, aclk, "PreTrig Status", 3, 0);	
		InputSamples(MemoryDepth_c*2, ToDut, Clk, 0, MemoryDepth_c);
		wait for 100 ns;	
		-- data is not important but clean recovery is
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);
		lastDoneCheck := now;		
		
		-- check correct behavior after recovery
		axi_single_write(Reg_Totspl_Addr_c, 10, ms, sm, aclk);
		axi_single_write(Reg_Pretrig_Addr_c, 5, ms, sm, aclk);
		axi_single_write(Reg_Cfg_Addr_c, 1*2**Reg_Cfg_ArmIdx_c, ms, sm, aclk);
		wait for 200 ns;
		assert FromDut.Done_Irq = '0' and FromDut.Done_Irq'last_event > now - lastDoneCheck report "Done_Irq was high after arming" severity error;
		lastDoneCheck := now;
		InputSamples(MemoryDepth_c*2, ToDut, Clk, 100, MemoryDepth_c);
		wait for 100 ns;	
		assert FromDut.Done_Irq'last_event < now - lastDoneCheck report "Done_Irq was low after recording" severity error;
		lastDoneCheck := now;
		CheckData(10, 100+MemoryDepth_c-5, ms, sm, aclk);
		axi_single_expect(Reg_Stat_Addr_c, Reg_Stat_StateDone_c, ms, sm, aclk, "Done Status", 3, 0);			

				
	end procedure;
	
	
end top_tb_case4_pkg;

