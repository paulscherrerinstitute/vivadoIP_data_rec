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

library work;
	use work.psi_common_array_pkg.all;
	use work.psi_tb_axi_pkg.all;
	use work.data_rec_register_pkg.all;

------------------------------------------------------------------------------
-- Package Header
------------------------------------------------------------------------------
package top_tb_pkg is

	-------------------------------------------------------------------------
	-- TB Definitions
	-------------------------------------------------------------------------
	constant 	ClockFrequency_c	: real 		:= 160.0e6;
	constant	ClockPeriod_c		: time		:= (1 sec)/ClockFrequency_c;

	-------------------------------------------------------------------------
	-- Constants
	-------------------------------------------------------------------------
	constant InputWidth_c		: integer		:= 16;
	constant NumOfInputs_c		: integer		:= 4;
	constant TriggerInputs_c	: integer		:= 4;
	
	-------------------------------------------------------------------------
	-- Variables
	-------------------------------------------------------------------------
	shared variable PatternCnt_v	: integer	:= 0;
	shared variable MemoryDepth_v	: integer		:= 30;
														
	-------------------------------------------------------------------------
	-- Types
	-------------------------------------------------------------------------	
	type Data_t is array(natural range <>) of std_logic_vector(InputWidth_c-1 downto 0);	
	
	type In_t is record
		In_Data 	: Data_t(NumOfInputs_c-1 downto 0);
		In_Vld		: std_logic;
		Trig_In		: std_logic_vector(TriggerInputs_c-1 downto 0);
	end record;
	
	type Out_t is record
		Done_Irq	: std_logic;
	end record;
	
	-------------------------------------------------------------------------
	-- Procedure
	-------------------------------------------------------------------------	
	procedure InputSamples(			samples 	: in	integer;
							signal	inp			: out	In_t;
							signal 	clk			: in	std_logic;
									startCnt	: in	integer := -1;
									trigAt		: in	integer := -1;
									dutycycle	: in	integer := 1;
									trigIdx		: in	integer := 0);
									
	procedure CheckData(			samples		: in 	integer;
									startValue	: in 	integer;
							signal 	ms			: out	axi_ms_r;
							signal 	sm			: in	axi_sm_r;
							signal 	aclk		: in	std_logic);
							
	procedure InputSamplesNoCh(		samples 	: in	integer;
							signal	inp			: out	In_t;
							signal 	clk			: in	std_logic;
									startCnt	: in	integer := -1000000;
									chStep		: in	integer := 1;
									cntStep		: in	integer := 1);
									
	procedure CheckDataNoCh(		samples		: in 	integer;
									startValue	: in 	integer;
									chStep		: in	integer := 1;	
									cntStep		: in	integer := 1;
							signal 	ms			: out	axi_ms_r;
							signal 	sm			: in	axi_sm_r;
							signal 	aclk		: in	std_logic);

	
end top_tb_pkg;

package body top_tb_pkg is
	procedure InputSamples(			samples 	: in	integer;
							signal	inp			: out	In_t;
							signal 	clk			: in	std_logic;
									startCnt	: in	integer := -1;
									trigAt		: in	integer := -1;
									dutycycle	: in	integer := 1;
									trigIdx		: in	integer := 0) is
		variable Data 	: unsigned(InputWidth_c-1 downto 0);
	begin
		if startCnt >= 0 then
			PatternCnt_v := startCnt;
		end if;
		wait until rising_edge(Clk);
		for cnt in 0 to samples-1 loop
			--Data := to_unsigned(startCnt+cnt, InputWidth_c);
			Data := to_unsigned(PatternCnt_v, InputWidth_c);
			PatternCnt_v := PatternCnt_v+1;
			-- Apply channel offs
			for d in 0 to NumOfInputs_c-1 loop
				Data(Data'left downto Data'left-2) := to_unsigned(d, 3);
				inp.In_Data(d) <= std_logic_vector(Data);
			end loop;
			-- Trigger if required
			if cnt = trigAt then
				inp.Trig_In(trigIdx) <= '1';
			end if;
			for w in 0 to dutycycle-2 loop
				wait until rising_edge(Clk);
			end loop;
			inp.In_Vld <= '1';
			wait until rising_edge(Clk);
			inp.In_Vld <= '0';
			if trigAt /= -1 then -- do only touch trigger it was set by this function
				inp.Trig_In <= (others => '0');
			end if;
		end loop;
		inp.In_Vld <= '0';
	end procedure;
	
	
	procedure CheckData(			samples		: in integer;
									startValue	: in integer;
							signal 	ms			: out	axi_ms_r;
							signal 	sm			: in	axi_sm_r;
							signal 	aclk		: in	std_logic) is
		variable ExpVal_v 		: integer;
	begin	
		for ch in 0 to NumOfInputs_c-1 loop				
			for spl in 0 to samples-1 loop
				ExpVal_v := ch*2**(InputWidth_c-3)+spl+startValue;
				axi_single_expect(MemAddr(ch, spl, MemoryDepth_v), ExpVal_v, ms, sm, aclk, "Data Ch" & integer'image(ch) & " Spl " & integer'image(spl));
			end loop;
		end loop; 
	end procedure;
	
	procedure InputSamplesNoCh(		samples 	: in	integer;
							signal	inp			: out	In_t;
							signal 	clk			: in	std_logic;
									startCnt	: in	integer := -1000000;
									chStep		: in	integer := 1;
									cntStep		: in	integer := 1) is	
		variable Data 	: signed(InputWidth_c-1 downto 0);
		variable ChData	: signed(Data'range);
	begin
		if startCnt /= -1000000 then
			PatternCnt_v := startCnt;
		end if;
		wait until rising_edge(Clk);
		for cnt in 0 to samples-1 loop
			Data := to_signed(PatternCnt_v, InputWidth_c);
			PatternCnt_v := PatternCnt_v+cntStep;
			-- Apply channel offs
			for d in 0 to NumOfInputs_c-1 loop
				ChData := Data + chStep*d;
				inp.In_Data(d) <= std_logic_vector(ChData);
			end loop;
			inp.In_Vld <= '1';
			wait until rising_edge(Clk);
			inp.In_Vld <= '0';
			inp.Trig_In <= (others => '0');
		end loop;
		inp.In_Vld <= '0';
	end procedure;	

	procedure CheckDataNoCh(		samples		: in 	integer;
									startValue	: in 	integer;
									chStep		: in	integer := 1;	
									cntStep		: in	integer := 1;
							signal 	ms			: out	axi_ms_r;
							signal 	sm			: in	axi_sm_r;
							signal 	aclk		: in	std_logic) is	
		variable ExpVal_v 		: integer;
	begin	
		for ch in 0 to NumOfInputs_c-1 loop				
			for spl in 0 to samples-1 loop
				ExpVal_v := ch*chStep+spl*cntStep+startValue;
				axi_single_expect(MemAddr(ch, spl, MemoryDepth_v), ExpVal_v, ms, sm, aclk, "Data Ch" & integer'image(ch) & " Spl " & integer'image(spl));
			end loop;
		end loop;
	end procedure;
	
end top_tb_pkg;


