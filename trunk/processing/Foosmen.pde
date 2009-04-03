/**
 * ---------------------------------------------
 * Foosman.pde
 *
 * Description: Foosbar object containing foosmen
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - FSM implementation
 * ---------------------------------------------
 */
 
class Foosman{
  PImage topImage = loadImage("data/foosmen_red/red_top_0.png");
  PImage frontImage = loadImage("data/foosmen_red/red_front_0.png");
  PImage backImage = loadImage("data/foosmen_red/red_top_270.png");
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  float hitBuffer = 20;
  boolean active, atTopEdge, atBottomEdge;
  Foosbar parent;
  int ballsRecentlyHit[];
  int nBalls;
    
  //GLOBAL button time
  double buttonDownTime = 0.3;
  double buttonLastPressed = 0;
  double gameTimer;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  Foosman( float x, float y, int newWidth, int newHeight, int numBalls, Foosbar new_parent){
    xPos = x;
    yPos = y;
    playerWidth = newWidth;
    orig_Width = newWidth;
    playerHeight = newHeight;
    parent = new_parent;
    ballsRecentlyHit = new int[numBalls];
    nBalls = numBalls;
    
    // Sets the screen size and border size - Used for edge collision
    screenWidth = parent.screenWidth;
    screenHeight = parent.screenHeight;
    borderWidth = parent.borderWidth;
    borderHeight = parent.borderHeight;
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
    
    // Player Width
    playerWidth = 4*orig_Width*parent.rotation;
    fill( #000000 );
    rect(xPos, yPos, playerWidth, playerHeight);

    // Images
    pushMatrix();
    imageMode(CENTER);
    translate(xPos, yPos + playerHeight/2);
    rotate(radians(90));
    
    imageMode(CENTER);
    if(parent.rotation == 0)
      image(topImage, 0, 0);
    else if( parent.rotation < -0.13 )
      image(frontImage, 0, 0);
    else if( parent.rotation > 0.13 )
      image(backImage, 0, 0);
    else
      image(topImage, 0, 0);
    popMatrix();
    // Team Color
    fill( parent.teamColor, 100 );
    rect(xPos-orig_Width/2, yPos, orig_Width, playerHeight);
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
}//class Foosman
