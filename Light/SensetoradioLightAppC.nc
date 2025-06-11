#include "SensetoradioLight.h"

configuration SensetoradioLightAppC {}

implementation {
  components MainC;
  components LedsC;
  components SensetoRadioLightC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_SENSETORADIOLIGHT);
  components new HamamatsuS10871TsrC() as LightSource;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Read -> LightSource;
}
