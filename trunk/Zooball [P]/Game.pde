/**
 * Foosball Game.
 *
 * Author:  Andy Bursavich
 * Version: 0.1
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
  
  public Game( ) {
    debugFont = loadFont( "ui\\fonts\\Arial Bold-14.vlw" );
    
    loadingState = new LoadingState( this );
    menuState = new MenuState( this );
    playState = new PlayState( this );
    pausedState = new PausedState( this );
    
    menuState.beginLoad( );
    //playState.beginLoad( );
    pausedState.beginLoad( );
    setState( pausedState );
  }
  
  public void loop( ) {
    state.input( );
    state.update( );
    state.draw( );
  }
  
  public void drawDebugText( String string ) {
    String[] lines = string.trim( ).split( "\n" );

    textFont( debugFont ); 
    fill( 255 );
    for ( int i = 0; i < lines.length; i++ ) {
      String line = lines[i].trim( );
      if ( !line.equals( "" ) )
        text( line, 15, 20 + i * 15 );
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
  
  //public LoadingState getLoadingState( ) { return loadingState; }
  public MenuState getMenuState( ) { return menuState; }
  public PlayState getPlayState( ) { return playState; }
  public PausedState getPausedState( ) { return pausedState; }
  /*
  public OverState getOverState( ) { return overState; }
  public LeavingState getLeavingState( ) { return leavingState; }
  */
  
  public boolean isDebugMode( ) { return debugMode; }
  public void toggleDebugMode( ) { debugMode = !debugMode; }
}
