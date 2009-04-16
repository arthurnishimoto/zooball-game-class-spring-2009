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
 * @version 0.1
 */
public class FoosballMenuState implements GameState {
  private FoosballGame game;
  private MirroredLabel mlblMenu;
  private PApplet p;
  private Timer timer;

/**
   * Creates a new FoosballMenuState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballMenuState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
    mlblMenu = new MirroredLabel( p, "ZOOBALL", Font.getInstance( p, "Arial", 36 ), p.width * 0.5f,
                                  p.height * 0.5f );
    mlblMenu.setPadding(0, 0, 10, 0);
  } // end FoosballMenuState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 0, 0x33, 0x66 );
    mlblMenu.draw(  );
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
    return "Foosball Menu State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballMenuState
