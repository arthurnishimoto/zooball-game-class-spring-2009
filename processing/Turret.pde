
class Turret{
  float diameter, xPos, yPos;
  float rotateDiameter, rotateButtonPos, xCord, yCord, angle;
  float rotate_xCord, rotate_yCord, rotateButtonDiameter;
  boolean active, pressed, rotatePressed, hasImage, isRound, canRotate, facingUp;
  boolean alwaysShowRotate = false;
  boolean enable = false;
  
  double buttonDownTime = 1;
  double buttonLastPressed = -1; // Starts active if < 0
  
  color idle_cl = color( 0, 0, 0 );
  color pressed_cl = color( 255, 0, 0 );
  color enabled_cl = color( 0, 255, 0 );
  
  float fireVelocity = 10;
  float recoil = 50;
  float currentRecoil = 0;
  int shotNo = 0;
  
  Turret( float newDia , int new_xPos, int new_yPos, float rotateDia, float rotateButtonDia){
    diameter = newDia;
    xPos = new_xPos;
    yPos = new_yPos;
    rotateDiameter = rotateDia;
    rotateButtonDiameter = rotateButtonDia;
    
    // Initial Rotate Button Location
    rotate_xCord = xPos;
    rotate_yCord = yPos+rotateDia/2; 
    angle = 90;
  
    hasImage = false;
    isRound = true;
    alwaysShowRotate = false;
  }// Button CTOR
  
  void faceUp(){
    facingUp = true;
    angle = 90;
    rotate_xCord = xPos;
    rotate_yCord = yPos+rotateDiameter/2; 
  }// faceUp

  void faceDown(){
    facingUp = false;
    angle = -90;
    rotate_xCord = xPos;
    rotate_yCord = yPos-rotateDiameter/2; 
  }// faceDown
  
  void enable(){
    enable = true;
  }// enable
  void disable(){
    enable = false;
  }// disable
  
  void display(){
    active = true;

    if( rotatePressed || alwaysShowRotate ){
      // Rotate area
      fill( 0, 0, 255, 100);
      noStroke();
      ellipse( xPos, yPos, rotateDiameter, rotateDiameter);
      
      // Rotating button
      fill( 0, 255, 0 );
      noStroke();
      ellipse( rotate_xCord, rotate_yCord, rotateButtonDiameter, rotateButtonDiameter);
    }
    

    
    // Center Button
    if(pressed){
      fill(pressed_cl);
      stroke(pressed_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }else{
      fill(idle_cl);
      stroke(idle_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }
    
    if( currentRecoil > 0 ){
      currentRecoil = recoil*(float)((buttonLastPressed + buttonDownTime)-timer_g);
    }else
      currentRecoil = 0;

  }// display
  
  void displayTurret(){
    pushMatrix();
    fill( 100, 100, 100 );
    noStroke();
    translate(xPos, yPos);
    rotate(radians(angle));
    //rect(-26 + currentRecoil, -13, -72, 25); // turret barrel
    if( enable )
      fill(enabled_cl);
    else
      fill(color( 100, 100, 100 ));
    rect(-26, -26, 52, 52); // Turret base
    popMatrix();
  }// displayTurret
  
  void displayDebug(){
    fill(debugColor);
    textFont(font,16);

    text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
    text("Rotate: "+canRotate, xPos+diameter, yPos-diameter/2+16);
    text("xCord: "+xCord, xPos+diameter, yPos-diameter/2+16*2);
    text("yCord: "+yCord, xPos+diameter, yPos-diameter/2+16*3);
    text("Angle: "+angle, xPos+diameter, yPos-diameter/2+16*4);
    text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16*5);
    if(buttonLastPressed + buttonDownTime > timer_g)
      text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-timer_g), xPos+diameter, yPos-diameter/2+16*6);
    else
      text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*6);
  }// displayDebug
  
  boolean isHit( float xCoord, float yCoord ){
    if(!active || !enable)
      return false;
    if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
      if (buttonLastPressed == 0){
        buttonLastPressed = timer_g;
      }else if ( buttonLastPressed + buttonDownTime < timer_g){
        buttonLastPressed = timer_g;
        pressed = true;
        shoot();
        return true;
      }// if-else-if button pressed
    }// if x, y in area
    //pressed = false;
    return false;
  }// isHit
  
  boolean rotateIsHit( float xCoord, float yCoord ){
    if(!active || !enable)
      return false;
      
    if( xCoord > xPos-rotateDiameter/2 && xCoord < xPos+rotateDiameter/2 && yCoord > yPos-rotateDiameter/2 && yCoord < yPos+rotateDiameter/2){
      //if (buttonLastPressed == 0){
      //  buttonLastPressed = timer_g;
      //}else if ( buttonLastPressed + buttonDownTime < timer_g){
        xCord = xCoord-xPos;
        yCord = yCoord-yPos;
        
        rotatePressed = true;
        if( xCoord > rotate_xCord-rotateButtonDiameter/2 && xCoord < rotate_xCord+rotateButtonDiameter/2 && yCoord > rotate_yCord-rotateButtonDiameter/2 && yCoord < rotate_yCord+rotateButtonDiameter/2){
          rotate_xCord = xCord+xPos;
          rotate_yCord = yCord+yPos;
        
          // Calculates angle based on standard x,y grid (+y is up)
          angle = degrees( atan2(yCord,xCord) );

          //buttonLastPressed = timer_g;
          canRotate = true;
          return true;
        }// if touch in rotate button
      //}// if-else-if button pressed
    }// if x, y in area
  
    return false;
  }// isHit
  
  void shoot(){
    if( ballQueue == nBalls )
       ballQueue = 0;
    
    currentRecoil = recoil;
    balls[ballQueue].xPos = xPos;
    
    if( facingUp)
      balls[ballQueue].yPos = yPos-50;
    else
      balls[ballQueue].yPos = yPos+50;
    balls[ballQueue].xVel = fireVelocity*cos(radians(angle+180));
    balls[ballQueue].yVel = fireVelocity*sin(radians(angle+180));
    balls[ballQueue].setActive();
    ballsInPlay++;
    ballQueue++;
    disable();
  }// shoot
  
  void resetButton(){
    pressed = false;
    rotatePressed = false;
    canRotate = false;
  }// resetButton;
  
  boolean setAngle(float newAngle){
    if( angle >= 0 && angle <= 360 )
      angle = newAngle;
    else
      return false;
    return true;  
  }// setAngle
  
  float getAngle(){
    return angle;
  }// getAngle
}// class
