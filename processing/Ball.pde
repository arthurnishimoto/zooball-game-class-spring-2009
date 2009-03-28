/**---------------------------------------------
 * Ball.pde
 *
 * Description: Ball object.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/18/09   - Version 0.2 - Initial FSM conversion
 * 3/25/09   - Version 0.3 - Encapsulation fixes for code clarity and easier Java conversion
 * 3/28/09   - displayDebug now takes in a color and font as parameters.
 */

class Ball{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  float friction = 0.001;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel = 10;
  float diameter;
  int ID_no;
  Ball[] others;
  color ballColor = color(#FFFFFF);
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr, int[] screenDim){
    // Sets the screen size and border size - Used for edge collision
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
  void process(){
    if(state == ACTIVE){
      display();
      //displayDebug();
      move();
    }else if(state == INACTIVE){
      // inactive state
    }// state if-else
  }// process
  
  boolean isActive(){
    if(state == ACTIVE)
      return true;
    else
      return false;  
  }// isActive
  
  /* Changes the direction and velocity of the ball.
   * Used for ball/wall or ball/foosmen collision
   */
  void kickBall( int hitDirection, float xVeloc, float yVeloc ){
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
  void launchBall(float x, float y, float xVeloc, float yVeloc){
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
  void isHit( float x, float y ){
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
  
  /* @TODO To be used for ball/ball collision
   */
  void collide() {
    if(state == INACTIVE)
      return;
  }// collide
  
  /* Moves the position of the ball based on its velocity
   */
  void move() {
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
  
  void display(){
    fill(ballColor, 255);
    ellipse(xPos, yPos, diameter, diameter);
  }// display
  
  void displayDebug(color debugColor, PFont font){
     fill(debugColor);
     textFont(font,16);
     text("ID: " + ID_no, xPos+diameter, yPos-diameter/2 );
  }// displayDebug
  
  // Getters/Setters
  
  /* Returns the speed of the ball
   * @return float - speed of the ball
   */
  float getSpeed(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getSpeed
  
  void setActive(){
    state = ACTIVE;
  }// setActive
  
  void setInactive(){
    state = INACTIVE;
  }// setActive
  
  void setMaxVel(float newMax){
    maxVel = newMax;
  }//setMaxVel
  
  void setColor(color newColor){
    ballColor = newColor;
  }// setColor
}//class Ball
