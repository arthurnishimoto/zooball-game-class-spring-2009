package Zooball;

import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import processing.net.*; 
import tacTile.net.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class foosballTest extends PApplet {

/**---------------------------------------------
 * FoosballTest.pde
 *
 * Description: Foosball prototype.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo) - Infinite State Entertainment
 * Version: 0.225
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
 * Notes:
 	- [TODO] Fix collision for slower moving balls
 	- [TODO] Physics engine?
        - [TODO] 1-to-1 control over goalie zone?
        - [TODO] Full bar rotation?
        - [TODO] Rewrite to FSM format
        - [NOTE] Two close fingers to move bars works well on tacTile.
 * ---------------------------------------------
 */

 // Disabled for applet



 
// Overall Program Flags
String programName = "Zooball";
float versionNo = 0.225f;

boolean connectToTacTile = false;
boolean usingMouse = true;
boolean applet = true;
boolean debugText = true;

int debugColor = color( 255, 255, 255 );

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
final static int PAUSE = 0;
final static int GAMEPLAY = 2;

int borderWidth = 75;
int borderHeight = 100;

float coinToss;
int sliderMultiplier = 2;
float tableFriction = 0.00f; // Default = 0.01
int fieldLines = 5; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #
int nBars = fieldLines - 1;
FoosBarManager barManager;
ParticleManager particleManager;

int nBalls = 2;
int ballsInPlay = 0;
int ballQueue = 0;
Ball[] balls = new Ball[nBalls];

Button resumeButton, resetButton;

// Bottom player
Turret ballLauncher_bottom;
Button pauseButton_bottom;

// Top Player
Turret ballLauncher_top;
Button pauseButton_top;


/*
 * Setup Method
 * 		Network connections and data structures used in your
 * 			application should be placed here. Consequently, 
 * 			the connection between Tac Tile an the application 
 *                      is initialized here.  
 */
public void setup() {
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
      }else
        size( screenWidth, screenHeight, OPENGL);
  }

  //color of the background
  background( 10 , 60 , 10 );
  timer_g = 0;
  
  //set frameRate
  frameRate(30); // Note tacTile generally runs at 16 FPS w/o OPENGL
  
  //load font  
  font = loadFont("CourierNew36.vlw"); 
  
  // Program specific setup:
  timer_g = 0;
  ballsInPlay = 0;
  barManager = new FoosBarManager( fieldLines, 200 );
  particleManager = new ParticleManager( 2000, 5 );
  
  ballLauncher_bottom = new Turret( 75 , screenWidth/2 , screenHeight - 100, 150, 50);
  ballLauncher_bottom.faceUp();
  ballLauncher_top = new Turret( 75 , screenWidth/2 , 0 + 100, 150, 50);
  ballLauncher_top.faceDown();
  
  coinToss();
    
  pauseButton_bottom = new Button( 50, borderWidth/2, 0 + borderHeight/2);
  pauseButton_top = new Button( 50, screenWidth - borderWidth/2, screenHeight - borderHeight/2);
  
  resumeButton = new Button( 100, screenWidth/4, screenHeight/2);
  resumeButton.setIdleColor(color(0,255,0));
  resumeButton.setButtonText("RESUME");
  
  resetButton = new Button( 100, 3*screenWidth/4, screenHeight/2);
  resetButton.setIdleColor(color(0,255,100));
  resetButton.setButtonText("RESET");
  
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
public void draw() {
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
  
  barManager.display();

  pauseButton_top.display();
  pauseButton_bottom.display();
  
  //Pause
  if( state == PAUSE ){
    fill( 0 , 0 , 0 , 150);
    stroke(0 , 0 , 0 , 150);
    rect( 0, 0, screenWidth, screenHeight );
    resumeButton.display();
    resetButton.display();
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
    if(  nBalls > 0 ){
      text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
      text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
      text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
    }
    // Program specific debug info
    if( state == GAMEPLAY ){
      barManager.displayDebug();
      particleManager.displayDebug();
    }
  }// if debugtext
  
  fill(debugColor);
  textFont(font,16);
  text("Infinite State Entertainment", screenWidth - 280, screenHeight - 16*2);
  text("'"+programName+"' Prototype v"+versionNo, screenWidth - 280, screenHeight - 16*1);
  
  checkInput();
}// draw

public void checkInput(){
  // Generic input code
  // Process mouse if clicked
  if(mousePressed && usingMouse){
	float xCoord = mouseX;    
	float yCoord = mouseY;
		
	//Draw mouse
        fill( 0xffFF0000 );
	stroke( 0xffFF0000 );
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
  ballLauncher_top.resetButton();
  ballLauncher_bottom.resetButton();
  }// if tacTileList empty else
  
  timer_g = timer_g + 0.048f;
}// checkInput

public void checkButtonHit(float x, float y, int finger){
  if( state == PAUSE ){
    if(resumeButton.isHit(x,y))
      state = GAMEPLAY;
    if(resetButton.isHit(x,y))
      setup();
  }else if( state == GAMEPLAY ){
    for( int i = 0; i < nBalls; i++ ){
      balls[i].isHit(x,y);
    }// for nBalls
    if( pauseButton_top.isHit(x,y) || pauseButton_bottom.isHit(x,y))
      state = PAUSE;
    barManager.barsPressed(x,y);
    ballLauncher_top.isHit(x,y);
    ballLauncher_top.rotateIsHit(x,y);
    ballLauncher_bottom.isHit(x,y);
    ballLauncher_bottom.rotateIsHit(x,y);
  }
}// checkButtonHit

