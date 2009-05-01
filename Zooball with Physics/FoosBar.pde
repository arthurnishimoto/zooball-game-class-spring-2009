public class FoosBar
{
  // Foosman Geometry
  private double FOOSMAN_WIDTH, FOOSMAN_HALF_WIDTH, BALL_RADIUS, BALL_DIAMETER;
  private Vector2D A, B, C, D;
  private double PLAY_FIELD_Z; // negative distance from center of rod to center of ball on field
  private double MIN_ROTATION, MAX_ROTATION, MIN_OFFSET, MAX_OFFSET;
  // FoosBar Physics
  private int current;
  private Vector2D position[]; // x doesn't change
  private Vector2D velocity[]; // x=angular, y=linear
  private double rotation[]; // angular rotation, normalized from -pi to pi
  private Vector2D forces; // I don't think this will actually be used
  private Vector2D friction; // Although this is probalby technically incorrect, allow for different friction in different directions
  private double mass, momentOfInertia;
  // Foosmen Instances
  private Image[] images;
  private double[] foosmenPositions;
  private double radius;

  public FoosBar( double x, double y, int foosmen, String team ) throws IllegalArgumentException {
    // Geometry
    FOOSMAN_WIDTH = 53;
    FOOSMAN_HALF_WIDTH = 26.5;
    BALL_RADIUS = 25;
    BALL_DIAMETER = 50;
    A = new Vector2D( -16, 40 );
    B = new Vector2D( -7, -109 );
    C = new Vector2D( 7, -109 );
    D = new Vector2D( 16, 40 );
    PLAY_FIELD_Z = -68;
    double a = -PLAY_FIELD_Z;
    double h = C.magnitude( );
    MIN_ROTATION = -Math.acos( a/h );
    MAX_OFFSET = Math.sqrt( h*h - a*a );
    h = B.magnitude( );
    MAX_ROTATION = Math.acos( a/h );
    MIN_OFFSET = -Math.sqrt( h*h - a*a );

    // instance variables
    if ( foosmen == 1 )
      foosmenPositions = new double[] { 0 };
    else if ( foosmen == 2)
      foosmenPositions = new double[] { -(FOOSMAN_WIDTH + 100), FOOSMAN_WIDTH + 100 };
    else if ( foosmen == 3 )
      foosmenPositions = new double[] { -(FOOSMAN_WIDTH + 165), 0, (FOOSMAN_WIDTH + 165) };
    else if ( foosmen == 5 )
      foosmenPositions = new double[] { -2*(FOOSMAN_WIDTH + 105), -(FOOSMAN_WIDTH + 105), 0, (FOOSMAN_WIDTH + 105), 2*(FOOSMAN_WIDTH + 105) };
    else
      throw new IllegalArgumentException("Invalid number of foosmen - " + foosmen + ". Number must be 1, 2, 3, or 5.");
    radius = 0.5 * (foosmenPositions[foosmenPositions.length-1] - foosmenPositions[0] + FOOSMAN_WIDTH);
    position = new Vector2D[] { new Vector2D( x, y ), new Vector2D( x, y ) };
    velocity = new Vector2D[] { new Vector2D( 0, 0 ), new Vector2D( 0, 0 ) };
    rotation = new double[] { 0, 0 };
    forces = new Vector2D( 0, 0 );
    //mass = 35 + foosmen * 5; // mass of bar plus mass of each foosman
    mass = 100 + foosmen * 20;
    friction = new Vector2D( -2 * mass * 500, -0.5 * mass * 500 ); // gravity ~9.8m/s^2 what is that in px/s^2

    double height = 0.5 * ( (A.y - B.y) + (D.y - C.y) );
    double width = 0.5 * ( (D.x - A.x) + (C.x - B.x) );
    momentOfInertia = mass * ( height*height + width*width ) / 12;
    
    //println( "FOOSBAR REACH = " + (MAX_OFFSET-MIN_OFFSET+BALL_DIAMETER) );
    
    images = new Image[25];
    for ( int i = 0; i < 25; i++ ) {
      images[i] = new Image( "objects/" + team + "/" + i + ".gif" );
      float scale = (float)((MAX_OFFSET-MIN_OFFSET+BALL_DIAMETER) / images[i].getWidth( ));
      images[i].setWidth( images[i].getWidth( ) * scale );
      images[i].setHeight( images[i].getHeight( ) * scale );
    }
  }

  public void step( double dt ) {
    // Runge-Kutta Order 4
    Vector2D p1 = new Vector2D( rotation[current], position[current].y );
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
    position[next].y = position[current].y + v4.y;
    rotation[next] = normalizeRotation( rotation[current] + v4.x );

    // v(n+1) = v(n) + (h/6)*(a1 + 2*a2 + 2*a3 + a4)
    a2.scale( 2 );
    a3.scale( 2 );
    a4.add( a3 );
    a4.add( a2 );
    a4.add( a1 );
    a4.scale( dt / 6.0 );
    velocity[next].set( velocity[current] );
    velocity[next].add( a4 );

    // Velocity might converge to something like, 0.038590812... radians/s so just kill it.
    if ( velocity[current].x == velocity[next].x && Math.abs( velocity[next].x ) < 0.5 )
      velocity[next].x = 0;
    // Velocity might converge to something like, 0.038590812... px/s so just kill it.
    if ( velocity[current].y == velocity[next].y && Math.abs( velocity[next].y ) < 2 )
      velocity[next].y = 0;

    current = next;
  }

  private Vector2D acceleration( Vector2D position, Vector2D velocity ) {
    // sliding friction
    Vector2D direction = new Vector2D( velocity.x == 0 ? 0 : velocity.x < 0 ? -1 : 1, velocity.y == 0 ? 0 : velocity.y < 0 ? -1 : 1 );
    return new Vector2D( direction.x * friction.x / momentOfInertia, direction.y * friction.y / mass );
  }
  
  public void draw( ) {
    int r;
    if ( rotation[current] <= 0 )
      r = (int)(map( (float)rotation[current], 0, -PI, 24, 12 ) + 0.5 ) ;
    else
      r = (int)(map( (float)rotation[current], 0, PI, 0, 12 ) + 0.5 );
    fill( 120 );
    rect( (float)position[current].x-6, 0, 14, 1080 );
    pushMatrix( );
    translate( (float)position[current].x, (float)position[current].y );
    for ( int i = 0; i < foosmenPositions.length; i++ ) {
      pushMatrix( );
      translate( -0.5 * images[r].getWidth( ), (float)foosmenPositions[i] - 0.5*images[r].getHeight( ) );
      images[r].draw( );
      popMatrix( );
    }
    popMatrix( );
  }
  
  public void drawDebug( ) {
    strokeWeight( 2 );
    // This jumble of code is for debugging... to be able to see what's
    // going on with the physics model behind the foosman sprites.
    double sinTheta = Math.sin( rotation[current] );
    double cosTheta = Math.cos( rotation[current] );
    Vector2D a = rotatePoint( A, sinTheta, cosTheta );
    Vector2D b = rotatePoint( B, sinTheta, cosTheta );
    Vector2D c = rotatePoint( C, sinTheta, cosTheta );
    Vector2D d = rotatePoint( D, sinTheta, cosTheta );
    pushMatrix( );
    translate( (float)position[current].x, (float)position[current].y );
    fill( 0, 0 );
    /*
    stroke( 255, 225, 0 );
    //ellipse( 0, 0, (float)(radius+radius), (float)(radius+radius) );
    stroke( 255, 0, 0 );
    rect( (float)MIN_OFFSET, (float)(foosmenPositions[0]-FOOSMAN_HALF_WIDTH), (float)(MAX_OFFSET-MIN_OFFSET), (float)(foosmenPositions[foosmenPositions.length-1]-foosmenPositions[0]+FOOSMAN_WIDTH) );
    stroke( 255, 255, 0 );
    rect( (float)(MIN_OFFSET-BALL_RADIUS), (float)(foosmenPositions[0]-FOOSMAN_HALF_WIDTH-BALL_RADIUS), (float)(MAX_OFFSET-MIN_OFFSET+BALL_DIAMETER), (float)(foosmenPositions[foosmenPositions.length-1]-foosmenPositions[0]+FOOSMAN_WIDTH+BALL_DIAMETER) );
    //*/
    for ( int i = 0; i < foosmenPositions.length; i++ ) {
      pushMatrix( );
      translate( 0, (float)foosmenPositions[i] );
      //*
      // connections
      stroke( 255, 0, 255 );
      line( (float)a.x, (float)FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
      line( (float)c.x, (float)FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
      line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)-FOOSMAN_HALF_WIDTH );
      line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)-FOOSMAN_HALF_WIDTH );      
      if ( rotation[current] < 0.5*Math.PI && rotation[current] > -0.5*Math.PI ) {
        // bottom
        stroke( 0, 0, 255 );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)c.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)b.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
        // top
        stroke( 0, 255, 255 );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)a.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)d.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
      } 
      else {
        // top
        stroke( 0, 255, 255 );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)a.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)d.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
        // bottom
        stroke( 0, 0, 255 );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)c.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)b.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
      }
      //*/
      // intersection
      double[] x = intersectionFoosmanX( );
      if( x != null ) {
        stroke( 255, 0, 0 );
        line( (float)(x[0]-position[current].x), (float)-FOOSMAN_HALF_WIDTH, (float)(x[0]-position[current].x), (float)FOOSMAN_HALF_WIDTH );
        line( (float)(x[0]-position[current].x), (float)FOOSMAN_HALF_WIDTH, (float)(x[1]-position[current].x), (float)FOOSMAN_HALF_WIDTH );
        line( (float)(x[0]-position[current].x), (float)-FOOSMAN_HALF_WIDTH, (float)(x[1]-position[current].x), (float)-FOOSMAN_HALF_WIDTH );
        line( (float)(x[1]-position[current].x), (float)-FOOSMAN_HALF_WIDTH, (float)(x[1]-position[current].x), (float)FOOSMAN_HALF_WIDTH );
        //stroke( 255, 255, 0 );
        //rect( (float)(x[0]-position[current].x-BALL_RADIUS), (float)(-FOOSMAN_HALF_WIDTH-BALL_RADIUS), (float)((x[1]-position[current].x)-(x[0]-position[current].x)+BALL_DIAMETER), (float)(FOOSMAN_WIDTH+BALL_DIAMETER) );
      }
      popMatrix( );
    }
    noStroke( );
    popMatrix( );
  }

  public boolean isAbovePlayField( ) {
    return ( rotation[current] < MIN_ROTATION ) || ( rotation[current] > MAX_ROTATION );
  }
  
  // TODO: currently this only works on horizontal wall, generalize it to vertical or angled
  public boolean collide( Line wall ) {
    double pY = wall.getP1( ).y;
    double nY = position[current].y - pY; // normal pointing towards the ball
    
    // check for interpenetration
    if ( nY*nY > radius*radius )
      return false;
    
    // "A collision occurs when a point on one body touches a point on another body with a
    //  negative relative normal velocity."
    if ( velocity[current].y * nY >= 0 ) // relative normal velocity, the wall isn't moving
       return false;
     
    double elasticity = 0.2; // 1 = elastic, 0 = plastic
    //      -(1 + e) * v . n
    //  j = -----------------
    //       n . n  * ( 1/M )
    double impulse = -(1+elasticity) * velocity[current].y * nY / ( nY * nY / mass );
    //              j
    //  vF2 = vF1 + - * n
    //              M
    velocity[current].y += nY * impulse / mass;
    
    nY = nY == 0 ? 0 : nY > 0 ? 1 : -1; // normalize nY
    position[current].y = pY + nY * radius;
    
    return true;
  }
  
  public boolean collide( Ball ball ) {
    // players are rotated above the play field
    if ( isAbovePlayField( ) )
      return false;

    double ballRight = ball.getX( ) + ball.getRadius( );
    double ballLeft = ball.getX( ) - ball.getRadius( );
    // ball outside of bar's reach
    if ( ( ballLeft > position[current].x + MAX_OFFSET ) || ( ballRight < position[current].x + MIN_OFFSET ) )
      return false;
    
    double ballTop = ball.getY( ) - ball.getRadius( );
    double ballBottom = ball.getY( ) + ball.getRadius( );
    double barTop = position[current].y + foosmenPositions[0] - FOOSMAN_HALF_WIDTH;
    double barBottom = position[current].y + foosmenPositions[foosmenPositions.length-1] + FOOSMAN_HALF_WIDTH;
    // ball is above or below bar's players
    if( ballBottom < barTop || ballTop > barBottom )
      return false;
 
    double[] foosmanX = intersectionFoosmanX( ); // the previous checks are to avoid getting the intersection when possible
    double barLeft = foosmanX[0];
    double barRight = foosmanX[1];
    // ball is left or right of bar's players
    if ( ballRight < barLeft || ballLeft > barRight )
      return false;
      
    //  We now know the intersection of the foosmen with the playing field, and that
    //  the ball is inside the smallest bounding box that includes all players.
    //  +---------------+
    //  |               |
    //  |               |
    //  |     +---+     |
    //  |     |   |     |
    //  |     | F |     |
    //  |     |   |     |
    //  |     +---+     |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |     +---+     |
    //  |     |   |     |
    //  |     | F |     |
    //  |     |   |     |
    //  |     +---+     |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |     +---+     |
    //  |     |   |     |
    //  |     | F |     |
    //  |     |   |     |
    //  |     +---+     |
    //  |               |
    //  |               |
    //  +---------------+
    //  Next we need to check each individual player - one more bounding box.  If the
    //  ball is in this last bounding box, we need to check distance to each line of
    //  the player.
    
    for ( int i = 0; i < foosmenPositions.length; i++ ) {
      // check the last bounding box possible, the one that only includes a single player
      double playerTop = position[current].y + foosmenPositions[i] - FOOSMAN_HALF_WIDTH;
      double playerBottom = position[current].y + foosmenPositions[i] + FOOSMAN_HALF_WIDTH;
      if ( ( ballBottom >= playerTop ) || ( ballTop <= playerBottom ) ) {
        //  Now we know that the ball is inside the player's individual bounding box.
        //  +---------------+
        //  |               |
        //  |               |
        //  |     +---+     |
        //  |     |   |     |
        //  |     | F |     |
        //  |     |   |     |
        //  |     +---+     |
        //  |               |
        //  |               |
        //  +---------------+
        Line[] lines = new Line[4];
        lines[0] = new Line( barLeft, playerTop, barRight, playerTop ); // top of player
        lines[1] = new Line( barLeft, playerBottom, barRight, playerBottom ); // bottom of player
        lines[2] = new Line( barLeft, playerTop, barLeft, playerBottom ); // left of player
        lines[3] = new Line( barRight, playerTop, barRight, playerBottom ); // right of player
        
        //  Ball might interpenetrate the player such that two lines have two different
        //  closest points.  We need to get the closest of these.
        //
        //  L0 = lines[0], CP0 = closest point on L0 to center of ball
        //  L1 = lines[1], CP1 = closest point on L1 to center of ball
        //  L2 = lines[2], CP2 = closest point on L2 to center of ball
        //  L3 = lines[3], CP3 = closest point on L3 to center of ball
        //
        //               /--------------------\
        //              /                      \
        //   +-----L0--/-CP0                    \
        //   |       `/ ``|                      \
        //   |      `/   `|                       \
        //   |      |     |      CENTER            |
        //  CP2     |    CP3       OF              |
        //   |      |     |       BALL             |
        //   |       \    |                       /
        //   L2       \   L3                     /
        //   |         \``|                     /
        //   |          \ |                    /
        //   |           \+-------------------/
        //   |            |
        //   |            |
        //   |            |
        //   +-----L1----CP1
        //
        //  CP0 and CP3 are both inside the ball, but CP3 is closer to the center of the ball.
        //  So use it.
        
        Vector2D ballCenter = ball.getPosition( );
        
        Vector2D[] points = new Vector2D[4];
        points[0] = lines[0].closestPoint( ballCenter );
        points[1] = lines[1].closestPoint( ballCenter );
        points[2] = lines[2].closestPoint( ballCenter );
        points[3] = lines[3].closestPoint( ballCenter );
        
        // assume point[0] is the closest
        Vector2D p = points[0];
        double cd2 = Vector2D.sub( points[0], ballCenter ).magnitudeSquared( ); // cd2 = (closest distance)^2
        // check to see if point[1] is closer
        double d2 = Vector2D.sub( points[1], ballCenter ).magnitudeSquared( ); // d2 = distance^2
        if ( d2 < cd2 ) {
          p = points[1];
          cd2 = d2;
        }
        // check to see if point[2] is closer
        d2 = Vector2D.sub( points[2], ballCenter ).magnitudeSquared( );
        if ( d2 < cd2 ) {
          p = points[2];
          cd2 = d2;
        }
        // check to see if point[3] is closer
        d2 = Vector2D.sub( points[3], ballCenter ).magnitudeSquared( );
        if ( d2 < cd2 ) {
          p = points[3];
          cd2 = d2;
        }
        
        // closest touching the ball
        if ( cd2 <= ball.getRadius( ) * ball.getRadius( ) ) {
          //println("BALL IS TOUCHING FOOSMAN " + (i+1) + " AT TIME: " + game.state.timer.getSecondsActive( ) );
          
          //*
          /////////    HACK FOR FOOSMAN COMING DOWN ON TOP OF BALL    \\\\\\\\\\
          
          int previous = current ^ 1;
          
          if ( rotation[previous] > MAX_ROTATION ) {
            // Foosman just came down from the left side (its moving to the right) and is inside the ball.
            // So move the left side of the ball to the right side of the foosman.
            ballCenter.x = points[3].x + ball.getRadius( );
            ball.setPosition( ballCenter.x, ballCenter.y );
            p = points[3]; // change the point of collision
          }
          // foosman just came down from the left side
          else if ( rotation[previous] < MIN_ROTATION ) {
            // Foosman just came down from the right side (its moving to the left) and is inside the ball.
            // So move the right side of the ball to the left side of the foosman.
            ballCenter.x = points[2].x - ball.getRadius( );
            ball.setPosition( ballCenter.x, ballCenter.y );
            p = points[3]; // change the point of collision
          }
          
          /////////                     END HACK                      \\\\\\\\\\
          //*/
          
          
          // So now we know that the ball and the player are either touching or interpentrating.
          // We need to get their relative normal velocity. If they are moving apart, there is no
          // collision.
          
          Vector2D n = Vector2D.sub( ballCenter, p ); // normal pointing towards the ball
          
          // We need to get the linear velocity for the player. We already have it's y component,
          // but the x component needs to be calculated from it's angular velocity.
          double rFPx = PLAY_FIELD_Z; // This should really be a vector in (x, z), but I just ignore the z and hope for the best
          Vector2D vFP = new Vector2D( velocity[current].x * rFPx, velocity[current].y ); // velocity of foosplayer at p, neglects velocity in z
          Vector2D vBP = ball.getVelocity( ); // velocity of ball at p
          Vector2D vBF = Vector2D.sub( vBP, vFP ); // relative velocity of ball with respect to foosplayer
          
          // "A collision occurs when a point on one body touches a point on another body with a
          //  negative relative normal velocity."
          if ( vBF.dot( n ) >= 0 ) // relative normal velocity
            return false;
            
          //println("BALL IS COLLIDING WITH FOOSMAN " + (i+1) + " AT TIME: " + game.state.timer.getSecondsActive( ) );
          
          // If we got to here, a collision occured!... Now calculate impulse and apply it.
          Vector2D ballVelocity = ball.getVelocity( );
          double elasticity = 0.8;
          double impulse;
          if ( n.y != 0 ) {
            if ( ball.getWallContacts( ).y * n.y >= 0 ) {
              // We don't have to worry about the ball touching the wall. Just apply the impulse to both and be done with it.
              
              //        -(1 + e) * vBF . n
              //  j = ------------------------
              //      n . n  * ( 1/mB + 1/mF )
              impulse = vBF.y * -( 1 + elasticity ) * n.y / ( n.y * n.y * ( 1/mass + 1/ball.getMass( ) ) );
              //              j
              //  vB2 = vB1 + -- * n
              //              mB 
              ballVelocity.y = ballVelocity.y + n.y * impulse / ball.getMass( );
              //              j
              //  vF2 = vF1 - -- * n
              //              mF
              velocity[current].y = velocity[current].y - n.y * impulse / mass;
            }
            else {
              // The ball is touching the wall in the direction we're trying to hit it. We need to apply some trickery.
              // Trickery 1: Lower the elasticity for the ball collision.
              // impulse = vBF.x * -( 1 + elasticity ) * n.x / ( n.x * n.x / ball.getMass( ) + ( rFPdotN * rFPdotN / momentOfInertia ) );
              impulse = vBF.y * -( 1 - 0.1 ) * n.y / ( n.y * n.y * ( 1/mass + 1/ball.getMass( ) ) );
              ballVelocity.y = ballVelocity.y + n.y * impulse / ball.getMass( );
              // Trickery 2: Have the foosman hit a horizontal "wall" at the point on the ball that it really.
              double nY = n.y == 0 ? 0 : n.y > 0 ? 1 : -1; // normalize nY
              double pY = ballCenter.y + ball.getRadius( ) * -nY;
              collide( new Line(0, pY, 1920, pY ) );
              // TODO: Something similar for X
            }
          }
          if ( n.x != 0 ) {
            double rFPdotN = rFPx * n.x; // ignores z of rFP
            if ( ball.getWallContacts( ).x * n.x >= 0 ) {
              // We don't have to worry about the ball touching the wall. Just apply the impulse to both and be done with it.
              
              //                 -(1 + e) * vBF . n
              //  j = ------------------------------------------
              //      n . n  * ( 1/mB ) + ( ( rFP . n )^2 ) / If
              impulse = vBF.x * -( 1 + elasticity ) * n.x / ( n.x * n.x / ball.getMass( ) + ( rFPdotN * rFPdotN / momentOfInertia ) );
              //              j
              //  vB2 = vB1 + -- * n
              //              mB
              ballVelocity.x = ballVelocity.x + n.x * impulse / ball.getMass( );
              //               rFPperp . jn
              //  wF2 = wF1 - --------------    <--- w = angular velocity
              //                     I
              velocity[current].x = velocity[current].x - rFPx * n.x * impulse / momentOfInertia;
            }
            else {
              // The ball is touching the wall in the direction we're trying to hit it. We need to apply some trickery.
              // Trickery 1: Lower the elasticity for the ball collision.
              impulse = vBF.x * -( 1 - 0.5 ) * n.x / ( n.x * n.x / ball.getMass( ) + ( rFPdotN * rFPdotN / momentOfInertia ) );
              ballVelocity.x = ballVelocity.x + n.x * impulse / ball.getMass( );
              // Trickery 2: Just flip the velocity of the foosman and dampen it until I can figure out something better.
              velocity[current].x = -velocity[current].x*0.5;
              // Trickery 3: rotate the player backward to before they hit, to prevent a foosman from passing through the ball.
              rotation[current] = rotation[previous]; // This is not correct, but will fail semi-gracefully... TODO: calculate rotation needed to put the foosbar in the correct spot
            }
          }
          ball.setVelocity( ballVelocity.x, ballVelocity.y );
          
          // TODO: If ball is not touching a wall, move it to touch at point at p. If the ball
          // is touching the wall, move the player to touch at point p.
          return true;
        }
      }
    }
    
    // ball is not inside any of the players' individual bounding box
    return false;
  }

  //               Z
  //               |
  //               |
  //   A           |           D
  //    \          |          /
  //     \         |         /
  // <----\----position-----/----> X
  //       \       |       /
  // ------(X)-----+-----(X)------ PLAY_FIELD_Z
  //         \     |     /
  //          \    |    /
  //           B___|___C
  //               |
  //               |
  private double[] intersectionFoosmanX( ) {
    // no intersection
    if ( isAbovePlayField( ) )
      return null;
    // intersection at one point - b
    if ( rotation[current] == MAX_ROTATION )
    return new double[] { 
      position[current].x + MIN_OFFSET, position[current].x + MIN_OFFSET                 };
    // intersection at one point - c
    if ( rotation[current] == MIN_ROTATION )
    return new double[] { 
      position[current].x + MAX_OFFSET, position[current].x + MAX_OFFSET                 };
    // intersection at two points - on AB, BC, or CD
    double[] points = new double[2];
    int found = 0;
    double sinTheta = Math.sin( rotation[current] );
    double cosTheta = Math.cos( rotation[current] );
    Vector2D a = rotatePoint( A, sinTheta, cosTheta );
    Vector2D b = rotatePoint( B, sinTheta, cosTheta );
    Vector2D c = rotatePoint( C, sinTheta, cosTheta );
    Vector2D d = rotatePoint( D, sinTheta, cosTheta );
    // AB intersects
    if ( b.y < PLAY_FIELD_Z )
      points[found++] = position[current].x + intersectionLineX( a, b );
    // BC intersects
    if ( ( b.y < PLAY_FIELD_Z ) != ( c.y < PLAY_FIELD_Z ) )
      points[found++] = position[current].x + intersectionLineX( b, c );
    // CD intersects
    if ( c.y < PLAY_FIELD_Z )
      points[found++] = position[current].x + intersectionLineX( c, d );
    return points;
  }

  // \           Z
  //  \          |
  //   \         |
  //    A        |
  //     \       |
  // <----\------+-----------> X
  //       \     |
  // ------(X)---|------------ PLAY_FIELD_Z
  //         \   |
  //          B  |
  //           \ |
  private double intersectionLineX( Vector2D a, Vector2D b ) {
    return ( PLAY_FIELD_Z - a.y ) * ( b.x - a.x ) / ( b.y - a.y ) + a.x;
  }

  private Vector2D rotatePoint( Vector2D p, double sinTheta, double cosTheta ) {
    return new Vector2D( p.x * cosTheta + p.y * sinTheta, p.y * cosTheta - p.x * sinTheta );
  }

  private double normalizeRotation( double r ) {
    while ( r < -Math.PI )
      r += Math.PI + Math.PI;
    while ( r > Math.PI )
      r -= Math.PI + Math.PI;
    return r;
  }

  public Vector2D getPosition( ) { return new Vector2D( position[current] ); }
  public void setPosition( double x, double y ) {
    int previous = current^1;
    position[previous].x = x;
    position[previous].y = y;
    position[current].x = x;
    position[current].y = y;
  }
  public Vector2D getVelocity( ) { return velocity[current]; }
  public void setVelocity( double angular, double linear ) {
    int previous = current^1;
    velocity[previous].x = angular;
    velocity[previous].y = linear;
    velocity[current].x = angular;
    velocity[current].y = linear;
  }
  public double getRotation( ) { return rotation[current]; }
  public void setRotation( double rotation ) {
    this.rotation[current] = normalizeRotation( rotation );
    this.rotation[current^1] = this.rotation[current];
  }
}

