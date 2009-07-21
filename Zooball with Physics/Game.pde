import tacTile.net.*;

/**
 * Foosball Game.
 *
 * Author:  Andy Bursavich
 * Version: 0.4
 */
class Game
{
  private GameState state;
  private LoadingState loadingState;
  private MenuState menuState;
  private PlayState playState;
  private PausedState pausedState;
  /*
  private OverState overState;
  private LeavingState leavingState;
  */
  private PFont debugFont;
  private boolean debugMode = false;
  private final static float DEFAULT_WIDTH = 1920;
  private final static float DEFAULT_HEIGHT = 1080;
  private float screenScale;
  private float screenOffsetX;
  private float screenOffsetY;
  private TouchAPI tacTile;
  
  public Game( TouchAPI tacTile ) {
    this.tacTile = tacTile;
    
    debugFont = loadFont( "ui\\fonts\\Arial Bold-14.vlw" );
   
    loadingState = new LoadingState( this, tacTile );
    menuState = new MenuState( this, tacTile );
    playState = new PlayState( this, tacTile );
    pausedState = new PausedState( this, tacTile );
    
    menuState.beginLoad( );
    playState.beginLoad( );
    pausedState.beginLoad( );
    
    setState( playState );
    
    calculateScreenTransformation( );
    noStroke( );
  }
  
  private void calculateScreenTransformation( ) {
    if ( width / (double)height >= DEFAULT_WIDTH / DEFAULT_HEIGHT ) {
      screenScale = height / DEFAULT_HEIGHT;
      screenOffsetX = (width - DEFAULT_WIDTH * screenScale) * 0.5;
      screenOffsetY = 0;
    }
    else {
      screenScale = width / DEFAULT_WIDTH;
      screenOffsetX = 0;
      screenOffsetY = (height - DEFAULT_HEIGHT * screenScale) * 0.5;
    }
  }
  
  public void loop( ) {
    state.update( );
    state.input( );
    // Translate and Scale
    pushMatrix( );
    translate( screenOffsetX, screenOffsetY );
    scale( screenScale );
    state.draw( );
    popMatrix( );
    drawBars( );
  }
  
  private void drawBars( ) {
    if ( screenOffsetX > 0 ) {
      fill( 50, 50, 50 );
      rect( 0, 0, screenOffsetX, height );
      rect( width - screenOffsetX, 0, screenOffsetX, height );
    }
    else if ( screenOffsetY > 0 ) {
      fill( 50, 50, 50 );
      rect( 0, 0, width, screenOffsetY );
      rect( 0, height - screenOffsetY, width, screenOffsetY );
    }
  }
  
  public void drawDebugText( String string ) {
    if (debugMode) {
      String[] lines = string.trim( ).split( "\n" );

      textFont( debugFont ); 
      for ( int i = 0; i < lines.length; i++ ) {
        String line = lines[i].trim( );
        if ( !line.equals( "" ) ) {
          fill( 0, 128 );
          rect( 10, 5 + i * 20, textWidth( line ) + 10, 20);
          fill( 255 );
          text( line, 15, 20 + i * 20 );
        }
      }
    }
  }

  public GameState getState( ) { return state; }
  public void setState( GameState state ) {
    if ( this.state != null )
      this.state.exit( );
    if ( state.isLoaded( ) ) {
      this.state = state;
      this.state.enter( );
    }  else {
      loadingState.setNextState( state );
      loadingState.reset( );
      loadingState.enter( );
      this.state = loadingState;
    }
    if ( tacTile != null )
      tacTile.clearAllDataTouches( ); // start the new state fresh!
  }
  
  public MenuState getMenuState( ) { return menuState; }
  public PlayState getPlayState( ) { return playState; }
  public PausedState getPausedState( ) { return pausedState; }
  /*
  public OverState getOverState( ) { return overState; }
  public LeavingState getLeavingState( ) { return leavingState; }
  */
  
  public float getX( ) { return screenOffsetX; }
  public float getY( ) { return screenOffsetY; }
  public float getScale( ) { return screenScale; }
  public float getWidth( ) { return DEFAULT_WIDTH; }
  public float getHeight( ) { return DEFAULT_HEIGHT; }
  
  public boolean isDebugMode( ) { return debugMode; }
  public void toggleDebugMode( ) { debugMode = !debugMode; }
}
