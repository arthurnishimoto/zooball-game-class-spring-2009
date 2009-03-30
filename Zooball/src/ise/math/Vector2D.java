package ise.math;

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
   * Calculates the distance of this Vector2D to another Vector2D.
   *
   * @param v1 The other Vector2D.
   *
   * @return The distance.
   */
  public float distance( Vector2D v1 ) {
    return (float) Math.sqrt( distanceSquared( v1 ) );
  } // end distance()

  /**
   * Calculates the distance between two Vector2D objects.
   *
   * @param v1 The first Vector2D.
   * @param v2 The second Vector2D.
   *
   * @return The distance.
   */
  public static float distance( Vector2D v1, Vector2D v2 ) {
    return (float) Math.sqrt( distanceSquared( v1, v2 ) );
  } // end distance()

  /**
   * Calculates the distance squared of this Vector2D to another Vector2D.
   *
   * @param v1 The other Vector2D.
   *
   * @return The distance squared.
   */
  public float distanceSquared( Vector2D v1 ) {
    float dx = v1.x - x;
    float dy = v1.y - y;

    return ( dx * dx ) + ( dy * dy );
  } // end distanceSquared()

  /**
   * Calculates the distance squared between two Vector2D objects.
   *
   * @param v1 The first Vector2D.
   * @param v2 The second Vector2D.
   *
   * @return The distance squared.
   */
  public static float distanceSquared( Vector2D v1, Vector2D v2 ) {
    float dx = v1.x - v2.x;
    float dy = v1.y - v2.y;

    return ( dx * dx ) + ( dy * dy );
  } // end distanceSquared()

  /**
   * Gets the magnitude of this vector.
   *
   * @return The magnitude.
   */
  public float magnitude(  ) {
    return (float) Math.sqrt( ( x * x ) + ( y * y ) );
  } // end magnitude()

  /**
   * Normalizes this vector to the magnitude equal to 1. No change occurs if the current
   * magnitude is 0.
   */
  public void normalize(  ) {
    float m = magnitude(  );

    if ( m != 0 ) {
      x /= m;
      y /= m;
    } // end if
  } // end normalise()

  /**
   * Gets the normalized vector with a magnitude equal to 1. No change occurs if the
   * magnitude is 0.
   *
   * @param v1 The vector.
   *
   * @return The normalized vector.
   */
  public static Vector2D normalize( Vector2D v1 ) {
    Vector2D value = new Vector2D( v1 );
    float m = value.magnitude(  );

    if ( m != 0 ) {
      value.x /= m;
      value.y /= m;
    } // end if

    return value;
  } // end normalize()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param obj DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  @Override
  public boolean equals( Object obj ) {
    if ( obj instanceof Vector2D ) {
      return ( ( (Vector2D) obj ).x == x ) && ( ( (Vector2D) obj ).y == y );
    } else {
      return false;
    }
  } // end equals()
  
  public void negate() {
	  x = -x;
	  y = -y;
  }

  /**
   * Returns a string that contains the values of this Vector2D. The form is (x,y,z).
   *
   * @return the String representation
   */
  public String toString(  ) {
    return "(" + x + "," + y + ")";
  } // end toString()
} // end Vector2D
