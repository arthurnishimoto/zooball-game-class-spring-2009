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
 * ---------------------------------------------
 */
 
class ParticleManager{
  //Manager Data
  int particleBuffer = 1000; // Prevents array out of bounds on particles
  int nActive;
  
  //Particle Data
  float maxVel = 20;
  float spring = 0.05;
  int particlesInUse = 0;
  int initParticleSize = 10;
  int particleDensity;
  double dispersionRate = 1; // larger = shorter, smaller = longer
  Particle[] particles;
  
  ParticleManager( int density, double dispersion){
    particleDensity = density;
    dispersionRate = dispersion;
    particles = new Particle[particleDensity+particleBuffer];
    
    //Generates particles
    for (int i = 0; i < particleDensity; i++) {
      particles[i] = new Particle(random(width), random(height), initParticleSize, i, particles, dispersionRate, this);
    }//for particleDensity
  
  }
  
  void display(){
    nActive = 0;
    for (int i = 0; i < particleDensity; i++) {
      if(particles[i].active)
        nActive++;
      particles[i].move();
      particles[i].display();
    }// for

    if( nActive == 0 )
      particlesInUse = 0;
  }// moveParticles
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,16);
    text("Particles: "+particlesInUse+" out of "+particleDensity, width-300 , 16 );
    text("Active Particles: "+nActive, width-300 , 16*2 );
  }// moveParticles
  
  // Particle effects follow the following convention:
  // effectDensity: # of particles used
  // newDia: Initial particle diameter (uses original size if newDia < 0)
  // Initial xPos, yPos, xVel, yVel
  // Color flag: see ParitcleManager::setColor(int);
  // dispersion: particle dispersion (fade) rate - higher # = faster, smaller # = slower
  void explodeParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
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
  
  void fireParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag, float dispRate){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].dispersionRate = dispRate;
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

  void smokeParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag, float dispRate){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].dispersionRate = dispRate;
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
  
  void waterCannonParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
    int particlesAdded = 0;
    if( particlesInUse >= particleDensity-particleBuffer )
       particlesInUse = 0;
    for (int i = particlesInUse; i < particlesInUse+effectDensity; i++) {
      if( particlesInUse >= particleDensity || particlesInUse < 0)
        break;
      particles[i].active = true;
 
      particles[i].dispersionRate = 0.5;
      particles[i].colorFlag = colorFlag;
      particles[i].diameter = particles[i].originalDiameter;
      if( newDia >= 0 )
        particles[i].diameter = newDia;
      particles[i].xPos = xPos;
      particles[i].yPos = yPos;
      particles[i].xVel = xVel + random(1)-random(1);
      particles[i].yVel = yVel;
      
      particles[i].gravity = true;
     }// for
     particlesInUse += effectDensity;
  }// waterCannonParticles
  
  void trailParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag){
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
  }// trailParticles
  
}// class ParticleManager
