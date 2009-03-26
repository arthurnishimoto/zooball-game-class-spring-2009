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
public class FoosballPlayState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;

/**
   * Creates a new FoosballPlayState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballPlayState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
  } // end FoosballPlayState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 20, 200, 20 );
    game.addDebugLine("Play Time: " + timer.getTimeActive());
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
  
  public void init(  ) {
	  timer.reset();
  }

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
    return "Foosball Play State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballPlayState
