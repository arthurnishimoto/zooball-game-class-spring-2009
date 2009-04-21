/**
 * ---------------------------------------------
 * PlayState.pde
 *
 * Description: Gameplay State
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.7
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
 * 4/20/09      - [Added] TouchAPI support
 * 4/21/09      - Version 0.7
 *              - Moved from PlayTestState to PlayState
 *              - [Added] Pause, Over State support
 * Notes:
 *      - [TODO] Add visual score counter above goals
 *      - [TODO] Limit bar spin when two un-parallel fingers in bar touch zone?
 *	- [TODO] Physics engine?
 *      - [TODO] Improve collision detection on goal zones
 *      - [TODO] Forward ball stop on foosman2
 *      - [TODO] 1-to-1 control over goalie zone?
 *      - [TODO] Rewrite to FSM format
 *      - [NOTE] Two close fingers to move bars works well on TacTile.
 *      - [NOTE] Foosman spin gesture works when FPS is 20-30 (60 too high).
 *      - [NOTE] Turret shoot-on-release works on TacTile only when usingMouse = false.
 * ---------------------------------------------
 */

// Gameplay Flags
Boolean displayArt = true;

Boolean yellowTeamTop = true;

Boolean yellowTeamWins = false;
Boolean redTeamWins = false;

Boolean debugText = false; // TEMP
Boolean debug2Text = false; // TEMP
color debugColor = color(255,255,255); // TEMP

// Gameplay Initial Variables
int nBalls = 5;
int maxScore = 2;
float tableFriction = 0.01; // Default = 0.01
int rotateInc = 15; // Global rotation increment for artwork

int borderWidth = 0;
int goalWidth = 100; // Replaces borderWidth to allow balls inside the goal.
int borderHeight = 100;

int fieldLines = 9; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #. Default = 9
int nBars = fieldLines - 1; 
int barWidth = 213;

double timer_g = 0; // TEMP
PFont font;

// Data Structures / Objects
Ball[] balls;
int[] screenDimensions = new int[4];
PImage ballImages[] = new PImage[360];
PImage red_foosmanImages[] = new PImage[360];
PImage yellow_foosmanImages[] = new PImage[360];
Goal topGoal, bottomGoal;
color topColor;
color bottomColor;
Turret ballLauncher_bottom;
Turret ballLauncher_top;

// Rotate animation images
String filepath;
String filename;
String extention = ".png";
    
// Managers
ParticleManager particleManager = new ParticleManager( 2000, 5 );
FoosbarManager barManager;

class PlayState extends GameState
{
  private CircularButton btnPauseTop, btnPauseBottom;
  int ballsInPlay = 0;
  int ballQueue = 0;

  public PlayState( Game game ) {
    super( game );
  }// CTOR
  
