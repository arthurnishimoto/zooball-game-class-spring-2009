/**
 * --------------------------------------------- 
 * Ball.pde
 * 
 * Description: Ball object.
 * 
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/18/09   - Version 0.2 - Initial FSM conversion
 * 3/25/09   - Version 0.3 - Encapsulation fixes for code clarity and easier Java conversion
 * 3/28/09   - displayDebug now takes in a color and font as parameters.
 * 4/1/09    - Ball image support added. Ball image rotates based on ball vector
 *           - Bouncing ball issue at very low velocities fixed.
 * 4/9/09    - Ball rolling animations implemented
 * --------------------------------------------- 
 */
class Ball{
  // Rotate animation images
  String filepath = "data/ball/";
  String filename = "ball_";
  String extention = ".png";
  PImage rotateImages[] = new PImage[360];
  int rotateInc = 15;
  
  int rotation = 0;
  
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  float friction = 0.001;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel = 20;
  float diameter;
  int ID_no;
  Ball[] others;
  color ballColor = color(#FFFFFF);
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  double gameTimer;
  
  /**
   * Creates a new Ball object.
   *
   * @param newX - initial x position
   * @param newY - initial y position
   * @param newDiameter - initial diameter
   * @param ID - unique Ball ID
   * @param otr - Array of all other Ball objects for collision purposes
   * @param screenDim - Screen and border parameters for edge collision
   */
  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr, int[] screenDim){
    if( displayArt ){
    // Loads all rotation images
    for(int i = 0; i < 360; i += rotateInc)
      rotateImages[i] = loadImage(filepath + filename + i + extention);
    }
    
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    
    state = INACTIVE; // Initial state
    xPos = newX;
    yPos = newY;
    xVel = random(5) + -1*random(5);
    yVel = random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  }// Ball CTOR
  
  /**
   * Performs actions of the Ball class based on its current state
   *
   * @param p - PApplet used for Processing graphics/text
   * @param timer_g - double used as the game timer
   */
  void process(double timer_g){
    if(state == ACTIVE){
      display();
      collide(balls);
      setGameTimer(timer_g);
      move();
    }else if(state == INACTIVE){
      // inactive state
    }// state if-else
  }// process
  
  /**
   * Sets the ball to its active state.
   */
  boolean isActive(){
    if(state == ACTIVE)
      return true;
    else
      return false;  
  }// isActive
  
  /**
   * Changes the direction and velocity of the ball.
   * Used for ball/wall or ball/foosmen collision
   *
   * @param hitDirection - 1: reverses x velocity, 2: reverses y velocity, 3: reverse both x and y
   * @param xVeloc - x velocity added
   * @param yVeloc - y velocity added
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
  
  /** 
   * Ball was launched with a specific location using a specific velocity.
   *
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
  
  /** 
   * Stops ball
   */
  void stopBall(){
    xVel = 0;
    yVel = 0;
  }//stopBall   
  
  /**
   * Checks if ball was hit from an input device
   *
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
      soundManager.playKick();
    }// if
  }// is Hit
  
  /**
   * TODO: To be used for ball/ball collision
   */
  void collide(Ball[] others) {
    float spring = 0.05;
    
    if(state == INACTIVE)
      return;
      
    for (int i = 0; i < nBalls; i++) {
      if( others[i].state == INACTIVE )
        continue;
      float dx = others[i].xPos - xPos;
      float dy = others[i].yPos - yPos;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = xPos + cos(angle) * minDist;
        float targetY = yPos + sin(angle) * minDist;
        float ax = (targetX - others[i].xPos) * spring;
        float ay = (targetY - others[i].yPos) * spring;
        xVel -= ax;
        yVel -= ay;
        others[i].xVel += ax;
        others[i].yVel += ay;
      }// if distance < minDist
    }// for others[i]
  }// collide
  
  /**
   * Moves the position of the ball based on its velocity
   */
  void move() {
    vel = sqrt(abs(sq(xVel))+abs(sq(yVel)));
    
    rotation += (int)vel;
    if(rotation >= 360 )
      rotation = 0;
      
    // Prevents bouncing ball when velocity is almost 0
    // Also stops ball before "sliding" occurs due to animation frames
    if( vel < 1 && vel > -1 ){
      xVel = 0;
      yVel = 0;
    }
    
    // Restricts maximum speed
    if( xVel > maxVel )
      xVel = maxVel;
    if( yVel > maxVel )
      yVel = maxVel;
    if( -1*xVel > maxVel )
      xVel = -1*maxVel;
    if( -1*yVel > maxVel )
      yVel = -1*maxVel;
      
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
        
    // Checks if object reaches edge of border/screen, bounce
    if ( xPos+diameter/4 > screenWidth-borderWidth){
      xVel *= -1;
      soundManager.playBounce();
    }else if ( xPos-diameter/4 < borderWidth){
      xVel *= -1;
      soundManager.playBounce();
    }
    if ( yPos+diameter/4 > screenHeight-borderHeight){
      yVel *= -1;
      soundManager.playBounce();
    }else if ( yPos-diameter/4 < borderHeight ){
      yVel *= -1;
      soundManager.playBounce();
    }
    
  }// move
  
  /**
   * Displays Ball
   *
   * @param p DOCUMENT ME!
   */
  void display(){
    fill(ballColor, 255);
    ellipse(xPos, yPos, diameter, diameter);
    imageMode(CENTER);

    if( displayArt ){
    pushMatrix();
    
    translate(xPos, yPos);
    rotate(atan2(yVel,xVel)+radians(270));
    
    if( rotation >= 360 - rotateInc && rotation < 0 + rotateInc )
      image(rotateImages[0], 0, 0);
    else{
      for( int i = 0;  i < 360; i += rotateInc ){
        if( rotation >= i - rotateInc && rotation < i + rotateInc ){
          image(rotateImages[i], 0, 0);
          break;
        }
      }// for
    }// else
    
    popMatrix();
  }
  }// display
  
  /**
   * Displays debug information
   *
   * @param 
   * @param
   */
  void displayDebug(color debugColor, PFont font){
     fill(debugColor);
     textFont(font,16);
     text("ID: " + ID_no, xPos+diameter, yPos-diameter/2 );
     
     fill(255,255,255);
     stroke(0,255,0);
     ellipse(xPos, yPos - diameter/2, 5, 5); // Top hitbox
     ellipse(xPos - diameter/2, yPos, 5, 5); // Left hitbox
     ellipse(xPos + diameter/2, yPos, 5, 5); // Right hitbox
     ellipse(xPos, yPos + diameter/2, 5, 5); // Bottom hitbox
  }// displayDebug
  
  // Getters/Setters
  
  float getSpeed(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getSpeed
  
  float getAngle(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getAngle  
  
  void setActive(){
    state = ACTIVE;
  }// setActive

  void setInactive(){
    state = INACTIVE;
  }// setInactive
    
  void setMaxVel(float newMax){
    maxVel = newMax;
  }//setMaxVel
  
  void setColor(color newColor){
    ballColor = newColor;
  }// setColor

  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer

  void setFriction( float newFriction){
    friction = newFriction;
  }// setFriction
}//class Ball
