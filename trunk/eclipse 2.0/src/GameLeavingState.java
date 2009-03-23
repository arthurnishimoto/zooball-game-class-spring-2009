import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class GameLeavingState implements GameState {
  private static int WAIT = 2000;
  private Game game;
  private int begin;
  private int elapsed;

/**
   * Creates a new GameLeavingState object.
   *
   * @param game DOCUMENT ME!
   */
  public GameLeavingState( Game game ) {
    this.game = game;
    elapsed = 0;
  } // end GameLeavingState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    p.background( 0 );

    if ( game.isDebugMode(  ) ) {
      game.printDebugLine( "Game State: Leaving" );
      game.printDebugLine( String.format( "Framerate: %2d", (int) ( p.frameRate + 0.5f ) ) );
    } // end if
  } // end draw()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void enter( PApplet p ) {
    // TODO Auto-generated method stub
  } // end enter()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void exit( PApplet p ) {
    // TODO Auto-generated method stub
  } // end exit()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( PApplet p, TouchAPI tacTile ) {
    // TODO Auto-generated method stub
  } // end input()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void update( PApplet p ) {
    int time = p.millis(  );

    if ( begin == -1 ) {
      begin = time;
      elapsed = 0;
    } // end if
    else {
      elapsed = time - begin;

      if ( elapsed >= WAIT ) {
        p.exit(  );
      } // end if
    } // end else
  } // end update()
} // end GameLeavingState
