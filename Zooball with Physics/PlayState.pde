/**
 * The main GameState. Gameplay happens here.
 *
 * Author:  Andy Bursavich
 * Version: 0.5
 */
class PlayState extends GameState
{
  private boolean wireframeMode = false;
  private float SCREEN_LEFT=0, SCREEN_RIGHT=1920, SCREEN_TOP=0, SCREEN_BOTTOM=1080,
  FIELD_LEFT=SCREEN_LEFT+75, FIELD_RIGHT=SCREEN_RIGHT-75, FIELD_TOP=SCREEN_TOP+25, FIELD_BOTTOM=SCREEN_BOTTOM-25,
  GOAL_SIZE=275, GOAL_TOP=FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), GOAL_BOTTOM=FIELD_BOTTOM-0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE),
  ZONE_COUNT=8, ZONE_WIDTH=(FIELD_RIGHT-FIELD_LEFT)/ZONE_COUNT, GOAL_BOX_SIZE=GOAL_SIZE+150, GOAL_BOX_TOP=GOAL_TOP-0.5*(GOAL_BOX_SIZE-GOAL_SIZE),
  GOAL_BOX_BOTTOM=GOAL_BOTTOM+0.5*(GOAL_BOX_SIZE-GOAL_SIZE);
  private long lastUpdate = 0;
  private Ball ball;
  private Booster[] boosters;
  private Line[] horzWalls, vertWalls, goalWalls;
  private FoosBar[] bars;
  //private Image imgChalk;

  public PlayState( Game game, TouchAPI tacTile ) {
    super( game, tacTile );
    //println( "ZONE WIDTH = " + ZONE_WIDTH);
  }
  
  public void toggleWireframeMode( ) {
    wireframeMode = !wireframeMode;
  }
  
  private void resetObjects( ) {
    ball.setPosition( 1920*0.5, 1080*0.5 );
    ball.setRotation( 0 );
    for ( int i = 0; i < bars.length; i++ ) {
      bars[i].setPosition( bars[i].getPosition( ).x, 1080*0.5 );
      bars[i].setRotation( 0 );
      bars[i].setVelocity( 0, 0 );
    }
  }
  
  public void test1( ) {
    resetObjects( );
    bars[3].setPosition( bars[3].getPosition( ).x, 1080*0.5 - 150 );
    bars[3].setVelocity( -3, 375 );
    bars[3].setRotation( Math.PI*0.6 );
    ball.setPosition( 1920*0.5+50, 1080*0.5 - 200 );
    ball.setVelocity( -350, 135 );
  }
  
  public void test2( ) {
    resetObjects( );
    bars[3].setPosition( bars[3].getPosition( ).x, 1080*0.5 );
    bars[3].setVelocity( -3, 273 );
    bars[3].setRotation( Math.PI*0.6 );
    ball.setPosition( 1920*0.5-75, 1080-50 );
    ball.setVelocity( 0, 0 );
  }

  public void test3( ) {
    resetObjects( );
    bars[2].setPosition( bars[2].getPosition( ).x, 1080*0.5 );
    bars[2].setVelocity( 0, 600 );
    ball.setPosition( bars[2].getPosition( ).x, 1080*0.5 + 130 );
    ball.setVelocity( 0, 0 );
  }
  

  public void test4( ) {
    resetObjects( );
    bars[6].setPosition( bars[6].getPosition( ).x, 1080*0.5+75 );
    bars[6].setVelocity( 0, 600 );
    ball.setPosition( bars[6].getPosition( ).x, 1080-50 );
    ball.setVelocity( 0, 0 );
  }
  
  public void test5( ) {
    resetObjects( );
    bars[0].setPosition( bars[0].getPosition( ).x, 1080*0.5 );
    bars[0].setVelocity( -4, 0 );
    //bars[0].setRotation( PI );
    ball.setPosition( FIELD_LEFT+25, 1080*0.5 );
    ball.setVelocity( 0, 0 );
  }
  
  public void test6( ) {
    resetObjects( );
    bars[7].setPosition( bars[7].getPosition( ).x, 1080*0.5+200 );
    bars[7].setVelocity( -4, 0 );
    bars[7].setRotation( HALF_PI );
    ball.setPosition( FIELD_RIGHT-25, 1080*0.5+200 );
    ball.setVelocity( 0, 0 );
  }
  
  public void test7( ) {
    // Corner Test
    resetObjects( );
    ball.setPosition( 1920-300, 100 );
    ball.setVelocity( 100, -40 );
  }
  
  public void test8( ) {
    // Ball Between Two Boosters
    resetObjects( );
    ball.setPosition( 1920*0.5 + 210, 100 );
    ball.setVelocity( 0, 175 );
  }

  public void load( ) {
    Vector2D center = new Vector2D( game.getWidth()*0.5, game.getHeight()*0.5 );
    bars = new FoosBar[8];
    bars[0] = new FoosBar( FIELD_LEFT+0.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 3, "tigers" );
    bars[1] = new FoosBar( FIELD_LEFT+1.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 2, "tigers" );
    bars[2] = new FoosBar( FIELD_LEFT+2.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 3, "dragons" );
    bars[3] = new FoosBar( FIELD_LEFT+3.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 5, "tigers" );
    bars[4] = new FoosBar( FIELD_LEFT+4.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 5, "dragons" );
    bars[5] = new FoosBar( FIELD_LEFT+5.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 3, "tigers" );
    bars[6] = new FoosBar( FIELD_LEFT+6.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 2, "dragons" );
    bars[7] = new FoosBar( FIELD_LEFT+7.5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 3, "dragons" );
    touchables = new Touchable[8];
    touchables[0] = new TouchZone( FIELD_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // bottom
    touchables[1] = new TouchZone( FIELD_LEFT+ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // bottom
    touchables[2] = new TouchZone( FIELD_LEFT+2*ZONE_WIDTH, FIELD_TOP, ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // top
    touchables[3] = new TouchZone( FIELD_LEFT+3*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // bottom
    touchables[4] = new TouchZone( FIELD_LEFT+4*ZONE_WIDTH, FIELD_TOP, ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // top
    touchables[5] = new TouchZone( FIELD_LEFT+5*ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // bottom
    touchables[6] = new TouchZone( FIELD_LEFT+6*ZONE_WIDTH, FIELD_TOP, ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // top
    touchables[7] = new TouchZone( FIELD_LEFT+7*ZONE_WIDTH, FIELD_TOP, ZONE_WIDTH, 0.5*(SCREEN_BOTTOM-SCREEN_TOP) ); // top
    ball = new Ball( 100, 600 );
    ball.setPosition( 1920*0.5+350, 1080*0.5 - 400 );
    // HORIZONTAL "WALLS"
    horzWalls = new Line[6];
    // top and bottom of field
    horzWalls[0] = new Line( FIELD_LEFT, FIELD_TOP, FIELD_RIGHT, FIELD_TOP );
    horzWalls[1] = new Line( FIELD_LEFT, FIELD_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM );
    // top and bottom of goals
    horzWalls[2] = new Line( SCREEN_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), FIELD_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE) );
    horzWalls[3] = new Line( SCREEN_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE), FIELD_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE) );
    horzWalls[4] = new Line( SCREEN_RIGHT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), FIELD_RIGHT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE) );
    horzWalls[5] = new Line( SCREEN_RIGHT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE), FIELD_RIGHT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE) );
    // VERTICAL "WALLS"
    vertWalls = new Line[6];
    // left and right of field
    vertWalls[0] = new Line( FIELD_LEFT, FIELD_TOP, FIELD_LEFT, FIELD_TOP + 0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE) );
    vertWalls[1] = new Line( FIELD_LEFT, FIELD_TOP + 0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE), FIELD_LEFT, FIELD_BOTTOM );
    vertWalls[2] = new Line( FIELD_RIGHT, FIELD_TOP, FIELD_RIGHT, FIELD_TOP + 0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE) );
    vertWalls[3] = new Line( FIELD_RIGHT, FIELD_TOP + 0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE), FIELD_RIGHT, FIELD_BOTTOM );
    // left and right of goals
    vertWalls[4] = new Line( SCREEN_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), SCREEN_LEFT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE) );
    vertWalls[5] = new Line( SCREEN_RIGHT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), SCREEN_RIGHT, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP+GOAL_SIZE) );
    boosters = new Booster[12];
    boosters[0] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_TOP+150, new Vector2D( 0, 1500 ) );
    boosters[1] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_TOP+150, new Vector2D( 0, 1500 ) );
    boosters[2] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_BOTTOM-150, new Vector2D( 0, -1500 ) );
    boosters[3] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_BOTTOM-150, new Vector2D( 0, -1500 ) );
    boosters[4] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_TOP+315, new Vector2D( -1200, 900 ) );
    boosters[5] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_TOP+315, new Vector2D( 1200, 900 ) );
    boosters[6] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_BOTTOM-315, new Vector2D( -1200, -900 ) );
    boosters[7] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_BOTTOM-315, new Vector2D( 1200, -900 ) );
    boosters[8] = new BoosterCorner( FIELD_LEFT, FIELD_TOP, 90, 250, new Vector2D( 80, 80 ) );
    boosters[9] = new BoosterCorner( FIELD_LEFT, FIELD_BOTTOM, 90, -250, new Vector2D( 80, -80 ) );
    boosters[10] = new BoosterCorner( FIELD_RIGHT, FIELD_TOP, -90, 250, new Vector2D( -80, 80 ) );
    boosters[11] = new BoosterCorner( FIELD_RIGHT, FIELD_BOTTOM, -90, -250, new Vector2D( -80, -80 ) );
    //imgChalk = new Image( "objects/stadium/chalk.gif" );
    //imgChalk.setPosition( FIELD_LEFT, FIELD_TOP );
    //imgChalk.setSize( FIELD_RIGHT-FIELD_LEFT, FIELD_BOTTOM-FIELD_TOP );
    endLoad( );
  }

  public void update( ) {
    super.update( );
    long time = timer.getMicrosecondsActive( );
    while ( lastUpdate < time ) {
      step( 0.005 );
      lastUpdate += 5000;
    }
  }

  private void step( double dt ) {
    // ADD BOOSTER FORCES
    ball.clearForces( );
    for ( int i = 0; i < boosters.length; i++ )
      if ( boosters[i].contains( ball.getPosition( ) ) )
        ball.addForce( boosters[i].getForce( ) );
    // STEP FORWARD
    ball.step( dt );
    for ( int i = 0; i < bars.length; i++ ) {
      Vector2D velocity = ( (TouchZone)touchables[i] ).getVelocity( timer.getMicrosecondsActive( ) );
      if ( velocity != null )
        bars[i].setVelocity( velocity.x, velocity.y );
      bars[i].step( dt );
    }
    // DO BALL/WALL COLLISIONS
    ball.clearWallContacts( );
    for( int i = 0; i < horzWalls.length; i++ )
      if ( ball.collide( horzWalls[i] ) )
        break; // only one horizontal wall can be hit at a time
    for( int i = 0; i < vertWalls.length; i++ )
      if ( ball.collide( vertWalls[i] ) )
        break; // only one vertical wall can be hit at a time
    // DO FOOSBAR/WALL COLLISIONS
    for ( int i = 0; i < bars.length; i++ )
      if ( !bars[i].collide( horzWalls[0] ) )
        bars[i].collide( horzWalls[1] ); // only one wall can be hit at a time
    // DO FOOSBAR/BALL COLLISIONS
    for ( int i = 0; i < bars.length; i++ )
      if( bars[i].collide( ball ) )
        break; // only one foosbar can be hit at a time, just stop
  }

  public void draw( ) {
    drawBackground( );
    // PITCH
    drawPitch( );
    for ( int i = 0; i < boosters.length; i++ ) {
      boosters[i].draw( );
      if ( game.isDebugMode( ) )
        boosters[i].drawDebug( );
    }
    drawChalk( );
    // BALL
    if( wireframeMode )
      ball.drawDebug( );
    else {
      ball.draw( );
      if ( game.isDebugMode( ) )
        ball.drawDebug( );
    }
    // FOOSMEN
    for ( int i = 0; i < bars.length; i++ ) {
      if( wireframeMode )
        bars[i].drawDebug( );
      else {
        bars[i].draw( );
        if ( game.isDebugMode( ) )
          bars[i].drawDebug( );
      }
    }
    // STADIUM
    drawStadium( );
    drawDebugText( );
  }

  private void drawBackground( ) {
    background( 0 );
  }

  private void drawPitch( ) {
    for ( int i = 0; i < ZONE_COUNT; i++ ) {
      fill( 0x79, 0xAE, 0x27 );
      rect( FIELD_LEFT + i*ZONE_WIDTH, FIELD_TOP, ZONE_WIDTH, FIELD_BOTTOM-FIELD_TOP );
      fill( 0x9E, 0xC6, 0x33 );
      rect( FIELD_LEFT + i*ZONE_WIDTH, FIELD_TOP, ZONE_WIDTH*0.5, FIELD_BOTTOM-FIELD_TOP );
    }
    fill( 0.5*(0x9E+0x79), 0.5*(0xC6+0xAE), 0.5*(0x33+0x27) );
    quad( SCREEN_LEFT, GOAL_TOP, FIELD_LEFT, GOAL_TOP, FIELD_LEFT, GOAL_BOTTOM, SCREEN_LEFT, GOAL_BOTTOM );
    quad( SCREEN_RIGHT, GOAL_TOP, FIELD_RIGHT, GOAL_TOP, FIELD_RIGHT, GOAL_BOTTOM, SCREEN_RIGHT, GOAL_BOTTOM );
    /*
    fill( 255 );
    rect( FIELD_LEFT, GOAL_TOP, -5, GOAL_SIZE );
    rect( FIELD_RIGHT, GOAL_TOP, 5, GOAL_SIZE );
    */
    //imgChalk.draw( );
  }
  
  private void drawChalk( ) {
    //imgChalk.draw( );
    float px = 5;
    fill( 255 );
    // outline
    rect( FIELD_LEFT, FIELD_TOP, px, FIELD_BOTTOM-FIELD_TOP );
    rect( FIELD_RIGHT, FIELD_TOP, -px, FIELD_BOTTOM-FIELD_TOP );
    rect( FIELD_LEFT, FIELD_TOP, FIELD_RIGHT-FIELD_LEFT, px );
    rect( FIELD_LEFT, FIELD_BOTTOM, FIELD_RIGHT-FIELD_LEFT, -px );
    // center line
    rect( FIELD_LEFT+0.5*(FIELD_RIGHT-FIELD_LEFT-px), FIELD_TOP, px, FIELD_BOTTOM-FIELD_TOP );
    // goalie box
    rect( FIELD_LEFT, GOAL_BOX_TOP, ZONE_WIDTH, px );
    rect( FIELD_LEFT, GOAL_BOX_BOTTOM, ZONE_WIDTH, -px );
    rect( FIELD_LEFT+ZONE_WIDTH, GOAL_BOX_TOP, -px, GOAL_BOX_SIZE );
    rect( FIELD_RIGHT, GOAL_BOX_TOP, -ZONE_WIDTH, px );
    rect( FIELD_RIGHT, GOAL_BOX_BOTTOM, -ZONE_WIDTH, -px );
    rect( FIELD_RIGHT-ZONE_WIDTH, GOAL_BOX_TOP, px, GOAL_BOX_SIZE );
    // center circle
    fill( 0, 0 );
    strokeWeight( px );
    stroke( 255 );
    ellipse( FIELD_LEFT+0.5*(FIELD_RIGHT-FIELD_LEFT), FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), 1.5*ZONE_WIDTH, 1.5*ZONE_WIDTH );
    //arc( FIELD_LEFT+ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), GOAL_SIZE, GOAL_SIZE, -HALF_PI, HALF_PI );
    //arc( FIELD_RIGHT-ZONE_WIDTH, FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP), GOAL_SIZE, GOAL_SIZE, HALF_PI, PI+HALF_PI );
    strokeWeight( 1 );
    noStroke( );
  }

  private void drawStadium( ) {
    fill( 0x72, 0x21, 0x11 );
    quad( SCREEN_LEFT, SCREEN_TOP, FIELD_LEFT, FIELD_TOP, FIELD_RIGHT, FIELD_TOP, SCREEN_RIGHT, SCREEN_TOP );
    quad( SCREEN_LEFT, SCREEN_BOTTOM, FIELD_LEFT, FIELD_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM, SCREEN_RIGHT, SCREEN_BOTTOM );
    quad( SCREEN_LEFT, SCREEN_TOP, FIELD_LEFT, FIELD_TOP, FIELD_LEFT, GOAL_TOP, SCREEN_LEFT, GOAL_TOP );
    quad( SCREEN_LEFT, SCREEN_BOTTOM, FIELD_LEFT, FIELD_BOTTOM, FIELD_LEFT, GOAL_BOTTOM, SCREEN_LEFT, GOAL_BOTTOM );
    quad( SCREEN_RIGHT, SCREEN_TOP, FIELD_RIGHT, FIELD_TOP, FIELD_RIGHT, GOAL_TOP, SCREEN_RIGHT, GOAL_TOP );
    quad( SCREEN_RIGHT, SCREEN_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM, FIELD_RIGHT, GOAL_BOTTOM, SCREEN_RIGHT, GOAL_BOTTOM );
    // UIC
    fill( 0xCC, 0, 0 );
    rect( FIELD_LEFT, SCREEN_TOP+5, FIELD_RIGHT-FIELD_LEFT, FIELD_TOP-SCREEN_TOP-10 ); // Side Marker
    rect( SCREEN_RIGHT, GOAL_TOP, (FIELD_RIGHT-SCREEN_RIGHT)*0.66, GOAL_SIZE ); // Goal
    // LSU
    fill( 0xFD, 0xD0, 0x23 );
    rect( FIELD_LEFT, FIELD_BOTTOM+5, FIELD_RIGHT-FIELD_LEFT, SCREEN_BOTTOM-FIELD_BOTTOM-10 ); // Side Marker
    rect( SCREEN_LEFT, GOAL_TOP, (FIELD_LEFT-SCREEN_LEFT)*0.66, GOAL_SIZE ); // Goal
  }

  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }

  public String toString( ) { 
    return "PlayState"; 
  }
}







