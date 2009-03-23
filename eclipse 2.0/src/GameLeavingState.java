import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class GameLeavingState implements GameState {
  private static int WAIT = 2000;
  private Game game;
  private Timer timer;

/**
   * Creates a new GameLeavingState object.
   *
   * @param game DOCUMENT ME!
   */
  public GameLeavingState( Game game ) {
    this.game = game;
    timer = new Timer(  );
  } // end GameLeavingState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    p.background( 0 );

    // TODO: thanks for playing, blah, blah, blah...
    if ( game.isDebugMode(  ) ) {
      game.printDebugLine( "Game State: Leaving" );
      game.printDebugLine( "Frame Rate: " + (int) ( p.frameRate + 0.5f ) + " f/s" );
      game.printDebugLine( "Timer: " + timer.getTimeActive(  ) );
    } // end if
  } // end draw()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void enter( PApplet p ) {
    timer.setActive( true );
  } // end enter()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void exit( PApplet p ) {
    timer.setActive( false );
  } // end exit()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( PApplet p, TouchAPI tacTile ) {} // end input()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void update( PApplet p ) {
    timer.update(  );

    if ( timer.getMillisecondsActive(  ) >= WAIT ) {
      p.exit(  );
    } // end if
  } // end update()
} // end GameLeavingState
