package ise.ui;

import ise.math.Vector2D;

import processing.core.PApplet;


/**
 * A display area for one or more short text strings. The message is displayed facing opposite
 * direction.
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class MirroredLabel extends Component {
  Label label;

/**
   * Creates a new MirroredLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String text, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    label = new Label( p, text, 0, 0 );
    label.setAnchor( CENTER, TOP );
    updateSize(  );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel()

/**
   * Creates a new MirroredLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String[] text, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    label = new Label( p, text, 0, 0 );
    label.setAnchor( CENTER, TOP );
    updateSize(  );
  } // end MirroredLabel()

/**
   * Creates a new MirroredLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String text, Font font, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    label = new Label( p, text, font, 0, 0 );
    label.horizontalAnchor = CENTER;
    label.verticalAnchor = BOTTOM;
    updateSize(  );
  } // end MirroredLabel()

/**
   * Creates a new MirroredLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String[] text, Font font, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    label = new Label( p, text, font, 0, 0 );
    label.horizontalAnchor = CENTER;
    label.verticalAnchor = BOTTOM;
    updateSize(  );
  } // end MirroredLabel()

/**
   * Creates a new MirroredLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String text, Font font, float x, float y, float width,
                        float height ) {
    super( p );
    this.x = x;
    this.y = y;
    this.preferredWidth = width;
    this.preferredHeight = height;
    label = new Label( p, text, font, 0, 0 );
    label.horizontalAnchor = CENTER;
    label.verticalAnchor = BOTTOM;
    label.setPreferredSize( width, height * 0.5f );
    updateSize(  );
  } // end MirroredLabel()

/**
   * Creates a new MirroredLabel object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String[] text, Font font, float x, float y, float width,
                        float height ) {
    super( p );
    this.x = x;
    this.y = y;
    this.preferredWidth = width;
    this.preferredHeight = height;
    label = new Label( p, text, font, 0, 0 );
    label.horizontalAnchor = CENTER;
    label.verticalAnchor = BOTTOM;
    label.setPreferredSize( width, height * 0.5f );
    updateSize(  );
  } // end MirroredLabel()

  /**
   * Sets the font of this Label.  Note: It may a side-effect of changing the PApplet's
   * current font.
   *
   * @param font The font to use for this Label.
   */
  public void setFont( Font font ) {
    label.setFont( font );
    updateSize(  );
  } // end setFont()

  /**
   * Sets the horizontal alignment for this Label.
   *
   * @param alignment The horizontal text alignment for this Label. Possible values: LEFT, CENTER,
   *        RIGHT.
   */
  public void setHorizontalTextAlignment( int alignment ) {
    label.setHorizontalTextAlignment( alignment );
  } // end setHorizontalTextAlignment()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param height DOCUMENT ME!
   */
  public void setPreferredHeight( float height ) {
    super.setPreferredHeight( height );
    label.setPreferredHeight( height * 0.5f );
    updateSize(  );
  } // end setPreferredHeight()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param size DOCUMENT ME!
   */
  public void setPreferredSize( Vector2D size ) {
    super.setPreferredSize( size );
    label.setPreferredSize( new Vector2D( size.x, size.y * 0.5f ) );
    updateSize(  );
  } // end setPreferredSize()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public void setPreferredSize( float width, float height ) {
    super.setPreferredSize( width, height );
    label.setPreferredSize( width, height * 0.5f );
    updateSize(  );
  } // end setPreferredSize()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param width DOCUMENT ME!
   */
  public void setPreferredWidth( float width ) {
    super.setPreferredWidth( width );
    label.setPreferredWidth( width );
    updateSize(  );
  } // end setPreferredWidth()

  /**
   * Sets the single line of text for this Label.
   *
   * @param text The single line of text for this Label.
   */
  public void setText( String text ) {
    label.setText( text );
    updateSize(  );
  } // end setText()

  /**
   * Sets the lines of text for this Label.
   *
   * @param text The lines of text for this Label.
   */
  public void setText( String[] text ) {
    label.setText( text );
    updateSize(  );
  } // end setText()

  /**
   * Sets the horizontal and vertical alignments for this Label.
   *
   * @param horizontalAlignment The horizontal text alignment for this Label. Possible values:
   *        LEFT, CENTER, RIGHT.
   * @param verticalAlignment The vertical text alignment for this Label. Possible values: TOP,
   *        MIDDLE, BOTTOM.
   */
  public void setTextAlignment( int horizontalAlignment, int verticalAlignment ) {
    label.setTextAlignment( horizontalAlignment, verticalAlignment );
  } // end setTextAlignment()

  /**
   * Sets the vertical alignment for this Label.
   *
   * @param alignment The vertical text alignment for this Label. Possible values: TOP, MIDDLE,
   *        BOTTOM.
   */
  public void setVerticalTextAlignment( int alignment ) {
    label.setVerticalTextAlignment( alignment );
  } // end setVerticalTextAlignment()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  protected void drawComponent(  ) {
    label.y = height;
    label.setFacingDirection( BOTTOM );
    label.draw(  );
    label.y = 0;
    label.setFacingDirection( TOP );
    label.draw(  );
  } // end drawComponent()

  /**
   * Updates the width and height values for this Label. Uses preferred sizes if possible, or
   * the smallest value to fit the text.
   */
  protected void updateSize(  ) {
    width = label.width;
    height = ( ( label.height * 2f ) + label.font.size ) - label.font.ascent;
    label.x = width * 0.5f;
  } // end updateSize()
} // end MirroredLabel
