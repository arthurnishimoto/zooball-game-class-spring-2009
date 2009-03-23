import processing.core.PApplet;
import processing.core.PConstants;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
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
    p.background( 0 );

    // TODO: don't use debug font, make this pretty and mirror to both directions
    p.pushMatrix(  );
    p.fill( 255 );
    p.translate( p.width / 2, p.height / 2 );
    p.textAlign( PConstants.CENTER );
    p.textFont( game.getDebugFont(  ), 32 );
    p.text( "Game Over", 0, p.textAscent(  ) / 2 );
    p.popMatrix(  );

    // TODO: draw PAUSED/RESUME button (?)

    // draw debug text
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
