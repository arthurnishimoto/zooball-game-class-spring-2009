import processing.core.*; 
import processing.xml.*; 

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

public class FoosballTest2 extends PApplet {

/**---------------------------------------------
 * FoosballTest.pde
 *
 * Description: Foosball prototype.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo)
 * Version: 0.2
 *
 * Version Notes:
 * 3/1/09	- Initial version 0.1
 * 3/5/09       - Version 0.2
 *              - FoosBars, players added. Bar rotation and touch zones implemented.
 *              - FoosBarManager generates number of player on bars based on number of bars. ( 3 person and goalie only)
 *              - FoosPlayers block balls if bar is within -0.4 to 0.4 of rotation value.
 * To-Do Notes:
 * 	- Ball contact issues with players while rotating. Occationally ball passed through player when it should stop (issue with high ball velocity?)
 * ---------------------------------------------
 */

//import processing.opengl.*; // Disabled for tacTile and applet



 
// Overall Program Flags
boolean usingMouse = true;
boolean debugText = true;
int debugColor = color( 255, 255, 255 );

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
float tableFriction = 0.00f; // Default = 0.01
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
public void setup() {
  if ( connectToTacTile ){
      //ALTERNATIVE: constructor to setup the connection on TacTile
      //tacTile = new TouchAPI( this );

      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);

      //size of the screen
      size( screen.width, screen.height ); // OPENGL on tacTile causes connect failure!
  } else {
      //ALTERNATIVE: constructor to setup the connection LOCALLY on your machine
      //tacTile = new TouchAPI( this, 7000);

      //Create connection to Touch Server
      //tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);

      //size of the screen
      //size( screen.width, screen.height );
      //size( screen.width, screen.height, OPENGL );
      size( 1280, 1024 ); // applet
     
  }

  //color of the background
  background( 255 , 255 , 255 );
  
  //set frameRate
  frameRate(30);
  
  //load font  
  font = loadFont("CourierNew36.vlw"); 
  
  // Program specific setup:
  barManager = new FoosBarManager( fieldLines, 200 );
  particleManager = new ParticleManager( 2000, 5 );
    
  for( int i = 0; i < nBalls; i++ ){
    // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
    balls[i] = new Ball( 1280/2, 1024/2, 50, i, balls);
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
  
  
  // Vertical Lines
  fill( 0 , 50 , 0 );
  noStroke();
  for( int x = 0 ; x < fieldLines ; x++ ){
    rect( x*(1280)/fieldLines, 0, 2, 1024 );
  }
  

  barManager.displayZones();
  particleManager.display();
  particleManager.displayDebug();
  
  for( int i = 0; i < nBalls; i++ ){
    //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
    particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, -1*balls[i].xVel, -1*balls[i].yVel, 0 );
    
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
    text("Resolution: "+1280+" , "+1024, 16, 16*1);  
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
  text("Infinite State Entertainment", 1280 - 280, 1024 - 16*2);
  text("'Foosball' Prototype v0.2", 1280 - 280, 1024 - 16*1);  
  
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
  }// if tacTileList empty else
  
  timer_g = timer_g + 0.048f;
}// draw

public void checkButtonHit(float x, float y, int finger){
  barManager.barsPressed(x,y);
}// checkButtonHit


















