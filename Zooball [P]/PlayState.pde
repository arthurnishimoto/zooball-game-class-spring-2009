/**
 * ---------------------------------------------
 * PlayState.pde
 *
 * Description: Gameplay State
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.8
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
 *
 * Notes:
 *      - [TODO] Limit bar spin when two un-parallel fingers in bar touch zone?
 *	- [TODO] Physics engine?
 *      - [TODO] Improve collision detection on goal zones
 *      - [TODO] 1-to-1 control over goalie zone?
 *      - [NOTE] Two close fingers to move bars works well on TacTile.
 *      - [NOTE] Foosman spin gesture works when FPS is 20-30 (60 too high).
 *      - [NOTE] Turret shoot-on-release works on TacTile only when usingMouse = false.
 * ---------------------------------------------
 */

// Gameplay Flags
Boolean displayArt = true;

Boolean redTeamTop = true;

Boolean yellowTeamWins = false;
Boolean redTeamWins = false;

Boolean debugText = false; // TEMP
Boolean debug2Text = false; // TEMP
color debugColor = color(255,255,255); // TEMP

// Gameplay Initial Variables
int nBalls = 1;
int maxScore = 5;
float tableFriction = 0.01; // Default = 0.01
int maxBallSpeed = 15;
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
Ball[] decoyBalls;
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
ParticleManager particleManager = new ParticleManager( 2000, 5 ); // Ball trail effects
ParticleManager particleManager2 = new ParticleManager( 2000, 3 ); // Fire effects
FoosbarManager barManager;

class PlayState extends GameState
{
  private CircularButton btnPauseTop, btnPauseBottom;
  private Image imgPitch, border, imgLines, imgNets, logo;
  int ballsInPlay = 0;
  int ballQueue = 0;
  int lastScored = -1;
    
  public PlayState( Game game ) {
    super( game );
  }// CTOR
  
