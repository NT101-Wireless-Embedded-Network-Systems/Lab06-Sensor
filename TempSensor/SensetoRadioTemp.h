#ifndef SENSETORADIOTEMP_H
#define SENSETORADIOTEMP_H

enum {
  AM_SENSETORADIOTEMP = 10,
  TIMER_PERIOD_MILLI = 250
};

typedef nx_struct SenseToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t value;
} SenseToRadioMsg;

#endif
