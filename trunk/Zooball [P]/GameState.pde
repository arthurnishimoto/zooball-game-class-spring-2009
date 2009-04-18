abstract class GameState
{
  protected Game game;
  protected Timer timer;
  protected volatile boolean loaded;
  
  public GameState( Game game ) {
    this.game = game;
    timer = new Timer( );
    loaded = false;
  }

  public boolean isLoaded( ) { return loaded; }
  public void load( ) { loaded = true; }
  
  public void enter( ) { timer.setActive( true ); }
  public void exit( ) { timer.setActive( false ); }
  
  public void input( ) { }
  public void update( ) { timer.update( ); }
  public void draw( ) { }
}
