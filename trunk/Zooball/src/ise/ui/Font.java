package ise.ui;

import processing.core.PApplet;
import processing.core.PFont;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;

import java.util.HashMap;


/**
 * A wrapper for the PFont object.  Stores additional information such as actual ascent and
 * descent.  Creation of Fonts is controlled by the Font.Factory.
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Font {
  private static HashMap<String, Font> fonts = new HashMap<String, Font>(  );
  protected PFont pFont;
  protected int ascent;
  protected int descent;
  protected int height;
  protected int size;

/**
   * Creates a new Font object.
   *
   * @param The Processing sketch.
   * @param font The PFont
   * @param size The "natural" font size
   */
  private Font( PApplet p, PFont pFont, int size ) {
    this.pFont = pFont;
    this.size = size;
    p.textFont( pFont );
    ascent = (int) p.textAscent(  );
    descent = (int) p.textDescent(  );
    height = ascent + descent;
  } // end Font()

  /**
   * Gets a Font object using the specified name and size.  A font of a given name and size
   * is only loaded once and stored as a Font object. Subsequent requests for the same font return
   * the same Font object.  If the Font object has not yet been created, first it tries to load
   * the PFont from the data directory. If it is not found in the data directory, it tries to
   * create the PFont from a system font.
   *
   * @param p The Processing sketch.
   * @param name The font name.
   * @param size The font size.
   *
   * @return The Font identified by the given name and size.
   */
  public static Font getInstance( PApplet p, String name, int size ) {
    String key = name + "-" + size + ".vlw";
    Font font;

    if ( fonts.containsKey( key ) ) {
      font = fonts.get( key );
    } // end if
    else {
      // Only synchronize over font creation
      synchronized ( fonts ) {
        if ( fonts.containsKey( key ) ) {
          font = fonts.get( key );
        } // end if
        else {
          PFont pFont = null;
          File file = new File( "data\\" + key );

          if ( file.exists(  ) ) {
            pFont = p.loadFont( key );
          } // end if
          else {
            try {
              pFont = p.createFont( name, size, true );

              try {
                pFont.save( new DataOutputStream( new FileOutputStream( file ) ) );
              } // end try
              catch ( Exception exception ) {
                System.err.println( "Could not save font: " + key );
                System.err.println( exception.getMessage(  ) );
              } // end catch
            } // end try
            catch ( Exception exception ) {
              System.err.println( "Could not create font: " + name + " (" + size + ")" );
              System.err.println( exception.getStackTrace(  ) );
              System.exit( -1 );
            } // end catch
          } // end else

          font = new Font( p, pFont, size );
          fonts.put( key, font );
        } // end else
      } // end synchronized
    } // end else

    return font;
  } // end getInstance()

  /**
   * Gets the ascent of this Font from the baseline.
   *
   * @return The ascent of this Font from the baseline.
   */
  public int getAscent(  ) {
    return ascent;
  } // end getAscent()

  /**
   * Gets the descent of this Font from the baseline.
   *
   * @return The descent of this Font from the baseline.
   */
  public int getDescent(  ) {
    return descent;
  } // end getDescent()

  /**
   * Gets the height of this font as calculated by descent + ascent;
   *
   * @return The height of this font.
   */
  public int getHeight(  ) {
    return height;
  } // end getHeight()

  /**
   * Gets the PFont for this Font.
   *
   * @return The PFont for this Font.
   */
  public PFont getPFont(  ) {
    return pFont;
  } // end getPFont()

  /**
   * Gets the "natural" size of this Font.
   *
   * @return The "natural" size of this Font.
   */
  public int getSize(  ) {
    return size;
  } // end getSize()
} // end Font
