import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class GamePausedState implements GameState {
  Game game;

/**
   * Creates a new GamePausedState object.
   *
   * @param game DOCUMENT ME!
   */
  public GamePausedState( Game game ) {
    this.game = game;
  } // end GamePausedState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    // capture debug mode
    boolean debug = game.isDebugMode(  );

    // turn off debug mode
    if ( debug ) {
      game.toggleDebugMode(  );
    } // end if

    // draw underlying game, without debug mode
    game.getPlayState(  ).draw( p );

    // reset debug mode
    if ( debug ) {
      game.toggleDebugMode(  );
    } // end if

    // draw black translucent overlay
    p.fill( 0, 0, 0, 128 );
    p.rect( 0, 0, p.width, p.height );

    // TODO: draw PAUSED/RESUME button (?)

    // draw debug text
    if ( debug ) {
      game.printDebugLine( "Game State: Paused" );
      game.printDebugLine( "Frame Rate: " + (int) ( p.frameRate + 0.5f ) + " f/s" );
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
    // TODO Auto-generated method stub
  } // end update()
} // end GamePausedState