/**---------------------------------------------
 * FoosballTest.pde
 *
 * Description: Foosball prototype.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo) - Infinite State Entertainment
 * Version: 0.2
 *
 * Version Notes:
 * 3/1/09	- Initial version 0.1
 * 3/5/09       - Version 0.2
 *              - FoosBars, players added. Bar rotation and touch zones implemented.
 *              - FoosBarManager generates number of player on bars based on number of bars. ( 3 person and goalie only)
 *              - FoosPlayers block balls if bar is within -0.4 to 0.4 of rotation value.
 * 3/6/09       - [FIXED] players now block the ball when playerWidth = -1.
                - [FIXED] MTFoosBar::collide(balls[]), Ball::isHit() - Foosmen block balls and changes the ball's velocity based on the bar's velocity.
                          Resolves "pass through" issue when ball would hit top or bottom surface of foosmen
                - [FIXED] MTFoosBar::reset() - Bars now always reset the xMove and yMove values. This prevents the bars from becoming stuck on screen edge.
                          Bar can still get stuck, but releasing will unstick it.
                - [ADDED] sliderMultiplier can be used to increase slider speed for tacTile
                - [ADDED] Ball::isHit() randomly kicks the ball if pressed when ball's speed < 1. Original function of isHit() - when foosmen hits ball, changed
                          to Ball::kickBall().
   3/11/09      - [ADDED] Program screen size now based on screenWidth and screenHeight variables in main. Allows for proper resize for applet or windowed mode.
 * To-Do Notes:
 * 	- Physics engine? Two fingers to move.
 * ---------------------------------------------
 */

//import processing.opengl.*; // Disabled for tacTile and applet

import processing.net.*;
import tacTile.net.*;
 
// Overall Program Flags
boolean usingMouse = true;
boolean debugText = true;
color debugColor = color( 255, 255, 255 );
int screenWidth = 1024;
int screenHeight = 768;

//Touch API
TouchAPI tacTile;

//List of Touches
ArrayList touchList = new ArrayList();

//boolean to determine which Touch Server connected to.
boolean connectToTacTile = false;

//Names of machines you might use
String localMachine = "localhost";
String tacTileMachine = "tactile.evl.uic.edu";

//Port for data transfer
int dataPort = 7000;
int msgPort = 7340;

//Generic Data Items
double timer_g; // Required for button class
PFont font;

// Program Specific Code
int sliderMultiplier = 2;
float tableFriction = 0.01; // Default = 0.01
int fieldLines = 5; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #
int nBars = fieldLines - 1;
FoosBarManager barManager;
ParticleManager particleManager;

int nBalls = 1;
//float ballSpeedLimit = 15; // Ball max speed set in Ball class
Ball[] balls = new Ball[nBalls];

/*
 * Setup Method
 * 		Network connections and data structures used in your
 * 			application should be placed here. Consequently, 
 * 			the connection between Tac Tile an the application 
 *                      is initialized here.  
 */
void setup() {
  if ( connectToTacTile ){
      //ALTERNATIVE: constructor to setup the connection on TacTile
      //tacTile = new TouchAPI( this );

      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);

      //size of the screen
      size( screenWidth, screenHeight ); // OPENGL on tacTile causes connect failure!
  } else {
      //ALTERNATIVE: constructor to setup the connection LOCALLY on your machine
      //tacTile = new TouchAPI( this, 7000);

      //Create connection to Touch Server
      //tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);

      //size of the screen
      //size( screen.width, screen.height );
      size( 1024, 768 );
      //size( 1280, 1024 ); // applet
      
  }

  //color of the background
  background( 255 , 255 , 255 );
  
  //set frameRate
  frameRate(30); // Note tacTile generally runs at 16 FPS
  
  //load font  
  font = loadFont("CourierNew36.vlw"); 
  
  // Program specific setup:
  barManager = new FoosBarManager( fieldLines, 200 );
  particleManager = new ParticleManager( 2000, 5 );
    
  for( int i = 0; i < nBalls; i++ ){
    // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
    balls[i] = new Ball( width/2, height/2, 50, i, balls);
    balls[i].friction = tableFriction;
  }
  
} //setup()

