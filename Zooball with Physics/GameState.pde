/**
 * Abstract GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.1
 */
abstract class GameState
{
  protected Game game;
  protected Timer timer;
  private volatile int loading;
  private final static int BEFORE = 0;
  private final static int DURING = 1;
  private final static int AFTER = 2;
  
  public GameState( Game game ) {
    this.game = game;
    timer = new Timer( );
    loading = BEFORE;
  }
  
  public boolean isLoading( ) { return loading == DURING; }
  public boolean isLoaded( ) { return loading == AFTER; }
  public final void beginLoad( ) {
    if (loading == BEFORE) {
      loading = DURING;
      
      Runnable loader = new Runnable( ) {
        public void run( ) { load( ); }
      };
      Thread thread = new Thread( loader );
      
      thread.start( );
    }
  }
  protected void load( ) { endLoad( ); }
  protected final void endLoad( ) { loading = AFTER; }
  
  public void reset( ) { timer.reset( ); }
  public void enter( ) { timer.setActive( true ); }
  public void exit( ) { timer.setActive( false ); }
  
  public void input( ) { }
  public void update( ) { timer.update( ); }
  public void draw( ) { }
}
