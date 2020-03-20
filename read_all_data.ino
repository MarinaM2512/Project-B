#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define BNO055_SAMPLERATE_DELAY_MS (100)
Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x28);

/* This driver uses the Adafruit unified sensor library (Adafruit_Sensor),
   which provides a common 'type' for sensor data and some helper functions.

   To use this driver you will also need to download the Adafruit_Sensor
   library and include it in your libraries folder.

   You should also assign a unique ID to this sensor for use with
   the Adafruit Sensor API so that you can identify this particular
   sensor in any data logs, etc.  To assign a unique ID, simply
   provide an appropriate value in the constructor below (12345
   is used by default in this example).

   Connections
   ===========
   Connect SCL to analog 5
   Connect SDA to analog 4
   Connect VDD to 3.3-5V DC
   Connect GROUND to common ground

   History
   =======
   2015/MAR/03  - First release (KTOWN)
*/

/* Set the delay between fresh samples */
//uint16_t BNO055_SAMPLERATE_DELAY_MS = 15;

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
//                                   id, address
//Adafruit_BNO055 bno = Adafruit_BNO055(55, 0x28);


//////////////////////////////////////////Defining Multiplexer(Mux) Values///////////////////////////////////
//Bits (arduino outputs):
const int s0 = 19;
const int s1 = 18;
const int s2 = 5;
//COM (esp3.2 input):
const int ComPin = 4;
// 3 bits--> 0-7 reading elements:
const int AllBits[] = {s0,s1,s2};
const int BitsNum = 3 ;
void setup(void)
{
  Serial.begin(115200);
  Serial.println("Orientation Sensor Test"); Serial.println("");

  /* Initialise the sensor */
  if (!bno.begin())
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while (1);
  }
  delay(1000);
  
  for (int k=0 ; k < BitsNum ; k++){
    pinMode(AllBits[k], OUTPUT);
  }
  pinMode(ComPin, INPUT); // Mux input
  //maby atenuation of ADC_2_5db from ADC_0db
  analogSetPinAttenuation( ComPin , ADC_11db); //sets the com pin attunation to 0, meaning the voltage range is 0-1v 
 // initializing :LOW to all OUTPUTS except from the first LED mode:
  for (int k=0 ; k < BitsNum ; k++){
    digitalWrite(AllBits[k], LOW);
  }
}


////////////////////////////////////////MuxReadFunc//////////////////////////////////////////////////////
int MuxReadFunc(int MuxNum){

  for (int k=0 ; k < BitsNum ; k++){
    digitalWrite(AllBits[k], bitRead(MuxNum,k));
    delay(3);
  }
  
  return ComPin;
}


void loop(void)
{
  
  //could add VECTOR_ACCELEROMETER, VECTOR_MAGNETOMETER,VECTOR_GRAVITY...
  sensors_event_t orientationData , angVelocityData , linearAccelData;
  bno.getEvent(&orientationData, Adafruit_BNO055::VECTOR_EULER);
  bno.getEvent(&angVelocityData, Adafruit_BNO055::VECTOR_GYROSCOPE);
  bno.getEvent(&linearAccelData, Adafruit_BNO055::VECTOR_LINEARACCEL);

  //printEvent(&orientationData);
  printEvent(&angVelocityData);
  //printEvent(&linearAccelData);

  //Get quaternions
  imu::Quaternion quat = bno.getQuat();
  Serial.print("qW: ");
  Serial.print(quat.w(), 4);
  Serial.print(" qX: ");
  Serial.print(quat.x(), 4);
  Serial.print(" qY: ");
  Serial.print(quat.y(), 4);
  Serial.print(" qZ: ");
  Serial.print(quat.z(), 4);
  Serial.print("\t\t");

 /* Display calibration status for each sensor. */
  uint8_t system, gyro, accel, mag = 0;
  bno.getCalibration(&system, &gyro, &accel, &mag);
  Serial.print("CALIBRATION: Sys: ");
  Serial.print(system, DEC);
  Serial.print(" Gyro: ");
  Serial.print(gyro, DEC);
  Serial.print(" Accel: ");
  Serial.print(accel, DEC);
  Serial.print(" Mag: ");
  Serial.println(mag, DEC);
  
  delay(BNO055_SAMPLERATE_DELAY_MS);
}

void printEvent(sensors_event_t* event) {
  Serial.println();
  //Serial.print(event->type);
  double x = -1000000, y = -1000000 , z = -1000000; //dumb values, easy to spot problem
  if (event->type == SENSOR_TYPE_ACCELEROMETER) {
    x = event->acceleration.x;
    y = event->acceleration.y;
    z = event->acceleration.z;
    Serial.println("acceleration:");
  }
  else if (event->type == SENSOR_TYPE_ORIENTATION) {
    x = event->orientation.x;
    y = event->orientation.y;
    z = event->orientation.z;
    Serial.println("orientation:");
  }
  else if (event->type == SENSOR_TYPE_MAGNETIC_FIELD) {
    x = event->magnetic.x;
    y = event->magnetic.y;
    z = event->magnetic.z;
    Serial.println("magnetic:");
  }
  else if ((event->type == SENSOR_TYPE_GYROSCOPE) || (event->type == SENSOR_TYPE_ROTATION_VECTOR)) {
    x = event->gyro.x;
    y = event->gyro.y;
    z = event->gyro.z;
    Serial.println("gyro:");

  }

  Serial.print("x: ");
  Serial.print(x);
  Serial.print(" y: ");
  Serial.print(y);
  Serial.print(" z: ");
  Serial.println(z);
      
  for(int k=0; k<5; k++){
    int value = analogRead(MuxReadFunc(k));
    delay(6);
    String str1 = "FSR";
    String str2 = str1 + k;
    Serial.print(str2);
    Serial.print(": ");
    Serial.print(value);
    Serial.print(" ");
  }
  Serial.println("");
}
