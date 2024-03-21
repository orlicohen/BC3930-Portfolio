// #define PIN_ANALOG_IN 15 // potentiometer, didn't end up using
// #define PIN_BUTTON 32 // button, didn't end up using

int xyzPins[] = {33, 25, 26}; //x,y,z on joystick 

void setup() {
  Serial.begin(115200); // must be at 115200 baud in serial monitor to read inputs
  pinMode(xyzPins[2], INPUT_PULLUP); // z axis of joystick functions as button.
  //pinMode(PIN_BUTTON, INPUT); // for button 
}

void loop() {
  int xVal = analogRead(xyzPins[0]); // joystick x
  int yVal = analogRead(xyzPins[1]); //  joystick y 
  int zVal = digitalRead(xyzPins[2]); // joystick z - pushed (0) not pushed (1)

  //int adcVal = analogRead(PIN_ANALOG_IN); // read adc of potentiometer 

  //int buttonVal = digitalRead(PIN_BUTTON); 

  //Serial.printf("XYZ,%d,%d,%d,\n", xVal, yVal, zVal, adcVal, buttonVal); // comma separators for splitting in processing
  Serial.printf("XYZ,%d,%d,%d,\n", xVal, yVal, zVal);
  delay(100);
}
