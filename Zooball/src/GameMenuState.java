import processing.core.PApplet;
import processing.core.PConstants;

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

    // TODO: don't use debug font, make this pretty and mirror to both directions
    p.pushMatrix(  );
    p.fill( 255 );
    p.translate( p.width / 2, p.height / 2 );
    p.textAlign( PConstants.CENTER );
    p.textFont( game.getDebugFont(  ), 32 );
    p.text( "Menu", 0, p.textAscent(  ) / 2 );
    /*
    p.stroke(255, 0, 0);
    p.strokeWeight(1.0f);
    p.line(-100, 0, 100, 0);
    p.line(0, -100, 0, 100);
    p.line(-100, -100, 100, 100);
    p.line(-100, 100, 100, -100);
    */
    p.popMatrix(  );

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
