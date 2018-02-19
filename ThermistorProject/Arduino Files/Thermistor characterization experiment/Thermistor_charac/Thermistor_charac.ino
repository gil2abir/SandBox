#include <math.h>
int analogPin= 0;
int raw= 0;
int Vin= 3.3; //V
float Vout= 0; //V
float R1= 220; //Ohm
float Rth= 0; //Ohm
float R25=220; //Ohm
float T= 0; //C
float b=3560; //Ohm
int iteration=0;
unsigned long prev = 0;
unsigned long elapsed=0;

void setup(){
  Serial.begin(9600);
  }

void loop(){
  analogReadResolution(12);
  unsigned long now=millis();
  raw= analogRead(analogPin);
  if(raw){                          //as long as there is a reading, get digital reading
  //Vout=(raw*Vin)/4095;
  Vout=map(raw,0,4095,0,5); //Convert to analog  
  Rth= R1*(Vout*(Vin-Vout));         //Voltage Divider
  T=298*(-b)/((-b)+298*log(Rth/R25)); //K
  T=T-273.15; //K to C
  elapsed = (now-prev)/1000;
  //Serial.print("Vout: ");
  //Serial.println(Vout);
  //Serial.print("Rth: ");
  //Serial.println(Rth);
  Serial.print("raw ");
  Serial.println(raw);
  delay(1000);
  Serial.print("T: ");
  Serial.println(T);
  delay(1000);
  Serial.print("Elapsed Time: ");
  Serial.println(elapsed);
  delay(1000);
  Serial.print("Vout");
  Serial.println(Vout);
  delay(1000);
  }
}
