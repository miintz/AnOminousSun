#define BACK_PIN 9;
#define LISTEN_PIN 10;

Servo BackServo;
Servo ListenServo;

unit8_t CommandIn;

void setup() {
  Serial.begin(57600);
}

void loop() {
  //if we have some incomming serial data then..
  if (Serial.available() > 0)
  {
    //read 1 byte from the data sent by the pc
    CommandIn = Serial.read();
    //test if the pc sent an 'a' or 'b'
    switch (commandIn)
    {
      case 'a':
        {
          //listen loop on
          break;
        }
      case 'b':
        {
          //listen loop off
          break;
        }
      case 'x':
        {
          //back loop on
          break;
        }
      case 'y':
        {
          //back loop off
          break;
        }
    }
  }
}
