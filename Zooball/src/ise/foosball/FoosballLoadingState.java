package ise.foosball;

import ise.game.GameState;

import ise.ui.Font;
import ise.ui.Label;
import ise.ui.ProgressBar;
import ise.ui.RotatingLabel;
import ise.ui.RotatingMirroredLabel;

import ise.utilities.Timer;

import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class FoosballLoadingState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private ProgressBar prgBarLower;
  private ProgressBar prgBarUpper;
  private RotatingMirroredLabel rlblLoading;
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

    rlblLoading = new RotatingMirroredLabel( p, "LOADING",
                                     Font.getInstance( p, "Arial", 36 ), p.width * 0.5f,
                                     p.height * 0.5f );
    rlblLoading.setTimer( timer );
    rlblLoading.setRevolutionsPerSecond( 0.25f );

    float padding = 35.0f;
    float height = 35.0f;
    float width = p.width - padding - padding;
    prgBarUpper = new ProgressBar( p, padding, padding, width, height );
    prgBarUpper.setAnchor(ProgressBar.RIGHT, ProgressBar.BOTTOM);
    prgBarUpper.setFacingDirection(ProgressBar.TOP);
    prgBarLower = new ProgressBar(p, padding, p.height - padding,
                                   width, height );
    prgBarLower.setAnchor(ProgressBar.LEFT, ProgressBar.BOTTOM);
  } // end FoosballLoadingState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 0 );
    prgBarUpper.draw(  );
    prgBarLower.draw(  );
    rlblLoading.draw(  );
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
      rlblLoading.update(  );
    } // end else
  } // end update()
} // end FoosballLoadingState
