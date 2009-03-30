package ise.gameObjects;

import ise.game.*;

import processing.core.*;


/**
 * --------------------------------------------- MTHandI.java Description: Multi-Touch Hand
 * Interface (Processing->Java version) Used for dealing with UI touches. Including basic
 * gestures. Class: System: Processing 1.0.1, Windows Vista Author: Arthur Nishimoto Version: 0.1
 * Version Notes: 2/13/09  - Initial Version - Uses timer_g and text needs a font 2/27/09      -
 * Added support for horizontal or vertical finger swipes
 * ---------------------------------------------
 */
class MTHandI extends PApplet {
  MTFinger[] fingers;
  boolean active;
  boolean leftHand;
  boolean pressed;
  boolean rightHand;
  float fingerDistance;
  float handTilt;
  float padDiameter;
  float pinkyDistX;
  float pinkyDistY;
  float thumbDistX;
  float thumbDistY;
  float xPos;
  float yPos;
  int nFingers;

  /**
   * Creates a new MTHandI object.
   *
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param padDia DOCUMENT ME!
   * @param numFing DOCUMENT ME!
   * @param fingDia DOCUMENT ME!
   */
  MTHandI( float x, float y, float padDia, int numFing, float fingDia ) {
    xPos = x;
    yPos = y;
    padDiameter = padDia;
    fingers = new MTFinger[numFing];
    nFingers = numFing;

    for ( int i = 0; i < numFing; i++ ) {
      fingers[i] = new MTFinger( xPos - ( padDiameter / 2 ) + ( fingDia / 2 ) +
                                 ( i * ( padDiameter / 4.5f ) ), height / 2, fingDia, this );
    } // end for
  } // end MTHandI()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newDelay DOCUMENT ME!
   */
  public void setDelay( double newDelay ) {
    for ( int i = 0; i < nFingers; i++ ) {
      fingers[i].buttonDownTime = newDelay;
    } // end for
  } // end setDelay()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param xCoord DOCUMENT ME!
   * @param yCoord DOCUMENT ME!
   * @param finger DOCUMENT ME!
   * @param intensity DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isPressed( float xCoord, float yCoord, int finger, float intensity ) {
    if ( !active ) {
      return false;
    }

    if ( ( xCoord > ( xPos - ( padDiameter / 2 ) ) ) && ( xCoord < ( xPos + ( padDiameter / 2 ) ) ) &&
           ( yCoord > ( yPos - ( padDiameter / 2 ) ) ) && ( yCoord < ( yPos + ( padDiameter / 2 ) ) ) ) {
      for ( int i = 0; i < nFingers; i++ ) {
        fingers[i].isPressed( xCoord, yCoord, finger, intensity );
      } // end for

      pressed = true;

      return true;
    } // end if

    for ( int i = 0; i < nFingers; i++ ) {
      fingers[i].reset(  );
    } // end for

    return false;
  } // end isPressed()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public float getSpan(  ) {
    return fingerDistance;
  } // end getSpan()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public float getTilt(  ) {
    return handTilt;
  } // end getTilt()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param hand DOCUMENT ME!
   */
  public void calibrate( String hand ) {
    // Left-handed calibration
    if ( hand == "LEFT" ) {
      leftHand = true;
      rightHand = false;

      if ( nFingers >= 5 ) {
        fingers[0].pinky = true;
        fingers[1].ring = true;
        fingers[2].middle = true;
        fingers[3].index = true;
        fingers[4].thumb = true;
      } // end if
        // Right-handed calibration
    } // end if
    else if ( hand == "RIGHT" ) {
      leftHand = false;
      rightHand = true;

      if ( nFingers >= 5 ) {
        fingers[4].pinky = true;
        fingers[3].ring = true;
        fingers[2].middle = true;
        fingers[1].index = true;
        fingers[0].thumb = true;
      } // end if
    } // end else if
  } // end calibrate()

  /**
   * TODO: DOCUMENT ME!
   */
  public void display(  ) {
    active = true;

    if ( pressed ) {
      fill( 0xff00FFFF, 100 );
      stroke( 0xff00FF00 );
      ellipse( xPos, yPos, padDiameter, padDiameter );
    } // end if
    else {
      fill( 0xff00FF00, 100 );
      stroke( 0xff00FF00 );
      ellipse( xPos, yPos, padDiameter, padDiameter );
    } // end else

    for ( int i = 0; i < nFingers; i++ ) {
      if ( fingers[i].pinky ) {
        pinkyDistX = fingers[i].xPos;
        pinkyDistY = fingers[i].yPos;
      } // end if
      else if ( fingers[i].thumb ) {
        thumbDistX = fingers[i].xPos;
        thumbDistY = fingers[i].yPos;
      } // end else if

      fingers[i].display(  );
    } // end for

    if ( leftHand ) {
      fingerDistance = sqrt( sq( thumbDistX - pinkyDistX ) + sq( thumbDistY - pinkyDistY ) );
      handTilt = thumbDistY - pinkyDistY;
    } // end if
    else if ( rightHand ) {
      fingerDistance = sqrt( sq( pinkyDistX - thumbDistX ) + sq( pinkyDistY - thumbDistY ) );
      handTilt = pinkyDistY - thumbDistY;
    } // end else if
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
    text( "Pressed: " + pressed, 10, 100 );
    text( "Hand Span: " + fingerDistance, 10, 100 + 16 );
    text( "Hand Tilt: " + handTilt, 10, 100 + ( 16 * 2 ) );

    for ( int i = 0; i < nFingers; i++ ) {
      fingers[i].displayDebug( p, g );
    } // end for
  } // end displayDebug()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newColor DOCUMENT ME!
   */
  public void displayFinger( int newColor ) {
    for ( int i = 0; i < nFingers; i++ ) {
      fingers[i].displayFinger( newColor );
    } // end for
  } // end displayFinger()

  /**
   * TODO: DOCUMENT ME!
   */
  public void reset(  ) {
    active = false;
    pressed = false;

    for ( int i = 0; i < nFingers; i++ ) {
      fingers[i].reset(  );
    } // end for
  } // end reset()
} // end MTHandI


