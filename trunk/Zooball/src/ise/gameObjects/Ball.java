package ise.gameObjects;

import ise.game.*;

import processing.core.*;


/**
 * --------------------------------------------- 
 * Ball.java
 * 
 * Description: Ball object.
 * 
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.3a
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/18/09   - Version 0.2 - Initial FSM conversion
 * 3/25/09   - Version 0.3 - Encapsulation fixes for code clarity and easier Java conversion
 */
public class Ball extends PApplet {
  static final int ACTIVE = 1;
  static final int INACTIVE = 0;
  Ball[] others;
  double timer_g;
  float angle;
  public float diameter;
  private float friction = 0.001f;
  float maxVel = 10;
  float vel;
  public float xPos;
  public float xVel;
  public float yPos;
  public float yVel;
  int ID_no;
  int ballColor = color( 0xffFFFFFF );

  // @TODO Fix variables here - quick fix only
  int borderHeight;

  // @TODO Fix variables here - quick fix only
  int borderWidth;
  int nBalls;

  // @TODO Fix variables here - quick fix only
  int screenHeight;

  // @TODO Fix variables here - quick fix only
  int screenWidth;
  int state;

  /**
   * Creates a new Ball object.
   *
   * @param newX DOCUMENT ME!
   * @param newY DOCUMENT ME!
   * @param newDiameter DOCUMENT ME!
   * @param ID DOCUMENT ME!
   * @param otr DOCUMENT ME!
   * @param screenDim DOCUMENT ME!
   */
  public Ball( float newX, float newY, float newDiameter, int ID, Ball[] otr, int[] screenDim ) {
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    state = INACTIVE; // Initial state
    xPos = screenWidth / 2; //newX;
    yPos = screenHeight / 2; //newY;
    xVel = random( 5 ) + ( -1 * random( 5 ) );
    yVel = random( 5 ) + ( -1 * random( 5 ) );
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
  } // end Ball()

  /**
   * TODO: DOCUMENT ME!
   */
  public void setActive(  ) {
    state = ACTIVE;
  } // end setActive()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isActive(  ) {
    if ( state == ACTIVE ) {
      return true;
    } else {
      return false;
    }
  } // end isActive()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newColor DOCUMENT ME!
   */
  public void setColor( int newColor ) {
    ballColor = newColor;
  } // end setColor()

  /* Checks if ball was hit from an input device
   * @param x : input x coordinate
   * @param y : input y coordinate
   */
  /**
   * TODO: DOCUMENT ME!
   *
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   */
  public void isHit( float x, float y ) {
    if ( state == INACTIVE ) {
      return;
    }

    if ( getSpeed(  ) > 1 ) {
      return;
    }

    if ( ( x > ( xPos - ( diameter / 2 ) ) ) && ( x < ( xPos + ( diameter / 2 ) ) ) &&
           ( y > ( yPos - ( diameter / 2 ) ) ) && ( y < ( yPos + ( diameter / 2 ) ) ) ) {
      float newVel = random( -10, 11 );

      while ( ( newVel < 4 ) && ( newVel > -4 ) ) {
        newVel = random( -10, 11 );
      }

      xVel = newVel;

      newVel = random( -10, 11 );

      while ( ( newVel < 4 ) && ( newVel > -4 ) ) {
        newVel = random( -10, 11 );
      }

      yVel = newVel;
    } // end if
  } // end isHit()

  /**
   * TODO: DOCUMENT ME!
   */
  public void setInactive(  ) {
    state = INACTIVE;
  } // end setInactive()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newMax DOCUMENT ME!
   */
  public void setMaxVel( float newMax ) {
    maxVel = newMax;
  } // end setMaxVel()

  // Getters/Setters
  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public float getSpeed(  ) {
    return sqrt( sq( xVel ) + sq( yVel ) );
  } // end getSpeed()

  /* @TODO Ti be used for ball/ball collision
   */
  /**
   * TODO: DOCUMENT ME!
   */
  public void collide(  ) {
    if ( state == INACTIVE ) {
      return;
    }
  } // end collide()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void display( PApplet p ) {
    p.fill( ballColor, 255 );
    p.ellipse( xPos, yPos, diameter, diameter );
  } // end display()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   * @param g DOCUMENT ME!
   */
  public void displayDebug( PApplet p, Game g ) {
    //p.fill(g.getDebugColor());
    //p.textFont(g.getDebugFont());
    p.text( "ID: " + ID_no, xPos + diameter, yPos - ( diameter / 2 ) );
  } // end displayDebug()

  /* Changes the direction and velocity of the ball.
   * Used for ball/wall or ball/foosmen collision
   */
  /**
   * TODO: DOCUMENT ME!
   *
   * @param hitDirection DOCUMENT ME!
   * @param xVeloc DOCUMENT ME!
   * @param yVeloc DOCUMENT ME!
   */
  public void kickBall( int hitDirection, float xVeloc, float yVeloc ) {
    if ( state == INACTIVE ) {
      return;
    }

    // Basic implementation
    if ( ( hitDirection == 1 ) || ( hitDirection == 3 ) ) { // Reverse x
      xVel *= -1;
    }

    if ( ( hitDirection == 2 ) || ( hitDirection == 3 ) ) { // Reverse y
      yVel *= -1;
    }

    xVel += xVeloc;
    yVel += yVeloc;
  } // end kickBall()

  /** Ball was launched with a specific location using a specific velocity.
   * @param x : initial x position
   * @param y : initial y position
   * @param xVeloc : initial x velocity
   * @param yVeloc : initial y velocity
   */
  public void launchBall( float x, float y, float xVeloc, float yVeloc ) {
    xPos = x;
    yPos = y;
    xVel = xVeloc;
    yVel = yVeloc;
    setActive(  );
  } // end launchBall()

  /**
   * Moves the position of the ball based on its velocity
   */
  public void move(  ) {
    vel = sqrt( abs( sq( xVel ) ) + abs( sq( yVel ) ) );

    if ( xVel > maxVel ) {
      xVel = maxVel;
    }

    if ( yVel > maxVel ) {
      yVel = maxVel;
    }

    xPos += xVel;
    yPos += yVel;

    if ( xVel > 0 ) {
      xVel -= getFriction();
    } else if ( xVel < 0 ) {
      xVel += getFriction();
    }

    if ( yVel > 0 ) {
      yVel -= getFriction();
    } else if ( yVel < 0 ) {
      yVel += getFriction();
    }

    // Checks if object reaches edge of screen, bounce
    if ( ( xPos + ( diameter / 4 ) ) > ( screenWidth - borderWidth ) ) {
      xVel *= -1;
      xPos += xVel;
    } // end if
    else if ( ( xPos - ( diameter / 4 ) ) < borderWidth ) {
      xVel *= -1;
      xPos += xVel;
    } // end else if

    if ( ( yPos + ( diameter / 4 ) ) > ( screenHeight - borderHeight ) ) {
      yVel *= -1;
      yPos += yVel;
    } // end if
    else if ( ( yPos - ( diameter / 4 ) ) < borderHeight ) {
      yVel *= -1;
      yPos += yVel;
    } // end else if
  } // end move()

  /**
   * Performs actions of the Ball class based on its current state
   *
   * @param p DOCUMENT ME!
   */
  public void process( PApplet p ) {
    if ( state == ACTIVE ) {
      display( p );
      move(  );
    } // end if
    else if ( state == INACTIVE ) {
      // inactive state
    } // end else if
  } // end process()

public void setFriction(float friction) {
	this.friction = friction;
}

public float getFriction() {
	return friction;
}
} // end Ball
