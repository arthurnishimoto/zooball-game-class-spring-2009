package ise.utilities;

/**
 * Timer intended to track time elapsed
 *
 * @author Andy Bursavich
 * @version 0.2
 */
public class Timer {
  private boolean active;
  private int activeTime;
  private int inactiveTime;
  private int lastTime;

/**
   * Creates a new Timer object.
   */
  public Timer(  ) {
    reset(  );
  } // end Timer()

  /**
   * Sets active state of timer. If the new state is different from the current state, an
   * update occurs.
   *
   * @param active the new state
   */
  public void setActive( boolean active ) {
    int time = getTime(  );

    if ( active && !this.active ) {
      inactiveTime += ( time - lastTime );
      lastTime = time;
      this.active = true;
    } // end if
    else if ( !active && this.active ) {
      activeTime += ( time - lastTime );
      lastTime = time;
      this.active = false;
    } // end else if
  } // end setActive()

  /**
   * Gets the active state of this Timer.
   *
   * @return true if this Timer has been started and not stopped, false if this Timer has not been
   *         started or has been stopped
   */
  public boolean isActive(  ) {
    return active;
  } // end isActive()

  /**
   * Gets the milliseconds that this Timer has been active
   *
   * @return DOCUMENT ME!
   */
  public int getMillisecondsActive(  ) {
    return activeTime;
  } // end getMillisecondsActive()

  /**
   * Gets the milliseconds that this Timer has been inactive, includes time before starting
   * and time after stopping
   *
   * @return milliseconds
   */
  public int getMillisecondsInactive(  ) {
    return inactiveTime;
  } // end getMillisecondsInactive()

  /**
   * Gets the seconds that this Timer has been active
   *
   * @return seconds
   */
  public float getSecondsActive(  ) {
    return activeTime / 1000.0f;
  } // end getSecondsActive()

  /**
   * Gets seconds that this Timer has been inactive, includes time before starting and time
   * after stopping
   *
   * @return seconds
   */
  public float getSecondsInactive(  ) {
    return inactiveTime / 1000.0f;
  } // end getSecondsInactive()

  /**
   * Gets the time that this Timer has been active
   *
   * @return String in the format MM:SS.S
   */
  public String getTimeActive(  ) {
    return timeToString( activeTime );
  } // end getTimeActive()

  /**
   * Gets the time that this Timer has been inactive
   *
   * @return String in the format MM:SS.S
   */
  public String getTimeInactive(  ) {
    return timeToString( inactiveTime );
  } // end getTimeInactive()

  /**
   * Resets Timer
   */
  public void reset(  ) {
    active = false;
    activeTime = 0;
    inactiveTime = 0;
    lastTime = getTime(  );
  } // end reset()

  /**
   * Updates Timer
   */
  public void update(  ) {
    int time = getTime(  );

    if ( active ) {
      activeTime += ( time - lastTime );
    } // end if
    else {
      inactiveTime += ( time - lastTime );
    } // end else

    lastTime = time;
  } // end update()

  /**
   * Returns the current value of the most precise available system timer, in milliseconds.
   * This method can only be used to measure elapsed time and is not related to any other notion
   * of system or wall-clock time. The value returned represents milliseconds since some fixed but
   * arbitrary time (perhaps in the future, so values may be negative). This method provides
   * millisecond precision, but not necessarily millisecond accuracy. No guarantees are made about
   * how frequently values change.
   *
   * @return The current value of the system timer, in milliseconds.
   */
  private int getTime(  ) {
    return (int) ( System.nanoTime(  ) / 1000000 );
  } // end getTime()

  /**
   * Converts time in milliseconds to a String in the format MM:SS.S
   *
   * @param time milliseconds
   *
   * @return String in the format MM:SS.S
   */
  private String timeToString( int time ) {
    return String.format( "%02d:%04.1f", time / 60000, ( time % 60000 ) / 1000.0f );
  } // end timeToString()
} // end Timer
