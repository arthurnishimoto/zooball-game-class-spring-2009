/**
 * The main GameState. Gameplay happens here.
 *
 * Author:  Andy Bursavich
 * Version: 0.5
 */
class PlayState extends GameState
{
  private float SCREEN_LEFT=0, SCREEN_RIGHT=1920, SCREEN_TOP=0, SCREEN_BOTTOM=1080,
                FIELD_LEFT=75, FIELD_RIGHT=SCREEN_RIGHT-75, FIELD_TOP=25, FIELD_BOTTOM=SCREEN_BOTTOM-25,
                GOAL_SIZE=250, GOAL_TOP=FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), GOAL_BOTTOM=FIELD_BOTTOM-0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE),
                ZONE_COUNT=8, ZONE_WIDTH=(FIELD_RIGHT-FIELD_LEFT)/ZONE_COUNT;
  private long lastUpdate = 0;
  private Image imgChalk, imgStadiumTop, imgStadiumBottom, imgStadiumLeft, imgStadiumRight, imgEnabledLED, imgDisabledLED;
  private CircularButton btnPauseTop, btnPauseBottom;
  private Ball ball;
  private Booster[] boosters;
  private Line[] horzWalls, vertWalls, goalWalls;
  private FoosBar bar;

  public PlayState( Game game ) {
    super( game );
  }
  
  public void test1( ) {
    // Front on ball/bar collision -- with boosters and two "goals"
    ball.setPosition( 1920*0.5+350, 1080*0.5 - 400 );
    ball.setVelocity( -350, 50 );
    bar.setPosition( 1920*0.5, 1080*0.5 - 275 );
    bar.setVelocity( -3, 300 );
    bar.setRotation( Math.PI*0.6 );
  }
  
  public void test2( ) {
    // Corner on ball/bar collision
    ball.setPosition( 1920*0.5+75, 1080-180 );
    ball.setVelocity( 0, 0 );
    bar.setPosition( 1920*0.5, 1080*0.5 );
    bar.setVelocity( -0.9, 250 );
    bar.setRotation( 0 );
  }
  
  public void test3( ) {
    // Bar/Ball/Wall - Ball Between Players
    ball.setPosition( 1920*0.5, 1080-450 );
    ball.setVelocity( 0, 0 );
    bar.setPosition( 1920*0.5, 1080*0.5 );
    bar.setVelocity( 0, 500 );
    bar.setRotation( 0 );
  }
  
  public void test4( ) {
    // Bar/Ball/Wall - Bar Side
    ball.setPosition( 1920*0.5, 1080-50 );
    ball.setVelocity( 0, 0 );
    bar.setPosition( 1920*0.5, 1080*0.5 );
    bar.setVelocity( 0, 800 );
    bar.setRotation( 0 );
  }
  
  public void test5( ) {
    // Bar/Ball/Wall - Bar Corner
    ball.setPosition( 1920*0.5+80, 1080-50 );
    ball.setVelocity( 0, 0 );
    bar.setPosition( 1920*0.5, 1080*0.5 );
    bar.setVelocity( -1.3, 555 );
    bar.setRotation( 0 );
  }
  
  public void test6( ) {
    // Corner Test
    ball.setPosition( 1920-300, 100 );
    ball.setVelocity( 100, -40 );
  }
  
  public void test7( ) {
    // Ball Between Two Boosters
    ball.setPosition( 1920*0.5 + 200, 150 );
    ball.setVelocity( 0, 40 );
  }

  public void load( ) {
    Vector2D center = new Vector2D( game.getWidth()*0.5, game.getHeight()*0.5 );
    bar = new FoosBar( 1920*0.5, 1080*0.5, 3 );
    // example: redirected to goal
    //ball = new Ball( new Vector2D( center.x - 200, 220 - 50 ), new Vector2D( 250, 0 ), 2.5, 27.5, 0.1 );
    // example: stuck between two boosters
    //ball = new Ball( 1920-665-(75*0.5), 75 );
    //ball.setVelocity( 8.5, 55 );
    // example: won't get stuck in corner
    //ball = new Ball( new Vector2D( 1920-400, 170 ), new Vector2D( 78, -32 ), 2.5, 27.5, 0.1 );
    //ball = new Ball( 1920-400, 170 );
    //ball.setVelocity( 78, -32 );
    ball = new Ball( 100, 600 );
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
    boosters[0] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_TOP+150, 150, 75, new Vector2D( 0, 1500 ) );
    boosters[1] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_TOP+150, 150, 75, new Vector2D( 0, 1500 ) );
    boosters[2] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_BOTTOM-150, 150, 75, new Vector2D( 0, -1500 ) );
    boosters[3] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_BOTTOM-150, 150, 75, new Vector2D( 0, -1500 ) );
    boosters[4] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_TOP+300, 150, 75, new Vector2D( -1200, 900 ) );
    boosters[5] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_TOP+300, 150, 75, new Vector2D( 1200, 900 ) );
    boosters[6] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_BOTTOM-300, 150, 75, new Vector2D( -1200, -900 ) );
    boosters[7] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_BOTTOM-300, 150, 75, new Vector2D( 1200, -900 ) );
    boosters[8] = new BoosterCorner( FIELD_LEFT, FIELD_TOP, 80, 225, new Vector2D( 80, 80 ) );
    boosters[9] = new BoosterCorner( FIELD_LEFT, FIELD_BOTTOM, 80, -225, new Vector2D( 80, -80 ) );
    boosters[10] = new BoosterCorner( FIELD_RIGHT, FIELD_TOP, -80, 225, new Vector2D( -80, 80 ) );
    boosters[11] = new BoosterCorner( FIELD_RIGHT, FIELD_BOTTOM, -80, -225, new Vector2D( -80, -80 ) );
    imgEnabledLED = new Image( "ui/led/white/enabled.png" );
    imgEnabledLED.setSize( 25, 25 );
    imgDisabledLED = new Image( "ui/led/white/disabled.png" );
    imgDisabledLED.setSize( 25, 25 );
    imgChalk = new Image( "objects/stadium/chalk.gif" );
    imgChalk.setPosition( 75, 25 );
    imgStadiumTop = new Image( "objects/stadium/top.png" );
    imgStadiumTop.setPosition( 0, 0 );
    imgStadiumBottom = new Image( "objects/stadium/bottom.png" );
    imgStadiumBottom.setPosition( 0, 1055 );
    imgStadiumLeft = new Image( "objects/stadium/left.png" );
    imgStadiumLeft.setPosition( 0, 25 );
    imgStadiumRight = new Image( "objects/stadium/right.png" );
    imgStadiumRight.setPosition( 1845, 25 );
    btnPauseBottom = new CircularButton( "pause" );
    btnPauseBottom.setPosition( 1882.5, 1027.5 );
    btnPauseBottom.setRadius( 27.5 );
    btnPauseTop = new CircularButton( "pause" );
    btnPauseTop.setPosition( 37.5, 52.5 );
    btnPauseTop.setRadius( 27.5 );
    btnPauseTop.setRotation( PI );
    endLoad( );
  }

  public void update( ) {
    super.update( );
    long time = timer.getMicrosecondsActive( );
    int multiSample = 10;
    double dt = (time - lastUpdate) / 1000000.0 / multiSample;
    for ( int i = 0; i < multiSample; i++ ) 
      step( dt );
    lastUpdate = time;
  }

  private void step( double dt ) {
    // ADD FORCES
    ball.clearForces( );
    for ( int i = 0; i < boosters.length; i++ )
      if ( boosters[i].contains( ball.getPosition( ) ) )
        ball.addForce( boosters[i].getForce( ) );
    // STEP FORWARD
    ball.step( dt );
    bar.step( dt );
    // DO BALL/WALL COLLISIONS
    ball.clearWallContacts( );
    for( int i = 0; i < horzWalls.length; i++ )
      ball.collide( horzWalls[i] );
    for( int i = 0; i < vertWalls.length; i++ )
      ball.collide( vertWalls[i] );
    // DO FOOSBAR/WALL COLLISIONS
    bar.collide( horzWalls[0] );
    bar.collide( horzWalls[1] );
    // DO FOOSBAR/BALL COLLISIONS
    bar.collide( ball );
  }

  public void draw( ) {
    drawBackground( );
    drawPitch( );
    for ( int i = 0; i < boosters.length; i++ )
      boosters[i].draw( );
    ball.draw( );
    bar.drawDebug( );
    drawStadiumDebug( );
    //for ( int i = 0; i < horzWalls.length; i++ )
    //  horzWalls[i].draw( );
    //for ( int i = 0; i < vertWalls.length; i++ )
    //  vertWalls[i].draw( );
    //drawScore( );
    //drawButtons( );
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
    //imgChalk.draw( );
  }
  
  private void drawStadiumDebug( ) {
    fill( 0x72, 0x21, 0x11 );
    quad( SCREEN_LEFT, SCREEN_TOP, FIELD_LEFT, FIELD_TOP, FIELD_RIGHT, FIELD_TOP, SCREEN_RIGHT, SCREEN_TOP );
    quad( SCREEN_LEFT, SCREEN_BOTTOM, FIELD_LEFT, FIELD_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM, SCREEN_RIGHT, SCREEN_BOTTOM );
    quad( SCREEN_LEFT, SCREEN_TOP, FIELD_LEFT, FIELD_TOP, FIELD_LEFT, GOAL_TOP, SCREEN_LEFT, GOAL_TOP );
    quad( SCREEN_LEFT, SCREEN_BOTTOM, FIELD_LEFT, FIELD_BOTTOM, FIELD_LEFT, GOAL_BOTTOM, SCREEN_LEFT, GOAL_BOTTOM );
    quad( SCREEN_RIGHT, SCREEN_TOP, FIELD_RIGHT, FIELD_TOP, FIELD_RIGHT, GOAL_TOP, SCREEN_RIGHT, GOAL_TOP );
    quad( SCREEN_RIGHT, SCREEN_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM, FIELD_RIGHT, GOAL_BOTTOM, SCREEN_RIGHT, GOAL_BOTTOM );
    // UIC
    fill( 0xCC, 0, 0 );
    rect( FIELD_LEFT, SCREEN_TOP+6, FIELD_RIGHT-FIELD_LEFT, FIELD_TOP-SCREEN_TOP-6-6 ); // Side Marker
    rect( SCREEN_RIGHT, GOAL_TOP, (FIELD_RIGHT-SCREEN_RIGHT)*0.5, GOAL_SIZE ); // Goal
    fill( 255 );
    rect( FIELD_RIGHT, GOAL_TOP, 5, GOAL_SIZE );
    // LSU
    fill( 0xFD, 0xD0, 0x23 );
    rect( FIELD_LEFT, FIELD_BOTTOM+6, FIELD_RIGHT-FIELD_LEFT, SCREEN_BOTTOM-FIELD_BOTTOM-6-6 ); // Side Marker
    rect( SCREEN_LEFT, GOAL_TOP, (FIELD_LEFT-SCREEN_LEFT)*0.5, GOAL_SIZE ); // Goal
    fill( 255 );
    rect( FIELD_LEFT, GOAL_TOP, -5, GOAL_SIZE );
  }

  private void drawStadium( ) {
    imgStadiumTop.draw( );
    imgStadiumBottom.draw( );
    imgStadiumLeft.draw( );
    imgStadiumRight.draw( );
  }

  private void drawButtons( ) {
    btnPauseBottom.draw( );
    btnPauseTop.draw( );
  }

  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }

  public String toString( ) { 
    return "PlayState"; 
  }
}





