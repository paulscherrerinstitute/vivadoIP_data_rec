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
	use work.psi_common_math_pkg.all;
	use work.data_rec_register_pkg.all;

------------------------------------------------------------------------------
-- Entity
------------------------------------------------------------------------------	
entity data_rec is
	generic
	(
		-- Component Parameters	
		NumOfInputs_g				: positive range 1 to 8	:= 4;
		InputWidth_g				: positive				:= 8;
		MemoryDepth_g				: positive				:= 128;
		TrigInputs_g				: natural range 0 to 8	:= 1
	);
	port
	(
		-- Control Signals
		Clk							: in std_logic;
		Rst							: in std_logic;
		-- Data Ports
		In_Data0					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data1					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data2					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data3					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data4					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data5					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data6					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Data7					: in std_logic_vector(InputWidth_g-1 downto 0);
		In_Vld						: in std_logic;
		-- Trigger Ports
		Trig_In						: in std_logic_vector(TrigInputs_g-1 downto 0);
		-- Register Ports
		State						: out std_logic_vector(3 downto 0);							-- Status of the recorder
		Arm							: in std_logic;												-- Arm the recorder
		Ack							: in std_logic;												-- Acknowledge data reatout
		PreTrigSpls					: in std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);	-- Number of pre trigger samples 
		TotalSpls					: in std_logic_vector(log2ceil(MemoryDepth_g) downto 0);	-- Number of total samples
		SelfTrigLo					: in std_logic_vector(InputWidth_g-1 downto 0);				-- Self triggering mask, lower limit
		SelfTrigHi					: in std_logic_vector(InputWidth_g-1 downto 0);				-- Self triggering mask, upper limit
		SelfTrigChEna				: in std_logic_vector(NumOfInputs_g-1 downto 0);			-- Enable self triggering analysis 
		SelfTrigOnExit				: in std_logic;												-- Trigger if signal leaves the configured range
		SelfTrigOnEnter				: in std_logic;												-- Trigger if signal enters the configured range	
		SwTrig						: in std_logic;												-- Force trigger from software		
		Done						: out std_logic;											-- A data recording was completed
		TrigCntClr					: in std_logic;												-- Clear trigger counter
		TrigCnt						: out std_logic_vector(31 downto 0);						-- Trigger counter output
		DoneTime					: out std_logic_vector(31 downto 0);						-- Time spent in done status
		TrigEna						: in std_logic_vector(2 downto 0);							-- Trigger source enable
		EnableExtTrig				: in std_logic_vector(TrigInputs_g-1 downto 0);				-- External trigger enabled (triggers are ORed)
		MinRecPeriod				: in std_logic_vector(31 downto 0);							-- Minimum period between two recordings in clock cycles
		-- Memory Ports
		Mem_Wr						: out std_logic;
		Mem_Adr						: out std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);
		Mem_Data					: out std_logic_vector(NumOfInputs_g*InputWidth_g-1 downto 0);
		FirstSplAddr				: out std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0)	-- Address of the first sample in the recording buffer
	);

