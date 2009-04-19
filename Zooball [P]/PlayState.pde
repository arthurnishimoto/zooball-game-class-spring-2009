/**
 * The main GameState. Gameplay happens here.
 *
 * Author:  Andy Bursavich
 * Version: 0.2
 */
class PlayState extends GameState
{
  public PlayState( Game game ) {
    super( game );
  }
  
  public void load( ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 5;
    Random r = new Random( );
    
    for ( int i = 0; i < max; i++ )
      r.nextDouble( );   
    endLoad( );
  }
  
  public void draw( ) {
    drawBackground( );
  }
  
  private void drawBackground( ) {
    background( 0 );
    fill( 20, 200, 20 ); // green
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  public String toString( ) { return "PlayState"; }
}
