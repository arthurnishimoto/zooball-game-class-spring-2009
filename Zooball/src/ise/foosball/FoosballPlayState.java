package ise.foosball;

import ise.game.GameState;
import ise.gameObjects.Ball;
import ise.gameObjects.FoosBarManager;

import ise.utilities.Timer;

import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class FoosballPlayState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;
  
  int nBalls = 1;
  int fieldLines = 5; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #. Default = 9
  int nBars = fieldLines - 1;
  
  Ball[] balls = new Ball[nBalls];
  FoosBarManager barManager;

/**
   * Creates a new FoosballPlayState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballPlayState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
    
    // Generate screenDimention data for object use
    int[] screenDimentions = new int[4];
    screenDimentions[0] = game.getPApplet().screen.width;//screenWidth
    screenDimentions[1] = game.getPApplet().screen.height;//screenHeight
    screenDimentions[2] = 0;//borderWidth
    screenDimentions[3] = 100;//borderHeight
    
    // Generate Balls
    for( int i = 0; i < nBalls; i++ ){
      // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
      balls[i] = new Ball( 0, 0, 50, i, balls, screenDimentions);
      balls[i].setActive();
      //balls[i].friction = tableFriction;
    }
    
    // Generate Foosbars
    barManager = new FoosBarManager( fieldLines, 200, screenDimentions, balls );
    
  } // end FoosballPlayState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 20, 200, 20 );
    game.addDebugLine("Play Time: " + timer.getTimeActive());
    
    barManager.displayZones(p);
    //particleManager.display();
    
    for( int i = 0; i < nBalls; i++ ){
      //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
      if( balls[i].isActive() ){
        //particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
        balls[i].process(p);
      }
    }// for all balls
    
    barManager.display(p);
    
  } // end draw()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void enter(  ) {
    timer.setActive( true );
  } // end enter()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void exit(  ) {
    timer.setActive( false );
  } // end exit()
  
  public void init(  ) {
	  timer.reset();
  }

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
    return "Foosball Play State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballPlayState
