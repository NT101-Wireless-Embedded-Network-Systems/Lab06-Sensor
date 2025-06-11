#ifndef SENSETORADIO_H
#define SENSETORADIO_H

enum {
  AM_SENSETORADIO = 10,
  TIMER_PERIOD_MILLI = 500
};

typedef nx_struct SenseToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t value;
} SenseToRadioMsg;

#endif