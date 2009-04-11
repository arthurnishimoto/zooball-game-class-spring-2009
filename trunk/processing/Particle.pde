/**---------------------------------------------
 * Particle.pde
 *
 * Description: Simple particle object with various preset colors
 *              Used with the ParticleManager to generate particle effects
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1
 * 
 * Version Notes:
 * 2/6/09    - Initial version
 */
 
class Particle{
  boolean active = true;
  boolean gravity = false;
  float xPos, yPos, xVel, yVel, vel, angle;
  float diameter, originalDiameter;
  double timer;
  int colorFlag;
  int ID_no;
  Particle[] others;
  ParticleManager manager;
  
  double dispersionRate;
  
  // "Bouncy" Variables
  float maxVel;
  float spring;

  Particle(float newX, float newY, float newDiameter, int ID, Particle[] otr, double dispersionVal, ParticleManager newmanager){
    active = false;
    xPos = newX;
    yPos = newY;
    xVel = 0;
    yVel = 0;
    diameter = 0;
    colorFlag = -1;
    originalDiameter = newDiameter;
    ID_no = ID;
    others = otr;
    maxVel = 20;
    spring = 0.05;
    dispersionRate = dispersionVal;
    manager = newmanager;
  }// Particle CTOR
  
  void collide() {
    for (int i = ID_no + 1; i < others.length; i++) {
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
  }// collide

  void move() {
    vel = sqrt(abs(sq(xVel))+abs(sq(yVel)));
    //timer = timer_g + dispersionRate;

    if( diameter > 0 && dispersionRate > 0)
      diameter -= dispersionRate;
       
    if( active && diameter <= 0 )
      active = false;
    
    // Gravity effect
    if( gravity )
      yVel += 1;
      
    if ( xVel > maxVel )
      xVel = maxVel;
    if ( yVel > maxVel )
      yVel = maxVel;
      
    xPos += xVel;
    yPos += yVel;
    
  }// move
  
  void display(){
    if( !active )
      return;
       
    switch(colorFlag){
      case(0): // Reddish, yellow explosion color
        fill( 255, random(155)+100 , 0 , diameter*20);
        break;
      case(1): // Blueish, green, and white
        if( random(3) < 2 )
          fill( 0 , random(155)+100 , random(155)+100 , diameter*20);
        else
          fill( 255 , 255 , 255 , diameter*20);
        break;
      case(2): // Reddish, orange fire color
        fill( 255, random(155)+20 , 0 , diameter*20);
        break;
      case(3): // Black, smokey
        float colorVal = random(diameter);
        fill( colorVal, colorVal , colorVal , 50);
        break;
      default: // White
        fill( 255, 255 , 255 , diameter*20);
        break;
    }
    noStroke();
    ellipse(xPos, yPos, diameter, diameter);

  }// display
}//class Particle
