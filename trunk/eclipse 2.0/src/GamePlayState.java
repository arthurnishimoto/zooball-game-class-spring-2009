import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class GamePlayState implements GameState {
  Game game;
  Timer timer;

/**
   * Creates a new GamePlayingState object.
   *
   * @param game DOCUMENT ME!
   */
  public GamePlayState( Game game ) {
    this.game = game;
    timer = new Timer(  );
  } // end GamePlayState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    p.background( 20, 200, 20 );

    // draw some lines to test pause blur
    p.strokeWeight( 10.0f );
    p.stroke( 200 );

    for ( int i = 0; i < 9; i++ ) {
      float x = 50.0f + ( ( i * ( p.width - 100.0f ) ) / 8.0f );
      p.line( x, 0, x, p.height );
    } // end for

    if ( game.isDebugMode(  ) ) {
      game.printDebugLine( "Game State: Playing" );
      game.printDebugLine( "Frame Rate: " + (int) ( p.frameRate + 0.5f ) + " f/s" );
      game.printDebugLine( "Playing Time: " + timer.getTimeActive(  ) );
      game.printDebugLine( "Inactive Time: " + timer.getTimeInactive(  ) );
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
    // TODO Auto-generated method stub
    timer.setActive( false );
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
    timer.update(  );
  } // end update()
} // end GamePlayState
