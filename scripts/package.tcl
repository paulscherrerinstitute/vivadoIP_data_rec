##############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
##############################################################################

###############################################################
# Include PSI packaging commands
###############################################################
source ../../../TCL/PsiIpPackage/PsiIpPackage.tcl
namespace import -force psi::ip_package::latest::*

###############################################################
# General Information
###############################################################
set IP_NAME data_rec
set IP_VERSION 2.3
set IP_REVISION "auto"
set IP_LIBRARY GPAC3
set IP_DESCIRPTION "Mutli channel data recorder (supports pre-trigger and self-triggering)"

init $IP_NAME $IP_VERSION $IP_REVISION $IP_LIBRARY
set_description $IP_DESCIRPTION
set_logo_relative "../doc/psi_logo_150.gif"
set_datasheet_relative "../doc/$IP_NAME.pdf"

###############################################################
# Add Source Files
###############################################################

#Relative Source Files
add_sources_relative { \
	../hdl/data_rec_register_pkg.vhd \
	../hdl/data_rec.vhd \
	../hdl/data_rec_vivado_wrp.vhd \
}

#PSI Common
add_lib_relative \
	"../../../VHDL/psi_common/hdl"	\
	{ \
		psi_common_math_pkg.vhd \
		psi_common_array_pkg.vhd \
		psi_common_logic_pkg.vhd \
		psi_common_pulse_cc.vhd \
		psi_common_status_cc.vhd \
		psi_common_simple_cc.vhd \
		psi_common_tdp_ram.vhd \
		psi_common_pl_stage.vhd \
		psi_common_axi_slave_ipif.vhd \
	}			

###############################################################
# GUI Parameters
###############################################################

#User Parameters
gui_add_page "Configuration"

gui_create_parameter "NumOfInputs_g" "Data Channels"
gui_parameter_set_range 1 8
gui_add_parameter

gui_create_parameter "InputWidth_g" "Data Channel Width"
gui_parameter_set_range 1 32
gui_add_parameter

gui_create_parameter "MemoryDepth_g" "Recording Buffer size"
gui_add_parameter

gui_create_parameter "TrigInputs_g" "Number of trigger inputs"
gui_parameter_set_range 0 8
gui_add_parameter

gui_create_parameter "C_S00_AXI_ADDR_WIDTH" "Axi address width in bits"
gui_add_parameter

#Remove reset interface (Vivado messes up polarity...)
remove_autodetected_interface Rst

###############################################################
# Associate clock
###############################################################
#Clk is associated wrongly, so we remove and re-add it
remove_autodetected_interface Clk
add_clock_in_interface Clk
#Add correct association
set_interface_clock s00_axi s00_axi_aclk

###############################################################
# Optional Ports
###############################################################

for {set i 0} {$i < 8} {incr i} {
	add_port_enablement_condition "In_Data$i" "\$NumOfInputs_g > $i"
}

###############################################################
# Package Core
###############################################################
set TargetDir ".."
#											Edit  Synth	
package_ip $TargetDir false true