public void coinToss(){
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
















class Ball{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  
  float friction = 0.001f;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel = 10;
  float diameter;
  int ID_no;
  Ball[] others;
 
  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr){
    state = INACTIVE; // Initial state
    xPos = newX;
    yPos = newY;
    xVel = 10;
    yVel = 10;//random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  }// Ball CTOR

  public void process(){
    if(state == ACTIVE){
      display();
      move();
    }else if(state == INACTIVE){
      // inactive state
    }// state if-else
    
  }// process
  
  public boolean isActive(){
    if(state == ACTIVE)
      return true;
    else
      return false;  
  }// isActive
  
  public void setActive(){
    state = ACTIVE;
  }// setActive
  
  public void kickBall( int hitDirection, float xVeloc, float yVeloc ){
    if(state == INACTIVE)
      return;
      
    // Basic implementation
    if( hitDirection == 1 || hitDirection == 3)
      xVel *= -1;
    if( hitDirection == 2 || hitDirection == 3)
      yVel *= -1;
    xVel += xVeloc;
    yVel += yVeloc;
  }// kickBall
  
  public void isHit( float x, float y ){
    if(state == INACTIVE)
      return;
    
    if( getSpeed() > 1 )
      return;
    if( x > xPos-diameter/2 && x < xPos+diameter/2 && y > yPos-diameter/2 && y < yPos+diameter/2 ){
      float newVel =  random(-10, 11);
      while( newVel < 4 && newVel > -4 )
        newVel =  random(-10, 11);
      xVel = newVel;
      
      newVel =  random(-10, 11);
      while( newVel < 4 && newVel > -4 )
        newVel =  random(-10, 11);
      yVel = newVel;
    }// if
  }// is Hit
  
  public void collide() {
    if(state == INACTIVE)
      return;
  }// collide
  
  public void move() {
    vel = sqrt(abs(sq(xVel))+abs(sq(yVel)));
        
    if ( xVel > maxVel )
      xVel = maxVel;
    if ( yVel > maxVel )
      yVel = maxVel;
      
    xPos += xVel;
    yPos += yVel;
    
    if( xVel > 0 )
      xVel -= friction;
    else if( xVel < 0 )
      xVel += friction;
    if( yVel > 0 )
      yVel -= friction;
    else if( yVel < 0 )
      yVel += friction;
      
    
    // Checks if object reaches edge of screen, bounce
    if ( xPos+diameter/4 > screenWidth-borderWidth){
      xVel *= -1;
      xPos += xVel;
    }else if ( xPos-diameter/4 < borderWidth){
      xVel *= -1;
      xPos += xVel;
    }
    if ( yPos+diameter/4 > screenHeight-borderHeight){
      yVel *= -1;
      yPos += yVel;
    }else if ( yPos-diameter/4 < borderHeight ){
      yVel *= -1;
      yPos += yVel;
    }
  }// move
  
  public void display(){
    fill(0xffFFFFFF, 255);
    ellipse(xPos, yPos, diameter, diameter);
  }// display
  
  public void displayDebug(){
     fill(debugColor);
     textFont(font,16);
     text("ID: " + ID_no, xPos+diameter, yPos-diameter/2 );
     //text("Speed: " + getSpeed(), xPos+diameter, yPos-diameter/2 + 16);
  }// displayDebug
  
  public float getSpeed(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getSpeed
}//class Ball

int team1 = color( 0, 0, 255 );
int team2 = color( 255, 0, 0 );

class FoosBarManager{
  MTFoosBar[] bars;
  
  FoosBarManager(int barLines, int barWidth){
    bars = new MTFoosBar[barLines];
    
    for( int x = 0 ; x < nBars ; x++ ){
      // Syntax: MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color teamColor, zoneFlag 0 = (top half of screen) 1 = (bottom half of screen))
      if( x%2 == 0 ){ // If even
        if( x == 0 || x == nBars) // Goalie - One player position
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        else
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
      }else{ // else odd
        if( x == 0 || x == nBars-1) // Goalie - One player position
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        else
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
      }
    }// for
    
  }// CTOR
  
  
  public void display(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].display();
      bars[x].ballInArea(balls);
      bars[x].collide(balls);
    }// for
  }// display
  
  public void displayZones(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayZones();
    }// for
  }// display

  public void displayDebug(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayDebug();
    }// for
  }// display
  
  public void barsPressed(float x, float y){
     for( int i = 0 ; i < nBars ; i++ )
        bars[i].isHit(x,y);
  }// barsPressed
  
  public void reset(){
    for( int i = 0 ; i < nBars ; i++ )
      bars[i].reset();
  }// reset
}//class

class Button{
  PImage buttonImage;
  int xPos, yPos;
  double buttonDownTime = 1;
  double buttonLastPressed = -1;
  boolean hasImage = false;
  boolean isRound = false;
  boolean pressed, xSwipe, ySwipe;
  float diameter;
  int idle_cl = color(0xff000000);
  int pressed_cl = color(0xffFF0000);
  boolean active;
  String buttonText = "";
  
  Button( float newDia , int new_xPos, int new_yPos){
    diameter = newDia;
    xPos = new_xPos;
    yPos = new_yPos;
    hasImage = false;
    isRound = true;
  }// Button CTOR
  
  Button( String newImage , int new_xPos, int new_yPos ){
    buttonImage = loadImage(newImage);
    xPos = new_xPos-buttonImage.width/2;
    yPos = new_yPos-buttonImage.height/2;
    diameter = buttonImage.width;
    hasImage = true;
  }// Button CTOR
  
  public void setIdleColor(int newColor){
    idle_cl = newColor;
  }// setIdleColor
  
  public void setPressedColor(int newColor){
    pressed_cl = newColor;
  }// setPressedColor
  
  public void setButtonText(String newText){
    buttonText = newText;
  }// setButtonText
  
