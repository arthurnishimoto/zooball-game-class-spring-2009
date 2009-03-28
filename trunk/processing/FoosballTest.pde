/**---------------------------------------------
 * FoosballTest.pde
 *
 * Description: Foosball prototype.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo) - Infinite State Entertainment
 * Version: 0.31
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
   3/18/09      - Version 0.225 
                - [MODIFIED] Ball changed to FSM
                - [ADDED] Turret ball launcher
   3/19/09      - [ADDED] Pause button/menu - States for overall program
                - [MODIFIED] Foosplayer::collide(ball[]) now tracks all recently hits balls and ignores them - fixes collision problems except for rare "corner" cases
   3/20/09      - Version 0.3
                - [ADDED] Goals and scoring
                - [FIXED] Minor bugs with collision for ball, foosmen, and goal zone.
                - [ADDED] After scoring, ball is given to other team. Launcher activated - Only tested with one ball
   3/28/09      - Version 0.31 - All classes except Turret have been modified to be independent of variables in main class. (ex debugColor/font, screenDim)
                - [Modified] Turret control revised. Rotate shows direction choice and ball now fires on button release, not press.
                - [Bugged] Revision of Goal class now prevents proper score keeping
                - [Added] Foosman now accepts a single .gif image
 * Notes:
 	- [TODO] Physics engine?
        - [TODO] 1-to-1 control over goalie zone?
        - [TODO] Full bar rotation?
        - [TODO] Rewrite to FSM format
        - [TODO] Every class should have its own setDebugText/color method. Also certain classes ( ball, foosplayer) should have a setPlayEdge(screenDimentions) method.
                 Also complete comments and documentation for all classes.
        - [NOTE] Two close fingers to move bars works well on tacTile.
 * ---------------------------------------------
 */

//import processing.opengl.*; // Disabled for applet

import processing.net.*;
import tacTile.net.*;
 
// Overall Program Flags
String programName = "Zooball";
float versionNo = 0.3;

boolean connectToTacTile = false;
boolean usingMouse = true;
boolean applet = true;
boolean debugText = true;
boolean debug2Text = false;

color debugColor = color( 255, 255, 255 );

int screenWidth = screen.width;
int screenHeight = screen.height;

//Touch API
TouchAPI tacTile;

//List of Touches
ArrayList touchList = new ArrayList();

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
int state;
final static int MAIN_MENU = 0;
final static int PAUSE = 1;
final static int GAMEPLAY = 2;

int lastScored = -1;

int borderWidth = 0;
int borderHeight = 100;

int[] screenDimentions = new int[4];

float coinToss;
int sliderMultiplier = 2;
float tableFriction = 0.00; // Default = 0.01
int fieldLines = 5; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #. Default = 9
int nBars = fieldLines - 1;
FoosbarManager barManager;
ParticleManager particleManager;

int nBalls = 10;
int ballsInPlay = 0;
int ballQueue = 0;
Ball[] balls;

Button resumeButton, resetButton, quitButton;

// Bottom player
int bottomScore = 0;
Turret ballLauncher_bottom;
Button pauseButton_bottom;
Button debugTextButton, debug2TextButton;

// Top Player
int topScore = 0;
Turret ballLauncher_top;
Button pauseButton_top;

