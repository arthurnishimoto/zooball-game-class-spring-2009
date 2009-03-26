package ise.game;

import tacTile.net.*;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
  */
public interface GameState {
  /**
   * DOCUMENT ME!
   */
  public void draw(  );

  /**
   * DOCUMENT ME!
   */
  public void enter(  );

  /**
   * DOCUMENT ME!
   */
  public void exit(  );

  /**
   * DOCUMENT ME!
   *
   * @param tacTile DOCUMENT ME!
   */
  public void input( TouchAPI tacTile );

  /**
   * DOCUMENT ME!
   */
  public void update(  );
} // end GameState
