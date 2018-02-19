#include <math.h>

int analogPin= 0;
int raw= 0;
int Vin= 5;
float Vout= 0;
float R1= 270.0;
float Rt= 0;
float R0= 250;
float T= 0;
float b=8000;


void setup()
{
Serial.begin(9600);
}

void loop()
{
analogReadResolution(12);
raw= analogRead(analogPin);
if(raw) 
{

Vout= raw * (Vin/4096.0) ;
Rt= R1 * Vout/(Vin-Vout);
T=298*(-b)/(-b+298*log(Rt/R0))-273.15;
Serial.print("Vout: ");
Serial.println(Vout);
Serial.print("Rt: ");
Serial.print("\t");
Serial.println(Rt);
Serial.print("T: ");
Serial.print("\t");
Serial.println(T);
delay(800);
}
}



