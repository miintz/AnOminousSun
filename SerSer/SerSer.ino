#define BACK_PIN 9
#define LISTEN_PIN 10

#include <Servo.h>

Servo ListenServo;
Servo BackServo;

int pos = 0;

int CommandIn;

void setup() {
  Serial.begin(57600);

  BackServo.attach(9);
  ListenServo.attach(10);
}

void loop() {
  //if we have some incomming serial data then..
  if (Serial.available() > 0)
  {
    //read 1 byte from the data sent by the pc
    CommandIn = Serial.read();
    //test if the pc sent an 'a' or 'b'
    switch (CommandIn)
    {
      case 'a':
        {
          //listen loop on
          for (pos = 0; pos < 180; pos += 1) // goes from 0 degrees to 180 degrees
          { // in steps of 1 degree
            ListenServo.write(pos);              // tell servo to go to position in variable 'pos'
            delay(15);                       // waits 15ms for the servo to reach the position
          }

          break;
        }
      case 'b':
        {
          //listen loop off
          for (pos = 180; pos >= 1; pos -= 1) // goes from 180 degrees to 0 degrees
          {
            ListenServo.write(pos);              // tell servo to go to position in variable 'pos'
            delay(15);                       // waits 15ms for the servo to reach the position
          }
          break;
        }
      case 'x':
        {
          //listen loop off
          for (pos = 0; pos < 180; pos += 1) // goes from 180 degrees to 0 degrees
          {
            BackServo.write(pos);              // tell servo to go to position in variable 'pos'
            delay(15);                       // waits 15ms for the servo to reach the position
          }
          //back loop on
          break;
        }
      case 'y':
        {
          //back loop off

          for (pos = 180; pos >= 1; pos -= 1) // goes from 180 degrees to 0 degrees
          {
            BackServo.write(pos);              // tell servo to go to position in variable 'pos'
            delay(15);                       // waits 15ms for the servo to reach the position
          }
          break;
        }
      case 'z':
        {
          //rest position, to not overload it
          
          pos = 0;
          BackServo.write(90);
          ListenServo.write(90);
          
          delay(50);
          
          break;
        }
      default:
        {
          Serial.write(CommandIn);
          for (pos = 0; pos < 180; pos += 1) // goes from 0 degrees to 180 degrees
          { // in steps of 1 degree
            ListenServo.write(pos);              // tell servo to go to position in variable 'pos'
            delay(1);                       // waits 15ms for the servo to reach the position
          }
          for (pos = 180; pos >= 1; pos -= 1) // goes from 180 degrees to 0 degrees
          {
            BackServo.write(pos);              // tell servo to go to position in variable 'pos'
            delay(1);                       // waits 15ms for the servo to reach the position
          }
          break;
        }
    }
  }
}
