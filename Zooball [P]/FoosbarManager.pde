/**
 * ---------------------------------------------
 * FoosbarManager.pde
 *
 * Description: Foosbar manager. Generates and organizes all Foosbars
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
 * 4/19/09   - Imported new Foosbars (with rotate support)
 * ---------------------------------------------
 */
 
class FoosbarManager{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  
  Foosbar[] bars;
  int nBars, fieldLines;
  
  color team1 = color( 255, 0, 0 );
  color team2 = color( 255, 255, 0 );
  
  //Used in Java/Eclipse version only
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  FoosbarManager(int barLines, int barWidth, int[] screenDim, Ball[] balls, PImage[] team1_Images, PImage[] team2_Images){
    state = ACTIVE; // Initial state
    bars = new Foosbar[barLines];
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
        if ( redTeamTop ){
          bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team1, 0, team1_Images);
          bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team1, 0, team1_Images);
          bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team2, 1, team2_Images);
          bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 5, team1, 0, team1_Images);
          bars[4] = new Foosbar( (4+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 5, team2, 1, team2_Images);
          bars[5] = new Foosbar( (5+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team1, 0, team1_Images);
          bars[6] = new Foosbar( (6+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team2, 1, team2_Images);
          bars[7] = new Foosbar( (7+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team2, 1, team2_Images);
          bars[0].setupBars(screenDim, balls);
          bars[1].setupBars(screenDim, balls);
          bars[2].setupBars(screenDim, balls);
          bars[3].setupBars(screenDim, balls);
          bars[4].setupBars(screenDim, balls);
          bars[5].setupBars(screenDim, balls);
          bars[6].setupBars(screenDim, balls);
          bars[7].setupBars(screenDim, balls);
          break;
        }else{
          bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team2, 0, team2_Images);
          bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team2, 0, team2_Images);
          bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team1, 1, team1_Images);
          bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 5, team2, 0, team2_Images);
          bars[4] = new Foosbar( (4+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 5, team1, 1, team1_Images);
          bars[5] = new Foosbar( (5+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team2, 0, team2_Images);
          bars[6] = new Foosbar( (6+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team1, 1, team1_Images);
          bars[7] = new Foosbar( (7+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team1, 1, team1_Images);
          bars[0].setupBars(screenDim, balls);
          bars[1].setupBars(screenDim, balls);
          bars[2].setupBars(screenDim, balls);
          bars[3].setupBars(screenDim, balls);
          bars[4].setupBars(screenDim, balls);
          bars[5].setupBars(screenDim, balls);
          bars[6].setupBars(screenDim, balls);
          bars[7].setupBars(screenDim, balls);
          break;
        }
      }else if( nBars == 6 ){
        bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team1, 0, team1_Images);
        bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team1, 0, team1_Images);
        bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team2, 1, team2_Images);
        bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team1, 0, team1_Images);
        bars[4] = new Foosbar( (4+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team2, 1, team2_Images);
        bars[5] = new Foosbar( (5+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team2, 1, team2_Images);
        bars[0].setupBars(screenDim, balls);
        bars[1].setupBars(screenDim, balls);
        bars[2].setupBars(screenDim, balls);
        bars[3].setupBars(screenDim, balls);
        bars[4].setupBars(screenDim, balls);
        bars[5].setupBars(screenDim, balls);
        break;
      }else if( nBars == 4 ){
        if ( redTeamTop ){
          bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team1, 0, team1_Images);
          bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team2, 1, team2_Images);
          bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team1, 0, team1_Images);
          bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team2, 1, team2_Images);
          bars[0].setupBars(screenDim, balls);
          bars[1].setupBars(screenDim, balls);
          bars[2].setupBars(screenDim, balls);
          bars[3].setupBars(screenDim, balls);
          break;
        }else{
          bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team2, 0, team2_Images);
          bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team1, 1, team1_Images);
          bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team2, 0, team2_Images);
          bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 2, team1, 1, team1_Images);
          bars[0].setupBars(screenDim, balls);
          bars[1].setupBars(screenDim, balls);
          bars[2].setupBars(screenDim, balls);
          bars[3].setupBars(screenDim, balls);
          break;
        }
      }else if( nBars == 2 ){
        if ( redTeamTop ){
          bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team1, 0, team1_Images);
          bars[1] = new Foosbar( (7+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team2, 1, team2_Images);
          bars[0].setupBars(screenDim, balls);
          bars[1].setupBars(screenDim, balls);
          break;
        }else{
          bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team2, 0, team2_Images);
          bars[1] = new Foosbar( (7+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team1, 1, team1_Images);
          bars[0].setupBars(screenDim, balls);
          bars[1].setupBars(screenDim, balls);
          break;
        }
      }else if( x%2 == 0 ){ // If even
        if( x == 0 || x == nBars) // Goalie - One player position
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team1, 0, team1_Images);
        else
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team1, 0, team1_Images);
      }else{ // else odd
        if( x == 0 || x == nBars-1) // Goalie - One player position
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 1, team2, 1, team2_Images);
        else
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines , screenHeight/2, barWidth, screenHeight, 3, team2, 1, team2_Images);
      }
      bars[x].setupBars(screenDim, balls);
    }// for
    
  }// CTOR
  
  // Process manager tasks based on current state
  void process(Ball[] balls, double timer_g, GameState parent){
    if( state == ACTIVE ){
      for( int x = 0 ; x < nBars ; x++ ){
        bars[x].display();
        if( parent.timer.isActive() ){
          //bars[x].ballInArea(balls);
          //bars[x].collide(balls); // No longer used for collision detection, but still used for stats and special hits
          bars[x].setGameTimer(timer_g);
        }
      }// for
    }else if ( state == INACTIVE ){
      // Inactive state
    }// state if-else-if
  }// process
  
  void collide(Line[] horzWalls){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].collide( horzWalls[0] );
      bars[x].collide( horzWalls[1] );
    }// for nBars
  }// collide
  
  void collide(Ball[] balls){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].collide( balls );
    }// for nBars
  }// collide

  void collide(Ball balls){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].collide( balls );
    }// for nBars
  }// collide
  
  void step(double dt){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].step( dt );
    }// for nBars
  }// step
  
  
  void display(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].display();
    }// for
  }// display
  
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
  
   void displayStats(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayStats();
    }// for
  }// displayStats
  
  void updateFoosbarRecord(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].updateFoosbarRecord();
    }// for
  }// updateFoosbarRecord
  
  // Bar touch zone is pressed
  void barsPressed(float x, float y){
     for( int i = 0 ; i < nBars ; i++ )
        bars[i].isHit(x,y);
  }// barsPressed
  
  void sendTouchList(ArrayList touchList, boolean isEmpty){
     for( int i = 0 ; i < nBars ; i++ )
       bars[i].checkForTouches(touchList, isEmpty);
  }// sendTouchList
  
  void setSpringEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setSpringEnabled(enable);
  }// setSpringEnabled
  
  void setRotationEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setRotationEnabled(enable);
  }// setRotationEnabled
  
  void setTopSpringEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      if( bars[x].zoneFlag == 0 )
        bars[x].setSpringEnabled(enable);
  }// setSpringEnabled
  
  void setTopRotationEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      if( bars[x].zoneFlag == 0 )
        bars[x].setRotationEnabled(enable);
  }// setRotationEnabled  

  void setBottomSpringEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      if( bars[x].zoneFlag == 1 )
        bars[x].setSpringEnabled(enable);
  }// setSpringEnabled
  
  void setBottomRotationEnabled(boolean enable){
    for( int x = 0 ; x < nBars ; x++ )
      if( bars[x].zoneFlag == 1 )
        bars[x].setRotationEnabled(enable);
  }// setRotationEnabled  
  
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

  void setMaxStopAngle(int newVal){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setMaxStopAngle(newVal);
  }// setMaxStopAngle

  void setMinStopAngle(int newVal){
    for( int x = 0 ; x < nBars ; x++ )
      bars[x].setMinStopAngle(newVal);
  }// setMinStopAngle
  
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

  int getMinStopAngle(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].getMinStopAngle();
    return -1;
  }// getMinStopAngle
  
  int getMaxStopAngle(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].getMaxStopAngle();
    return -1;
  }// getMaxStopAngle
  
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
  
  boolean isRotationEnabled(){
    for( int x = 0 ; x < nBars ; x++ )
      return bars[x].isRotationEnabled();
    return false;
  }// isRotationEnabled
  
  // Reset bars - used to fix edge collision sticking
  void reset(){
    for( int i = 0 ; i < nBars ; i++ )
      bars[i].reset();
  }// reset
}//class FoosbarManager
