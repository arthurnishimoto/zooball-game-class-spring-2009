/**
 * ---------------------------------------------
 * Foosbar.pde
 *
 * Description: Foosbar object containing foosmen
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.2
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - FSM implementation
 * 4/1/09    - "Spring-loaded" foosbar option added
 * 4/3/09    - Added barRotation and support for 360 images
 * 4/10/09   - Basic hit zones added. Bar rotation multipler.
 *           - Ball/bar basic top,left,bottom,right zone collision implemented. Bar at certain angle stops ball
 * 4/16/09   - Fixed "shaky" bar during very low rotation velocities
 * ---------------------------------------------
 */
 
class Foosbar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea, yMaxTouchArea;
  color teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0;
  float sliderMultiplier = 2;
  float rotateMultiplier = 3;
  int nPlayers, zoneFlag;
  MTFinger fingerTest;
  Foosmen[] foosPlayers;
  Ball[] ballArray;
  boolean springEnabled = false;
  float spring = 0.01;
  float barRotation = 0;
  float rotateVel;
  float barFriction = 0.15;
  
  PImage[] foosmenImages;
  
  int playerWidth = 50;
  int playerHeight = 60;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  /**
   * Setups a new Foosbar object.
   *
   * @param new_xPos- initial x position
   * @param new_yPos - initial y position
   * @param new_barWidth - initial bar zone width
   * @param new_barHeight - initial bar zone height
   * @param players - Number of foosmen on the bar
   * @param tColor - Color of the foosmen
   * @param zoneFlg - Zone flag: 0 = (top half of screen), 1 = (bottom half of screen), else (height of screen)
   */  
  Foosbar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color tColor, int zoneFlg, PImage[] images){
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
    foosmenImages = images;
  }// CTOR

  /**
   * Setups ball pointers and screen dimentions before bar generation
   */
  void setupBars(int[] screenDim, Ball[] balls){
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    ballArray = balls;
    generateBars(); // Create foosbars after screen/border dimentions are known
  }// setupBars  
  
  /**
   * Creates the foosbars and sets the zones. setupBars() must be called before this. 
   */
  void generateBars(){
    if(zoneFlag == 0){
      yMinTouchArea = borderHeight;
      yMaxTouchArea = game.getHeight()/2 - borderHeight;
    }else if(zoneFlag == 1){
      yMinTouchArea = game.getHeight()/2;
      yMaxTouchArea = game.getHeight()/2 - borderHeight;
    }else{
      yMinTouchArea = 0;
      yMaxTouchArea = game.getHeight();      
    }
    
    foosPlayers = new Foosmen[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new Foosmen( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth, playerWidth, playerHeight, ballArray.length , this);
    }
  }// ScrollBar CTOR
  
  void display(){
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i].display();
    }
    active = true;
  
    // Swipe
    if( abs(xMove) <= swipeThreshold ){
      xSwipe = true;
      //shoot(4);
    }else{
      xSwipe = false;
    }// if xSwipe

    if( abs(yMove) <= swipeThreshold ){
      ySwipe = true;
      //shoot(5);
    }else{
      ySwipe = false;
    }// if xSwipe

    // Bar rotation
    if( zoneFlag == 0 ){
      if( xMove > 1 ){
        barRotation += xMove * rotateMultiplier;
        xMove -= barFriction;
        rotateVel = xMove * rotateMultiplier;
      }else if( xMove < -1 ){
        barRotation += xMove * rotateMultiplier;
        xMove += barFriction;
        rotateVel = xMove * rotateMultiplier;
      }else{
        xMove = 0;
        rotateVel = 0;
      }
    }else if( zoneFlag == 1 ){
      if( xMove > 1 ){
        barRotation -= xMove * rotateMultiplier;
        xMove -= barFriction;
        rotateVel = xMove * rotateMultiplier;
      }else if( xMove < -1 ){
        barRotation -= xMove * rotateMultiplier;
        xMove += barFriction;
        rotateVel = xMove * rotateMultiplier;
      }else{
        xMove = 0;
        rotateVel = 0;
      }
    }

    if( barRotation >= 360 )
      barRotation = 0;
    else if( barRotation < 0 )
      barRotation = 359;
  }// display
  
  void displayZones(){
    noStroke();
    
    // Zone Bar
    //if(pressed)
    //  fill( #00FF00, 50);
    //else if(hasBall)
    //  fill( #FF0000, 50);
    //else
    fill( #AAAAAA, 50);
    noStroke();
    rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
  }// displayZones
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,12);
    
    text("Bar Rotation: "+barRotation, xPos, yPos+barHeight-16*9);
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
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].displayHitbox(); 
  }// displayHitbox
  
  /**
   * Handles user input and collisions with the screen border
   *
   * @param xCoord - x coordinate of user input
   * @param yCoord - y coordinate of user input
   */
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
        
        // Checks if foosmen at edge of screen
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
   * Checks if ball is inside Foosbar touch zone.
   * Formally used to flick balls in area.
   *
   * @param balls - Array of ball objects
   */  
  boolean ballInArea(Ball[] balls){
    for( int i = 0; i < balls.length; i++ ){
      if( !balls[i].isActive() )
        return false;
      if( balls[i].xPos > xPos && balls[i].xPos < xPos + barWidth ){
        hasBall = true;
        /*
        if(pressed){ // If ball is in area and user flicks in area
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
        }// if pressed
        */
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
    //xMove = 0;
    //yMove = 0;
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
  
  void setBarSlideMultiplier(float newVal){
    sliderMultiplier = newVal;
  }// setBarSlideMultiplier

  void setBarRotateMultiplier(float newVal){
    rotateMultiplier = newVal;
  }// setBarRotateMultiplier
  
  void setMinStopAngle(int newVal){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].setMinStopAngle(newVal);
  }// setMinStopAngle
  
  void setMaxStopAngle(int newVal){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].setMaxStopAngle(newVal);
  }// setMaxStopAngle
  
  float getBarSlideMultiplier(){
    return sliderMultiplier;
  }// getBarSlideMultiplier
  
  float getBarRotateMultiplier(){
    return rotateMultiplier;
  }// getBarRotateMultiplier  
  
  boolean isSpringEnabled(){
    return springEnabled;
  }// isSpringEnabled
  
  int getMinStopAngle(){
    for( int i = 0; i < nPlayers; i++ )
      return foosPlayers[i].getMinStopAngle();
    return 0;
  }// getMinStopAngle
  
  int getMaxStopAngle(){
    for( int i = 0; i < nPlayers; i++ )
      return foosPlayers[i].getMaxStopAngle();
    return 0;
  }// getMaxStopAngle

}// class Foosbar

