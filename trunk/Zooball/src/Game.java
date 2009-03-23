import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PFont;
import processing.core.PImage;

import tacTile.net.*;

import java.util.Random;


/**
 * DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Game {
  PApplet p;
  private GameLeavingState leavingState;
  private GameMenuState menuState;
  private GameOverState overState;
  private GamePausedState pausedState;
  private GamePlayState playState;
  private GameState state;
  private PFont debugFont;
  private PImage woodTexture;
  private boolean debugMode;
  private volatile boolean loaded;
  private float debugAscent;
  private float debugHeight;
  private int debugColor;
  private int debugRow;

/**
   * Creates a new Game object.
   */
  public Game( PApplet p ) {
    this.p = p;
    loaded = false;
    // initialize debug variables
    debugMode = false;
    debugFont = p.loadFont( "CourierNew36.vlw" );
    debugColor = p.color( 255, 255, 255 );
    p.textFont( debugFont, 16 );
    debugAscent = p.textAscent(  );
    debugHeight = debugAscent + p.textDescent(  );
    debugRow = 0;
    // initialize states
    menuState = new GameMenuState( this );
    overState = new GameOverState( this );
    pausedState = new GamePausedState( this );
    playState = new GamePlayState( this );
    leavingState = new GameLeavingState( this );
    setState( new GameLoadingState( this ) );

    //setState(menuState);
  } // end Game()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public int getDebugColor(  ) {
    return debugColor;
  } // end getDebugColor()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public PFont getDebugFont(  ) {
    return debugFont;
  } // end getDebugFont()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public boolean isDebugMode(  ) {
    return debugMode;
  } // end isDebugMode()

  /**
   * Gets the current state of the game
   *
   * @return the current GameState
   */
  public GameState getGameState(  ) {
    return state;
  } // end getGameState()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public GameLeavingState getLeavingState(  ) {
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
  public GameMenuState getMenuState(  ) {
    return menuState;
  } // end getMenuState()

  /**
   * Gets the "over" state for this Game
   *
   * @return the GameOverState for this Game
   */
  public GameOverState getOverState(  ) {
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
  public GamePausedState getPausedState(  ) {
    return pausedState;
  } // end getPausedState()

  /**
   * Gets the "playing" state for this Game
   *
   * @return the GamePlayingState for this Game
   */
  public GamePlayState getPlayState(  ) {
    return playState;
  } // end getPlayState()

  /**
   * Sets the current state of the game
   *
   * @param state the GameState
   */
  public void setState( GameState state ) {
    if ( this.state != null ) {
      this.state.exit( p );
    } // end if

    this.state = state;
    this.state.enter( p );
  } // end setState()

  /**
   * DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public PImage getWoodTexture(  ) {
    return woodTexture;
  } // end getWoodTexture()

  /**
   * Loads assets in another thread
   */
  public void loadAssets(  ) {
    loaded = false;

    // TODO: Load actual assets
    woodTexture = p.loadImage( "wood.tga" );

    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 6;
    Random r = new Random(  );

    for ( int i = 0; i < max; i++ ) {
      r.nextDouble(  );
    } // end for

    loaded = true;
  } // end loadAssets()

  /**
   * Main game loop. It processes touches, updates the game, then draws the game.
   *
   * @param p DOCUMENT ME!
   * @param tacTile DOCUMENT ME!
   */
  public void loop( PApplet p, TouchAPI tacTile ) {
    //int time = parent.millis();
    debugRow = 0;
    state.input( p, tacTile );
    state.update( p );
    state.draw( p );
  } // end loop()

  /**
   * Prints a string to the "Debug Console"
   *
   * @param str the String to be printed
   */
  public void printDebugLine( String str ) {
    p.textAlign( PConstants.LEFT );
    p.fill( debugColor );
    p.textFont( debugFont, 16 );
    p.text( str, 15.0f, 15.0f + debugAscent + ( debugHeight * debugRow ) );
    debugRow++;
  } // end printDebugLine()

  /**
   * Toggles debug mode
   */
  public void toggleDebugMode(  ) {
    debugMode = !debugMode;
  } // end toggleDebugMode()
} // end Game
