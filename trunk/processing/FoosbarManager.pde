/**---------------------------------------------
 * FoosbarManager.pde
 *
 * Description: Foosbar manager. Generates and organizes all foosbars
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
  
  Foosbar[] bars;
  int nBars, fieldLines;
  
  color team1 = color( 0, 0, 255 );
  color team2 = color( 255, 0, 0 );

  //Used in Java/Eclipse version only
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  FoosbarManager(int barLines, int barWidth, int[] screenDim, Ball[] balls){
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
      // Syntax: MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color teamColor, zoneFlag 0 = (top half of screen) 1 = (bottom half of screen))
      if( nBars == 8 ){ // Full regulation size
        bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team1, 0);
        bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
        bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 5, team1, 0);
        bars[4] = new Foosbar( (4+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 5, team2, 1);
        bars[5] = new Foosbar( (5+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
        bars[6] = new Foosbar( (6+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team2, 1);
        bars[7] = new Foosbar( (7+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
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
        bars[0] = new Foosbar( (0+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        bars[1] = new Foosbar( (1+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team1, 0);
        bars[2] = new Foosbar( (2+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
        bars[3] = new Foosbar( (3+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
        bars[4] = new Foosbar( (4+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 2, team2, 1);
        bars[5] = new Foosbar( (5+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        bars[0].setupBars(screenDim, balls);
        bars[1].setupBars(screenDim, balls);
        bars[2].setupBars(screenDim, balls);
        bars[3].setupBars(screenDim, balls);
        bars[4].setupBars(screenDim, balls);
        bars[5].setupBars(screenDim, balls);
        break;
      }else if( x%2 == 0 ){ // If even
        if( x == 0 || x == nBars) // Goalie - One player position
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team1, 0);
        else
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team1, 0);
      }else{ // else odd
        if( x == 0 || x == nBars-1) // Goalie - One player position
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 1, team2, 1);
        else
          bars[x] = new Foosbar( (x+1)*(screenWidth)/fieldLines-barWidth/2 , 0, barWidth, screenHeight, 3, team2, 1);
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
  
  // Bar touch zone is pressed
  void barsPressed(float x, float y){
     for( int i = 0 ; i < nBars ; i++ )
        bars[i].isHit(x,y);
  }// barsPressed
  
  // Reset bars - used to fix edge collision sticking
  void reset(){
    for( int i = 0 ; i < nBars ; i++ )
      bars[i].reset();
  }// reset
}//class FoosbarManager
