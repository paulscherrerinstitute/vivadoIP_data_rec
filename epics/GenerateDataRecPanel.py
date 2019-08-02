##############################################################################
#  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Oliver Bruendler
##############################################################################

from argparse import ArgumentParser
from copy import deepcopy

parser = ArgumentParser()
parser.add_argument("-channels", nargs="+", dest="channels", help="Channel names separated by spaces", required=True, type=str)
parser.add_argument("-exttrigcnt", dest="exttrigcnt", help="Number of external trigger inputs", required=True, type=int)
parser.add_argument("-outpath", dest="outpath", help="Output Path", required=True, type=str)
parser.add_argument("-outname", dest="outname", help="Output File Name", required=True, type=str)
args = parser.parse_args()

OUTPUT_FILE_PATH = args.outpath + "/" + args.outname + ".ui"

CHANNEL_RGB = [(0, 0, 255),
               (255, 0, 0),
               (0, 255, 0),
               (255, 0, 255),
               (255, 255, 0),
               (170, 170, 0)]

CH_COUNT = len(args.channels)

#Checks
if CH_COUNT > 6:
    raise Exception("ERROR: caCartesianPlot only supports up to 6 channels. Consider generating a panel for less channels" +
                    " and modify it manually.")

#Read control template
with open("PanelInput/Panel.tpl", "r") as f:
    content = f.read()

#Add selftrig enable buttons
selftrig_ena = []
with open("PanelInput/selftrig_ena_item.tpl", "r") as f:
    item = f.read()
for i, ch in enumerate(args.channels):
    selftrig_ena.append(item.replace("<CHANNEL>", "CH{}".format(i)))
selftrig_ena_all = "\n".join(selftrig_ena)
content = content.replace("<SELFTRIG-ENA>", selftrig_ena_all)

#Add plot labels
plot_labels = []
with open("PanelInput/ch_label_item.tpl", "r") as f:
    item = f.read()
for n, ch in enumerate(args.channels):
    thisItem = deepcopy(item)
    thisItem = thisItem.replace("<ROW>", str(n))
    thisItem = thisItem.replace("<CHNAME>", ch)
    thisItem = thisItem.replace("<COLOR_R>", str(CHANNEL_RGB[n][0]))
    thisItem = thisItem.replace("<COLOR_G>", str(CHANNEL_RGB[n][1]))
    thisItem = thisItem.replace("<COLOR_B>", str(CHANNEL_RGB[n][2]))
    plot_labels.append(thisItem)
plot_labels_all = "\n".join(plot_labels)
content = content.replace("<PLOT-LABELS>", plot_labels_all)

#Add wave channels
wave_channels = []
with open("PanelInput/wave_channel.tpl", "r") as f:
    item = f.read()
for i in range(6):
    thisItem = deepcopy(item)
    if i < CH_COUNT:
        thisItem = thisItem.replace("<DATA>", ";$(DEV):$(SYS)-REC-DATA-CH{}".format(i))
    else:
        thisItem = thisItem.replace("<DATA>", ";")
    thisItem = thisItem.replace("<COLOR_R>", str(CHANNEL_RGB[i][0]))
    thisItem = thisItem.replace("<COLOR_G>", str(CHANNEL_RGB[i][1]))
    thisItem = thisItem.replace("<COLOR_B>", str(CHANNEL_RGB[i][2]))
    thisItem = thisItem.replace("<CH>", str(i+1))
    wave_channels.append(thisItem)
wave_channels_all = "\n".join(wave_channels)
content = content.replace("<WAVE-CHANNELS>", wave_channels_all)

with open(OUTPUT_FILE_PATH, "w+") as f:
    f.write(content)

