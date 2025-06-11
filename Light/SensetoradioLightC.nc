#include <Timer.h>
#include "SensetoradioLight.h"

module SensetoRadioLightC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;	
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t>;
}

implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;
  uint16_t lux;

  // Cập nhật LED theo mức sáng
  void updateLeds(uint16_t luxVal) {
    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Off();

    if (luxVal > 1000) {
      call Leds.led0On();
    } else if (luxVal >= 100) {
      call Leds.led1On();
    } else {
      call Leds.led2On();
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    } else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    call Read.read();
  }

  event void Read.readDone(error_t result, uint16_t data) {
    if (result == SUCCESS) {
      lux = (data * 2.5 * 6250.0) / 4096.0;
      updateLeds(lux);

      if (!busy) {
        SenseToRadioMsg* datapkt = (SenseToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(SenseToRadioMsg)));
        if (datapkt == NULL) return;

        datapkt->nodeid = TOS_NODE_ID;
        datapkt->value = lux;

        if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(SenseToRadioMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
}
