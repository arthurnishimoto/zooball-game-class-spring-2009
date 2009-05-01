public class Booster
{
  protected Vector2D points[];
  protected Vector2D normals[], force;
  protected int c = color( 128 );
  
  public Booster( Vector2D force ) {
    this.force = force;
  }
  
  protected final void setPoints( Vector2D[] points ) {
    this.points = points;
    calculateNormals( );
  }
  
  private void calculateNormals( ) {
    int length = points.length;
    normals = new Vector2D[length];
    for (int i = 0; i < length; i++ )
      normals[i] = Vector2D.sub( points[(i+1) % length], points[i] ).perp( );
  }
  
  // Note: Polygon must be convex for this to work!
  public boolean contains( Vector2D p ) {
    c = color( 255, 0, 0 );
    for (int i = 0; i < points.length; i++ )
      if ( Vector2D.sub( p, points[i] ).dot( normals[i] ) < 0 ) return false;
    c = color( 0, 255, 0 );
    return true;
  }
  
  public void draw( ) { }
  
  public void drawDebug( ) {
    strokeWeight( 2 );
    fill( c );
    beginShape( );
    for (int i = 0; i < points.length; i++ )
      vertex( (float)points[i].x, (float)points[i].y );
    endShape(CLOSE);
  }
  
  public Vector2D getForce( ) { return force; }
}
