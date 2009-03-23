import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class GameOverState implements GameState {
  Game game;

/**
   * Creates a new GameOverState object.
   *
   * @param game DOCUMENT ME!
   */
  public GameOverState( Game game ) {
    this.game = game;
  } // end GameOverState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    p.background( 0, 0, 0 );

    if ( game.isDebugMode(  ) ) {
      game.printDebugLine( "Game State: Over" );
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
} // end GameOverState
