#include <stdlib.h>
#include <EEPROM.h>
#include <Servo.h>
#include "U8glib.h"
#include <RotaryEncoder.h> // by Matthias Hertel

#define encoder0But 5 // pin for encoder pushbutton

RotaryEncoder encoder(2, 4); // encoder A, B pins

U8GLIB_SSD1306_128X64 u8g(U8G_I2C_OPT_NO_ACK);  // Display which does not send AC

Servo myservo;  // create servo object to control a servo

 bool spindleOn = LOW;
 int spindleSpeed = 0;
 int EEaddress = 5;
 
 char tmp_string[6]; // for printing numbers

// The Interrupt Service Routine for Pin Change Interrupt 1
// This routine will only be called on any signal change on A2 and A3: exactly where we need to check.
ISR(PCINT2_vect) {
  encoder.tick(); // just call tick() to check the state.
}

 void setup() { 
   pinMode (encoder0But,INPUT_PULLUP);
   pinMode (13,OUTPUT);

  // PCIE0, PCMSK0: D8-D13 (PCINT0 - PCINT5)
  // PCIE1, PCMSK1: A0-A5 (PCINT8 - PCINT13)
  // PCIE2, PCMSK2: D0-D7 (PCINT16 - PCINT23)
  PCICR |= (1 << PCIE2);
  PCMSK2 |= (1 << PCINT18) | (1 << PCINT20); // D2, D4

   Serial.begin (9600);
   myservo.attach(9);  // attaches the servo on pin 9 to the servo object
   myservo.writeMicroseconds(1000); //Initialize ESC
   spindleSpeed = EEPROM.read(EEaddress);
   if(spindleSpeed>100){spindleSpeed =0;}
   encoder.setPosition(spindleSpeed);
 } 

 void loop() { 
    // lcd refresh routines
    u8g.firstPage();  
    do {
      draw();
    } while( u8g.nextPage() );
   // spindle control routines
  int newSpindleSpeed = encoder.getPosition();
  if (spindleSpeed != newSpindleSpeed) {
    spindleSpeed  = constrain(newSpindleSpeed,0,100);
    encoder.setPosition(spindleSpeed);
  }

   // check Encoder button
   if (digitalRead(encoder0But)==LOW){   // pressed
     delay(20); // debouncing
     if (digitalRead(encoder0But)==LOW){   // still pressed
        // wait until button released 
        while (digitalRead(encoder0But)==LOW){} // wait while pressed
        delay(20);
        if (digitalRead(encoder0But)==HIGH){ // still released
          // do something
          spindleOn = !spindleOn;
          commandSpindle(spindleSpeed,spindleOn);
          Serial.print(spindleOn);
          Serial.print(",");
          Serial.println(spindleSpeed);
  
          // write setting to EEPROM
          byte tmpE = EEPROM.read(EEaddress);
          if(tmpE!=spindleSpeed && !spindleOn){
            delay(100);
            EEPROM.write(EEaddress,spindleSpeed);
            Serial.println("WriteEEPROM");
  
          }
        }
     }
   }
} 

void commandSpindle(byte Speed, bool sOn){
  int sPWM = map(Speed, 0, 100, 1000, 2000);
  if(spindleOn){
    myservo.writeMicroseconds(sPWM); //Stop
  }else{
    myservo.writeMicroseconds(1000); //Stop
  }
  if(sOn){digitalWrite(13, HIGH);}else{digitalWrite(13, LOW);}
}

void draw(void) {
  u8g.setFont(u8g_font_fur14); // height 14
  u8g.drawStr(93,15,(spindleOn ? "ON" : "OFF"));

  u8g.drawStr(0,33,"%"); // height 14
  u8g.drawStr(0,60,"rpm"); // height 14
  
  u8g.setFont(u8g_font_fub20n);// height 25
  itoa(spindleSpeed, tmp_string, 10);
  u8g.drawStr(40,33,tmp_string);
  u8g.drawStr(40,63,"0"); // not yet implemented
  
}
