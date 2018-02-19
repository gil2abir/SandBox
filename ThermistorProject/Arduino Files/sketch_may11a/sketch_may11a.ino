// Pin that the thermistor is connected to
#define PINOTERMISTOR A0
// Nominal temperature value for the thermistor
#define TERMISTORNOMINAL 10000
// Nominl temperature depicted on the datasheet
#define TEMPERATURENOMINAL 25
// Number of samples 
#define NUMAMOSTRAS 5
// Beta value for our thermistor
#define BCOEFFICIENT 3560
// Value of the series resistor
#define SERIESRESISTOR 10000

int amostra[NUMAMOSTRAS];
int i;
void setup(void) {
Serial.begin(9600);
analogReference(EXTERNAL);
}

void loop(void) {
float media;

for (i=0; i< NUMAMOSTRAS; i++) {
amostra[i] = analogRead(PINOTERMISTOR);
delay(10);
}

media = 0;
for (i=0; i< NUMAMOSTRAS; i++) {
media += amostra[i];
}
media /= NUMAMOSTRAS;
// Convert the thermal stress value to resistance
media = 1023 / media - 1;
media = SERIESRESISTOR / media;

//Calculate temperature using the Beta Factor equation
float temperatura;
temperatura = media / TERMISTORNOMINAL;     // (R/Ro)
temperatura = log(temperatura); // ln(R/Ro)
temperatura /= BCOEFFICIENT;                   // 1/B * ln(R/Ro)
temperatura += 1.0 / (TEMPERATURENOMINAL + 273.15); // + (1/To)
temperatura = 1.0 / temperatura;                 // Invert the value
temperatura -= 273.15;                         // Convert it to Celsius

Serial.print("The sensor temperature is: ");
Serial.print(temperatura);
Serial.println(" *C");

delay(1000);
}