Goal leftGoal, rightGoal;

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
      if(applet){
        screenWidth = 1280;
        screenHeight = 1024;
        size( 1280, 1024 ); // applet
      }else{
        // TacTile Resolution
        //screenWidth = 1920;
        //screenHeight = 1080;
        size( screenWidth, screenHeight, OPENGL);
      }
      screenDimentions[0] = screenWidth;
      screenDimentions[1] = screenHeight;
      screenDimentions[2] = borderWidth;
      screenDimentions[3] = borderHeight;
  }

  //color of the background
  background( 10 , 60 , 10 );
  timer_g = 0;
  state = GAMEPLAY; // Initial State
  
  //set frameRate
  frameRate(30); // Note tacTile generally runs at 16 FPS w/o OPENGL
  
  //load font  
  font = loadFont("CourierNew36.vlw"); 
  
  // Program specific setup:
  balls = new Ball[nBalls];
  timer_g = 0;
  ballsInPlay = 0;
  bottomScore = 0;
  topScore = 0;
  barManager = new FoosbarManager( fieldLines, 200, screenDimentions, balls );
  particleManager = new ParticleManager( 2000, 5 );
  
  ballLauncher_bottom = new Turret( 75 , screenWidth/2 , screenHeight - 100, 150, 50);
  ballLauncher_bottom.faceUp();
  ballLauncher_top = new Turret( 75 , screenWidth/2 , 0 + 100, 150, 50);
  ballLauncher_top.faceDown();
  
  coinToss();
    
  pauseButton_bottom = new Button( 50, 50 , 0 + borderHeight/2);
  pauseButton_top = new Button( 50, screenWidth - 50, screenHeight - borderHeight/2);
  
  resumeButton = new Button( 100, screenWidth/4, screenHeight/2);
  resumeButton.setIdleColor(color(0,255,0));
  resumeButton.setButtonText("RESUME");
  
  resetButton = new Button( 100, 3*screenWidth/4, screenHeight/2);
  resetButton.setIdleColor(color(0,255,100));
  resetButton.setButtonText("RESET");
  
  quitButton = new Button( 100, screenWidth/2, screenHeight/2);
  quitButton.setIdleColor(color(0,100,100));
  quitButton.setButtonText("QUIT");

  leftGoal = new Goal( borderWidth, height/2, 100, 300 , 0, balls);
  rightGoal = new Goal( screenWidth-borderWidth-100, height/2, 100, 300 , 1, balls);
  
  debugTextButton = new Button( 50, screenWidth - 50, screenHeight - borderHeight/2 - 75*1 );
  debugTextButton.setIdleColor(color(0,50,50));
  
  debug2TextButton = new Button( 50, screenWidth - 50, screenHeight - borderHeight/2 - 75*2 );
  debug2TextButton.setIdleColor(color(0,50,50));
  
  for( int i = 0; i < nBalls; i++ ){
    // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
    //balls[i] = new Ball( width-borderWidth-50, height/2, 50, i, balls);
    balls[i] = new Ball( borderWidth+random(width-borderWidth-100), borderHeight+random(height+borderHeight), 50, i, balls, screenDimentions);
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

  if( ballsInPlay != 0 && ballsInPlay <= nBalls )
    coinToss();
  if( ballsInPlay == 0)
    reloadBall();
  ballLauncher_bottom.display();
  ballLauncher_top.display();
  ballLauncher_bottom.displayTurret();
  ballLauncher_top.displayTurret();
  
  // Vertical Lines
  fill( 0 , 50 , 0 );
  noStroke();
  for( int x = 0 ; x < fieldLines ; x++ ){
    rect( x*(screenWidth)/fieldLines, borderHeight, 2, screenHeight-borderHeight*2 );
  }
  

  barManager.displayZones();
  particleManager.display();
  
  for( int i = 0; i < nBalls; i++ ){
    //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
    if( balls[i].isActive() && state == GAMEPLAY ){
      particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
      balls[i].process();
    }
  }// for all balls
  
  leftGoal.collide(balls);
  rightGoal.collide(balls);
  
  barManager.process(balls);

  leftGoal.display();
  if( leftGoal.scored() )
    bottomScore ++;
    
  rightGoal.display();
  if( rightGoal.scored() )
    topScore ++;
  
  pauseButton_top.display();
  pauseButton_bottom.display();
  debugTextButton.display();
  debug2TextButton.display();
  
  //Pause
  if( state == PAUSE ){
    fill( 0 , 0 , 0 , 150);
    stroke(0 , 0 , 0 , 150);
    rect( 0, 0, screenWidth, screenHeight );
    resumeButton.display();
    resetButton.display();
    quitButton.display();
  }
  
  // Generic debug info
  if(debugText){
    textAlign(LEFT);
    fill(debugColor);
    textFont(font,16);
    text("Resolution: "+width+" , "+height, 16, 16*1);  
    text("MousePos: "+mouseX+" , "+mouseY, 16, 16*2);
    text("Timer: "+timer_g, 16, 16*3);
    text("FPS: "+frameRate, 16, 16*4);
    text("Table Friction: "+tableFriction, 16, 16*5);
    text("Top (Blue) Score: "+topScore, 16, 16*9);
    text("Bottom (Red) Score: "+bottomScore, 16, 16*10);
    text("Last Scored (Top = 0, Bottom = 1): "+lastScored, 16, 16*11);
    if(  nBalls > 0 ){
      text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
      text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
      text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
    }
    // Program specific debug info
    if( state == GAMEPLAY && debug2Text){
      barManager.displayDebug(debugColor, font);
      particleManager.displayDebug(debugColor, font);
      leftGoal.displayDebug(debugColor, font);
      rightGoal.displayDebug(debugColor, font);
      for( int i = 0; i < nBalls; i++ )
        balls[i].displayDebug(debugColor, font);
    }
  }// if debugtext
  
  fill(debugColor);
  textFont(font,16);
  text("Infinite State Entertainment", screenWidth - 280, screenHeight - 16*2);
  text("'"+programName+"' Prototype v"+versionNo, screenWidth - 280, screenHeight - 16*1);
  
  checkInput();
}// draw

