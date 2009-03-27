package ise.gameObjects;
import ise.game.*;
import processing.core.*;

/**---------------------------------------------
 * Ball.java
 *
 * Description: Ball object.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3a
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/18/09   - Version 0.2 - Initial FSM conversion
 * 3/25/09   - Version 0.3 - Encapsulation fixes for code clarity and easier Java conversion
 */

public class Ball extends PApplet{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  float friction = 0.001f;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel = 10;
  float diameter;
  int ID_no;
  Ball[] others;
  int ballColor = color(0xffFFFFFF);
  
	// @TODO Fix variables here - quick fix only
  int screenWidth, screenHeight, borderWidth, borderHeight;
  int nBalls;
  double timer_g;
  
  public Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr, int[] screenDim){
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    state = INACTIVE; // Initial state
    xPos = screenWidth/2; //newX;
    yPos = screenHeight/2; //newY;
    xVel = random(5) + -1*random(5);
    yVel = random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  }// Ball CTOR
  
  /* Performs actions of the Ball class based on current state
   */
  public void process(PApplet p){
    if(state == ACTIVE){
      display(p);
      move();
    }else if(state == INACTIVE){
      // inactive state
    }// state if-else
  }// process
  
  public boolean isActive(){
    if(state == ACTIVE)
      return true;
    else
      return false;  
  }// isActive
  
  /* Changes the direction and velocity of the ball.
   * Used for ball/wall or ball/foosmen collision
   */
  public void kickBall( int hitDirection, float xVeloc, float yVeloc ){
    if(state == INACTIVE)
      return;
      
    // Basic implementation
    if( hitDirection == 1 || hitDirection == 3) // Reverse x
      xVel *= -1;
    if( hitDirection == 2 || hitDirection == 3) // Reverse y
      yVel *= -1;
    xVel += xVeloc;
    yVel += yVeloc;
  }// kickBall
  
  /* Ball was launched with a specific location using a specific velocity.
   * @param x : initial x position
   * @param y : initial y position
   * @param xVeloc : initial x velocity
   * @param yVeloc : initial y velocity
   */
  public void launchBall(float x, float y, float xVeloc, float yVeloc){
    xPos = x;
    yPos = y;
    xVel = xVeloc;
    yVel = yVeloc;
    setActive();
  }//launchBall 
  
  /* Checks if ball was hit from an input device
   * @param x : input x coordinate
   * @param y : input y coordinate
   */
  public void isHit( float x, float y ){
    if(state == INACTIVE)
      return;
    
    if( getSpeed() > 1 )
      return;
    if( x > xPos-diameter/2 && x < xPos+diameter/2 && y > yPos-diameter/2 && y < yPos+diameter/2 ){
      float newVel =  random(-10, 11);
      while( newVel < 4 && newVel > -4 )
        newVel =  random(-10, 11);
      xVel = newVel;
      
      newVel =  random(-10, 11);
      while( newVel < 4 && newVel > -4 )
        newVel =  random(-10, 11);
      yVel = newVel;
    }// if
  }// is Hit
  
  /* @TODO Ti be used for ball/ball collision
   */
  public void collide() {
    if(state == INACTIVE)
      return;
  }// collide
  
  /* Moves the position of the ball based on its velocity
   */
  public void move() {
    vel = sqrt(abs(sq(xVel))+abs(sq(yVel)));
        
    if ( xVel > maxVel )
      xVel = maxVel;
    if ( yVel > maxVel )
      yVel = maxVel;
      
    xPos += xVel;
    yPos += yVel;
    
    if( xVel > 0 )
      xVel -= friction;
    else if( xVel < 0 )
      xVel += friction;
    if( yVel > 0 )
      yVel -= friction;
    else if( yVel < 0 )
      yVel += friction;
    
    // Checks if object reaches edge of screen, bounce
    if ( xPos+diameter/4 > screenWidth-borderWidth){
      xVel *= -1;
      xPos += xVel;
    }else if ( xPos-diameter/4 < borderWidth){
      xVel *= -1;
      xPos += xVel;
    }
    if ( yPos+diameter/4 > screenHeight-borderHeight){
      yVel *= -1;
      yPos += yVel;
    }else if ( yPos-diameter/4 < borderHeight ){
      yVel *= -1;
      yPos += yVel;
    }
  }// move
  
  public void display(PApplet p){
    p.fill(ballColor, 255);
    p.ellipse(xPos, yPos, diameter, diameter);
  }// display
  
  public void displayDebug(PApplet p, Game g){
     //p.fill(g.getDebugColor());
     //p.textFont(g.getDebugFont());
     p.text("ID: " + ID_no, xPos+diameter, yPos-diameter/2 );
  }// displayDebug
  
  // Getters/Setters
  
  /* Returns the speed of the ball
   * @return float - speed of the ball
   */
  public float getSpeed(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getSpeed
  
  public void setActive(){
    state = ACTIVE;
  }// setActive
  
  public void setInactive(){
    state = INACTIVE;
  }// setActive
  
  public void setMaxVel(float newMax){
    maxVel = newMax;
  }//setMaxVel
  
  public void setColor(int newColor){
    ballColor = newColor;
  }// setColor
}//class Ball
