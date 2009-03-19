/**---------------------------------------------
 * FoosballTest.pde
 *
 * Description: Foosball prototype.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo) - Infinite State Entertainment
 * Version: 0.22
 *
 * Version Notes:
 * 3/1/09	- Initial version 0.1
 * 3/5/09       - Version 0.2
 *              - FoosBars, players added. Bar rotation and touch zones implemented.
 *              - FoosBarManager generates number of player on bars based on number of bars. ( 3 person and goalie only)
 *              - FoosPlayers block balls if bar is within -0.4 to 0.4 of rotation value.
 * 3/6/09       - Version 0.21
                - [FIXED] players now block the ball when playerWidth = -1.
                - [FIXED] MTFoosBar::collide(balls[]), Ball::isHit() - Foosmen block balls and changes the ball's velocity based on the bar's velocity.
                          Resolves "pass through" issue when ball would hit top or bottom surface of foosmen
                - [FIXED] MTFoosBar::reset() - Bars now always reset the xMove and yMove values. This prevents the bars from becoming stuck on screen edge.
                          Bar can still get stuck, but releasing will unstick it.
                - [ADDED] sliderMultiplier can be used to increase slider speed for tacTile
                - [ADDED] Ball::isHit() randomly kicks the ball if pressed when ball's speed < 1. Original function of isHit() - when foosmen hits ball, changed
                          to Ball::kickBall().
   3/11/09      - [ADDED] Program screen size now based on screenWidth and screenHeight variables in main. Allows for proper resize for applet or windowed mode.
   3/12/09      - Version 0.22
                - [ADDED] Borders now restrict ball movement and is recognized as topEdge or bottomEdge for foosmen collision (marked as on edge, but takes no block action)
                - [REMOVED] Ball and foosmen collision info, foosmen and edge of play area collision.
                - [ADDED] New foosmen collision boxes are now visible via Foosplayer::displayDebug()
   3/13/09      - [MODIFIED] Foosplayer collision detection with ball revamped in Foosplayer::collide(ball[]) - Ball still can bounce inside player.
                - [MODIFIED] Foosplayer::collide(ball[]) now has a delay before it will change the velocity of the ball - fixes collision problems except for slow moving balls
 * Notes:
 	- [TODO] Fix collision for slower moving balls
 	- [TODO] Physics engine?
        - [TODO] 1-to-1 control over goalie zone?
        - [TODO] Full bar rotation?
        - [TODO] Rewrite to FSM format
        - [NOTE] Two close fingers to move bars works well on tacTile.
 * ---------------------------------------------
 */

//import processing.opengl.*; // Disabled for applet

import processing.net.*;
import tacTile.net.*;
 
// Overall Program Flags
String programName = "Zooball";
float versionNo = 0.22;
boolean usingMouse = true;
boolean debugText = true;
color debugColor = color( 255, 255, 255 );
int screenWidth = 1280;
int screenHeight = 1024;
int borderWidth = 75;
int borderHeight = 100;

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
float tableFriction = 0.00; // Default = 0.01
int fieldLines = 5; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #
int nBars = fieldLines - 1;
FoosBarManager barManager;
ParticleManager particleManager;

int nBalls = 10;
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

      //size of the screen
      size( screenWidth, screenHeight, OPENGL); // OPENGL on tacTile causes connect failure if placed after TouchAPI CTOR
      
      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);
  } else {
      //ALTERNATIVE: constructor to setup the connection LOCALLY on your machine
      //tacTile = new TouchAPI( this, 7000);

      //Create connection to Touch Server
      //tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);

      //size of the screen
      //size( screenWidth, screenHeight, OPENGL);
      //size( 1024, 768 ); // applet
      size( 1280, 1024 ); // applet
      
  }

  //color of the background
  background( 255 , 255 , 255 );
  
  //set frameRate
  frameRate(30); // Note tacTile generally runs at 16 FPS w/o OPENGL
  
  //load font  
  font = loadFont("CourierNew36.vlw"); 
  
  // Program specific setup:
  barManager = new FoosBarManager( fieldLines, 200 );
  particleManager = new ParticleManager( 2000, 5 );
    
  for( int i = 0; i < nBalls; i++ ){
    // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
    //balls[i] = new Ball( width-borderWidth-50, height/2, 50, i, balls);
    balls[i] = new Ball( borderWidth+random(width-borderWidth-100), borderHeight+random(height+borderHeight), 50, i, balls);
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
  fill( 100 , 50 , 0 );
  noStroke();
  rect( borderWidth, 0, screenWidth-borderWidth*2, borderHeight ); // Top border
  rect( borderWidth, screenHeight-borderHeight, screenWidth-borderWidth*2, borderHeight ); // Bottom border
  rect( 0, borderHeight, borderWidth, screenHeight-borderHeight*2 ); // Left border
  rect( screenWidth-borderWidth, borderHeight, borderWidth, screenHeight-borderHeight*2 ); // Right border
  
  // Vertical Lines
  fill( 0 , 50 , 0 );
  noStroke();
  for( int x = 0 ; x < fieldLines ; x++ ){
    rect( x*(screenWidth)/fieldLines, borderHeight, 2, screenHeight-borderHeight*2 );
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
  text("'"+programName+"' Prototype v"+versionNo, screenWidth - 280, screenHeight - 16*1);  
  
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


















