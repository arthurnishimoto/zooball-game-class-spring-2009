
class MTFoosBar{
  float xPos, yPos, barWidth, barHeight, yMinTouchArea = 0, yMaxTouchArea = height/2;
  color teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  float xMove, yMove, rotation;
  float swipeThreshold = 30.0;
  int nPlayers;
  MTFinger fingerTest;
  FoosPlayer[] foosPlayers;
  int playerWidth = 50;
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
  
  void display(){
    active = true;
    
    if( yPos+playerHeight > screen.height){
      atBottomEdge = true;
    }else
      atBottomEdge = false;
      
    if( yPos < 0){
      atTopEdge = true;
    }else
      atTopEdge = false;
      
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
  }// displayDebug
  
  boolean collide(Ball[] balls){
    if( parent.rotation > 0.4 ) // Player is rotated high enough for ball to pass
      return false;
    for( int i = 0; i < nBalls; i++ ){
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
    }// for
    return false;
  }// collide
}//class
