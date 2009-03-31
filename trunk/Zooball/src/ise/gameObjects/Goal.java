package ise.gameObjects;

import processing.core.*;
/**---------------------------------------------
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
 */
 
public class Goal extends PApplet{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  
  float xPos, yPos, goalWidth, goalHeight;
  float barWidth = 10;
  int teamNumber, nBalls;
  Ball[] balls;
  
  int ballsRecentlyHit[];
 
  public Goal( float new_xPos, float new_yPos, float newWidth, float newHeight, int teamNo, Ball[] theBalls){
    xPos = new_xPos;
    yPos = new_yPos - newHeight/2;
    goalWidth = newWidth;
    goalHeight = newHeight;
    teamNumber = teamNo;
    balls = theBalls;
    nBalls = balls.length;
    ballsRecentlyHit = new int[nBalls];
  }// goal CTOR
  
  public void display(PApplet p){
    p.fill(0xffFFFFFF, 100);
    p.stroke(0xffFFFFFF);
    p.rect( xPos, yPos, goalWidth, goalHeight ); // Goal Area
    
    p.fill( 100 , 50 , 0 );
    p.stroke( 100 , 50 , 0 );
    p.rect( xPos, 0, goalWidth, yPos ); // Top bar
    p.rect( xPos, yPos + goalHeight - barWidth, goalWidth, yPos ); // Bottom bar
  }// display
  
  public void displayDebug(PApplet p, int debugColor, PFont font){
    p.textFont(font,16);
    p.fill(debugColor);
    for( int i = 0; i < nBalls; i++)
    	p.text("RecentlyHit["+i+"]: "+ballsRecentlyHit[i], xPos, yPos + 16*(3+i));
  }// displayDebug
  
  public boolean scored(){
    return false;
  }// scored
  
  // Check for balls colliding with the goal bars
  public boolean collide(Ball[] balls){
    
    for( int i = 0; i < nBalls; i++ ){
      float ballX = balls[i].xPos;
      float ballY = balls[i].yPos;
      float ballDia = balls[i].diameter;
      
      if( !balls[i].isActive() )
        continue;

      if( teamNumber == 0 ){ // Blue team, left goal
        if( ballX - ballDia/2 < xPos + goalWidth ){
          if( ballsRecentlyHit[i] == 1 )
            continue;
          
          if( ballY <= yPos || ballY >= yPos + goalHeight ){
            balls[i].kickBall( 1, 0, 0 );
            ballsRecentlyHit[i] = 1;
            continue;
          }

        }// if
        if( ballX < xPos + goalWidth/2 ){ // GOOOOOOOAL!
          balls[i].setInactive();
          scored();
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
            ballsRecentlyHit[i] = 1;
            continue;
          }

        }// if
        if( ballX > xPos + goalWidth/2 ){ // GOOOOOOOAL!
          balls[i].setInactive();
          scored();
          
          //topScore++;
          //lastScored = 0;
          //ballsInPlay--;
          continue;
        }
        if(ballsRecentlyHit[i] == 1)
          ballsRecentlyHit[i] = 0; 
      }// team if-else-if 

    }// for
    return false;
  }// collide
  
  public boolean hasBall(Ball[] balls){
    return false;
  }// hasBall
  
}// class Goal