/**
 *  TODO: DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
  */
class MTFinger extends PApplet {
  MTHandI hand;
  boolean active;
  boolean calibrated;
  boolean clicked;
  boolean index;
  boolean middle;
  boolean pinky;
  boolean pressed;
  boolean ring;
  boolean thumb;
  boolean xSwipe;
  boolean ySwipe;
  double buttonDownTime = 0.2f;
  double buttonLastPressed = 0;
  double timer_g;
  float diameter;
  float intensity;
  float swipeThreshold = 30.0f;
  float xMove;
  float xPos;
  float yMove;
  float yPos;

  // @TODO Fix variables here - quick fix only
  int borderHeight;

  // @TODO Fix variables here - quick fix only
  int borderWidth;
  int fingerID;
  int nBalls;

  // @TODO Fix variables here - quick fix only
  int screenHeight;

  // @TODO Fix variables here - quick fix only
  int screenWidth;

  /**
   * Creates a new MTFinger object.
   *
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param dia DOCUMENT ME!
   * @param newHand DOCUMENT ME!
   */
  MTFinger( float x, float y, float dia, MTHandI newHand ) {
    xPos = x;
    yPos = y;
    pinky = false;
    ring = false;
    middle = false;
    index = false;
    thumb = false;
    calibrated = false;
    diameter = dia;
    hand = newHand;
  } // end MTFinger()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newDelay DOCUMENT ME!
   */
  public void setButtonDelay( double newDelay ) {
    buttonDownTime = newDelay;
  } // end setButtonDelay()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param xCoord DOCUMENT ME!
   * @param yCoord DOCUMENT ME!
   * @param finger DOCUMENT ME!
   * @param intensityVal DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isPressed( float xCoord, float yCoord, int finger, float intensityVal ) {
    if ( ( xCoord > ( xPos - ( diameter / 2 ) ) ) && ( xCoord < ( xPos + ( diameter / 2 ) ) ) &&
           ( yCoord > ( yPos - ( diameter / 2 ) ) ) && ( yCoord < ( yPos + ( diameter / 2 ) ) ) ) {
      if ( buttonLastPressed == 0 ) {
        buttonLastPressed = timer_g;
      } // end if
      else if ( ( buttonLastPressed + buttonDownTime ) < timer_g ) {
        if ( fingerID != finger ) {
          clicked = true;
          buttonLastPressed = timer_g;
        } // end if

        pressed = true;
        xMove = xCoord - xPos;
        yMove = yCoord - yPos;
        xPos = xCoord;
        yPos = yCoord;
      } // end else if
      else {
        intensity = intensityVal;
        fingerID = finger;
        clicked = false;
        pressed = true;
        xMove = xCoord - xPos;
        yMove = yCoord - yPos;
        xPos = xCoord;
        yPos = yCoord;

        return true;
      } // end else
    } // end if

    return false;
  } // end isPressed()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newThreshold DOCUMENT ME!
   */
  public void setSwipeThreshold( float newThreshold ) {
    swipeThreshold = newThreshold;
  } // end setSwipeThreshold()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param xCoord DOCUMENT ME!
   * @param yCoord DOCUMENT ME!
   * @param finger DOCUMENT ME!
   */
  public void calibrate( float xCoord, float yCoord, int finger ) {
    if ( ( xCoord > ( xPos - ( diameter / 2 ) ) ) && ( xCoord < ( xPos + ( diameter / 2 ) ) ) &&
           ( yCoord > ( yPos - ( diameter / 2 ) ) ) && ( yCoord < ( yPos + ( diameter / 2 ) ) ) ) {
      switch ( finger ) {
        case ( 1 ) :
          pinky = true;
          calibrated = true;

          break;

        case ( 2 ) :
          ring = true;
          calibrated = true;

          break;

        case ( 3 ) :
          middle = true;
          calibrated = true;

          break;

        case ( 4 ) :
          index = true;
          calibrated = true;

          break;

        case ( 5 ) :
          thumb = true;
          calibrated = true;

          break;

        default :
          calibrated = false;
          pinky = false;
          ring = false;
          middle = false;
          index = false;
          thumb = false;

          break;
      } // end switch
    } // end if

    return;
  } // end calibrate()