  public void display(){
    active = true;
   
    if(hasImage)
      image( buttonImage, xPos, yPos );
    else if(isRound && !pressed){
      fill(idle_cl);
      stroke(idle_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }else if(isRound && pressed){
      fill(pressed_cl);
      stroke(pressed_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }
    
    fill(0xff000000);
    textFont(font,16);
    textAlign(CENTER);
    text(buttonText, xPos, yPos);
    textAlign(LEFT);
  }// display
  
  public void displayEdges(){
    fill(0xffFFFFFF);
    if(isRound){
      ellipse( xPos-diameter/2, yPos-diameter/2, 10, 10 ); // Top left
      ellipse( xPos+diameter/2, yPos-diameter/2, 10, 10 ); // Top Right
      ellipse( xPos-diameter/2, yPos+diameter/2, 10, 10 ); // Bottom left
      ellipse( xPos+diameter/2, yPos+diameter/2, 10, 10 ); // Bottom Right      
    }else if(hasImage){
      ellipse( xPos, yPos, 10, 10 ); // Top left
      ellipse( xPos+buttonImage.width, yPos+buttonImage.height, 10, 10 ); // Bottom Right
      ellipse( xPos+buttonImage.width, yPos, 10, 10 ); // Top right
      ellipse( xPos, yPos+buttonImage.height, 10, 10 );// Bottom Left 
    } 
  }//  displayEdges
  
  public void displayDebug(){
    fill(0xff000000);
    textFont(font,16);

    text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
    text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16);
    if(buttonLastPressed + buttonDownTime > timer_g)
      text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-timer_g), xPos+diameter, yPos-diameter/2+16*2);
    else
      text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*2);
  }// displayDebug
  
  public void setDelay(double newDelay){
    buttonDownTime = newDelay;
  }// setDelay
  
  public boolean isHit( float xCoord, float yCoord ){
    if( !active )
      return false;
    if(isRound){
      if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
        if (buttonLastPressed == 0){
          buttonLastPressed = timer_g;
        }else if ( buttonLastPressed + buttonDownTime < timer_g){
          buttonLastPressed = timer_g;
          pressed = true;
          return true;
        }// if-else-if button pressed
      }// if x, y in area
    }else if(hasImage){
      if( xCoord > xPos && xCoord < xPos+buttonImage.width && yCoord > yPos && yCoord < yPos+buttonImage.height){
        if (buttonLastPressed == 0){
          buttonLastPressed = timer_g;
        }else if ( buttonLastPressed + buttonDownTime < timer_g){
          buttonLastPressed = timer_g;
          pressed = true;
          return true;
        }// if-else-if button pressed
      }// if x, y in area
    }
    pressed = false;
    return false;
  }// isHit
  
  public void resetButton(){
    pressed = false;
  }// resetButton;
  
  public boolean isActive(){
    if(active)
      return true;
    else
      return false;  
  }// isActive
}// class Button


class MTFoosBar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea = 0, yMaxTouchArea = screenHeight/2;
  int teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0f;
  int nPlayers;
  MTFinger fingerTest;
  FoosPlayer[] foosPlayers;
  
  int playerWidth = 50;
  int playerHeight = 100;
  
  MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, int tColor, int zoneFlag){
    xPos = new_xPos;
    yPos = new_yPos;
    barWidth = new_barWidth;
    barHeight = new_barHeight;
    buttonPos = yPos;
    nPlayers = players;
    fingerTest = new MTFinger(new_xPos, new_yPos, 30, null);
    atTopEdge = false;
    atBottomEdge = false;
    teamColor = tColor;
    
    if(zoneFlag == 0){
      yMinTouchArea = 0;
      yMaxTouchArea = height/2;
    }else if(zoneFlag == 1){
      yMinTouchArea = height/2;
      yMaxTouchArea = height;
    }
    
    foosPlayers = new FoosPlayer[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new FoosPlayer( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth, playerWidth, playerHeight , this);
    }
  }// ScrollBar CTOR
  
  public void display(){
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i].display();
    }
    active = true;
  
    // Swipe
    if( abs(xMove) >= swipeThreshold ){
      xSwipe = true;
      //shoot(4);
    }else{
      xSwipe = false;
    }// if xSwipe

    if( abs(yMove) >= swipeThreshold ){
      ySwipe = true;
      //shoot(5);
    }else{
      ySwipe = false;
    }// if xSwipe
    
    

  }// display
  
  public void displayZones(){
    // Zone Bar
    if(pressed)
      fill( 0xff00FF00, 50);
    else if(hasBall)
      fill( 0xffFF0000, 50);
    else
      fill( 0xffAAAAAA, 50);
    rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
  }// displayZones
  
  public void displayDebug(){
    fill(debugColor);
    textFont(font,12);

    text("Active: "+pressed, xPos, yPos+barHeight-16*7);
    text("Y Position: "+buttonValue, xPos, yPos+barHeight-16*6);
    text("Movement: "+xMove+" , "+yMove, xPos, yPos+barHeight-16*5);
    text("Rotation: "+rotation, xPos, yPos+barHeight-16*4);
    text("Players: "+nPlayers, xPos, yPos+barHeight-16*3);
    if(atTopEdge)
      text("atTopEdge", xPos, yPos+barHeight-16*2);
    else if(atBottomEdge)
      text("atBottomEdge", xPos, yPos+barHeight-16*2);
    
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].displayDebug();
  }// displayDebug
  
  public boolean isHit( float xCoord, float yCoord ){
    if(!active)
      return false;
    if( xCoord > xPos && xCoord < xPos+barWidth && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea){
        fingerTest.xMove = xCoord-fingerTest.xPos;
        fingerTest.yMove = yCoord-fingerTest.yPos;
        
        fingerTest.xPos = xCoord;
        fingerTest.yPos = yCoord;
        
        fingerTest.display();
        
        buttonValue = (yPos-buttonPos)/(yPos-barWidth-barHeight);
        pressed = true;
        
        rotation = (xCoord-(xPos+barWidth/2))/barWidth; // Rotation: value from -0.5 (fully up to the left) to 0.5 (fully up to the right)
    
        xMove = fingerTest.xMove*sliderMultiplier;
        if( abs(fingerTest.yMove-yMove) < 100) // Prevents sudden sliding of bar
          yMove = fingerTest.yMove*sliderMultiplier;

        if( abs(yMove) > 100 ){
          yMove = 0;
          return false;
        }
        
        // Checks if foosMen at edge of screen
        float positionChange;
        atTopEdge = foosPlayers[0].atTopEdge;
        if( foosPlayers[0].atTopEdge ){
          positionChange = foosPlayers[0].yPos; // Keeps players at proper distance from each other when at top edge
          for( int i = 0; i < nPlayers; i++ ){
            foosPlayers[i].yPos += borderHeight-positionChange;
          }
        }else if( foosPlayers[nPlayers-1].atBottomEdge ){
          positionChange = foosPlayers[nPlayers-1].yPos;
          for( int i = 0; i < nPlayers; i++ ){
            foosPlayers[i].yPos += screenHeight-borderHeight-positionChange-foosPlayers[nPlayers-1].playerHeight;
          }
        }
        // If not at edges move bar
        if( !atTopEdge && !atBottomEdge ){
          for( int i = 0; i < nPlayers; i++ ){
            foosPlayers[i].yPos += yMove;
          }
        }
        

        
        buttonPos = yCoord;
        return true;
    }// if x, y in area
    pressed = false;
    return false;
  }// isHit
  
  public boolean ballInArea(Ball[] balls){
    for( int i = 0; i < nBalls; i++ ){
      if( !balls[i].isActive() )
        return false;
      if( balls[i].xPos > xPos && balls[i].xPos < xPos + barWidth ){
        hasBall = true;
        
        
        if(pressed){ // If ball is in area and user flicks in area
          /*
          if( xMove > 0 && balls[i].xVel > 0){
            balls[i].xVel += xMove; // Add speed to same direction right (+x)
          }else if( xMove < 0 && balls[i].xVel < 0){
            balls[i].xVel -= xMove; // Add speed to same direction left (-x)
          }else if( xMove > 0 && balls[i].xVel < 0){ // if ball +x and swipe -x
            balls[i].xVel = xMove; // Set ball and speed in direction of swipe
          }else if( xMove < 0 && balls[i].xVel > 0){ // if ball -x and swipe +x
            balls[i].xVel = xMove; // Set ball and speed in direction of swipe
          }else if( xMove == 0 ){ // Block the ball
            //balls[i].xVel *= -1; // Bounce
            //balls[i].xVel /= 2; 
          }// if-else
          */
        }// if pressed
        
        return true;
      }// if
    }// for
    hasBall = false;
    return false;
  }// ballInArea
  
  public boolean collide(Ball[] balls){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].collide(balls);
    return false;
  }// collide
  
  public void setButtonPos(float pos){
    buttonPos = -1*(yPos*pos-barWidth*pos-barHeight*pos-yPos);
    buttonValue = (yPos-buttonPos)/(yPos-barWidth-barHeight); // Update debug display
  }// setButtonPos
  
  public void reset(){
    pressed = false;
    xMove = 0;
    yMove = 0;
  }// reset
}// class