void checkInput(){
  // Generic input code
  // Process mouse if clicked
  if(mousePressed && usingMouse){
	float xCoord = mouseX;    
	float yCoord = mouseY;
		
	//Draw mouse
        fill( #FF0000 );
	stroke( #FF0000 );
	ellipse( xCoord, yCoord, 20, 20 );

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
  }*/ else {
    checkButtonHit(-100,-100,-1);
    // Reset objects based on timer_g
    for( int x = 0 ; x < fieldLines ; x++ ){
      barManager.reset();
    }
  ballLauncher_top.resetButton();
  ballLauncher_bottom.resetButton();
  }// if tacTileList empty else
  
  timer_g = timer_g + 0.048;
}// checkInput

void checkButtonHit(float x, float y, int finger){
  if( state == PAUSE ){
    if(resumeButton.isHit(x,y))
      state = GAMEPLAY;
    if(resetButton.isHit(x,y))
      setup();
    if(quitButton.isHit(x,y))
      exit();
  }else if( state == GAMEPLAY ){
    
    // Ball
    for( int i = 0; i < nBalls; i++ ){
      balls[i].isHit(x,y);
    }// for nBalls
    
    // Buttons
    if( pauseButton_top.isHit(x,y) || pauseButton_bottom.isHit(x,y))
      state = PAUSE;
    
    if( debugTextButton.isHit(x,y) ){
      if(debugText){
        debugText = false;
        debugTextButton.setIdleColor(color(0,50,50));
      }else{
        debugText = true;
        debugTextButton.setIdleColor(color(0,250,250));
      }
    }
    if( debug2TextButton.isHit(x,y) ){
      if(debug2Text){
        debug2Text = false;
        debug2TextButton.setIdleColor(color(0,50,50));
      }else{
        debug2Text = true;
        debug2TextButton.setIdleColor(color(0,250,250));
      }
    }
    
    barManager.barsPressed(x,y);
    ballLauncher_top.isHit(x,y);
    ballLauncher_top.rotateIsHit(x,y);
    ballLauncher_bottom.isHit(x,y);
    ballLauncher_bottom.rotateIsHit(x,y);
  }
}// checkButtonHit

void reloadBall(){
  if( lastScored == 0 ){
    ballLauncher_bottom.enable();
  }else if( lastScored == 1 ){
    ballLauncher_top.enable();
  }
}// reloadBall

void coinToss(){
  coinToss = random(2);
  if( coinToss >= 1 )
    ballLauncher_bottom.enable();
  else if( coinToss < 1 )
    ballLauncher_top.enable();
    
  if( ballsInPlay == nBalls ){
    ballLauncher_top.disable();
    ballLauncher_bottom.disable();
  }
}// coinToss
















