/**
 * ---------------------------------------------
 * Goal.pde
 *
 * Description: Foosbar goal zone
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1
 * 
 * Version Notes:
 * 3/20/09    - Initial version
 * 3/28/09    - FSM implementation
 * 4/19/09    - Added team color to goal
 * --------------------------------------------- 
 */
 
class Goal{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  
  float xPos, yPos, goalWidth, goalHeight;
  float barWidth = 10;
  int teamNumber, nBalls, points;
  color teamColor;
  Ball[] balls;
  
  boolean onFire = false;
  float fireDuration = 10;
  float fireTimer = 0;
  float fireX, fireY;
  
  PlayState parent;
  
  int ballsRecentlyHit[];
 
  Goal( float new_xPos, float new_yPos, float newWidth, float newHeight, int teamNo, color playerColor, Ball[] theBalls){
    xPos = new_xPos;
    yPos = new_yPos - newHeight/2;
    goalWidth = newWidth;
    goalHeight = newHeight;
    teamNumber = teamNo;
    balls = theBalls;
    nBalls = balls.length;
    ballsRecentlyHit = new int[nBalls];
    teamColor = playerColor;
  }// goal CTOR
  
  void display(){
    fill(#FFFFFF, 100);
    stroke(#FFFFFF);
    rect( xPos, yPos, goalWidth, goalHeight ); // Goal Area
    
    fill( 100 , 50 , 0 );
    noStroke();
    rect( xPos, 0, goalWidth, yPos ); // Top bar
    rect( xPos, yPos + goalHeight, goalWidth, yPos ); // Bottom bar
    
    if( teamNumber == 0 ){
      fill( teamColor );
      noStroke();      
      rect( xPos, yPos, goalWidth/2, goalHeight );
    }else if( teamNumber == 1 ){
      fill( teamColor );
      noStroke();      
      rect( xPos + goalWidth/2, yPos, goalWidth/2, goalHeight );
    }

    // Temp visual score
    for(int x = 1; x < points+1; x++){
      fill(0,0,0);
      rectMode(CENTER);
      rect( xPos + goalWidth/2, yPos + 50*x, 40, 40 );
    }
    rectMode(CORNER);
    
    if( fireTimer > parent.timer.getSecondsActive() ){
      particleManager2.fireParticles( 5, 30, fireX, fireY, 0, 0, 0, 5);
      particleManager2.fireParticles( 5, 30, fireX, fireY, 0, 0, 0, 5);
      particleManager2.smokeParticles( 5, 10, fireX, fireY, 0, (int)random(-1,2), 3 , -1 ); // Fast Smoke
      parent.leftElephant.setPosition( fireX - 50, fireY + 100 );
    }else
      onFire = false;
  }// display
  
  void displayDebug(color debugColor, PFont font){
    textFont(font,16);
    fill(debugColor);
    for( int i = 0; i < nBalls; i++)
      text("RecentlyHit["+i+"]: "+ballsRecentlyHit[i], xPos, yPos + 16*(3+i));
    text("Points: "+points, xPos, yPos + 16*(3+nBalls));
  }// displayDebug
    
  // Check for balls colliding with the goal bars
  boolean collide(Ball[] balls){
    for( int i = 0; i < nBalls; i++ ){
      if( balls[i] == null )
        return false;
      
      float ballX = balls[i].xPos;
      float ballY = balls[i].yPos;
      float ballDia = balls[i].diameter;
      
      if( balls[i].isInactive() )
        continue;

      if( teamNumber == 0 ){ // Blue team, left goal
        if( ballX - ballDia/2 < xPos + goalWidth ){
          if( ballsRecentlyHit[i] == 1 )
            continue;
          
          if( ballY <= yPos || ballY >= yPos + goalHeight ){
            balls[i].kickBall( 1, 0, 0 );
            soundManager.playBounce();
            ballsRecentlyHit[i] = 1;
            continue;
          }

        }// if
        
        if( ballX < xPos + goalWidth/2 ){ // GOOOOOOOAL!
          if( balls[i].isFireball() )
            setOnFire(balls[i].xPos,balls[i].yPos);
          if( balls[i].isDecoyball() )
            continue;
          if( balls[i].lastBarHit != null ){
            balls[i].lastBarHit.statistics[0] += 1; // Scored
            if( teamNumber == balls[i].lastBarHit.zoneFlag ) // Scored on own goal
              balls[i].lastBarHit.statistics[1] += 1;
          }
          balls[i].setInactive();
          points++;
          soundManager.playGoal();
          parent.lastScored = 1;
          parent.ballsInPlay--;
          continue;
        }
        
        if(ballsRecentlyHit[i] == 1)
          ballsRecentlyHit[i] = 0;
      }else if( teamNumber == 1 ){ // Red team, right goal
        if( ballX + ballDia/2 > xPos ){
          if( ballsRecentlyHit[i] == 1 )
            continue;
          
          if( ballY <= yPos || ballY >= yPos + goalHeight ){
            balls[i].kickBall( 1, 0, 0 );
            soundManager.playBounce();
            ballsRecentlyHit[i] = 1;
            continue;
          }

        }// if
        
        if( ballX > xPos + goalWidth/2 ){ // GOOOOOOOAL!
          if( balls[i].isFireball() )
            setOnFire(balls[i].xPos,balls[i].yPos);
          if( balls[i].isDecoyball() )
            continue;
          if( balls[i].lastBarHit != null ){
            balls[i].lastBarHit.statistics[0] += 1; // Scored
            if( teamNumber == balls[i].lastBarHit.zoneFlag ) // Scored on own goal
              balls[i].lastBarHit.statistics[1] += 1;
          }
          balls[i].setInactive();
          points++;
          soundManager.playGoal();
          parent.lastScored = 0;
          parent.ballsInPlay--;
          continue;
        }
        
        if(ballsRecentlyHit[i] == 1)
          ballsRecentlyHit[i] = 0; 
      }// team if-else-if 

    }// for
    return false;
  }// collide
  
  boolean hasBall(Ball[] balls){
    return false;
  }// hasBall
  
  // Setters/Getters
  
  void setParentClass(PlayState newParent){
    parent = newParent;
  }// setParentClass
  
  void setOnFire(float x, float y){
    onFire = true;
    fireX = x;
    fireY = y;
    fireTimer = fireDuration + (float)parent.timer.getSecondsActive();
    soundManager.playSizzle();
    soundManager.playElephant();
  }// setOnFire
  
  boolean isOnFire(){
    return onFire;
  }//isonFire
  
  int getScore(){
    return points;
  }// getScore
  
}// class Goal

