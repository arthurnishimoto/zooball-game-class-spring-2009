/**
 * Loading GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.5
 */
class LoadingState extends GameState
{
  private GameState nextState;
  private Image logo;
  
  public LoadingState( Game game, TouchAPI tacTile ) {
    super( game, tacTile );
    logo = new Image( "ui\\logos\\infinity.png" );
    logo.setX( ( game.getWidth( ) - logo.getWidth( ) ) * 0.5 );
    logo.setY( ( game.getHeight( ) - logo.getHeight( ) ) * 0.5 );
    endLoad( );
  }
  
  public void setNextState( GameState state ) { this.nextState = state; }
  
  public void enter( ) {
    super.enter( );
    if ( nextState != null && !nextState.isLoading( ) && !nextState.isLoaded( ) )
      nextState.beginLoad( );
  }
  
  public void update( ) {
    if ( nextState != null && nextState.isLoaded( ) )
      game.setState( nextState );
    else
      super.update( );
  }
  
  public void draw( ) {
    drawBackground( );
    drawLogo( );
    drawOverlay( );
    drawDebugText( );
  }
  
  private void drawBackground( ) {
    background( 0 ); // black
  }
  
  private void drawLogo( ) {
    logo.draw( );
  }
  
  private void drawOverlay( ) {
    fill( 0, getOverlayAlpha( ) );
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private float getOverlayAlpha( ) {
    float FULL_CYCLE = 2.0;
    float HALF_CYCLE = 1.0;
    float seconds = (float)timer.getSecondsActive( );
    float position = seconds - floor( seconds / FULL_CYCLE ) * FULL_CYCLE;
    if ( position > HALF_CYCLE)
      return map( position, HALF_CYCLE, FULL_CYCLE, 180, 0 );
    else
      return map( position, 0, HALF_CYCLE, 0, 180 );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nLoading: " + nextState + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "LoadingState"; }
}
