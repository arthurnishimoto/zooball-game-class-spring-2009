package ise.gameObjects;
import ise.game.*;
import processing.core.*;
/**---------------------------------------------
 * MTFoosbar.java
 *
 * Description: Multi-touch foosball bar object.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3a
 * 
 * Version Notes:
 * 3/26/09    - Initial version - imported from processing with minor Java fixes
 */
class MTFoosBar extends PApplet{
	  int screenWidth, screenHeight, borderWidth, borderHeight;
	  int nBalls;
	  double timer_g;
	
  float xPos, yPos, barWidth, barHeight, yMinTouchArea, yMaxTouchArea;
  int teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0f;
  int nPlayers;
  MTFinger fingerTest;
  FoosPlayer[] foosPlayers;
  int sliderMultiplier = 2;
  
  int playerWidth = 65;
  int playerHeight = 100;
  int zoneFlag;
  
  MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, int tColor, int new_zoneFlag){
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
    zoneFlag =new_zoneFlag;
  }
  
  private void generateFoosmen(){
    if(zoneFlag == 0){
      yMinTouchArea = borderHeight;
      yMaxTouchArea = height/2;
    }else if(zoneFlag == 1){
      yMinTouchArea = height/2;
      yMaxTouchArea = height/2 - borderHeight;
    }
    
    foosPlayers = new FoosPlayer[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new FoosPlayer( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth, playerWidth, playerHeight , this);
    }
  }// ScrollBar CTOR
  
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
  
  public void displayZones(PApplet p){
    // Zone Bar
    if(pressed)
      p.fill( 0xff00FF00, 50);
    else if(hasBall)
      p.fill( 0xffFF0000, 50);
    else
      p.fill( 0xffAAAAAA, 50);
    p.rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
  }// displayZones
  
  public void displayDebug(PApplet p, Game g){
    //p.fill(g.getDebugColor());
    //p.textFont(g.getDebugFont());

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
      foosPlayers[i].displayDebug(p,g);
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
  
  public void setScreenDimentions(int[] screenDim){
  
	  screenWidth = screenDim[0];
	  screenHeight = screenDim[1];
	  borderWidth = screenDim[2];
	  borderHeight = screenDim[3];
	  generateFoosmen();
  }// setScreenDimentions
  public void reset(){
    pressed = false;
    xMove = 0;
    yMove = 0;
  }// reset
}// class