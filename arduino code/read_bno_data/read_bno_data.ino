#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define FSR_DT_R (2)
#define FSR_DT_W (1)
#define BNO_DT (20)
unsigned long BNO_time = 0;
unsigned long FSR_time = 0;
unsigned long t = 0;
unsigned long start_time;
bool bno_done=0;
bool read_flag=0;
bool restart=0;
Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x28);
char start_measurments =0;
char recieved = 0;




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

/*Calibration Func*/
void calibrate(void){
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
}
void press_s_to_start(void){
    while(start_measurments!='s'){
    Serial.println("press s key to start");
    if(Serial.available()>0)
      start_measurments=Serial.read();
    delay(300);
  }
    Serial.println("\nStarting measurments");
    BNO_time=0;
    FSR_time=0;
}

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
  //Calibrate before beginningof measurments
  calibrate();
 press_s_to_start();
start_time = millis();
}

void loop(void)
{
  // Every BNO_DT period get a new data sample of BNO and FSR
  if(Serial.available()>0){
    recieved = Serial.read();
    if(recieved == 'c' || recieved == 's' ){
      if(recieved == 'c')
        calibrate();
    press_s_to_start();
    restart = 1;
    k=0;    
    }
  }
  if (millis() - BNO_time>= BNO_DT || restart){
    restart=0;
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

    //Angular Velocity

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
    t = millis() - start_time;
    Serial.println((String)" "+system+" "+gyro+" "+accel+" "+mag+" "+t);
    bno_done=1;

  } 
}
