package ise.ui;

import ise.math.Vector2D;

import processing.core.PApplet;
import processing.core.PConstants;


/**
 * A display area for one or more short text strings.
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Label extends Component {
  protected Font font;
  protected String[] text;
  protected int horizontalTextAlignment = CENTER;
  protected int verticalTextAlignment = MIDDLE;

/**
   * Creates a new Label object.
   *
   * @param p The Processing sketch
   * @param text The single line of text to display on the Label
   * @param x The x location of the Label's anchor
   * @param y The y location of the Label's anchor
   */
  public Label( PApplet p, String text, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    font = Font.getInstance( p, "Arial", 15 );
    this.text = new String[] { text };
    updateSize(  );
  } // end Label()

/**
   * Creates a new Label object.
   *
   * @param p The Processing sketch
   * @param text The lines of text to display on the Label
   * @param x The x location of the Label's anchor
   * @param y The y location of the Label's anchor
   */
  public Label( PApplet p, String[] text, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    font = Font.getInstance( p, "Arial", 15 );
    this.text = text;

    updateSize(  );
  } // end Label()

/**
   * Creates a new Label object.
   *
   * @param p The Processing sketch
   * @param text The single line of text to display on the Label
   * @param font The font to use to display the text
   * @param x The x location of the Label's anchor
   * @param y The y location of the Label's anchor
   */
  public Label( PApplet p, String text, Font font, float x, float y ) {
    super( p );
    this.font = font;
    this.text = new String[] { text };
    this.x = x;
    this.y = y;
    updateSize(  );
  } // end Label()

/**
   * Creates a new Label object.
   *
   * @param p The Processing sketch
   * @param text The lines of text to display on the Label
   * @param font The font to use to display the text
   * @param x The x location of the Label's anchor
   * @param y The y location of the Label's anchor
   */
  public Label( PApplet p, String[] text, Font font, float x, float y ) {
    super( p );
    this.x = x;
    this.y = y;
    this.font = font;
    this.text = text;

    updateSize(  );
  } // end Label()

/**
   * Creates a new Label object.
   * 
   * Note: Preferred size is not guaranteed. Text will not be shrunk or truncated to fit a
   * smaller preferred size, but the Component will be expanded to fit a larger preferred
   * size. 
   *
   * @param p The Processing sketch
   * @param text The single line of text to display on the Label
   * @param font The font to use to display the text
   * @param x The x location of the Label's anchor
   * @param y The y location of the Label's anchor
   * @param width The preferred width of the Label
   * @param height The preferred width of the Label
   */
  public Label( PApplet p, String text, Font font, float x, float y, float width, float height ) {
    super( p );
    this.x = x;
    this.y = y;
    this.preferredWidth = width;
    this.preferredHeight = height;
    this.font = font;
    this.text = new String[] { text };
    updateSize(  );
  } // end Label()