end entity data_rec;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture rtl of data_rec is 
	-- More complex logic is required to support non-power-of-two recorder depth
	constant NonPwr2MemDepth_c				: boolean				:= (log2(MemoryDepth_g) /= log2ceil(MemoryDepth_g));
	
	-- 2D array handling
	type Data_t is array(natural range <>) of std_logic_vector(InputWidth_g-1 downto 0);
	signal In_Data 		: Data_t(7 downto 0);
	type TrigIn_t is array(natural range <>) of std_logic_vector(TrigInputs_g-1 downto 0);

	-- State defintion
	type State_t is (Idle_s, PreTrig_s, WaitTrig_s, PostTrig_s, Done_s);

	-- Two Process Method
	type data_rec_r is record
		-- Input Registers
		In_Vld				: std_logic_vector(0 to 2);
		Trig_In				: TrigIn_t(0 to 2);
		Data_0				: Data_t(NumOfInputs_g-1 downto 0);
		Data_1				: Data_t(NumOfInputs_g-1 downto 0);
		Data_2				: Data_t(NumOfInputs_g-1 downto 0);
		Data_3				: Data_t(NumOfInputs_g-1 downto 0);
		-- Status	
		State_2				: State_t;
		Trigger_2			: std_logic;
		AdrCnt_2			: unsigned(Mem_Adr'range);
		AdrCnt_3			: unsigned(Mem_Adr'range);
		SplCnt_2			: unsigned(Mem_Adr'high+1 downto 0);
		Done				: std_logic_vector(2 to 3);
		MemWr_3				: std_logic;
		TrigCnt_3			: unsigned(31 downto 0);
		DoneTime_3			: unsigned(31 downto 0);
		FirstSpl_3			: unsigned(Mem_Adr'range);
		StInRange_1			: std_logic_vector(NumOfInputs_g-1 downto 0);
		StInRangeLast_1		: std_logic_vector(NumOfInputs_g-1 downto 0);
		LastRecCnt_2		: std_logic_vector(31 downto 0);
		-- Configuration 
		SwTrigPending_2		: std_logic;
		ExtTrigPending_2	: std_logic;		
	end record;	
	signal r, r_next : data_rec_r;
	

begin
	--------------------------------------------------------------------------
	-- 2D array handling
	--------------------------------------------------------------------------
	In_Data(0)	<= In_Data0;
	In_Data(1)	<= In_Data1;
	In_Data(2)	<= In_Data2;
	In_Data(3)	<= In_Data3;
	In_Data(4)	<= In_Data4;
	In_Data(5)	<= In_Data5;
	In_Data(6)	<= In_Data6;
	In_Data(7)	<= In_Data7;

	--------------------------------------------------------------------------
	-- Combinatorial Process
	--------------------------------------------------------------------------
	p_comb : process(	r, In_Data, In_Vld, Trig_In,
						Arm, PreTrigSpls, TotalSpls, SelfTrigLo, SelfTrigHi, 
						SelfTrigChEna, SelfTrigOnExit, SelfTrigOnEnter, SwTrig, Ack,
						TrigCntClr, MinRecPeriod, EnableExtTrig)	
		variable v : data_rec_r;
		variable StEnter_2	: std_logic_vector(NumOfInputs_g-1 downto 0);
		variable StExit_2	: std_logic_vector(NumOfInputs_g-1 downto 0);
		variable StTrig_2	: std_logic;
		variable TrigNow_2	: std_logic;
	begin
		-- hold variables stable
		v := r;
		
		-- *** Pipe Handling ***
		v.In_Vld(v.In_Vld'low+1 to v.In_Vld'high) 		:= r.In_Vld(r.In_Vld'low to r.In_Vld'high-1);
		v.Trig_In(v.Trig_In'low+1 to v.Trig_In'high) 	:= r.Trig_In(r.Trig_In'low to r.Trig_In'high-1);
		v.Done(v.Done'low+1 to v.Done'high) 			:= r.Done(r.Done'low to r.Done'high-1);
		
		-- *** Stage 0 ***
		-- Input Registers
		v.In_Vld(0)		:= In_Vld;
		v.Trig_In(0)	:= Trig_In;
		for i in 0 to NumOfInputs_g-1 loop
			v.Data_0(i) := In_Data(i);
		end loop;
		
		-- *** Stage 1 ***
		-- Pipelining
		v.Data_1 := r.Data_0;
		
		-- Self Trigger In Range detection
		if r.In_Vld(0) = '1' then
			v.StInRangeLast_1 := r.StInRange_1;
			for i in 0 to NumOfInputs_g-1 loop
				-- unsigned in range
				if 	(unsigned(r.Data_0(i)) <= unsigned(SelfTrigHi)) and
					(unsigned(r.Data_0(i)) >= unsigned(SelfTrigLo)) then
					v.StInRange_1(i) := '1';
				-- signed in range
				elsif (signed(r.Data_0(i)) <= signed(SelfTrigHi)) and
					  (signed(r.Data_0(i)) >= signed(SelfTrigLo)) then	
					v.StInRange_1(i) := '1';
				else	
					v.StInRange_1(i) := '0';
				end if;
			end loop;
		end if;
		
		-- *** SW Trigger Pending detection ***
		
		-- *** Stage 2 ***
		-- Pipelining
		v.Data_2 := r.Data_1;
		
		-- Self Trigger
		StEnter_2 	:= r.StInRange_1 and not r.StInRangeLast_1;
		StExit_2 	:= r.StInRangeLast_1 and not r.StInRange_1;
		StTrig_2	:= '0';
		if (SelfTrigOnExit = '1') and (unsigned(StExit_2 and SelfTrigChEna) /= 0) then
			StTrig_2	:= '1';
		end if;
		if (SelfTrigOnEnter = '1') and (unsigned(StEnter_2 and SelfTrigChEna) /= 0) then
			StTrig_2	:= '1';
		end if;
		
		-- External Trigger
		if r.State_2 = PreTrig_s then
			v.ExtTrigPending_2 := '0';
		end if;			
		for i in 0 to TrigInputs_g-1 loop
			if r.Trig_In(0)(i) = '1' and r.Trig_In(1)(i) = '0' and EnableExtTrig(i) = '1' then
				v.ExtTrigPending_2 := '1';
			end if;		
		end loop;
		
		-- SW Trigger
		if SwTrig = '1' then
			v.SwTrigPending_2 := '1';
		elsif r.State_2 = PreTrig_s then
			v.SwTrigPending_2 := '0';
		end if;

		-- Trigger Masking		
		TrigNow_2 := ((StTrig_2 and TrigEna(Reg_TrigEna_SelfIdx_c)) or 
					  (r.ExtTrigPending_2 and TrigEna(Reg_TrigEna_ExtIdx_c)) or 	-- Edge sensitive trigger
					  (r.SwTrigPending_2 and TrigEna(Reg_TrigEna_SwIdx_c)))
					 and r.In_Vld(1);
					 
		-- Maximum trigger period counter
		if unsigned(MinRecPeriod) < unsigned(r.LastRecCnt_2) then
			v.LastRecCnt_2 := MinRecPeriod;
		elsif unsigned(r.LastRecCnt_2) /= 0 then
			TrigNow_2 := '0';
			v.LastRecCnt_2 := std_logic_vector(unsigned(r.LastRecCnt_2) - 1);
			-- clear pendign triggers (they were too early)
			v.ExtTrigPending_2 := '0'; 
			v.SwTrigPending_2 := '0';
		elsif r.Trigger_2 = '1' then
			v.LastRecCnt_2 := MinRecPeriod;
		end if;						 
					 
		-- Recorder state handling
		v.Trigger_2 := '0';
		v.Done(2)	:= '0';
		case r.State_2 is
			when Idle_s =>					
				if (Arm = '1') then
					v.State_2	:= PreTrig_s;
				end if;
			when PreTrig_s => 
				-- Skip if no pre trigger is required
				if unsigned(PreTrigSpls) = 0 then
					v.State_2 := WaitTrig_s;
				-- Pre trigger recorded
				elsif (r.AdrCnt_2 = unsigned(PreTrigSpls)-1) and (r.In_Vld(1) = '1') then
					v.State_2 := WaitTrig_s;
				end if;
			when WaitTrig_s =>
				if TrigNow_2 = '1' then
					v.State_2 	:= PostTrig_s;
					v.Trigger_2 := '1';
				end if;
			when PostTrig_s => 
				if r.SplCnt_2 >= unsigned(TotalSpls) then
					v.State_2 	:= Done_s;
					v.Done(2)	:= '1';
					end if;
			when Done_s =>				
				if Arm = '1' then
					v.State_2 := PreTrig_s;
				elsif Ack = '1' then
					v.State_2 := Idle_s;				
				end if;			
			when others => null;
		end case;
						
		-- Address coutner handling
		if (r.State_2 = Idle_s) or (r.State_2 = Done_s)  then
			v.AdrCnt_2	:= (others => '0');
		elsif r.In_Vld(1) = '1' then
			if r.AdrCnt_2 = MemoryDepth_g-1 then
				v.AdrCnt_2 := (others => '0');
			else
				v.AdrCnt_2	:= r.AdrCnt_2+1;
			end if;
		end if;
		
		-- Sample Counter handling
		if r.State_2 = WaitTrig_s then
			v.SplCnt_2 := unsigned('0' & PreTrigSpls) + 1;
		elsif r.In_Vld(1) = '1' then
			v.SplCnt_2 := r.SplCnt_2 + 1;
		end if;
		
		-- *** Stage 3 ***
		-- Pipelining
		v.Data_3 	:= r.Data_2;
		v.AdrCnt_3 	:= r.AdrCnt_2;
		
		-- memory write
		if (r.State_2 = Idle_s) or (r.State_2 = Done_s) then
			v.MemWr_3	:= '0';
		else	
			v.MemWr_3	:= r.In_Vld(2);
		end if;
		
		-- first sample address
		if r.Trigger_2 = '1' then
			-- simple logic for power of 2 recorder depth
			if not NonPwr2MemDepth_c then
				v.FirstSpl_3	:= r.AdrCnt_2-unsigned(PreTrigSpls);
			-- more complex logic for non-power of two recorder depth
			else
				if r.AdrCnt_2 > unsigned(PreTrigSpls) then
					v.FirstSpl_3	:= r.AdrCnt_2-unsigned(PreTrigSpls);
				else
					v.FirstSpl_3	:= r.AdrCnt_2-unsigned(PreTrigSpls) + MemoryDepth_g;
				end if;
			end if;
		end if;
		
		-- trigger counter
		if TrigCntClr = '1' then
			v.TrigCnt_3		:= (others => '0');
		elsif r.Trigger_2 = '1' then	
			v.TrigCnt_3		:= r.TrigCnt_3+1;
		end if;
		
		-- Done time counter
		if r.Trigger_2 = '1' then
			v.DoneTime_3 := (others => '0');
		elsif r.State_2 = Done_s then
			if r.DoneTime_3 /= X"FFFFFFFF" then 	-- prevent overflow
				v.DoneTime_3 := r.DoneTime_3 + 1;
			end if;
		end if;
		
		-- Outputs
		case r.State_2 is
			when Idle_s 	=>	State <= std_logic_vector(to_unsigned(Reg_Stat_StateIdle_c, State'length));
			when PreTrig_s 	=>	State <= std_logic_vector(to_unsigned(Reg_Stat_StatePreTrig_c, State'length));
			when WaitTrig_s =>	State <= std_logic_vector(to_unsigned(Reg_Stat_StateWaitTrig_c, State'length));
			when PostTrig_s =>	State <= std_logic_vector(to_unsigned(Reg_Stat_StatePostTrig_c, State'length));
			when Done_s 	=>	State <= std_logic_vector(to_unsigned(Reg_Stat_StateDone_c, State'length));
			when others 	=>	State <= (others => '0');
		end case; 
		for i in 0 to NumOfInputs_g-1 loop 
			Mem_Data((i+1)*InputWidth_g-1 downto i*InputWidth_g) <= r.Data_3(i);
		end loop;
		Mem_Adr <= std_logic_vector(r.AdrCnt_3);
		Mem_Wr <= r.MemWr_3;
		FirstSplAddr <= std_logic_vector(r.FirstSpl_3);
		Done <= r.Done(3);
		TrigCnt <= std_logic_vector(r.TrigCnt_3);
		DoneTime <= std_logic_vector(r.DoneTime_3);
		
		
		-- Apply to record
		r_next <= v;
		
	end process;
	
	--------------------------------------------------------------------------
	-- Sequential Process
	--------------------------------------------------------------------------	
	p_seq : process(Clk)
	begin	
		if rising_edge(Clk) then
			r <= r_next;
			if Rst = '1' then
				r.In_Vld			<= (others => '0');
				r.Trig_In			<= (others => (others => '0'));
				r.State_2			<= Idle_s;
				r.AdrCnt_2			<= (others => '0');
				r.SplCnt_2			<= (others => '0');
				r.MemWr_3			<= '0';
				r.Trigger_2			<= '0';
				r.FirstSpl_3		<= (others => '0');
				r.SwTrigPending_2	<= '0';
				r.Done				<= (others => '0');
				r.TrigCnt_3			<= (others => '0');
				r.DoneTime_3		<= (others => '0');
				r.ExtTrigPending_2	<= '0';
				r.LastRecCnt_2		<= (others => '0');
			end if;
		end if;
	end process;
 
end rtl;
