
class Goal{
  int state;
  final static int ACTIVE = 1;
  final static int INACTIVE = 0;
  
  float xPos, yPos, goalWidth, goalHeight;
  float barWidth = 10;
  int teamNumber;
  
  int ballsRecentlyHit[] = new int[nBalls];
 
  Goal( float new_xPos, float new_yPos, float newWidth, float newHeight, int teamNo ){
    xPos = new_xPos;
    yPos = new_yPos - newHeight/2;
    goalWidth = newWidth;
    goalHeight = newHeight;
    teamNumber = teamNo;
  }// goal CTOR
  
  void display(){
    fill(#FFFFFF, 100);
    stroke(#FFFFFF);
    rect( xPos, yPos, goalWidth, goalHeight ); // Goal Area
    
    fill( 100 , 50 , 0 );
    stroke( 100 , 50 , 0 );
    
    rect( xPos, 0, goalWidth, yPos ); // Top bar
    rect( xPos, yPos + goalHeight - barWidth, goalWidth, yPos ); // Bottom bar
  }// display
  
  void displayDebug(){
    textFont(font,16);
    fill(debugColor);
    for( int i = 0; i < nBalls; i++)
    text("RecentlyHit["+i+"]: "+ballsRecentlyHit[i], xPos, yPos + 16*(3+i));
  }// displayDebug
  
  boolean scored(){
    return false;
  }// scored
  
  boolean collide(Ball[] balls){
    
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
          bottomScore++;
          lastScored = 1;
          ballsInPlay--;
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
          topScore++;
          lastScored = 0;
          ballsInPlay--;
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
  
}// class

