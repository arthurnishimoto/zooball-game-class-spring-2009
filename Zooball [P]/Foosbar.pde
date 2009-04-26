/**
 * ---------------------------------------------
 * Foosbar.pde
 *
 * Description: Foosbar object containing foosmen
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - FSM implementation
 * 4/1/09    - "Spring-loaded" foosbar option added
 * 4/3/09    - Added barRotation and support for 360 images
 * 4/10/09   - Basic hit zones added. Bar rotation multipler.
 *           - Ball/bar basic top,left,bottom,right zone collision implemented. Bar at certain angle stops ball
 * 4/16/09   - Fixed "shaky" bar during very low rotation velocities
 * 4/21/09   - Version 0.3 - Revised "Spring-loaded" option for bar rotation. Applies velocity on press release.
 * 4/24/09   - Catch/release ball and associated effects added.
 * ---------------------------------------------
 */

class Foosbar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea, yMaxTouchArea;
  color teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  boolean centerZonePressed;
  float centerZoneWidth = 50;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0;
  float sliderMultiplier = 3;
  float rotateMultiplier = 1;
  int nPlayers, zoneFlag;
  MTFinger fingerTest;
  Foosmen[] foosPlayers;
  Ball[] ballArray;
  float spring = 0.01;
  float barRotation = 0;
  float rotateVel;
  float barFriction = 0.15;
  
  float orig_sliderMultiplier = sliderMultiplier;
  float orig_rotateMultiplier = rotateMultiplier;
  float debuffDuration = 7;
  float debuffTimer = 0;
  double gameTimer;
  boolean debuffed = false;
  
  boolean springEnabled = false;
  boolean rotationEnabled = true;

  boolean hasSpecial = true; // If foosbar has special ability ready

  boolean dragons = false;
  boolean tigers = false;

  PImage[] foosmenImages;
  
  int playerWidth = 50;
  int playerHeight = 60;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  //Statistics
  int numStatistics = 20;
  byte[] statistics;
  byte[] record;
  
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
    statistics = new byte[numStatistics];
    record = loadBytes("data/records/"+this.getFoosbarID()+".dat");  
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
      if( redTeamTop )
        dragons = true;
      else
        tigers = true;
      yMinTouchArea = borderHeight;
      yMaxTouchArea = game.getHeight()/2 - borderHeight;
    }else if(zoneFlag == 1){
      if( !redTeamTop )
        dragons = true;
      else
        tigers = true;
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
    
    if(debuffed){
      sliderMultiplier = 0.5;
      rotateMultiplier = 0.5;   
      if( debuffTimer < gameTimer ){
        debuffTimer = 0;
        debuffed = false;
      }
    }else{
      sliderMultiplier = orig_sliderMultiplier;
      rotateMultiplier = orig_rotateMultiplier;
    }
    
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
       
    // Gets xMove directly from finer to also stop spinning
    if( centerZonePressed && fingerTest.xMove == 0 && !pressed ){ // Resets to neutral position if center zone tapped
      barRotation = 0;
      rotateVel = 0;
      xMove = 0; // Stops spinning on release
    }
    
    if( hasBall && !pressed)
      for(int i = 0; i < foosPlayers.length; i++)
        foosPlayers[i].releaseBall();

    // If spring == true, bar will "spring" back to down position
    if( springEnabled ){
      
      if( rotation < 0 ){
        if( zoneFlag == 1 ){
          rotation += spring * 10;
          if(!pressed) // Applies velocity on press release
            rotateVel = barRotation/4;
          barRotation = abs(rotation*100);
        }else if( zoneFlag == 0 ){
          rotation += spring * 10;
          if(!pressed) // Applies velocity on press release
            rotateVel = (360 - barRotation)/4;
          barRotation = 360 + rotation*100;
        }
        
      }else if( rotation > 0 ){
        if( zoneFlag == 1 ){
          rotation -= spring * 10;
          if(!pressed) // Applies velocity on press release
            rotateVel = (360 - barRotation)/4;
          barRotation = 360 - rotation*100;
        }else if( zoneFlag == 0 ){
          rotation -= spring * 10;
          if(!pressed) // Applies velocity on press release
            rotateVel = barRotation/4;
          barRotation = rotation*100;          
        }
        
      }else if( rotation == 0 )
        barRotation = 0;
        
      xMove = rotateVel*100;
      
      // Stops spring
      if( rotation < 0.1 && rotation > -0.1 ){
        rotateVel = 0;
        rotation = 0;
      }
      return;
    }// if spring enabled
    
    // Bar rotation
    if(rotationEnabled){
      if( zoneFlag == 0 ){
        if( xMove > 1 ){
          if( !hasBall )
            barRotation += xMove * rotateMultiplier;
          xMove -= barFriction;
          rotateVel = xMove * rotateMultiplier;
        }else if( xMove < -1 ){
          if( !hasBall )
            barRotation += xMove * rotateMultiplier;
          xMove += barFriction;
          rotateVel = xMove * rotateMultiplier;
        }else{
          xMove = 0;
          rotateVel = 0;
        }
      }else if( zoneFlag == 1 ){
        if( xMove > 1 ){
          if( !hasBall )
            barRotation -= xMove * rotateMultiplier;
          xMove -= barFriction;
          rotateVel = xMove * rotateMultiplier;
        }else if( xMove < -1 ){
          if( !hasBall )
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
    }// if rotationEnabled
    if( hasBall )
      barRotation = 0; // Locks bar rotation if hasBall
  }// display

  void displayStats(){
    fill( 0, 0, 0, 150 );
    rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
    
    textAlign(CENTER);
    fill(teamColor);
    textFont(font,14);
 
    if( zoneFlag == 1){

      text( getFoosbarInfo(), xPos + barWidth/2, yMinTouchArea + 32);
    }else if( zoneFlag == 0){
      pushMatrix();
      translate( xPos + barWidth/2, yMinTouchArea + yMaxTouchArea - 32);
      rotate( PI );
      text( getFoosbarInfo(),0, 0);
      popMatrix();
    }//
    textAlign(LEFT);
  }// displayStats
  
  void displayZones(){
    noStroke();
    
    // Zone Bar
    if(pressed)
      fill( #00FF00, 50);
    //else if(hasBall)
    //  fill( #FF0000, 50);
    else
      fill( #AAFFAA, 50);
    noStroke();
    rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
    
    // Center Zone Bar
    if(centerZonePressed)
      fill( #00FFFF, 50);
    else
      fill( #00AAAA, 50);
    rect(xPos+barWidth/2 - centerZoneWidth/2, yMinTouchArea, centerZoneWidth, yMaxTouchArea);
  }// displayZones
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,12);
    if( debuffTimer - gameTimer > 0)
      text("Debuff Time Remaining "+(debuffTimer - gameTimer), xPos, yPos+barHeight-16*10);
    text("Bar Rotation: "+barRotation, xPos, yPos+barHeight-16*9);
    text("Rotate Velocity: "+rotateVel, xPos, yPos+barHeight-16*8);
    text("Active: "+pressed, xPos, yPos+barHeight-16*7);
    text("Y Position: "+buttonValue, xPos, yPos+barHeight-16*6);
    text("Movement: "+xMove+" , "+yMove, xPos, yPos+barHeight-16*5);
    text("Rotation: "+rotation*100, xPos, yPos+barHeight-16*4);
    text("Players: "+nPlayers, xPos, yPos+barHeight-16*3);
    if(atTopEdge)
      text("atTopEdge", xPos, yPos+barHeight-16*2);
    else if(atBottomEdge)
      text("atBottomEdge", xPos, yPos+barHeight-16*2);
    else if(dragons)
      text("DRAGONS/RED", xPos, yPos+barHeight-16*2);
    else if(tigers)
      text("TIGERS/YELLOW", xPos, yPos+barHeight-16*2);      
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
        
        if( xCoord > xPos + barWidth/2 - centerZoneWidth/2 && xCoord < xPos + barWidth/2 + centerZoneWidth/2 && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea)
          centerZonePressed = true;
        else
          centerZonePressed = false;
          
        rotation = (xCoord-(xPos+barWidth/2))/barWidth; // Rotation: value from -0.5 (fully up to the left) to 0.5 (fully up to the right)
    
        if( fingerTest.xMove*sliderMultiplier != 0)
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
    /*
    for( int i = 0; i < balls.length; i++ ){
      if( !balls[i].isActive() )
        return false;
      if( balls[i].xPos > xPos && balls[i].xPos < xPos + barWidth ){
        hasBall = true;

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
        
        return true;
      }// if
    }// for
    hasBall = false;
    */
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
    gameTimer = timer_g;
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].setGameTimer(timer_g);
  }// setGameTimer
  
  void setSpringEnabled(boolean enable){
    springEnabled = enable;
  }// setSpringEnabled
  
  void setRotationEnabled(boolean enable){
    rotationEnabled = enable;
  }// setRotationEnabled 
  
  void setBarSlideMultiplier(float newVal){
    sliderMultiplier = newVal;
    orig_sliderMultiplier = newVal;
  }// setBarSlideMultiplier

  void setBarRotateMultiplier(float newVal){
    rotateMultiplier = newVal;
    orig_rotateMultiplier = newVal;
  }// setBarRotateMultiplier
  
  void setMinStopAngle(int newVal){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].setMinStopAngle(newVal);
  }// setMinStopAngle
  
  void setMaxStopAngle(int newVal){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].setMaxStopAngle(newVal);
  }// setMaxStopAngle
  
  void setDebuff(){
    debuffTimer = debuffDuration + (float)gameTimer;
    debuffed = true;
  }// setDebuff 
    
  float getBarSlideMultiplier(){
    return sliderMultiplier;
  }// getBarSlideMultiplier
  
  float getBarRotateMultiplier(){
    return rotateMultiplier;
  }// getBarRotateMultiplier  
  
  boolean isSpringEnabled(){
    return springEnabled;
  }// isSpringEnabled
  
  boolean isRotationEnabled(){
    return rotationEnabled;
  }// isRotationEnabled
  
  boolean isDragon(){
    return dragons;
  }// isDragon
  
  boolean isTiger(){
    return tigers;
  }// isTiger
  
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

  int getFoosbarID(){
    if( (redTeamTop && zoneFlag == 0) || (!redTeamTop && zoneFlag == 1) ){
      switch(nPlayers){
        case(1):
          return 0;
        case(2):
          return 1;
        case(3):
          return 3;
        case(4):
          return 2;
        default:
          return -1;    
      }// switch      
    }else if( (redTeamTop && zoneFlag == 1) || (!redTeamTop && zoneFlag == 0) ){
      switch(nPlayers){
        case(1):
          return 4;
        case(2):
          return 5;
        case(3):
          return 7;
        case(4):
          return 6;
        default:
          return -1;    
      }// switch      
    }
    return -1;
  }// getFoosbarID
  
  
  Foosbar getFoosbar(){
    return this;
  }// getFoosbar
  
  void updateFoosbarRecord(){
    if( statistics[0] > record[0] )
      record[0] = statistics[0];
    if( statistics[1] > record[1] )
      record[1] = statistics[1];
    if( statistics[2] > record[2] )
      record[2] = statistics[2];
    if( statistics[3] > record[3] )
      record[3] = statistics[3];
    if( statistics[4] > record[4] )
      record[4] = statistics[4];
    if( statistics[5] > record[5] )
      record[5] = statistics[5];
    if( statistics[6] > record[6] )
      record[6] = statistics[6];
    saveBytes("data/records/"+this.getFoosbarID()+".dat", record);
  }// updateFoosbarRecord
  
  String getFoosbarInfo(){
    if( record == null ){
      saveBytes("data/records/"+this.getFoosbarID()+".dat", statistics);
      record = loadBytes("data/records/"+this.getFoosbarID()+".dat");  
    }else
      record = loadBytes("data/records/"+this.getFoosbarID()+".dat"); 
    
    String output = "";
    
    output += this;    
    output += "Statistics\n";
    output += "Goals scored: " + statistics[0];
    if( statistics[0] > record[0] )
      output += " NEW!";
    output += "\nGoals scored on own team: " + statistics[1];
    if( statistics[1] > record[1] )
      output += " NEW!";
    output += "\nBall hits: " + statistics[2];
    if( statistics[2] > record[2] )
      output += " NEW!";
    output += "\nBall stops: " + statistics[3];
    if( statistics[3] > record[3] )
      output += " NEW!";
    output += "\nBalls caught: " + statistics[4];
    if( statistics[4] > record[4] )
      output += " NEW!";
    if( isTiger() )
      output += "\nDragons Tricked: " + statistics[5];
    if( statistics[5] > record[5] )
      output += " NEW!";
    if( isDragon() )
      output += "\nTigers set on fire: " + statistics[6];
    if( statistics[6] > record[6] )
      output += " NEW!";
    output += "\nBoosters used: " + statistics[7];
    if( statistics[7] > record[7] )
      output += " NEW!";
      
    output += "\n\n\nRecord\n\n";
    output += "Goals scored: " + record[0] + "\n";
    output += "Goals scored on own team: " + record[1] + "\n";
    output += "Ball hits: " + record[2] + "\n";
    output += "Ball stops: " + record[3] + "\n";
    output += "Balls caught: " + record[4] + "\n";
    if( isTiger() )
      output += "Dragons Tricked: " + record[5] + "\n";
    if( isDragon() )
      output += "Tigers set on fire: " + record[6] + "\n";    
    output += "Boosters used: " + record[7];
    
    return output;
  }// getFoosbarInfo
  
  public String toString(){
    String output = "";
    
    // Team Name
    if( redTeamTop && zoneFlag == 0)
      output += "Dragons ";
    else if ( redTeamTop && zoneFlag == 1)
      output += "Tigers ";
    else if( !redTeamTop && zoneFlag == 1)
      output += "Dragons ";
    else if ( !redTeamTop && zoneFlag == 0)
      output += "Tigers ";
      
    // Position
    switch(nPlayers){
      case(1):
        output += "Goalkeeper\n";
        break;
      case(2):
        output += "Defense\n";
        break;
      case(3):
        output += "Attack\n";
        break;
      case(4):
        output += "Midfield\n";
        break;
      default:
        output += "UNKNOWN POSITION\n";
        break;      
    }// switch
    return output;
  }//toString()
}// class Foosbar

