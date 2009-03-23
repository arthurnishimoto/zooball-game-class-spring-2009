import processing.core.PApplet;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class BoundingBox {
  Vector2D position;
  Vector2D size;

/**
   * Creates a new BoundingBox object.
   *
   * @param position DOCUMENT ME!
   * @param size DOCUMENT ME!
   */
  public BoundingBox( Vector2D position, Vector2D size ) {
    this.position = new Vector2D( position );
    this.size = new Vector2D( size );
  } // end BoundingBox()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void draw( PApplet p ) {
    p.stroke( 255 );
    p.strokeWeight( 1.0f );
    p.rect( position.x, position.y, size.x, size.y );
  } // end draw()
} // end BoundingBox
