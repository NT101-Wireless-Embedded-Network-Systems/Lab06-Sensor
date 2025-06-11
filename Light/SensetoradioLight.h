#ifndef SENSETORADIOLIGHT_H
#define SENSETORADIOLIGHT_H

enum {
  AM_SENSETORADIOLIGHT = 10,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct SenseToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t value;
} SenseToRadioMsg;

#endif
