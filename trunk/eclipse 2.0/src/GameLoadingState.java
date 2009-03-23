import processing.core.PApplet;
import processing.core.PConstants;

import tacTile.net.TouchAPI;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.5
 */
public class GameLoadingState implements GameState {
  private static int BARS = 12;
  Timer timer;
  private Game game;
  private ProgressBar prgBarLower;
  private ProgressBar prgBarUpper;

/**
   * Creates a new GameLoadingState object.
   *
   * @param game DOCUMENT ME!
   */
  public GameLoadingState( Game game ) {
    this.game = game;
    timer = new Timer(  );

    float padding = 35.0f;
    float height = 35.0f;
    float width = game.getPApplet(  ).width - padding - padding;
    prgBarUpper = new ProgressBar( padding, padding, width, height );
    prgBarUpper.setDirection( ProgressBar.RIGHT_TO_LEFT );
    prgBarLower = new ProgressBar( padding, game.getPApplet(  ).height - padding - height, width,
                                   height );
  } // end GameLoadingState()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void draw( PApplet p ) {
    p.background( 0 );

    prgBarUpper.draw( p );
    prgBarLower.draw( p );

    p.pushMatrix(  );
    // move to center of screen
    p.translate( p.width / 2, p.height / 2 );
    // Rotate clockwise by pi/3 radians (60 degrees) per second
    p.rotateZ( PConstants.PI / 3.0f * timer.getSecondsActive(  ) );
    p.fill( 255 );
    p.textAlign( PConstants.CENTER );
    p.textFont( game.getDebugFont(  ), 32 );
    p.text( "ZOOBALL", 0, -2 );
    p.text( "LOADING", 0, p.textAscent(  ) + 2.0f );

    for ( int b = 0; b < BARS; b++ ) {
      float percent = ( (float) b ) / BARS;
      p.pushMatrix(  );
      p.rotateZ( PConstants.TWO_PI * percent );
      /*
       * Alternate gradation of peices
      if(b < 4) {
        p.fill( 191 + (128 * (4 - b) / 6.0f) );
      }
      else p.fill(64);
      */
      p.fill( 255 * ( 1.0f - percent ) );
      p.rect( -17.5f, 75.0f, 35.0f, 70.0f ); // down
                                             //p.rect( 75.0f, -17.5f, 70.0f, 35.0f ); // right
                                             //p.ellipse( 0, 110.0f, 35.0f, 70.0f );  

      p.popMatrix(  );
    } // end for

    p.popMatrix(  );

    if ( game.isDebugMode(  ) ) {
      game.printDebugLine( "Game State: Loading" );
      game.printDebugLine( "Frame Rate: " + (int) ( p.frameRate + 0.5f ) + " f/s" );
      game.printDebugLine( "Loading Time: " + timer.getTimeActive(  ) );
    } // end if
  } // end draw()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void enter( PApplet p ) {
    timer.setActive( true );

    if ( !game.isLoaded(  ) ) {
      // Load Game assets in a separate thread
      Runnable loader = new Runnable(  ) {
        public void run(  ) {
          game.loadAssets(  );
        } // end run()
      } // end new
      ;

      Thread thread = new Thread( loader );
      thread.start(  );
    } // end if
  } // end enter()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void exit( PApplet p ) {
    timer.setActive( false );
  } // end exit()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( PApplet p, TouchAPI tacTile ) {} // end input()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  @Override
  public void update( PApplet p ) {
    if ( game.isLoaded(  ) ) {
      game.setState( game.getMenuState(  ) );
    } // end if
    else {
      timer.update(  );
      prgBarUpper.update( timer );
      prgBarLower.update( timer );
    } // end else
  } // end update()
} // end GameLoadingState