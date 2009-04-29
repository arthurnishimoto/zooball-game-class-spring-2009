/**
 * Timer intended to track time elapsed.
 *
 * Author:  Andy Bursavich
 * Version: 1.0
 */
class Timer {
  private boolean active;
  private long activeTime;
  private long inactiveTime;
  private long lastTime;

  /**
   * Creates a new Timer object.
   */
  public Timer( ) { reset( ); }
  
  /**
   * Returns the current value of the most precise available system timer, in milliseconds.
   * This method can only be used to measure elapsed time and is not related to any other notion
   * of system or wall-clock time. The value returned represents milliseconds since some fixed but
   * arbitrary time (perhaps in the future, so values may be negative). This method provides
   * millisecond precision, but not necessarily millisecond accuracy. No guarantees are made about
   * how frequently values change.
   */
  private long getTime( ) { return System.nanoTime( ) / 1000; }
  
  public void reset( ) {
    active = false;
    activeTime = 0;
    inactiveTime = 0;
    lastTime = getTime( );
  }

  public void update( ) {
    long time = getTime( );

    if ( active ) activeTime += ( time - lastTime );
    else inactiveTime += ( time - lastTime );

    lastTime = time;
  }

  /**
   * Sets active state of timer. If the new state is different from the current state, an
   * update occurs.
   */
  public void setActive( boolean active ) {
    long time = getTime( );

    if ( active && !this.active ) {
      inactiveTime += ( time - lastTime );
      lastTime = time;
      this.active = true;
    }
    else if ( !active && this.active ) {
      activeTime += ( time - lastTime );
      lastTime = time;
      this.active = false;
    }
  }
  public boolean isActive( ) { return active; }

  private String timeToString( long time ) { return String.format( "%02d:%04.1f", time / 60000000, ( time % 60000000 ) / 1000.0f ); }
  
  public long getMicrosecondsActive( ) { return activeTime; }
  public double getSecondsActive( ) { return activeTime / 1000000.0f; }
  public String getTimeActive( ) { return timeToString( activeTime ); }
  
  public long getMicrosecondsInactive( ) { return inactiveTime; }
  public double getSecondsInactive( ) { return inactiveTime / 1000000.0f; }
  public String getTimeInactive( ) { return timeToString( inactiveTime ); }
}

