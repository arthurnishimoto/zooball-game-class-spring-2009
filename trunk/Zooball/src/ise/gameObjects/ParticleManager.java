package ise.gameObjects;

import processing.core.*;
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
 
class Particle extends PApplet{
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
 
  /**
   * 
   * @param newX
   * @param newY
   * @param newDiameter
   * @param ID
   * @param otr
   * @param dispersionVal
   * @param newmanager
   */
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
    spring = 0.05f;
    dispersionRate = dispersionVal;
    manager = newmanager;
  }// Particle CTOR
  
  /**
   * 
   */
  public void collide() {
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

  /**
   * 
   */
  public void move() {
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
  
  /**
   * 
   */
  public void display(PApplet p){
    if( !active )
      return;
       
    switch(colorFlag){
      case(0): // Reddish, yellow explosion color
        p.fill( 255, random(155)+100 , 0 , diameter*20);
        break;
      case(1): // Blueish, green, and white
        if( random(3) < 2 )
          p.fill( 0 , random(155)+100 , random(155)+100 , diameter*20);
        else
          p.fill( 255 , 255 , 255 , diameter*20);
        break;
      case(2): // Reddish, orange fire color
        fill( 255, random(155)+20 , 0 , diameter*20);
        break;
      case(3): // Black, smokey
        float colorVal = random(diameter);
        p.fill( colorVal, colorVal , colorVal , 50);
        break;
      default: // White
        p.fill( 255, 255 , 255 , diameter*20);
        break;
    }
    p.noStroke();
    p.ellipse(xPos, yPos, diameter, diameter);

  }// display
}//class Particle

/**---------------------------------------------
 * ParticleManager.pde
 *
 * Description: Particle Manager.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo)
 * Version: 0.2
 *
 * Version Notes:
 * 2/6/09	- Initial version 0.1
 * 		- Particle Manager designed for assignment 1.
 * 2/27/09      - Version 0.2: ParticleManager is now completely program independent.
 *              - Programed for original "explode" effect as well as a fire effect.
 * To-Do Notes:
 * 	- Delegate more commands to ParticleManager from Particle: color
 * ---------------------------------------------
 */
 
public class ParticleManager extends PApplet{
  //Manager Data
  int particleBuffer = 1000; // Prevents array out of bounds on particles
  int nActive;
  
  //Particle Data
  float maxVel = 20;
  float spring = 0.05f;
  int particlesInUse = 0;
  int initParticleSize = 10;
  int particleDensity;
  double dispersionRate = 1; // larger = shorter, smaller = longer
  Particle[] particles;
  
  PApplet p;
  
  /**
   * 
   * @param density
   * @param dispersion
   */
  public ParticleManager( int density, double dispersion, PApplet newP){
    particleDensity = density;
    dispersionRate = dispersion;
    particles = new Particle[particleDensity+particleBuffer];
    p = newP;
    
    //Generates particles
    for (int i = 0; i < particleDensity; i++) {
      particles[i] = new Particle(random(width), random(height), initParticleSize, i, particles, dispersionRate, this);
    }//for particleDensity
  
  }
  
  /**
   * 
   */
  public void display(){
    nActive = 0;
    for (int i = 0; i < particleDensity; i++) {
      if(particles[i].active)
        nActive++;
      particles[i].move();
      particles[i].display(p);
    }// for

    if( nActive == 0 )
      particlesInUse = 0;
  }// moveParticles
  
  /**
   * 
   * @param debugColor
   * @param font
   */
  public void displayDebug(PApplet p, int debugColor, PFont font){
    p.fill(debugColor);
    p.textFont(font,16);
    p.text("Particles: "+particlesInUse+" out of "+particleDensity, width-300 , 16 );
    p.text("Active Particles: "+nActive, width-300 , 16*2 );
  }// moveParticles
  
  /**
   * Creates an explosion of particles at the given xPos, yPos
   * @param effectDensity - # of particles used
   * @param newDia - Initial particle diameter (uses original size if newDia < 0)
   * @param xPos - initial x position
   * @param yPos - initial y position
   * @param xVel - initial x velocity
   * @param yVel - initial y velocity
   * @param colorFlag - see ParitcleManager::setColor(int);
   */
  public void explodeParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
      particles[i].gravity = false;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(10)-random(10);
      particles[i].yVel = yVel + random(10)-random(10);
     }// for
     particlesInUse += effectDensity;
  }//explodeparticles
  
  /**
   * Creates a rising cone of particles
   * @param effectDensity - # of particles used
   * @param newDia - Initial particle diameter (uses original size if newDia < 0)
   * @param xPos - initial x position
   * @param yPos - initial y position
   * @param xVel - initial x velocity
   * @param yVel - initial y velocity
   * @param colorFlag - see ParitcleManager::setColor(int);
   */
  public void fireParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
      particles[i].gravity = false;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(5)-random(5);
      particles[i].yVel = yVel - random(10);
     }// for
     particlesInUse += effectDensity;
  }//fireparticles

  /**
   * Creates an arching stream of particles
   * @param effectDensity - # of particles used
   * @param newDia - Initial particle diameter (uses original size if newDia < 0)
   * @param xPos - initial x position
   * @param yPos - initial y position
   * @param xVel - initial x velocity
   * @param yVel - initial y velocity
   * @param colorFlag - see ParitcleManager::setColor(int);
   */
  public void waterCannonParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
 
      particles[i].dispersionRate = 0.5f;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(5)-random(5);
      particles[i].yVel = yVel;
      
      particles[i].gravity = true;
     }// for
     particlesInUse += effectDensity;
  }// waterCannonParticles
  
  /**
   * Generates a steady stream of particles
   * @param effectDensity - # of particles used
   * @param newDia - Initial particle diameter (uses original size if newDia < 0)
   * @param xPos - initial x position
   * @param yPos - initial y position
   * @param xVel - initial x velocity
   * @param yVel - initial y velocity
   * @param colorFlag - see ParitcleManager::setColor(int);
   */
  public void trailParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
      particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
 
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel;
      particles[i].yVel = yVel;
      
      particles[i].gravity = false;
     }// for
     particlesInUse += effectDensity;
  }// waterCannonParticles
  
}// class ParticleManager