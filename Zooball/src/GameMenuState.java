import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class GameMenuState implements GameState {
  Game game;

/**
   * Creates a new GameMainMenuState object.
   *
   * @param game DOCUMENT ME!
   */
  public GameMenuState( Game game ) {
    this.game = game;
  } // end GameMenuState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    p.background( 0, 0, 0 );

    if ( game.isDebugMode(  ) ) {
      game.printDebugLine( "Game State: Menu" );
      game.printDebugLine( "Frame Rate: " + (int) ( p.frameRate + 0.5f ) + " f/s" );

      /*
      Random rand = new Random(42);
      String chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ !@#$%^&*()_+-=[]{}:\";',./<>?";
      String str = "";
      for(int line = 0; line < 16; line++) {
        str = "";
        for(int c = 0; c < 32; c++) {
          str += chars.charAt((int)(rand.nextFloat() * chars.length()));
        }
        game.printDebugLine(str);
      }
      */
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
} // end GameMenuState
