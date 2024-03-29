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
	use work.psi_common_array_pkg.all;
	use work.data_rec_register_pkg.all;

------------------------------------------------------------------------------
-- Entity
------------------------------------------------------------------------------	
entity data_rec_vivado_wrp is
	generic
	(
		-- Component Parameters
		NumOfInputs_g				: positive range 1 to 8		:= 4;
		InputWidth_g				: positive range 1 to 32	:= 8;
		MemoryDepth_g				: positive					:= 128;
		TrigInputs_g				: natural range 0 to 8		:= 1;
		
		-- AXI Parameters
		C_S00_AXI_ID_WIDTH          : integer := 1;							-- Width of ID for for write address, write data, read address and read data
		C_S00_AXI_ADDR_WIDTH        : integer := 14							-- Width of S_AXI address bus		
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
		Done_Irq					: out std_logic;
		-----------------------------------------------------------------------------
		-- Axi Slave Bus Interface
		-----------------------------------------------------------------------------
		-- System
		s00_axi_aclk                : in    std_logic;                                             -- Global Clock Signal
		s00_axi_aresetn             : in    std_logic;                                             -- Global Reset Signal. This signal is low active.
		-- Read address channel
		s00_axi_arid                : in    std_logic_vector(C_S00_AXI_ID_WIDTH-1   downto 0);     -- Read address ID. This signal is the identification tag for the read address group of signals.
		s00_axi_araddr              : in    std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);     -- Read address. This signal indicates the initial address of a read burst transaction.
		s00_axi_arlen               : in    std_logic_vector(7 downto 0);                          -- Burst length. The burst length gives the exact number of transfers in a burst
		s00_axi_arsize              : in    std_logic_vector(2 downto 0);                          -- Burst size. This signal indicates the size of each transfer in the burst
		s00_axi_arburst             : in    std_logic_vector(1 downto 0);                          -- Burst type. The burst type and the size information, determine how the address for each transfer within the burst is calculated.
		s00_axi_arlock              : in    std_logic;                                             -- Lock type. Provides additional information about the atomic characteristics of the transfer.
		s00_axi_arcache             : in    std_logic_vector(3 downto 0);                          -- Memory type. This signal indicates how transactions are required to progress through a system.
		s00_axi_arprot              : in    std_logic_vector(2 downto 0);                          -- Protection type. This signal indicates the privilege and security level of the transaction, and whether the transaction is a data access or an instruction access.
		s00_axi_arvalid             : in    std_logic;                                             -- Write address valid. This signal indicates that the channel is signaling valid read address and control information.
		s00_axi_arready             : out   std_logic;                                             -- Read address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
		-- Read data channel
		s00_axi_rid                 : out   std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);       -- Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
		s00_axi_rdata               : out   std_logic_vector(31 downto 0);                         -- Read Data
		s00_axi_rresp               : out   std_logic_vector(1 downto 0);                          -- Read response. This signal indicates the status of the read transfer.
		s00_axi_rlast               : out   std_logic;                                             -- Read last. This signal indicates the last transfer in a read burst.
		s00_axi_rvalid              : out   std_logic;                                             -- Read valid. This signal indicates that the channel is signaling the required read data.
		s00_axi_rready              : in    std_logic;                                             -- Read ready. This signal indicates that the master can accept the read data and response information.
		-- Write address channel
		s00_axi_awid                : in    std_logic_vector(C_S00_AXI_ID_WIDTH-1   downto 0);     -- Write Address ID
		s00_axi_awaddr              : in    std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);     -- Write address
		s00_axi_awlen               : in    std_logic_vector(7 downto 0);                          -- Burst length. The burst length gives the exact number of transfers in a burst
		s00_axi_awsize              : in    std_logic_vector(2 downto 0);                          -- Burst size. This signal indicates the size of each transfer in the burst
		s00_axi_awburst             : in    std_logic_vector(1 downto 0);                          -- Burst type. The burst type and the size information, determine how the address for each transfer within the burst is calculated.
		s00_axi_awlock              : in    std_logic;                                             -- Lock type. Provides additional information about the atomic characteristics of the transfer.
		s00_axi_awcache             : in    std_logic_vector(3 downto 0);                          -- Memory type. This signal indicates how transactions are required to progress through a system.
		s00_axi_awprot              : in    std_logic_vector(2 downto 0);                          -- Protection type. This signal indicates the privilege and security level of the transaction, and whether the transaction is a data access or an instruction access.
		s00_axi_awvalid             : in    std_logic;                                             -- Write address valid. This signal indicates that the channel is signaling valid write address and control information.
		s00_axi_awready             : out   std_logic;                                             -- Write address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
		-- Write data channel
		s00_axi_wdata               : in    std_logic_vector(31    downto 0);                      -- Write Data
		s00_axi_wstrb               : in    std_logic_vector(3 downto 0);                          -- Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
		s00_axi_wlast               : in    std_logic;                                             -- Write last. This signal indicates the last transfer in a write burst.
		s00_axi_wvalid              : in    std_logic;                                             -- Write valid. This signal indicates that valid write data and strobes are available.
		s00_axi_wready              : out   std_logic;                                             -- Write ready. This signal indicates that the slave can accept the write data.
		-- Write response channel
		s00_axi_bid                 : out   std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);       -- Response ID tag. This signal is the ID tag of the write response.
		s00_axi_bresp               : out   std_logic_vector(1 downto 0);                          -- Write response. This signal indicates the status of the write transaction.
		s00_axi_bvalid              : out   std_logic;                                             -- Write response valid. This signal indicates that the channel is signaling a valid write response.
		s00_axi_bready              : in    std_logic                                              -- Response ready. This signal indicates that the master can accept a write response.		
	);

