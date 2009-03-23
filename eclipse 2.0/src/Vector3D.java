/**
 * Represents a Three-Dimensional Vector
 *
 * @author Andy Bursavich
 * @version 0.5
 */
public class Vector3D implements Cloneable {
  public float x;
  public float y;
  public float z;

/**
   * Constructs and initializes a Vector3D to (0,0,0).
   */
  public Vector3D(  ) {
    x = y = z = 0;
  } // end Vector3D()

/**
   * Constructs and initializes a Vector3D from the specified xyz coordinates.
   * @param x the x coordinate
   * @param y the y coordinate
   * @param z the z coordinate
   */
  public Vector3D( final float x, final float y, final float z ) {
    this.x = x;
    this.y = y;
    this.z = z;
  } // end Vector3D()

/**
   * Creates a new Vector3D object.
   *
   * @param v1 DOCUMENT ME!
   */
  public Vector3D( Vector3D v1 ) {
    x = v1.x;
    y = v1.y;
    z = v1.z;
  } // end Vector3D()

  /**
   * Sets the value of this Vector3D to the vector sum of itself and Vector3D p1.
   *
   * @param v1 the other Vector3D
   */
  public final void add( final Vector3D v1 ) {
    x += v1.x;
    y += v1.y;
    z += v1.z;
  } // end add()

  /**
   * Returns a Vector3D initialized to the vector sum of Vector3D v1 and Vector3D v2.
   *
   * @param v1 the first Vector3D
   * @param v2 the second Vector3D
   *
   * @return the Vector3D vector sum of Vector3D v1 and Vector3D v2
   */
  public static final Vector3D add( final Vector3D v1, final Vector3D v2 ) {
    return new Vector3D( v1.x + v2.x, v1.y + v2.y, v1.z + v2.z );
  } // end add()

  /**
   * Creates and returns a copy of this Vector3D.
   *
   * @return a Vector3D that is a copy of this Vector3D
   */
  public Object clone(  ) {
    return new Vector3D( this );
  } // end clone()

  /**
   * DOCUMENT ME!
   *
   * @param v1 DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public final float dotProduct( final Vector3D v1 ) {
    return ( x * v1.x ) + ( y * v1.y ) + ( z * v1.z );
  } // end dotProduct()

  /**
   * DOCUMENT ME!
   *
   * @param v1 DOCUMENT ME!
   * @param v2 DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public static final float dotProduct( final Vector3D v1, final Vector3D v2 ) {
    return ( v1.x * v2.x ) + ( v1.y * v2.y ) + ( v1.z * v2.z );
  } // end dotProduct()

  /**
   * DOCUMENT ME!
   *
   * @param v1 DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public final Vector3D crossProduct( final Vector3D v1 ) {
    return new Vector3D( ( y * v1.z ) - ( z * v1.y ), ( z * v1.x ) - ( x * v1.z ),
                         ( x * v1.y ) - ( y * v1.x ) );
  } // end crossProduct()

  /**
   * DOCUMENT ME!
   *
   * @param v1 DOCUMENT ME!
   * @param v2 DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public static final Vector3D crossProduct( final Vector3D v1, final Vector3D v2 ) {
    return new Vector3D( ( v1.y * v2.z ) - ( v1.z * v2.y ), ( v1.z * v2.x ) - ( v1.x * v2.z ),
                         ( v1.x * v2.y ) - ( v1.y * v2.x ) );
  } // end crossProduct()

  /**
   * Sets the value of this Vector3D to the vector difference of itself and Vector3D v1 (this
   * = this - v1).
   *
   * @param v1 the other Vector3D
   */
  public final void sub( final Vector3D v1 ) {
    x -= v1.x;
    y -= v1.y;
    z -= v1.z;
  } // end sub()

  /**
   * Returns a Vector3D initialized to the vector difference of Vector3D v1 and Vector3D v2
   * (v1 - v2).
   *
   * @param v1 the first Vector3D
   * @param v2 the second Vector3D
   *
   * @return the Vector3D vector difference of Vector3D v1 and Vector3D v2 (v1 - v2)
   */
  public static final Vector3D sub( final Vector3D v1, final Vector3D v2 ) {
    return new Vector3D( v1.x - v2.x, v1.y - v2.y, v1.z - v2.z );
  } // end sub()

  /**
   * Sets the value of this Vector3D to the scalar multiplication of the scale with this.
   *
   * @param s the scalar value
   */
  public final void scale( final float s ) {
    this.x *= s;
    this.y *= s;
    this.z *= s;
  } // end scale()

  /**
   * Returns a Vector3D initialized to the scalar multiplication of the scale factor with
   * Vector3D v1.
   *
   * @param v1 the Vector3D value
   * @param s the scalar value
   *
   * @return the Vector3D scalar multiplication of the scale factor with Vector3D v1
   */
  public static final Vector3D scale( final Vector3D v1, final float s ) {
    return new Vector3D( v1.x * s, v1.y * s, v1.z * s );
  } // end scale()

  /**
   * Linearly interpolates between this vector and vector v1 and places the result into this
   * vector: this = alphathis + (1-alpha)v1.
   *
   * @param v1 the first vector
   * @param alpha the alpha interpolation parameter
   */
  public final void interpolate( final Vector3D v1, final float alpha ) {
    float alpha1 = 1.0f - alpha;
    this.x = ( alpha * this.x ) + ( alpha1 * v1.x );
    this.y = ( alpha * this.y ) + ( alpha1 * v1.y );
    this.z = ( alpha * this.z ) + ( alpha1 * v1.z );
  } // end interpolate()

  /**
   * Linearly interpolates between vector v1 and vector v2 and returns the result: alphav1 +
   * (1-alpha)v2.
   *
   * @param v1 the first vector
   * @param v2 the second vector
   * @param alpha the alpha interpolation parameter
   *
   * @return the Vector3D that is the linear interpolation of v1 and v2: alphav1 + (1-alpha)v2.
   */
  public static final Vector3D interpolate( final Vector3D v1, final Vector3D v2, final float alpha ) {
    float alpha1 = 1.0f - alpha;

    return new Vector3D( ( alpha * v1.x ) + ( alpha1 * v2.x ),
                         ( alpha * v1.y ) + ( alpha1 * v2.y ), ( alpha * v1.z ) + ( alpha1 * v2.z ) );
  } // end interpolate()

  /**
   * Returns a string that contains the values of this Vector3D. The form is (x,y,z).
   *
   * @return the String representation
   */
  public String toString(  ) {
    return "(" + x + "," + y + "," + z + ")";
  } // end toString()
} // end Vector3D