class FoosPlayer{
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  boolean active, atTopEdge, atBottomEdge;
  MTFoosBar parent;
  ArrayList ballsInZone = new ArrayList();
    
  //GLOBAL button time
  double buttonDownTime = 0.3f;
  double buttonLastPressed = 0;
  
  FoosPlayer( float x, float y, int newWidth, int newHeight, MTFoosBar new_parent){
    xPos = x;
    yPos = y;
    playerWidth = newWidth;
    orig_Width = newWidth;
    playerHeight = newHeight;
    parent = new_parent;
  }// CTOR
  
  public void display(){
    active = true;
    
    if( yPos+playerHeight > screenHeight-borderHeight ){
      atBottomEdge = true;
      parent.atBottomEdge = true;
    }else{
      atBottomEdge = false;
      parent.atBottomEdge = false;
    }
    
    if( yPos < borderHeight ){
      atTopEdge = true;
      parent.atTopEdge = true;
    }else{
      parent.atTopEdge = false;
      atTopEdge = false;
    }
    fill( 0xff000000 );
    playerWidth = 4*orig_Width*parent.rotation;
    rect(xPos, yPos, playerWidth, playerHeight);
    
    // Player Color
    fill( parent.teamColor );
    rect(xPos-orig_Width/2, yPos, orig_Width, playerHeight);
  }// display
  
