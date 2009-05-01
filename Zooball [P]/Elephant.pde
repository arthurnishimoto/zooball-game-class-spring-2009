class Elephant{
  Image elephant;
  float xPos, yPos;
  float xVel, yVel;
  float targetX, targetY;
  float rotation;
  int distance;
    
  Elephant( float x, float y ){
    xPos = x;
    yPos = y;
    xVel = 0;
    yVel = 0;
    elephant = new Image("data/objects/elephant_small.png");
    elephant.setPosition(x,y);
  }// CTOR
  
  public void display(){
    elephant.setPosition(xPos,yPos);
    elephant.setRotation(rotation);
    elephant.draw();
    //fireParticles(int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag, float dispRate){
    particleManager2.fireParticles( 10, 10, xPos + 50, yPos + 50, 0, -10, 1, 0.5);
  }// display
  
  public void move( float xVeloc, float yVeloc ){
    xVel = xVeloc;
    yVel = yVeloc;
  }// move
  
  public void setPosition( float x, float y ){
    xPos = x;
    yPos = y;
  }// setPosition
  
  public void setRotation( float newVal ){
    rotation = newVal;
  }// setRotation
  
  public void shootWater( float distance ){
    
  }
}// class
