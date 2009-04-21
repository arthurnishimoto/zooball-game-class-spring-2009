/**
 * Intended for circular buttons. Position (x, y) is the center of the button.
 * 
 * Author: Andy Bursavich
 * Version: 0.2
 */
public class CircularButton
{
  private Image image;
  private float x, y, rotation, radius;
  
  public CircularButton( String fileName ) {
    image = new Image( fileName );
    setRadius( ( image.getWidth( ) + image.getHeight( ) ) * 0.25 ); // diameter = average of width and height
  }
  
  public void draw( ) {
    pushMatrix( );
    translate( x, y );
    rotate( rotation );
    image.draw( );
    popMatrix( );
  }
  
  public boolean contains( float x, float y ) {
    float dx = this.x - x;
    float dy = this.y - y;
    return (radius * radius) >= ( (dx * dx) + (dy * dy) );
  }
  
  public void setPosition( float x, float y ) {
    this.x = x;
    this.y = y;
  }
  public float getX( ) { return x; }
  public void setX( float x ) { this.x = x; }
  public float getY( ) { return y; }
  public void setY( float y ) { this.y = y; }
  public float getRotation( ) { return rotation; }
  public void setRotation( float rotation ) { this.rotation = rotation; }
  public float getRadius( ) { return radius; }
  public void setRadius( float radius ) {
    this.radius = radius;
    image.setWidth( radius * 2 );
    image.setHeight( radius * 2 );
    image.setX( -radius );
    image.setY( -radius );
  }
  
}