  /**
   * TODO: DOCUMENT ME!
   */
  public void display(  ) {
    active = true;

    if ( ( fingerID == -1 ) && !pressed ) {
      buttonLastPressed = timer_g;
    }

    if ( pressed && !clicked ) {
      fill( 0xff0000FF );
      stroke( 0xff00FF00 );
      ellipse( xPos, yPos, diameter, diameter );
    } // end if
    else if ( clicked ) {
      fill( 0xffFF0000 );
      stroke( 0xff00FF00 );
      ellipse( xPos, yPos, diameter, diameter );
    } // end else if
    else {
      fill( 0xff000000 );
      stroke( 0xff00FF00 );
      ellipse( xPos, yPos, diameter, diameter );
    } // end else

    // Swipe
    if ( abs( xMove ) >= swipeThreshold ) {
      xSwipe = true;
      shoot( 4 );
    } // end if
    else {
      xSwipe = false;
    } // end else

    if ( abs( yMove ) >= swipeThreshold ) {
      ySwipe = true;
      shoot( 5 );
    } // end if
    else {
      ySwipe = false;
    } // end else
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
    text( "Pressed: " + pressed, xPos + diameter, yPos - ( diameter / 2 ) );
    text( "Position: " + xPos + " , " + yPos, xPos + diameter, yPos - ( diameter / 2 ) + 16 );
    text( "Movement: " + xMove + " , " + yMove, xPos + diameter, yPos - ( diameter / 2 ) - 16 );
    text( "FingerID: " + fingerID + " Intensity: " + intensity, xPos + diameter,
          yPos - ( diameter / 2 ) + ( 16 * 2 ) );
    text( "Button Delay: " + buttonDownTime, xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 3 ) );

    if ( ( buttonLastPressed + buttonDownTime ) > timer_g ) {
      text( "Button Downtime Remain: " + ( ( buttonLastPressed + buttonDownTime ) - timer_g ),
            xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 4 ) );
    } else {
      text( "Button Downtime Remain: 0", xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 4 ) );
    }

    if ( pinky ) {
      text( "PINKY", xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 5 ) );
    } else if ( ring ) {
      text( "RING", xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 5 ) );
    } else if ( middle ) {
      text( "MIDDLE", xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 5 ) );
    } else if ( index ) {
      text( "INDEX", xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 5 ) );
    } else if ( thumb ) {
      text( "THUMB", xPos + diameter, yPos - ( diameter / 2 ) + ( 16 * 5 ) );
    }
  } // end displayDebug()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param newColor DOCUMENT ME!
   */
  public void displayFinger( int newColor ) {
    //fill(newColor);
    //textFont(font,16);
    if ( pinky ) {
      text( "PINKY", xPos, yPos - ( diameter * .6f ) );
    } else if ( ring ) {
      text( "RING", xPos, yPos - ( diameter * .6f ) );
    } else if ( middle ) {
      text( "MIDDLE", xPos, yPos - ( diameter * .6f ) );
    } else if ( index ) {
      text( "INDEX", xPos, yPos - ( diameter * .6f ) );
    } else if ( thumb ) {
      text( "THUMB", xPos, yPos - ( diameter * .6f ) );
    }
  } // end displayFinger()

  /**
   * TODO: DOCUMENT ME!
   */
  public void reset(  ) {
    fingerID = -1;
    pressed = false;
  } // end reset()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param style DOCUMENT ME!
   */
  public void shoot( int style ) {
    //particleManager.explodeParticles(100, xPos, yPos, 0, 0, style);
  } // end shoot()
} // end MTFinger
