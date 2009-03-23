import processing.core.PApplet;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class FoosBall {
  PApplet parent;
  Vector3D position;
  float density;
  float radius;
  int id;

/**
   * Creates a new Ball object.
   *
   * @param parent DOCUMENT ME!
   * @param id DOCUMENT ME!
   * @param position DOCUMENT ME!
   * @param radius DOCUMENT ME!
   * @param density DOCUMENT ME!
   */
  public FoosBall( PApplet parent, int id, Vector3D position, float radius, float density ) {
    this.parent = parent;
    this.id = id;
    this.position = (Vector3D) position.clone(  );
    this.radius = radius;
    this.density = density;
  } // end FoosBall()
} // end FoosBall
