class Game
{
  private GameState state;
  private LoadingState loadingState;
  private MenuState menuState;
  /*
  private PlayState playState;
  private PausedState pausedState;
  private OverState overState;
  private LeavingState leavingState;
  */
  private boolean debugMode = false;
  
  public Game( ) {
    loadingState = new LoadingState( this );
    menuState = new MenuState( this );
    setState( menuState );
  }
  
  public void loop( ) {
    state.input( );
    state.update( );
    state.draw( );
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
      setState( loadingState );
    }
  }
  
  public LoadingState getLoadingState( ) { return loadingState; }
  public MenuState getMenuState( ) { return menuState; }
  /*
  public PlayState getPlayState( ) { return playState; }
  public PausedState getPausedState( ) { return pausedState; }
  public OverState getOverState( ) { return overState; }
  public LeavingState getLeavingState( ) { return leavingState; }
  */
  
  public boolean isDebugMode( ) { return debugMode; }
  public void toggleDebugMode( ) { debugMode = !debugMode; }
}
