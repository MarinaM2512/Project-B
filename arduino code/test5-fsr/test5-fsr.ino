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
//////////////////////////////////////Setup Loop//////////////////////////////////////////////////////////
void setup() {

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
  Serial.begin(115200);
}
  
////////////////////////////////////////MuxReadFunc//////////////////////////////////////////////////////
int MuxReadFunc(int MuxNum){

  for (int k=0 ; k < BitsNum ; k++){
    digitalWrite(AllBits[k], bitRead(MuxNum,k));
    delay(3);
  }
  
  return ComPin;
}
//////////////////////////////////////loop/////////////////////////////////////////
void loop (){
  for(int k=0; k<5; k++){
    int value = analogRead(MuxReadFunc(k));
    delay(6);
    String str1 = "FSR";
    String str2 = str1 + k;
    Serial.print(str2);
    Serial.print(": ");
    Serial.print(value);
    Serial.print(" ");
    //delay(500);
  }
  Serial.println("");
}
