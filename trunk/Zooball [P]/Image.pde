import java.util.HashMap;

import processing.core.PApplet;
import processing.core.PImage;

/**
 * Wrapper of sorts for PImage.  Create a new Image by calling Image.getImage( fileName ).
 * Image will only create a single instance of the underlying PImage object which is shared
 * among all Images that use it.
 * 
 * For example, multiple buttons can be created using the same texture.  Each button will
 * have its own Image object with its own position, size, rotation, etc.  But each will use
 * the same underlying PImage object when drawing.
 * 
 * Author: Andy Bursavich
 * Version: 0.1
 */
public class Image
{
  private static PApplet p;
  private static HashMap pimages = new HashMap( );
  private PImage pimage;
  private float x, y, rotation, width, height;
  
  private Image( PImage pimage ) {
    this.pimage = pimage;
    x = y = rotation = 0;
    width = pimage.width;
    height = pimage.height;
  }
  
  public static void setPApplet( PApplet p ) { Image.p = p; }
  
  public static Image getImage( String fileName ) {
    PImage pimage = null;
    
    if ( pimages.containsKey( fileName ) )
      pimage = (PImage) pimages.get( fileName );
    else {
      synchronized ( pimages ) {
        if ( pimages.containsKey( fileName ) )
          pimage = (PImage) pimages.get( fileName );
        else {
          pimage = p.loadImage( fileName );
          pimages.put( fileName, pimage );
        }
      }
    }
    
    return new Image( pimage );
  }
  
  public void draw( ) {
    p.pushMatrix( );
    p.translate( x, y );
    p.rotate( rotation );
    p.beginShape( );
    p.texture( pimage );
    p.textureMode( PApplet.NORMALIZED );
    p.vertex( 0, 0, 0, 0 );
    p.vertex( width, 0, 1, 0 );
    p.vertex( width, height, 1, 1 );
    p.vertex( 0, height, 0, 1 );
    p.endShape( );
    p.popMatrix( );
  }
  
  public float getX( ) { return x; }
  public void setX( float x ) { this.x = x; }
  public float getY( ) { return y; }
  public void setY( float y ) { this.y = y; }
  public float getRotation( ) { return rotation; }
  public void setRotation( float rotation ) { this.rotation = rotation; }
  public float getWidth( ) { return width; }
  public void setWidth( float width ) { this.width = width; }
  public float getHeight( ) { return height; }
  public void setHeight( float height ) { this.height = height; }
}
