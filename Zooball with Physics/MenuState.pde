/**
 * Menu GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class MenuState extends GameState
{
  public MenuState( Game game, TouchAPI tacTile ) {
    super( game, tacTile );
  }
  
  public void load( ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 6;
    Random r = new Random( );
    
    for ( int i = 0; i < max; i++ )
      r.nextDouble( );   

    endLoad( );
  }
  
  public void update( ) {
    super.update( );
    if ( timer.getSecondsActive( ) > 3.0 )
      game.setState( game.getPlayState( ) );
  }
  
  public void draw( ) {
    drawBackground( );
    drawDebugText( );
  }
  
  private void drawBackground( ) {
    background( 0 );
    fill( 0x00, 0x33, 0x66 ); // blue
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "MenuState"; }
}
