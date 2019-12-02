##############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
##############################################################################

#Constants
set LibPath "../../.."

#Set library
psi::sim::add_library data_rec

#suppress messages
psi::sim::compile_suppress 135,1236
psi::sim::run_suppress 8684,3479,3813,8009,3812

# psi_common
psi::sim::add_sources "$LibPath/VHDL/psi_common/hdl" {
	psi_common_array_pkg.vhd \
	psi_common_math_pkg.vhd \
	psi_common_logic_pkg.vhd \
	psi_common_pulse_cc.vhd \
	psi_common_simple_cc.vhd \
	psi_common_status_cc.vhd \
	psi_common_tdp_ram.vhd \
	psi_common_pl_stage.vhd \
	psi_common_axi_slave_ipif.vhd \
} -tag lib

# psi_tb
psi::sim::add_sources "$LibPath/VHDL/psi_tb/hdl" {
	psi_tb_txt_util.vhd \
	psi_tb_compare_pkg.vhd \
	psi_tb_axi_pkg.vhd \
} -tag lib

# project sources
psi::sim::add_sources "../hdl" {
	data_rec_register_pkg.vhd \
	data_rec.vhd \
	data_rec_vivado_wrp.vhd \
} -tag src

# testbenches
psi::sim::add_sources "../testbench" {
	top_tb/top_tb_pkg.vhd \
	top_tb/top_tb_case0_pkg.vhd \
	top_tb/top_tb_case1_pkg.vhd \
	top_tb/top_tb_case2_pkg.vhd \
	top_tb/top_tb_case3_pkg.vhd \
	top_tb/top_tb_case4_pkg.vhd \
	top_tb/top_tb_case5_pkg.vhd \
	top_tb/top_tb.vhd \
} -tag tb
	
#TB Runs
psi::sim::create_tb_run "top_tb"
psi::sim::tb_run_add_arguments \
	"-gMemoryDepth_g=32" \
	"-gMemoryDepth_g=30"
psi::sim::add_tb_run