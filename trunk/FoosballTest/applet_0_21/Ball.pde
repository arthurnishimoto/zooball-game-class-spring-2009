class Ball{
  float friction = 0.001;
  boolean active = true;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel = 10;
  float diameter;
  int ID_no;
  Ball[] others;

  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr){
    xPos = newX;
    yPos = newY;
    xVel = 2;
    yVel = random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  }// Ball CTOR

  void kickBall( float xVeloc, float yVeloc ){
    // Basic implementation
    xVel *= -1;
    yVel *= -1;
    xVel += xVeloc;
    yVel += yVeloc;
  }// kickBall
  
  void isHit( float x, float y ){
    if( getSpeed() > 1 )
      return;
    if( x > xPos-diameter/2 && x < xPos+diameter/2 && y > yPos-diameter/2 && y < yPos+diameter/2 ){
      xVel = random(-maxVel)+random(maxVel);
      yVel = random(-maxVel)+random(maxVel);
    }// if
  }// is Hit
  
  void collide() {
    /*
    for (int i = ID_no + 1; i < numBugs; i++) {
      if( !active || !others[i].active )
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
    */
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
    if ( xPos > width - diameter/2 ){
      xVel *= -1;
      xPos += xVel;
    }else if ( xPos < 0 ){
      xVel *= -1;
      xPos += xVel;
    }
    if ( yPos > height - diameter/2 ){
      yVel *= -1;
      yPos += yVel;
    }else if ( yPos < 0 ){
      yVel *= -1;
      yPos += yVel;
    }
  }// move
  
  void display(){
    if( !active )
      return;
    
    fill(#FFFFFF, 255);
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
