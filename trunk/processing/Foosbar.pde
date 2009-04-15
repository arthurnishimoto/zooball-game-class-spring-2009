/**
 * ---------------------------------------------
 * Foosbar.pde
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
 * 4/1/09    - "Spring-loaded" foosbar option added
 * ---------------------------------------------
 */
 
class Foosbar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea, yMaxTouchArea;
  float orig_barWidth;
  color teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0;
  int sliderMultiplier = 2;
  int nPlayers, zoneFlag;
  MTFinger fingerTest;
  Foosman[] foosPlayers;
  Ball[] ballArray;
  boolean springEnabled = false;
  float spring = 0.01;
  float rotateVel;
  
  int playerWidth = 65;
  int playerHeight = 100;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  Foosbar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color tColor, int zoneFlg){
    xPos = new_xPos;
    yPos = new_yPos;
    barWidth = new_barWidth;
    orig_barWidth = new_barWidth;
    barHeight = new_barHeight;
    buttonPos = yPos;
    nPlayers = players;
    fingerTest = new MTFinger(new_xPos, new_yPos, 30, null);
    atTopEdge = false;
    atBottomEdge = false;
    teamColor = tColor;
    zoneFlag = zoneFlg;
  }// CTOR
  
  void generateBars(){
    if(zoneFlag == 0){
      yMinTouchArea = borderHeight;
      yMaxTouchArea = height/2;
    }else if(zoneFlag == 1){
      yMinTouchArea = height/2;
      yMaxTouchArea = height/2 - borderHeight;
    }
    
    foosPlayers = new Foosman[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new Foosman( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth, playerWidth, playerHeight, ballArray.length , this);
    }
  }// ScrollBar CTOR
  
  void display(){
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
  
  void displayZones(){
    // Zone Bar
    if(pressed)
      fill( #00FF00, 50);
    else if(hasBall)
      fill( #FF0000, 50);
    else
      fill( #AAAAAA, 50);
    rect(xPos, yMinTouchArea, orig_barWidth, yMaxTouchArea);
    rectMode(CENTER);
    if(zoneFlag == 0)
      rect(xPos + orig_barWidth/2, yMinTouchArea + screenHeight/4, barWidth, yMaxTouchArea);
    if(zoneFlag == 1)
      rect(xPos + orig_barWidth/2, yMinTouchArea + screenHeight/5, barWidth, yMaxTouchArea);
    rectMode(CORNER);
  }// displayZones
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,12);
    
    text("Spring: "+spring, xPos, yPos+barHeight-16*9);
    text("Rotate Velocity: "+rotateVel, xPos, yPos+barHeight-16*8);
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
      foosPlayers[i].displayDebug(debugColor, font);
  }// displayDebug
  
  void displayHitbox(){
  }
  
  boolean isHit( float xCoord, float yCoord ){
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
        xMove = constrain(xMove, -10, 10);
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
    
    // If spring == true, bar will "spring" back to down position
    if( springEnabled ){
      //if(pressed || rotateVel != 0) // Debug text - prints velocity
      //  println(rotateVel);
      
      if( rotation < 0 ){
        rotateVel += spring;
        rotation += rotateVel;
      }else if( rotation > 0 ){
        rotateVel -= spring;
        rotation += rotateVel;
      }
      xMove = rotateVel*100;
      
      // Stops spring
      if( rotation < 0.1 && rotation > -0.1 ){
        rotateVel = 0;
        rotation = 0;
      }
  
    }// if spring enabled
    
    pressed = false;
    return false;
  }// isHit
  
  boolean ballInArea(Ball[] balls){
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
  
  boolean collide(Ball[] balls){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].collide(balls);
    return false;
  }// collide
 
  void reset(){
    pressed = false;
    xMove = 0;
    yMove = 0;
  }// reset
  
  // Setters and Getters
  
  void setButtonPos(float pos){
    buttonPos = -1*(yPos*pos-barWidth*pos-barHeight*pos-yPos);
    buttonValue = (yPos-buttonPos)/(yPos-barWidth-barHeight); // Update debug display
  }// setButtonPos
  
  void setGameTimer( double timer_g ){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].setGameTimer(timer_g);
  }// setGameTimer
  
  void setSpringEnabled(boolean enable){
    springEnabled = enable;
  }// setSpringEnabled
  
  boolean isSpringEnabled(){
    return springEnabled;
  }// isSpringEnabled
  
  // Setups ball pointers and screen dimentions before bar generation
  void setupBars(int[] screenDim, Ball[] balls){
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    ballArray = balls;
    generateBars(); // Create foosbars after screen/border dimentions are known
  }// setupBars  
}// class Foosbar

