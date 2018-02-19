#include <math.h>
// resistance at 25 degrees C [ohm]
#define THERMISTORRESNOMINAL 220      
// temp. for nominal resistance (almost always 25 C)
#define TEMPERATURENOMINAL 25   
// how many samples to take and average
#define NUMSAMPLES 5
// The beta coefficient of the thermisto
#define BCOEFFICIENT 3560
//Time constant of the thermistor
#define TAU 5
// disipation contant , [W/dC]
#define dc 7.5e-3 
// thermistor resistance
#define Rt 1/dc
// thermistor capcitance
#define Ct tau*dc
#define cAmpiricNormalize 0.315
#define cNominal Ct*cAmpiricNormalize

//Initialization
#define VoutInit 5 //5 Volt

//Circuit Parameters & Processor
#define Rm1 220 //OHM
#define Rm2 10 //OHM
#define Fs 250 //sample rate
#define dt 250


//DEFINE PROCESSOR INPUT\OUTPUT 
int Vinpin = 1;
int Voutpin = 2; 
//Initialize buffers, arrays and all other neccesities
float Vraw;
float Vin[2] = {0,0}; //[Vin(n-1),Vin(n)]
float Rth[2] = {THERMISTORRESNOMINAL,THERMISTORRESNOMINAL};//[T(n-1),T(n)]
float Tth[2] = {TEMPERATURENOMINAL,TEMPERATURENOMINAL}; //[T(n-1),T(n)]
float Vout[2] = {VoutInit,0};
double Tdiff = 0;
uint8_t win = 1;

void setup(void) {
  Serial.begin(9600);

  // Initialize the A2D\D2A Pins
  pinMode(Vinpin,INPUT);
  pinMode(Voutpin, OUTPUT);
}
 
void loop() {
  
  if(win<2){
    Vraw = SampleAvgRaw();
    Vin[0]=Vinitial;
    Vin[1]=Vraw;
    win+=win;
    return; //delay of 1 samples to have first derivative ready for control scheme algorithem
  }
  else{
    Vraw=SampleAvgRaw(); //move values one discrete sample backword and populate from buffer 
    Vin[0]=Vin[1];
    Vin[1]=Vraw;
      
    //Get thermistor temperature from Voltage sampled by arduino (circuit design dependable)
    transformVin(Vin);
    
    //Get the thermistor's resistance according to voltage
    getThermResist(Vin, Rth, Vout);
    
    
    //Get Temperature of thermistor
    getThermTemp(Rth,Tth);
    Tdiff=((Tth[1]-T[0])/(dt/Fs));
    
    if(Tdiff<=0){ //to remove sensetivity to noise (leading to negetive derivatives in noisy data), 
    win+=win;     //and to force converge, lets examine derivative each iteration and ignore local risings.
    return;
    }
    
    //Set Vcontrol and warm the fucker up
    setVout(Vout, Rth[1], Tdiff)
  
    //Set Output voltage Vref
    analogWriteResolution(12);
  	analogWrite(Voutpin,map(Vout,0.0,5.0,0.0,3.3));
  
    //Stop this fucker when converging by a certain tolerance
    if  (Tdiff<0.001){
  
      //Call From Some Plotting\Displaying\Exploding\Whatever
      //plot();
      //display();
      //explode();
      //quit Project();
      //Stop Running
      void stop();
    }
  win+=win;
  }
}


//My Functions Definitions


//Get averaged raw voltage data from arduino A2D
float sampleAvgRaw(){
	uint8_t i;
  float samplesVraw;
  float Vraw;
  analogReadResolution(12);
  

  // take N samples in a row, with a slight delay
  
  for (i=0; i< NUMSAMPLES; i++) {
   samplesVraw += analogRead(Vin);
   delay(Fs/NUMSAMPLES);
  }
  Vraw = samplesVraw/NUMSAMPLES;
  Vraw = fmap(raw, 0, 4095, 0.0, 5.0);
  return Vraw
}


//Transform Vin according to model
void transformVin(long Vin[]){
  int tilda = 1/(((1/Rm1)+(1/Rm1))/Rm1);
  for (i=0; i< 1; i++) { 
     Vin1[i]*=2;
     Vin2[i]*=2;
  }
}

//Get Thermistor Resistance From Raw Data
void getThermResist(float Vin[], float Rth[], float Vout){
  Rth[0]=Rm2*Vin[0]/(Vout[0]-Vin[0]);
  Rth[1]=Rm2*Vin[1]/(Vout[1]-Vin[1]);
}

//Get Temperature from Rth
void getThermTemp(long Rth[],long Tth){
  Tth[0]=(BCOEFFICIENT/log(Rth[0]/R25))+(BCOEFFICIENT/298.15);
  Tth[1]=(BCOEFFICIENT/log(Rth[1]/R25))+(BCOEFFICIENT/298.15);	
}

//Get Current Output
void setVout(float Vout, float Rth[], int Tdiff){
  Vout[0]=Vout[1];
  Vout[1]=sqrt(cNominal*Rth[1]*Tdiff);
}

//Stop Running
void stop(){
  while(1);
}

