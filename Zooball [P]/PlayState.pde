/**
 * ---------------------------------------------
 * PlayState.pde
 *
 * Description: Gameplay State
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 1.2
 *
 * Version Notes:
 * 3/1/09	- Initial version 0.1
 * 3/5/09       - Version 0.2
 *              - FoosBars, players added. Bar rotation and touch zones implemented.
 *              - FoosBarManager generates number of player on bars based on number of bars. ( 3 person and goalie only)
 *              - FoosPlayers block balls if bar is within -0.4 to 0.4 of rotation value.
 * 3/6/09       - Version 0.2.1
 *              - [FIXED] players now block the ball when playerWidth = -1.
 *              - [FIXED] MTFoosBar::collide(balls[]), Ball::isHit() - Foosmen block balls and changes the ball's velocity based on the bar's velocity.
 *                        Resolves "pass through" issue when ball would hit top or bottom surface of foosmen
 *              - [FIXED] MTFoosBar::reset() - Bars now always reset the xMove and yMove values. This prevents the bars from becoming stuck on screen edge.
 *                        Bar can still get stuck, but releasing will unstick it.
 *              - [ADDED] sliderMultiplier can be used to increase slider speed for tacTile
 *              - [ADDED] Ball::isHit() randomly kicks the ball if pressed when ball's speed < 1. Original function of isHit() - when foosmen hits ball, changed
 *                        to Ball::kickBall().
 * 3/11/09      - [ADDED] Program screen size now based on screenWidth and screenHeight variables in main. Allows for proper resize for applet or windowed mode.
 * 3/12/09      - Version 0.2.2
 *              - [ADDED] Borders now restrict ball movement and is recognized as topEdge or bottomEdge for foosmen collision (marked as on edge, but takes no block action)
 *              - [REMOVED] Ball and foosmen collision info, foosmen and edge of play area collision.
 *              - [ADDED] New foosmen collision boxes are now visible via Foosplayer::displayDebug()
 * 3/13/09      - [MODIFIED] Foosplayer collision detection with ball revamped in Foosplayer::collide(ball[]) - Ball still can bounce inside player.
 *              - [MODIFIED] Foosplayer::collide(ball[]) now has a delay before it will change the velocity of the ball - fixes collision problems except for slow moving balls
 * 3/18/09      - Version 0.2.2.5 
 *              - [MODIFIED] Ball changed to FSM
 *              - [ADDED] Turret ball launcher
 * 3/19/09      - [ADDED] Pause button/menu - States for overall program
 *              - [MODIFIED] Foosplayer::collide(ball[]) now tracks all recently hits balls and ignores them - fixes collision problems except for rare "corner" cases
 * 3/20/09      - Version 0.3
 *              - [ADDED] Goals and scoring
 *              - [FIXED] Minor bugs with collision for ball, foosmen, and goal zone.
 *              - [ADDED] After scoring, ball is given to other team. Launcher activated - Only tested with one ball
 * 3/28/09      - Version 0.3.1 - All classes except Turret have been modified to be independent of variables in main class. (ex debugColor/font, screenDim)
 *              - [Modified] Turret control revised. Rotate shows direction choice and ball now fires on button release, not press.
 *              - [Bugged] Revision of Goal class now prevents proper score keeping
 *              - [Added] Foosman now accepts a single .gif image
 * 4/1/09       - Version 0.3.2 - Foosbar has optional "spring-loaded" mode
 *              - [Modified] Turret can be toggled from press to shoot, or release to shoot
 *              - [Added] SoundManager, Menu Screen for demo
 * 4/2/09       - [Added] Demo main menu, first sound files, ball accepts a single image file
 * 4/3/09       - Version 0.4 - Mid-Semester Demo
 *              - [Added] FoosbarRotateTest imports up to 360 images and rotates it. Demo screen for sound, rotate test.
 * 4/4/09       - Version 0.4.1
 *              - [Added] Debug Console to change number of bars/balls, volume, table friction, and older debug functions
 * 4/9/09       - [Modified] Music looping, stops if selected while playing. Gameplay added to main game.
 *              - [Added] Ball rolling animations. Foosbar2 hitbox displayed, not used.
 * 4/10/09      - [Modified] Touch zones changed to 213 for TacTile size. 8 bar teams changed for TacTile (center bar has 4 players instead of 5)
 *              - [Fixed] Touch release bug for turret
 *              - Version 0.4.2
 *              - [Modified] Bar/ball collision detection for Foosbar2. Foosman stops ball at certain angle.
 * 4/16/09      - Version 0.4.3
 *              - [Added] DebugConsole2 controls for bar sensitivity options.
 *              - [Fixed] Touch release bug for turret and foosmen spin gesture working in 30 FPS
 * 4/19/09      - Version 0.6
 *              - Initial conversion to a PlayState. Menus removed.
 *              - [Added] Fireball state to ball
 *              - [Added] Toggle to change team screen positions. Goal zone colors and team color bar.
 *              - [Fixed] Responds to game timer for pausing
 *              - [Modified] All ball/foosmen image loading done by parent state. Only loads one instance of each image.
 * 4/20/09      - Version 0.7
 *              - [Added] TouchAPI support
 *              - Moved from PlayTestState to PlayState
 *              - [Added] Pause, Over State support
 * 4/21/09      - Version 0.8
 *              - Ball launcher reintegrated (Thus all Prototype features in)
 *              - Foosbar "Spring-loaded" mode reintegrated and better implemented.
 * 4/23/09      - Version 0.8.5
 *              - DebugConsole completely rewritten. All sounds back in. Some artwork in. Multiple foosbar control modes in.
 *              - Full rotation modified. Spin gesture improved. Foosmen catch and throw implemented
 * 4/24/09      - Fireball ability and debuff effect implemented.
 *              - Decoyball ability implemented.
 * 4/25/09      - Version 0.9
 *              - Foosbars now track and save game statistics
 *              - Ball launcher now properly tracks which balls are queued up for firing - now multi-ball supported.
 *              - Early menus added
 * 4/26/09      - Added mouse recording (for tutorial)
 * 4/29/09      - Version 0.9.5
 *              - Physics engine implementation - Phase One - Balls and Walls
 *              - Version 0.9.7
 *              - Physics engine implementation - Phase Two - Boosters and Bars (Partial)
 * 4/30/09      - Physics engine implementation - Phase Two - Boosters and Bars (Complete) - Need to fix images
 * 5/1/09       - Version 1.0 (Alpha)
 *              - Foosbar catch/throw and special balls re-implemented. Fixes with resetting physics.
 * 5/5/09       - Version 1.1
 *              - Tutorial fully implemented, ball/bar velocity collision fixes. Stressed tested.
 * 6/5/09       - Version 1.1.1
 *              - Implements echoClient to communicate with Processing launcher. Exit button enabled on tutorial.
 * 6/15/09      - Version 1.1.2
 *              - Button class replaced with MTButton library
 * 7/6/09       - Started control screen. echoClient now triggers on esc key.
 * 7/7/09       - Version 1.1.9
 *              - Control select screen fully integrated. Fix for ball out of bounds. - Needs tacTile testing before moving to v1.2
 * 9/30/09      - Version 1.2.1
 *              - Fixed bug where balls were not correcty being caught under full rotation mode.
 * 12/15/09     - Version 1.3
 *              - Minor bug fixes, mouse 'touch' less off-centered, config file added for TouchAPI portability.
 * Notes:
 *      - [TODO] Improve collision detection on goal zones
 *      - [TODO] 1-to-1 control over goalie zone?
 *      - [NOTE] Two close fingers to move bars works well on TacTile.
 *      - [NOTE] Foosman spin gesture works when FPS is 20-30 (60 too high).
 *      - [NOTE] Turret shoot-on-release works on TacTile only when usingMouse = false.
 * ---------------------------------------------
 */