class Ball{
  float friction = 0.001f;
  boolean active = true;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel = 15;
  float diameter;
  int ID_no;
  Ball[] others;

  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr){
    xPos = newX;
    yPos = newY;
    xVel = 15;
    yVel = random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  }// Ball CTOR

  
  public void isHit( float x, float y, float xVeloc, float yVeloc){
    if ( xVeloc > maxVel )
      xVel = maxVel;
    if ( yVeloc > maxVel )
      yVel = maxVel;
      
    xVel *= xVeloc;
    yVel += yVeloc;
  }// is Hit
  
  public void collide() {
    /*
    for (int i = ID_no + 1; i < numBugs; i++) {
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
    */
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
    if ( xPos > width - diameter/2 ){
      xVel *= -1;
      xPos += xVel;
    }else if ( xPos < 0 ){
      xVel *= -1;
      xPos += xVel;
    }
    if ( yPos > height - diameter/2 ){
      yVel *= -1;
      yPos += yVel;
    }else if ( yPos < 0 ){
      yVel *= -1;
      yPos += yVel;
    }
  }// move
  
  public void display(){
    if( !active )
      return;
    
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
          bars[x] = new MTFoosBar( (x+1)*(screen.width)/fieldLines-barWidth/2 , 0, barWidth, screen.height, 1, team1, 0);
        else
          bars[x] = new MTFoosBar( (x+1)*(screen.width)/fieldLines-barWidth/2 , 0, barWidth, screen.height, 3, team1, 0);
      }else{ // else odd
        if( x == 0 || x == nBars-1) // Goalie - One player position
          bars[x] = new MTFoosBar( (x+1)*(screen.width)/fieldLines-barWidth/2 , 0, barWidth, screen.height, 1, team2, 1);
        else
          bars[x] = new MTFoosBar( (x+1)*(screen.width)/fieldLines-barWidth/2 , 0, barWidth, screen.height, 3, team2, 1);
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

class MTFoosBar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea = 0, yMaxTouchArea = height/2;
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
  int playerHeight = 150;
  
    
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
      foosPlayers[i] = new FoosPlayer( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth/2, playerWidth, playerHeight , this);
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
    
    // Checks if foosMen at edge of screen
    atTopEdge = foosPlayers[0].atTopEdge;
    if( !atTopEdge )
      atTopEdge = foosPlayers[nPlayers-1].atTopEdge;
    atBottomEdge = foosPlayers[0].atBottomEdge;
    if( !atBottomEdge )
      atBottomEdge = foosPlayers[nPlayers-1].atBottomEdge;
    if( atBottomEdge && nPlayers > 1)
      for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].yPos += ((screen.height-foosPlayers[nPlayers-1].yPos)-foosPlayers[nPlayers-1].playerHeight)-1;
    else if( atBottomEdge && nPlayers == 1){
      for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].yPos += ((screen.height-foosPlayers[nPlayers-1].yPos)-foosPlayers[nPlayers-1].playerHeight)-1;
    }else if( atTopEdge && nPlayers > 1){
      for( int i = nPlayers-1; i >= 0; i-- )
          foosPlayers[i].yPos += (0-(foosPlayers[0].yPos))+1;
    }else if( atTopEdge && nPlayers == 1){
      for( int i = 0; i < nPlayers; i++ )
          foosPlayers[i].yPos += (0-(foosPlayers[0].yPos))+1;
    }
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

    text("Active: "+pressed, xPos, yPos+barHeight-16*54);
    text("Y Position: "+buttonValue, xPos, yPos+barHeight-16*53);
    text("Movement: "+xMove+" , "+yMove, xPos, yPos+barHeight-16*52);
    text("Rotation: "+rotation, xPos, yPos+barHeight-16*51);
    text("Players: "+nPlayers, xPos, yPos+barHeight-16*50);
    if(atTopEdge)
      text("atTopEdge", xPos, yPos+barHeight-16*49);
    else if(atBottomEdge)
      text("atBottomEdge", xPos, yPos+barHeight-16*49);
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
    
        xMove = fingerTest.xMove;
        if( abs(fingerTest.yMove-yMove) < 100) // Prevents sudden sliding of bar
          yMove = fingerTest.yMove;

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
  }// reset
}// class

class FoosPlayer{
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  boolean active, atTopEdge, atBottomEdge;
  MTFoosBar parent;
  
  FoosPlayer( float x, float y, int newWidth, int newHeight, MTFoosBar new_parent){
    xPos = x;
    yPos = y;
    playerWidth = newWidth;
    orig_Width = newWidth;
    playerHeight = newHeight;
    parent = new_parent;
  }// CTOR
  
  public void display(){
    displayDebug();
    active = true;
    
    if( yPos+playerHeight > screen.height){
      atBottomEdge = true;
    }else
      atBottomEdge = false;
      
    if( yPos < 0){
      atTopEdge = true;
    }else
      atTopEdge = false;
      
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
  }// displayDebug
  
  public boolean collide(Ball[] balls){
    if( parent.rotation > 0.4f ) // Player is rotated high enough for ball to pass
      return false;
    //if( parent.rotation < -0.4 ) // Player is rotated high enough for ball to pass
    //  return false;
    for( int i = 0; i < nBalls; i++ ){
      if( parent.rotation < 0.4f )
        if( balls[i].xPos+balls[i].diameter/2 > xPos && balls[i].xPos-balls[i].diameter/2 < xPos + playerWidth ) // case where playerWidth >= 0
           if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight )
              balls[i].isHit(0, 0, -1, parent.yMove);
      if( parent.rotation > -0.4f && parent.rotation < 0)
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth && balls[i].xPos-balls[i].diameter/2 < xPos ) // case where playerWidth < 0
           if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight )
              balls[i].isHit(0, 0, -1, parent.yMove);
    }// for
    return false;
  }// collide
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

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "FoosballTest2" });
  }
}
