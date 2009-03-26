package ise.ui;

import ise.utilities.Timer;

import processing.core.PApplet;
import processing.core.PConstants;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class RotatingMirroredLabel extends MirroredLabel {
  private Timer timer;
  private float radiansPerSecond;

/**
   * Creates a new RotatingLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public RotatingMirroredLabel( PApplet p, String text, float x, float y ) {
    super( p, text, x, y );

    // TODO Auto-generated constructor stub
  } // end RotatingMirroredLabel()

/**
   * Creates a new RotatingLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public RotatingMirroredLabel( PApplet p, String[] text, float x, float y ) {
    super( p, text, x, y );

    // TODO Auto-generated constructor stub
  } // end RotatingMirroredLabel()

/**
   * Creates a new RotatingLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public RotatingMirroredLabel( PApplet p, String text, Font font, float x, float y ) {
    super( p, text, font, x, y );

    // TODO Auto-generated constructor stub
  } // end RotatingMirroredLabel()

/**
   * Creates a new RotatingLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public RotatingMirroredLabel( PApplet p, String[] text, Font font, float x, float y ) {
    super( p, text, font, x, y );

    // TODO Auto-generated constructor stub
  } // end RotatingMirroredLabel()

/**
   * Creates a new RotatingLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public RotatingMirroredLabel( PApplet p, String text, Font font, float x, float y, float width,
                                float height ) {
    super( p, text, font, x, y, width, height );

    // TODO Auto-generated constructor stub
  } // end RotatingMirroredLabel()

/**
   * Creates a new RotatingLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public RotatingMirroredLabel( PApplet p, String[] text, Font font, float x, float y, float width,
                                float height ) {
    super( p, text, font, x, y, width, height );

    // TODO Auto-generated constructor stub
  } // end RotatingMirroredLabel()

  /**
   * Sets the revolutions the Label will make per second.
   *
   * @param revolutions Revolutions per second. Positive values cause clockwise rotation. Negative
   *        values cause counter-clockwise rotation.
   */
  public void setRevolutionsPerSecond( float revolutions ) {
    radiansPerSecond = PConstants.TWO_PI * revolutions;
  } // end setRevolutionsPerSecond()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param timer DOCUMENT ME!
   */
  public void setTimer( Timer timer ) {
    this.timer = timer;
  } // end setTimer()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public Timer getTimer(  ) {
    return timer;
  } // end getTimer()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    setRotation( timer.getSecondsActive(  ) * radiansPerSecond );
  } // end update()
} // end RotatingMirroredLabel