  public void displayDebug(){
    fill(debugColor);
    textFont(font,12);

    text("Position: "+xPos+", "+yPos, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*0);
    text("playerWidth: "+playerWidth, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*1);
    if( atTopEdge )
      text("atTopEdge", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*2);
    if( atBottomEdge )
      text("atBottomEdge", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*2);
    text("Button Delay: "+buttonDownTime, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*3);
    if(buttonLastPressed + buttonDownTime > timer_g)
      text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-timer_g), xPos + playerWidth + 16, yPos+playerHeight/2 + 16*4);
    else
      text("Button Downtime Remain: 0", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*4);
    
    //Display Hitbox
    fill( 0xffFFFFFF );
    if( abs(playerWidth) <= orig_Width/2 ){
      ellipse( xPos - orig_Width/2, yPos , 5, 5 );
      ellipse( xPos + orig_Width/2, yPos , 5, 5 );
      ellipse( xPos - orig_Width/2, yPos + playerHeight , 5, 5 );
      ellipse( xPos + orig_Width/2, yPos + playerHeight , 5, 5 );
    }else{
      //ellipse( xPos + playerWidth/2, yPos , 5, 5 );
      ellipse( xPos + playerWidth, yPos , 5, 5 );
      //ellipse( xPos + playerWidth/2, yPos + playerHeight , 5, 5 );
      //ellipse( xPos + playerWidth, yPos + playerHeight , 5, 5 );      
      
    }
  }// displayDebug
  
  public boolean collide(Ball[] balls){
    if( abs(parent.rotation) > 0.4f ) // Player is rotated high enough for ball to pass
      return false;
         
    fill( 0xffFF0000, 100 );
    for( int i = 0; i < nBalls; i++ ){
      
      if( playerWidth > orig_Width/2 ){ // Player is rotated to right (feet pointing to right)
        rect( xPos + playerWidth/2, yPos, abs(playerWidth)/2, playerHeight);
      
        if( balls[i].xPos+balls[i].diameter/2 < xPos+playerWidth && balls[i].xPos+balls[i].diameter/2 > xPos + abs(playerWidth)/2 )
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            if( !setDelay() )
              return false;
              
            if( balls[i].xVel < 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight ){ // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
            }else if( balls[i].xVel > 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight){ // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
            }else if( balls[i].yVel > 0 && balls[i].xPos < xPos+playerWidth && balls[i].xPos > xPos+playerWidth/2){ // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
            }else if( balls[i].yVel < 0 && balls[i].xPos < xPos+playerWidth && balls[i].xPos > xPos+playerWidth/2){ // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
            }
            
        }// if has been hit 
          
      }else if( -1*playerWidth > orig_Width/2 ){ // Player is rotated to left (feet pointing to left)
        fill( 0xff0000FF, 100 );
        rect( xPos + playerWidth, yPos, abs(playerWidth)/2, playerHeight);
       
        if( balls[i].xPos+balls[i].diameter/2 > xPos+playerWidth && balls[i].xPos+balls[i].diameter/2 < xPos + abs(playerWidth)/2 )
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            if( !setDelay() )
              return false;
              
            if( balls[i].xVel < 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight ){ // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
            }else if( balls[i].xVel > 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight){ // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
            }else if( balls[i].yVel > 0 && balls[i].xPos > xPos+playerWidth && balls[i].xPos < xPos+playerWidth/2){ // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
            }else if( balls[i].yVel < 0 && balls[i].xPos > xPos+playerWidth && balls[i].xPos < xPos+playerWidth/2){ // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
            }
            
        }// if has been hit 
        
      }else if( abs(playerWidth) <= orig_Width/2 ){ // Player is not rotated (feet straight down)
        if( balls[i].xPos+balls[i].diameter/2 > xPos && balls[i].xPos+balls[i].diameter/2 < xPos + orig_Width )
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            if( !setDelay() )
              return false;
            
            if( balls[i].xVel < 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight ){ // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
            }else if( balls[i].xVel > 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight){ // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
            }else if( balls[i].yVel > 0 && balls[i].xPos > xPos-orig_Width/2 && balls[i].xPos < xPos+orig_Width/2){ // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
            }else if( balls[i].yVel < 0 && balls[i].xPos > xPos-orig_Width/2 && balls[i].xPos < xPos+orig_Width/2){ // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
            }
            
          }// if has been hit   
      }//if-else
      
    }//for
      /*
      if( parent.rotation < 0.4 )
        if( balls[i].xPos+balls[i].diameter/2 > xPos && balls[i].xPos-balls[i].diameter/2 < xPos + playerWidth ) // case where playerWidth >= 0
           if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight )
              balls[i].kickBall(parent.xMove, parent.yMove);
      if( parent.rotation > -0.4 && parent.rotation < 0)
        if( balls[i].xPos+balls[i].diameter/2 >= xPos + playerWidth && balls[i].xPos-balls[i].diameter/2 <= xPos ) // case where playerWidth < 0
           if( balls[i].yPos+balls[i].diameter/2 >= yPos && balls[i].yPos-balls[i].diameter/2 <= yPos + playerHeight )
              balls[i].kickBall(parent.xMove, parent.yMove);
      if( playerWidth == -1 ) // Fix for case where ball would pass through if playerHeight == -1
        if( balls[i].xPos+balls[i].diameter/2 >= xPos + playerWidth && balls[i].xPos-balls[i].diameter/2 <= xPos ) // case where playerWidth == -1
           if( balls[i].yPos+balls[i].diameter/2 >= yPos && balls[i].yPos-balls[i].diameter/2 <= yPos +1 )
              balls[i].kickBall(parent.xMove, parent.yMove);
      */
    
    return false;
  }// collide
  
  public boolean setDelay(){
    if(buttonLastPressed == 0){
      buttonLastPressed = ((buttonLastPressed + buttonDownTime)-timer_g);
      return false;
    }else if ( buttonLastPressed + buttonDownTime < timer_g){
      buttonLastPressed = timer_g;
      return true;
    }// if-else-if button pressed
    return false;
  }// setDelay
}//class
/**---------------------------------------------
 * MTHandI.pro
 *
 * Description: Multi-Touch Hand Interface
 *
 * Class:
 * System: Processing 1.0.1, Windows Vista
 * Author: Arthur Nishimoto
 * Version: 0.1
 *
 * Version Notes:
 * 2/13/09	- Initial Version
 *              - Uses timer_g and text needs a font
 * 2/27/09      - Added support for horizontal or vertical finger swipes
 * ---------------------------------------------
 */
 
 class MTHandI{
   float xPos, yPos, padDiameter, fingerDistance, handTilt;
   float pinkyDistX, pinkyDistY, thumbDistX, thumbDistY;
   int nFingers;
   boolean active, pressed, leftHand, rightHand;
   MTFinger[] fingers;
   
   MTHandI(float x, float y, float padDia, int numFing, float fingDia){
     xPos = x;
     yPos = y;
     padDiameter = padDia;
     fingers = new MTFinger[numFing];
     nFingers = numFing;
     for(int i = 0; i < numFing; i++){
       fingers[i] = new MTFinger(xPos-padDiameter/2+fingDia/2+ i*(padDiameter/4.5f), height/2, fingDia, this);
     }// for fingerGeneration
   }// MTHandI CTOR
   
   public void display(){
     active = true;  
     if(pressed){
       fill(0xff00FFFF, 100);
       stroke(0xff00FF00);
       ellipse(xPos, yPos, padDiameter, padDiameter);
     }else{
       fill(0xff00FF00, 100);
       stroke(0xff00FF00);
       ellipse(xPos, yPos, padDiameter, padDiameter);
     }
     
     for(int i = 0; i < nFingers; i++){
       if( fingers[i].pinky  ){
         pinkyDistX = fingers[i].xPos;
         pinkyDistY = fingers[i].yPos;
       }else if( fingers[i].thumb ){
         thumbDistX = fingers[i].xPos;
         thumbDistY = fingers[i].yPos;
       }
       fingers[i].display();
     }// for fingers
     if(leftHand){
       fingerDistance = sqrt( sq(thumbDistX-pinkyDistX)+sq(thumbDistY-pinkyDistY) );
       handTilt = thumbDistY - pinkyDistY;

     }else if(rightHand){
       fingerDistance = sqrt( sq(pinkyDistX-thumbDistX)+sq(pinkyDistY-thumbDistY) );
       handTilt = pinkyDistY - thumbDistY;
     }
   }// display
   
   public boolean isPressed( float xCoord, float yCoord, int finger, float intensity){
     if( !active )
       return false;
     if( xCoord > xPos-padDiameter/2 && xCoord < xPos+padDiameter/2 && yCoord > yPos-padDiameter/2 && yCoord < yPos+padDiameter/2){
       for(int i = 0; i < nFingers; i++){
         fingers[i].isPressed(xCoord,yCoord, finger, intensity);
           
       }// for fingers
       pressed = true;
       return true;
     }// if x, y in area
     for(int i = 0; i < nFingers; i++){
       fingers[i].reset();      
     }// for fingers
     return false;
   }// isPressed

  public void displayDebug(){
    fill(0xff000000);
    textFont(font,16);
    text("Pressed: "+pressed, 10, 100);
    text("Hand Span: "+fingerDistance, 10, 100+16);
    text("Hand Tilt: "+handTilt, 10, 100+16*2);

    for(int i = 0; i < nFingers; i++){
      fingers[i].displayDebug();
    }// for fingers
  }// displayDebug
  
  public void displayFinger(int newColor){
    for(int i = 0; i < nFingers; i++){
      fingers[i].displayFinger(newColor);
    }// for fingers
  }// displayDebug
  
  public void setDelay(double newDelay){
    for(int i = 0; i < nFingers; i++){
      fingers[i].buttonDownTime = newDelay;
    }// for fingers
  }// setDelay
  
  public float getSpan(){
    return fingerDistance;
  }// getSpan
  
  public float getTilt(){
    return handTilt;
  }// getTilt

  public void reset(){
    active = false;
    pressed = false;
    for(int i = 0; i < nFingers; i++){
        fingers[i].reset();
    }// for fingers
  }// reset
  
  public void calibrate(String hand){
    
    // Left-handed calibration
    if( hand == "LEFT" ){
      leftHand = true;
      rightHand = false;
      if(nFingers >= 5){
        fingers[0].pinky = true;
        fingers[1].ring = true;
        fingers[2].middle = true;
        fingers[3].index = true;
        fingers[4].thumb = true;
      }// for fingers
    // Right-handed calibration
    }else if( hand == "RIGHT" ){
       leftHand = false;
       rightHand = true;
       if(nFingers >= 5){
        fingers[4].pinky = true;
        fingers[3].ring = true;
        fingers[2].middle = true;
        fingers[1].index = true;
        fingers[0].thumb = true;
      }// for fingers     
    }// if-else left/right-handed
  }// calibrate
  
 }// class MTHandI
 
 class MTFinger{
   double buttonDownTime = 0.2f;
   double buttonLastPressed = 0;
   float swipeThreshold = 30.0f;
   float xPos, yPos, intensity;
   float diameter;
   boolean active, pressed, clicked, xSwipe, ySwipe;
   boolean calibrated, pinky, ring, middle, index, thumb;
   float xMove, yMove;
   int fingerID;
   MTHandI hand;
   
   MTFinger(float x, float y, float dia, MTHandI newHand){
     xPos = x;
     yPos = y;
     pinky = false;
     ring = false;
     middle = false;
     index = false;
     thumb = false;
     calibrated = false;
     diameter = dia;
     hand = newHand;
   }// MTFinger CTOR
   
   public void display(){
     active = true;
     if(fingerID == -1 && !pressed)
       buttonLastPressed = timer_g;
       
     if(pressed && !clicked){
       fill(0xff0000FF);
       stroke(0xff00FF00);
       ellipse(xPos, yPos, diameter, diameter);
     }else if(clicked){
       fill(0xffFF0000);
       stroke(0xff00FF00);
       ellipse(xPos, yPos, diameter, diameter);
     }else{
       fill(0xff000000);
       stroke(0xff00FF00);
       ellipse(xPos, yPos, diameter, diameter); 
     }
     
     // Swipe
     if( abs(xMove) >= swipeThreshold ){
       xSwipe = true;
       shoot(4);
     }else{
       xSwipe = false;
     }// if xSwipe

     if( abs(yMove) >= swipeThreshold ){
       ySwipe = true;
       shoot(5);
     }else{
       ySwipe = false;
     }// if xSwipe
     
   }// display
 
   public void displayDebug(){
     fill(0xff000000);
     textFont(font,16);

     text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
     text("Position: "+xPos+" , "+yPos, xPos+diameter, yPos-diameter/2+16);
     text("Movement: "+xMove+" , "+yMove, xPos+diameter, yPos-diameter/2-16);
     text("FingerID: "+fingerID+" Intensity: "+intensity, xPos+diameter, yPos-diameter/2+16*2);
     text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16*3);
     if(buttonLastPressed + buttonDownTime > timer_g)
       text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-timer_g), xPos+diameter, yPos-diameter/2+16*4);
     else
       text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*4);
     if(pinky)
       text("PINKY", xPos+diameter, yPos-diameter/2+16*5);
     else if(ring)
       text("RING", xPos+diameter, yPos-diameter/2+16*5);
     else if(middle)
       text("MIDDLE", xPos+diameter, yPos-diameter/2+16*5);
     else if(index)
       text("INDEX", xPos+diameter, yPos-diameter/2+16*5);
     else if(thumb)
       text("THUMB", xPos+diameter, yPos-diameter/2+16*5);
   }// displayDebug 
   
   public void displayFinger(int newColor){
     fill(newColor);
     textFont(font,16);
     if(pinky)
       text("PINKY", xPos, yPos-diameter*.6f);
     else if(ring)
       text("RING", xPos, yPos-diameter*.6f);
     else if(middle)
       text("MIDDLE", xPos, yPos-diameter*.6f);
     else if(index)
       text("INDEX", xPos, yPos-diameter*.6f);
     else if(thumb)
       text("THUMB", xPos, yPos-diameter*.6f);
   }// displayFinger
   
   public boolean isPressed( float xCoord, float yCoord, int finger, float intensityVal){
     if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
       if (buttonLastPressed == 0){
         buttonLastPressed = timer_g;
       }else if ( buttonLastPressed + buttonDownTime < timer_g){
         if(fingerID != finger){
           clicked = true;
           buttonLastPressed = timer_g;

         }
         pressed = true;
         xMove = xCoord-xPos;
         yMove = yCoord-yPos;
         xPos = xCoord;
         yPos = yCoord;
       }else{
         intensity = intensityVal;
         fingerID = finger;
         clicked = false;
         pressed = true;
         xMove = xCoord-xPos;
         yMove = yCoord-yPos;
         xPos = xCoord;
         yPos = yCoord;
         return true;
       }// if-else-if button pressed
     }// if x, y in area
     return false;
   }// isPressed
 
 
    public void calibrate( float xCoord, float yCoord, int finger){
     if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
       switch(finger){
         case(1):
           pinky = true;
           calibrated = true;
           break;
         case(2):
           ring = true;
           calibrated = true;
           break;
         case(3):
           middle = true;
           calibrated = true;
           break;
         case(4):
           index = true;
           calibrated = true;
           break;
         case(5):
           thumb = true;
           calibrated = true;
           break;
         default:
           calibrated = false;
           pinky = false;
           ring = false;
           middle = false;
           index = false;
           thumb = false;
           break;
       }
     }// if x, y in area
     return;
   }// calibrate
   
   public void shoot(int style){
     //particleManager.explodeParticles(100, xPos, yPos, 0, 0, style);
   }// shoot
   
   public void reset(){
     fingerID = -1;
     pressed = false;
   }// reset
   
  public void setButtonDelay(double newDelay){
    buttonDownTime = newDelay;
  }// setDelay
  
  public void setSwipeThreshold(float newThreshold){
    swipeThreshold = newThreshold;
  }// setSwipeThreshold
  
 }// class MTFinger
