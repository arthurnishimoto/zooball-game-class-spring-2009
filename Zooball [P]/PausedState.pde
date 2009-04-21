/**
 * Paused GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class PausedState extends GameState
{
  private CircularButton btnResumeBottom, btnResumeTop, btnQuitBottom, btnQuitTop;
  
  public PausedState( Game game ) {
    super( game );
  }
  
  public boolean isLoading( ) { return super.isLoading( ) || game.getPlayState( ).isLoading( ); }
  public boolean isLoaded( ) { return super.isLoaded( ) && game.getPlayState( ).isLoaded( ); }
  public void load( ) {
    if ( !game.getPlayState( ).isLoading( ) && !game.getPlayState( ).isLoaded( ) )
      game.getPlayState( ).beginLoad( );
    btnResumeBottom = new CircularButton( "ui\\buttons\\play\\enabled.png" );
    btnResumeBottom.setPosition( 897.5, 980 );
    btnResumeBottom.setRadius( 50 );
    btnQuitBottom = new CircularButton( "ui\\buttons\\stop\\enabled.png" );
    btnQuitBottom.setPosition( 1022.5, 980 );
    btnQuitBottom.setRadius( 50 );
    btnResumeTop = new CircularButton( "ui\\buttons\\play\\enabled.png" );
    btnResumeTop.setPosition( 1022.5, 100 );
    btnResumeTop.setRadius( 50 );
    btnResumeTop.setRotation( PI );
    btnQuitTop = new CircularButton( "ui\\buttons\\stop\\enabled.png" );
    btnQuitTop.setPosition( 897.5, 100 );
    btnQuitTop.setRadius( 50 );
    btnQuitTop.setRotation( PI );
    endLoad( );
  }
  
  public void draw( ) {
    drawBackground( );
    drawOverlay( );
    drawButtons( );
    drawDebugText( );
  }
  
  private void drawBackground( ) {
    boolean debugMode = game.isDebugMode( );
    if ( debugMode ) game.toggleDebugMode( );
    game.getPlayState().draw( );
    if ( debugMode ) game.toggleDebugMode( );
  }
  
  private void drawOverlay( ) {
    fill( 0, 128 );
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private void drawButtons( ) {
    btnResumeBottom.draw( );
    btnQuitBottom.draw( );
    btnResumeTop.draw( );
    btnQuitTop.draw( );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame Rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "PausedState"; }
  
  public void checkButtonHit(float x, float y, int finger){
    if( btnResumeBottom.contains(x,y) || btnResumeTop.contains(x,y) )
      game.setState( game.getPlayState() );
    else if( btnQuitBottom.contains(x,y) || btnQuitTop.contains(x,y) )
      game.setState( game.getMenuState() );
  }// checkButtonHit
  
}
