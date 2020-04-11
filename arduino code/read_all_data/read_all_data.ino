#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define FSR_DT_R (2)
#define FSR_DT_W (1)
#define BNO_DT (20)
unsigned long BNO_time = 0;
unsigned long FSR_time = 0;
unsigned long FSR_done_time=0;
unsigned long t = 0;
bool bno_done=0;
bool read_flag=0;
Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x28);
char start_measurments =0;




// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
//                                   id, address
//Adafruit_BNO055 bno = Adafruit_BNO055(55, 0x28);


//////////////////////////////////////////Defining Multiplexer(Mux) Values///////////////////////////////////
//Bits (arduino outputs):
const int s0 = 14;
const int s1 = 27;
const int s2 = 26;
//COM (esp3.2 input):
const int ComPin = 4;
// 3 bits--> 0-7 reading elements:
const int AllBits[] = {s0,s1,s2};
const int BitsNum = 3 ;
int k=0;
void setup(void)
{
  Serial.begin(115200);
  Serial.println("Orientation Sensor Test"); Serial.println("");

  /* Initialise BNO sensor */
  if (!bno.begin())
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while (1);
  }
  delay(1000);
  
  /* Initialise FSR sensor */
  for (int k=0 ; k < BitsNum ; k++){
    pinMode(AllBits[k], OUTPUT);
  }
  pinMode(ComPin, INPUT); // Mux input
  analogSetPinAttenuation( ComPin , ADC_11db); 
 // initializing :LOW to all OUTPUTS except from the first LED mode:
  for (int k=0 ; k < BitsNum ; k++){
    digitalWrite(AllBits[k], LOW);
  }
  //Calibrate before g=beginningof measurments
  uint8_t system, gyro, accel, mag = 0;
  while( system<3 || gyro<3 || accel<3 || mag<3 ){
    bno.getCalibration(&system, &gyro, &accel, &mag);
    Serial.print("CALIBRATION: Sys: ");
    Serial.print(system, DEC);
    Serial.print(" Gyro: ");
    Serial.print(gyro, DEC);
    Serial.print(" Accel: ");
    Serial.print(accel, DEC);
    Serial.print(" Mag: ");
    Serial.println(mag, DEC);
    delay(500);
  }
  Serial.println("BNO fully Calibrated");
  while(start_measurments!='s'){
    Serial.println("press s key to start");
    if(Serial.available()>0)
      start_measurments=Serial.read();
    delay(300);
  }
    Serial.println("Starting measurments");
    BNO_time=0;
    FSR_time=0;
    FSR_done_time =0;
}

void loop(void)
{
  // Every BNO_DT period get a new data sample of BNO and FSR
  if (millis() - BNO_time>= BNO_DT){
    BNO_time = millis();
    sensors_event_t orientationData , angVelocityData , linearAccelData;
    bno.getEvent(&orientationData, Adafruit_BNO055::VECTOR_EULER);
    bno.getEvent(&angVelocityData, Adafruit_BNO055::VECTOR_GYROSCOPE);
    bno.getEvent(&linearAccelData, Adafruit_BNO055::VECTOR_LINEARACCEL);
  
    //Linear acceleration
    double x = (linearAccelData.acceleration).x;
    double y = (linearAccelData.acceleration).y;
    double z = (linearAccelData.acceleration).z;
    Serial.printf("%.4lf %.4lf %.4lf",x,y,z);

    //Angular acceleration

    x = angVelocityData.gyro.x;
    y = angVelocityData.gyro.y;
    z = angVelocityData.gyro.z;
    Serial.printf(" %.4lf %.4lf %.4lf",x,y,z);

    //Get quaternions
    imu::Quaternion quat = bno.getQuat();
    Serial.printf(" %.4lf %.4lf %.4lf %.4lf",quat.w(),quat.x(),quat.y(),quat.z());
    
   /* Display calibration status for each sensor. */
    uint8_t system, gyro, accel, mag = 0;
    bno.getCalibration(&system, &gyro, &accel, &mag);
    Serial.print((String)" "+system+" "+gyro+" "+accel+" "+mag);
    bno_done=1;
  } 
  /* If BNO samples are finished 5-8 msec start measuring FSR 5 - 10 msec */
    if(millis()-FSR_time >= FSR_DT_W && bno_done && !read_flag){
    for (int i=0 ; i < BitsNum ; i++){
      digitalWrite(AllBits[i], bitRead(k,i));
    }
    read_flag = 1;
  }
  if (millis()- FSR_time >= FSR_DT_R && read_flag){
      int value = analogRead(ComPin);
      Serial.print(" ");
      Serial.print(value);
      k++;
      if (k>4){
        k=0;
        Serial.println("");
        bno_done=0;
      }
      read_flag=0;
      FSR_time =millis();
   }
}