class Particle{
  boolean active = true;
  boolean gravity = false;
  float xPos, yPos, xVel, yVel, vel, angle;
  float diameter, originalDiameter;
  double timer;
  int colorFlag;
  int ID_no;
  Particle[] others;
  ParticleManager manager;
  
  double dispersionRate;
  
  // "Bouncy" Variables
  float maxVel;
  float spring;

  Particle(float newX, float newY, float newDiameter, int ID, Particle[] otr, double dispersionVal, ParticleManager newmanager){
    active = false;
    xPos = newX;
    yPos = newY;
    xVel = 0;
    yVel = 0;
    diameter = 0;
    colorFlag = -1;
    originalDiameter = newDiameter;
    ID_no = ID;
    others = otr;
    maxVel = 20;
    spring = 0.05f;
    dispersionRate = dispersionVal;
    manager = newmanager;
  }// Particle CTOR
  
  public void collide() {
    for (int i = ID_no + 1; i < others.length; i++) {
      if( !active || !others[i].active )
        continue;
      float dx = others[i].xPos - xPos;
      float dy = others[i].yPos - yPos;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = xPos + cos(angle) * minDist;
        float targetY = yPos + sin(angle) * minDist;
        float ax = (targetX - others[i].xPos) * spring;
        float ay = (targetY - others[i].yPos) * spring;
        xVel -= ax;
        yVel -= ay;
        others[i].xVel += ax;
        others[i].yVel += ay;
      }// if distance < minDist
    }// for others[i]
  }// collide

  public void move() {
    vel = sqrt(abs(sq(xVel))+abs(sq(yVel)));
    //timer = timer_g + dispersionRate;

    if( diameter > 0 && dispersionRate > 0)
      diameter -= dispersionRate;
       
    if( active && diameter <= 0 )
      active = false;
    
    // Gravity effect
    if( gravity )
      yVel += 1;
      
    if ( xVel > maxVel )
      xVel = maxVel;
    if ( yVel > maxVel )
      yVel = maxVel;
      
    xPos += xVel;
    yPos += yVel;
    
  }// move
  
  public void display(){
    if( !active )
      return;
       
    switch(colorFlag){
      case(0): // Reddish, yellow explosion color
        fill( 255, random(155)+100 , 0 , diameter*20);
        break;
      case(1): // Blueish, green, and white
        if( random(3) < 2 )
          fill( 0 , random(155)+100 , random(155)+100 , diameter*20);
        else
          fill( 255 , 255 , 255 , diameter*20);
        break;
      case(2): // Reddish, orange fire color
        fill( 255, random(155)+20 , 0 , diameter*20);
        break;
      case(3): // Black, smokey
        float colorVal = random(diameter);
        fill( colorVal, colorVal , colorVal , 50);
        break;
      default: // White
        fill( 255, 255 , 255 , diameter*20);
        break;
    }
    noStroke();
    ellipse(xPos, yPos, diameter, diameter);

  }// display
}//class Bug
/**---------------------------------------------
 * ParticleManager.pde
 *
 * Description: Particle Manager.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo)
 * Version: 0.2
 *
 * Version Notes:
 * 2/6/09	- Initial version 0.1
 * 		- Particle Manager designed for assignment 1.
 * 2/27/09      - Version 0.2: ParticleManager is now completely program independent.
 *              - Programed for original "explode" effect as well as a fire effect.
 * To-Do Notes:
 * 	- Delegate more commands to ParticleManager from Particle: color
 * ---------------------------------------------
 */
 
