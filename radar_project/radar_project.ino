#include <Servo.h>                     //servo header file
#include <SoftwareSerial.h>            //header file for bluetooth
#define trigPin 4                      //HC SR04 trig-4pin
#define echoPin 5                      //HC SR04 echo-5pin
SoftwareSerial Blueboy(10, 11);        //Naming HC 05 as Blueboy TX-10pin RX-11pin
Servo servo;                           //Creating a SERVO object called servo
//Global variables
int BluetoothData;                     //Command given from app via bluetooth will be stored in this variable
int posc = 0;                          //variable to store position of sg 90
int flag=10;                           //reference flag during debugging 
void setup() 
{
  servo.attach(9);                     //Servo control-9pin
  pinMode(trigPin, OUTPUT);            //trigpin of HC SR04 sensor is output
  pinMode(echoPin, INPUT);             //echopin of HC SR04 sensor is Input
  Serial.begin(38400);                 //Serial monitor is started at 38400 baud rate for debugging
  Blueboy.begin(9600);                 //Bluetooth module works at 9600 baudrate
  Blueboy.println("Blueboy is active");//Conformation from Bluetooth
}
void loop()
{
   if (Blueboy.available())
{
Serial.println("Incoming");            //for debugging
BluetoothData=Blueboy.read();          //read data from bluetooth  
Serial.println(BluetoothData);         //for debugging
   if (BluetoothData == 'p')           //if the mobile app has sent a 'p'
   {
   flag=0;                             //play the device in auto mode
   }
   if (BluetoothData == 's')           //if the mobile app has sent a 's'
   {
   flag=1;                             //stop the device and enter manual mode
   } 
Serial.println(flag);                  //for debugging
}
if (flag==0)
servofun();                            //Servo sweeps on own 
if (flag==1)
manualservo();                         //Manual sweeping
}

//Function declaration starts from here

//Function for servo to sweep auto
void servofun()
{
  Serial.println("Sweeping");          //for debugging 
  for(posc = 10;posc <= 170;posc++)   // Moving servo from 10 degree to 70 degree angle 
  {                                
    servo.write(posc);                // set the position of servo motor
    delay(50);  
  us();                              //measure the distance of objects using us function                
  } 
  
  for(posc = 170;posc >= 10;posc--)   
  {                                
    servo.write(posc);
    delay(50); 
    us();                            //measure the distance of objects sing the US sensor             
  } 
  Serial.println ("Scan Complete"); //for debugging
  flag=0;
} 

//Function to control Servo manually
void manualservo()
{  
us();
   if (Blueboy.available())
{
BluetoothData=Blueboy.read();
Serial.println(BluetoothData);
  servo.write(BluetoothData);
  Serial.println("Written");
   if (BluetoothData == 'p')
   {
   flag=0;
   }
}
}

//Function to measure the distance
void us()
{
 int duration, distance;
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(1000);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = (duration/2) / 29.1; // Calculates the distance from the sensor
  if (distance<200 && distance >0)
Blueboy.write(distance);       
}
