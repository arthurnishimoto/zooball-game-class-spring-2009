
class MTFoosBar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea = 0, yMaxTouchArea = screenHeight/2;
  color teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0;
  int nPlayers;
  MTFinger fingerTest;
  FoosPlayer[] foosPlayers;
  
  int playerWidth = 65;
  int playerHeight = 100;
  
  MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color tColor, int zoneFlag){
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
    rect(xPos, yMinTouchArea, barWidth, yMaxTouchArea);
  }// displayZones
  
  void displayDebug(){
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
  
  boolean ballInArea(Ball[] balls){
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
  
  boolean collide(Ball[] balls){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].collide(balls);
    return false;
  }// collide
  
  void setButtonPos(float pos){
    buttonPos = -1*(yPos*pos-barWidth*pos-barHeight*pos-yPos);
    buttonValue = (yPos-buttonPos)/(yPos-barWidth-barHeight); // Update debug display
  }// setButtonPos
  
  void reset(){
    pressed = false;
    xMove = 0;
    yMove = 0;
  }// reset
}// class

class FoosPlayer{
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  float hitBuffer = 20;
  boolean active, atTopEdge, atBottomEdge;
  MTFoosBar parent;
  int ballsRecentlyHit[] = new int[nBalls];
    
  //GLOBAL button time
  double buttonDownTime = 0.3;
  double buttonLastPressed = 0;
  
  FoosPlayer( float x, float y, int newWidth, int newHeight, MTFoosBar new_parent){
    xPos = x;
    yPos = y;
    playerWidth = newWidth;
    orig_Width = newWidth;
    playerHeight = newHeight;
    parent = new_parent;
  }// CTOR
  
