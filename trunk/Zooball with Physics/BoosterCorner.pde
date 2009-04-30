public class BoosterCorner extends Booster
{
  Vector2D center;
  double radiusSquared;
  
  public BoosterCorner( double x, double y, double width, double height, Vector2D force ) {
    super( force );
    setPoints( x, y, width, height );
  }
  
  private void setPoints( double x, double y, double width, double height ) {
    Vector2D[] points = new Vector2D[3];
    // Points are clockwise
    points[0] = new Vector2D( x, y );
    points[1] = new Vector2D( x, y + height );
    points[2] = new Vector2D( x + width, y );;
    center = Vector2D.add( points[1], points[2] );
    center.scale( 0.5 );
    radiusSquared = Vector2D.sub( points[1], center ).magnitudeSquared( );
    setPoints( points );
  }
  
  public boolean contains( Vector2D p ) {
    c = color( 0, 0, 255 );
    if ( radiusSquared < Vector2D.sub( center, p ).magnitudeSquared( ) ) return false;
    return super.contains( p );
  }
  
  public void draw( ) {
    fill( 0.5*(0x9E+0x79), 0.5*(0xC6+0xAE), 0.5*(0x33+0x27) );
    //fill( 235 );
    beginShape( );
    for (int i = 0; i < points.length; i++ )
      vertex( (float)points[i].x, (float)points[i].y );
    endShape(CLOSE);
  }
  
  public void drawDebug( ) {
    super.drawDebug( );
    fill( 255 );
    ellipse( (float)center.x, (float)center.y, 5, 5 );
    stroke( 0 );
    line( (float)center.x, (float)center.y, (float)(center.x + force.x * 0.25), (float)(center.y + force.y * 0.25) );
    fill( 0, 0 );
    stroke( 255 );
    float diameter = (float)Math.sqrt( radiusSquared );
    diameter += diameter;
    ellipse( (float)center.x, (float)center.y, diameter, diameter );
    noStroke( );
  }
}
