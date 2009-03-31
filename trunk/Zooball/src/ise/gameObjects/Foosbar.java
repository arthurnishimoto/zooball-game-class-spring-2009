package ise.gameObjects;

import processing.core.*;

/**---------------------------------------------
 * Foosbar.java
 *
 * Description: Foosbar object containing foosmen
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1a
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - FSM implementation
 * 3/30/09	 - Conversion from Processing to Java
 */
 
public class Foosbar extends PApplet{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea, yMaxTouchArea;
  int teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0f;
  int sliderMultiplier = 2;
  int nPlayers, zoneFlag;
  MTFinger fingerTest;
  Foosmen[] foosPlayers;
  Ball[] ballArray;
  
  int playerWidth = 65;
  int playerHeight = 100;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  /**
   * 
   * @param new_xPos
   * @param new_yPos
   * @param new_barWidth
   * @param new_barHeight
   * @param players
   * @param tColor
   * @param zoneFlg
   */
  Foosbar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, int tColor, int zoneFlg){
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
    zoneFlag = zoneFlg;
  }// CTOR
  
  /**
   * 
   */
  public void generateBars(){
    if(zoneFlag == 0){
      yMinTouchArea = borderHeight;
      yMaxTouchArea = height/2;
    }else if(zoneFlag == 1){
      yMinTouchArea = height/2;
      yMaxTouchArea = height/2 - borderHeight;
    }
    
    foosPlayers = new Foosmen[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new Foosmen( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth, playerWidth, playerHeight, ballArray.length , this);
    }
  }// ScrollBar CTOR
  
  /**
   * 
   */
  public void display(PApplet p){
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i].display(p);
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
  
  /**
   * 
   */
  public void displayZones(PApplet p){
    // Zone Bar
    if(pressed)
      p.fill( 0xff00FF00, 150);
    else if(hasBall)
      p.fill( 0xffFF0000, 150);
    else
      p.fill( 0xffAAAAAA, 150);
    p.rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
  }// displayZones
  
  /**
   * 
   * @param debugColor
   * @param font
   */
  public void displayDebug(PApplet p, int debugColor, PFont font){
    p.fill(debugColor);
    p.textFont(font,12);

    p.text("Active: "+pressed, xPos, yPos+barHeight-16*7);
    p.text("Y Position: "+buttonValue, xPos, yPos+barHeight-16*6);
    p.text("Movement: "+xMove+" , "+yMove, xPos, yPos+barHeight-16*5);
    p.text("Rotation: "+rotation, xPos, yPos+barHeight-16*4);
    p.text("Players: "+nPlayers, xPos, yPos+barHeight-16*3);
    if(atTopEdge)
      p.text("atTopEdge", xPos, yPos+barHeight-16*2);
    else if(atBottomEdge)
      p.text("atBottomEdge", xPos, yPos+barHeight-16*2);
    
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].displayDebug(p, debugColor, font);
  }// displayDebug
  
  /**
   * 
   * @param xCoord
   * @param yCoord
   * @return
   */
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
  
  /**
   * 
   * @param balls
   * @return
   */
  public boolean ballInArea(Ball[] balls){
    for( int i = 0; i < balls.length; i++ ){
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
  
  /**
   * 
   * @param balls
   * @return
   */
  public boolean collide(PApplet p, Ball[] balls){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].collide(p, balls);
    return false;
  }// collide
 
  /**
   * 
   */
  public void reset(){
    pressed = false;
    xMove = 0;
    yMove = 0;
  }// reset
  
  
  // Setters and Getters
  
  /**
   * 
   */
  public void setButtonPos(float pos){
    buttonPos = -1*(yPos*pos-barWidth*pos-barHeight*pos-yPos);
    buttonValue = (yPos-buttonPos)/(yPos-barWidth-barHeight); // Update debug display
  }// setButtonPos
  
  /**
   * 
   * @param timer_g
   */
  public void setGameTimer( double timer_g ){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].setGameTimer(timer_g);
  }// setGameTimer
  
  /**
   * Setups ball pointers and screen dimentions before bar generation
   * @param screenDim
   * @param balls
   */
  public void setupBars(int[] screenDim, Ball[] balls){
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    ballArray = balls;
    generateBars(); // Create foosbars after screen/border dimentions are known
  }// setupBars  
}// class Foosbar