/**
 * Leaving GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class LeavingState extends GameState
{
  
  public LeavingState( Game game ) {
    super( game );
  }
  
  public void load( ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 6;
    Random r = new Random( );
    
    for ( int i = 0; i < max; i++ )
      r.nextDouble( );
         
    endLoad( );
  }
  
  public void enter(){
    timer.reset();
    timer.setActive( true );
    soundManager.stopSounds();
  }// enter()  
  
  public void update( ) {
    super.update( );
    if ( timer.getSecondsActive( ) > 5.0 )
      quit = true;
  }
  
  public void draw( ) {
    drawBackground( );
    int offset = 200;
    textFont(font,64);
    fill(255,255,255);
    noStroke();
    textAlign(CENTER);
    text("Thanks for playing ZOOBALL!\nInfinite State Entertainment", game.getWidth()/2 , game.getHeight()/2 + offset);
    pushMatrix();
    translate(game.getWidth()/2, game.getHeight()/2 - offset);
    rotate(PI);
    text("Thanks for playing ZOOBALL!\nInfinite State Entertainment", 0, 0);
    popMatrix();
    textAlign(LEFT);
    
    drawDebugText( );
  }
  
  private void drawBackground( ) {
    background( 0, 0, 0 );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "LeavingState"; }
  
  public void checkButtonHit(float x, float y, int finger){
  }// checkButtonHit
}// class LeavingState
