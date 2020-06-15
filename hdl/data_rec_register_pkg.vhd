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
	use work.psi_common_math_pkg.all;
	
------------------------------------------------------------------------------
-- Package Header
------------------------------------------------------------------------------
package data_rec_register_pkg is

	constant Reg_Stat_Addr_c			: integer 	:= 16#0000#;
	constant Reg_Stat_StateIdle_c		: integer	:= 0;
	constant Reg_Stat_StatePreTrig_c	: integer	:= 1;
	constant Reg_Stat_StateWaitTrig_c	: integer	:= 2;
	constant Reg_Stat_StatePostTrig_c	: integer	:= 3;
	constant Reg_Stat_StateDone_c		: integer	:= 4;
	
	constant Reg_Cfg_Addr_c				: integer 	:= 16#0004#;
	constant Reg_Cfg_ArmIdx_c			: integer	:= 0;
	constant Reg_Cfg_TrgCntClr_Idx_c	: integer	:= 16;
	
	constant Reg_Pretrig_Addr_c			: integer	:= 16#0008#;
	constant Reg_Totspl_Addr_c			: integer   := 16#000C#;
	constant Reg_SelftrigLo_Addr_c		: integer	:= 16#0010#;
	constant Reg_SelftrigHi_Addr_c		: integer	:= 16#0014#;
	
	constant Reg_SelftrigCfg_Addr_c		: integer	:= 16#0018#;
	constant Reg_SelftrigCfg_ChEnaSft_c	: integer	:= 0;
	constant Reg_SelftrigCfg_ExitSft_c	: integer	:= 8;
	constant Reg_SelftrigCfg_EnterSft_c	: integer	:= 16;
	
	constant Reg_SwTrig_Addr_c			: integer	:= 16#001C#;
	constant Reg_SwTrig_TrigIdx_c		: integer	:= 0;
	
	constant Reg_TrigCnt_Addr_c			: integer	:= 16#0020#;
	
	constant Reg_DoneTime_Addr_c		: integer	:= 16#0024#;
	
	constant Reg_TrigEna_Addr_c			: integer	:= 16#0028#;
	constant Reg_TrigEna_ExtIdx_c		: integer	:= 0;
	constant Reg_TrigEna_SwIdx_c		: integer   := 1;
	constant Reg_TrigEna_SelfIdx_c		: integer 	:= 2;
	
	constant Reg_MinRecPeriod_Addr_c	: integer	:= 16#002C#;
	
	constant Reg_EnableExtTrig_Addr_c	: integer	:= 16#0030#;

	constant Reg_ParamInputs_Addr_c    : integer := 16#0034#;
	constant Reg_ParamMemDepth_Addr_c  : integer := 16#0038#;


	constant Mem_Addr_c					: integer	:= 16#0080#;
	
	function ToWordAddr(	ByteAddr	: in	integer) return integer;
	
	function MemAddr(	channel 	: in integer;
						sample		: in integer;
						memdepth	: in integer) return integer;
  
end data_rec_register_pkg;	 

------------------------------------------------------------------------------
-- Package Body
------------------------------------------------------------------------------
package body data_rec_register_pkg is 
  
	function ToWordAddr(	ByteAddr	: in	integer) return integer is
	begin
		return ByteAddr/4;
	end function;
	
	function MemAddr(	channel 	: in integer;
						sample		: in integer;
						memdepth	: in integer) return integer is
		constant ChannelSpacing_c : integer := 2**log2ceil(memdepth);
	begin
		return Mem_Addr_c + (channel*ChannelSpacing_c+sample)*4;
	end function;

	
end data_rec_register_pkg;
