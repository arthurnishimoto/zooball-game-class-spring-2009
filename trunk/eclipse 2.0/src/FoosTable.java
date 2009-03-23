/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class FoosTable {
  Vector2D position;
  Vector2D rotation;
  Vector2D size;

/**
   * Creates a new FoosTable object.
   *
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public FoosTable( float x, float y, float width, float height ) {
    position = new Vector2D( x, y );
    rotation = new Vector2D(  );
    size = new Vector2D( width, height );
  } // end FoosTable()

/**
   * Creates a new FoosTable object.
   *
   * @param position DOCUMENT ME!
   * @param size DOCUMENT ME!
   */
  public FoosTable( Vector2D position, Vector2D size ) {
    this.position = (Vector2D) position.clone(  );
    rotation = new Vector2D(  );
    this.size = (Vector2D) size.clone(  );
  } // end FoosTable()

/**
   * Creates a new FoosTable object.
   *
   * @param position DOCUMENT ME!
   * @param rotation DOCUMENT ME!
   * @param size DOCUMENT ME!
   */
  public FoosTable( Vector2D position, Vector2D rotation, Vector2D size ) {
    this.position = new Vector2D( position );
    this.rotation = new Vector2D( rotation );
    this.size = new Vector2D( size );
  } // end FoosTable()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public BoundingBox getBoundingBox(  ) {
    return new BoundingBox( position, size );
  } // end getBoundingBox()
} // end FoosTable