  public void load( ) {
    ballsInPlay = 0;
    ballQueue = 0;
    lastScored = -1;
  
    imgPitch = new Image( "data/objects/stadium/gamefield_grass.gif" );
    imgPitch.setPosition( 0, 0 );
    border = new Image( "data/objects/stadium/gamefield_woodtrim.png" );
    border.setPosition( 0, 0 );
    imgLines = new Image( "data/objects/stadium/gamefield_centerline_goalzones.png" );
    imgLines.setPosition( 0, 0 );
    imgNets = new Image( "data/objects/stadium/gamefield_nets.png" );
    imgNets.setPosition( 0, 0 );
    logo = new Image( "data/objects/stadium/gamefield_logo.png" );
    logo.setPosition( 0, 0 );    
    
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

    font = loadFont("data/ui/fonts/Arial Bold-14.vlw"); // TEMP
    balls = new Ball[nBalls];
    decoyBalls = new Ball[nBalls];
    
    // Loads Ball artwork
    filepath = "data/objects/ball/";
    filename = "ball_";
    for(int i = 0; i < 360; i += rotateInc)
      ballImages[i] = loadImage(filepath + filename + i + extention);
    
    for( int i = 0; i < nBalls; i++ ){
      balls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions, ballImages);
      decoyBalls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions, ballImages);
    }

    // Loads Red Foosman artwork
    //filepath = "data/objects/foosmen_red/";
    //filename = "red_top_";
    filepath = "data/objects/dragon_360/";
    filename = "dragon_";
    for(int i = 0; i < 360; i += rotateInc)
      red_foosmanImages[i] = loadImage(filepath + filename + i + extention);
      
    // Loads Yellow Foosman artwork
    //filepath = "data/objects/foosmen_yellow/";
    //filename = "yellow_top_";
    filepath = "data/objects/tiger_360/";
    filename = "tiger_";
    for(int i = 0; i < 360; i += rotateInc)
      yellow_foosmanImages[i] = loadImage(filepath + filename + i + extention);      
      
    barManager = new FoosbarManager( fieldLines, barWidth, screenDimensions, balls, red_foosmanImages, yellow_foosmanImages);

    // Sets team colors
    if( !redTeamTop ){
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
    
    coinToss();

    endLoad( );
  }// load()
  
  public void enter(){
    timer.setActive( true );
    soundManager.stopSounds();
    soundManager.playGameplay();
  }// enter()  
  
  public void draw( ) {
    frameRate(30); // Framerate must be below 60 to allow bar spin gesture.
    
    if( ballsInPlay != 0 && ballsInPlay <= nBalls )
      coinToss();
    if( ballsInPlay == 0)
      reloadBall();
      
    drawBackground( );
    
    particleManager.display();
    barManager.displayZones();
    
    drawBalls();
    
    imgNets.draw();
    topGoal.collide(balls);
    bottomGoal.collide(balls);
    topGoal.collide(decoyBalls);
    bottomGoal.collide(decoyBalls);
    
    barManager.process(balls, timer.getSecondsActive());
    barManager.process(decoyBalls, timer.getSecondsActive());
    
    topGoal.display();
    bottomGoal.display();
    
    drawBorders();
    particleManager2.display();
    drawButtons();
    
    ballLauncher_bottom.process(timer.getSecondsActive()); 
    ballLauncher_top.process(timer.getSecondsActive()); 
    
    drawDebugText();
    
    if(debugText){
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
      if(  nBalls > 0 ){
        text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
        text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
        text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
        text("Ball 0 Angle: "+degrees(atan2(balls[0].yVel,balls[0].xVel)), 16, 16*9);
      }
      particleManager.displayDebug(debugColor, font);
      barManager.displayDebug(debugColor, font);
      barManager.displayHitbox();
      for( int i = 0; i < nBalls; i++ ){
        balls[i].displayDebug(debugColor, font);
        decoyBalls[i].displayDebug(debugColor,font);
      }
    }
    
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
    for( int i = 0; i < balls.length; i++ ){
      if( !timer.isActive() )
        break;
        
      balls[i].setMaxVel(maxBallSpeed);
      decoyBalls[i].setMaxVel(maxBallSpeed);
      
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
      
      if( decoyBalls[i].isDecoyball() ){
        particleManager.trailParticles( 1, decoyBalls[i].diameter, decoyBalls[i].xPos, decoyBalls[i].yPos, 0, 0, 0 );
        decoyBalls[i].process( timer.getSecondsActive() );          
      }
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
    if( topGoal.getScore() >= maxScore ){
      if( !redTeamTop ){
        redTeamWins = true;
        game.setState( game.getOverState() );
      }else{
        yellowTeamWins = true;
        game.setState( game.getOverState() );
      }
    }else if( bottomGoal.getScore() >= maxScore  ){
      if( redTeamTop ){
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
    
  // Keyboard input
  if(keyPressed && usingMouse){
    if( key == 'b' || key == 'B' )
       balls[0].launchBall(mouseX, mouseY, 5, 0);
    else if( key == 'v' || key == 'V' )
       balls[0].launchBall(mouseX, mouseY, 0, 5);
    else if( key == 'n' || key == 'N' )
       balls[0].launchBall(mouseX, mouseY, 5, 5);
    else if( key == 'f' || key == 'F' )
      balls[0].launchFireball(mouseX, mouseY, 5, 5);
    else if( key == 'd' || key == 'D' )
      decoyBalls[0].launchDecoyball(mouseX, mouseY, 5, 5);
  }// if keypressed
  
    if( btnPauseBottom.contains(x,y) || btnPauseTop.contains(x,y) )
       game.setState( game.getPausedState() );
    barManager.barsPressed(x,y);
    
    ballLauncher_top.isHit(x,y);
    ballLauncher_top.rotateIsHit(x,y);
    ballLauncher_bottom.isHit(x,y);
    ballLauncher_bottom.rotateIsHit(x,y);
    
    // Player can touch the ball if get stuck (must be moving very slow or stopped)
    for( int i = 0; i < nBalls; i++ ){
        balls[i].isHit(x,y);
    }// for nBalls     
  }// checkButtonHit
  
  void reloadBall(){
    if( lastScored == 0 ){
      ballLauncher_bottom.enable();
    }else if( lastScored == 1 ){
      ballLauncher_top.enable();
    }
  }// reloadBall
  
  void coinToss(){
    float coinToss = random(2);
    if( coinToss >= 1 )
      ballLauncher_bottom.enable();
    else if( coinToss < 1 )
      ballLauncher_top.enable();
      
    if( ballsInPlay == nBalls ){
      ballLauncher_top.disable();
      ballLauncher_bottom.disable();
    }
  }// coinToss

}// class PlayState
