// Last Update: Phillip Truppelli 4/29/2020
// A sensing tool to determine the distance between two moving carts that follow 
// each other along a track.

// Import Libraries
#include<Servo.h>

//Variables & pin numbers for the hall effect sensor
const int hallPin = A3;
const int servoPin = 5; //Pins identified where the driver board is connected
int inputVal = 0;
long      duration;
int       distance;

//Variables for servo motor
Servo servo1;
float pos = 0.0;

// Start main function

void setup()
{
  //Establish serial connection through COM3 port
  Serial.begin(9600);

  //Variable settings for servo motor
  servo1.attach( )          //Attaching servo motor to Arduino pin _

  //Variable Settings for hall effect sensor
  pinMode(13, OUTPUT);          // Pin 13 has an LED connected on most Arduino boards:
  pinMode(hallPin,INPUT);    //Pin A3 is connected to the output of proximity sensor

}
void loop() 
{

// Reads the hallPin, returns the voltage the Hall effect sensor produces
volts = pulseIn(hallPin,HIGH);

// Calculating the distance in cm
distance = 10*((2615/((Volts-2.5)/0.0025))-1.534);

// Prints the distance on the Serial Monitor
Serial.print("Distance: ");
Serial println(distance);

// Start the brakes if the distance is less than 5cm

if (distance < 1)
{
  digitalWrite(13, HIGH); // LED on
  pos = 135;            // Hard Brake
  servo1.write(pos); 
  delay(1000);          // Wait for 5 second after brake 
  pos = 90;             // Release brakes
  servo1.write(pos);
}

else if(distance < 2)
{
  // The distance between the carts is too little
  digitalWrite(13, HIGH); // LED on
  pos = 140;            // Hard Brake
  servo1.write(pos); 
  delay(1000);          // Wait for 5 second after brake 
  pos = 90;             // Release brakes
  servo1.write(pos);
}
  
  else if(distance < 3)
{
  // The distance between the carts is too little
  digitalWrite(13, HIGH); // LED on
  pos = 135;            // Hard Brake
  servo1.write(pos); 
  delay(1000);          // Wait for 5 second after brake 
  pos = 90;             // Release brakes
  servo1.write(pos);
}
  
  else if(distance < 4)
{
  // The distance between the carts is too little
  digitalWrite(13, HIGH); // LED on
  pos = 135;            // Hard Brake
  servo1.write(pos); 
  delay(1000);          // Wait for 5 second after brake 
  pos = 90;             // Release brakes
  servo1.write(pos);
}
  
  else (distance > 4)
{
  // the distance between the carts is adequate nothing needs to be done
}
        
  inputVal = analogRead(hallPin);
  Serial.println(inputVal);
  delay(100); // wait 0.1 seconds 
}

