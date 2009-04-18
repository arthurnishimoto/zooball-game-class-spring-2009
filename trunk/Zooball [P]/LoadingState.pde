class LoadingState extends GameState
{
  private GameState nextState;
  private PImage logo;
  
  public LoadingState( Game game ) {
    super( game );
    logo = loadImage( "infinity.png" );
    loaded = true;
  }
  
  public void setNextState( GameState state ) { this.nextState = state; }
  
  public void enter( ) {
    super.enter( );
    if ( nextState != null && !nextState.isLoaded( ) ) {
      Runnable loader = new Runnable( ) {
        public void run( ) { nextState.load( ); }
      };
      new Thread( loader ).start( );
    }
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
  }
  
  private void drawBackground( ) {
    //background( 0x00, 0x33, 0x66 ); // blue
    //background( 0xFF, 0x66, 0x00 ); // orange
    background( 0 ); // black
  }
  
  private void drawLogo( ) {
    pushMatrix( );
    translate( ( width - logo.width ) * 0.5, ( height - logo.height ) * 0.5 );
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
    noStroke( );
    fill( 0, getAlpha( ) );
    rect( 0, 0, width, height );
  }
  
  private float getAlpha( ) {
    float FULL_CYCLE = 4.0;
    float HALF_CYCLE = 2.0;
    float seconds = timer.getSecondsActive( );
    float position = seconds - floor( seconds / FULL_CYCLE ) * FULL_CYCLE;
    if ( position > HALF_CYCLE)
      return map( position, HALF_CYCLE, FULL_CYCLE, 200, 0 );
    else
      return map( position, 0, HALF_CYCLE, 0, 200 );
  }
}
