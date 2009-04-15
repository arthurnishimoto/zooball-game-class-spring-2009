/**
 * ---------------------------------------------
 * Turret.pde
 *
 * Description: Rotating turret which can fire a projectile at a given angle and velocity.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo)
 * Version: 0.1
 *
 * Version Notes:
 * 3/20/09	- Initial version 0.1
 * ---------------------------------------------
 */
 
class Turret{
  float diameter, xPos, yPos;
  float rotateDiameter, rotateButtonPos, xCord, yCord, angle;
  float rotate_xCord, rotate_yCord, rotateButtonDiameter;
  boolean active, pressed, rotatePressed, hasImage, isRound, canRotate, facingUp;
  boolean alwaysShowRotate = false;
  boolean enable = false;
  boolean armed = false;
  boolean shootOnRelease = true;
  
  double buttonDownTime = 1;
  double buttonLastPressed = -1; // Starts active if < 0
  double gameTimer;
  
  color idle_cl = color( 0, 0, 0 );
  color pressed_cl = color( 255, 0, 0 );
  color enabled_cl = color( 0, 255, 0 );
  
  float fireVelocity = 10;
  float recoil = 50;
  float currentRecoil = 0;
  int shotNo = 0;
  
  FoosballDemo parent;
  
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
    pressed = false;
    rotatePressed = false;
    canRotate = false;
  }// disable
  
  void process(double timer_g){
    display();
    displayTurret();
    setGameTimer(timer_g);
  }//process
  
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
      currentRecoil = recoil*(float)((buttonLastPressed + buttonDownTime)-gameTimer);
    }else
      currentRecoil = 0;

  }// display
  
  void displayTurret(){
    pushMatrix();
    fill( 100, 100, 100 );
    noStroke();
    translate(xPos, yPos);
    rotate(radians(angle));
    if(pressed)
      rect(-26 + currentRecoil, -13, -72, 25); // turret barrel
    if( enable )
      fill(enabled_cl);
    else
      fill(color( 100, 100, 100 ));
    rect(-26, -26, 52, 52); // Turret base
    popMatrix();
  }// displayTurret
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,16);

    text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
    text("Rotate: "+canRotate, xPos+diameter, yPos-diameter/2+16);
    text("xCord: "+xCord, xPos+diameter, yPos-diameter/2+16*2);
    text("yCord: "+yCord, xPos+diameter, yPos-diameter/2+16*3);
    text("Angle: "+angle, xPos+diameter, yPos-diameter/2+16*4);
    text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16*5);
    if(buttonLastPressed + buttonDownTime > gameTimer)
      text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-gameTimer), xPos+diameter, yPos-diameter/2+16*6);
    else
      text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*6);
  }// displayDebug
  
  // Checks if central button has been hit
  boolean isHit( float xCoord, float yCoord ){
    if(!active || !enable)
      return false;
    if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
      if (buttonLastPressed == 0){
        buttonLastPressed = gameTimer;
      }else if ( buttonLastPressed + buttonDownTime < gameTimer){
        buttonLastPressed = gameTimer;
        pressed = true;
        armed = true;
        if(!shootOnRelease)
          shoot();
        return true;
      }// if-else-if button pressed

    }// if x, y in area
    else if( armed && rotatePressed && shootOnRelease){
      shoot();
      armed = false;
    }
    pressed = false; 
    return false;
  }// isHit
  
  // Checks if outer rotate area has been hit
  boolean rotateIsHit( float xCoord, float yCoord ){
    if(!active || !enable)
      return false;
      
    if( xCoord > xPos-rotateDiameter/2 && xCoord < xPos+rotateDiameter/2 && yCoord > yPos-rotateDiameter/2 && yCoord < yPos+rotateDiameter/2){
      xCord = xCoord-xPos;
      yCord = yCoord-yPos;
        
      rotatePressed = true;
      rotate_xCord = xCord+xPos;
      rotate_yCord = yCord+yPos;
        
      // Calculates angle based on standard x,y grid (+y is up)
      angle = degrees( atan2(yCord,xCord) );

      canRotate = true;
      return true;
    }// if x, y in area
    
    if( armed && shootOnRelease){
      shoot();
      armed = false;
    }
    
    pressed = false;
    rotatePressed = false;
    canRotate = false;
    return false;
  }// isHit
  
  void shoot(){
    soundManager.playKick();
    
    if( parent.ballQueue == parent.nBalls )
       parent.ballQueue = 0;
    
    currentRecoil = recoil;
    
    float newXVel = fireVelocity*cos(radians(angle+180));
    float newYVel = fireVelocity*sin(radians(angle+180));
    float newXPos = xPos;
    float newYPos;
    
    if( facingUp)
      newYPos = yPos-50;
    else
      newYPos = yPos+50;

    parent.balls[parent.ballQueue].launchBall(newXPos, newYPos, newXVel, newYVel);
    parent.ballsInPlay++;
    parent.ballQueue++;
    disable();
  }// shoot
  
  void setParentClass(FoosballDemo newParent){
    parent = newParent;
  }// setParentClass
  
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
  
  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer
  
  void setShootOnRelease(boolean enable){
    shootOnRelease = enable;
  }// setShootOnRelease
  
  boolean isShootOnRelease(){
    return shootOnRelease;
  }// isShootOnRelease
  
  float getAngle(){
    return angle;
  }// getAngle
}// class Turret
