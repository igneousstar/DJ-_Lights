#include <FastLED.h>

//Change this to send more data
//to the computer
#define OUT_DATA_SIZE 10

//Change this to recieve
//more data from the computer
#define IN_DATA_SIZE 10

//Number of LED's being used 
#define NUM_LEDS 10

//Pin being used for data
#define DATA_PIN 5

//Variables used to send data
float outGoingData[OUT_DATA_SIZE];

//The data coming from the computer
int inComingData[IN_DATA_SIZE];

// Define the array of leds
CRGB leds[NUM_LEDS];
int r = 10;
int g = 10;
int b = 10;
  
void setup() {
  //get rid of null values
  FastLED.addLeds<WS2812B, DATA_PIN, GRB>(leds, NUM_LEDS);
  for(int i = 0; i < OUT_DATA_SIZE; i++){
    outGoingData[i] = 0;
  }
  for(int i = 0; i < IN_DATA_SIZE; i++){
    inComingData[i] = 0;
  }
  Serial.begin(9600);
  delay(5);
  
}

void loop() {
  //first, read the new data
  readData();
  r = inComingData[0];
  g = inComingData[1];
  b = inComingData[2];
  
  //change the Value of the LED
  //or do anything else with the 
  //expected inComingData[]
  for(int i = 0; i < NUM_LEDS; i++){
    leds[i].setRGB(r, g, b);
  }
    
  outGoingData[0] = inComingData[0];
  outGoingData[1] = inComingData[1];
  outGoingData[2] = inComingData[2];
  
  //Send data to the computer
  Serial.println(inComingData[0]);
  //sendData();
  FastLED.show();
  delay(5);
}

/**
 * sends data to the computer
 */
void sendData(){
  //start the string with the first value
  String outGoingString = "";
  for(int i = 0; i < OUT_DATA_SIZE; i++){
    outGoingString = outGoingString + outGoingData[i];
    outGoingString = outGoingString + ",";
  }
  Serial.println(outGoingString);
}

/**
 * read the incoming data
 * from the computer
 */
void readData(){  
     //find the starting point 
     //of the incoming string
     if (Serial.find("aa")) {
      for(int i = 0; i < IN_DATA_SIZE; i++){
        inComingData[i] = Serial.parseInt();
      }
     }
}
