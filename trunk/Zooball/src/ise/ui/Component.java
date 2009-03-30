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
  public static final int CENTER = 4;
  public static final int RIGHT = 1;
  public static final int TOP = 2;
  public static final int MIDDLE = 5;
  public static final int BOTTOM = 3;
  protected PApplet p;
  protected Padding padding;
  protected Timer timer;
  protected boolean visible = true;
  protected float borderSize;
  protected float height = 0;
  protected float preferredHeight = 0;
  protected float preferredWidth = 0;
  protected float radiansPerSecond = 0;
  protected float rotation = 0;
  protected float rotationFacing = 0;
  protected float width = 0;
  protected float x = 0;
  protected float y = 0;
  protected int backgroundColor;
  protected int borderColor;
  protected int foregroundColor;
  protected int horizontalAnchor = CENTER;
  protected int verticalAnchor = MIDDLE;

/**
   * Creates a new Component object.
   *
   * @param p The Processing sketch.
   */
  public Component( PApplet p ) {
    this.p = p;
    padding = new Padding();
    backgroundColor = p.color( 255, 255, 255, 0 );
    foregroundColor = p.color( 255, 255, 255 );
    borderColor = p.color( 255, 255, 255 );
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
   * Sets the background color. The default is transparent.
   *
   * @param backgroundColor The background color.
   */
  public void setBackgroundColor( int backgroundColor ) {
    this.backgroundColor = backgroundColor;
  } // end setBackgroundColor()

  /**
   * Sets the background color. The default is transparent.
   *
   * @param red The red value of the color.
   * @param green The green value of the color.
   * @param blue The blue value of the color.
   */
  public void setBackgroundColor( int red, int green, int blue ) {
    backgroundColor = p.color( red, green, blue );
  } // end setBackgroundColor()

  /**
   * Sets the background color. The default is transparent.
   *
   * @param red The red value of the color.
   * @param green The green value of the color.
   * @param blue The blue value of the color.
   * @param alpha The alpha value of the color.
   */
  public void setBackgroundColor( int red, int green, int blue, int alpha ) {
    backgroundColor = p.color( red, green, blue, alpha );
  } // end setBackgroundColor()

  /**
   * Gets the background color.
   *
   * @return The background color.
   */
  public int getBackgroundColor(  ) {
    return backgroundColor;
  } // end getBackgroundColor()

  /**
   * Sets the border color. The default is white.
   *
   * @param borderColor The border color.
   */
  public void setBorderColor( int borderColor ) {
    this.borderColor = borderColor;
  } // end setBorderColor()

  /**
   * Sets the border color. The default is white.
   *
   * @param red The red value of the color.
   * @param green The green value of the color.
   * @param blue The blue value of the color.
   */
  public void setBorderColor( int red, int green, int blue ) {
    borderColor = p.color( red, green, blue );
  } // end setBorderColor()

  /**
   * Sets the border color. The default is white.
   *
   * @param red The red value of the color.
   * @param green The green value of the color.
   * @param blue The blue value of the color.
   * @param alpha The alpha value of the color.
   */
  public void setBorderColor( int red, int green, int blue, int alpha ) {
    borderColor = p.color( red, green, blue, alpha );
  } // end setBorderColor()

  /**
   * Gets the border color.
   *
   * @return The border color.
   */
  public int getBorderColor(  ) {
    return borderColor;
  } // end getBorderColor()

  /**
   * Sets the size of this Component's border. The default is 0.
   *
   * @param borderSize The border size.
   */
  public void setBorderSize( float borderSize ) {
    width = width - this.borderSize - this.borderSize + borderSize + borderSize;
    height = height - this.borderSize - this.borderSize + borderSize + borderSize;
    this.borderSize = borderSize;
  } // end setBorderSize()

  /**
   * Gets the size of this Component's border.
   *
   * @return The border size.
   */
  public float getBorderSize(  ) {
    return borderSize;
  } // end getBorderSize()

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
   * Sets the foreground color. This is the main color used by this Component. For example,
   * the color of text in a Label or the color of the bar in a ProgressBar.
   *
   * @param foregroundColor The foreground color.
   */
  public void setForegroundColor( int foregroundColor ) {
    this.foregroundColor = foregroundColor;
  } // end setForegroundColor()

  /**
   * Sets the foreground color. This is the main color used by this Component. For example,
   * the color of text in a Label or the color of the bar in a ProgressBar.
   *
   * @param red The red value of the color.
   * @param green The green value of the color.
   * @param blue The blue value of the color.
   */
  public void setForegroundColor( int red, int green, int blue ) {
    foregroundColor = p.color( red, green, blue, 255 );
  } // end setForegroundColor()

  /**
   * Sets the foreground color. This is the main color used by this Component. For example,
   * the color of text in a Label or the color of the bar in a ProgressBar.
   *
   * @param red The red value of the color.
   * @param green The green value of the color.
   * @param blue The blue value of the color.
   * @param alpha The alpha value of the color.
   */
  public void setForegroundColor( int red, int green, int blue, int alpha ) {
    foregroundColor = p.color( red, green, blue, alpha );
  } // end setForegroundColor()

  /**
   * Gets the foreground color. This is the main color used by this Component. For example,
   * the color of text in a Label or the color of the bar in a ProgressBar.
   *
   * @return The foreground color.
   */
  public int getForegroundColor(  ) {
    return foregroundColor;
  } // end getForegroundColor()

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
        zRotation += ( radiansPerSecond * timer.getSecondsActive(  ) );
      } // end if

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
      
      if(borderSize > 0) {
    	p.fill( borderColor );
      	p.quad(0, 0, borderSize, borderSize, width - borderSize, borderSize, width, 0);
      	p.quad(0, 0, borderSize, borderSize, borderSize, height - borderSize, 0, height);
      	p.quad(width, height, width - borderSize, height - borderSize, width-borderSize, borderSize, width, 0);
      	p.quad(width, height, width - borderSize, height - borderSize, borderSize, height - borderSize, 0, height);
      }

      p.translate( borderSize, borderSize );
      p.fill( backgroundColor );
      p.rect( 0, 0, width - borderSize - borderSize, height - borderSize - borderSize );

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
   * TODO: DOCUMENT ME!
   *
   * @param left DOCUMENT ME!
   * @param right DOCUMENT ME!
   * @param top DOCUMENT ME!
   * @param bottom DOCUMENT ME!
   */
  public void setPadding( float left, float right, float top, float bottom ) {
    padding.left = left;
    padding.right = right;
    padding.top = top;
    padding.bottom = bottom;
  } // end setPadding()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public Padding getPadding(  ) {
    return padding;
  } // end getPadding()

  /**
   * Sets the revolutions the Label will make per second. The Timer must also be set for
   * rotation to occur.
   *
   * @param revolutionsPerSecond Revolutions per second. Positive values result in clockwise
   *        rotation. Negative values result in counter-clockwise rotation.
   */
  public void setRevolutionsPerSecond( float revolutionsPerSecond ) {
    this.radiansPerSecond = PConstants.TWO_PI * revolutionsPerSecond;
  } // end setRevolutionsPerSecond()

  /**
   * Sets the revolutions the Label will make per second.
   *
   * @param revolutionsPerSecond Revolutions per second. Positive values result in clockwise
   *        rotation. Negative values result in counter-clockwise rotation.
   * @param timer The timer used to rotate the Component. Rotation only occurs while the Timer is
   *        active.
   */
  public void setRevolutionsPerSecond( float revolutionsPerSecond, Timer timer ) {
    this.timer = timer;
    setRevolutionsPerSecond( revolutionsPerSecond );
  } // end setRevolutionsPerSecond()

  /**
   * Sets the current rotation of this Component. If
   *
   * @param rotation DOCUMENT ME!
   */
  public void setRotation( float rotation ) {
    this.rotation = rotation;
  } // end setRotation()

  /**
   * Sets the timer associated with this Component. The Timer is used to calculate rotation
   * but may also be used for other animation purposes.
   *
   * @param timer The Timer.
   */
  public void setTimer( Timer timer ) {
    this.timer = timer;
  } // end setTimer()

  /**
   * Gets the timer associated with this Component. The Timer is used to calculate rotation
   * but may also be used for other animation purposes.
   *
   * @param timer The Timer.
   */
  public void getTimer( Timer timer ) {}

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

  /**
   *  TODO: DOCUMENT ME!
   *
   * @author Andy Bursavich
   * @version 0.1
    */
  public class Padding {
    public float bottom;
    public float left;
    public float right;
    public float top;

    /**
     * Creates a new Padding object.
     */
    public Padding(  ) {
      left = right = top = bottom = 0;
    } // end Padding()

    /**
     * Creates a new Padding object.
     *
     * @param left DOCUMENT ME!
     * @param right DOCUMENT ME!
     * @param top DOCUMENT ME!
     * @param bottom DOCUMENT ME!
     */
    public Padding( float left, float right, float top, float bottom ) {
      this.left = left;
      this.right = right;
      this.top = top;
      this.bottom = bottom;
    } // end Padding()
  } // end Padding
} // end Component