end entity data_rec_vivado_wrp;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture rtl of data_rec_vivado_wrp is 

	-- More complex logic is required to support non-power-of-two recorder depth
	constant NonPwr2MemDepth_c				: boolean				:= (log2(MemoryDepth_g) /= log2ceil(MemoryDepth_g));

	-- Array of desired number of chip enables for each address range
	constant USER_SLV_NUM_REG               : integer              := 32; 
	
	-- IP Interconnect (IPIC) signal declarations
	signal reg_rd                    		: std_logic_vector(USER_SLV_NUM_REG-1 downto  0);
	signal reg_rdata                 		: t_aslv32(0 to USER_SLV_NUM_REG-1) := (others => (others => '0'));
	signal reg_wr                    		: std_logic_vector(USER_SLV_NUM_REG-1 downto  0);
	signal reg_wdata                 		: t_aslv32(0 to USER_SLV_NUM_REG-1);	
    signal mem_addr                  		: std_logic_vector(C_S00_AXI_ADDR_WIDTH - 1 downto  0);
    signal mem_wr                    		: std_logic_vector( 3 downto  0);
    signal mem_wdata                 		: std_logic_vector(31 downto  0);
    signal mem_rdata                 		: std_logic_vector(31 downto  0);	

	-- Register Signals
	signal reg_cfg_arm						: std_logic;
	signal reg_cfg_trigcntclr				: std_logic;
	signal reg_stat_state					: std_logic_vector(3 downto 0);
	signal reg_pretrig						: std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);
	signal reg_totspl						: std_logic_vector(log2ceil(MemoryDepth_g) downto 0);
	signal reg_selftriglo					: std_logic_vector(31 downto 0);	-- Full width for sign-correct extended readback
	signal reg_selftrighi					: std_logic_vector(31 downto 0);	-- Full width for sign-correct extended readback
	signal reg_selftrigchena				: std_logic_vector(NumOfInputs_g-1 downto 0);
	signal reg_selftrigonexit				: std_logic;
	signal reg_selftrigonenter				: std_logic;
	signal reg_swtrig						: std_logic;
	signal reg_trigcnt						: std_logic_vector(31 downto 0);
	signal reg_donetime						: std_logic_vector(31 downto 0);
	signal reg_trigena						: std_logic_vector(2 downto 0);
	signal reg_minrecperiod					: std_logic_vector(31 downto 0);
	signal reg_enableexttrig				: std_logic_vector(TrigInputs_g-1 downto 0);
	
	-- Data side signals
	signal port_cfg_arm						: std_logic;
	signal port_cfg_ack						: std_logic;
	signal port_cfg_trigcntclr				: std_logic;
	signal port_stat_state					: std_logic_vector(3 downto 0);
	signal port_pretrig						: std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);
	signal port_totspl						: std_logic_vector(log2ceil(MemoryDepth_g) downto 0);
	signal port_selftriglo					: std_logic_vector(InputWidth_g-1 downto 0);
	signal port_selftrighi					: std_logic_vector(InputWidth_g-1 downto 0);
	signal port_selftrigchena				: std_logic_vector(NumOfInputs_g-1 downto 0);
	signal port_selftrigonexit				: std_logic;
	signal port_selftrigonenter				: std_logic;	
	signal port_swtrig						: std_logic;
	signal port_done						: std_logic;
	signal port_trigcnt						: std_logic_vector(31 downto 0);
	signal port_donetime					: std_logic_vector(31 downto 0);
	signal port_trigena						: std_logic_vector(2 downto 0);
	signal port_minrecperiod				: std_logic_vector(31 downto 0);
	signal port_enableexttrig				: std_logic_vector(TrigInputs_g-1 downto 0);
	
	-- Status CC to Axi
	subtype CcSToAxi_StatState_Rng			is natural range 3 downto 0;	
	subtype CcSToAxi_TrigCnt_Rng			is natural range CcSToAxi_StatState_Rng'left+32 downto CcSToAxi_StatState_Rng'left+1;
	subtype CcSToAxi_DoneTime_Rng			is natural range CcSToAxi_TrigCnt_Rng'left+32 downto CcSToAxi_TrigCnt_Rng'left+1;
	constant CcSToAxi_Width_c				: natural	:= CcSToAxi_DoneTime_Rng'high+1;	 
	signal CcSToAxIn						: std_logic_vector(CcSToAxi_Width_c-1 downto 0);
	signal CcSToAxOut						: std_logic_vector(CcSToAxi_Width_c-1 downto 0);
	
	-- Pulse CC from Axi
	constant CcPFromAxi_Arm_c				: natural := 0;
	constant CcPFromAxi_Ack_c				: natural := CcPFromAxi_Arm_c+1;
	constant CcPFromAxi_TrigCntClr_c		: natural := CcPFromAxi_Ack_c+1;
	constant CcFromAxi_Width_c				: natural := CcPFromAxi_TrigCntClr_c+1;
	signal CcPFromAxIn						: std_logic_vector(CcFromAxi_Width_c-1 downto 0);
	signal CcPFromAxOut						: std_logic_vector(CcFromAxi_Width_c-1 downto 0);
	
	-- Status CC from Axi
	subtype CcSFromAxi_PreTrig_Rng			is natural range log2ceil(MemoryDepth_g)-1 downto 0;
	subtype CcSFromAxi_TotSpl_Rng			is natural range CcSFromAxi_PreTrig_Rng'left+log2ceil(MemoryDepth_g)+1 downto CcSFromAxi_PreTrig_Rng'left+1;
	subtype CcSFromAxi_SelfTrigLo_Rng		is natural range CcSFromAxi_TotSpl_Rng'left+InputWidth_g downto CcSFromAxi_TotSpl_Rng'left+1;
	subtype CcSFromAxi_SelfTrigHi_Rng		is natural range CcSFromAxi_SelfTrigLo_Rng'left+InputWidth_g downto CcSFromAxi_SelfTrigLo_Rng'left+1;
	subtype CcSFromAxi_SelfTrigChEna_Rng	is natural range CcSFromAxi_SelfTrigHi_Rng'left+NumOfInputs_g downto CcSFromAxi_SelfTrigHi_Rng'left+1;
	constant CcSFromAxi_SelfTrigOnExit_c	: natural 	:= CcSFromAxi_SelfTrigChEna_Rng'left+1;
	constant CcSFromAxi_SelfTrigOnEnter_c	: natural 	:= CcSFromAxi_SelfTrigOnExit_c+1;
	subtype CcSFromAxi_TrigEna_Rng			is natural range CcSFromAxi_SelfTrigOnEnter_c+3 downto CcSFromAxi_SelfTrigOnEnter_c+1;
	constant CcSFromAxi_SwTrig_c			: natural := CcSFromAxi_TrigEna_Rng'left+1;
	subtype CcSFromAxi_MinRecPeriod_Rng		is natural range CcSFromAxi_SwTrig_c+32 downto CcSFromAxi_SwTrig_c+1;
	subtype CcSFromAxi_EnableExtTrig_Rng	is natural range CcSFromAxi_MinRecPeriod_Rng'left+TrigInputs_g downto CcSFromAxi_MinRecPeriod_Rng'left+1;
	constant CcSFromAxi_Width_c				: natural	:= CcSFromAxi_EnableExtTrig_Rng'left+1;	
	signal CcSFromAxIn						: std_logic_vector(CcSFromAxi_Width_c-1 downto 0);
	signal CcSFromAxOut						: std_logic_vector(CcSFromAxi_Width_c-1 downto 0);	
	
	-- Pulse CC to Axi
	constant CsPToAxi_Done_c				: natural	:= 0;			
	constant CsPToAxi_Width_c				: natural	:= CsPToAxi_Done_c+1;
	signal CcPToAxIn						: std_logic_vector(CsPToAxi_Width_c-1 downto 0);
	signal CcPToAxOut						: std_logic_vector(CsPToAxi_Width_c-1 downto 0);
	
	-- Ohter Signals 
	signal RstProc							: std_logic;
	signal AxiRst							: std_logic;
	
	-- Memory Signals
	signal RecMemWr							: std_logic;
	signal RecMemAdr						: std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);
	signal RecMemData						: std_logic_vector(InputWidth_g*NumOfInputs_g-1 downto 0);
	signal AxiMemAdr						: std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);
	signal AxiMemSel						: std_logic_vector(2 downto 0);
	type Data_t	is array (natural range <>) of std_logic_vector(InputWidth_g-1 downto 0);
	signal AxiMemOut						: Data_t(7 downto 0);
	
	-- Internal Signals
	signal FirstSplAddr						: std_logic_vector(log2ceil(MemoryDepth_g)-1 downto 0);
	signal AckDone							: std_logic;
	
	-- Register Reaset Values
	constant RegRstVal_c					: t_aslv32(0 to USER_SLV_NUM_REG-1)	:= (Reg_EnableExtTrig_Addr_c/4 => (others => '1'),	-- Enable all external triggers by default
																					others => (others => '0'));
	

