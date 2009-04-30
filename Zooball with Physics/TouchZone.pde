public class TouchZone implements Touchable
{
  private int MAX_TOUCHES = 10;
  private Vector2D position, size;
  private Vector2D[] touches;
  private long[] times;
  private long lastTime;
  private int count;
  
  public TouchZone( double x, double y, double width, double height ) {
    position = new Vector2D( x, y );
    size = new Vector2D( width, height );
    touches = new Vector2D[MAX_TOUCHES];
    for ( int i = 0; i < MAX_TOUCHES; i++ )
      touches[i] = new Vector2D( );
    times = new long[MAX_TOUCHES];
    count = 0;
  }
  
  public boolean contains( Vector2D touch ) {
    return ( touch.x >= position.x ) && ( touch.y >= position.y ) && ( touch.x <= position.x + size.x ) && ( touch.y <= position.y + size.y );
  }
  
  public void clear( ) {
    lastTime = 0;
  }

  public void touch( int id, Vector2D position, long touchTime, long timeNow ) {
    for ( int i = MAX_TOUCHES-2, k = MAX_TOUCHES-1; i >= 0; i--, k-- ) {
      touches[k].x = touches[i].x;
      touches[k].y = touches[i].y;
      times[k] = times[i];
    }
    touches[0].x = position.x;
    touches[0].y = position.y;
    times[0] = touchTime;
    lastTime = timeNow;
    if (count < MAX_TOUCHES )
      count++;
  }
  
  public Vector2D getVelocity( long time ) {
    long minTime = time - 250000; // -0.25 seconds
    if ( lastTime < minTime )
      return null;
    minTime = times[0] - 500000; // -0.5 seconds
    int oldest = 0;
    for ( int i = 1; i < count; i++ ) {
      if ( times[i] >= minTime )
        oldest = i;
      else
        break;
    }
    double dt = ( times[0] - times[oldest] ) / (double)1000.0;
    if ( dt == 0 )
      return new Vector2D( 0, 0 );
    double dx = touches[0].x - touches[oldest].x;
    double dy = touches[0].y - touches[oldest].y;
    return new Vector2D( dy/size.y*PI/dt, dy/dt );
  }
}
