/**
 * Represents a Two-Dimensional Vector
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Vector2D implements Cloneable {
  public float x;
  public float y;

/**
   * Constructs and initializes a Vector2D to (0,0).
   */
  public Vector2D(  ) {
    x = y = 0;
  } // end Vector2D()

/**
   * Constructs and initializes a Vector2D from the specified xy coordinates.
   * @param x the x coordinate
   * @param y the y coordinate
   */
  public Vector2D( final float x, final float y ) {
    this.x = x;
    this.y = y;
  } // end Vector2D()

/**
   * Creates a new Vector2D object.
   *
   * @param v1 DOCUMENT ME!
   */
  public Vector2D( Vector2D v1 ) {
    x = v1.x;
    y = v1.y;
  } // end Vector2D()

  /**
   * Sets the value of this Vector2D to the vector sum of itself and Vector2D v1.
   *
   * @param v1 the other Vector2D
   */
  public final void add( final Vector2D v1 ) {
    x += v1.x;
    y += v1.y;
  } // end add()

  /**
   * Returns a Vector2D initialized to the vector sum of Vector2D v1 and Vector2D v2.
   *
   * @param v1 the first Vector2D
   * @param v2 the second Vector2D
   *
   * @return the Vector2D vector sum of Vector2D v1 and Vector2D v2
   */
  public static final Vector2D add( final Vector2D v1, final Vector2D v2 ) {
    return new Vector2D( v1.x + v2.x, v1.y + v2.y );
  } // end add()

  /**
   * Creates and returns a copy of this Vector2D.
   *
   * @return a Vector2D that is a copy of this Vector2D
   */
  public Object clone(  ) {
    return new Vector2D( this );
  } // end clone()

  /**
   * DOCUMENT ME!
   *
   * @param v1 DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public final float dotProduct( final Vector2D v1 ) {
    return ( x * v1.x ) + ( y * v1.y );
  } // end dotProduct()

  /**
   * DOCUMENT ME!
   *
   * @param v1 DOCUMENT ME!
   * @param v2 DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public static final float dotProduct( final Vector2D v1, final Vector2D v2 ) {
    return ( v1.x * v2.x ) + ( v1.y * v2.y );
  } // end dotProduct()

  /**
   * Sets the value of this Vector2D to the vector difference of itself and Vector2D v1 (this
   * = this - v1).
   *
   * @param v1 the other Vector2D
   */
  public final void sub( final Vector2D v1 ) {
    x -= v1.x;
    y -= v1.y;
  } // end sub()

  /**
   * Returns a Vector2D initialized to the vector difference of Vector2D v1 and Vector2D v2
   * (v1 - v2).
   *
   * @param v1 the first Vector2D
   * @param v2 the second Vector2D
   *
   * @return the Vector2D vector difference of Vector2D v1 and Vector2D v2 (v1 - v2)
   */
  public static final Vector2D sub( final Vector2D v1, final Vector2D v2 ) {
    return new Vector2D( v1.x - v2.x, v1.y - v2.y );
  } // end sub()

  /**
   * Sets the value of this Vector2D to the scalar multiplication of the scale with this.
   *
   * @param s the scalar value
   */
  public final void scale( final float s ) {
    this.x *= s;
    this.y *= s;
  } // end scale()

  /**
   * Returns a Vector2D initialized to the scalar multiplication of the scale factor with
   * Vector2D v1.
   *
   * @param v1 the Vector2D value
   * @param s the scalar value
   *
   * @return the Vector2D scalar multiplication of the scale factor with Vector2D v1
   */
  public static final Vector2D scale( final Vector2D v1, final float s ) {
    return new Vector2D( v1.x * s, v1.y * s );
  } // end scale()

  /**
   * Linearly interpolates between this vector and vector v1 and places the result into this
   * vector: this = alphathis + (1-alpha)v1.
   *
   * @param v1 the first vector
   * @param alpha the alpha interpolation parameter
   */
  public final void interpolate( final Vector2D v1, final float alpha ) {
    float alpha1 = 1.0f - alpha;
    this.x = ( alpha * this.x ) + ( alpha1 * v1.x );
    this.y = ( alpha * this.y ) + ( alpha1 * v1.y );
  } // end interpolate()

  /**
   * Linearly interpolates between vector v1 and vector v2 and returns the result: alphav1 +
   * (1-alpha)v2.
   *
   * @param v1 the first vector
   * @param v2 the second tuple
   * @param alpha the alpha interpolation parameter
   *
   * @return the Vector2D that is the linear interpolation of v1 and v2: alphav1 + (1-alpha)v2.
   */
  public static final Vector2D interpolate( final Vector2D v1, final Vector2D v2, final float alpha ) {
    float alpha1 = 1.0f - alpha;

    return new Vector2D( ( alpha * v1.x ) + ( alpha1 * v2.x ), ( alpha * v1.y ) + ( alpha1 * v2.y ) );
  } // end interpolate()

  /**
   * Returns a string that contains the values of this Vector2D. The form is (x,y,z).
   *
   * @return the String representation
   */
  public String toString(  ) {
    return "(" + x + "," + y + ")";
  } // end toString()
} // end Vector2D
