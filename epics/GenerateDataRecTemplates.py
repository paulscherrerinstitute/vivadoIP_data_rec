##############################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
##############################################################################

from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("-channels", dest="channels", help="Number of channels", required=True, type=int)
parser.add_argument("-exttrigcnt", dest="exttrigcnt", help="Number of external trigger inputs", required=True, type=int)
parser.add_argument("-outpath", dest="outpath", help="Output Path", required=True, type=str)
parser.add_argument("-outname", dest="outname", help="Output File Name", required=True, type=str)
args = parser.parse_args()

OUTPUT_FILE_PATH = args.outpath + "/" + args.outname + ".template"

MBBO_FIELDS = ["ZR", "ON", "TW", "TH", "FR", "FV", "SX", "SV", "EI", "NI", "TE", "EL", "TV", "TT", "FT", "FF"]


#Read control template
with open("TemplateInput/CONTROL.tpl", "r") as f:
    content = f.read()

#Add selftrig enable fields
selftrig_ena = []
for ch in range(args.channels):
    txt = "\n".join(
        (
            "record(bo, \"$(DEV)$(SYS)SELFTRIG-ENA-CH{}\") {{".format(ch),
            "   field(DESC, \"Enable Selftrig CH{}\")".format(ch),
            "   field(VAL, \"0\")",
            "   field(PINI, \"YES\")",
            "   field(FLNK, \"$(DEV)$(SYS)SELFTRIG-CHENA-LO\")",
            "}"
        )
    )
    selftrig_ena.append(txt)
selftrig_ena_all = "\n\n".join(selftrig_ena)
content = content.replace("<SELFTRIG-ENA>", selftrig_ena_all)

#Add external trigger select fields
entries = []
for trig in range(args.exttrigcnt):
    entries.append("   field({id}VL, \"{val}\")".format(id=MBBO_FIELDS[trig], val=2**trig))
    entries.append("   field({id}ST, \"{val}\")".format(id=MBBO_FIELDS[trig], val="Trigger " + str(trig)))
content = content.replace("<EXT-TRIG-SEL>", "\n".join(entries))

#Add calculation for selftriggger enable
selftrig_calc_in = []
selftrig_calc_calc = []
for ch in range(args.channels):
    letter = chr(ord("A")+ch)
    selftrig_calc_in.append("   field(INP{}, \"$(DEV)$(SYS)SELFTRIG-ENA-CH{} PP\")".format(letter, ch))
    selftrig_calc_calc.append("({}<<{})".format(letter, ch))
selftrig_calc_in_all = "\n".join(selftrig_calc_in)
selftrig_calc_calc_all = "|".join(selftrig_calc_calc)
content = content.replace("<SELFTRIG-CALC-IN>", selftrig_calc_in_all)
content = content.replace("<SELFTRIG-CALC-CALC>", selftrig_calc_calc_all)

#Add data records
data_recs = []
read_data = []
for ch in range(args.channels):
    txt = "\n".join(
        (
            "record(aai, \"$(DEV)$(SYS)DATA-CH{}\") {{".format(ch),
            "   field(DESC, \"Channel {} Data\")".format(ch),
            "   field(DTYP, \"regDev\")",
            "   field(INP, \"@$(VME_ADDR_ADC_REC_MEM_WRD):{}*4*$(DEPTH) T=int32\")".format(ch),
            "   field(NELM, \"$(DEPTH)\")",
            "   field(FTVL, \"LONG\")",
            "}"
        )
    )
    data_recs.append(txt)
    read_data.append("   field(LNK{}, \"$(DEV)$(SYS)DATA-CH{} PP\")".format(ch+1, ch))
data_recs_all = "\n\n".join(data_recs)
read_data_all = "\n".join(read_data)
content = content.replace("<DATA-RECS>", data_recs_all)
content = content.replace("<READ-DATA>", read_data_all)

with open(OUTPUT_FILE_PATH, "w+") as f:
    f.write(content)

