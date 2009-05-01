public class Ball
{
  private int current;
  private Vector2D position[];
  private Vector2D velocity[];
  private double direction[];
  private double rotation[];
  private Vector2D forces, wallContacts;
  private double mass, inverseMass, radius, friction;
  private Image[] images;
  private Image shadow;
  
  public Ball( double x, double y ) {
    current = 0;
    position = new Vector2D[] { new Vector2D( x, y ), new Vector2D( x, y ) };
    velocity = new Vector2D[] { new Vector2D( 0, 0 ), new Vector2D( 0, 0 ) };
    direction = new double[] { 0, 0 };
    rotation = new double[] { 0, 0 };
    forces = new Vector2D( 0, 0 );
    wallContacts = new Vector2D( 0, 0 );
    mass = 5;
    inverseMass = 1 / mass;
    radius = 25;
    // Friction = -mu * mass * gravity * (velocity / |velocity|)
    // friction = -mu * mass * gravity;
    friction = -0.05 * mass * 500; // gravity ~9.8m/s^2 what is that in px/s^2
    
    images = new Image[25];
    for ( int i = 0; i < 25; i++ ) {
      images[i] = new Image( "objects/ball/" + i + ".gif" );
      images[i].setSize( 50, 50 );
      images[i].setPosition( -25, -25 );
    }
    shadow = new Image( "objects/ball/shadow.png" );
    shadow.setSize( 50, 50 );
    shadow.setPosition( -25, -25 );
  }
  
  public void draw( ) {
    pushMatrix( );
    translate( (float)position[current].x, (float)position[current].y);
    pushMatrix( );
    rotate( PI - (float)direction[current] );
    images[(int)(map( (float)rotation[current], 0, TWO_PI, 24, 0 ) + 0.5 )].draw( );
    popMatrix( );
    shadow.draw( );
    popMatrix();
  }

  public void drawDebug( ) {
    strokeWeight( 2 );
    pushMatrix( );
    translate( (float)position[current].x, (float)position[current].y);
    fill( 0, 0 );
    stroke( 255, 255, 255 );
    ellipse( 0, 0, (float)(radius+radius), (float)(radius+radius) );
    stroke( 255, 0, 0 );
    line( 0, 0, (float)velocity[current].x, (float)velocity[current].y );
    rotateZ( HALF_PI - (float)direction[current] );
    rotateY( HALF_PI + (float)rotation[current] );
    stroke(0, 0, 255);
    line(0, 0, (float)radius, 0);
    stroke(0, 255, 0);
    line(0, 0, (float)-radius, 0);
    noStroke();
    popMatrix();
  }
  
  public boolean collide( Line wall ) {
    Vector2D p = wall.closestPoint( position[current] );
    Vector2D n = Vector2D.sub( position[current], p ); // normal pointing towards the ball
    
    // check for interpenetration
    if ( n.magnitudeSquared( ) > radius*radius )
      return false;
    
    // the ball is touching the wall
    wallContacts.add( n ); // keep track of this to use in collisions with foosbar collisions
    
    // "A collision occurs when a point on one body touches a point on another body with a
    //  negative relative normal velocity."
    if ( velocity[current].dot( n ) >= 0 ) // relative normal velocity, the wall isn't moving
       return false;
     
    double elasticity = 0.8; // 1 = elastic, 0 = plastic
    //      -(1 + e) * v . n
    //  j = -----------------
    //       n . n  * ( 1/M )
    double impulse = Vector2D.scale( velocity[current], -( 1 + elasticity ) ).dot( n ) / ( n.dot( n ) / mass );
    //              j
    //  vB2 = vB1 + - * n
    //              M
    velocity[current].add( Vector2D.scale( n, impulse / mass ) );
    // move ball to touch exactly at p
    n.norm( );
    n.scale( radius );
    p.add( n );
    position[current].x = p.x;
    position[current].y = p.y;
    
    return true;
  }
  
  public void clearWallContacts( ) {
    wallContacts.x = 0;
    wallContacts.y = 0;
  }
  public Vector2D getWallContacts( ) { return new Vector2D( wallContacts ); }
  
  public void step( double dt ) {
    // Runge-Kutta Order 4
    Vector2D p1 = position[current];
    Vector2D v1 = velocity[current];
    Vector2D a1 = acceleration( p1, v1 );
    
    Vector2D p2 = Vector2D.add( p1, Vector2D.scale( v1, 0.5*dt ) );
    Vector2D v2 = Vector2D.add( v1, Vector2D.scale( a1, 0.5*dt ) );
    Vector2D a2 = acceleration( p2, v2 );
    
    Vector2D p3 = Vector2D.add( p1, Vector2D.scale( v2, 0.5*dt ) );
    Vector2D v3 = Vector2D.add( v1, Vector2D.scale( a2, 0.5*dt ) );
    Vector2D a3 = acceleration( p3, v3 );
    
    Vector2D p4 = Vector2D.add( p1, Vector2D.scale( v3, dt ) );
    Vector2D v4 = Vector2D.add( v1, Vector2D.scale( a3, dt ) );
    Vector2D a4 = acceleration( p4, v4 );
    
    int next = current ^ 1;
    
    // p(n+1) = p(n) + (h/6)*(v1 + 2*v2 + 2*v3 + v4)
    v2.scale( 2 );
    v3.scale( 2 );
    v4.add( v3 );
    v4.add( v2 );
    v4.add( v1 );
    v4.scale( dt / 6.0 );
    position[next].set( position[current] );
    position[next].add( v4 );
     
    // v(n+1) = v(n) + (h/6)*(a1 + 2*a2 + 2*a3 + a4)
    a2.scale( 2 );
    a3.scale( 2 );
    a4.add( a3 );
    a4.add( a2 );
    a4.add( a1 );
    a4.scale( dt / 6.0 );
    velocity[next].set( velocity[current] );
    velocity[next].add( a4 );

    // Velocity might converge to something like, 0.038590812... px/s so just kill it.
    //if ( velocity[current].x == velocity[next].x && Math.abs( velocity[next].x ) < 0.5 )
      //velocity[next].x = 0;
    //if ( velocity[current].y == velocity[next].y && Math.abs( velocity[next].y ) < 0.5 )
      //velocity[next].y = 0;
    if ( velocity[next].x != 0 || velocity[next].y != 0 ) {
      // Changing the rotation when the velocity drops to zero would cause it to "jump"
      direction[next] = Math.atan2( velocity[next].x, velocity[next].y );
      // circumfrence = 2*pi * r;
      // revolutions = distance / circumfrence
      // rotation = revolutions * 2*pi = (distance / (2*pi * r)) * 2*pi = distance / r
      rotation[next] = normalizeRotation( rotation[current] + v4.magnitude( ) / radius );
    }
    
    current = next;
  }
  // TODO: Use position to check for booster? Probably not worth it...
  // Currently calculates friction, but assumes other external forces are constant through step
  // i.e. If it was on the booster before the step, it assumes it stays on the booster throughout the step
  // And if it was off the booster before the step, it assumes it stays off the booster througout the step
  private Vector2D acceleration( Vector2D position, Vector2D velocity ) {
    // sliding friction
    Vector2D forces = new Vector2D( velocity );
    forces.norm( );
    forces.scale( friction );
    // add existing forces
    forces.add( this.forces );
    // divide by mass
    forces.scale( inverseMass ); // a = F/m
    return forces;
  }
  public void clearForces( ) {
    forces.x = 0;
    forces.y = 0;
  }
  public void addForce( Vector2D force ) {
    forces.x += force.x;
    forces.y += force.y;
  }
  
  // This was intended for backtracking which probably won't be implemented
  public void undoStep( ) {
    current ^= 1;
  }
  
  private double normalizeRotation( double r ) {
    while ( r < 0 )
      r += Math.PI + Math.PI;
    while ( r >= Math.PI + Math.PI )
      r -= Math.PI + Math.PI;
    return r;
  }
 
  public double getMass( ) { return mass; }
  public double getRadius( ) { return radius; }
  public double getX( ) { return position[current].x; }
  public double getY( ) { return position[current].y; }
  public Vector2D getPosition( ) { return position[current]; }
  public void setPosition( double x, double y ) {
    this.position[current].x = x;
    this.position[current].y = y;
    this.position[current^1].x = x;
    this.position[current^1].y = y;
  }
  public Vector2D getVelocity( ) { return velocity[current]; }
  public void setVelocity( double x, double y ) {
    velocity[current].x = x;
    velocity[current].y = y;
    direction[current] = Math.atan2( velocity[current].x, velocity[current].y );
    velocity[current^1].x = x;
    velocity[current^1].y = y;
    direction[current^1] = direction[current];
  }
  public double getRotation( ) { return rotation[current]; }
  public void setRotation( double rotation ) {
    this.rotation[current] = normalizeRotation( rotation );
    this.rotation[current^1] = this.rotation[current];
  }
}
