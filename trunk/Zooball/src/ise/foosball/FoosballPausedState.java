package ise.foosball;

import ise.game.GameState;

import ise.utilities.Timer;

import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class FoosballPausedState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;

/**
   * Creates a new FoosballPausedState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballPausedState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
  } // end FoosballPausedState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    // draw underlying game
    game.getPlayState(  ).draw(  );

    // draw black translucent overlay
    p.fill( 0, 0, 0, 128 );
    p.rect( 0, 0, p.width, p.height );

    // TODO: draw PAUSED/RESUME button (?)

    // Add debug text
    if ( game.isDebugMode(  ) ) {
      //game.addDebugLine( "PAUSED DEBUG TEXT" );
    } // end if
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
    return "Foosball Paused State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballPausedState
