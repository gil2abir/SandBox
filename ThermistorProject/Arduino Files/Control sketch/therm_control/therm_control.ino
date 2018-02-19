#include <math.h>
// which analog pin to connect
#define THERMISTORPIN A0         
// resistance at 25 degrees C [ohm]
#define THERMISTORNOMINAL 220      
// temp. for nominal resistance (almost always 25 C)
#define TEMPERATURENOMINAL 25   
// how many samples to take and average
#define NUMSAMPLES 5
// The beta coefficient of the thermisto
#define BCOEFFICIENT 3560
//Time constant of the thermistor
#define TAU=5;
// the value of the Howland balanceded resistors
#define RHOWL ????????
// disipation contant , [W/dC]
#define dc=7.5e-3 ; 
// thermistor resistance
#define Rt=1/dc;
// thermistor capcitance
#define Ct=tau*dc;
//Model parameters
#define Rm=220 //OHM
//////////////////////////////////////////////////////////////////////////////////////
// Thermistor model first\second(?) values ///////////////////////////////////////////
#define order=1;             //choose first (1) or second (2) order model control logic
#define r1=Rt;
#define r2=0.35*Rt;
#define c1=0.99*Ct;
#define c2=0.05*Ct;
#define a=r1*r2*c1*c2;
#define b=r2*c2+r1*c1+c1*r2;
#define c=r1*r2*c2;
#define d=r1+r2;
//////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////// 

//DEFINE PROCESSOR INPUT\OUTPUT 
int samples[NUMSAMPLES];
const int VinPin  =1;
const int VthPin  =2;
const int VrefPin =3; 

void setup(void) {
  //Serial.begin(9600);

  // Initialize the A2D\D2A Pins
  const int pinMode(VinPin,INPUT);
  const int pinMode(VthPin, INPUT);
}
 
void loop(void) {
  
  long Vin1[2]; //[Vin(VinPin),Vth(VthPin)] 
  long Vin2[2]; //[Vin(VinPin),Vth(VthPin)]
  SampleAvgRaw(Vin1);
  delay(100)
  int dt=100;
  SampleAvgRaw(Vin2);
  
	//Initialization of control logic parameters
  long Rth[2]; //[R(n),R(n+1)]
	getThermResis(Vin1,Vin2,Rth);

  //Get thermistor temperature
  long Tth[2]; //[T(n),T(n+1)]
  getThermTemp(Rth,Tth);

  //Get control current based on first order model
  long Ith;
  Ith = getOutputCurr(Tth,Rth[1],dt);

  //Set Output voltage Vref
  analogWriteResolution(12);
  Vout = Ith/RHOWL  
	analogWrite(VrefPin,map(Vout,0,4095,0,5));
	}

  //Stop control when converging
  if (Tth[1]-Tth[0]<0.001){

    //Call From Some Plotting\Displaying\Exploding\Whatever
    plot()
    display()
    explode()
    quit Project()

    //Stop Running
    void stop()
  }
}


//My Functions Definitions


//Get averaged raw voltage data from arduino A2D
void sampleAvgRaw(long A2D[]){
	uint8_t i;
	float rawVin;
  float rawVth;
  analogReadResolution(12);
  // take N samples in a row, with a slight delay
  for (i=0; i< NUMSAMPLES; i++) {
   samplesVin[i] = analogRead(VinPin); //change to 12 bit resolution
   samplesVth[i] = analogRead(VinPin); //change to 12 bit resolution
   //delay(10);
   //delay(10);
  }

  // average all the samples out
  rawVin = 0;
  rawVth = 0;
  for (i=0; i< NUMSAMPLES; i++) {
     rawVin += samplesVin[i];
     rawVth += samplesVth[i];
  }
  rawVin /= NUMSAMPLES;
  rawVth /= NUMSAMPLES;
  A2D[0]=rawVin;
  A2D[1]=rawVth;
}


//Get Thermistor Resistance From Raw Data
void getThemResis(long Vin1[], long Vin2[],long Rth[]){
  Rth[0]=(Vin1[0]*Rm)/(Vin1[0]-Vin1[1]);
  Rth[1]=(Vin2[0]*Rm)/(Vin2[0]-Vin2[1]);
}

//Get Temperature from Rth
void getThermTemp(long Rth[],long Tth){
  Tth[0]=(BCOEFFICIENT/log(Rth[0]/R25))+(BCOEFFICIENT/298.15);
  Tth[1]=(BCOEFFICIENT/log(Rth[1]/R25))+(BCOEFFICIENT/298.15);	
}

//Get Current Output
float getOutputCurr(float Tth[], float Rn,int dt){
  Ith=sqrt((c1*(Tth[1]-Tth[0]))/(dt*Rn))
  return Ith
}

//Stop Running
void stop(){
  while(1);
}