/**
   * Creates a new Label object.
   * 
   * Note: Preferred size is not guaranteed. Text will not be shrunk or truncated to fit a
   * smaller preferred size, but the Component will be expanded to fit a larger preferred
   * size. 
   *
   * @param p The Processing sketch
   * @param text The lines of text to display on the Label
   * @param font The font to use to display the text
   * @param x The x location of the Label's anchor
   * @param y The y location of the Label's anchor
   * @param width The preferred width of the Label
   * @param height The preferred width of the Label
   */
  public Label( PApplet p, String[] text, Font font, float x, float y, float width, float height ) {
    super( p );
    this.x = x;
    this.y = y;
    this.preferredWidth = width;
    this.preferredHeight = height;
    this.font = font;
    this.text = text;
    updateSize(  );
  } // end Label()

  /**
   * Sets the font of this Label.  Note: It may a side-effect of changing the PApplet's
   * current font.
   *
   * @param font The font to use for this Label.
   */
  public void setFont( Font font ) {
    this.font = font;
    updateSize(  );
  } // end setFont()

  /**
   * Sets the horizontal alignment for this Label.
   *
   * @param alignment The horizontal text alignment for this Label. Possible values: LEFT, CENTER,
   *        RIGHT.
   */
  public void setHorizontalTextAlignment( int alignment ) {
    horizontalTextAlignment = alignment;
  } // end setHorizontalTextAlignment()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param height DOCUMENT ME!
   */
  public void setPreferredHeight( float height ) {
    super.setPreferredHeight( height );
    updateSize(  );
  } // end setPreferredHeight()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param size DOCUMENT ME!
   */
  public void setPreferredSize( Vector2D size ) {
    super.setPreferredSize( size );
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
    updateSize(  );
  } // end setPreferredSize()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param width DOCUMENT ME!
   */
  public void setPreferredWidth( float width ) {
    super.setPreferredWidth( width );
    updateSize(  );
  } // end setPreferredWidth()
  
  /**
   * TODO: DOCUMENT ME!
   *
   * @param width DOCUMENT ME!
   */
  public void setPadding( float left, float right, float top, float bottom ) {
    super.setPadding( left, right, top, bottom );
    updateSize(  );
  } // end setPreferredWidth()

  /**
   * Sets the single line of text for this Label.
   *
   * @param text The single line of text for this Label.
   */
  public void setText( String text ) {
    this.text = new String[] { text };
    updateSize(  );
  } // end setText()

  /**
   * Sets the lines of text for this Label.
   *
   * @param text The lines of text for this Label.
   */
  public void setText( String[] text ) {
    if ( text == null ) {
      this.text = new String[] { "" };
    } // end if
    else {
      this.text = text;
    } // end else

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
    horizontalTextAlignment = horizontalAlignment;
    verticalTextAlignment = verticalAlignment;
  } // end setTextAlignment()

  /**
   * Sets the vertical alignment for this Label.
   *
   * @param alignment The vertical text alignment for this Label. Possible values: TOP, MIDDLE,
   *        BOTTOM.
   */
  public void setVerticalTextAlignment( int alignment ) {
    verticalTextAlignment = alignment;
  } // end setVerticalTextAlignment()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  protected Vector2D getTextSize(  ) {
    Vector2D size = new Vector2D( 0, 0 );
    float lineWidth = 0;
    size.y = ( text.length < 2 ) ? font.height : ( font.height + ( font.size * ( text.length - 1 ) ) );

    p.textFont( font.pFont );

    for ( int i = 0; i < text.length; i++ ) {
      lineWidth = p.textWidth( text[i] );

      if ( lineWidth > size.x ) {
        size.x = lineWidth;
      } // end if
    } // end for

    return size;
  } // end getTextSize()
  
  protected Vector2D getTextTranslation(float width, float height) {
	  Vector2D translation = new Vector2D(0, 0);

	    // horizontal alignment
	    if ( horizontalTextAlignment == LEFT ) {
	    	translation.x = 0.0f;
	      p.textAlign( PConstants.LEFT );
	    } // end if
	    else if ( horizontalTextAlignment == CENTER ) {
	    	translation.x = width * 0.5f;
	      p.textAlign( PConstants.CENTER );
	    } // end else if
	    else { // RIGHT
	    	translation.x = width;
	      p.textAlign( PConstants.RIGHT );
	    } // end else

	    // vertical alignment
	    if ( verticalTextAlignment == TOP ) {
	    	translation.y = font.ascent;
	    } // end if
	    else if ( verticalTextAlignment == MIDDLE ) {
	    	translation.y = ( 0.5f * ( height - ( font.height + ( font.size * ( text.length - 1 ) ) ) ) ) +
	          font.ascent;
	    } // end else if
	    else { // BOTTOM
	    	translation.y = height - ( font.height + ( font.size * ( text.length - 1 ) ) ) + font.ascent;
	    } // end else
	    
	    return translation;
  }

  /**
   * Draws this Label.
   */
  @Override
  protected void drawComponent(  ) {
		Vector2D translation = getTextTranslation(width - padding.left - padding.right, height - padding.top - padding.bottom);
	    p.pushMatrix(  );
	    p.translate( translation.x + padding.top, translation.y + padding.left );
	    drawText();
	    p.popMatrix(  );
  } // end drawComponent()
  
  protected void drawText() {
	    p.pushMatrix(  );

	    p.fill( foregroundColor );
	    p.textFont( font.pFont );

	    // draw text
	    for ( int i = 0; i < text.length; i++ ) {
	      p.text( text[i], 0, 0 );
	      /*
	         // DEBUG - Red line at acent, Green Line at baseline, Blue line at descent
	         p.stroke(255, 0, 0);
	         p.line(-100, -font.ascent, 100, -font.ascent);
	         p.stroke(0, 255, 0);
	         p.line(-100, 0, 100, 0);
	         p.stroke(0, 0, 255);
	         p.line(-100, font.descent, 100, font.descent);
	         // END DEBUG
	      */
	      p.translate( 0, font.size );
	    } // end for

	    p.popMatrix(  );
  }

  /**
   * Updates the width and height values for this Label. Uses preferred sizes if possible, or
   * the smallest value to fit the text.
   */
  protected void updateSize(  ) {
	Vector2D size = getTextSize(  );
    size.x = size.x + padding.left + padding.right + borderSize + borderSize;
    size.y = size.y+ padding.top + padding.bottom + borderSize  + borderSize ;
    
    width = ( preferredWidth < size.x ) ? size.x : preferredWidth;
    height = ( preferredHeight < size.y ) ? size.y : preferredHeight;
  } // end updateSize()
} // end Label
