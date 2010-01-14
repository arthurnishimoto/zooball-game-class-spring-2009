/**
 * Foosball Game.
 *
 * Author:  Andy Bursavich
 * Version: 0.4
 */

float screenScale;
float screenOffsetX;
float screenOffsetY;

class Game
{
  private GameState state;
  private IntroState introState;
  private LoadingState loadingState;
  private MenuState menuState;
  private PlayState playState;
  private PausedState pausedState;
  
  private OverState overState;
  private LeavingState leavingState;
  
  private PFont debugFont;
  private boolean debugMode = false;
  private boolean strokeMode = false;
  private final static float DEFAULT_WIDTH = 1920;
  private final static float DEFAULT_HEIGHT = 1080;

  protected PApplet parent;
  
  public Game( PApplet p ) {
    debugFont = loadFont( "data/ui/fonts/Arial Bold-14.vlw" );
    parent = p;
    
    introState = new IntroState( this );
    loadingState = new LoadingState( this );
    menuState = new MenuState( this );
    playState = new PlayState( this );
    pausedState = new PausedState( this );
    overState = new OverState( this );
    leavingState = new LeavingState( this );
    
    introState.beginLoad( );
    menuState.beginLoad( );
    playState.beginLoad( );
    pausedState.beginLoad( );
    overState.beginLoad( );
    leavingState.beginLoad( );
    
    setState( introState );
    //setState( playState );
    
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
    state.update( );
    
    // Translate and Scale
    pushMatrix( );
    if( scaleScreen ){
    translate( screenOffsetX, screenOffsetY );
    scale( screenScale );
    }
    state.draw( );
    debugConsole.draw();
    state.input( ); // Placed after draw so input touches appear on top
    popMatrix( );
  }
  
  public void drawDebugText( String string ) {
    if (debugMode) {
      String[] lines = string.trim( ).split( "\n" );

      textFont( debugFont ); 

      for ( int i = 0; i < lines.length; i++ ) {
        String line = lines[i].trim( );
        if ( !line.equals( "" ) ){
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
  }
  
  /**
   * Reloads the input state
   *
   * @param state - state to be reloaded
   */
  public void reloadState( GameState state ) {
    if ( this.state != null )
      this.state.exit( );
    state.reset();
    state.beginLoad();
    setState(state);
  }// reloadState
  
  public IntroState getIntroState( ) { return introState; }
  public MenuState getMenuState( ) { return menuState; }
  public PlayState getPlayState( ) { return playState; }
  public PausedState getPausedState( ) { return pausedState; }
  
  public OverState getOverState( ) { return overState; }
  public LeavingState getLeavingState( ) { return leavingState; }
  
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
