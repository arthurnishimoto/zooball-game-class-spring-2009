package ise.objects;

import ise.math.Vector2D;
import ise.utilities.Timer;

import processing.core.PApplet;
import processing.core.PConstants;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Ball {
  protected PApplet p;
  protected Timer timer;
  protected Vector2D center;
  protected Vector2D velocity;
  protected float density;
  protected float radius;
  protected float rotation = 0;
  protected float lastRotation = 0;
  protected int lastUpdate = -1;
  protected Vector2D lastCenter;
  protected int color;

/**
   * Creates a new Ball object.
   *
   * @param x The x value of the center.
   * @param y The y value of the center.
   * @param radius The radius.
   * @param density The density.
   */
  public Ball( PApplet p, Timer timer, float x, float y, float radius, float density ) {
    this.p = p;
    this.timer = timer;
    center = new Vector2D( x, y );
    velocity = new Vector2D( 0, 0 );
    this.radius = radius;
    this.density = density;
    color = p.color(0, 0, 0);
  } // end Ball()

/**
   * Creates a new Ball object.
   *
   * @param center The center of this Ball
   * @param radius The radius of this Ball
   * @param density The density of this Ball
   */
  public Ball( PApplet p, Timer timer, Vector2D center, float radius, float density ) {
    this.p = p;
    this.timer = timer;
    center = new Vector2D( center );
    velocity = new Vector2D( 0, 0 );
    this.radius = radius;
    this.density = density;
    color = p.color(0, 0, 0);
  } // end Ball()
  
  public void update(  ) {
	if (lastUpdate == -1) {
		lastUpdate = timer.getMillisecondsActive();
		lastCenter = new Vector2D( center );
		lastRotation = 0;
	} else {
		float dt = (timer.getMillisecondsActive() - lastUpdate) * 0.001f;
		center = Vector2D.add(lastCenter, Vector2D.scale(velocity, dt));
		Vector2D dir = Vector2D.sub(center, lastCenter);
		float m = dir.magnitude();
		rotation = m * PConstants.TWO_PI / getCircumfrence();
		rotation += lastRotation;
	}
  }
  
  public float getCircumfrence()  {
	  return PConstants.TWO_PI * radius;
  }

  /**
   * Sets the center of this Ball.
   *
   * @param center The center.
   */
  public void setCenter( Vector2D center ) {
    this.center = center;
  } // end setCenter()

  /**
   * Gets the center of this Ball.
   *
   * @return The center.
   */
  public Vector2D getCenter(  ) {
    return center;
  } // end getCenter()

  /**
   * Sets the density of this Ball.
   *
   * @param density The density.
   */
  public void setDensity( float density ) {
    this.density = density;
  } // end setDensity()

  /**
   * Gets the density of this Ball.
   *
   * @return The density.
   */
  public float getDensity(  ) {
    return density;
  } // end getDensity()

  /**
   * Gets this mass of this ball.
   *
   * @return The mass.
   */
  public float getMass(  ) {
    return density * getVolume(  );
  } // end getMass()

  /**
   * Sets the radius of this Ball.
   *
   * @param radius The radius.
   */
  public void setRadius( float radius ) {
    this.radius = radius;
  } // end setRadius()

  /**
   * Gets the radius of this Ball.
   *
   * @return The radius.
   */
  public float getRadius(  ) {
    return radius;
  } // end getRadius()

  /**
   * Sets the velocity of this Ball.
   *
   * @param velocity The velocity.
   */
  public void setVelocity( Vector2D velocity ) {
    this.velocity = velocity;
  } // end setVelocity()

  /**
   * Gets the velocity of this Ball.
   *
   * @return The velocity.
   */
  public Vector2D getVelocity(  ) {
    return velocity;
  } // end getVelocity()

  /**
   * Gets the volume of this Ball.
   *
   * @return The volume.
   */
  public float getVolume(  ) {
    return 1.333333333333f * radius * radius * radius;
  } // end getVolume()

  /**
   * Collides this Ball with a Line.
   *
   * @param line The line.
   *
   * @return Whether or not a collision occurred.
   */
  public boolean collide( Line line ) {
	    float bx = center.x;
	    float by = center.y;
	    Vector2D p = line.closestPoint( center );
	    float px = p.x;
	    float py = p.y;
	    float br = radius;
	    float pr = 0;
	    float dx = px - bx;
	    float dy = py - by;
	    float d = (float) Math.sqrt( ( dx * dx ) + ( dy * dy ) );

    if ( d <= radius ) {
    	// TODO: Rewind Time!
        float vx1 = velocity.x;
        float vy1 = velocity.y;
        float vx2 = line.velocity.x;
        float vy2 = line.velocity.y;
        float mass1 = getMass(  );
        float mass2 = Float.MAX_VALUE;

        // velocity in the direction of (dx, dy)
        float vp1 = ( ( vx1 * dx ) + ( vy1 * dy ) ) / d;
        float vp2 = ( ( vx2 * dx ) + ( vy2 * dy ) ) / d;
        
        // collision should have happened dt before
        float dt = ( ( br + pr ) - d ) / ( vp1 - vp2 );
        // move the circles backward in time
        bx -= ( vx1 * dt );
        by -= ( vy1 * dt );
        px -= ( vx2 * dt );
        py -= ( vy2 * dt );
        // new collision calculations at impact
        dx = px - bx;
        dy = py - by;
        d = (float) Math.sqrt( ( dx * dx ) + ( dy * dy ) );

        // unit vector in the direction of the collision
        float ax = dx / d;
        float ay = dy / d;

        // projection of the velocities in these axes
        float va1 = ( vx1 * ax ) + ( vy1 * ay );
        float vb1 = ( -vx1 * ay ) + ( vy1 * ax );
        float va2 = ( vx2 * ax ) + ( vy2 * ay );
        float vb2 = ( -vx2 * ay ) + ( vy2 * ax );

        // calculate new velocity after collision
        float ed = 1;
        float vaP1 = va1 + ( ( ( 1 + ed ) * ( va2 - va1 ) ) / ( 1 + ( mass1 / mass2 ) ) );
        float vaP2 = va2 + ( ( ( 1 + ed ) * ( va1 - va2 ) ) / ( 1 + ( mass2 / mass1 ) ) );
        // undo projections
        vx1 = ( vaP1 * ax ) - ( vb1 * ay );
        vy1 = ( vaP1 * ay ) + ( vb1 * ax );
        vx2 = ( vaP2 * ax ) - ( vb2 * ay );
        vy2 = ( vaP2 * ay ) + ( vb2 * ax );
        // move time dt forward
        bx += ( vx1 * dt );
        by += ( vy1 * dt );
        px += ( vx2 * dt );
        py += ( vy2 * dt );
        
    	lastCenter.x = center.x;
    	lastCenter.y = center.y;
    	lastUpdate = timer.getMillisecondsActive();
    	lastRotation = rotation;
    	
        // update locations and velocities
        if ( !Float.isNaN( bx ) ) {
          center.x = bx;
        } // end if

        if ( !Float.isNaN( by ) ) {
          center.y = by;
        } // end if

        if ( !Float.isNaN( vx1 ) ) {
          velocity.x = vx1;
        } // end if

        if ( !Float.isNaN( vy1 ) ) {
          velocity.y = vy1;
        } // end if
    	
    	return true;
    } // end if
    else {
      return false;
    } // end else
  } // end collide()

  /**
   * Collides this Ball with another Ball.
   *
   * @param ball The other Ball.
   *
   * @return Whether or not a collision occurred.
   */
  public boolean collide( Ball ball ) {
    float x1 = center.x;
    float y1 = center.y;
    float x2 = ball.center.x;
    float y2 = ball.center.y;
    float r1 = radius;
    float r2 = ball.radius;
    float dx = x2 - x1;
    float dy = y2 - y1;
    float d = (float) Math.sqrt( ( dx * dx ) + ( dy * dy ) );

    if ( d <= ( r1 + r2 ) ) {
      float vx1 = velocity.x;
      float vy1 = velocity.y;
      float vx2 = ball.velocity.x;
      float vy2 = ball.velocity.y;
      float mass1 = getMass(  );
      float mass2 = ball.getMass(  );

      // velocity in the direction of (dx, dy)
      float vp1 = ( ( vx1 * dx ) + ( vy1 * dy ) ) / d;
      float vp2 = ( ( vx2 * dx ) + ( vy2 * dy ) ) / d;

      // collision should have happened dt before
      float dt = ( ( r1 + r2 ) - d ) / ( vp1 - vp2 );
      // move the circles backward in time
      x1 -= ( vx1 * dt );
      y1 -= ( vy1 * dt );
      x2 -= ( vx2 * dt );
      y2 -= ( vy2 * dt );
      // new collision calculations at impact
      dx = x2 - x1;
      dy = y2 - y1;
      d = (float) Math.sqrt( ( dx * dx ) + ( dy * dy ) );

      // unit vector in the direction of the collision
      float ax = dx / d;
      float ay = dy / d;

      // projection of the velocities in these axes
      float va1 = ( vx1 * ax ) + ( vy1 * ay );
      float vb1 = ( -vx1 * ay ) + ( vy1 * ax );
      float va2 = ( vx2 * ax ) + ( vy2 * ay );
      float vb2 = ( -vx2 * ay ) + ( vy2 * ax );

      // calculate new velocity after collision
      float ed = 1;
      float vaP1 = va1 + ( ( ( 1 + ed ) * ( va2 - va1 ) ) / ( 1 + ( mass1 / mass2 ) ) );
      float vaP2 = va2 + ( ( ( 1 + ed ) * ( va1 - va2 ) ) / ( 1 + ( mass2 / mass1 ) ) );
      // undo projections
      vx1 = ( vaP1 * ax ) - ( vb1 * ay );
      vy1 = ( vaP1 * ay ) + ( vb1 * ax );
      vx2 = ( vaP2 * ax ) - ( vb2 * ay );
      vy2 = ( vaP2 * ay ) + ( vb2 * ax );
      // move time dt forward
      x1 += ( vx1 * dt );
      y1 += ( vy1 * dt );
      x2 += ( vx2 * dt );
      y2 += ( vy2 * dt );
      
      lastUpdate = timer.getMillisecondsActive();
      lastCenter.x = center.x;
      lastCenter.y = center.y;
      lastRotation = rotation;
      
      ball.lastUpdate = timer.getMillisecondsActive();
      ball.lastCenter.x = ball.center.x;
      ball.lastCenter.y = ball.center.y;
      ball.lastRotation = ball.rotation;

      // update locations and velocities
      if ( !Float.isNaN( x1 ) ) {
        center.x = x1;
      } // end if

      if ( !Float.isNaN( y1 ) ) {
        center.y = y1;
      } // end if

      if ( !Float.isNaN( x2 ) ) {
        ball.center.x = x2;
      } // end if

      if ( !Float.isNaN( y2 ) ) {
        ball.center.y = y2;
      } // end if

      if ( !Float.isNaN( vx1 ) ) {
        velocity.x = vx1;
      } // end if

      if ( !Float.isNaN( vy1 ) ) {
        velocity.y = vy1;
      } // end if

      if ( !Float.isNaN( vx2 ) ) {
        ball.velocity.x = vx2;
      } // end if

      if ( !Float.isNaN( vy2 ) ) {
        ball.velocity.y = vy2;
      } // end if
           

      return true;
    } // end if
    else {
      return false;
    } // end else
  } // end collide()

  /**
   * Draws this Ball.
   */
  public void draw(  ) {
	float diameter = radius + radius;
	p.fill(color);
    p.ellipse( center.x, center.y, diameter, diameter );
    // DEBUG
    p.pushMatrix();
    p.translate(center.x, center.y);
    p.rotateZ(PConstants.HALF_PI - (float)Math.atan2(velocity.x, velocity.y));
    p.stroke(255, 0, 0);
    p.line(0, 0, velocity.magnitude(), 0);
    p.rotateY(PConstants.HALF_PI + rotation);
    p.stroke(0, 0, 255);
    p.line(0, 0, radius, 0);
    p.stroke(0, 255, 0);
    p.line(0, 0, -radius, 0);
    p.noStroke();
    // END DEBUG
    p.popMatrix();
  } // end draw()
} // end Ball
