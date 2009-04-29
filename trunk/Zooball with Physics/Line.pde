public class Line
{
  protected Vector2D a, b, direction, normal;
  
  public Line( double ax, double ay, double bx, double by ) {
    a = new Vector2D( ax, ay );
    b = new Vector2D( bx, by );
    direction = Vector2D.sub( b, a );
    normal = direction.perp( );
  }
  
  public Vector2D closestPoint( Vector2D p ) {
    double s = Vector2D.sub( p, a ).dot( direction ) / direction.dot( direction );
    if ( s <= 0 ) return new Vector2D( a );
    if ( s >= 1 ) return new Vector2D( b );
    return new Vector2D( a.x + s*direction.x, a.y + s*direction.y );
  }
  
  public double distanceToPoint( Vector2D p ) {
    return Vector2D.sub( p, closestPoint( p ) ).magnitude( );
  }
  
  private void draw( ) {
    strokeWeight( 2 );
    stroke( 255, 0, 255 );
    line( (float)a.x, (float)a.y, (float)b.x, (float)b.y );
    strokeWeight( 1 );
    stroke( 255, 0, 0 );
    noStroke( );
  }
  
  public Vector2D getP1( ) { return new Vector2D( a ); }
  public Vector2D getP2( ) { return new Vector2D( b ); }
  public String toString( ) { return "[ " + a + " " + b + " ]"; }
}
