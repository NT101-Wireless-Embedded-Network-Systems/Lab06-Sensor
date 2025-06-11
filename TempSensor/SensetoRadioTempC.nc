#include <Timer.h>
#include "SensetoRadioTemp.h"

module SensetoRadioTempC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as Read;
}
implementation {

  message_t pkt;
  bool busy = FALSE;

  void setLeds(uint16_t val) {
    if (val & 0x01)
      call Leds.led0On();
    else 
      call Leds.led0Off();
    if (val & 0x02)
      call Leds.led1On();
    else
      call Leds.led1Off();
    if (val & 0x04)
      call Leds.led2On();
    else
      call Leds.led2Off();
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
      // Giới hạn an toàn giá trị ADC (phòng lỗi cảm biến)
      if (data < 100 || data > 4000) return;

      // Chỉ gửi khi radio không bận
      if (!busy) {
        SenseToRadioMsg* btrpkt = (SenseToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(SenseToRadioMsg)));
        if (btrpkt == NULL) return;

        // Tính toán và lấy phần nguyên của nhiệt độ
        float temp_with_decimal = -39.60 + 0.01 * data;
        int16_t temp_integer_only = (int16_t)temp_with_decimal;
        
        btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->value = (nx_uint16_t)temp_integer_only;

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