begin

	AxiRst <= not s00_axi_aresetn;

   -----------------------------------------------------------------------------
   -- AXI decode instance
   -----------------------------------------------------------------------------
   axi_slave_reg_mem_inst : entity work.psi_common_axi_slave_ipif
   generic map
   (
      -- Users parameters
      num_reg_g                    => USER_SLV_NUM_REG,
      use_mem_g                    => true,
      rst_val_g                  => RegRstVal_c,
      -- Parameters of Axi Slave Bus Interface
      axi_id_width_g                => C_S00_AXI_ID_WIDTH,
      axi_addr_width_g              => C_S00_AXI_ADDR_WIDTH
   )
   port map
   (
      --------------------------------------------------------------------------
      -- Axi Slave Bus Interface
      --------------------------------------------------------------------------
      -- System
      s_axi_aclk                  => s00_axi_aclk,
      s_axi_aresetn               => s00_axi_aresetn,
      -- Read address channel
      s_axi_arid                  => s00_axi_arid,
      s_axi_araddr                => s00_axi_araddr,
      s_axi_arlen                 => s00_axi_arlen,
      s_axi_arsize                => s00_axi_arsize,
      s_axi_arburst               => s00_axi_arburst,
      s_axi_arlock                => s00_axi_arlock,
      s_axi_arcache               => s00_axi_arcache,
      s_axi_arprot                => s00_axi_arprot,
      s_axi_arvalid               => s00_axi_arvalid,
      s_axi_arready               => s00_axi_arready,
      -- Read data channel
      s_axi_rid                   => s00_axi_rid,
      s_axi_rdata                 => s00_axi_rdata,
      s_axi_rresp                 => s00_axi_rresp,
      s_axi_rlast                 => s00_axi_rlast,
      s_axi_rvalid                => s00_axi_rvalid,
      s_axi_rready                => s00_axi_rready,
      -- Write address channel
      s_axi_awid                  => s00_axi_awid,
      s_axi_awaddr                => s00_axi_awaddr,
      s_axi_awlen                 => s00_axi_awlen,
      s_axi_awsize                => s00_axi_awsize,
      s_axi_awburst               => s00_axi_awburst,
      s_axi_awlock                => s00_axi_awlock,
      s_axi_awcache               => s00_axi_awcache,
      s_axi_awprot                => s00_axi_awprot,
      s_axi_awvalid               => s00_axi_awvalid,
      s_axi_awready               => s00_axi_awready,
      -- Write data channel
      s_axi_wdata                 => s00_axi_wdata,
      s_axi_wstrb                 => s00_axi_wstrb,
      s_axi_wlast                 => s00_axi_wlast,
      s_axi_wvalid                => s00_axi_wvalid,
      s_axi_wready                => s00_axi_wready,
      -- Write response channel
      s_axi_bid                   => s00_axi_bid,
      s_axi_bresp                 => s00_axi_bresp,
      s_axi_bvalid                => s00_axi_bvalid,
      s_axi_bready                => s00_axi_bready,
      --------------------------------------------------------------------------
      -- Register Interface
      --------------------------------------------------------------------------
      o_reg_rd                    => reg_rd,
      i_reg_rdata                 => reg_rdata,
      o_reg_wr                    => reg_wr,
      o_reg_wdata                 => reg_wdata,
	  	--------------------------------------------------------------------------
      -- Memory Interface
      --------------------------------------------------------------------------
      o_mem_addr                  => mem_addr,
      o_mem_wr                    => mem_wr,
      o_mem_wdata                 => mem_wdata,
      i_mem_rdata                 => mem_rdata
   );

	-----------------------------------------------------------------------------
	-- Register Decoding
	----------------------------------------------------------------------------   
	-- Status
	reg_rdata(ToWordAddr(Reg_Stat_Addr_c))(3 downto 0)		<= reg_stat_state;
	AckDone <= '1' when (reg_rd(ToWordAddr(Reg_Stat_Addr_c)) = '1') and (unsigned(reg_stat_state) = Reg_Stat_StateDone_c) else '0';
	
	-- Cfg
	reg_cfg_arm 		<= reg_wr(ToWordAddr(Reg_Cfg_Addr_c)) and reg_wdata(ToWordAddr(Reg_Cfg_Addr_c))(Reg_Cfg_ArmIdx_c);
	reg_cfg_trigcntclr	<= reg_wr(ToWordAddr(Reg_Cfg_Addr_c)) and reg_wdata(ToWordAddr(Reg_Cfg_Addr_c))(Reg_Cfg_TrgCntClr_Idx_c);
	reg_pretrig			<= reg_wdata(ToWordAddr(Reg_Pretrig_Addr_c))(reg_pretrig'left downto 0);
	reg_totspl			<= reg_wdata(ToWordAddr(Reg_Totspl_Addr_c))(reg_totspl'left downto 0);
	reg_selftriglo		<= reg_wdata(ToWordAddr(Reg_SelftrigLo_Addr_c))(reg_selftriglo'left downto 0);
	reg_selftrighi		<= reg_wdata(ToWordAddr(Reg_SelftrigHi_Addr_c))(reg_selftrighi'left downto 0);
	reg_selftrigchena	<= reg_wdata(ToWordAddr(Reg_SelftrigCfg_Addr_c))(NumOfInputs_g-1 downto 0);
	reg_selftrigonexit	<= reg_wdata(ToWordAddr(Reg_SelftrigCfg_Addr_c))(Reg_SelftrigCfg_ExitSft_c);
	reg_selftrigonenter	<= reg_wdata(ToWordAddr(Reg_SelftrigCfg_Addr_c))(Reg_SelftrigCfg_EnterSft_c);
	reg_swtrig			<= reg_wdata(ToWordAddr(Reg_SwTrig_Addr_c))(Reg_SwTrig_TrigIdx_c);
	reg_trigena			<= reg_wdata(ToWordAddr(Reg_TrigEna_Addr_c))(reg_trigena'left downto 0);
	reg_minrecperiod	<= reg_wdata(ToWordAddr(Reg_MinRecPeriod_Addr_c))(reg_minrecperiod'left downto 0);
	reg_enableexttrig	<= reg_wdata(ToWordAddr(Reg_EnableExtTrig_Addr_c))(reg_enableexttrig'left downto 0);
	
	-- Cfg Readback
	reg_rdata(ToWordAddr(Reg_Pretrig_Addr_c))(reg_pretrig'left downto 0)				<= reg_pretrig;
	reg_rdata(ToWordAddr(Reg_Totspl_Addr_c))(reg_totspl'left downto 0)					<= reg_totspl;
	reg_rdata(ToWordAddr(Reg_SelftrigLo_Addr_c))(reg_selftriglo'left downto 0)			<= reg_selftriglo;
	reg_rdata(ToWordAddr(Reg_SelftrigHi_Addr_c))(reg_selftrighi'left downto 0)			<= reg_selftrighi;
	reg_rdata(ToWordAddr(Reg_SelftrigCfg_Addr_c))(NumOfInputs_g-1 downto 0)				<= reg_selftrigchena;
	reg_rdata(ToWordAddr(Reg_SelftrigCfg_Addr_c))(Reg_SelftrigCfg_ExitSft_c)			<= reg_selftrigonexit;
	reg_rdata(ToWordAddr(Reg_SelftrigCfg_Addr_c))(Reg_SelftrigCfg_EnterSft_c)			<= reg_selftrigonenter;	
	reg_rdata(ToWordAddr(Reg_TrigCnt_Addr_c))(reg_trigcnt'left downto 0)				<= reg_trigcnt;
	reg_rdata(ToWordAddr(Reg_DoneTime_Addr_c))(reg_donetime'left downto 0)				<= reg_donetime;
	reg_rdata(ToWordAddr(Reg_TrigEna_Addr_c))(reg_trigena'left downto 0)				<= reg_trigena;
	reg_rdata(ToWordAddr(Reg_MinRecPeriod_Addr_c))(reg_minrecperiod'left downto 0)		<= reg_minrecperiod;
	reg_rdata(ToWordAddr(Reg_EnableExtTrig_Addr_c))(reg_enableexttrig'left downto 0)	<= reg_enableexttrig;
	
   
	-----------------------------------------------------------------------------
	-- Clock Crossings
	----------------------------------------------------------------------------- 
	
	-- *** Status from Data to AXI domain ***
	CcSToAxIn(CcSToAxi_StatState_Rng)	<= port_stat_state;
	CcSToAxIn(CcSToAxi_TrigCnt_Rng)		<= port_trigcnt;
	CcSToAxIn(CcSToAxi_DoneTime_Rng)	<= port_donetime;
	
	i_cc_status_toAxi : entity work.psi_common_status_cc
		generic map (
			width_g	=> CcSToAxi_Width_c
		)
		port map (
			a_clk_i		=> Clk,
			a_rst_i		=> Rst,
			a_rst_o 	=> RstProc,
			a_dat_i		=> CcSToAxIn,
			b_clk_i		=> s00_axi_aclk,
			b_rst_i		=> AxiRst,
			b_rst_o		=> open,
			b_dat_o		=> CcSToAxOut			
		);
		
	reg_stat_state 	<= CcSToAxOut(CcSToAxi_StatState_Rng);
	reg_trigcnt		<= CcSToAxOut(CcSToAxi_TrigCnt_Rng);
	reg_donetime	<= CcSToAxOut(CcSToAxi_DoneTime_Rng);
	
	-- *** Status from Axi to Data domain ***
	CcSFromAxIn(CcSFromAxi_PreTrig_Rng)			<= reg_pretrig;
	CcSFromAxIn(CcSFromAxi_TotSpl_Rng)			<= reg_totspl;
	CcSFromAxIn(CcSFromAxi_SelfTrigLo_Rng)		<= reg_selftriglo(InputWidth_g-1 downto 0);
	CcSFromAxIn(CcSFromAxi_SelfTrigHi_Rng)		<= reg_selftrighi(InputWidth_g-1 downto 0);
	CcSFromAxIn(CcSFromAxi_SelfTrigChEna_Rng)	<= reg_selftrigchena;
	CcSFromAxIn(CcSFromAxi_SelfTrigOnExit_c)	<= reg_selftrigonexit;
	CcSFromAxIn(CcSFromAxi_SelfTrigOnEnter_c)	<= reg_selftrigonenter;	
	CcSFromAxIn(CcSFromAxi_TrigEna_Rng)			<= reg_trigena;
	CcSFromAxIn(CcSFromAxi_SwTrig_c)			<= reg_swtrig;
	CcSFromAxIn(CcSFromAxi_MinRecPeriod_Rng)	<= reg_minrecperiod;
	CcSFromAxIn(CcSFromAxi_EnableExtTrig_Rng)	<= reg_enableexttrig;
	
	i_cc_status_fromAxi : entity work.psi_common_status_cc
		generic map (
			width_g	=> CcSFromAxi_Width_c
		)
		port map (
			a_clk_i		=> s00_axi_aclk,
			a_rst_i		=> AxiRst,
			a_rst_o 	=> open,
			a_dat_i		=> CcSFromAxIn,
			b_clk_i		=> Clk,
			b_rst_i		=> Rst,
			b_rst_o		=> open,
			b_dat_o		=> CcSFromAxOut			
		);
		
	port_pretrig 			<= CcSFromAxOut(CcSFromAxi_PreTrig_Rng);	
	port_totspl 			<= CcSFromAxOut(CcSFromAxi_TotSpl_Rng);	
	port_selftriglo			<= CcSFromAxOut(CcSFromAxi_SelfTrigLo_Rng);
	port_selftrighi			<= CcSFromAxOut(CcSFromAxi_SelfTrigHi_Rng);
	port_selftrigchena		<= CcSFromAxOut(CcSFromAxi_SelfTrigChEna_Rng);
	port_selftrigonexit		<= CcSFromAxOut(CcSFromAxi_SelfTrigOnExit_c);
	port_selftrigonenter	<= CcSFromAxOut(CcSFromAxi_SelfTrigOnEnter_c);
	port_trigena			<= CcSFromAxOut(CcSFromAxi_TrigEna_Rng);
	port_swtrig				<= CcSFromAxOut(CcSFromAxi_SwTrig_c);
	port_minrecperiod		<= CcSFromAxOut(CcSFromAxi_MinRecPeriod_Rng);
	port_enableexttrig		<= CcSFromAxOut(CcSFromAxi_EnableExtTrig_Rng);
	
	-- *** Pulses from AXI to Data domain ***
	CcPFromAxIn(CcPFromAxi_Arm_c)			<= reg_cfg_arm;
	CcPFromAxIn(CcPFromAxi_Ack_c)			<= AckDone;
	CcPFromAxIn(CcPFromAxi_TrigCntClr_c)	<= reg_cfg_trigcntclr;
	
	i_cc_pulse_fromAxi : entity work.psi_common_pulse_cc
		generic map (
			num_pulses_g	=> CcFromAxi_Width_c
		)
		port map (
			a_clk_i 		=> s00_axi_aclk,
			a_rst_i		=> AxiRst,
			a_rst_o		=> open,
			a_dat_i		=> CcPFromAxIn,
			b_clk_i		=> Clk,
			b_rst_i		=> Rst,
			b_rst_o		=> open,
			b_dat_o		=> CcPFromAxOut
		);
		
	port_cfg_arm 		<= CcPFromAxOut(CcPFromAxi_Arm_c);
	port_cfg_ack 		<= CcPFromAxOut(CcPFromAxi_Ack_c);
	port_cfg_trigcntclr	<= CcPFromAxOut(CcPFromAxi_TrigCntClr_c);
	
	-- *** Pulses from Data to Axi domain ***
	CcPToAxIn(CsPToAxi_Done_c)			<= port_done;
	
	i_cc_pulse_toAxi : entity work.psi_common_pulse_cc
		generic map (
			num_pulses_g	=> CsPToAxi_Width_c
		)
		port map (
			a_clk_i 		=> Clk,
			a_rst_i		=> Rst,
			a_rst_o		=> open,
			a_dat_i		=> CcPToAxIn,
			b_clk_i		=> s00_axi_aclk,
			b_rst_i		=> AxiRst,
			b_rst_o		=> open,
			b_dat_o		=> CcPToAxOut
		);
		
	Done_Irq 		<= CcPToAxOut(CsPToAxi_Done_c);

	------------------------------------------
	-- instantiate User Logic
	------------------------------------------
	i_data_rec : entity work.data_rec
		generic map (
			NumOfInputs_g	=> NumOfInputs_g,
			InputWidth_g	=> InputWidth_g,
			MemoryDepth_g	=> MemoryDepth_g,
			TrigInputs_g	=> TrigInputs_g
		)
		port map
		(
			-- Control Signals
			Clk				=> Clk,
			Rst				=> RstProc,
			-- Data Ports
			In_Data0		=> In_Data0,			
			In_Data1		=> In_Data1,			
			In_Data2		=> In_Data2,			
			In_Data3		=> In_Data3,			
			In_Data4		=> In_Data4,			
			In_Data5		=> In_Data5,			
			In_Data6		=> In_Data6,			
			In_Data7		=> In_Data7,			
			In_Vld			=> In_Vld,		
			-- Trigger Ports
			Trig_In			=> Trig_In,
			-- Register Ports
			State			=> port_stat_state,
			Arm				=> port_cfg_arm,
			Ack				=> port_cfg_ack,
			PreTrigSpls		=> port_pretrig,
			TotalSpls		=> port_totspl,			
			SelfTrigLo		=> port_selftriglo,
			SelfTrigHi		=> port_selftrighi,
			SelfTrigChEna	=> port_selftrigchena,
			SelfTrigOnExit	=> port_selftrigonexit,
			SelfTrigOnEnter	=> port_selftrigonenter,
			SwTrig			=> port_swtrig,
			Done			=> port_done,
			TrigCntClr		=> port_cfg_trigcntclr,
			TrigCnt			=> port_trigcnt,
			DoneTime		=> port_donetime,
			TrigEna			=> port_trigena,
			EnableExtTrig	=> port_enableexttrig,
			MinRecPeriod	=> port_minrecperiod,
			-- Memory Ports
			Mem_Wr			=> RecMemWr,
			Mem_Adr			=> RecMemAdr,
			Mem_Data		=> RecMemData,
			FirstSplAddr	=> FirstSplAddr
		);
		
	-- For power of 2 memory depth, the address logic is relatively simple
	g_pwr2mem : if not NonPwr2MemDepth_c generate
		AxiMemAdr		<= std_logic_vector(unsigned(mem_addr(log2ceil(MemoryDepth_g)+1 downto 2)) + unsigned(FirstSplAddr));
	end generate;
	
	-- For non power of 2 memory depth, the address logic is more complex and prone to slow timing, therefore it is only implemented if required
	g_npwr2mem : if NonPwr2MemDepth_c generate
		signal AxiMemAddrUnwrapped 	: std_logic_vector(AxiMemAdr'high+1 downto 0);
		signal MemAddrFull			: std_logic_vector(AxiMemAddrUnwrapped'range);
	begin
		AxiMemAddrUnwrapped		<= std_logic_vector(unsigned(mem_addr(log2ceil(MemoryDepth_g)+1 downto 2)) + unsigned('0' & FirstSplAddr));
		MemAddrFull				<= AxiMemAddrUnwrapped when unsigned(AxiMemAddrUnwrapped) < MemoryDepth_g else 
								   std_logic_vector(unsigned(AxiMemAddrUnwrapped) - MemoryDepth_g);
		AxiMemAdr				<= MemAddrFull(AxiMemAdr'range);
	end generate;
		
	
	mem_read_mux : process(s00_axi_aclk)
	begin
		if rising_edge(s00_axi_aclk) then
			AxiMemSel		<= mem_addr(log2ceil(MemoryDepth_g)+4 downto log2ceil(MemoryDepth_g)+2);
		end if;
	end process;
	mem_rdata(31 downto InputWidth_g)	<= 	(others => mem_rdata(InputWidth_g-1)); --sign extension
	mem_rdata(InputWidth_g-1 downto 0) 	<= 	AxiMemOut(0) when unsigned(AxiMemSel) = 0 else
											AxiMemOut(1) when unsigned(AxiMemSel) = 1 else
											AxiMemOut(2) when unsigned(AxiMemSel) = 2 else
											AxiMemOut(3) when unsigned(AxiMemSel) = 3 else
											AxiMemOut(4) when unsigned(AxiMemSel) = 4 else
											AxiMemOut(5) when unsigned(AxiMemSel) = 5 else
											AxiMemOut(6) when unsigned(AxiMemSel) = 6 else
											AxiMemOut(7);
	
	
	g_mem : for i in 0 to NumOfInputs_g-1 generate
	begin	
		i_mem : entity work.psi_common_tdp_ram
			generic map (
				depth_g		=> MemoryDepth_g,
				width_g		=> InputWidth_g,
				behavior_g	=> "RBW"
			)
			port map (
				-- Port A
				a_clk_i		=> Clk,
				a_addr_i		=> RecMemAdr,
				a_wr_i			=> RecMemWr,
				a_dat_i		=> RecMemData((i+1)*InputWidth_g-1 downto i*InputWidth_g),
				a_dat_o		=> open,
				
				-- Port B
				b_clk_i		=> s00_axi_aclk,
				b_addr_i		=> AxiMemAdr,
				b_wr_i			=> '0',
				b_dat_i		=> (others => '0'),
				b_dat_o		=> AxiMemOut(i)
			);
	end generate;
  
end rtl;
