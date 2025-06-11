#include "SensetoRadioTemp.h"

configuration SensetoRadioTempAppC {}

implementation {
  components MainC;
  components LedsC;
  components SensetoRadioTempC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_SENSETORADIOTEMP);
  components new SensirionSht11C() as TempSource;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMSend -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.Read -> TempSource.Temperature;
}
