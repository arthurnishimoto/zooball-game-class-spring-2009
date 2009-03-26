package ise.foosball;

import ise.game.Game;

import ise.ui.DebugOutput;
import ise.ui.Font;
import ise.ui.Label;

import processing.core.PApplet;

import tacTile.net.TouchAPI;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Random;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class FoosballGame extends Game {
  private FoosballLeavingState leavingState;
  private FoosballMenuState menuState;
  private FoosballOverState overState;
  private FoosballPausedState pausedState;
  private FoosballPlayState playState;
  private DebugOutput lblDebug;
  private PApplet p;
  private boolean debugMode = false;
  private volatile boolean loaded;

/**
   * Creates a new Foosball object.
   *
   * @param p DOCUMENT ME!
   */
  public FoosballGame( PApplet p ) {
    super(  );
    this.p = p;
    p.frameRate( 60 );
    // initialize states
    menuState = new FoosballMenuState( p, this );
    overState = new FoosballOverState( p, this );
    pausedState = new FoosballPausedState( p, this );
    playState = new FoosballPlayState( p, this );
    leavingState = new FoosballLeavingState( p, this );
    setState( new FoosballLoadingState( p, this ) );
    // debug label 
    lblDebug = new DebugOutput( p, Font.getInstance( p, "Arial Bold", 14 ), 20, 20 );
    lblDebug.setAnchor( Label.LEFT, Label.TOP );
    lblDebug.setTextAlignment( Label.LEFT, Label.TOP );
  } // end Foosball()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isDebugMode(  ) {
    return debugMode;
  } // end isDebugMode()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public FoosballLeavingState getLeavingState(  ) {
    return leavingState;
  } // end getLeavingState()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isLoaded(  ) {
    return loaded;
  } // end isLoaded()

  /**
   * Gets the "main menu" state for this Game
   *
   * @return the GameMainMenuState for this Game
   */
  public FoosballMenuState getMenuState(  ) {
    return menuState;
  } // end getMenuState()

  /**
   * Gets the "over" state for this Game
   *
   * @return the GameOverState for this Game
   */
  public FoosballOverState getOverState(  ) {
    return overState;
  } // end getOverState()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public PApplet getPApplet(  ) {
    return p;
  } // end getPApplet()

  /**
   * Gets the "paused" state for this Game
   *
   * @return the GamePausedState for this Game
   */
  public FoosballPausedState getPausedState(  ) {
    return pausedState;
  } // end getPausedState()

  /**
   * Gets the "playing" state for this Game
   *
   * @return the GamePlayingState for this Game
   */
  public FoosballPlayState getPlayState(  ) {
    return playState;
  } // end getPlayState()

  /**
   * Adds a line to the debug output
   *
   * @param line DOCUMENT ME!
   */
  public void addDebugLine( String line ) {
    lblDebug.addLine( line );
  } // end addDebugLine()

  /**
   * Loads assets in another thread
   */
  public void load(  ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 6;
    Random r = new Random(  );

    for ( int i = 0; i < max; i++ ) {
      r.nextDouble(  );
    } // end for

    loaded = true;
  } // end load()

  /**
   * TODO: DOCUMENT ME!
   *
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void loop( TouchAPI tacTile ) {
    if ( debugMode ) {
      addDebugLine( "Game State: " + state.toString(  ) );
      addDebugLine( "Frame Rate: " + (int) ( p.frameRate + 0.5f ) + " f/s" );
    } // end if

    super.loop( tacTile );

    if ( debugMode ) {
    	lblDebug.draw();
    } // end if
  } // end loop()

  /**
   * Toggles debug mode
   */
  public void toggleDebugMode(  ) {
    debugMode = !debugMode;
  } // end toggleDebugMode()
} // end Foosball