class ParticleManager{
  //Manager Data
  int particleBuffer = 1000; // Prevents array out of bounds on particles
  int nActive;
  
  //Particle Data
  float maxVel = 20;
  float spring = 0.05f;
  int particlesInUse = 0;
  int initParticleSize = 10;
  int particleDensity;
  double dispersionRate = 1; // larger = shorter, smaller = longer
  Particle[] particles;
  
  ParticleManager( int density, double dispersion){
    particleDensity = density;
    dispersionRate = dispersion;
    particles = new Particle[particleDensity+particleBuffer];
    
    //Generates particles
    for (int i = 0; i < particleDensity; i++) {
      particles[i] = new Particle(random(width), random(height), initParticleSize, i, particles, dispersionRate, this);
    }//for particleDensity
  
  }
  
  public void display(){
    nActive = 0;
    for (int i = 0; i < particleDensity; i++) {
      if(particles[i].active)
        nActive++;
      particles[i].move();
      particles[i].display();
    }// for

    if( nActive == 0 )
      particlesInUse = 0;
  }// moveParticles
  
  public void displayDebug(){
    fill(debugColor);
    textFont(font,16);
    text("Particles: "+particlesInUse+" out of "+particleDensity, width-300 , 16 );
    text("Active Particles: "+nActive, width-300 , 16*2 );
  }// moveParticles
  
  // Particle effects follow the following convention:
  // effectDensity: # of particles used
  // newDia: Initial particle diameter (uses original size if newDia < 0)
  // Initial xPos, yPos, xVel, yVel
  // Color flag: see ParitcleManager::setColor(int);
  // dispersion: particle dispersion (fade) rate - higher # = faster, smaller # = slower
  public void explodeParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
      particles[i].gravity = false;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(10)-random(10);
      particles[i].yVel = yVel + random(10)-random(10);
     }// for
     particlesInUse += effectDensity;
  }//explodeparticles
  
  public void fireParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
      particles[i].gravity = false;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(5)-random(5);
      particles[i].yVel = yVel - random(10);
     }// for
     particlesInUse += effectDensity;
  }//fireparticles

  public void waterCannonParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
 
      particles[i].dispersionRate = 0.5f;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(5)-random(5);
      particles[i].yVel = yVel;
      
      particles[i].gravity = true;
     }// for
     particlesInUse += effectDensity;
  }// waterCannonParticles
  
  public void trailParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
      particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
 
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel;
      particles[i].yVel = yVel;
      
      particles[i].gravity = false;
     }// for
     particlesInUse += effectDensity;
  }// waterCannonParticles
  
}// class

