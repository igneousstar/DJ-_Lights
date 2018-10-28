import processing.serial.*;
import java.util.ArrayList;

/**
* The com port the arduino is on
*/

Serial myPort;

/**
* the incoming String from 
* the Arduino
*/
String dataIn;

/**
* The size of the incoming serial data
* this is what you need to change
* if you modify the amount of data
* being read from the Arduino. 
*/
static final int dataSize = 10;

/**
* The incomeing serial data
*/
float[] serialData;

/**
* The amount of data being sent
* modify to send more to the Arduino
*/
static final int sentDataSize = 10;

/**
*
*/
float[] sentData;

/**
* A timer for different actions
*/

long timer;

/**
* This is the data that
* is going to be sent to 
* the Arduino :)
*/
String str;

/**
* These are objects for the GUI
*/
Slider rSlider;
Slider gSlider;
Slider bSlider;

Button mode1;
Button mode2;
Button mode3;

Graph graph;
Gauge colorGauge;

/**
* The last button Mode
*/

int buttonMode = 1;

void setup(){
  //start the incoming data array
  serialData = new float[dataSize];
  
  //start the outgoing data array
  sentData = new float[sentDataSize];
  //get rid of all the null pointers
  //in the arrays
  for(int i = 0; i < dataSize; i++){
    serialData[i] = 0;
  }
  
  for(int i = 0; i < sentDataSize; i++){
    sentData[i] = 0;
  }
  

  /**
  * Creates a Slider objects
  * Slider(String name, int centerX, int centerY, int sliderLength, int mapMin, int mapMax)
  */
  rSlider = new Slider("R", width/2, 100, 600, 0, 255);
  gSlider = new Slider("G", width/2, 200, 600, 0, 255);
  bSlider = new Slider("B", width/2, 300, 600, 0, 255);
  
  rSlider.setPrimeColor(255, 0, 0);
  gSlider.setPrimeColor(0, 255, 0);
  bSlider.setPrimeColor(0, 0, 255);
  
  /**
  * Creates a button objects
  * Button(String name, int xPos, int yPos)
  */ 
  mode1 = new Button("Mode 1", width/6, height/4);
  mode2 = new Button("Mode 2", width/6, height/2);
  mode3 = new Button("Mode 3", width/6, (height*3)/4);
  
  /**
  * Constructs a Gauge object
  * Gauge(String name, int centerX, int centerY, int mapMin, int mapMax)
  */
  //gauge = new Gauge("myGauge", width/2, 335, 0, 1023);
  
  /**
  * Creates a graph that displays
  * Graph(String name, int centerX, int centerY, String[] lineNames, int maxTime)
  */
  
  String lineNames[] = {"R", "G", "B"};
  graph = new Graph("myGraph", width/2, 550, lineNames, 10000);
  
  //Set the colors for all the lines in the graph
  int colors[] = {#ff0000, #00ff00, #0000ff};
  graph.setColors(colors);
  
  //start the timer for comSelect
  timer = millis() -3000; 
  
  //set the window and background
  size(1400, 700);
  background(#044f6f);
}


void draw(){
  background(#044f6f);
  
  if(myPort == null){
    selectCom();
  }
  else{
    /*********************** read all the incoming data **********************/
    readSerial();
    
    /******************** do things with the data recieved *******************/
    
    //the setValues(float[] values) requires
    //an array so one is made here
    float[] graphData = {rSlider.getValues()[0], gSlider.getValues()[0], bSlider.getValues()[0]};
    graph.setValues(graphData);
    
    /************************* draw the user interface ***********************/
     rSlider.drawUI();
     gSlider.drawUI();
     bSlider.drawUI();
     
     graph.drawUI();
       
    
    /*********** update the data that is being sent to the arduino ***********/
    sentData[0] = rSlider.getValues()[0];
    sentData[1] = gSlider.getValues()[0];
    sentData[2] = bSlider.getValues()[0];
    
    /******************* send the new data to the arduino ********************/
    writeSerial();
    
    /*********************** use this for debugging **************************/
    printSerialData();
  }
}
