package ise.foosball;

import ise.game.GameState;

import ise.ui.Font;
import ise.ui.Label;
import ise.ui.MirroredLabel;
import ise.ui.MirroredLabel;
import ise.ui.ProgressBar;

import ise.utilities.Timer;

import processing.core.PApplet;
import processing.core.PConstants;

import tacTile.net.TouchAPI;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.3
 */
public class FoosballLoadingState implements GameState {
  private FoosballGame game;
  private Label mlblLoading;
  private PApplet p;
  private ProgressBar prgBarLower;
  private ProgressBar prgBarUpper;
  private Timer timer;

/**
   * Creates a new FoosballLoadingState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballLoadingState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );

    mlblLoading = new MirroredLabel( p, new String[] { "LOADING" }, Font.getInstance( p, "Arial", 36 ),
                                      p.width * 0.5f, p.height * 0.5f );
    mlblLoading.setRevolutionsPerSecond( 0.25f, timer );
    mlblLoading.setPadding(10, 10, 10, 5);
    //mlblLoading.setBackgroundColor( 255, 255, 255, 50);
    //mlblLoading.setForegroundColor( 255, 255, 255 );
    //mlblLoading.setBorderSize(5);

    float padding = 35.0f;
    float height = 35.0f;
    float width = p.width - padding - padding;
    prgBarUpper = new ProgressBar( p, padding, padding, width, height );
    prgBarUpper.setAnchor( ProgressBar.RIGHT, ProgressBar.BOTTOM );
    prgBarUpper.setFacingDirection( ProgressBar.TOP );
    prgBarLower = new ProgressBar( p, padding, p.height - padding, width, height );
    prgBarLower.setAnchor( ProgressBar.LEFT, ProgressBar.BOTTOM );
  } // end FoosballLoadingState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 0 );
    // TODO: Make this rotating ring (with text) its own UI Component
    p.pushMatrix(  );
    p.translate( p.width * 0.5f, p.height * 0.5f );

    // Rotate clockwise by pi/3 radians (60 degrees) per second
    float rotation = PConstants.TWO_PI * 0.25f * timer.getSecondsActive(  );
    float innerRadius = ( (float) Math.sqrt( ( mlblLoading.getWidth(  ) * mlblLoading.getWidth(  ) ) +
                                             ( mlblLoading.getHeight(  ) * mlblLoading.getHeight(  ) ) ) * 0.5f );
    float outterRadius = innerRadius + 35f;
    int sections = 64;
    float theta = PConstants.TWO_PI / sections;
    float[] x = new float[4];
    float[] y = new float[4];
    x[0] = 0;
    y[0] = 0;
    x[1] = outterRadius - innerRadius;
    y[1] = 0;
    x[3] = ( innerRadius * PApplet.cos( theta ) ) - innerRadius;
    y[3] = innerRadius * PApplet.sin( theta );
    x[2] = ( outterRadius * PApplet.cos( theta ) ) - innerRadius;
    y[2] = outterRadius * PApplet.sin( theta );
    p.rotateZ( -rotation );

    for ( int i = 0; i < sections; i++ ) {
      float percent = ( (float) i ) / sections;
      p.fill( 0, 0x66, 0xFF, 0xFF * ( 1.0f - percent ) );
      p.pushMatrix(  );
      p.rotateZ( PConstants.TWO_PI * percent );
      p.translate( innerRadius, 0 );
      p.quad( x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3] );
      p.popMatrix(  );
    } // end for

    p.popMatrix(  );

    prgBarUpper.draw(  );
    prgBarLower.draw(  );
    mlblLoading.draw(  );
  } // end draw()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void enter(  ) {
    timer.setActive( true );

    if ( !game.isLoaded(  ) ) {
      // Load Game assets in a separate thread
      Runnable loader = new Runnable(  ) {
        public void run(  ) {
          game.load(  );
        } // end run()
      } // end new
      ;

      Thread thread = new Thread( loader );
      thread.start(  );
    } // end if
  } // end enter()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void exit(  ) {
    timer.setActive( false );
  } // end exit()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( TouchAPI tacTile ) {}

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public String toString(  ) {
    return "Foosball Loading State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    if ( game.isLoaded(  ) ) {
      game.setState( game.getMenuState(  ) );
    } // end if
    else {
      timer.update(  );

      // TODO: Rewrite ProgressBar as a Component
      prgBarUpper.update( timer );
      prgBarLower.update( timer );

      //mlblLoading.update(  );
    } // end else
  } // end update()
} // end FoosballLoadingState
