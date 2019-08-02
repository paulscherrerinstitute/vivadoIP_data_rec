#------------------------------------------------------------------------------
#----------- DATA REC v1.0 IP-Core EPICS Template  [Recorder Control] ---------
#------------------------------------------------------------------------------
# $(DEV):                         Device name
# $(SYS):                         System name
# $(VME_ADDR_ADC_REC_REG_WRD):    Base address of the recorder (registers)
# $(VME_ADDR_ADC_REC_MEM_WRD):    Base address of the recorder (memory)
# $(DEPTH):                       Recorder memory depth (samples)
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Initialization
#------------------------------------------------------------------------------
record (fanout, "$(DEV)$(SYS)REC-INIT") {
   field(LNK1, "$(DEV)$(SYS)INIT-REC")
   field(LNK2, "$(DEV)$(SYS)INIT-SELFTRIG")    
   field(LNK3, "$(DEV)$(SYS)INIT-TRIG") 
}

record (fanout, "$(DEV)$(SYS)INIT-REC") {
   field(LNK1, "$(DEV)$(SYS)TOTSPLS")
   field(LNK2, "$(DEV)$(SYS)PRETRIG")    
}

record (fanout, "$(DEV)$(SYS)INIT-SELFTRIG") {
   field(LNK1, "$(DEV)$(SYS)SELFTRIG-LO")
   field(LNK2, "$(DEV)$(SYS)SELFTRIG-HI")    
   field(LNK3, "$(DEV)$(SYS)SELFTRIG-CTRL") 
}

record (seq, "$(DEV)$(SYS)INIT-TRIG") {
   field(DO1, "1")
   field(LNK1, "$(DEV)$(SYS)MINTRIGPERIOD.PROC")
   field(DO2, "0")
   field(LNK2, "$(DEV)$(SYS)TRIGSRC PP")  
   field(DO3, "0xFFFFFFFF") 
   field(LNK3, "$(DEV)$(SYS)EXTTRIG-SEL PP")   
   field(DO4, "1")
   field(LNK4, "$(DEV)$(SYS)SWTRIG PP")
   field(DO5, "0")
   field(LNK5, "$(DEV)$(SYS)ARM PP")
}

record(calcout,  "$(DEV)$(SYS)SPLS-MINUS-ONE") {
   field(DESC, "Internal")
   field(CALC, "$(DEPTH)-1")
   field(PINI, "YES")
   field(OUT, "$(DEV)$(SYS)SPLS-MINUS-ONE-FO")
   field(FLNK, "$(DEV)$(SYS)SPLS-MINUS-ONE-FO")
}
record (dfanout, "$(DEV)$(SYS)SPLS-MINUS-ONE-FO") {
   field(OUTA, "$(DEV)$(SYS)PRETRIG.HOPR")
   field(OUTB, "$(DEV)$(SYS)PRETRIG.DRVH")    
}

#------------------------------------------------------------------------------
# Status
#------------------------------------------------------------------------------
record(bi, "$(DEV)$(SYS)STATUS-SCAN") {
	field(SCAN, ".2 second")
	field(FLNK, "$(DEV)$(SYS)STATUS PP")
}

