/**
 * Intended for circular buttons. Position (x, y) is the center of the button.
 * 
 * Author: Andy Bursavich
 * Version: 0.2
 */
public class CircularButton
{
  private Image imgEnabled, imgDisabled;
  private float x, y, rotation, radius;
  private boolean enabled, selected;
  
  public CircularButton( String name ) {
    imgEnabled = new Image( "ui/buttons/" + name + "/enabled.png" );
    imgDisabled = new Image( "ui/buttons/" + name + "/disabled.png" );
    setRadius( ( imgEnabled.getWidth( ) + imgEnabled.getHeight( ) ) * 0.25 ); // diameter = average of width and height
    enabled = true;
    selected = false;
  }
  
  public void draw( ) {
    pushMatrix( );
    translate( x, y );
    rotate( rotation );
    if ( selected ) {
      float diameter = radius + radius + 16;
      fill( 0, 0 );
      strokeWeight( 2.0 );
      stroke( 255 );
      ellipse( 0, 0, diameter, diameter );
      noStroke( );
    }
    if ( enabled )
      imgEnabled.draw( );
    else
      imgDisabled.draw( );
    popMatrix( );
  }
  
  public boolean contains( float x, float y ) {
    float dx = this.x - x;
    float dy = this.y - y;
    return (radius * radius) <= ( (dx * dx) + (dy * dy) );
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
    imgEnabled.setWidth( radius * 2 );
    imgEnabled.setHeight( radius * 2 );
    imgEnabled.setX( -radius );
    imgEnabled.setY( -radius );
    imgDisabled.setWidth( radius * 2 );
    imgDisabled.setHeight( radius * 2 );
    imgDisabled.setX( -radius );
    imgDisabled.setY( -radius );
  }
  public boolean isEnabled( ) { return enabled; }
  public void setEnabled( boolean enabled ) { this.enabled = enabled; }
}
