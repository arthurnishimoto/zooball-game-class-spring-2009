package ise.objects;

import processing.core.PApplet;
import ise.math.Vector2D;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Line {
  protected PApplet p;
  protected Vector2D a;
  protected Vector2D b;
  protected Vector2D velocity = new Vector2D();
  protected int color;
  public boolean collision = false; // DEBUG

/**
   * Creates a new Line object.
   *
   * @param x1 DOCUMENT ME!
   * @param y1 DOCUMENT ME!
   * @param x2 DOCUMENT ME!
   * @param y2 DOCUMENT ME!
   */
  public Line( PApplet p, float x1, float y1, float x2, float y2 ) {
	  this.p = p;
    a = new Vector2D( x1, y1 );
    b = new Vector2D( x2, y2 );
    color = p.color(0, 0, 255);
  } // end Line()
  
  public Line( PApplet p, Vector2D a, Vector2D b ) {
	  this.p = p;
	    this.a = new Vector2D( a );
	    this.b = new Vector2D( b );
	    color = p.color(0, 0, 255);
	  } // end Line()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isHorizontal(  ) {
    return a.x == b.x;
  } // end isHorizontal()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param p1 DOCUMENT ME!
   */
  public void setA( Vector2D a ) {
    this.a = a;
  } // end setP1()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public Vector2D getA(  ) {
    return a;
  } // end getP1()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param p2 DOCUMENT ME!
   */
  public void setB( Vector2D b ) {
    this.b = b;
  } // end setP2()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public Vector2D getB(  ) {
    return b;
  } // end getP2()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isVertical(  ) {
    return a.y == b.y;
  } // end isVertical()
  
  public void draw() {
	  if (collision) p.stroke( 255, 0, 0 ); // DEBUG
	  else p.stroke(color);
	  p.strokeWeight(2);
	  p.line(a.x, a.y, b.x, b.y);
	  p.noStroke();
  }
  
  public float distanceToPoint( Vector2D p ) {
	  return p.distance( closestPoint( p ) ); 
  }

  /**
   * Gets the closest point on this Line to another point
   *
   * @param p The other point.
   *
   * @return The closest point on this Line.
   */
  public Vector2D closestPoint( Vector2D p ) {
	// http://www.gamedev.net/community/forums/topic.asp?topic_id=198199
    Vector2D v = Vector2D.sub( b, a ); // b - a
    float m = v.magnitude(  ); // Length of the line segment
    v.normalize( ); // Unit Vector from a to b
    float t = v.dotProduct( Vector2D.sub( p, a ) ); // Intersection point Distance from a

    // Check to see if the point is on the line
    // if not then return the endpoint
    if ( t <= 0 ) {
      return a;
    } // end if

    if ( t >= m ) {
      return b;
    } // end if

    // get the distance to move from point a
    v.scale( t );
    // move from point a to the nearest point on the segment
    v.add( a );
    return v;
  } // end closestPoint()
} // end Line