record(mbbi, "$(DEV)$(SYS)STATUS") {
   field(DESC, "Recorder status")
   field(DTYP, "regDev")
   field(INP,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x00 T=uint32")
   field(SCAN, "I/O Intr")
   field(PRIO, "HIGH")
   field(ZRVL, "0")
   field(ONVL, "1")
   field(TWVL, "2")
   field(THVL, "3")
   field(FRVL, "4")
   field(ZRST, "Idle")
   field(ONST, "Pre-Trigger")
   field(TWST, "Waiting for Trigger")
   field(THST, "Post-Trigger")
   field(FRST, "Done")
   field(FLNK, "$(DEV)$(SYS)CHECK")
}

record(calcout, "$(DEV)$(SYS)CHECK") {
   field(INPA, "$(DEV)$(SYS)STATUS")
   field(CALC, "A==4? 1:0")
   field(OOPT, "When Non-zero")
   field(OUT,  "$(DEV)$(SYS)READ0.PROC")
}

record(fanout, "$(DEV)$(SYS)READ0") {
   field(LNK1, "$(DEV)$(SYS)TRIG-CNT-FW PP")
   field(LNK2, "$(DEV)$(SYS)TRIG-CNT-SW.PROC")
   field(LNK3, "$(DEV)$(SYS)TRIG-CNT-DIFF.PROC")
   field(FLNK, "$(DEV)$(SYS)READ1")
}

record(fanout, "$(DEV)$(SYS)READ1") {
   field(LNK1, "$(DEV)$(SYS)ACQUIRE PP")
   field(FLNK, "$(DEV)$(SYS)READ2")
}

record(fanout, "$(DEV)$(SYS)READ2") {
   field(LNK1, "$(DEV)$(SYS)STAT-SW-EPICS PP")
}

record(bo, "$(DEV)$(SYS)ARM") {
   field(DESC, "Arm recorder")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x04 T=uint32")
   field(VAL,  "1")
   field(PINI, "YES")
   field(ZNAM, "Disarm")
   field(ONAM, "Arm")
}

#------------------------------------------------------------------------------
# Trigger Source
#------------------------------------------------------------------------------
record(mbbo, "$(DEV)$(SYS)TRIGSRC") {
   field(DESC, "Trigger Source")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x28 T=uint32 U=2000")
   field(ZRVL, "0")
   field(ONVL, "1")
   field(TWVL, "2")
   field(THVL, "4")
   field(ZRST, "Stopped")
   field(ONST, "External")
   field(TWST, "Free-Running")
   field(THST, "Self-Trigger")
}

record(mbbo, "$(DEV)$(SYS)EXTTRIG-SEL") {
   field(DESC, "External trigger select")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x30 T=uint32 U=2000")
<EXT-TRIG-SEL>
}

#------------------------------------------------------------------------------
# Minimal Time between Triggers
#------------------------------------------------------------------------------
record(ao, "$(DEV)$(SYS)MINTRIGPERIOD") {
   field(DESC, "Min. Trigger Period")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x2C T=uint32")
   field(SCAN, "Passive")
   field(VAL, "200")
   field(PINI, "YES")   
   field(PREC, "2")
   field(EGU, "ms")
   field(LINR, "SLOPE")   
   field(ESLO, "6.25e-6")
   field(EOFF, "0")
   field(LOPR, "10")
   field(DRVL, "10")
   field(HOPR, "20000")   
   field(DRVH, "20000")
}

#------------------------------------------------------------------------------
# Recording Configuration
#------------------------------------------------------------------------------
record(ao, "$(DEV)$(SYS)TOTSPLS") {
   field(DESC, "Total samples to record")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x0C T=uint32 U=2000")
   field(VAL,  "$(DEPTH)")
   field(PINI, "YES")
   field(LOPR, "1")
   field(DRVL, "1")
   field(HOPR, "$(DEPTH)")
   field(DRVH, "$(DEPTH)")   
}

record(ao, "$(DEV)$(SYS)PRETRIG") {
   field(DESC, "Pre-trigger samples")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x08 T=uint32 U=2000")
   field(VAL,  "0")
   field(PINI, "YES")
   field(LOPR, "0")
   field(DRVL, "0")   
}

#------------------------------------------------------------------------------
# Software Trigger
#------------------------------------------------------------------------------
#Should always be one, otherwise freerunnning mode will not work
record(bo, "$(DEV)$(SYS)SWTRIG") {
   field(DESC, "Force trigger")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x1C T=uint32")
   field(VAL,  "1")
   field(PINI, "YES")
   field(ZNAM, "Deasserted")
   field(ONAM, "Asserted")
}

#------------------------------------------------------------------------------
# Self Trigger
#------------------------------------------------------------------------------
record(ao, "$(DEV)$(SYS)SELFTRIG-LO") {
   field(DESC, "Selftrig Low-Limit")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x10 T=int32 U=2000")
   field(VAL, "-32768")
   field(PINI, "YES")
}

record(ao, "$(DEV)$(SYS)SELFTRIG-HI") {
   field(DESC, "Selftrig High-Limit")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x14 T=int32 U=2000")
   field(VAL, "32767")
   field(PINI, "YES")
}

record(bo, "$(DEV)$(SYS)SELFTRIG-ONEXIT") {
   field(DESC, "Trigger on exit from range")
   field(FLNK, "$(DEV)$(SYS)SELFTRIG-CTRL-REG")
   field(VAL, "0")
   field(PINI, "YES")
}

record(bo, "$(DEV)$(SYS)SELFTRIG-ONENTER") {
   field(DESC, "Trigger on enter to range")
   field(FLNK, "$(DEV)$(SYS)SELFTRIG-CTRL-REG")
   field(VAL, "0")
   field(PINI, "YES")
}

<SELFTRIG-ENA>

record(calc,  "$(DEV)$(SYS)SELFTRIG-CHENA-LO") {
   field(DESC, "Internal")
<SELFTRIG-CALC-IN>
   field(CALC, "<SELFTRIG-CALC-CALC>")
   field(FLNK, "$(DEV)$(SYS)SELFTRIG-CHENA")
}

record(calc,  "$(DEV)$(SYS)SELFTRIG-CHENA") {
   field(DESC, "Internal")
   field(INPA, "$(DEV)$(SYS)SELFTRIG-CHENA-LO PP")
   field(CALC, "(A<<0)")
   field(FLNK, "$(DEV)$(SYS)SELFTRIG-CTRL-REG")
}

record(calcout,  "$(DEV)$(SYS)SELFTRIG-CTRL-REG") {
   field(DESC, "Internal")
   field(INPA, "$(DEV)$(SYS)SELFTRIG-ONEXIT PP")
   field(INPB, "$(DEV)$(SYS)SELFTRIG-ONENTER PP")
   field(INPC, "$(DEV)$(SYS)SELFTRIG-CHENA PP")
   field(CALC, "(A<<8)|(B<<16)|(C&0xFF)")
   field(OUT,  "$(DEV)$(SYS)SELFTRIG-CTRL PP")
}

record(ao, "$(DEV)$(SYS)SELFTRIG-CTRL") {
   field(DESC, "Selftrig Control Register")
   field(DTYP, "regDev")
   field(OUT,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x18 T=uint32")
}

#------------------------------------------------------------------------------
# Trigger counter firmware
#------------------------------------------------------------------------------
record(ai, "$(DEV)$(SYS)TRIG-CNT-FW") {
   field(DESC, "Trigger count")
   field(DTYP, "regDev")
   field(INP,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x0020 T=uint32")   
#   field(SCAN, "1 second")
}

#------------------------------------------------------------------------------
# Trigger counter interface
#------------------------------------------------------------------------------
record(calcout, "$(DEV)$(SYS)TRIG-CNT-SW") {
   field(DESC, "Trigger cnt SW")
   field(INPA, "$(DEV)$(SYS)TRIG-CNT-SW.VAL")
   field(CALC, "A+1")
   field(OOPT, "Every Time" )
   field(DOPT, "Use CALC" )
   field(EGU,  "counts")
}

record(ao, "$(DEV)$(SYS)TRIG-CNT-OFFS") {
   field(DESC, "Trigger cnt offs")
   field(VAL, "0")
   field(EGU, "counts")
}

record(calcout, "$(DEV)$(SYS)TRIG-CNT-DIFF") {
   field(DESC, "Trigger cnt diff")
   field(INPA, "$(DEV)$(SYS)TRIG-CNT-FW")
   field(INPB, "$(DEV)$(SYS)TRIG-CNT-SW")
   field(INPC, "$(DEV)$(SYS)TRIG-CNT-OFFS")
   field(CALC, "A-B-C")
   field(EGU,  "counts")
}

#------------------------------------------------------------------------------
# Trigger counter firmware
#------------------------------------------------------------------------------
record(ai, "$(DEV)$(SYS)STAT-SW-EPICS") {
   field(DESC, "Duration of embedded EPICS")
   field(DTYP, "regDev")
   field(INP,  "@$(VME_ADDR_ADC_REC_REG_WRD):0x0024 T=uint32")
   field(PREC, "3")
   field(LINR, "SLOPE")
   field(ESLO, "0.000008")
   field(EOFF, "0")
   field(EGU,  "ms")
}

#------------------------------------------------------------------------------
# Read all data
#------------------------------------------------------------------------------
record(seq, "$(DEV)$(SYS)ACQUIRE") {
<READ-DATA>
   field(FLNK, "$(DEV)$(SYS)POSTREAD")
}

#------------------------------------------------------------------------------
# Post Read Operations (re-arm)
#------------------------------------------------------------------------------
record(seq, "$(DEV)$(SYS)POSTREAD") {
   field(DO1, "1")
   field(LNK1, "$(DEV)$(SYS)ARM.PROC")
}

#------------------------------------------------------------------------------
# Data channels
#------------------------------------------------------------------------------
<DATA-RECS>

#------------------------------------------------------------------------------
# End of file
#------------------------------------------------------------------------------