class Turret{
  float diameter, xPos, yPos;
  float rotateDiameter, rotateButtonPos, xCord, yCord, angle;
  float rotate_xCord, rotate_yCord, rotateButtonDiameter;
  boolean active, pressed, rotatePressed, hasImage, isRound, canRotate, facingUp;
  boolean alwaysShowRotate = false;
  boolean enable = false;
  
  double buttonDownTime = 1;
  double buttonLastPressed = -1; // Starts active if < 0
  
  int idle_cl = color( 0, 0, 0 );
  int pressed_cl = color( 255, 0, 0 );
  int enabled_cl = color( 0, 255, 0 );
  
  float fireVelocity = 10;
  float recoil = 50;
  float currentRecoil = 0;
  int shotNo = 0;
  
  Turret( float newDia , int new_xPos, int new_yPos, float rotateDia, float rotateButtonDia){
    diameter = newDia;
    xPos = new_xPos;
    yPos = new_yPos;
    rotateDiameter = rotateDia;
    rotateButtonDiameter = rotateButtonDia;
    
    // Initial Rotate Button Location
    rotate_xCord = xPos;
    rotate_yCord = yPos+rotateDia/2; 
    angle = 90;
  
    hasImage = false;
    isRound = true;
    alwaysShowRotate = false;
  }// Button CTOR
  
  public void faceUp(){
    facingUp = true;
    angle = 90;
    rotate_xCord = xPos;
    rotate_yCord = yPos+rotateDiameter/2; 
  }// faceUp

  public void faceDown(){
    facingUp = false;
    angle = -90;
    rotate_xCord = xPos;
    rotate_yCord = yPos-rotateDiameter/2; 
  }// faceDown
  
  public void enable(){
    enable = true;
  }// enable
  public void disable(){
    enable = false;
  }// disable
  
  public void display(){
    active = true;

    if( rotatePressed || alwaysShowRotate ){
      // Rotate area
      fill( 0, 0, 255, 100);
      noStroke();
      ellipse( xPos, yPos, rotateDiameter, rotateDiameter);
      
      // Rotating button
      fill( 0, 255, 0 );
      noStroke();
      ellipse( rotate_xCord, rotate_yCord, rotateButtonDiameter, rotateButtonDiameter);
    }
    

    
    // Center Button
    if(pressed){
      fill(pressed_cl);
      stroke(pressed_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }else{
      fill(idle_cl);
      stroke(idle_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }
    
    if( currentRecoil > 0 ){
      currentRecoil = recoil*(float)((buttonLastPressed + buttonDownTime)-timer_g);
    }else
      currentRecoil = 0;

  }// display
  
  public void displayTurret(){
    pushMatrix();
    fill( 100, 100, 100 );
    noStroke();
    translate(xPos, yPos);
    rotate(radians(angle));
    //rect(-26 + currentRecoil, -13, -72, 25); // turret barrel
    if( enable )
      fill(enabled_cl);
    else
      fill(color( 100, 100, 100 ));
    rect(-26, -26, 52, 52); // Turret base
    popMatrix();
  }// displayTurret
  
  public void displayDebug(){
    fill(debugColor);
    textFont(font,16);

    text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
    text("Rotate: "+canRotate, xPos+diameter, yPos-diameter/2+16);
    text("xCord: "+xCord, xPos+diameter, yPos-diameter/2+16*2);
    text("yCord: "+yCord, xPos+diameter, yPos-diameter/2+16*3);
    text("Angle: "+angle, xPos+diameter, yPos-diameter/2+16*4);
    text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16*5);
    if(buttonLastPressed + buttonDownTime > timer_g)
      text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-timer_g), xPos+diameter, yPos-diameter/2+16*6);
    else
      text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*6);
  }// displayDebug
  
  public boolean isHit( float xCoord, float yCoord ){
    if(!active || !enable)
      return false;
    if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
      if (buttonLastPressed == 0){
        buttonLastPressed = timer_g;
      }else if ( buttonLastPressed + buttonDownTime < timer_g){
        buttonLastPressed = timer_g;
        pressed = true;
        shoot();
        return true;
      }// if-else-if button pressed
    }// if x, y in area
    //pressed = false;
    return false;
  }// isHit
  
  public boolean rotateIsHit( float xCoord, float yCoord ){
    if(!active || !enable)
      return false;
      
    if( xCoord > xPos-rotateDiameter/2 && xCoord < xPos+rotateDiameter/2 && yCoord > yPos-rotateDiameter/2 && yCoord < yPos+rotateDiameter/2){
      //if (buttonLastPressed == 0){
      //  buttonLastPressed = timer_g;
      //}else if ( buttonLastPressed + buttonDownTime < timer_g){
        xCord = xCoord-xPos;
        yCord = yCoord-yPos;
        
        rotatePressed = true;
        if( xCoord > rotate_xCord-rotateButtonDiameter/2 && xCoord < rotate_xCord+rotateButtonDiameter/2 && yCoord > rotate_yCord-rotateButtonDiameter/2 && yCoord < rotate_yCord+rotateButtonDiameter/2){
          rotate_xCord = xCord+xPos;
          rotate_yCord = yCord+yPos;
        
          // Calculates angle based on standard x,y grid (+y is up)
          angle = degrees( atan2(yCord,xCord) );

          //buttonLastPressed = timer_g;
          canRotate = true;
          return true;
        }// if touch in rotate button
      //}// if-else-if button pressed
    }// if x, y in area
  
    return false;
  }// isHit
  
  public void shoot(){
    if( ballQueue == nBalls )
       ballQueue = 0;
    
    currentRecoil = recoil;
    balls[ballQueue].xPos = xPos;
    
    if( facingUp)
      balls[ballQueue].yPos = yPos-50;
    else
      balls[ballQueue].yPos = yPos+50;
    balls[ballQueue].xVel = fireVelocity*cos(radians(angle+180));
    balls[ballQueue].yVel = fireVelocity*sin(radians(angle+180));
    balls[ballQueue].setActive();
    ballsInPlay++;
    ballQueue++;
    disable();
  }// shoot
  
  public void resetButton(){
    pressed = false;
    rotatePressed = false;
    canRotate = false;
  }// resetButton;
  
  public boolean setAngle(float newAngle){
    if( angle >= 0 && angle <= 360 )
      angle = newAngle;
    else
      return false;
    return true;  
  }// setAngle
  
  public float getAngle(){
    return angle;
  }// getAngle
}// class

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "FoosballTest" });
  }
}