  void display(){
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
    fill( #000000 );
    playerWidth = 4*orig_Width*parent.rotation;
    rect(xPos, yPos, playerWidth, playerHeight);
    
    // Player Color
    fill( parent.teamColor );
    rect(xPos-orig_Width/2, yPos, orig_Width, playerHeight);
  }// display
  
  void displayDebug(){
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
    
    //Display Hitbox
    fill( #FFFFFF );
    if( abs(playerWidth) <= orig_Width/2 ){ // Foosmen straight down
      ellipse( xPos - orig_Width/2, yPos , 5, 5 );
      ellipse( xPos + orig_Width/2, yPos , 5, 5 );
      ellipse( xPos - orig_Width/2, yPos + playerHeight , 5, 5 );
      ellipse( xPos + orig_Width/2, yPos + playerHeight , 5, 5 );
      
      //hitBuffer
      ellipse( xPos - hitBuffer - orig_Width/2, (yPos - hitBuffer), 5, 5 );
      ellipse( xPos + hitBuffer + orig_Width/2, (yPos - hitBuffer), 5, 5 );
      ellipse( xPos - hitBuffer - orig_Width/2, (yPos + hitBuffer) + playerHeight, 5, 5 );
      ellipse( xPos + hitBuffer + orig_Width/2, (yPos + hitBuffer) + playerHeight, 5, 5 );  
    }else if( -1*playerWidth > orig_Width/2 ){ // Foosmen angled to right
      ellipse( xPos + playerWidth/2, yPos , 5, 5 );
      ellipse( xPos + playerWidth, yPos , 5, 5 );
      ellipse( xPos + playerWidth/2, yPos + playerHeight , 5, 5 );
      ellipse( xPos + playerWidth, yPos + playerHeight , 5, 5 );
      
      //hitBuffer
      ellipse( xPos + hitBuffer + playerWidth/2, (yPos - hitBuffer) , 5, 5 );
      ellipse( xPos - hitBuffer + playerWidth, (yPos - hitBuffer) , 5, 5 );
      ellipse( xPos + hitBuffer + playerWidth/2, (yPos + hitBuffer) + playerHeight , 5, 5 );
      ellipse( xPos - hitBuffer + playerWidth, (yPos + hitBuffer) + playerHeight , 5, 5 );
    }else if( playerWidth > orig_Width/2 ){ // Foosmen angled to left
      ellipse( xPos + playerWidth/2, yPos , 5, 5 );
      ellipse( xPos + playerWidth, yPos , 5, 5 );
      ellipse( xPos + playerWidth/2, yPos + playerHeight , 5, 5 );
      ellipse( xPos + playerWidth, yPos + playerHeight , 5, 5 );
      
      //hitBuffer
      ellipse( xPos - hitBuffer + playerWidth/2, (yPos - hitBuffer) , 5, 5 );
      ellipse( xPos + hitBuffer + playerWidth, (yPos - hitBuffer) , 5, 5 );
      ellipse( xPos - hitBuffer + playerWidth/2, (yPos + hitBuffer) + playerHeight , 5, 5 );
      ellipse( xPos + hitBuffer + playerWidth, (yPos + hitBuffer) + playerHeight , 5, 5 );
    }
    
    
  }// displayDebug
  
  boolean collide(Ball[] balls){
    if( abs(parent.rotation) > 0.4 ) // Player is rotated high enough for ball to pass
      return false;
         
    fill( #FF0000, 100 );
    for( int i = 0; i < nBalls; i++ ){
      
      if( playerWidth > orig_Width/2 ){ // Player is rotated to right (feet pointing to right)
        fill(#FFFF00);
        rect( xPos + playerWidth/2, yPos, abs(playerWidth)/2, playerHeight);
      
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth/2 + hitBuffer && balls[i].xPos+balls[i].diameter/2 < xPos + playerWidth + orig_Width/2 + hitBuffer)
          if( balls[i].yPos+balls[i].diameter/2 > yPos - hitBuffer && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight + hitBuffer )
            if(ballsRecentlyHit[i] == 1)
              continue;
     
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth/2 && balls[i].xPos+balls[i].diameter/2 < xPos + playerWidth + orig_Width/2)
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            ballsRecentlyHit[i] = 1;
            balls[i].setColor(color(#FF0000));
            if( balls[i].xVel < 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight ){ // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].xVel > 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight){ // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].yVel > 0 && balls[i].xPos < xPos+playerWidth && balls[i].xPos > xPos+playerWidth/2){ // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].yVel < 0 && balls[i].xPos < xPos+playerWidth && balls[i].xPos > xPos+playerWidth/2){ // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
              continue;
            }
            
        }// if has been hit 
          
      }else if( -1*playerWidth > orig_Width/2 ){ // Player is rotated to left (feet pointing to left)
        fill(#FFFF00);
        rect( xPos + playerWidth/2, yPos, playerWidth/2, playerHeight);
        
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth - hitBuffer && balls[i].xPos+balls[i].diameter/2 < xPos + abs(playerWidth)/2 + hitBuffer)
          if( balls[i].yPos+balls[i].diameter/2 > yPos - hitBuffer && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight + hitBuffer)
            if(ballsRecentlyHit[i] == 1)
              continue;
        
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth && balls[i].xPos+balls[i].diameter/2 < xPos + abs(playerWidth)/2 )
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            ballsRecentlyHit[i] = 1;
            balls[i].setColor(color(#FF0000));
            if( balls[i].xVel < 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight ){ // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].xVel > 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight){ // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].yVel > 0 && balls[i].xPos > xPos+playerWidth && balls[i].xPos < xPos+playerWidth/2){ // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].yVel < 0 && balls[i].xPos > xPos+playerWidth && balls[i].xPos < xPos+playerWidth/2){ // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
              continue;
            }
            
        }// if has been hit 
        
      }else if( abs(playerWidth) <= orig_Width/2 ){ // Player is not rotated (feet straight down)
      
        if( balls[i].xPos+balls[i].diameter/2 > xPos - orig_Width  + hitBuffer && balls[i].xPos+balls[i].diameter/2 < xPos + orig_Width + hitBuffer)
          if( balls[i].yPos+balls[i].diameter/2 > yPos - hitBuffer && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight + hitBuffer)
            if(ballsRecentlyHit[i] == 1)
              continue;

        if( balls[i].xPos+balls[i].diameter/2 > xPos - orig_Width/2 && balls[i].xPos+balls[i].diameter/2 < xPos + orig_Width )
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            ballsRecentlyHit[i] = 1;
            balls[i].setColor(color(#FF0000));
            if( balls[i].xVel < 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight ){ // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].xVel > 0 && balls[i].yPos > yPos && balls[i].yPos < yPos + playerHeight){ // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].yVel > 0 && balls[i].xPos > xPos-orig_Width/2 && balls[i].xPos < xPos+orig_Width/2){ // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
              continue;
            }else if( balls[i].yVel < 0 && balls[i].xPos > xPos-orig_Width/2 && balls[i].xPos < xPos+orig_Width/2){ // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2 , parent.xMove, parent.yMove);
              continue;
            }
            
          }// if has been hit   
      }//if-else
      if(ballsRecentlyHit[i] == 1){
          ballsRecentlyHit[i] = 0;
          balls[i].setColor(color(#FFFFFF));
      }
    }//for
    return false;
  }// collide
  
  boolean setDelay(){
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