/*
 * Draw Method
 * 		Draw is a method that is repeatedly called by Processing.
 * 		Consequently, touches that occur over the network connection
 * 		are extracted and processed here.
 *   
 */
void draw() {
  //clear backgrd
  background( 10 , 60 , 10 );

  // Program Specific Code:
  
  
  // Vertical Lines
  fill( 0 , 50 , 0 );
  noStroke();
  for( int x = 0 ; x < fieldLines ; x++ ){
    rect( x*(screenWidth)/fieldLines, 0, 2, screenHeight );
  }
  

  barManager.displayZones();
  particleManager.display();
  particleManager.displayDebug();
  
  for( int i = 0; i < nBalls; i++ ){
    //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
    particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
    
    balls[i].move();
    balls[i].display();
    balls[i].displayDebug();
  }
  
  
  barManager.display();
  barManager.displayDebug();
  
  // Generic debug info
  if(debugText){
    fill(debugColor);
    textFont(font,16);
    text("Resolution: "+width+" , "+height, 16, 16*1);  
    text("MousePos: "+mouseX+" , "+mouseY, 16, 16*2);
    text("Timer: "+timer_g, 16, 16*3);
    text("FPS: "+frameRate, 16, 16*4);
    text("Table Friction: "+tableFriction, 16, 16*5);
    if(  nBalls > 0 ){
      text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
      text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
      text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
    }

  }// if debugtext
  
  fill(debugColor);
  textFont(font,16);
  text("Infinite State Entertainment", screenWidth - 280, screenHeight - 16*2);
  text("'Foosball' Prototype v0.2", screenWidth - 280, screenHeight - 16*1);  
  
  // Generic input code
  // Process mouse if clicked
  if(mousePressed && usingMouse){
	float xCoord = mouseX;    
	float yCoord = mouseY;
		
	//Draw mouse
        fill( #FF0000 );
	stroke( #FF0000 );
	ellipse( xCoord, yCoord, 20, 20 );
        //MTFinger fingerTest = new MTFinger(xCoord, yCoord, 20, null);
        //fingerTest.display();
        //fingerTest.displayDebug();

        // ANY CHANGES HERE MUST BE COPIED TO TOUCH ELSE-IF BELOW
        checkButtonHit(xCoord,yCoord, 1);
  }// if mousePressed
  /*
  //Process touches off the managedList if there are any touches.
  else if ( ! tacTile.managedListIsEmpty()  ){
    // Grab the managedList
	touchList = tacTile.getManagedList();
    // Cycle though the touches 
	for ( int index = 0; index < touchList.size(); index ++ ){
		//Grab a touch
		Touches curTouch = (Touches) touchList.get(index);

		//Grab data
		float xCoord = curTouch.getXPos() * width;    
		float yCoord = height - curTouch.getYPos() * height;

  		//Get finger ID
		int finger = curTouch.getFinger();
		
		//Draw finger 
		fill( #FF0000 );
		stroke( #FF0000 );
		ellipse( xCoord, yCoord, 20, 20 );
                
                // ANY CHANGES HERE MUST BE COPIED TO MOUSE IF ABOVE
                checkButtonHit(xCoord, yCoord, finger);
	}// for touchList
  } */else {
    // Reset objects based on timer_g
    for( int x = 0 ; x < fieldLines ; x++ ){
      barManager.reset();
    }
  }// if tacTileList empty else
  
  timer_g = timer_g + 0.048;
}// draw

void checkButtonHit(float x, float y, int finger){
  for( int i = 0; i < nBalls; i++ ){
    balls[i].isHit(x,y);
  }// for nBalls
  barManager.barsPressed(x,y);
}// checkButtonHit


















