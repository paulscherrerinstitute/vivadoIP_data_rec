# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Configuration [ipgui::add_page $IPINST -name "Configuration"]
  ipgui::add_param $IPINST -name "NumOfInputs_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "InputWidth_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "MemoryDepth_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "TrigInputs_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Configuration}


}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to update C_S00_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ID_WIDTH { PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to validate C_S00_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.InputWidth_g { PARAM_VALUE.InputWidth_g } {
	# Procedure called to update InputWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.InputWidth_g { PARAM_VALUE.InputWidth_g } {
	# Procedure called to validate InputWidth_g
	return true
}

proc update_PARAM_VALUE.MemoryDepth_g { PARAM_VALUE.MemoryDepth_g } {
	# Procedure called to update MemoryDepth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MemoryDepth_g { PARAM_VALUE.MemoryDepth_g } {
	# Procedure called to validate MemoryDepth_g
	return true
}

proc update_PARAM_VALUE.NumOfInputs_g { PARAM_VALUE.NumOfInputs_g } {
	# Procedure called to update NumOfInputs_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NumOfInputs_g { PARAM_VALUE.NumOfInputs_g } {
	# Procedure called to validate NumOfInputs_g
	return true
}

proc update_PARAM_VALUE.TrigInputs_g { PARAM_VALUE.TrigInputs_g } {
	# Procedure called to update TrigInputs_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TrigInputs_g { PARAM_VALUE.TrigInputs_g } {
	# Procedure called to validate TrigInputs_g
	return true
}


proc update_MODELPARAM_VALUE.NumOfInputs_g { MODELPARAM_VALUE.NumOfInputs_g PARAM_VALUE.NumOfInputs_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NumOfInputs_g}] ${MODELPARAM_VALUE.NumOfInputs_g}
}

proc update_MODELPARAM_VALUE.InputWidth_g { MODELPARAM_VALUE.InputWidth_g PARAM_VALUE.InputWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.InputWidth_g}] ${MODELPARAM_VALUE.InputWidth_g}
}

proc update_MODELPARAM_VALUE.MemoryDepth_g { MODELPARAM_VALUE.MemoryDepth_g PARAM_VALUE.MemoryDepth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MemoryDepth_g}] ${MODELPARAM_VALUE.MemoryDepth_g}
}

proc update_MODELPARAM_VALUE.TrigInputs_g { MODELPARAM_VALUE.TrigInputs_g PARAM_VALUE.TrigInputs_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TrigInputs_g}] ${MODELPARAM_VALUE.TrigInputs_g}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH PARAM_VALUE.C_S00_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

