/**
 * Loading GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.2
 */
class LoadingState extends GameState
{
  private GameState nextState;
  private PImage logo;
  
  public LoadingState( Game game ) {
    super( game );
    logo = loadImage( "ui\\logos\\infinity.png" );
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
    pushMatrix( );
    translate( ( game.getWidth( ) - logo.width ) * 0.5, ( game.getHeight( ) - logo.height ) * 0.5 );
    beginShape( );
    texture( logo );
    textureMode( NORMALIZED );
    vertex( 0, 0, 0, 0 );
    vertex( logo.width, 0, 1, 0 );
    vertex( logo.width, logo.height, 1, 1 );
    vertex( 0, logo.height, 0, 1 );
    endShape( );
    popMatrix( );
  }
  
  private void drawOverlay( ) {
    fill( 0, getOverlayAlpha( ) );
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private float getOverlayAlpha( ) {
    float FULL_CYCLE = 3.0;
    float HALF_CYCLE = 1.5;
    float seconds = timer.getSecondsActive( );
    float position = seconds - floor( seconds / FULL_CYCLE ) * FULL_CYCLE;
    if ( position > HALF_CYCLE)
      return map( position, HALF_CYCLE, FULL_CYCLE, 180, 0 );
    else
      return map( position, 0, HALF_CYCLE, 0, 180 );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "Loading: " + nextState + "\nFrame rate: " + frameRate + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "LoadingState"; }
}