// Gameplay Flags
Boolean displayArt = true;

Boolean redTeamTop = false;

Boolean yellowTeamWins = false;
Boolean redTeamWins = false;

Boolean debugText = false; // TEMP
Boolean debug2Text = false; // TEMP
color debugColor = color(255,255,255); // TEMP

boolean demoMode = false;
boolean playStateActive = false;

boolean springMode = false;
boolean rotateMode = true;

// Gameplay Initial Variables
int nBalls = 1;
int maxScore = 5;
float tableFriction = 0.01; // Default = 0.01
int maxBallSpeed = 300;
int rotateInc = 15; // Global rotation increment for artwork

int borderWidth = 0;
int goalWidth = 100; // Replaces borderWidth to allow balls inside the goal.
int borderHeight = 100;

int fieldLines = 9; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #. Default = 9
int nBars = fieldLines - 1; 
int barWidth = 213;

int FIELD_MODE = 2; // Booster difficulty: 1 = Easy, 2 - Normal (No boosters), 3 - Hard 

float timer_g = 0; // TEMP
float demoTimer = 0;
PFont font;

// Data Structures / Objects
Ball[] balls = new Ball[nBalls];
Ball[] decoyBalls = new Ball[nBalls];
int[] screenDimensions = new int[4];
PImage ballImages[] = new PImage[360];
PImage red_foosmanImages[] = new PImage[360];
PImage yellow_foosmanImages[] = new PImage[360];
Goal topGoal, bottomGoal;
color topColor;
color bottomColor;
Turret ballLauncher_bottom;
Turret ballLauncher_top;

