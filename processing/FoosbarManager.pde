/**
 * ---------------------------------------------
 * FoosbarManager.pde
 *
 * Description: Foosbar2 manager. Generates and organizes all Foosbar2s
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.2
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - Version 0.2 - Support for various field configuration
 *           - FSM implementation
 */
 
class FoosbarManager{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  
  Foosbar2[] bars;
  int nBars, fieldLines;
  
  color team1 = color( 255, 0, 0 );
  color team2 = color( 255, 255, 0 );

  //Used in Java/Eclipse version only
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  FoosbarManager(int barLines, int barWidth, int[] screenDim, Ball[] balls){
    state = ACTIVE; // Initial state
    bars = new Foosbar2[barLines];
    fieldLines = barLines;
    nBars = barLines - 1;
    
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    
    for( int x = 0 ; x < nBars ; x++ ){
      // Syntax: MTFoosbar2(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color teamColor, zoneFlag 0 = (top half of screen) 1 = (bottom half of screen))
      if( nBars == 8 ){ // Modified regulation size (Reduced center players from 5 to 4)
        bars[0] = new Foosbar2( (0+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        bars[1] = new Foosbar2( (1+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team1, 0);
        bars[2] = new Foosbar2( (2+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
        bars[3] = new Foosbar2( (3+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 4, team1, 0);
        bars[4] = new Foosbar2( (4+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 4, team2, 1);
        bars[5] = new Foosbar2( (5+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
        bars[6] = new Foosbar2( (6+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team2, 1);
        bars[7] = new Foosbar2( (7+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        bars[0].setupBars(screenDim, balls);
        bars[1].setupBars(screenDim, balls);
        bars[2].setupBars(screenDim, balls);
        bars[3].setupBars(screenDim, balls);
        bars[4].setupBars(screenDim, balls);
        bars[5].setupBars(screenDim, balls);
        bars[6].setupBars(screenDim, balls);
        bars[7].setupBars(screenDim, balls);
        break;
      }else if( nBars == 6 ){
        bars[0] = new Foosbar2( (0+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        bars[1] = new Foosbar2( (1+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team1, 0);
        bars[2] = new Foosbar2( (2+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
        bars[3] = new Foosbar2( (3+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
        bars[4] = new Foosbar2( (4+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team2, 1);
        bars[5] = new Foosbar2( (5+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        bars[0].setupBars(screenDim, balls);
        bars[1].setupBars(screenDim, balls);
        bars[2].setupBars(screenDim, balls);
        bars[3].setupBars(screenDim, balls);
        bars[4].setupBars(screenDim, balls);
        bars[5].setupBars(screenDim, balls);
        break;
      }else if( x%2 == 0 ){ // If even
        if( x == 0 || x == nBars) // Goalie - One player position
          bars[x] = new Foosbar2( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        else
          bars[x] = new Foosbar2( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
      }else{ // else odd
        if( x == 0 || x == nBars-1) // Goalie - One player position
          bars[x] = new Foosbar2( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        else
          bars[x] = new Foosbar2( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
      }
      bars[x].setupBars(screenDim, balls);
    }// for
    
  }// CTOR
  
  // Process manager tasks based on current state
  void process(Ball[] balls, double timer_g){
    if( state == ACTIVE ){
      for( int x = 0 ; x < nBars ; x++ ){
        bars[x].display();
        bars[x].ballInArea(balls);
        bars[x].collide(balls);
        bars[x].setGameTimer(timer_g);
      }// for
    }else if ( state == INACTIVE ){
      // Inactive state
    }// state if-else-if
  }// process
  
  // Displays team zone areas
  void displayZones(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayZones();
    }// for
  }// display

  void displayDebug(color debugColor, PFont font){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayDebug(debugColor,font);
    }// for
  }// display
  
  void displayHitbox(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayHitbox();
    }// for
  }// displayHitbox
  
  // Bar touch zone is pressed
  void barsPressed(float x, float y){
     for( int i = 0 ; i < nBars ; i++ )
        bars[i].isHit(x,y);
  }// barsPressed
  
  void setSpringEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setSpringEnabled(enable);
  }// setSpringEnabled
  
  void setBarWidth(float newWidth){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].barWidth = newWidth;
  }// setBarWidth  
  
  void setBarSlideMultiplier(float newVal){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setBarSlideMultiplier(newVal);
  }// setBarSlideMultiplier
  
  void setBarRotateMultiplier(float newVal){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setBarRotateMultiplier(newVal);
  }// setBarRotateMultiplier
  
  void setBarFriction(float newVal){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].barFriction = newVal;
  }// setBarFriction
  
  float getBarSlideMultiplier(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].getBarSlideMultiplier();
    return -1.0;
  }// getBarSlideMultiplier
  
  float getBarRotateMultiplier(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].getBarRotateMultiplier();
    return -1.0;
  }// getBarRotateMultiplier
  
  float getBarFriction(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].barFriction;
    return -1.0;
  }// getBarFriction 
  
  boolean isSpringEnabled(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].isSpringEnabled();
    return false;
  }// isSpringEnabled
  
  // Reset bars - used to fix edge collision sticking
  void reset(){
    for( int i = 0 ; i < nBars ; i++ )
      bars[i].reset();
  }// reset
}//class FoosbarManager
