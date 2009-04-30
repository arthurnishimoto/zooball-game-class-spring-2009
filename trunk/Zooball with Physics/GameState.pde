/**
 * Abstract GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.1
 */
abstract class GameState
{
  protected Game game;
  protected TouchAPI tacTile;
  protected Timer timer;
  protected Touchable[] touchables;
  private volatile int loading;
  private final static int BEFORE = 0;
  private final static int DURING = 1;
  private final static int AFTER = 2;
  
  public GameState( Game game, TouchAPI tacTile ) {
    this.game = game;
    this.tacTile = tacTile;
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
  
  public void input( ) {
    if ( touchables != null && tacTile != null ){
      long timeNow = timer.getMicrosecondsActive( );
      for ( int i = 0; i < touchables.length; i++ )
        touchables[i].clear( );
      ArrayList touches = tacTile.getManagedList( );
      Iterator iterator = touches.listIterator( );
      while( iterator.hasNext( ) ) {
        Touches touch = (Touches)iterator.next( );
        Vector2D vector = new Vector2D( touch.getXPos( )*1920, (1-touch.getYPos( ))*1080 );
        for ( int i = 0; i < touchables.length; i++ ) {
          if ( touchables[i].contains( vector ) )
            touchables[i].touch( touch.getFinger( ), vector, touch.getTimeStamp( ), timeNow );
        }
        fill( 255, 0, 0 );
        ellipse( (float)vector.x, (float)vector.y, 10, 10 );
      }
    }
  }
  private void touchToVector( Touches touch, Vector2D vector ) {

  }
  
  public void update( ) { timer.update( ); }
  public void draw( ) { }
}
