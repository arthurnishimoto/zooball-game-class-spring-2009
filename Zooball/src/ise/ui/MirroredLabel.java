package ise.ui;

import ise.math.Vector2D;

import processing.core.PApplet;
import processing.core.PConstants;


/**
 *  TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.2
  */
public class MirroredLabel extends Label {
  /**
   * Creates a new MirroredLabel2 object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String text, float x, float y ) {
    super( p, text, x, y );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel2()

  /**
   * Creates a new MirroredLabel2 object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String[] text, float x, float y ) {
    super( p, text, x, y );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel2()

  /**
   * Creates a new MirroredLabel2 object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String text, Font font, float x, float y ) {
    super( p, text, font, x, y );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel2()

  /**
   * Creates a new MirroredLabel2 object.
   *
   * @param p DOCUMENT ME!
   * @param text DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public MirroredLabel( PApplet p, String[] text, Font font, float x, float y ) {
    super( p, text, font, x, y );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel2()

  /**
   * Creates a new MirroredLabel2 object.
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
    super( p, text, font, x, y, width, height );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel2()

  /**
   * Creates a new MirroredLabel2 object.
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
    super( p, text, font, x, y, width, height );

    // TODO Auto-generated constructor stub
  } // end MirroredLabel2()

  /**
   * Draws this Label.
   */
  @Override
  protected void drawComponent(  ) {
	  float height = this.height * 0.5f - borderSize - padding.top - padding.bottom;
	  float width = this.width - borderSize - borderSize - padding.left - padding.right;
	  
		Vector2D translation = getTextTranslation(width, height);
		
		// draw top text
	    p.pushMatrix(  );
	    p.translate( translation.x + padding.left, translation.y + height + padding.top + padding.top + padding.bottom);
	    drawText();
	    p.popMatrix(  );
	    
	    // draw bottom text
	    p.pushMatrix(  );
	    p.translate(width + padding.right, height + padding.bottom);
	    p.rotateZ(PConstants.PI);
	    p.translate( translation.x, translation.y );
	    drawText();
	    p.popMatrix(  );
  } // end drawComponent()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  protected void updateSize(  ) {
    Vector2D size = getTextSize(  );
    size.x = size.x + padding.left + padding.right + borderSize + borderSize;
    size.y = (size.y + borderSize + padding.top + padding.bottom) * 2f;

    width = ( preferredWidth < size.x ) ? size.x : preferredWidth;
    height = ( preferredHeight < size.y ) ? size.y : preferredHeight;
  } // end updateSize()
} // end MirroredLabel2