  public void load( ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 5;
    Random r = new Random( );
    
    for ( int i = 0; i < max; i++ )
      r.nextDouble( ); 
    
    yellowTeamWins = false;
    redTeamWins = false;
    
    screenDimensions[0] = (int)game.getWidth( );
    screenDimensions[1] = (int)game.getHeight( );
    screenDimensions[2] = borderWidth;
    screenDimensions[3] = borderHeight;

    font = loadFont("ui\\fonts\\Arial Bold-14.vlw"); // TEMP
    balls = new Ball[nBalls];
    
    // Loads Ball artwork
    filepath = "data/objects/ball/";
    filename = "ball_";
    for(int i = 0; i < 360; i += rotateInc)
      ballImages[i] = loadImage(filepath + filename + i + extention);
    
    for( int i = 0; i < nBalls; i++ ){
      balls[i] = new Ball( game.getWidth( )/2, game.getHeight( )/2, 50, i, balls, screenDimensions, ballImages);
      balls[i].setActive();
    }

    // Loads Red Foosman artwork
    filepath = "data/objects/foosmen_red/";
    filename = "red_top_";
    for(int i = 0; i < 360; i += rotateInc)
      red_foosmanImages[i] = loadImage(filepath + filename + i + extention);
      
    // Loads Yellow Foosman artwork
    filepath = "data/objects/foosmen_yellow/";
    filename = "yellow_top_";
    for(int i = 0; i < 360; i += rotateInc)
      yellow_foosmanImages[i] = loadImage(filepath + filename + i + extention);      
      
    barManager = new FoosbarManager( fieldLines, barWidth, screenDimensions, balls, red_foosmanImages, yellow_foosmanImages);

    // Sets team colors
    if( !yellowTeamTop ){
      topColor = color(255,0,0);
      bottomColor = color(255,255,0);
    }else{
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
    btnPauseBottom = new CircularButton( "ui\\buttons\\pause\\enabled.png" );
    btnPauseBottom.setPosition( 1882.5, 1027.5 );
    btnPauseBottom.setRadius( 27.5 );
    btnPauseTop = new CircularButton( "ui\\buttons\\pause\\enabled.png" );
    btnPauseTop.setPosition( 37.5, 52.5 );
    btnPauseTop.setRadius( 27.5 );
    btnPauseTop.setRotation( PI );
       
    ballLauncher_bottom = new Turret( 75 , game.getWidth()/2 , game.getHeight() - 100, 150, 50);
    ballLauncher_bottom.setParentClass(this);
    ballLauncher_bottom.faceUp();
    
    ballLauncher_top = new Turret( 75 , game.getWidth()/2 , 0 + 100, 150, 50);
    ballLauncher_top.setParentClass(this);
    ballLauncher_top.faceDown();
    
    endLoad( );
  }// load()
  
  public void enter(){
    timer.setActive( true );
    soundManager.stopSounds();
    soundManager.playGameplay();
  }// enter()  
  
  public void draw( ) {
    drawBackground( );
    
    particleManager.display();
    barManager.displayZones();
    
    drawBalls();
    
    topGoal.collide(balls);
    bottomGoal.collide(balls);
            
    barManager.process(balls, timer.getSecondsActive());
  
    topGoal.display();
    bottomGoal.display();
    
    drawBorders();
    drawButtons();
    drawDebugText();
    
    if( timer.isActive() )
      checkWinningConditions();
  }// draw()
  
  private void drawBackground( ) {
    background( 0 );
    fill( 20, 200, 20 ); // green
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }// drawBackGround()
  
  public String toString( ) { return "PlayState"; }
  
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
      if( !timer.isActive() )
        break;

      if( balls[i].isActive() ){
        particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
        balls[i].process( timer.getSecondsActive() );
        balls[i].setFriction(tableFriction);
      }// if ball active
      else if( balls[i].isFireball() ){
        balls[i].process( timer.getSecondsActive() );
        balls[i].setFriction(tableFriction);
        particleManager.explodeParticles( 5, balls[i].diameter, balls[i].xPos, balls[i].yPos, -balls[i].xVel/2, -balls[i].yVel/2, 2 );
      }// else if ball fireball
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
    
    
    // Team border
    fill( topColor );
    noStroke();
    rect( borderWidth + goalWidth, borderHeight - 30, game.getWidth( )-(borderWidth + goalWidth)*2, 20 ); // Top border
    fill( bottomColor );
    noStroke();
    rect( borderWidth + goalWidth, game.getHeight( )-borderHeight + 10, game.getWidth( )-(borderWidth + goalWidth)*2, 20 ); // Bottom border    
  }// drawBorders()
  
  private void checkWinningConditions(){
    if( topGoal.getScore() >= maxScore ){
      if( !yellowTeamTop ){
        redTeamWins = true;
        game.setState( game.getOverState() );
      }else{
        yellowTeamWins = true;
        game.setState( game.getOverState() );
      }
    }else if( bottomGoal.getScore() >= maxScore  ){
      if( yellowTeamTop ){
        redTeamWins = true;
        game.getOverState().timer.reset();
        game.setState( game.getOverState() );
      }else{
        yellowTeamWins = true;
        game.getOverState().timer.reset();
        game.setState( game.getOverState() );
      }
    }
  }// checkWinningConditions()
  
  void checkButtonHit(float x, float y, int finger){
    if( btnPauseBottom.contains(x,y) || btnPauseTop.contains(x,y) )
       game.setState( game.getPausedState() );
    barManager.barsPressed(x,y);
  }// checkButtonHit
}// class PlayState

