package ise.gameObjects;

import processing.core.*;
/**---------------------------------------------
 * Foosmen.pde
 *
 * Description: Foosbar object containing foosmen
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - FSM implementation
 */
 
public class Foosmen extends PApplet{
  PImage topImage = loadImage("foosman_top_h100.gif");
  float xPos, yPos, playerWidth, playerHeight, orig_Width;
  float hitBuffer = 20;
  boolean active, atTopEdge, atBottomEdge;
  Foosbar parent;
  int ballsRecentlyHit[];
  int nBalls;
    
  //GLOBAL button time
  double buttonDownTime = 0.3f;
  double buttonLastPressed = 0;
  double gameTimer;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  /**
   * 
   * @param x
   * @param y
   * @param newWidth
   * @param newHeight
   * @param numBalls
   * @param new_parent
   */
  Foosmen( float x, float y, int newWidth, int newHeight, int numBalls, Foosbar new_parent){
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
  
  /**
   * 
   */
  public void display(PApplet p){
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
    p.fill( 0xff000000 );
    playerWidth = 4*orig_Width*parent.rotation;
    
    
    
    
    p.rect(xPos, yPos, playerWidth, playerHeight);

    p.image(topImage, xPos-orig_Width/2+17, yPos+playerHeight/2);
    p.imageMode(CENTER);
    
    // Player Color
    p.fill( parent.teamColor, 100 );
    p.rect(xPos-orig_Width/2, yPos, orig_Width, playerHeight);
    

  }// display
  
  /**
   * 
   * @param debugColor
   * @param font
   */
  public void displayDebug(PApplet p, int debugColor, PFont font){
    p.fill(debugColor);
    p.textFont(font,12);

    p.text("Position: "+xPos+", "+yPos, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*0);
    p.text("playerWidth: "+playerWidth, xPos + playerWidth + 16, yPos+playerHeight/2 + 16*1);
    if( atTopEdge )
      p.text("atTopEdge", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*2);
    if( atBottomEdge )
      p.text("atBottomEdge", xPos + playerWidth + 16, yPos+playerHeight/2 + 16*2);
    for( int i = 0; i < nBalls; i++)
    p.text("RecentlyHit["+i+"]: "+ballsRecentlyHit[i], xPos + playerWidth + 16, yPos+playerHeight/2 + 16*(3+i));
    
    //Display Hitbox
    p.fill( 0xffFFFFFF );
    if( abs(playerWidth) <= orig_Width/2 ){ // Foosmen straight down
      p.ellipse( xPos - orig_Width/2, yPos , 5, 5 );
      p.ellipse( xPos + orig_Width/2, yPos , 5, 5 );
      p.ellipse( xPos - orig_Width/2, yPos + playerHeight , 5, 5 );
      p.ellipse( xPos + orig_Width/2, yPos + playerHeight , 5, 5 );
      
      //hitBuffer
      p.ellipse( xPos - hitBuffer - orig_Width/2, (yPos - hitBuffer), 5, 5 );
      p.ellipse( xPos + hitBuffer + orig_Width/2, (yPos - hitBuffer), 5, 5 );
      p.ellipse( xPos - hitBuffer - orig_Width/2, (yPos + hitBuffer) + playerHeight, 5, 5 );
      p.ellipse( xPos + hitBuffer + orig_Width/2, (yPos + hitBuffer) + playerHeight, 5, 5 );  
    }else if( -1*playerWidth > orig_Width/2 ){ // Foosmen angled to right
      p.ellipse( xPos + playerWidth/2, yPos , 5, 5 );
      p.ellipse( xPos + playerWidth, yPos , 5, 5 );
      p.ellipse( xPos + playerWidth/2, yPos + playerHeight , 5, 5 );
      p.ellipse( xPos + playerWidth, yPos + playerHeight , 5, 5 );
      
      //hitBuffer
      p.ellipse( xPos + hitBuffer + playerWidth/2, (yPos - hitBuffer) , 5, 5 );
      p.ellipse( xPos - hitBuffer + playerWidth, (yPos - hitBuffer) , 5, 5 );
      p.ellipse( xPos + hitBuffer + playerWidth/2, (yPos + hitBuffer) + playerHeight , 5, 5 );
      p.ellipse( xPos - hitBuffer + playerWidth, (yPos + hitBuffer) + playerHeight , 5, 5 );
    }else if( playerWidth > orig_Width/2 ){ // Foosmen angled to left
      p.ellipse( xPos + playerWidth/2, yPos , 5, 5 );
      p.ellipse( xPos + playerWidth, yPos , 5, 5 );
      p.ellipse( xPos + playerWidth/2, yPos + playerHeight , 5, 5 );
      p.ellipse( xPos + playerWidth, yPos + playerHeight , 5, 5 );
      
      //hitBuffer
      p.ellipse( xPos - hitBuffer + playerWidth/2, (yPos - hitBuffer) , 5, 5 );
      p.ellipse( xPos + hitBuffer + playerWidth, (yPos - hitBuffer) , 5, 5 );
      p.ellipse( xPos - hitBuffer + playerWidth/2, (yPos + hitBuffer) + playerHeight , 5, 5 );
      p.ellipse( xPos + hitBuffer + playerWidth, (yPos + hitBuffer) + playerHeight , 5, 5 );
    }
    
    
  }// displayDebug
  
  /**
   * 
   * @param balls
   * @return
   */
  public boolean collide(PApplet p, Ball[] balls){
    if( abs(parent.rotation) > 0.4f ) // Player is rotated high enough for ball to pass
      return false;
         
    p.fill( 0xffFF0000, 100 );
    for( int i = 0; i < nBalls; i++ ){
      
      if( playerWidth > orig_Width/2 ){ // Player is rotated to right (feet pointing to right)
        p.fill(0xffFFFF00);
        p.rect( xPos + playerWidth/2, yPos, abs(playerWidth)/2, playerHeight);
      
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth/2 + hitBuffer && balls[i].xPos+balls[i].diameter/2 < xPos + playerWidth + orig_Width/2 + hitBuffer)
          if( balls[i].yPos+balls[i].diameter/2 > yPos - hitBuffer && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight + hitBuffer )
            if(ballsRecentlyHit[i] == 1)
              continue;
     
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth/2 && balls[i].xPos+balls[i].diameter/2 < xPos + playerWidth + orig_Width/2)
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            ballsRecentlyHit[i] = 1;
            balls[i].setColor(color(0xffFF0000));
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
        p.fill(0xffFFFF00);
        p.rect( xPos + playerWidth/2, yPos, playerWidth/2, playerHeight);
        
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth - hitBuffer && balls[i].xPos+balls[i].diameter/2 < xPos + abs(playerWidth)/2 + hitBuffer)
          if( balls[i].yPos+balls[i].diameter/2 > yPos - hitBuffer && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight + hitBuffer)
            if(ballsRecentlyHit[i] == 1)
              continue;
        
        if( balls[i].xPos+balls[i].diameter/2 > xPos + playerWidth && balls[i].xPos+balls[i].diameter/2 < xPos + abs(playerWidth)/2 )
          if( balls[i].yPos+balls[i].diameter/2 > yPos && balls[i].yPos-balls[i].diameter/2 < yPos + playerHeight ){
            ballsRecentlyHit[i] = 1;
            balls[i].setColor(color(0xffFF0000));
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
            balls[i].setColor(color(0xffFF0000));
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
          balls[i].setColor(color(0xffFFFFFF));
      }
    }//for
    return false;
  }// collide
  
  /**
   * 
   * @param timer_g
   */
  public void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer
  
  /**
   * 
   * @return
   */
  public boolean setDelay(){
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