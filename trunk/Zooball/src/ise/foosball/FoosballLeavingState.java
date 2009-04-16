package ise.foosball;

import ise.game.GameState;

import ise.ui.Font;
import ise.ui.MirroredLabel;

import ise.utilities.Timer;

import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.2
 */
public class FoosballLeavingState implements GameState {
  private FoosballGame game;
  private MirroredLabel mlblLeaving;
  private PApplet p;
  private Timer timer;

/**
   * Creates a new FoosballLeavingState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballLeavingState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
    mlblLeaving = new MirroredLabel( p,
                                     new String[] {
                                       "Thanks for playing ZOOBALL!", "Infinite State Entertainment"
                                     }, Font.getInstance( p, "Arial", 36 ), p.width * 0.5f,
                                     p.height * 0.5f );
    mlblLeaving.setPadding(0, 0, 20, 0);
  } // end FoosballLeavingState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 0 );
    mlblLeaving.draw(  );
  } // end draw()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void enter(  ) {
    timer.setActive( true );
  } // end enter()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void exit(  ) {
    timer.setActive( false );
  } // end exit()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( TouchAPI tacTile ) {}

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public String toString(  ) {
    return "Foosball Leaving State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );

    if ( timer.getMillisecondsActive(  ) >= 2000 ) {
      System.exit( 0 );
    } // end if
    else if ( game.isDebugMode(  ) ) {
      game.addDebugLine( "Timer: " + timer.getTimeActive(  ) );
    } // end else if
  } // end update()
} // end FoosballLeavingState
