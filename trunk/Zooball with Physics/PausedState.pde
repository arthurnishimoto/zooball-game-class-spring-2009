/**
 * Paused GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class PausedState extends GameState
{
  private CircularButton btnResumeBottom, btnResumeTop, btnReplayBottom, btnReplayTop, btnQuitBottom, btnQuitTop;
  
  public PausedState( Game game, TouchAPI tacTile ) {
    super( game, tacTile );
  }
  
  public boolean isLoading( ) { return super.isLoading( ) || game.getPlayState( ).isLoading( ); }
  public boolean isLoaded( ) { return super.isLoaded( ) && game.getPlayState( ).isLoaded( ); }
  public void load( ) {
    if ( !game.getPlayState( ).isLoading( ) && !game.getPlayState( ).isLoaded( ) )
      game.getPlayState( ).beginLoad( );
    btnResumeBottom = new CircularButton( "play" );
    btnResumeBottom.setPosition( 837.5, 980 );
    btnResumeBottom.setRadius( 50 );
    btnReplayBottom = new CircularButton( "replay" );
    btnReplayBottom.setPosition( 960, 980 );
    btnReplayBottom.setRadius( 50 );
    btnQuitBottom = new CircularButton( "stop" );
    btnQuitBottom.setPosition( 1082.5, 980 );
    btnQuitBottom.setRadius( 50 );
    btnResumeTop = new CircularButton( "play" );
    btnResumeTop.setPosition( 1082.5, 100 );
    btnResumeTop.setRadius( 50 );
    btnResumeTop.setRotation( PI );
    btnReplayTop = new CircularButton( "replay" );
    btnReplayTop.setPosition( 960, 100 );
    btnReplayTop.setRadius( 50 );
    btnReplayTop.setRotation( PI );
    btnQuitTop = new CircularButton( "stop" );
    btnQuitTop.setPosition( 837.5, 100 );
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
    btnReplayBottom.draw( );
    btnQuitBottom.draw( );
    btnResumeTop.draw( );
    btnReplayTop.draw( );
    btnQuitTop.draw( );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame Rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() + "\nPlay Time: " + game.playState.timer.getSecondsActive() );
  }
  
  public String toString( ) { return "PausedState"; }
}
