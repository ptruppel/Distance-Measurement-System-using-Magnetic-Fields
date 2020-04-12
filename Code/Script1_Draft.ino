// A sensing tool to determine the distance between two moving carts that follow 
// each other along a track.

// Import Libraries
#include<Servo.h>

//Variables & pin numbers for the hall effect sensor
const int trigPin = _;
const int echoPin = _;
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
  pinMode(trigPin, OUTPUT); //Sets the trigPin as Output
  pinMode(echoPin, INPUT);  //Sets the echoPin as an Input

}

// Start Measure Distance
// Clears the trigPin
digitalWrite(trigPin, LOW);
delayMicroseconds(2);

// Sets the trigPin to high for 10 micro seconds
digitalWrite(trigPin, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin,LOW);

// Reads the echoPin, returns the voltage the Hall effect sensor produces
volts = pulseIn(echoPin,HIGH);

// Calculating the distance in cm
distance = 10*((2615/((Volts-2.5)/0.0025))-1.534);

// Prints the distance on the Serial Monitor
Serial.print("Distance: ");
Serial println(distance);

// Start the brakes if the distance is less than 5cm

if (distance >= 2)
{
  // nothing needs to be done
}

else
{
  // The distance between the carts is too little

  pos = 135;            //Hard Brake
  servo1.write(pos); 
  delay(5000);          //Wait for 5 second after brake 
  pos = 90;             //Release brakes
  servo1.write(pos);
  
}
}

