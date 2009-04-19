/**
 * Paused GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.1
 */
class PausedState extends GameState
{
  public PausedState( Game game ) {
    super( game );
  }
  
  public void draw( ) {
    drawBackground( );
    drawOverlay( );
    drawUI( );
  }
  
  public boolean isLoading( ) { return super.isLoading( ) || game.getPlayState( ).isLoading( ); }
  public boolean isLoaded( ) { return super.isLoaded( ) && game.getPlayState( ).isLoaded( ); }
  public void load( ) {
    if ( !game.getPlayState( ).isLoading( ) && !game.getPlayState( ).isLoaded( ) )
      game.getPlayState( ).beginLoad( );
    endLoad( );
  }
  
  private void drawBackground( ) {
    game.getPlayState().draw( );
  }
  
  private void drawOverlay( ) {
    noStroke( );
    fill( 0, 128 );
    rect( 0, 0, width, height );
  }
  
  private void drawUI( ) {
    // TODO: draw labels, buttons, etc.
  }
  
  public String toString( ) {
    return "PausedState";
  }
}
