package ise.gameObjects;
import ise.game.*;
import processing.core.*;

/**---------------------------------------------
 * FoosBarManager.java
 *
 * Description: FoosBar manager.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3a
 * 
 * Version Notes:
 * 3/25/09    - Initial version - imported from processing with minor Java fixes
 */

public class FoosBarManager extends PApplet{
	int team1 = color( 0, 0, 255 );
	int team2 = color( 255, 0, 0 );
	
  MTFoosBar[] bars;
  int fieldLines;
  int nBars;
  Ball[] balls;
  
  //Used in Java/Eclipse version only
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  public FoosBarManager(int barLines, int barWidth, int[] screenDim, Ball[] ballArray){
    bars = new MTFoosBar[barLines];
    fieldLines = barLines;
    nBars = fieldLines - 1;
    balls = ballArray;

    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    
    for( int x = 0 ; x < nBars ; x++ ){
      // Syntax: MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color teamColor, zoneFlag 0 = (top half of screen) 1 = (bottom half of screen))
      if( nBars == 8 ){ // Full regulation size
        bars[0] = new MTFoosBar( (0+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        bars[1] = new MTFoosBar( (1+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team1, 0);
        bars[2] = new MTFoosBar( (2+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
        bars[3] = new MTFoosBar( (3+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 5, team1, 0);
        bars[4] = new MTFoosBar( (4+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 5, team2, 1);
        bars[5] = new MTFoosBar( (5+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
        bars[6] = new MTFoosBar( (6+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team2, 1);
        bars[7] = new MTFoosBar( (7+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
      }else if( x%2 == 0 ){ // If even
        if( x == 0 || x == nBars) // Goalie - One player position
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        else
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
      }else{ // else odd
        if( x == 0 || x == nBars-1) // Goalie - One player position
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        else
          bars[x] = new MTFoosBar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
      }
      
      bars[x].setScreenDimentions(screenDim);
    }// for
    
  }// CTOR
  
  
  public void display(PApplet p){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].display(p);
      bars[x].ballInArea(balls);
      bars[x].collide(balls);
    }// for
  }// display
  
  public void displayZones(PApplet p){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayZones(p);
    }// for
  }// display

  public void displayDebug(PApplet p, Game g){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayDebug(p,g);
    }// for
  }// display
  
  public void barsPressed(float x, float y){
     for( int i = 0 ; i < nBars ; i++ )
        bars[i].isHit(x,y);
  }// barsPressed
  
  public void reset(){
    for( int i = 0 ; i < nBars ; i++ )
      bars[i].reset();
  }// reset
}//class