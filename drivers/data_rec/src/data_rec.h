/*############################################################################
#  Copyright (c) 2020 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
#  Authors: Jonas Purtschert
############################################################################*/

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

//*******************************************************************************
// Includes
//*******************************************************************************
#include <stdint.h>
#include <xil_io.h>

//*******************************************************************************
// AXI Register
//*******************************************************************************
#define DATAREC_REG_STATUS          0x00
#define DATAREC_REG_CTRL            0x04
#define DATAREC_REG_PRE_TRIG        0x08
#define DATAREC_REG_TOT_SAMPLES     0x0C
#define DATAREC_REG_SELF_TRIG_LOW   0x10
#define DATAREC_REG_SELF_TRIG_HIGH  0x14
#define DATAREC_REG_SELF_TRIG_CFG   0x18
#define DATAREC_REG_SW_TRIG         0x1C
#define DATAREC_REG_TRIG_CNT        0x20
#define DATAREC_REG_DONE_TIME       0x24
#define DATAREC_REG_TRIG_EN         0x28
#define DATAREC_REG_TRIG_MIN_PERIOD 0x2C
#define DATAREC_REG_TRIG_EXT_EN     0x30
#define DATAREC_REG_PARAM_INPUTS    0x34
#define DATAREC_REG_PARAM_MEMDEPTH  0x38

//*******************************************************************************
// Types
//*******************************************************************************
typedef enum DataRec_Status {
  Idle               = 0,
  AcquirePreTrigger  = 1,
  WaitingTrigger     = 2,
  AcquirePostTrigger = 3,
  RecordingDone      = 4,
} DataRec_Status;

// component generic parameters:
typedef struct DataRec_Parameter {
  uint8_t NumOfInputs;
  uint8_t InputWidth;
  uint32_t MemoryDepth;
  uint8_t TrigInputs;
} DataRec_Parameter;

#define DATAREC_TRIG_EXT  0x1
#define DATAREC_TRIG_SELF 0x2
#define DATAREC_TRIG_SW   0x4

//*******************************************************************************
// Functions
//*******************************************************************************

DataRec_Status DataRec_GetStatus(const uint32_t baseAddr);
void DataRec_Arm(const uint32_t baseAddr);
void DataRec_ClearTriggerCounter(const uint32_t baseAddr);
void DataRec_SetSelfTriggerRange(const uint32_t baseAddr, const uint32_t low, const uint32_t high);
void DataRec_EnableSelfTrigger(const uint32_t baseAddr, const uint32_t channel, const uint8_t trigOut, const uint8_t trigIn);
void DataRec_SetSwTrigger(const uint32_t baseAddr, const uint8_t enableSwTrig);
uint32_t DataRec_GetTriggerCounter(const uint32_t baseAddr);
uint32_t DataRec_GetDoneTime(const uint32_t baseAddr);
void DataRec_EnableTrigger(const uint32_t baseAddr, const uint32_t enTrig);
void DataRec_SetMinTriggerPeriod(const uint32_t baseAddr, const uint32_t minTrig);
void DataRec_EnableExtTriggerIn(const uint32_t baseAddr, const uint32_t extTrigIn);
void DataRec_GetParameters(const uint32_t baseAddr, DataRec_Parameter *param);
void DataRec_GetData(const uint32_t baseAddr, uint32_t *buffer, const uint8_t channel, const uint32_t offset, const uint32_t numSamples);

#ifdef __cplusplus
}
#endif

