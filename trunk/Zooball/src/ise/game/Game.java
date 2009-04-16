package ise.game;

import tacTile.net.*;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public abstract class Game {
  protected GameState state;

/**
   * Creates a new Game object.
   */
  public Game(  ) {} // end Game()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public GameState getGameState(  ) {
    return state;
  } // end getGameState()

  /**
   * Sets the current state of the game
   *
   * @param state the GameState
   */
  public void setState( GameState state ) {
    if ( this.state != null ) {
      this.state.exit(  );
    } // end if

    this.state = state;
    this.state.enter(  );
  } // end setState()

  /**
   * Main game loop. It processes touches, updates the game, then draws the game.
   *
   * @param tacTile DOCUMENT ME!
   */
  public void loop( TouchAPI tacTile ) {
    state.update(  );
    state.draw(  );
    state.input( tacTile ); // Input must be placed after draw to prevent background from covering touches.
  } // end loop()
} // end Game
