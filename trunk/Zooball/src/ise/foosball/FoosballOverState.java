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
public class FoosballOverState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;

/**
   * Creates a new FoosballOverState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballOverState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
  } // end FoosballOverState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 0 );
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
  @Override
  public String toString(  ) {
    return "Foosball Over State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballOverState
