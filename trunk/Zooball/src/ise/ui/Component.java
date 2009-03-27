package ise.ui;

import ise.math.Vector2D;

import ise.utilities.Timer;

import processing.core.PApplet;
import processing.core.PConstants;


/**
 * A component is an object having a graphical representation that can be displayed on the
 * screen and that can interact with the user. Examples of components are the labels, buttons,
 * checkboxes, and images of a typical graphical user interface.
 *
 * @author Andy Bursavich
 * @version 0.2
 */
public abstract class Component {
  public static final int LEFT = 0;
  public static final int CENTER = 1;
  public static final int RIGHT = 2;
  public static final int TOP = 3;
  public static final int MIDDLE = 4;
  public static final int BOTTOM = 5;
  protected PApplet p;
  protected Timer timer;
  protected boolean visible = true;
  protected float height = 0;
  protected float preferredHeight = 0;
  protected float preferredWidth = 0;
  protected float radiansPerSecond = 0;
  protected float rotation = 0;
  protected float rotationFacing = 0;
  protected float width = 0;
  protected float x = 0;
  protected float y = 0;
  protected int horizontalAnchor = CENTER;
  protected int verticalAnchor = MIDDLE;

/**
   * Creates a new Component object.
   *
   * @param p DOCUMENT ME!
   */
  public Component( PApplet p ) {
    this.p = p;
  } // end Component()

  /**
   * Sets the anchor of this Component. The anchor affects the location and rotation of the
   * Component.
   *
   * @param horizontal The horizontal anchor to set for this Component. Possible values: LEFT,
   *        CENTER, RIGHT.
   * @param vertical The vertical anchor to set for this Component. Possible values: TOP, MIDDLE,
   *        BOTTOM.
   */
  public void setAnchor( int horizontal, int vertical ) {
    horizontalAnchor = horizontal;
    verticalAnchor = vertical;
  } // end setAnchor()

  /**
   * Sets the rotation of this Component to face the provided direction.
   *
   * @param direction The direction of the Component to face. Possible values: BOTTOM, TOP, LEFT,
   *        RIGHT.
   */
  public void setFacingDirection( int direction ) {
    if ( direction == BOTTOM ) {
      rotationFacing = 0f;
    } // end if
    else if ( direction == TOP ) {
      rotationFacing = PConstants.PI;
    } // end else if
    else if ( direction == RIGHT ) {
      rotationFacing = PConstants.PI + PConstants.HALF_PI;
    } // end else if
    else { // LEFT
      rotationFacing = PConstants.HALF_PI;
    } // end else
  } // end setFacingDirection()

  /**
   * Gets the height of this Component.
   *
   * @return The height of this Component.
   */
  public float getHeight(  ) {
    return height;
  } // end getHeight()

  /**
   * Sets the horizontal anchor of this Component. The anchor affects the location and
   * rotation of the Component.
   *
   * @param horizontalAnchor The horizontal anchor to set for this Component. Possible values:
   *        LEFT, CENTER, RIGHT.
   */
  public void setHorizontalAnchor( int horizontalAnchor ) {
    this.horizontalAnchor = horizontalAnchor;
  } // end setHorizontalAnchor()

  /**
   * Gets the horizontal anchor of this Component.
   *
   * @return The horizontal anchor of this Component. Possible values: LEFT, CENTER, RIGHT.
   */
  public int getHorizontalAnchor(  ) {
    return horizontalAnchor;
  } // end getHorizontalAnchor()

  /**
   * Sets the location of this Component.
   *
   * @param location The Vector2D representing the location of this component.
   */
  public void setLocation( Vector2D location ) {
    x = location.x;
    y = location.y;
  } // end setLocation()

  /**
   * Sets the location of this Component.
   *
   * @param x The x value of the location.
   * @param y The y value of the location.
   */
  public void setLocation( float x, float y ) {
    this.x = x;
    this.y = y;
  } // end setLocation()

  /**
   * Gets the location of this Component.
   *
   * @return The Vector2D representing the location of this Component.
   */
  public Vector2D getLocation(  ) {
    return new Vector2D( x, y );
  } // end getLocation()

  /**
   * Sets the preferred height for this Component. The component decides whether or not to
   * honor the request. For example, if the preferred height is too small for a Label to display
   * its text in its font, the Label will set its height to the smallest possible to fit its text.
   *
   * @param height The preferred height.
   */
  public void setPreferredHeight( float height ) {
    preferredHeight = height;
  } // end setPreferredHeight()

  /**
   * Gets the preferred height of this component.
   *
   * @return This component's preferred height.
   */
  public float getPreferredHeight(  ) {
    return preferredHeight;
  } // end getPreferredHeight()

  /**
   * Sets the preferred size for this Component. The component decides whether or not to
   * honor the request. For example, if the preferred height is too small for a Label to display
   * its text in its font, the Label will set its height to the smallest possible to fit its text.
   *
   * @param size The preferred size. The x value represents width. The y value represents height.
   */
  public void setPreferredSize( Vector2D size ) {
    preferredWidth = size.x;
    preferredHeight = size.y;
  } // end setPreferredSize()

  /**
   * Sets the preferred size for this Component. The component decides whether or not to
   * honor the request. For example, if the preferred height is too small for a Label to display
   * its text in its font, the Label will set its height to the smallest possible to fit its text.
   *
   * @param width The preferred width.
   * @param height The preferred height.
   */
  public void setPreferredSize( float width, float height ) {
    preferredWidth = width;
    preferredHeight = height;
  } // end setPreferredSize()

  /**
   * Gets the preferred size of this Component.
   *
   * @return A Vector2D representing the preferred size. The x value represents width. The y value
   *         represents height.
   */
  public Vector2D getPreferredSize(  ) {
    return new Vector2D( preferredWidth, preferredHeight );
  } // end getPreferredSize()

  /**
   * Sets the preferred width for this Component. The component decides whether or not to
   * honor the request. For example, if the preferred width is too small for a Label to display
   * its text in its font, the Label will set its width to the smallest possible to fit its text.
   *
   * @param width The preferred width.
   */
  public void setPreferredWidth( float width ) {
    preferredWidth = width;
  } // end setPreferredWidth()

  /**
   * Gets the preferred width of this Component.
   *
   * @return The preferred width.
   */
  public float getPreferredWidth(  ) {
    return preferredWidth;
  } // end getPreferredWidth()

  /**
   * Gets the rotation of this Component relative to its facing direction.
   *
   * @return The rotation of this Component in radians.
   */
  public float getRotation(  ) {
    return rotation;
  } // end getRotation()

  /**
   * Gets the size of this Component.
   *
   * @return The Vector2D representing the size of this Component.
   */
  public Vector2D getSize(  ) {
    return new Vector2D( width, height );
  } // end getSize()

  /**
   * Sets the vertical anchor of this Component. The anchor affects the location and rotation
   * of the Component.
   *
   * @param verticalAnchor The vertical anchor of this Component. Possible values: TOP, MIDDLE,
   *        BOTTOM.
   */
  public void setVerticalAnchor( int verticalAnchor ) {
    this.verticalAnchor = verticalAnchor;
  } // end setVerticalAnchor()

  /**
   * Gets the vertical anchor of this Component.
   *
   * @return The vertical anchor of this Component. Possible values: TOP, MIDDLE, BOTTOM.
   */
  public int getVerticalAnchor(  ) {
    return verticalAnchor;
  } // end getVerticalAnchor()

  /**
   * Sets the visibility of this Component.
   *
   * @param visible The visibility of this Component.
   */
  public void setVisible( boolean visible ) {
    this.visible = visible;
  } // end setVisible()

  /**
   * Gets the visibility of this Component.
   *
   * @return The visibility of this Component.
   */
  public boolean isVisible(  ) {
    return visible;
  } // end isVisible()

  /**
   * This method must be implemented to draw the component.
   */
  public final void draw(  ) {
    if ( visible ) {
      float xTranslation = 0;
      float yTranslation = 0;
      float zRotation = rotationFacing + rotation;

      if ( timer != null ) {
        zRotation += ( radiansPerSecond * timer.getSecondsActive() );
      }

      p.pushMatrix(  );

      p.translate( this.x, this.y );
      p.rotateZ( zRotation );

      // If verticalAnchor == TOP, do nothing
      if ( verticalAnchor == MIDDLE ) {
        yTranslation = -0.5f * height;
      } // end if
      else if ( verticalAnchor == BOTTOM ) {
        yTranslation = -height;
      } // end else if

      // If horizontalAnchor == LEFT, do nothing
      if ( horizontalAnchor == CENTER ) {
        xTranslation = -0.5f * width;
      } // end if
      else if ( horizontalAnchor == RIGHT ) {
        xTranslation = -width;
      } // end else if

      p.translate( xTranslation, yTranslation );

      /*
         // DEBUG - Box Around Component
         p.stroke( 225, 0, 0 );
         p.fill( 0, 0, 0, 0 );
         p.rect( 0, 0, width, height );
         // END DEBUG
       */
      drawComponent(  );

      p.popMatrix(  );
    } // end if
  } // end draw()

  /**
   * Sets the current rotation of this Component. If
   *
   * @param rotation DOCUMENT ME!
   */
  public void setRotation( float rotation ) {
    this.rotation = rotation;
  } // end setRotation()

  /**
   * Sets the revolutions the Label will make per second. The Timer must also be set for rotation to occur.
   *
   * @param revolutionsPerSecond Revolutions per second. Positive values result in clockwise
   *        rotation. Negative values result in counter-clockwise rotation.
   */
  public void setRevolutionsPerSecond( float revolutionsPerSecond ) {
    this.radiansPerSecond = PConstants.TWO_PI * revolutionsPerSecond;
  } // end setRotationsPerSecond()
  
  /**
   * Sets the revolutions the Label will make per second.
   *
   * @param revolutionsPerSecond Revolutions per second. Positive values result in clockwise
   *        rotation. Negative values result in counter-clockwise rotation.
   * @param timer The timer used to rotate the Component. Rotation only occurs while the Timer is active.
   */
  public void setRevolutionsPerSecond( float revolutionsPerSecond, Timer timer ) {
	this.timer = timer;
	setRevolutionsPerSecond(revolutionsPerSecond);
  } // end setRotationsPerSecond()

  /**
   * Sets the timer associated with this Component. The Timer is used to calculate rotation but may also be used for other animation purposes.
   * 
   * @param timer The Timer.
   */
  public void setTimer(Timer timer) {
	  this.timer = timer;
  }
  
  /**
   * Gets the timer associated with this Component. The Timer is used to calculate rotation but may also be used for other animation purposes.
   * 
   * @param timer The Timer.
   */
  public void getTimer(Timer timer) {
	  
  }

  /**
   * Gets the width of this Component.
   *
   * @return The width of this Component.
   */
  public float getWidth(  ) {
    return width;
  } // end getWidth()

  /**
   * Sets the x location of this Component's anchor point.
   *
   * @param x The value to set as the x location of this Component's anchor point.
   */
  public void setX( float x ) {
    this.x = x;
  } // end setX()

  /**
   * Gets the x location of this Component's anchor point.
   *
   * @return The x location of this Component's anchor point.
   */
  public float getX(  ) {
    return x;
  } // end getX()

  /**
   * Sets the y location of this Component's anchor point.
   *
   * @param y The value to set as the x location of this Component's anchor point.
   */
  public void setY( float y ) {
    this.y = y;
  } // end setY()

  /**
   * Gets the y location of this Component's anchor point.
   *
   * @return The y location of this Component's anchor point.
   */
  public float getY(  ) {
    return y;
  } // end getY()

  /**
   * This draws the Component. When called, the PApplet's current transformation matrix is
   * such that it is position and rotated as necessary to draw the Component. The top left of the
   * Component should be drawn at (0, 0) and the bottom right should be drawn at (width,height).
   */
  protected abstract void drawComponent(  );
} // end Component
