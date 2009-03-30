package ise.gameObjects;

import ise.game.*;

import processing.core.*;


/**
 *  TODO: DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
  */
class FoosPlayer extends PApplet {
  MTFoosBar parent;
  int[] ballsRecentlyHit;
  boolean active;
  boolean atBottomEdge;
  boolean atTopEdge;

  //GLOBAL button time
  double buttonDownTime = 0.3f;
  double buttonLastPressed = 0;
  double timer_g;
  float hitBuffer = 20;
  float orig_Width;
  float playerHeight;
  float playerWidth;
  float xPos;
  float yPos;

  //Used in Java/Eclipse version only
  int borderHeight;

  //Used in Java/Eclipse version only
  int borderWidth;
  int nBalls;

  //Used in Java/Eclipse version only
  int screenHeight;

  //Used in Java/Eclipse version only
  int screenWidth;

  /**
   * Creates a new FoosPlayer object.
   *
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param newWidth DOCUMENT ME!
   * @param newHeight DOCUMENT ME!
   * @param new_parent DOCUMENT ME!
   */
  FoosPlayer( float x, float y, int newWidth, int newHeight, MTFoosBar new_parent ) {
    xPos = x;
    yPos = y;
    playerWidth = newWidth;
    orig_Width = newWidth;
    playerHeight = newHeight;
    parent = new_parent;
    ballsRecentlyHit = new int[nBalls];
  } // end FoosPlayer()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean setDelay(  ) {
    if ( buttonLastPressed == 0 ) {
      buttonLastPressed = ( ( buttonLastPressed + buttonDownTime ) - timer_g );

      return false;
    } // end if
    else if ( ( buttonLastPressed + buttonDownTime ) < timer_g ) {
      buttonLastPressed = timer_g;

      return true;
    } // end else if