String[] tutorialText;
String previousText;

// Rotate animation images
String filepath;
String filename;
String extention = ".png";

// Managers
ParticleManager particleManager = new ParticleManager( 2000, 5 ); // Ball trail effects
ParticleManager particleManager2 = new ParticleManager( 2000, 3 ); // Fire effects
FoosbarManager barManager;
BoosterManager boosterManager;

class PlayState extends GameState
{
  private float SCREEN_LEFT=0, SCREEN_RIGHT=1920, SCREEN_TOP=0, SCREEN_BOTTOM=1080,
    FIELD_LEFT=SCREEN_LEFT+100, FIELD_RIGHT=SCREEN_RIGHT-100, FIELD_TOP=SCREEN_TOP+100, FIELD_BOTTOM=SCREEN_BOTTOM-100,
    GOAL_SIZE=275, GOAL_TOP=FIELD_TOP+0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE), GOAL_BOTTOM=FIELD_BOTTOM-0.5*(FIELD_BOTTOM-FIELD_TOP-GOAL_SIZE),
    ZONE_COUNT=8, ZONE_WIDTH=(FIELD_RIGHT-FIELD_LEFT)/ZONE_COUNT;
  private float[] fieldDimensions = new float[5];
  private Line[] horzWalls, vertWalls, goalWalls;
  private long lastUpdate = 0; // physics time in microseconds

  private CircularButton btnPauseTop, btnPauseBottom;
  private Image imgPitch, border, imgLines, imgNets, logo;
  int ballsInPlay = 0;
  int topQueue = 0;
  int bottomQueue = 0;
  int lastScored = -1; // 0 = top, 1 = bottom
  double goalTimeDelay = 0;
  
  Elephant leftElephant;
  
  public PlayState( Game game ) {
    super( game );
  }// CTOR

  public void load( ) {
    leftElephant = new Elephant( 50, 800 );
    
    lastUpdate = 0; // physics time in microseconds
    Vector2D center = new Vector2D( game.getWidth()*0.5, game.getHeight()*0.5 );
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

    fieldDimensions[0] = FIELD_LEFT;
    fieldDimensions[1] = FIELD_RIGHT;
    fieldDimensions[2] = FIELD_TOP;
    fieldDimensions[3] = FIELD_BOTTOM;
    fieldDimensions[4] = ZONE_WIDTH;

    ballsInPlay = 0;
    topQueue = 0;
    bottomQueue = 0;
    lastScored = -1;
    demoTimer = 0;

    imgPitch = new Image( "data/objects/stadium/gamefield_grass.gif" );
    imgPitch.setPosition( 0, 0 );
    border = new Image( "data/objects/stadium/woodtrim copy.png" );
    border.setPosition( 0, 0 );
    imgLines = new Image( "data/objects/stadium/gamefield_centerline_goalzones.png" );
    imgLines.setPosition( 0, 0 );
    imgNets = new Image( "data/objects/stadium/gamefield_nets.png" );
    imgNets.setPosition( 0, 0 );
    logo = new Image( "data/objects/stadium/gamefield_logo.png" );
    //logo = new Image( "data/objects/stadium/blank.png" );
    logo.setPosition( 0, 0 );    

    yellowTeamWins = false;
    redTeamWins = false;

    screenDimensions[0] = (int)game.getWidth( );
    screenDimensions[1] = (int)game.getHeight( );
    screenDimensions[2] = borderWidth;
    screenDimensions[3] = borderHeight;

    font = loadFont("data/ui/fonts/Arial Bold-14.vlw"); // TEMP
    balls = new Ball[nBalls];
    decoyBalls = new Ball[nBalls];

    // Loads Ball artwork
    //filepath = "data/objects/ball/";
    //filename = "ball_";
    //for(int i = 0; i < 360; i += rotateInc)
    //  ballImages[i] = loadImage(filepath + filename + i + extention);

    for( int i = 0; i < nBalls; i++ ){
      balls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions, ballImages);
      decoyBalls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions, ballImages);
    }

    // Loads Red Foosman artwork
    filepath = "data/objects/uicDragons/";
    filename = "dragon_";
    for(int i = 0; i < 360; i += rotateInc)
      red_foosmanImages[i] = loadImage(filepath + filename + i + extention);

    // Loads Yellow Foosman artwork
    filepath = "data/objects/lsuTigers/";
    filename = "tiger_";
    for(int i = 0; i < 360; i += rotateInc)
      yellow_foosmanImages[i] = loadImage(filepath + filename + i + extention);      

    barManager = new FoosbarManager( fieldLines, barWidth, screenDimensions, balls, red_foosmanImages, yellow_foosmanImages);
    if(springMode){
      barManager.setSpringEnabled(true);
      barManager.setRotationEnabled(false);
    }else if(rotateMode){
      barManager.setSpringEnabled(false);
      barManager.setRotationEnabled(true);
    }else{
      barManager.setSpringEnabled(false);
      barManager.setRotationEnabled(false);
    }
    
    // Sets team colors
    if( !redTeamTop ){
      topColor = color(255,0,0);
      bottomColor = color(255,255,0);
    }
    else{
      topColor = color(255,255,0);
      bottomColor = color(255,0,0);      
    }

    // Left Goal
    topGoal = new Goal( borderWidth, game.getHeight()/2, goalWidth, 300 , 0, topColor, balls);
    topGoal.setParentClass(this);

    // Right Goal
    bottomGoal = new Goal( game.getWidth()-borderWidth-100, game.getHeight()/2, goalWidth, 300 , 1, bottomColor, balls);
    bottomGoal.setParentClass(this);

    // Pause Buttons
    btnPauseBottom = new CircularButton( "data/ui/buttons/pause/enabled.png" );
    btnPauseBottom.setPosition( 1882.5, 1027.5 );
    btnPauseBottom.setRadius( 27.5 );
    btnPauseTop = new CircularButton( "data/ui/buttons/pause/enabled.png" );
    btnPauseTop.setPosition( 37.5, 52.5 );
    btnPauseTop.setRadius( 27.5 );
    btnPauseTop.setRotation( PI );

    ballLauncher_bottom = new Turret( 75 , game.getWidth()/2 , game.getHeight() - 100, 150, 50);
    ballLauncher_bottom.setParentClass(this);
    ballLauncher_bottom.faceUp();

    ballLauncher_top = new Turret( 75 , game.getWidth()/2 , 0 + 100, 150, 50);
    ballLauncher_top.setParentClass(this);
    ballLauncher_top.faceDown();

    boosterManager = new BoosterManager(FIELD_MODE, fieldDimensions); // 1 = Easy, 2 - Medium, 3 - Hard

    endLoad( );
  }// load()

  public void update( ) {
    super.update( ); // update PlayState timer
    long time = timer.getMicrosecondsActive( ); // get current game time
    // step until physics time is caught with up or past current game time
    while ( lastUpdate < time ) {
      // The chosen step size means that the physics is updated 200 times/second,
      // or about 3.333 times/frame when running at 60 frames/second. This size can
      // be lowered to prevent tunneling (objects passing through each other, before
      // collision can be detected) or raised if performance is an issue (but it isn't).
      step( 0.005 ); // step physics objects forward by 0.005 seconds and handle collisions
      lastUpdate += 5000; // update physics time by the equivalent 5000 microseconds
    }

  }// update

  private void step( double dt ) {
    for(int i = 0; i < nBalls; i++ ){
      if(balls[i] == null)
        balls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions, ballImages);
      if(decoyBalls[i] == null)
        decoyBalls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions, ballImages);
    }
    
    Booster[] boosters = boosterManager.getBoosters();
    
    // ADD FORCES
    for(int i = 0; i < nBalls; i++ ){
      balls[i].clearForces( );
      decoyBalls[i].clearForces( );
      
      for ( int j = 0; j < boosters.length; j++ )
        if ( boosters[j].contains( balls[i].getPosition( ) ) ){
          balls[i].addForce( boosters[j].getForce( ) );
          decoyBalls[i].addForce( boosters[j].getForce( ) );
        }
      // STEP FORWARD
      balls[i].step( dt );
      decoyBalls[i].step( dt );
      barManager.step( dt );
      //bar.step( dt );
     
      // DO BALL/WALL COLLISIONS
      balls[i].clearWallContacts( );
      decoyBalls[i].clearWallContacts( );
      for( int j = 0; j < horzWalls.length; j++ ){
        balls[i].collide( horzWalls[j] );
        decoyBalls[i].collide( horzWalls[j] );
      }
      for( int j = 0; j < vertWalls.length; j++ ){
        balls[i].collide( vertWalls[j] );
        decoyBalls[i].collide( vertWalls[j] );
      }
      // DO FOOSBAR/BALL COLLISIONS
      barManager.collide( balls[i] );
      barManager.collide( decoyBalls[i] );
      //bar.collide( balls[0] );
   }// for nBalls
   // DO FOOSBAR/WALL COLLISIONS
   barManager.collide( horzWalls );
   //bar.collide( horzWalls[0] );
   //bar.collide( horzWalls[1] );   
  }// step

  public void enter(){
    timer.setActive( true );
    soundManager.playGameplay();
  }// enter()  

  public void draw( ) {
    playStateActive = timer.isActive();

    frameRate(30); // Framerate must be below 60 to allow bar spin gesture.

    if( (ballsInPlay + topQueue + bottomQueue) < nBalls && lastScored == -1 )
      coinToss();

    reloadBall();

    if( topQueue > 0 )
      ballLauncher_top.enable();
    else
      ballLauncher_top.disable();

    if( bottomQueue > 0 )
      ballLauncher_bottom.enable();
    else
      ballLauncher_bottom.disable();

    drawBackground( );

    boosterManager.display();
    barManager.displayZones();

    particleManager.display();
    drawBalls();

    imgNets.draw();
    topGoal.collide(balls);
    bottomGoal.collide(balls);
    topGoal.collide(decoyBalls);
    bottomGoal.collide(decoyBalls);

    barManager.process(balls, timer.getSecondsActive(), this);
    barManager.process(decoyBalls, timer.getSecondsActive(), this);

    topGoal.display();
    bottomGoal.display();
        
    drawBorders();
    particleManager2.display();
    drawButtons();

    ballLauncher_bottom.process(timer.getSecondsActive()); 
    ballLauncher_top.process(timer.getSecondsActive()); 

    if(demoMode && timer.isActive())
      demoMode();

    if(debugText){
      drawStadiumDebug( );

      fill(0,0,0,150);
      stroke(0,0,0);
      rect(0,0, 400, 16*12 );
      textAlign(LEFT);
      fill(debugColor);
      textFont(font,16);
      text("Resolution: "+width+" , "+height, 16, 16*1);  
      text("MousePos: "+mouseX+" , "+mouseY, 16, 16*2);
      text("Timer: "+timer_g, 16, 16*3);
      text("FPS: "+frameRate, 16, 16*4);
      text("Table Friction: "+tableFriction, 16, 16*5);
      text("Last Scored (Top = 0, Bottom = 1): "+lastScored, 16, 16*10);
      text("Ball Queue (Top = "+topQueue+" , Bottom = "+bottomQueue+")", 16, 16*11);
      if(  nBalls > 0 ){
        text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
        text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
        text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
        text("Ball 0 Angle: "+degrees(atan2(balls[0].yVel,balls[0].xVel)), 16, 16*9);
      }
      particleManager.displayDebug(debugColor, font);
      //barManager.displayHitbox();
      boosterManager.displayDebug();
      barManager.displayDebug(debugColor, font);

      for( int i = 0; i < nBalls; i++ ){
        balls[i].displayDebug(debugColor, font);
        decoyBalls[i].displayDebug(debugColor,font);
      }
    }
    drawDebugText();
    
    if( topGoal.isOnFire() || bottomGoal.isOnFire() )
      spawnElephant();
    
    if( timer.isActive() )
      checkWinningConditions();
  }// draw()

  private void drawBackground( ) {
    background( 0 );
    fill( 121, 174, 39 ); // green
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
    imgPitch.draw( );
    imgLines.draw();
    logo.draw();
  }// drawBackGround()

  private void drawStadiumDebug( ) {
    fill( 0x72, 0x21, 0x11 );
    quad( SCREEN_LEFT, SCREEN_TOP, FIELD_LEFT, FIELD_TOP, FIELD_RIGHT, FIELD_TOP, SCREEN_RIGHT, SCREEN_TOP );
    quad( SCREEN_LEFT, SCREEN_BOTTOM, FIELD_LEFT, FIELD_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM, SCREEN_RIGHT, SCREEN_BOTTOM );
    quad( SCREEN_LEFT, SCREEN_TOP, FIELD_LEFT, FIELD_TOP, FIELD_LEFT, GOAL_TOP, SCREEN_LEFT, GOAL_TOP );
    quad( SCREEN_LEFT, SCREEN_BOTTOM, FIELD_LEFT, FIELD_BOTTOM, FIELD_LEFT, GOAL_BOTTOM, SCREEN_LEFT, GOAL_BOTTOM );
    quad( SCREEN_RIGHT, SCREEN_TOP, FIELD_RIGHT, FIELD_TOP, FIELD_RIGHT, GOAL_TOP, SCREEN_RIGHT, GOAL_TOP );
    quad( SCREEN_RIGHT, SCREEN_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM, FIELD_RIGHT, GOAL_BOTTOM, SCREEN_RIGHT, GOAL_BOTTOM );
    // UIC
    //fill( 0xCC, 0, 0 );
    //rect( FIELD_LEFT, SCREEN_TOP+6, FIELD_RIGHT-FIELD_LEFT, FIELD_TOP-SCREEN_TOP-6-6 ); // Side Marker
    //rect( SCREEN_RIGHT, GOAL_TOP, (FIELD_RIGHT-SCREEN_RIGHT)*0.5, GOAL_SIZE ); // Goal
    //fill( 255 );
    //rect( FIELD_RIGHT, GOAL_TOP, 5, GOAL_SIZE );
    // LSU
    //fill( 0xFD, 0xD0, 0x23 );
    //rect( FIELD_LEFT, FIELD_BOTTOM+6, FIELD_RIGHT-FIELD_LEFT, SCREEN_BOTTOM-FIELD_BOTTOM-6-6 ); // Side Marker
    //rect( SCREEN_LEFT, GOAL_TOP, (FIELD_LEFT-SCREEN_LEFT)*0.5, GOAL_SIZE ); // Goal
    //fill( 255 );
    //rect( FIELD_LEFT, GOAL_TOP, -5, GOAL_SIZE );
  }// drawStadiumDebug( )

  public String toString( ) { 
    return "PlayState"; 
  }

  private void drawButtons( ) {
    btnPauseBottom.draw( );
    btnPauseTop.draw( );
  }  

  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame Rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }

  private void drawBalls(){
    // Draw Balls
    for( int i = 0; i < nBalls; i++ ){
      if( balls[i] == null || !timer.isActive() )
        break;

      if( balls[i].isActive() ){
        particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
        balls[i].process( timer.getSecondsActive() );
        balls[i].setFriction(tableFriction);
      }// if ball active
      else if( balls[i].isFireball() ){
        balls[i].process( timer.getSecondsActive() );
        balls[i].setFriction(tableFriction);
        particleManager.explodeParticles( 5, balls[i].diameter, balls[i].xPos, balls[i].yPos, -balls[i].xVel/10, -balls[i].yVel/10, 2 );
      }// else if ball fireball

      if( decoyBalls[i].isDecoyball() ){
        particleManager.trailParticles( 1, decoyBalls[i].diameter, decoyBalls[i].xPos, decoyBalls[i].yPos, 0, 0, 0 );
        decoyBalls[i].process( timer.getSecondsActive() );          
      }
      balls[i].setMaxVel(maxBallSpeed);
      decoyBalls[i].setMaxVel(maxBallSpeed);
    }// for all balls
  }// drawBalls

  private void drawBorders(){
    // Borders
    fill( 100 , 50 , 0 );
    noStroke();
    rect( borderWidth, 0, game.getWidth( )-borderWidth*2, borderHeight ); // Top border
    rect( borderWidth, game.getHeight( )-borderHeight, game.getWidth( )-borderWidth*2, borderHeight ); // Bottom border
    rect( 0, borderHeight, borderWidth, game.getHeight( )-borderHeight*2 ); // Left border
    rect( game.getWidth( )-borderWidth, borderHeight, borderWidth, game.getHeight( )-borderHeight*2 ); // Right border

    // Border Image
    border.draw();

    // Team border
    fill( bottomColor );
    noStroke();
    rect( borderWidth + goalWidth, borderHeight - 30, game.getWidth( )-(borderWidth + goalWidth)*2, 20 ); // Top border
    fill( topColor );
    noStroke();
    rect( borderWidth + goalWidth, game.getHeight( )-borderHeight + 10, game.getWidth( )-(borderWidth + goalWidth)*2, 20 ); // Bottom border
  }// drawBorders()

  private void checkWinningConditions(){
    if( topGoal.getScore() < maxScore && bottomGoal.getScore() < maxScore ){ // Delay between winning goal and win screen
      goalTimeDelay = timer.getSecondsActive() + 2;
    }
    
    if( topGoal.getScore() >= maxScore || bottomGoal.getScore() >= maxScore ){ // Stops game play between winning goal and next screen
      ballLauncher_bottom.disable();
      ballLauncher_top.disable();
      for(int i = 0; i < nBalls; i++)
        balls[i].stopBall();
    }
    
    if( goalTimeDelay > timer.getSecondsActive() )
      return;
    
    if( topGoal.getScore() >= maxScore){
      if( !redTeamTop ){
        redTeamWins = true;
        game.setState( game.getOverState() );
      }
      else{
        yellowTeamWins = true;
        game.setState( game.getOverState() );
      }
    }
    else if( bottomGoal.getScore() >= maxScore  ){
      if( redTeamTop ){
        redTeamWins = true;
        game.getOverState().timer.reset();
        game.setState( game.getOverState() );
      }
      else{
        yellowTeamWins = true;
        game.getOverState().timer.reset();
        game.setState( game.getOverState() );
      }
    }
  }// checkWinningConditions()

  void checkButtonHit(float x, float y, int finger){

    // Keyboard input
    if(keyPressed && usingMouse){
      if( key == 'j' || key == 'J' )
        balls[0].launchBall(x, y, -150, 0);
      else if( key == 'l' || key == 'L' )
        balls[0].launchBall(x, y, 150, 0);
      else if( key == 'i' || key == 'I' )
        balls[0].launchBall(x, y, 0, -150);
      else if( key == 'k' || key == 'K' )
        balls[0].launchBall(x, y, 0, 150);
      else if( key == 'u' || key == 'U' )
        balls[0].setFireball();
      else if( key == 'o' || key == 'O' )
        balls[0].setDecoyball();
    }// if keypressed

    if( btnPauseBottom.contains(x,y) || btnPauseTop.contains(x,y) )
      game.setState( game.getPausedState() );
    
    if(demoMode)
      barManager.barsPressed(x,y);
    
    ballLauncher_top.isHit(x,y);
    ballLauncher_top.rotateIsHit(x,y);
    ballLauncher_bottom.isHit(x,y);
    ballLauncher_bottom.rotateIsHit(x,y);

    // Player can touch the ball if get stuck (must be moving very slow or stopped)
    for( int i = 0; i < nBalls; i++ ){
      try{
      balls[i].isHit(x,y);
      }catch(ArrayIndexOutOfBoundsException e){
        continue;
      }
    }// for nBalls
  }// checkButtonHit

  void sendTouchList(ArrayList touchList){
    if( !demoMode )
      barManager.sendTouchList(touchList, false );
  }// sendTouchList
  
  void checkButtonHit_demo(float x, float y, int finger){
    if( btnPauseBottom.contains(x,y) || btnPauseTop.contains(x,y) )
      game.setState( game.getPausedState() );
  }
  
  void reloadBall(){
    if( lastScored == 0 ){
      bottomQueue++;
    }
    else if( lastScored == 1 ){
      topQueue++;
    }
    lastScored = -1;
  }// reloadBall

  void coinToss(){
    float coinToss = random(2);
    if( coinToss >= 1 )
      bottomQueue++;
    else if( coinToss < 1 )
      topQueue++;
  }// coinToss

  public void demoMode(){
    
    mousePlayback = loadStrings("data/tutorial.txt");
    playbackMouse = true;
    
    fill(0,0,0, 150);
    rect( game.getWidth()/2 + 300, game.getHeight()/2, 500, 400 );
    
    textFont(font,18);
    fill(255,255,255);
    noStroke();
    tutorialText = new String[50];
    int delay_0 = 0;
    tutorialText[0] = "Welcome to the Zooball Tutorial";
    int delay_1 = 3;
    tutorialText[1] = "Move the foosbar by pressing on a touch zone on\n    your side of the table";
    int delay_2 = 6;
    tutorialText[2] = "You can also rotate the bar by moving left\n     and right";
    int delay_3 = 12;
    tutorialText[3] = "Each bar will only respond to touches in its own zone.\nPlace two fingers in a zone to reset the bar rotation.";
    int delay_4 = 20;
    tutorialText[4] = "To launch a ball, press on the ball launcher.\n     It will be green when ready";    
    int delay_5 = 22;
    tutorialText[5] = "Like a slingshot pull back in the opposite\n     direction you want the ball to fire";    
    int delay_6 = 28;
    tutorialText[6] = "To catch a ball angle the foosmen back. Keep your\n     finger in the touch zone to hold the ball";    
    int delay_7 = 32;
    tutorialText[7] = "To throw a ball, flick and release in the desired\n     direction. Now go back to the menu and\n     PLAY ZOOBALL!";    
    int delay_8 = 40;
    
    if( demoTimer > 29.8 && demoTimer < 30 ){
      barManager.bars[4].foosPlayers[0].catchBall2(0);
    }    
    
    previousText = tutorialText[0];
    if( demoTimer > delay_0 ){
      if( demoTimer < delay_1 )
        fill(50,255,50);
      text( tutorialText[0] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 );
    }
    if( demoTimer > delay_1 ){
      if( demoTimer < delay_2 )
        fill(50,255,50);
      text( tutorialText[1] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*1 );
    }
    if( demoTimer > delay_2 ){
      if( demoTimer < delay_3 )
        fill(50,255,50);
      text( tutorialText[2] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*3 );
    }
    if( demoTimer > delay_3 ){
      if( demoTimer < delay_4 )
        fill(50,255,50);
      text( tutorialText[3] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*5 );
    }
    if( demoTimer > delay_4 ){
      if( demoTimer < delay_5 )
        fill(50,255,50);
      text( tutorialText[4] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*7 );
    }
    if( demoTimer > delay_5 ){
      if( demoTimer < delay_6 )
        fill(50,255,50);
      text( tutorialText[5] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*9 );
    }
    if( demoTimer > delay_6 ){
      if( demoTimer < delay_7 )
        fill(50,255,50);
      text( tutorialText[6] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*11 );
      if( demoTimer < delay_6 + 1 )
        balls[0].launchBall(725, 390, 150, 0);
    }
    if( demoTimer > delay_7 ){
      if( demoTimer < delay_8 )
        fill(50,255,50);
      text( tutorialText[7] , game.getWidth()/2 + 320, game.getHeight()/2 + 30 + 24*13 );
    }

    pushMatrix();
    translate( game.getWidth()/2, game.getHeight()/2 );
    rotate( PI );
    fill(0,0,0, 150);
    rect( 0 + 300, 0, 500, 400 );
    
    fill(255,255,255);
    noStroke();
    
    if( demoTimer > delay_0 ){
      if( demoTimer < delay_1 )
        fill(50,255,50);
      text( tutorialText[0] , 0 + 320, 0 + 30 );
    }
    if( demoTimer > delay_1 ){
      if( demoTimer < delay_2 )
        fill(50,255,50);
      text( tutorialText[1] , 0+ 320, 0 + 30 + 24*1 );
    }
    if( demoTimer > delay_2 ){
      if( demoTimer < delay_3 )
        fill(50,255,50);
      text( tutorialText[2] , 0 + 320, 0 + 30 + 24*3 );
    }
    if( demoTimer > delay_3 ){
      if( demoTimer < delay_4 )
        fill(50,255,50);
      text( tutorialText[3] , 0 + 320, 0 + 30 + 24*5 );
    }
    if( demoTimer > delay_4 ){
      if( demoTimer < delay_5 )
        fill(50,255,50);
      text( tutorialText[4] , 0 + 320, 0 + 30 + 24*7 );
    }
    if( demoTimer > delay_5 ){
      if( demoTimer < delay_6 )
        fill(50,255,50);
      text( tutorialText[5] , 0 + 320, 0 + 30 + 24*9 );
    }
    if( demoTimer > delay_6 ){
      if( demoTimer < delay_7 )
        fill(50,255,50);
      text( tutorialText[6] , 0 + 320, 0 + 30 + 24*11 );
    }
    if( demoTimer > delay_7 ){
      if( demoTimer < delay_8 )
        fill(50,255,50);
      text( tutorialText[7] , 0 + 320, 0 + 30 + 24*13 );
    }

    popMatrix();    
    
    if( demoTimer > delay_8 ){
      playbackMouse = false;
      demoMode = false;
    }
  }// demoMode
  
  private void spawnElephant(){
    leftElephant.display();
  }// spawnElephant
}// class PlayState


