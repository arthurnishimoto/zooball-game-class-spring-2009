public class BoosterStrip extends Booster
{
  Vector2D center;
  double radiusSquared;
  
  public BoosterStrip( double x, double y, double width, double height, Vector2D force ) {
    super( force );
    center = new Vector2D( x, y );
    setPoints( width, height );
  }
  
  private void setPoints( double width, double height ) {
    Vector2D[] points = new Vector2D[4];
    radiusSquared = width*width*0.25 + height*height*0.25;
    Vector2D xN = Vector2D.norm( force );
    Vector2D yN = xN.perp( );   
    xN.scale( width*0.5 );
    yN.scale( height*0.5 );
    // Points are clockwise
    points[0] = Vector2D.sub( center, xN );
    points[0].sub( yN );
    points[1] = Vector2D.add( center, xN );
    points[1].sub( yN );
    points[2] = Vector2D.add( center, xN );
    points[2].add( yN );
    points[3] = Vector2D.sub( center, xN );
    points[3].add( yN );
    setPoints( points );
  }
  
  public boolean contains( Vector2D p ) {
    c = color( 0, 0, 255 );
    if ( radiusSquared < Vector2D.sub( center, p ).magnitudeSquared( ) ) return false;
    return super.contains( p );
  }
  
  public void draw( ) {
    super.draw( );
  }// draw
  
  public void drawDebug( ) {
    fill( 255 );
    ellipse( (float)center.x, (float)center.y, 5, 5 );
    fill( 0, 0 );
    stroke( 255 );
    float diameter = (float)Math.sqrt( radiusSquared ) * 2;
    ellipse( (float)center.x, (float)center.y, diameter, diameter );
    stroke( 255, 0, 0 );
    line( (float)center.x, (float)center.y, (float)(center.x + force.x * 0.25), (float)(center.y + force.y * 0.25) );
    noStroke( );
  }// drawDebug
  
}
