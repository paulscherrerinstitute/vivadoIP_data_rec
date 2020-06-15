/*############################################################################
#  Copyright (c) 2020 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Jonas Purtschert
############################################################################*/

#include "data_rec.h"


DataRec_Status DataRec_GetStatus(const uint32_t baseAddr)
{
  return (DataRec_Status) Xil_In32(baseAddr + DATAREC_REG_STATUS);
}

void DataRec_SetNumSamples(const uint32_t baseAddr, const uint32_t preTrigSamples, const uint32_t totalSamples)
{
  Xil_Out32(baseAddr + DATAREC_REG_PRE_TRIG, preTrigSamples);
  Xil_Out32(baseAddr + DATAREC_REG_TOT_SAMPLES, totalSamples);
}

void DataRec_Arm(const uint32_t baseAddr)
{
  Xil_Out32(baseAddr + DATAREC_REG_CTRL, 0x1);
}

void DataRec_ClearTriggerCounter(const uint32_t baseAddr)
{
  Xil_Out32(baseAddr + DATAREC_REG_CTRL, 0x10000);
}

void DataRec_SetSelfTriggerRange(const uint32_t baseAddr, const uint32_t low, const uint32_t high)
{
  Xil_Out32(baseAddr + DATAREC_REG_SELF_TRIG_LOW, low);
  Xil_Out32(baseAddr + DATAREC_REG_SELF_TRIG_HIGH, high);
}

void DataRec_EnableSelfTrigger(const uint32_t baseAddr, const uint32_t channel, const uint8_t trigOut, const uint8_t trigIn)
{
  uint32_t reg;
  reg = channel&0xFF;
  reg |= (trigOut ? 0x00100 : 0x0);
  reg |= (trigIn  ? 0x10000 : 0x0);
  Xil_Out32(baseAddr + DATAREC_REG_SELF_TRIG_CFG, reg);
}

void DataRec_SetSwTrigger(const uint32_t baseAddr, const uint8_t enableSwTrig)
{
  Xil_Out32(baseAddr + DATAREC_REG_SW_TRIG, enableSwTrig);
}

uint32_t DataRec_GetTriggerCounter(const uint32_t baseAddr)
{
  return Xil_In32(baseAddr + DATAREC_REG_TRIG_CNT);
}

uint32_t DataRec_GetDoneTime(const uint32_t baseAddr)
{
  return Xil_In32(baseAddr + DATAREC_REG_DONE_TIME);
}

void DataRec_EnableTrigger(const uint32_t baseAddr, const uint8_t sw, const uint8_t ext, const uint8_t self)
{
  uint8_t enTrig = 0;
  enTrig |= sw ? DATAREC_TRIG_SW : 0;
  enTrig |= ext ? DATAREC_TRIG_EXT : 0;
  enTrig |= self ? DATAREC_TRIG_SELF : 0;
  Xil_Out32(baseAddr + DATAREC_REG_TRIG_EN, enTrig);
}

void DataRec_SetMinTriggerPeriod(const uint32_t baseAddr, const uint32_t minTrig)
{
  Xil_Out32(baseAddr + DATAREC_REG_TRIG_MIN_PERIOD, minTrig);
}

void DataRec_EnableExtTriggerIn(const uint32_t baseAddr, const uint32_t extTrigIn)
{
  Xil_Out32(baseAddr + DATAREC_REG_TRIG_EXT_EN, extTrigIn);
}

void DataRec_GetParameters(const uint32_t baseAddr, DataRec_Parameter *param)
{
  uint32_t regInputs   = Xil_In32(baseAddr + DATAREC_REG_PARAM_INPUTS);
  uint32_t regMemDepth = Xil_In32(baseAddr + DATAREC_REG_PARAM_MEMDEPTH);
  if (param) {
    param->NumOfInputs = regInputs & 0xFF;
    param->InputWidth  = (regInputs>>8) & 0xFF;
    param->TrigInputs  = (regInputs>>16) & 0xFF;
    param->MemoryDepth = regMemDepth;
  }
}

void DataRec_GetData(const uint32_t baseAddr, uint32_t *buffer, const uint8_t channel, const uint32_t offset, const uint32_t numSamples)
{
  uint32_t regMemDepth = Xil_In32(baseAddr + DATAREC_REG_PARAM_MEMDEPTH);
  uint32_t memOffset = 0x80;
  uint32_t channelOffset = channel * regMemDepth * 0x4 + offset*4;
  // !!! To Be Optimized:
  for (uint32_t i=0;i<numSamples;i++) {
    *(buffer + i) = Xil_In32(baseAddr + memOffset + channelOffset + i*4);
  }
}

