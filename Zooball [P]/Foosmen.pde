/**
 * ---------------------------------------------
 * Foosmen.pde
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
 * 4/19/09   - Removed image loading from constructor. Done by parent
 *             to load only one instance of each image.
 * ---------------------------------------------
 */

class Foosmen{
  int rotateInc = 15;
  
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  float hitBuffer = 20;
  boolean active, atTopEdge, atBottomEdge;
  boolean topBufferHit, bottomBufferHit, leftBufferHit, rightBufferHit;
  boolean topHit, bottomHit, leftHit, rightHit;
  boolean hasImage = false;
  Foosbar parent;
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
    
  Foosmen( float x, float y, int newWidth, int newHeight, int numBalls, Foosbar new_parent){
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
    
    if( parent.zoneFlag == 0 && redTeamTop ){ // Top player - faces right
     rotate(radians(-90));
    }else if( parent.zoneFlag == 1 && redTeamTop ){ // Bottom player - faces left
      rotate(radians(-90));
    }
    
    if( parent.zoneFlag == 0 && !redTeamTop ){ // Top player - faces right
     rotate(radians(90));
    }else if( parent.zoneFlag == 1 && !redTeamTop ){ // Bottom player - faces left
      rotate(radians(90));
    }    
    
    int imageInc = rotateInc/2;
    if( displayArt ){
    if( barRotation >= 360 - rotateInc && barRotation < 0 + rotateInc )
      image(parent.foosmenImages[0], 0, 0);
    else{
      for( int i = 0;  i < 360; i += rotateInc ){
        if( barRotation >= i - rotateInc && barRotation < i + rotateInc ){
          image(parent.foosmenImages[i], 0, 0);
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
          // Stops ball when "wedged" by Foosmen at a certain angle
          if( parent.barRotation > minStopAngle && parent.barRotation < maxStopAngle )
            if( balls[i].getSpeed() > 1 )
              balls[i].stopBall();
            
          ballsRecentlyHit[i] = 1;  // Flag collision has occured
          balls[i].kickBall( 1 , parent.xMove, parent.yMove); // Bounce ball back ( invert yVel ) + add bar speed
          continue;
          
        }// if Ball is between the left hit buffer and center
        else if(balls[i].xPos - balls[i].diameter/2 < hit_xPos + hit_width && balls[i].xPos + balls[i].diameter/2 > hit_xPos + hit_width/2){ // Ball is between the right hit buffer and center
          rightHit = true;
          // Stops ball when "wedged" by Foosmen at a certain angle
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
              
            // Stops ball when "wedged" by Foosmen at a certain angle
            if( parent.barRotation > 300 && parent.barRotation < 315 ){
              if( balls[i].getSpeed() > 1 )
                balls[i].stopBall();
            }
            ballsRecentlyHit[i] = 1;
            balls[i].kickBall( 1 , parent.xMove, parent.yMove); // Bounce ball back ( invert xVel ) + add bar speed
            continue;            
          }// if ball hits left side of Foosmen
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
  
  void setMinStopAngle(int newVal){
    minStopAngle = newVal;
  }// setMinStopAngle
  
  void setMaxStopAngle(int newVal){
    maxStopAngle = newVal;
  }// setMaxStopAngle
  
  int getMinStopAngle(){
    return minStopAngle;
  }// getMinStopAngle
  
  int getMaxStopAngle(){
    return maxStopAngle;
  }// getMaxStopAngle
  
}//class Foosmen

