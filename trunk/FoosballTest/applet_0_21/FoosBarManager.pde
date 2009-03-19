
color team1 = color( 0, 0, 255 );
color team2 = color( 255, 0, 0 );

class FoosBarManager{
  MTFoosBar[] bars;
  
  FoosBarManager(int barLines, int barWidth){
    bars = new MTFoosBar[barLines];
    
    for( int x = 0 ; x < nBars ; x++ ){
      // Syntax: MTFoosBar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color teamColor, zoneFlag 0 = (top half of screen) 1 = (bottom half of screen))
      if( x%2 == 0 ){ // If even
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
    }// for
    
  }// CTOR
  
  
  void display(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].display();
      bars[x].ballInArea(balls);
      bars[x].collide(balls);
    }// for
  }// display
  
  void displayZones(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayZones();
    }// for
  }// display

  void displayDebug(){
    for( int x = 0 ; x < nBars ; x++ ){
      bars[x].displayDebug();
    }// for
  }// display
  
  void barsPressed(float x, float y){
     for( int i = 0 ; i < nBars ; i++ )
        bars[i].isHit(x,y);
  }// barsPressed
  
  void reset(){
    for( int i = 0 ; i < nBars ; i++ )
      bars[i].reset();
  }// reset
}//class
