/**
 * Foosball Game.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
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
  private boolean strokeMode = false;
  private final static float DEFAULT_WIDTH = 1920;
  private final static float DEFAULT_HEIGHT = 1080;
  private float screenScale;
  private float screenOffsetX;
  private float screenOffsetY;
  
  public Game( ) {
    debugFont = loadFont( "ui\\fonts\\Arial Bold-14.vlw" );
   
    loadingState = new LoadingState( this );
    menuState = new MenuState( this );
    playState = new PlayState( this );
    pausedState = new PausedState( this );
    
    menuState.beginLoad( );
    playState.beginLoad( );
    pausedState.beginLoad( );
    setState( menuState );
    
    calculateScreenTransformation( );
    noStroke( );
  }
  
  private void calculateScreenTransformation( ) {
    if ( width / height >= DEFAULT_WIDTH / DEFAULT_HEIGHT ) {
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
    state.input( );
    state.update( );
    // Translate and Scale
    pushMatrix( );
    translate( screenOffsetX, screenOffsetY );
    scale( screenScale );
    state.draw( );
    popMatrix( );
  }
  
  public void drawDebugText( String string ) {
    if (debugMode) {
      String[] lines = string.trim( ).split( "\n" );

      textFont( debugFont ); 
      fill( 255 );
      for ( int i = 0; i < lines.length; i++ ) {
        String line = lines[i].trim( );
        if ( !line.equals( "" ) )
          text( line, 15, 20 + i * 15 );
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
  }
  
  public MenuState getMenuState( ) { return menuState; }
  public PlayState getPlayState( ) { return playState; }
  public PausedState getPausedState( ) { return pausedState; }
  /*
  public OverState getOverState( ) { return overState; }
  public LeavingState getLeavingState( ) { return leavingState; }
  */
  
  public float getWidth( ) { return DEFAULT_WIDTH; }
  public float getHeight( ) { return DEFAULT_HEIGHT; }
  
  public boolean isDebugMode( ) { return debugMode; }
  public void toggleDebugMode( ) { debugMode = !debugMode; }
  public boolean isStrokeMode( ) { return strokeMode; }
  public void toggleStrokeMode( ) {
    strokeMode = !strokeMode;
    if ( strokeMode )
      stroke( 0x33, 0xff, 0x00 );
    else
      noStroke( );
  }
}
