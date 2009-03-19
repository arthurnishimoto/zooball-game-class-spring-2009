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
 
  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr){
    state = INACTIVE; // Initial state
    xPos = newX;
    yPos = newY;
    xVel = 10;
    yVel = 10;//random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  }// Ball CTOR

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
  
  void setActive(){
    state = ACTIVE;
  }// setActive
  
  void setColor(color newColor){
    ballColor = newColor;
  }// setColor
  
  void kickBall( int hitDirection, float xVeloc, float yVeloc ){
    if(state == INACTIVE)
      return;
      
    // Basic implementation
    if( hitDirection == 1 || hitDirection == 3)
      xVel *= -1;
    if( hitDirection == 2 || hitDirection == 3)
      yVel *= -1;
    xVel += xVeloc;
    yVel += yVeloc;
  }// kickBall
  
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
  
  void collide() {
    if(state == INACTIVE)
      return;
  }// collide
  
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
  
  void displayDebug(){
     fill(debugColor);
     textFont(font,16);
     text("ID: " + ID_no, xPos+diameter, yPos-diameter/2 );
     //text("Speed: " + getSpeed(), xPos+diameter, yPos-diameter/2 + 16);
  }// displayDebug
  
  float getSpeed(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getSpeed
}//class Ball
