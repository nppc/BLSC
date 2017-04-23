#include <EEPROM.h>
#include <Servo.h>

Servo myservo;  // create servo object to control a servo


 int val; 
 int encoder0PinA = 2;
 int encoder0PinB = 4;
 int encoder0But  = 5;
 int encoder0PinALast = LOW;
 int n = LOW;
 bool spindelOn = LOW;
 int spindleSpeed = 0;
 int EEaddress = 5;

 void setup() { 
   pinMode (encoder0PinA,INPUT);
   pinMode (encoder0PinB,INPUT);
   pinMode (encoder0But,INPUT_PULLUP);
   pinMode (13,OUTPUT);
   Serial.begin (9600);
   myservo.attach(9);  // attaches the servo on pin 9 to the servo object
   myservo.writeMicroseconds(1000); //Initialize ESC
   spindleSpeed = EEPROM.read(EEaddress);
   if(spindleSpeed>100){spindleSpeed =0;}
 } 

 void loop() { 
   n = digitalRead(encoder0PinA);
   if ((encoder0PinALast == LOW) && (n == HIGH)) {
     if (digitalRead(encoder0PinB) == LOW) {
       spindleSpeed--;
       spindleSpeed = spindleSpeed<0 ? 0 : spindleSpeed;
     } else {
       spindleSpeed++;
       spindleSpeed = spindleSpeed>100 ? 100 : spindleSpeed;
     }
     commandSpindle(spindleSpeed,spindelOn);
     Serial.println(spindleSpeed);
   } 
   encoder0PinALast = n;

   // check Encoder button
   if (digitalRead(encoder0But)==LOW){   // pressed
     delay(20); // debouncing
     if (digitalRead(encoder0But)==LOW){   // still pressed
        // wait until button released 
        while (digitalRead(encoder0But)==LOW){} // wait while pressed
        delay(20);
        if (digitalRead(encoder0But)==HIGH){ // still released
          // do something
          spindelOn = !spindelOn;
          commandSpindle(spindleSpeed,spindelOn);
          Serial.print(spindelOn);
          Serial.print(",");
          Serial.println(spindleSpeed);
  
          // write setting to EEPROM
          byte tmpE = EEPROM.read(EEaddress);
          if(tmpE!=spindleSpeed && !spindelOn){
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
  if(spindelOn){
    myservo.writeMicroseconds(sPWM); //Stop
  }else{
    myservo.writeMicroseconds(1000); //Stop
  }
  if(sOn){digitalWrite(13, HIGH);}else{digitalWrite(13, LOW);}
}