    return false;
  } // end setDelay()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param balls DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean collide( Ball[] balls ) {
    if ( abs( parent.rotation ) > 0.4f ) { // Player is rotated high enough for ball to pass

      return false;
    }

    //fill( 0xffFF0000, 100 );
    for ( int i = 0; i < nBalls; i++ ) {
      if ( playerWidth > ( orig_Width / 2 ) ) { // Player is rotated to right (feet pointing to right)
        fill( 0xffFFFF00 );
        rect( xPos + ( playerWidth / 2 ), yPos, abs( playerWidth ) / 2, playerHeight );

        if ( ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) > ( xPos + ( playerWidth / 2 ) +
                                                                 hitBuffer ) ) &&
               ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) < ( xPos + playerWidth +
                                                                   ( orig_Width / 2 ) + hitBuffer ) ) ) {
          if ( ( ( balls[i].yPos + ( balls[i].diameter / 2 ) ) > ( yPos - hitBuffer ) ) &&
                 ( ( balls[i].yPos - ( balls[i].diameter / 2 ) ) < ( yPos + playerHeight +
                                                                     hitBuffer ) ) ) {
            if ( ballsRecentlyHit[i] == 1 ) {
              continue;
            }
          }
        }

        if ( ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) > ( xPos + ( playerWidth / 2 ) ) ) &&
               ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) < ( xPos + playerWidth +
                                                                   ( orig_Width / 2 ) ) ) ) {
          if ( ( ( balls[i].yPos + ( balls[i].diameter / 2 ) ) > yPos ) &&
                 ( ( balls[i].yPos - ( balls[i].diameter / 2 ) ) < ( yPos + playerHeight ) ) ) {
            ballsRecentlyHit[i] = 1;
            balls[i].setColor( color( 0xffFF0000 ) );

            if ( ( balls[i].xVel < 0 ) && ( balls[i].yPos > yPos ) &&
                   ( balls[i].yPos < ( yPos + playerHeight ) ) ) { // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1, parent.xMove, parent.yMove );

              continue;
            } // end if
            else if ( ( balls[i].xVel > 0 ) && ( balls[i].yPos > yPos ) &&
                        ( balls[i].yPos < ( yPos + playerHeight ) ) ) { // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1, parent.xMove, parent.yMove );

              continue;
            } // end else if
            else if ( ( balls[i].yVel > 0 ) && ( balls[i].xPos < ( xPos + playerWidth ) ) &&
                        ( balls[i].xPos > ( xPos + ( playerWidth / 2 ) ) ) ) { // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2, parent.xMove, parent.yMove );

              continue;
            } // end else if
            else if ( ( balls[i].yVel < 0 ) && ( balls[i].xPos < ( xPos + playerWidth ) ) &&
                        ( balls[i].xPos > ( xPos + ( playerWidth / 2 ) ) ) ) { // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2, parent.xMove, parent.yMove );

              continue;
            } // end else if
          } // end if
        }
      } // end if
      else if ( ( -1 * playerWidth ) > ( orig_Width / 2 ) ) { // Player is rotated to left (feet pointing to left)
        fill( 0xffFFFF00 );
        rect( xPos + ( playerWidth / 2 ), yPos, playerWidth / 2, playerHeight );

        if ( ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) > ( ( xPos + playerWidth ) -
                                                                 hitBuffer ) ) &&
               ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) < ( xPos + ( abs( playerWidth ) / 2 ) +
                                                                   hitBuffer ) ) ) {
          if ( ( ( balls[i].yPos + ( balls[i].diameter / 2 ) ) > ( yPos - hitBuffer ) ) &&
                 ( ( balls[i].yPos - ( balls[i].diameter / 2 ) ) < ( yPos + playerHeight +
                                                                     hitBuffer ) ) ) {
            if ( ballsRecentlyHit[i] == 1 ) {
              continue;
            }
          }
        }

        if ( ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) > ( xPos + playerWidth ) ) &&
               ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) < ( xPos + ( abs( playerWidth ) / 2 ) ) ) ) {
          if ( ( ( balls[i].yPos + ( balls[i].diameter / 2 ) ) > yPos ) &&
                 ( ( balls[i].yPos - ( balls[i].diameter / 2 ) ) < ( yPos + playerHeight ) ) ) {
            ballsRecentlyHit[i] = 1;
            balls[i].setColor( color( 0xffFF0000 ) );

            if ( ( balls[i].xVel < 0 ) && ( balls[i].yPos > yPos ) &&
                   ( balls[i].yPos < ( yPos + playerHeight ) ) ) { // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1, parent.xMove, parent.yMove );

              continue;
            } // end if
            else if ( ( balls[i].xVel > 0 ) && ( balls[i].yPos > yPos ) &&
                        ( balls[i].yPos < ( yPos + playerHeight ) ) ) { // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1, parent.xMove, parent.yMove );

              continue;
            } // end else if
            else if ( ( balls[i].yVel > 0 ) && ( balls[i].xPos > ( xPos + playerWidth ) ) &&
                        ( balls[i].xPos < ( xPos + ( playerWidth / 2 ) ) ) ) { // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2, parent.xMove, parent.yMove );

              continue;
            } // end else if
            else if ( ( balls[i].yVel < 0 ) && ( balls[i].xPos > ( xPos + playerWidth ) ) &&
                        ( balls[i].xPos < ( xPos + ( playerWidth / 2 ) ) ) ) { // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2, parent.xMove, parent.yMove );

              continue;
            } // end else if
          } // end if
        }
      } // end else if
      else if ( abs( playerWidth ) <= ( orig_Width / 2 ) ) { // Player is not rotated (feet straight down)

        if ( ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) > ( xPos - orig_Width + hitBuffer ) ) &&
               ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) < ( xPos + orig_Width + hitBuffer ) ) ) {
          if ( ( ( balls[i].yPos + ( balls[i].diameter / 2 ) ) > ( yPos - hitBuffer ) ) &&
                 ( ( balls[i].yPos - ( balls[i].diameter / 2 ) ) < ( yPos + playerHeight +
                                                                     hitBuffer ) ) ) {
            if ( ballsRecentlyHit[i] == 1 ) {
              continue;
            }
          }
        }

        if ( ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) > ( xPos - ( orig_Width / 2 ) ) ) &&
               ( ( balls[i].xPos + ( balls[i].diameter / 2 ) ) < ( xPos + orig_Width ) ) ) {
          if ( ( ( balls[i].yPos + ( balls[i].diameter / 2 ) ) > yPos ) &&
                 ( ( balls[i].yPos - ( balls[i].diameter / 2 ) ) < ( yPos + playerHeight ) ) ) {
            ballsRecentlyHit[i] = 1;
            balls[i].setColor( color( 0xffFF0000 ) );

            if ( ( balls[i].xVel < 0 ) && ( balls[i].yPos > yPos ) &&
                   ( balls[i].yPos < ( yPos + playerHeight ) ) ) { // Ball is coming from the right && ball is hitting the right side
              balls[i].kickBall( 1, parent.xMove, parent.yMove );

              continue;
            } // end if
            else if ( ( balls[i].xVel > 0 ) && ( balls[i].yPos > yPos ) &&
                        ( balls[i].yPos < ( yPos + playerHeight ) ) ) { // Ball is coming from the left && hitting left side
              balls[i].kickBall( 1, parent.xMove, parent.yMove );

              continue;
            } // end else if
            else if ( ( balls[i].yVel > 0 ) && ( balls[i].xPos > ( xPos - ( orig_Width / 2 ) ) ) &&
                        ( balls[i].xPos < ( xPos + ( orig_Width / 2 ) ) ) ) { // Ball is coming from the top && hitting top side
              balls[i].kickBall( 2, parent.xMove, parent.yMove );

              continue;
            } // end else if
            else if ( ( balls[i].yVel < 0 ) && ( balls[i].xPos > ( xPos - ( orig_Width / 2 ) ) ) &&
                        ( balls[i].xPos < ( xPos + ( orig_Width / 2 ) ) ) ) { // Ball is coming from the bottom && hitting bottom side
              balls[i].kickBall( 2, parent.xMove, parent.yMove );

              continue;
            } // end else if
          } // end if
        }
      } // end else if

      if ( ballsRecentlyHit[i] == 1 ) {
        ballsRecentlyHit[i] = 0;
        balls[i].setColor( color( 0xffFFFFFF ) );
      } // end if
    } // end for

    return false;
  } // end collide()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void display( PApplet p ) {
    active = true;

    if ( ( yPos + playerHeight ) > ( screenHeight - borderHeight ) ) {
      atBottomEdge = true;
      parent.atBottomEdge = true;
    } // end if
    else {
      atBottomEdge = false;
      parent.atBottomEdge = false;
    } // end else

    if ( yPos < borderHeight ) {
      atTopEdge = true;
      parent.atTopEdge = true;
    } // end if
    else {
      parent.atTopEdge = false;
      atTopEdge = false;
    } // end else

    p.fill( 0xff000000 );
    playerWidth = 4 * orig_Width * parent.rotation;
    p.rect( xPos, yPos, playerWidth, playerHeight );

    // Player Color
    p.fill( parent.teamColor );
    p.rect( xPos - ( orig_Width / 2 ), yPos, orig_Width, playerHeight );
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
    text( "Position: " + xPos + ", " + yPos, xPos + playerWidth + 16,
          yPos + ( playerHeight / 2 ) + ( 16 * 0 ) );
    text( "playerWidth: " + playerWidth, xPos + playerWidth + 16,
          yPos + ( playerHeight / 2 ) + ( 16 * 1 ) );

    if ( atTopEdge ) {
      text( "atTopEdge", xPos + playerWidth + 16, yPos + ( playerHeight / 2 ) + ( 16 * 2 ) );
    }

    if ( atBottomEdge ) {
      text( "atBottomEdge", xPos + playerWidth + 16, yPos + ( playerHeight / 2 ) + ( 16 * 2 ) );
    }

    for ( int i = 0; i < nBalls; i++ ) {
      text( "RecentlyHit[" + i + "]: " + ballsRecentlyHit[i], xPos + playerWidth + 16,
            yPos + ( playerHeight / 2 ) + ( 16 * ( 3 + i ) ) );
    }

    //Display Hitbox
    fill( 0xffFFFFFF );

    if ( abs( playerWidth ) <= ( orig_Width / 2 ) ) { // Foosmen straight down
      ellipse( xPos - ( orig_Width / 2 ), yPos, 5, 5 );
      ellipse( xPos + ( orig_Width / 2 ), yPos, 5, 5 );
      ellipse( xPos - ( orig_Width / 2 ), yPos + playerHeight, 5, 5 );
      ellipse( xPos + ( orig_Width / 2 ), yPos + playerHeight, 5, 5 );

      //hitBuffer
      ellipse( xPos - hitBuffer - ( orig_Width / 2 ), ( yPos - hitBuffer ), 5, 5 );
      ellipse( xPos + hitBuffer + ( orig_Width / 2 ), ( yPos - hitBuffer ), 5, 5 );
      ellipse( xPos - hitBuffer - ( orig_Width / 2 ), ( yPos + hitBuffer ) + playerHeight, 5, 5 );
      ellipse( xPos + hitBuffer + ( orig_Width / 2 ), ( yPos + hitBuffer ) + playerHeight, 5, 5 );
    } // end if
    else if ( ( -1 * playerWidth ) > ( orig_Width / 2 ) ) { // Foosmen angled to right
      ellipse( xPos + ( playerWidth / 2 ), yPos, 5, 5 );
      ellipse( xPos + playerWidth, yPos, 5, 5 );
      ellipse( xPos + ( playerWidth / 2 ), yPos + playerHeight, 5, 5 );
      ellipse( xPos + playerWidth, yPos + playerHeight, 5, 5 );

      //hitBuffer
      ellipse( xPos + hitBuffer + ( playerWidth / 2 ), ( yPos - hitBuffer ), 5, 5 );
      ellipse( xPos - hitBuffer + playerWidth, ( yPos - hitBuffer ), 5, 5 );
      ellipse( xPos + hitBuffer + ( playerWidth / 2 ), ( yPos + hitBuffer ) + playerHeight, 5, 5 );
      ellipse( xPos - hitBuffer + playerWidth, ( yPos + hitBuffer ) + playerHeight, 5, 5 );
    } // end else if
    else if ( playerWidth > ( orig_Width / 2 ) ) { // Foosmen angled to left
      ellipse( xPos + ( playerWidth / 2 ), yPos, 5, 5 );
      ellipse( xPos + playerWidth, yPos, 5, 5 );
      ellipse( xPos + ( playerWidth / 2 ), yPos + playerHeight, 5, 5 );
      ellipse( xPos + playerWidth, yPos + playerHeight, 5, 5 );

      //hitBuffer
      ellipse( xPos - hitBuffer + ( playerWidth / 2 ), ( yPos - hitBuffer ), 5, 5 );
      ellipse( xPos + hitBuffer + playerWidth, ( yPos - hitBuffer ), 5, 5 );
      ellipse( xPos - hitBuffer + ( playerWidth / 2 ), ( yPos + hitBuffer ) + playerHeight, 5, 5 );
      ellipse( xPos + hitBuffer + playerWidth, ( yPos + hitBuffer ) + playerHeight, 5, 5 );
    } // end else if
  } // end displayDebug()
} // end FoosPlayer
