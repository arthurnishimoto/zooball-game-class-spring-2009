import processing.core.PApplet;

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
   *
   * @param p DOCUMENT ME!
   */
  public void draw( PApplet p );

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void enter( PApplet p );

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void exit( PApplet p );

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   * @param tacTile DOCUMENT ME!
   */
  public void input( PApplet p, TouchAPI tacTile );

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void update( PApplet p );
} // end GameState
