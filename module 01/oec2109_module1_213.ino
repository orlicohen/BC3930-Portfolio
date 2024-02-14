/*
Creative Embedded Systems COMS-BC3930
Professor Mark Santolucito
Orli Cohen oec2109 
Module 1: Generative Art Installation

*/

//download as zip and add to libraries folder in Arduino folder https://github.com/pangodream/18650CL
#include <Pangodream_18650_CL.h> 

#define ADC_PIN 34
#define CONV_FACTOR 1.8
#define READS 20
Pangodream_18650_CL BL(ADC_PIN, CONV_FACTOR, READS);

#include <TFT_eSPI.h> // Graphics and font library for ILI9341 driver chip
#include <SPI.h>

TFT_eSPI tft = TFT_eSPI();  // Invoke library, pins defined in User_Setup.h

#define BUTTON_PIN_BITMASK 0x800000000 // 2^35 in hex

void IRAM_ATTR goToSleep() {
  esp_deep_sleep_start();
}

void setup() {
  tft.init();
  tft.setRotation(1); // sets rotation of screen to horizontal 

  attachInterrupt(0, goToSleep, CHANGE);
  //set screen Back Light brightness
  //pinMode(TFT_BL, OUTPUT);
  //ledcSetup(0, 5000, 8); // 0-15, 5000, 8
  //ledcAttachPin(TFT_BL, 0); // TFT_BL, 0 - 15
  //ledcWrite(0, 1); // 0-15, 0-255 (with 8 bit resolution); 0=totally dark;255=totally shiny
}

void loop() {

  tft.fillScreen(TFT_BLACK); // make screen background black 
  tft.setTextColor(TFT_PINK); tft.setTextSize(3);


  char intro[] = {"To whom this may concern:"};
  char *messages[4] = {"i love you <3", "thank u :)", "i appreciate you !!", "u mean the world 2 me"};

  tft.setCursor(5,5);
  tft.print(intro);

  while(1){
    int j = (int)(rand()%4);
    int ranX = random(100);
    int ranY = (rand() % (100 + 1 - 55)) + 50;
    tft.setCursor(ranX, ranY);
    tft.setTextColor(TFT_RED); tft.setTextSize(2);
    tft.println(messages[j]);

    delay(1500);

    tft.setCursor(ranX, ranY);
    tft.setTextColor(TFT_BLACK); tft.setTextSize(2);
    tft.println(messages[j]);

    // put intro message back 
    tft.setCursor(5,5); tft.setTextColor(TFT_PINK); tft.setTextSize(3);
    tft.println(intro);
  }
}
