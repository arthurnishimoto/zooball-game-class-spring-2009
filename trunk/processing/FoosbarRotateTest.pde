/**
 * ---------------------------------------------
 * Foosbar2.pde
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
 * ---------------------------------------------
 */
 
class Foosbar2{
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
  Foosman2[] foosPlayers;
  Ball[] ballArray;
  boolean springEnabled = false;
  float spring = 0.01;
  float barRotation = 0;
  float rotateVel;
  float barFriction = 0.15;
  
  int playerWidth = 50;
  int playerHeight = 60;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  Foosbar2(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color tColor, int zoneFlg){
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
  
  void generateBars(){
    if(zoneFlag == 0){
      yMinTouchArea = borderHeight;
      yMaxTouchArea = height/2;
    }else if(zoneFlag == 1){
      yMinTouchArea = height/2;
      yMaxTouchArea = height/2 - borderHeight;
    }else{
      yMinTouchArea = 0;
      yMaxTouchArea = height;      
    }
    
    foosPlayers = new Foosman2[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new Foosman2( xPos+barWidth/2, (i+1)*barHeight/(nPlayers+1)-playerWidth, playerWidth, playerHeight, ballArray.length , this);
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
      if( xMove > 0 ){
        barRotation += xMove * rotateMultiplier;
        xMove -= barFriction;
        rotateVel = xMove * rotateMultiplier;
      }else if( xMove < 0 ){
        barRotation += xMove * rotateMultiplier;
        xMove += barFriction;
        rotateVel = xMove * rotateMultiplier;
      }
    }else if( zoneFlag == 1 ){
      if( xMove > 0 ){
        barRotation -= xMove * rotateMultiplier;
        xMove -= barFriction;
        rotateVel = xMove * rotateMultiplier;
      }else if( xMove < 0 ){
        barRotation -= xMove * rotateMultiplier;
        xMove += barFriction;
        rotateVel = xMove * rotateMultiplier;
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
  
  float getBarSlideMultiplier(){
    return sliderMultiplier;
  }// getBarSlideMultiplier
  
  float getBarRotateMultiplier(){
    return rotateMultiplier;
  }// getBarRotateMultiplier  
  
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
}// class Foosbar2

/**
 * ---------------------------------------------
 * Foosman2.pde
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
 * 4/3/09    - Rotating image implemented
 * 4/9/09    - Hit box displayed, but not active
 * ---------------------------------------------
 */

class Foosman2{
  
  // Foosman2 Images
  String filepath = "data/foosmen_pink/";
  String filename = "top_";
  String extention = ".png";
  PImage rotateImages[] = new PImage[360];
  int rotateInc = 15;
  
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  float hitBuffer = 20;
  boolean active, atTopEdge, atBottomEdge;
  boolean topBufferHit, bottomBufferHit, leftBufferHit, rightBufferHit;
  boolean topHit, bottomHit, leftHit, rightHit;
  Foosbar2 parent;
  int ballsRecentlyHit[];
  int nBalls;
    
  //GLOBAL button time
  double buttonDownTime = 0.3;
  double buttonLastPressed = 0;
  double gameTimer;
  
  // Hit box information
  float hit_xPos;
  float hit_yPos;
  float hit_width = 31;
  float hit_height = 68;
  float hit_horz_shift = 0;
  int maxStopAngle = 330;
  int minStopAngle = 300;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
    
  Foosman2( float x, float y, int newWidth, int newHeight, int numBalls, Foosbar2 new_parent){
    if( displayArt ){
    if( new_parent.zoneFlag == 0 ){ // Top player - faces right
      filepath = "data/foosmen_red/red_";
    }else if( new_parent.zoneFlag == 1 ){ // Bottom player - faces left
      filepath = "data/foosmen_yellow/yellow_";
    }
  
      // Loads all rotation images
    for(int i = 0; i < 360; i += rotateInc)
      rotateImages[i] = loadImage(filepath + filename + i + extention);
    }
    xPos = x;
    yPos = y;
    playerWidth = newWidth;
    orig_Width = newWidth;
    playerHeight = newHeight;
    parent = new_parent;
    ballsRecentlyHit = new int[numBalls];
    nBalls = numBalls;
    
    hit_xPos = xPos - hit_width/2;
    hit_yPos = yPos;
  
    // Sets the screen size and border size - Used for edge collision
    screenWidth = parent.screenWidth;
    screenHeight = parent.screenHeight;
    borderWidth = parent.borderWidth;
    borderHeight = parent.borderHeight;
  }// CTOR
  
  void display(){
    active = true;
    
    // Maintains Hitbox shile moving
    if( parent.zoneFlag == 0 ){
      if( parent.barRotation >= 0 && parent.barRotation < 15 ) 
        hit_horz_shift = 0;
      else if( parent.barRotation >= 15  && parent.barRotation < 30 ) 
        hit_horz_shift = 25 * 1;
      else if( parent.barRotation >= 30  && parent.barRotation < 45 ) 
        hit_horz_shift = 25 * 2;
      else if( parent.barRotation >= 45 && parent.barRotation < 60 ) 
        hit_horz_shift = 25 * 3 - 5;
      else if( parent.barRotation >= 60  && parent.barRotation < 75 ) 
        hit_horz_shift = 25 * 4 - 15;
          
      else if( parent.barRotation >= 345  && parent.barRotation < 360 ) 
        hit_horz_shift = -25 * 1;
      else if( parent.barRotation >= 330  && parent.barRotation < 375 ) 
        hit_horz_shift = -25 * 2;
      else if( parent.barRotation >= 315 && parent.barRotation < 330 ) 
        hit_horz_shift = -25 * 3 + 5;
      else if( parent.barRotation >= 300  && parent.barRotation < 315 ) 
        hit_horz_shift = -25 * 4 + 15;
      else
        hit_horz_shift = 720;
    }else if( parent.zoneFlag == 1 ){
      if( parent.barRotation >= 0 && parent.barRotation < 15 ) 
        hit_horz_shift = 0;
      else if( parent.barRotation >= 15  && parent.barRotation < 30 ) 
        hit_horz_shift = -25 * 1;
      else if( parent.barRotation >= 30  && parent.barRotation < 45 ) 
        hit_horz_shift = -25 * 2;
      else if( parent.barRotation >= 45 && parent.barRotation < 60 ) 
        hit_horz_shift = -25 * 3 + 5;
      else if( parent.barRotation >= 60  && parent.barRotation < 75 ) 
        hit_horz_shift = -25 * 4 + 15;
          
      else if( parent.barRotation >= 345  && parent.barRotation < 360 ) 
        hit_horz_shift = 25 * 1;
      else if( parent.barRotation >= 330  && parent.barRotation < 375 ) 
        hit_horz_shift = 25 * 2;
      else if( parent.barRotation >= 315 && parent.barRotation < 330 ) 
        hit_horz_shift = 25 * 3 - 5;
      else if( parent.barRotation >= 300  && parent.barRotation < 315 ) 
        hit_horz_shift = 25 * 4 - 15;
      else
        hit_horz_shift = 720;      
    }
    hit_xPos = (xPos-hit_width/2) + hit_horz_shift;
    hit_yPos = yPos - 4;
    
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
    
    // Player Width
    playerWidth = 0;
    fill( #000000 );
    rect(xPos, yPos, playerWidth, playerHeight);

    if( !displayArt ){
    // Team Color
    fill( parent.teamColor );
    rect(xPos-orig_Width/2, yPos, orig_Width, playerHeight);
    }
    
    // Images
    pushMatrix();
    imageMode(CENTER);
    translate(xPos, yPos + playerHeight/2);

    float barRotation = parent.barRotation;
    
    if( parent.zoneFlag == 0 ){ // Top player - faces right
     rotate(radians(-90));
    }else if( parent.zoneFlag == 1 ){ // Bottom player - faces left
      rotate(radians(-90));
    }
    
    int imageInc = rotateInc/2;
    if( displayArt ){
    if( barRotation >= 360 - rotateInc && barRotation < 0 + rotateInc )
      image(rotateImages[0], 0, 0);
    else{
      for( int i = 0;  i < 360; i += rotateInc ){
        if( barRotation >= i - rotateInc && barRotation < i + rotateInc ){
          image(rotateImages[i], 0, 0);
          break;
        }
      }// for
    }// else
    }
    popMatrix();
  }// display
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,12);

    text("Position: "+xPos+", "+yPos, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*0);
    text("playerWidth: "+playerWidth, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*1);
    if( atTopEdge )
      text("atTopEdge", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*2);
    if( atBottomEdge )
      text("atBottomEdge", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*2);
    for( int i = 0; i < nBalls; i++)
      text("RecentlyHit["+i+"]: "+ballsRecentlyHit[i], xPos + playerWidth + 16, yPos+playerHeight/2 + 16*(3+i));
  }// displayDebug

  void displayHitbox(){
    //Display Hitbox
    if( hit_horz_shift != 720 ){
      if( parent.barRotation > minStopAngle && parent.barRotation < maxStopAngle )
        stroke( 255, 0, 0);
      else
        stroke( 0, 255, 0);
      fill( 0,0,0 );
      ellipse( hit_xPos, hit_yPos, 5, 5 ); // Upper left
      ellipse( hit_xPos + hit_width , hit_yPos, 5, 5 ); // Upper Right
      ellipse( hit_xPos , hit_yPos + hit_height, 5, 5 ); // Lower Left
      ellipse( hit_xPos + hit_width, hit_yPos + hit_height, 5, 5 ); // Lower Right
      
      // Hit buffer
      ellipse( hit_xPos - hitBuffer, hit_yPos - hitBuffer, 5, 5 ); // Upper left
      ellipse( hit_xPos + hit_width + hitBuffer, hit_yPos - hitBuffer, 5, 5 ); // Upper Right
      ellipse( hit_xPos - hitBuffer, hit_yPos + hit_height + hitBuffer, 5, 5 ); // Lower Left
      ellipse( hit_xPos + hit_width + hitBuffer, hit_yPos + hit_height + hitBuffer, 5, 5 ); // Lower Right
    }
    
    if( topBufferHit ){
      fill(255,255,0);
      stroke(0,0,0);
      rect( hit_xPos - hitBuffer, hit_yPos - hitBuffer, hit_width + hitBuffer*2, 5 );
      topBufferHit = false;
    }if( bottomBufferHit ){
      fill(255,255,0);
      stroke(0,0,0);
      rect( hit_xPos - hitBuffer, hit_yPos + hit_height + hitBuffer, hit_width + hitBuffer*2, 5 );
      bottomBufferHit = false;   
    }
    if( topHit ){
      fill(255,0,0);
      stroke(0,0,0);
      rect( hit_xPos, hit_yPos, hit_width, 5 );
      topHit = false;
    }if( bottomHit ){
      fill(255,0,0);
      stroke(0,0,0);
      rect( hit_xPos, hit_yPos + hit_height, hit_width, 5 );
      bottomHit = false;
    }
    
    if( leftBufferHit ){
      fill(255,255,0);
      stroke(0,0,0);
      rect( hit_xPos - hitBuffer, hit_yPos - hitBuffer, 5, hit_height + hitBuffer*2 );
      leftBufferHit = false;
    }if( rightBufferHit ){
      fill(255,255,0);
      stroke(0,0,0);
      rect( hit_xPos + hit_width + hitBuffer, hit_yPos - hitBuffer, 5, hit_height + hitBuffer*2 );
      rightBufferHit = false;
    }
    if( leftHit ){
      fill(255,0,0);
      stroke(0,0,0);
      rect( hit_xPos, hit_yPos, 5, hit_height );
      leftHit = false;
    }if( rightHit ){
      fill(255,0,0);
      stroke(0,0,0);
      rect( hit_xPos + hit_width, hit_yPos, 5, hit_height );
      rightHit = false;
    }
  }// displayHitbox
  
  boolean collide(Ball[] balls){
    if( parent.barRotation > 75 && parent.barRotation < 300 ) // Player is rotated high enough for ball to pass
      return false;
         
    for( int i = 0; i < nBalls; i++ ){
   
      // If ball is inside the hit buffer zone and if has hit recently, iqnore any collisions with current ball. - Prevents internal bouncing
      if( balls[i].xPos+balls[i].diameter/2 > hit_xPos - hitBuffer && balls[i].xPos+balls[i].diameter/2 < hit_xPos + hit_width + hitBuffer)
        if( balls[i].yPos+balls[i].diameter/2 > hit_yPos - hitBuffer && balls[i].yPos-balls[i].diameter/2 < hit_yPos + hit_height + hitBuffer)
          if(ballsRecentlyHit[i] == 1)
            continue;
      
      // Hit buffer zones
      if(balls[i].xPos > hit_xPos - hitBuffer && balls[i].xPos < hit_xPos + hit_width + hitBuffer){ // Ball is between the left and right edges of the hit buffer
        if( balls[i].yPos + balls[i].diameter/2 > hit_yPos - hitBuffer && balls[i].yPos - balls[i].diameter/2 < hit_yPos + hit_height/2 ) // Ball center is between top hit buffer and center
        { 
          topBufferHit = true;
        }// if ball enters top buffer zone
        else if(balls[i].yPos - balls[i].diameter/2 < hit_yPos + hit_height + hitBuffer && balls[i].yPos + balls[i].diameter/2 > hit_yPos + hit_height/2)
        {
          bottomBufferHit = true;
        }// else-if ball entered bottom buffer zone

        // If hit box collision (Top-bottom collision)
        if( balls[i].yPos + balls[i].diameter/2 > hit_yPos && balls[i].yPos - balls[i].diameter/2 < hit_yPos + hit_height/2 ) // Ball center is between bottom hit buffer and center
        { 
          topHit = true;
          ballsRecentlyHit[i] = 1;  // Flag collision has occured
          balls[i].kickBall( 2 , parent.xMove, parent.yMove); // Bounce ball back ( invert yVel ) + add bar speed
          continue;
        }// if ball hit top hit zone
        else if(balls[i].yPos - balls[i].diameter/2 < hit_yPos + hit_height && balls[i].yPos + balls[i].diameter/2 > hit_yPos + hit_height/2)
        {
          bottomHit = true;
          ballsRecentlyHit[i] = 1;  // Flag collision has occured
          balls[i].kickBall( 2 , parent.xMove, parent.yMove); // Bounce ball back ( invert yVel ) + add bar speed
          continue;
        }// else-if ball hits bottom hit
      }// if ball is between the left and right edges of the hit buffer
      
      if( balls[i].yPos > hit_yPos - hitBuffer && balls[i].yPos < hit_yPos + hit_height + hitBuffer ){ // Ball is between top and bottom hit buffer edges
        if(balls[i].xPos + balls[i].diameter/2  > hit_xPos - hitBuffer && balls[i].xPos - balls[i].diameter/2 < hit_xPos + hit_width/2){ // Ball is between the left hit buffer and center
          leftBufferHit = true;            
        }// if Ball is between the left hit buffer and center
        else if(balls[i].xPos - balls[i].diameter/2 < hit_xPos + hit_width + hitBuffer && balls[i].xPos + balls[i].diameter/2 > hit_xPos + hit_width/2){ // Ball is between the right hit buffer and center
          rightBufferHit = true;
        }// if Ball is between the right hit buffer and center
        
        // If hit box collision (Left-right collision)
        if(balls[i].xPos + balls[i].diameter/2  > hit_xPos && balls[i].xPos - balls[i].diameter/2 < hit_xPos + hit_width/2){ // Ball is between the left hit buffer and center
          leftHit = true;
          // Stops ball when "wedged" by foosman at a certain angle
          if( parent.barRotation > minStopAngle && parent.barRotation < maxStopAngle )
            if( balls[i].getSpeed() > 1 )
              balls[i].stopBall();
            
          ballsRecentlyHit[i] = 1;  // Flag collision has occured
          balls[i].kickBall( 1 , parent.xMove, parent.yMove); // Bounce ball back ( invert yVel ) + add bar speed
          continue;
          
        }// if Ball is between the left hit buffer and center
        else if(balls[i].xPos - balls[i].diameter/2 < hit_xPos + hit_width && balls[i].xPos + balls[i].diameter/2 > hit_xPos + hit_width/2){ // Ball is between the right hit buffer and center
          rightHit = true;
          // Stops ball when "wedged" by foosman at a certain angle
          if( parent.barRotation > minStopAngle && parent.barRotation < maxStopAngle )
            if( balls[i].getSpeed() > 1 )
              balls[i].stopBall();
              
          ballsRecentlyHit[i] = 1;  // Flag collision has occured
          balls[i].kickBall( 1 , parent.xMove, parent.yMove); // Bounce ball back ( invert yVel ) + add bar speed
          continue;
        }// if Ball is between the right hit buffer and center
      }// If Ball is between top and bottom hit buffer edges
      
      /*
      // If ball is within hit box... (Left-right collision)
      if( balls[i].xPos+balls[i].diameter/2 > hit_xPos && balls[i].xPos-balls[i].diameter/2 < hit_xPos + hit_width ) // Ball right within left side && Ball left is within right side
        if( balls[i].yPos+balls[i].diameter/2 > hit_yPos && balls[i].yPos-balls[i].diameter/2 < hit_yPos + hit_height ) // Ball bottom is within top side && Ball top is within bottom side
          {
            if( ballsRecentlyHit[i] == 1 )
              continue;
              
            // Stops ball when "wedged" by foosman at a certain angle
            if( parent.barRotation > 300 && parent.barRotation < 315 ){
              if( balls[i].getSpeed() > 1 )
                balls[i].stopBall();
            }
            ballsRecentlyHit[i] = 1;
            balls[i].kickBall( 1 , parent.xMove, parent.yMove); // Bounce ball back ( invert xVel ) + add bar speed
            continue;            
          }// if ball hits left side of foosman
      */
      
      // If bar not hit and recently hit, clear flag
      if(ballsRecentlyHit[i] == 1){
          ballsRecentlyHit[i] = 0;
          balls[i].setColor(color(#FFFFFF));
      }
    }//for all balls
    return false;
  }// collide
  
  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer
  
  boolean setDelay(){
    if(buttonLastPressed == 0){
      buttonLastPressed = ((buttonLastPressed + buttonDownTime)-gameTimer);
      return false;
    }else if ( buttonLastPressed + buttonDownTime < gameTimer){
      buttonLastPressed = gameTimer;
      return true;
    }// if-else-if button pressed
    return false;
  }// setDelay
}//class Foosman2

