package ise.ui;

import processing.core.PApplet;

import java.util.ArrayList;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.2
 */
public class DebugOutput extends Label {
  protected ArrayList<String> lines;

/**
   * Creates a new DebugOutput object.
   *
   * @param p DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public DebugOutput( PApplet p, float x, float y ) {
    super( p, new String[] {  }, x, y );

    // TODO Auto-generated constructor stub
  } // end DebugOutput()

/**
   * Creates a new DebugOutput object.
   *
   * @param p DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public DebugOutput( PApplet p, Font font, float x, float y ) {
    super( p, new String[] {  }, font, x, y );

    // TODO Auto-generated constructor stub
  } // end DebugOutput()

/**
   * Creates a new DebugOutput object.
   *
   * @param p DOCUMENT ME!
   * @param font DOCUMENT ME!
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public DebugOutput( PApplet p, Font font, float x, float y, float width, float height ) {
    super( p, new String[] {  }, font, x, y, width, height );

    // TODO Auto-generated constructor stub
  } // end DebugOutput()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param text DOCUMENT ME!
   */
  public void addLine( String text ) {
    int length = this.text.length;
    String[] oldText = this.text;
    String[] newText = new String[length + 1];

    for ( int i = 0; i < length; i++ ) {
      newText[i] = oldText[i];
    } // end for

    newText[length] = text;
    setText( newText );
  } // end addLine()

  /**
   * TODO: DOCUMENT ME!
   */
  public void clearLines(  ) {
    text = new String[] {  };
  } // end clearLines()
} // end DebugOutput
