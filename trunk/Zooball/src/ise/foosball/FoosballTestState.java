package ise.foosball;

import java.util.Random;

import ise.game.GameState;

import ise.math.Vector2D;

import ise.objects.Ball;
import ise.objects.Line;

import ise.utilities.Timer;

import processing.core.PApplet;

import tacTile.net.TouchAPI;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class FoosballTestState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;
  private Ball[] balls;
  private Line[] boundaries;

/**
   * Creates a new FoosballPlayState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballTestState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
    
    Vector2D center = new Vector2D(p.width, p.height);
    center.scale(0.5f);
    Vector2D padding = new Vector2D(20, 60);
    Vector2D goalSize = new Vector2D(100, 250);
    Vector2D fieldSize = new Vector2D(p.width - 2.0f * (padding.x + goalSize.x), p.height - 2.0f * padding.y);
    float goalOffset = (fieldSize.y - goalSize.y) * 0.5f;
    Vector2D[] points = new Vector2D[] {
    		new Vector2D(padding.x + goalSize.x, padding.y),
    		new Vector2D(padding.x + goalSize.x + fieldSize.x, padding.y),
    		new Vector2D(padding.x + goalSize.x + fieldSize.x, padding.y + goalOffset),
    		new Vector2D(padding.x + goalSize.x + fieldSize.x + goalSize.x, padding.y + goalOffset),
    		new Vector2D(padding.x + goalSize.x + fieldSize.x + goalSize.x, padding.y + goalOffset + goalSize.y),
    		new Vector2D(padding.x + goalSize.x + fieldSize.x, padding.y + goalOffset + goalSize.y),
    		new Vector2D(padding.x + goalSize.x + fieldSize.x, padding.y + fieldSize.y),
    		new Vector2D(padding.x + goalSize.x, padding.y + fieldSize.y),
    		new Vector2D(padding.x + goalSize.x, padding.y + fieldSize.y - goalOffset),
    		new Vector2D(padding.x, padding.y + fieldSize.y - goalOffset),
    		new Vector2D(padding.x, padding.y + goalOffset),
    		new Vector2D(padding.x + goalSize.x, padding.y + goalOffset)
    };
    boundaries = new Line[12];

    for ( int i = 0; i < points.length; i++ ) {
      boundaries[i] = new Line( p, points[i], points[( i + 1 ) % points.length] );
    } // end for 
  } // end FoosballTestState()
  
  // gets a random float in the given interval
  private float rf( Random r, float min, float max ){
	  return min + r.nextFloat() * (max - min);
  }

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 20, 200, 20 );

    for ( int i = 0; i < boundaries.length; i++ ) {
      boundaries[i].draw(  );
    } // end for

    for ( int i = 0; i < balls.length; i++ ) {
      balls[i].draw(  );
    } // end for

    if ( game.isDebugMode(  ) ) {
      game.addDebugLine( "Play Time: " + timer.getTimeActive(  ) );
    } // end if
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

  /**
   * TODO: DOCUMENT ME!
   */
  public void init(  ) {
    timer.reset(  );
    Random r = new Random(42);
    
    Vector2D spawn = new Vector2D(boundaries[0].getA());
    spawn.add(new Vector2D(100, 100));
    balls = new Ball[6];
    balls[0] = new PingPongBall( p, timer, spawn.x, spawn.y );
    balls[0].setVelocity( new Vector2D( rf(r, -100, 100), rf(r, -100, 100) ) );
    spawn.add(new Vector2D(100, 0));
    balls[1] = new FoosBall( p, timer, spawn.x, spawn.y );
    balls[1].setVelocity( new Vector2D( rf(r, -100, 100), rf(r, -100, 100) ) );
    spawn.add(new Vector2D(100, 0));
    balls[2] = new FoosBall( p, timer, spawn.x, spawn.y );
    balls[2].setVelocity( new Vector2D( rf(r, -100, 100), rf(r, -100, 100) ) );
    spawn.add(new Vector2D(-200, 100));
    balls[3] = new BowlingBall( p, timer, spawn.x, spawn.y );
    balls[3].setVelocity( new Vector2D( rf(r, -100, 100), rf(r, -100, 100) ) );
    spawn.add(new Vector2D(100, 0));
    balls[4] = new FoosBall( p, timer, spawn.x, spawn.y );
    balls[4].setVelocity( new Vector2D( rf(r, -100, 100), rf(r, -100, 100) ) );
    spawn.add(new Vector2D(100, 0));
    balls[5] = new FoosBall( p, timer, spawn.x, spawn.y );
    balls[5].setVelocity( new Vector2D( rf(r, -100, 100), rf(r, -100, 100) ) );
  } // end init()

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
    return "Foosball Physics Test State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );

    for ( int i = 0; i < balls.length; i++ ) {
      balls[i].update(  );
    } // end for

    for ( int i = 0; i < balls.length; i++ ) {
      for ( int x = i + 1; x < balls.length; x++ ) {
        balls[i].collide( balls[x] );
      } // end for
    } // end for

    // DEBUG
    for ( int x = 0; x < boundaries.length; x++ ) {
      boundaries[x].collision = false;
    }

    // END DEBUG
    for ( int i = 0; i < balls.length; i++ ) {
      for ( int x = 0; x < boundaries.length; x++ ) {
        if ( balls[i].collide( boundaries[x] ) ) {
          boundaries[x].collision = true; // DEBUG
        } // end if
      } // end for
    } // end for
  } // end update()
} // end FoosballTestState
