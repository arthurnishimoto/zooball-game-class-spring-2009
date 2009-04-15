/**
 * ---------------------------------------------
 * FoosballTest.pde
 *
 * Description: Foosball prototype.
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto (anishimo) - Infinite State Entertainment
 * Version: 0.43
 *
 * Version Notes:
 * 3/1/09	- Initial version 0.1
 * 3/5/09       - Version 0.2
 *              - FoosBars, players added. Bar rotation and touch zones implemented.
 *              - FoosBarManager generates number of player on bars based on number of bars. ( 3 person and goalie only)
 *              - FoosPlayers block balls if bar is within -0.4 to 0.4 of rotation value.
 * 3/6/09       - Version 0.21
 *              - [FIXED] players now block the ball when playerWidth = -1.
 *              - [FIXED] MTFoosBar::collide(balls[]), Ball::isHit() - Foosmen block balls and changes the ball's velocity based on the bar's velocity.
 *                        Resolves "pass through" issue when ball would hit top or bottom surface of foosmen
 *              - [FIXED] MTFoosBar::reset() - Bars now always reset the xMove and yMove values. This prevents the bars from becoming stuck on screen edge.
 *                        Bar can still get stuck, but releasing will unstick it.
 *              - [ADDED] sliderMultiplier can be used to increase slider speed for tacTile
 *              - [ADDED] Ball::isHit() randomly kicks the ball if pressed when ball's speed < 1. Original function of isHit() - when foosmen hits ball, changed
 *                        to Ball::kickBall().
 * 3/11/09      - [ADDED] Program screen size now based on screenWidth and screenHeight variables in main. Allows for proper resize for applet or windowed mode.
 * 3/12/09      - Version 0.22
 *              - [ADDED] Borders now restrict ball movement and is recognized as topEdge or bottomEdge for foosmen collision (marked as on edge, but takes no block action)
 *              - [REMOVED] Ball and foosmen collision info, foosmen and edge of play area collision.
 *              - [ADDED] New foosmen collision boxes are now visible via Foosplayer::displayDebug()
 * 3/13/09      - [MODIFIED] Foosplayer collision detection with ball revamped in Foosplayer::collide(ball[]) - Ball still can bounce inside player.
 *              - [MODIFIED] Foosplayer::collide(ball[]) now has a delay before it will change the velocity of the ball - fixes collision problems except for slow moving balls
 * 3/18/09      - Version 0.225 
 *              - [MODIFIED] Ball changed to FSM
 *              - [ADDED] Turret ball launcher
 * 3/19/09      - [ADDED] Pause button/menu - States for overall program
 *              - [MODIFIED] Foosplayer::collide(ball[]) now tracks all recently hits balls and ignores them - fixes collision problems except for rare "corner" cases
 * 3/20/09      - Version 0.3
 *              - [ADDED] Goals and scoring
 *              - [FIXED] Minor bugs with collision for ball, foosmen, and goal zone.
 *              - [ADDED] After scoring, ball is given to other team. Launcher activated - Only tested with one ball
 * 3/28/09      - Version 0.31 - All classes except Turret have been modified to be independent of variables in main class. (ex debugColor/font, screenDim)
 *              - [Modified] Turret control revised. Rotate shows direction choice and ball now fires on button release, not press.
 *              - [Bugged] Revision of Goal class now prevents proper score keeping
 *              - [Added] Foosman now accepts a single .gif image
 * 4/1/09       - Version 0.32 - Foosbar has optional "spring-loaded" mode
 *              - [Modified] Turret can be toggled from press to shoot, or release to shoot
 *              - [Added] SoundManager, Menu Screen for demo
 * 4/2/09       - [Added] Demo main menu, first sound files, ball accepts a single image file
 * 4/3/09       - Version 0.4 - Mid-Semester Demo
 *              - [Added] FoosbarRotateTest imports up to 360 images and rotates it. Demo screen for sound, rotate test.
 * 4/4/09       - Version 0.41
 *              - [Added] Debug Console to change number of bars/balls, volume, table friction, and older debug functions
 * 4/9/09       - [Modified] Music looping, stops if selected while playing. Gameplay added to main game.
 *              - [Added] Ball rolling animations. Foosbar2 hitbox displayed, not used.
 * 4/10/09      - [Modified] Touch zones changed to 213 for TacTile size. 8 bar teams changed for TacTile (center bar has 4 players instead of 5)
 *              - [Fixed] Touch release bug for turret - NEEDS TESTING
 *              - Version 0.42
 *              - [Modified] Bar/ball collision detection for Foosbar2. Foosman stops ball at certain angle.
 * 4/16/09      - Version 0.43
 *              - [Added] DebugConsole2 controls for bar sensitivity options.
 *              - [Fixed] Touch release bug for turret and foosmen spin gesture working in 30 FPS
 * Notes:
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

import processing.opengl.*; // Disabled for applet

import processing.net.*;
import tacTile.net.*;
 
// Overall Program Flags
String companyName = "Infinite State Entertainment";
String programName = "Zooball";
float versionNo = 0.43;
String textLine2 = "'"+programName+"' Prototype v"+versionNo;
//String textLine2 = "Mid-Semester Demo";

boolean connectToTacTile = false; // Should disable mouse if using TacTile
boolean usingMouse = true;
boolean applet = false;
boolean debugText = false;
boolean debug2Text = false;
boolean displayHitbox = true;
boolean displayArt = true;

boolean debugConsole = false;
boolean debugConsole2 = false;
int new_nBalls, newFieldLines;

color debugColor = color( 255, 255, 255 );

int screenWidth = screen.width;
int screenHeight = screen.height;

int framerate = 30; // Framerate should be at 20-30 to rotate foosmen properly
float timerIncrementer = 0.030; //Default = 0.048; 0.015 for 60 FPS; 0.030 for 30 FPS

//Touch API
TouchAPI tacTile;

//List of Touches
ArrayList touchList = new ArrayList();

//Names of machines you might use
String localMachine = "localhost";
String tacTileMachine = "tactile.evl.uic.edu";

//Port for data transfer
int dataPort = 7000;
int msgPort = 7340;

//Generic Data Items
double timer_g; // Game timer
PFont font;

// Program Specific Code
int state;
final static int MAIN_MENU = 0;
final static int PAUSE = 1;
final static int GAMEPLAY = 2;
final static int FOOSBAR = 3;
final static int SOUNDTEST = 4;

// Main Menu State
PImage infinity, ISE, greenButton;
int fade = 255;
boolean fadeIn = false;
boolean animate = true;
int pos = 0;
int finalPos = 150;
Button startButton;
Button topButton1, topButton2, topButton3, topButton0;
Button bottomButton1, bottomButton2, bottomButton3, bottomButton0;

// Pause State
Button resumeButton, resetButton, quitButton;

// Gameplay  State
PImage fieldImage, borderImage;
int borderWidth = 0;
int borderHeight = 100;
int lastScored = -1;
int[] screenDimensions = new int[4];

float coinToss;
float tableFriction = 0.01; // Default = 0.01
int fieldLines = 9; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #. Default = 9
int nBars = fieldLines - 1;

FoosbarManager barManager;
ParticleManager particleManager;
SoundManager soundManager;

int nBalls = 10;
int ballsInPlay = 0;
int ballQueue = 0;
int barWidth = 213;
Ball[] balls;

// Bottom player
int bottomScore = 0;
Turret ballLauncher_bottom;
Button pauseButton_bottom;


// Top Player
int topScore = 0;
Turret ballLauncher_top;
Button pauseButton_top;

Goal leftGoal, rightGoal;

// Debugging Buttonu
Button debugButton;
Button debugTextButton, debug2TextButton;
Button springButton, turretButton;
Button addBall, subtBall;
Button addBar, subtBar;
Button volumeUp, volumeDown;
Button muteButton;
Button applyChanges;
Button addFriction, subtFriction;

// Foosbar State
Foosbar2 testbar;
Foosbar2 testbar2;
Button topBack, bottomBack;

// SoundTest State
Button topSoundButton1, topSoundButton2, topSoundButton3, topSoundButton4, topSoundButton5;
Button botSoundButton1, botSoundButton2, botSoundButton3, botSoundButton4, botSoundButton5;
Button barWidthUp, barWidthDown;

/*
 * Setup Method
 * 		Network connections and data structures used in your
 * 			application should be placed here. Consequently, 
 * 			the connection between Tac Tile an the application 
 *                      is initialized here.  
 */
void setup() {
  if ( connectToTacTile ){
      //size of the screen
      size( screenWidth, screenHeight, OPENGL); // OPENGL on tacTile causes connect failure if placed after TouchAPI CTOR
      
      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);
  } else {
      //size of the screen
      if(applet){
        screenWidth = 1440; // 50% TecTile Size
        screenHeight = 810;// Same Aspect Ratio
        size( 1440, 810, OPENGL ); // applet
      }else{
        // TacTile Resolution
        //screenWidth = 1920;
        //screenHeight = 1080;
        size( screenWidth, screenHeight, OPENGL);
        
        //Create connection to Touch Server
        tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
      }// if applet elsr
  }// if-else tacTile
  
  // Sets the screen dimensions array - distributed to other classes
  screenDimensions[0] = screenWidth;
  screenDimensions[1] = screenHeight;
  screenDimensions[2] = borderWidth;
  screenDimensions[3] = borderHeight;
  
  //color of the background
  background( 10 , 60 , 10 );
  timer_g = 0;
  
  // Initial State
  state = GAMEPLAY; 
  
  //set frameRate
  frameRate(framerate); // Note tacTile generally runs at 16 FPS w/o OPENGL
  
  //load font  
  font = loadFont("CourierNew36.vlw"); 
  
  //load images
  infinity = loadImage("infinity.png");
  ISE = loadImage("ise0.png");
  greenButton = loadImage("glowButton_green.png");
  fieldImage = loadImage("blank.png");
  borderImage = loadImage("blank.png");

  newFieldLines = fieldLines;
  new_nBalls = nBalls;
  
  loadGame();
}// setup


void loadGame(){
    // Sets the screen dimentions array - distributed to other classes
    screenDimensions[0] = screenWidth;
    screenDimensions[1] = screenHeight;
    screenDimensions[2] = borderWidth;
    screenDimensions[3] = borderHeight;
      
    // Main Menu Screen
    startButton = new Button( width/2 - 300/2, height/2 - 150/2, 300, 150 );
    startButton.setPressedColor(color(255,0,0,1));
    
    int vertShift = 300;
    topButton0 = new Button( width/2 - 300, height/2 - vertShift, "glowButton_blue.png" );
    topButton0.setFadeIn();
    topButton0.setButtonText("QUIT");
    topButton0.setInvertedText(true);
    
    topButton1 = new Button( width/2 - 100, height/2 - vertShift, "glowButton_blue.png" );
    topButton1.setFadeIn();
    topButton1.setButtonText("ROTATE DEMO");
    topButton1.setInvertedText(true);
    
    topButton2 = new Button( width/2 + 100, height/2 - vertShift, "glowButton_blue.png" );
    topButton2.setFadeIn(); 
    topButton2.setButtonText("GAMEPLAY DEMO");
    topButton2.setInvertedText(true);
    
    topButton3 = new Button( width/2 + 300, height/2 - vertShift, "glowButton_blue.png" );
    topButton3.setFadeIn();
    topButton3.setButtonText("SOUND DEMO");
    topButton3.setInvertedText(true);
 
    bottomButton0 = new Button( width/2 - 300, height/2 + vertShift, "glowButton_red.png" );
    bottomButton0.setButtonText("SOUND DEMO");
    bottomButton0.setFadeIn();
    bottomButton0.setDoubleSidedText(false);
    
    bottomButton1 = new Button( width/2 - 100, height/2 + vertShift, "glowButton_red.png" );
    bottomButton1.setButtonText("GAMEPLAY DEMO");
    bottomButton1.setFadeIn();
    bottomButton1.setDoubleSidedText(false);
    
    bottomButton2 = new Button( width/2 + 100, height/2 + vertShift, "glowButton_red.png" );
    bottomButton2.setFadeIn(); 
    bottomButton2.setButtonText("ROTATE DEMO");
    bottomButton2.setDoubleSidedText(false);
    
    bottomButton3 = new Button( width/2 + 300, height/2 + vertShift, "glowButton_red.png" );
    bottomButton3.setButtonText("QUIT");
    bottomButton3.setFadeIn();
    bottomButton3.setDoubleSidedText(false);
    
    // Pause Screen
    resumeButton = new Button( screenWidth/4, screenHeight/2, 100);
    resumeButton.setIdleColor(color(0,255,0));
    resumeButton.setButtonText("RESUME");
    
    resetButton = new Button( screenWidth/2, screenHeight/2, 100);
    resetButton.setIdleColor(color(0,255,100));
    resetButton.setButtonText("RESET");
    
    quitButton = new Button( 3*screenWidth/4, screenHeight/2, 100);
    quitButton.setIdleColor(color(0,100,100));
    quitButton.setButtonText("QUIT");
    
    // Gameplay Screen
    balls = new Ball[nBalls];
    timer_g = 0;
    ballsInPlay = 0;
    bottomScore = 0;
    topScore = 0;
    
    barManager = new FoosbarManager( fieldLines, barWidth, screenDimensions, balls );
    particleManager = new ParticleManager( 2000, 5 );
    soundManager = new SoundManager(this);
    
    ballLauncher_bottom = new Turret( 75 , screenWidth/2 , screenHeight - 100, 150, 50);
    ballLauncher_bottom.setParentClass(this);
    ballLauncher_bottom.faceUp();
    
    ballLauncher_top = new Turret( 75 , screenWidth/2 , 0 + 100, 150, 50);
    ballLauncher_top.setParentClass(this);
    ballLauncher_top.faceDown();
    
    coinToss();
      
    pauseButton_bottom = new Button( 50 , 0 + borderHeight/2, 50 );
    pauseButton_bottom.setInvertedText(true);
    pauseButton_bottom.setButtonText("Pause");
    pauseButton_bottom.setButtonTextColor(color(255,255,255));
    
    pauseButton_top = new Button( screenWidth - 50, screenHeight - borderHeight/2, 50 );
    pauseButton_top.setDoubleSidedText(false);
    pauseButton_top.setButtonText("Pause");
    pauseButton_top.setButtonTextColor(color(255,255,255));
  
    leftGoal = new Goal( borderWidth, height/2, 100, 300 , 0, balls);
    leftGoal.setParentClass(this);
    rightGoal = new Goal( screenWidth-borderWidth-100, height/2, 100, 300 , 1, balls);
    rightGoal.setParentClass(this);
        
    for( int i = 0; i < nBalls; i++ ){
      // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
      balls[i] = new Ball( -100, -100, 50, i, balls, screenDimensions);
    }
    
    // Foosbar Test Screen
    //Foosbar2(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color tColor, int zoneFlg)
    testbar = new Foosbar2( screenWidth/4-260/2, 0, 260, screenHeight, 3, color(255,255,0), 0 );
    testbar2 = new Foosbar2( 3*screenWidth/4-260/2, 0, 260, screenHeight, 3, color(255,255,0), 1 );
    testbar.setupBars(screenDimensions, balls);
    testbar2.setupBars(screenDimensions, balls);
    
    bottomBack = new Button( screenWidth - 100, screenHeight - 75, "glowButton_blue.png" );
    bottomBack.setButtonText("MENU");
    bottomBack.setDoubleSidedText(false);

    topBack = new Button( 100 ,  + 75, "glowButton_blue.png" );
    topBack.setButtonText("MENU");
    topBack.setInvertedText(true);
    
    // Sound Test Screen
    vertShift = 400;
    
    topSoundButton1 = new Button( width/2 - 400, height/2 - vertShift, "glowButton_green.png" );
    topSoundButton1.setButtonText("POSTGAME");
    topSoundButton1.setInvertedText(true);
    
    topSoundButton2 = new Button( width/2 - 200, height/2 - vertShift, "glowButton_green.png" );
    topSoundButton2.setButtonText("GOOAAL");
    topSoundButton2.setInvertedText(true);
    
    topSoundButton3 = new Button( width/2 - 000, height/2 - vertShift, "glowButton_green.png" );
    topSoundButton3.setButtonText("BOUNCE");
    topSoundButton3.setInvertedText(true);
    
    topSoundButton4 = new Button( width/2 + 200, height/2 - vertShift, "glowButton_green.png" );
    topSoundButton4.setButtonText("KICK");
    topSoundButton4.setInvertedText(true);
    
    topSoundButton5 = new Button( width/2 + 400, height/2 - vertShift, "glowButton_green.png" );
    topSoundButton5.setButtonText("GAMEPLAY");
    topSoundButton5.setInvertedText(true);
    
    botSoundButton1 = new Button( width/2 - 400, height/2 + vertShift, "glowButton_green.png" );
    botSoundButton1.setButtonText("GAMEPLAY");
    botSoundButton1.setDoubleSidedText(false);
    
    botSoundButton2 = new Button( width/2 - 200, height/2 + vertShift, "glowButton_green.png" );
    botSoundButton2.setButtonText("KICK");
    botSoundButton2.setDoubleSidedText(false);
    
    botSoundButton3 = new Button( width/2 - 000, height/2 + vertShift, "glowButton_green.png" );

    botSoundButton3.setButtonText("BOUNCE");
    botSoundButton3.setDoubleSidedText(false);
    
    botSoundButton4 = new Button( width/2 + 200, height/2 + vertShift, "glowButton_green.png" );
    botSoundButton4.setButtonText("GOOAAL");
    botSoundButton4.setDoubleSidedText(false);
    
    botSoundButton5 = new Button( width/2 + 400, height/2 + vertShift, "glowButton_green.png" );
    botSoundButton5.setButtonText("POSTGAME");
    botSoundButton5.setDoubleSidedText(false);
    
    
    // Debugging Console
    debugButton = new Button( 50 , screenHeight - borderHeight/2 - 75*0, 50 );
    debugButton.setIdleColor(color(0,10,0));    
    debugButton.setLitColor(color(0,250,50)); 

    debugTextButton = new Button( 375 , screenHeight - borderHeight/2 - 75*0, 50 );
    debugTextButton.setIdleColor(color(0,50,50));
    debugTextButton.setLitColor(color(0,250,250));
    
    debug2TextButton = new Button( 375 , screenHeight - borderHeight/2 - 75*1, 50 );
    debug2TextButton.setIdleColor(color(0,50,50));
    debug2TextButton.setLitColor(color(0,250,250));
    
    springButton = new Button( 375 , screenHeight - borderHeight/2 - 75*2, 50 );
    springButton.setIdleColor(color(0,50,50));
    springButton.setLitColor(color(250,250,0));
    
    turretButton = new Button( 375 , screenHeight - borderHeight/2 - 75*3, 50 );
    turretButton.setIdleColor(color(0,50,50));
    turretButton.setLitColor(color(0,250,0));
    
    volumeDown = new Button( 50, screenHeight - borderHeight/2 - 65*5 - 25, 50, 50 );
    volumeDown.setIdleColor(color(250,250,250));
    volumeDown.setButtonText("-");
    volumeDown.setDoubleSidedText(false);    
    
    volumeUp = new Button( 250, screenHeight - borderHeight/2 - 65*5 - 25, 50, 50 );
    volumeUp.setIdleColor(color(250,250,250));
    volumeUp.setButtonText("+");
    volumeUp.setDoubleSidedText(false); 
         
    muteButton = new Button( 250 + 75, screenHeight - borderHeight/2 - 65*5 - 25, 100, 50 );
    muteButton.setIdleColor(color(60,10,10));
    muteButton.setLitColor(color(255, 0, 0));
    muteButton.setButtonText("MUTE");
    muteButton.setDoubleSidedText(false);  
    
    applyChanges = new Button( 125, screenHeight - borderHeight/2 - 65*0 - 25, 200, 50 );
    applyChanges.setIdleColor(color(60,10,10, 1));
    applyChanges.setLitColor(color(255, 0, 0));
    applyChanges.setDoubleSidedText(false);  
    
    subtBall = new Button( 50, screenHeight - borderHeight/2 - 65*4 - 25, 50, 50 );
    subtBall.setIdleColor(color(250,250,250));
    subtBall.setButtonText("-");
    subtBall.setDoubleSidedText(false);
    addBall = new Button( 250, screenHeight - borderHeight/2 - 65*4 - 25, 50, 50 );
    addBall.setIdleColor(color(250,250,250));
    addBall.setButtonText("+");
    addBall.setDoubleSidedText(false);
    
    subtBar = new Button( 50, screenHeight - borderHeight/2 - 65*3 - 25, 50, 50 );
    subtBar.setIdleColor(color(250,250,250));
    subtBar.setButtonText("-");
    subtBar.setDoubleSidedText(false);
    addBar = new Button( 250, screenHeight - borderHeight/2 - 65*3 - 25, 50, 50 );
    addBar.setIdleColor(color(250,250,250));
    addBar.setButtonText("+");
    addBar.setDoubleSidedText(false);
    
    subtFriction = new Button( 50, screenHeight - borderHeight/2 - 65*2 - 25, 50, 50 );
    subtFriction.setIdleColor(color(250,250,250));
    subtFriction.setButtonText("-");
    subtFriction.setDoubleSidedText(false);
    addFriction = new Button( 250, screenHeight - borderHeight/2 - 65*2 - 25, 50, 50 );
    addFriction.setIdleColor(color(250,250,250));
    addFriction.setButtonText("+");
    addFriction.setDoubleSidedText(false);
    
    barWidthDown = new Button( 50, screenHeight - borderHeight/2 - 65*1 - 25, 50, 50 );
    barWidthDown.setIdleColor(color(250,250,250));
    barWidthDown.setButtonText("-");
    barWidthDown.setDoubleSidedText(false);
    barWidthDown.setDelay(0.1);
    barWidthUp = new Button( 250, screenHeight - borderHeight/2 - 65*1 - 25, 50, 50 );
    barWidthUp.setIdleColor(color(250,250,250));
    barWidthUp.setButtonText("+");
    barWidthUp.setDoubleSidedText(false);
    barWidthUp.setDelay(0.1);
    
} // loadGame

/*
 * Draw Method
 * 		Draw is a method that is repeatedly called by Processing.
 * 		Consequently, touches that occur over the network connection
 * 		are extracted and processed here.
 *   
 */
void draw() {
  //clear backgrd
  background( 10 , 60 , 10 );
  

  
  if( state == MAIN_MENU ){
    frameRate(60);
    
    //clear backgrd
    background( 0 , 0 , 0 );
        
    topButton0.process(font, timer_g);
    topButton1.process(font, timer_g);
    topButton2.process(font, timer_g);
    topButton3.process(font, timer_g);
    bottomButton0.process(font, timer_g);
    bottomButton1.process(font, timer_g);
    bottomButton2.process(font, timer_g);
    bottomButton3.process(font, timer_g);
    
    imageMode(CENTER);

    if(animate){
      fade = 1;
      if( pos < finalPos )
        pos++;
      else{
        bottomButton0.fadeEnable();
        topButton3.fadeEnable();
        if( bottomButton0.isDoneFading() ){
          topButton2.fadeEnable();
          bottomButton1.fadeEnable();
        }if( bottomButton1.isDoneFading() ){
          topButton1.fadeEnable();
          bottomButton2.fadeEnable();
        }if( bottomButton2.isDoneFading() ){
          topButton0.fadeEnable();
          bottomButton3.fadeEnable();
        }
      }
      image(ISE, width/2, height/2 + pos);
      pushMatrix();
      translate(width/2, height/2 - pos);
      rotate(radians(180));
      image(ISE, 0, 0 );
      popMatrix();  
    }else{
      image(infinity, width/2, height/2);
      if(fade >= 230)
        fadeIn = true;
      else if ( fade <= 1)
        fadeIn = false;
      if(fadeIn)
        fade--;
      else
        fade++;
    }
    imageMode(CORNERS);

    startButton.process(font, timer_g);
    startButton.setIdleColor(color(0,0,0,fade));   
  }// if main menu state


  else if( state == GAMEPLAY || state == PAUSE ){
    frameRate(30);
    imageMode(CORNERS);
    image(fieldImage, 0, 0);
    
    // Borders
    fill( 100 , 50 , 0 );
    noStroke();
    rect( borderWidth, 0, screenWidth-borderWidth*2, borderHeight ); // Top border
    rect( borderWidth, screenHeight-borderHeight, screenWidth-borderWidth*2, borderHeight ); // Bottom border
    rect( 0, borderHeight, borderWidth, screenHeight-borderHeight*2 ); // Left border
    rect( screenWidth-borderWidth, borderHeight, borderWidth, screenHeight-borderHeight*2 ); // Right border
    
  
    if( ballsInPlay != 0 && ballsInPlay <= nBalls )
      coinToss();
    if( ballsInPlay == 0)
      reloadBall();
      
    // Vertical Lines
    fill( 0 , 50 , 0 );
    noStroke();
    for( int x = 0 ; x < fieldLines ; x++ )
      rect( x*(screenWidth)/fieldLines, borderHeight, 2, screenHeight-borderHeight*2 );

    barManager.displayZones();
    

    
    particleManager.display();
    
    for( int i = 0; i < nBalls; i++ ){
      //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
      if( balls[i].isActive() && state == GAMEPLAY ){
        particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
        balls[i].process(timer_g);
        balls[i].setFriction(tableFriction);
      }
    }// for all balls
    
    leftGoal.collide(balls);
    rightGoal.collide(balls);
    
    barManager.process(balls, timer_g);
  
    leftGoal.display();
    bottomScore = leftGoal.scored();
      
    rightGoal.display();
    topScore = rightGoal.scored();
    
    imageMode(CORNER);
    image(borderImage, 0, 0);
    
    ballLauncher_bottom.process(timer_g);
    ballLauncher_top.process(timer_g);
    
    pauseButton_top.process(font, timer_g);
    pauseButton_bottom.process(font, timer_g);
 
    //Pause
    if( state == PAUSE ){
      fill( 0 , 0 , 0 , 150);
      stroke(0 , 0 , 0 , 150);
      rect( 0, 0, screenWidth, screenHeight );
      resumeButton.process(font, timer_g);
      resetButton.process(font, timer_g);
      quitButton.process(font, timer_g);
    }// if state == pause
  }// if state == gameplay
  
  
  else if( state == FOOSBAR ){
    imageMode(CORNER);
    bottomBack.process(font, timer_g);
    topBack.process(font, timer_g);

    fill( 0 , 50 , 0 );
    noStroke();
    rect( screenWidth/2, 0, 2, screenHeight );
    
    if( ballsInPlay != 0 && ballsInPlay <= nBalls )
      coinToss();
    if( ballsInPlay == 0)
      reloadBall();   
     
    testbar.displayZones();   
    testbar2.displayZones();   
    particleManager.display();
            
    for( int i = 0; i < nBalls; i++ ){
      //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
      if( balls[i].isActive() ){
        particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
        balls[i].process(timer_g);
        balls[i].setFriction(tableFriction);
      }
    }// for all balls
  
    testbar.display();
    testbar.collide(balls);
    testbar2.display();
    testbar2.collide(balls);

    ballLauncher_bottom.process(timer_g);
    ballLauncher_top.process(timer_g);
    
    testbar.displayDebug(debugColor, font);
    testbar2.displayDebug(debugColor, font);  
  }// else if( state == FOOSBAR )
  
  else if ( state == SOUNDTEST ){
    imageMode(CORNER);
    bottomBack.process(font, timer_g);
    topBack.process(font, timer_g);
    
    botSoundButton1.process(font, timer_g);
    botSoundButton2.process(font, timer_g);
    botSoundButton3.process(font, timer_g);
    botSoundButton4.process(font, timer_g);
    botSoundButton5.process(font, timer_g);
    
    topSoundButton1.process(font, timer_g);
    topSoundButton2.process(font, timer_g);
    topSoundButton3.process(font, timer_g);
    topSoundButton4.process(font, timer_g);
    topSoundButton5.process(font, timer_g);
    
    textAlign(CENTER);
    fill(color(0,0,0));
    textFont(font,32);
    text("SOUND TEST", width/2, height - 32);
    
    pushMatrix();
    translate(width/2, + 32);
    rotate(radians(180));
    text("SOUND TEST", 0, 0);
    popMatrix();
    textAlign(LEFT);
  }//else if ( state == SOUNDTEST )
   
  // Generic debug info
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
    text("Top (Blue) Score: "+topScore, 16, 16*10);
    text("Bottom (Red) Score: "+bottomScore, 16, 16*11);
    text("Last Scored (Top = 0, Bottom = 1): "+lastScored, 16, 16*12);
    if(  nBalls > 0 ){
      text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
      text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
      text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
      text("Ball 0 Angle: "+degrees(atan2(balls[0].yVel,balls[0].xVel)), 16, 16*9);
    }
    
    // Program specific debug info
    if(displayHitbox && state == GAMEPLAY )
      barManager.displayHitbox();

    if( debug2Text && state == GAMEPLAY ){
      barManager.displayDebug(debugColor, font);
      particleManager.displayDebug(debugColor, font);
      leftGoal.displayDebug(debugColor, font);
      rightGoal.displayDebug(debugColor, font);
      for( int i = 0; i < nBalls; i++ )
        balls[i].displayDebug(debugColor, font);
    }else if ( debug2Text && state == FOOSBAR ){
      testbar.displayHitbox();
      testbar2.displayHitbox();
      for( int i = 0; i < nBalls; i++ )
        balls[i].displayDebug(debugColor, font);      
    }
  }// if debugtext
  
  textAlign(LEFT);
  fill(debugColor);
  textFont(font,16);
  text(companyName, screenWidth - 280, screenHeight - 16*2);
  text(textLine2, screenWidth - 280, screenHeight - 16*1);
  
  if(!debugText){
    pushMatrix();
    translate(280, 40);
    rotate(radians(180));
    text(companyName, 0, 16*1);
    text(textLine2, 0 , 16*2);   
    popMatrix();
  }
  

  if( debugConsole || debugConsole2 ){ 
    // Debug Console
    rectMode(CORNER);
    
    // background
    fill(color(0,0,0, 150));
    stroke(color(0,0,0));
    rect(0, screenHeight - borderHeight/2 - 75*5, 450 , 500 );
    
    // Controls
    volumeDown.process(font, timer_g);
    textAlign(CENTER);
    fill(color(255,255,255));
    textFont(font,18);
    if( debugConsole ){
      text("Volume\n("+soundManager.getGain()+")", 175, screenHeight - borderHeight/2 - 65*5);
      muteButton.process(font, timer_g);
      muteButton.setLit( soundManager.isMuted() );      
    }else if( debugConsole2 )
      text("Bar Slide\n("+barManager.getBarSlideMultiplier()+")", 175, screenHeight - borderHeight/2 - 65*5);
    volumeUp.process(font, timer_g);

    
    applyChanges.process(font, timer_g);
    if( new_nBalls != nBalls || fieldLines != newFieldLines ){
      applyChanges.setButtonText("APPLY CHANGES\n (Requires Restart)");
      applyChanges.setLit( true );
    }else{
      applyChanges.setButtonText("");
      applyChanges.setLit( false );      
    }
    subtBall.process(font, timer_g);
    textAlign(CENTER);
    fill(color(255,255,255));
    textFont(font,18);
    if( debugConsole ){
      text("Balls\n("+new_nBalls+")", 175, screenHeight - borderHeight/2 - 65*4);
    }else if( debugConsole2 )
      text("Bar Rotation\n("+barManager.getBarRotateMultiplier()+")", 175, screenHeight - borderHeight/2 - 65*4);     
    addBall.process(font, timer_g);

    subtBar.process(font, timer_g);
    textAlign(CENTER);
    fill(color(255,255,255));
    textFont(font,18);
    if( debugConsole )
      text("Bars\n("+(newFieldLines - 1)+")", 175, screenHeight - borderHeight/2 - 65*3);
    else if( debugConsole2 )
      text("Bar Friction\n("+barManager.getBarFriction()+")", 175, screenHeight - borderHeight/2 - 65*3);
    addBar.process(font, timer_g);
    
    if( debugConsole){
    subtFriction.process(font, timer_g);
    textAlign(CENTER);
    fill(color(255,255,255));
    textFont(font,18);
    text("Friction\n("+tableFriction+")", 175, screenHeight - borderHeight/2 - 65*2);
    addFriction.process(font, timer_g);
    
    barWidthDown.process(font, timer_g);
    textAlign(CENTER);
    fill(color(255,255,255));
    textFont(font,18);
    text("Bar Width\n("+barWidth+")", 175, screenHeight - borderHeight/2 - 65*1);
    barWidthUp.process(font, timer_g);
    }
    debugTextButton.process(font, timer_g);
    debug2TextButton.process(font, timer_g);
    springButton.process(font, timer_g);
    turretButton.process(font, timer_g);
  }// if debugConsole
  debugButton.process(font, timer_g);
  debugButton.setLit( debugConsole || debugConsole2 );

  checkInput();
}// draw



void checkInput(){
  // Generic input code
  
  // Keyboard input
  if(keyPressed && usingMouse){
    if( key == 'b' || key == 'B' )
       balls[0].launchBall(mouseX, mouseY, 2, 0);
    else if( key == 'v' || key == 'V' )
       balls[0].launchBall(mouseX, mouseY, 0, 2);
    else if( key == 'n' || key == 'N' )
       balls[0].launchBall(mouseX, mouseY, 2, 2);
  }// if keypressed
  
  // Process mouse if clicked
  if(mousePressed && usingMouse){
	float xCoord = mouseX;    
	float yCoord = mouseY;
		
	//Draw mouse
        fill( #FF0000 );
	stroke( #FF0000 );
	ellipse( xCoord, yCoord, 20, 20 );

        // ANY CHANGES HERE MUST BE COPIED TO TOUCH ELSE-IF BELOW
        checkButtonHit(xCoord,yCoord, 1);
  }// if mousePressed
  else if( usingMouse && !connectToTacTile ){
    checkButtonHit(-100, -100, -1); // Allows for a "mouse release" trigger
  }// else if usingMouse
  
  //Process touches off the managedList if there are any touches.
  if ( ! tacTile.managedListIsEmpty()  ){
    // Grab the managedList
	touchList = tacTile.getManagedList();
    // Cycle though the touches 
	for ( int index = 0; index < touchList.size(); index ++ ){
		//Grab a touch
		Touches curTouch = (Touches) touchList.get(index);

		//Grab data
		float xCoord = curTouch.getXPos() * width;    
		float yCoord = height - curTouch.getYPos() * height;

  		//Get finger ID
		int finger = curTouch.getFinger();
		
		//Draw finger 
		fill( #FF0000 );
		stroke( #FF0000 );
		ellipse( xCoord, yCoord, 20, 20 );
                
                // ANY CHANGES HERE MUST BE COPIED TO MOUSE IF ABOVE
                checkButtonHit(xCoord, yCoord, finger);
	}// for touchList
  }// if touch
  else if(connectToTacTile){ 
    checkButtonHit(-100, -100, -1); // Allows for a "touch release" trigger
  }// if tacTileList empty else
  
  // Events that occur during every loop
  
  // Used to fix foosmen from getting stuck in wall
  for( int x = 0 ; x < fieldLines ; x++ ){
      barManager.reset();
  }
  testbar.reset();

  // Sets the color of debug buttons based on current debug state
  debugTextButton.setLit(debugText);
  debug2TextButton.setLit(debug2Text);
  springButton.setLit(debugConsole2);
  turretButton.setLit(ballLauncher_bottom.isShootOnRelease());
  
  timer_g = timer_g + timerIncrementer;
}// checkInput

void checkButtonHit(float x, float y, int finger){
  
  if( debugButton.isHit(x,y) ){
    if(debugConsole || debugConsole2){
      debugConsole = false;
      debugConsole2 = false;
    }else{
      new_nBalls = nBalls;
      newFieldLines = fieldLines;
      debugConsole = true;
    }
  }// debugButton
  
  
  if(debugConsole){
    
    if( volumeUp.isHit(x,y) ){
      soundManager.addGain();
    }// if volumeUp
    
    if( volumeDown.isHit(x,y) ){
      soundManager.subtractGain();
    }// if volumeDown
    
    if( muteButton.isHit(x,y) ){
      if( soundManager.isMuted() )
        soundManager.unmute();
      else
        soundManager.mute();
    }// if muteButton
    
    if( subtBall.isHit(x,y) ){
      if( new_nBalls > 0 )
        new_nBalls --;
    }// if subtBall
    
    if( addBall.isHit(x,y) ){
      if( new_nBalls >= 0 )
        new_nBalls ++;
    }// if addBall
    
    if( subtBar.isHit(x,y) ){
      if( newFieldLines > 1 )
        newFieldLines--;
    }// if subtBar
    
    if( addBar.isHit(x,y) ){
      if( newFieldLines >= 1 )
        newFieldLines++;
    }// if addBar 
    
    if( subtFriction.isHit(x,y) ){
      tableFriction -= 0.01;
    }// if subtFriction
    
    if( addFriction.isHit(x,y) ){
      tableFriction += 0.01;
    }// if addFriction 
    
    if( barWidthDown.isHit(x,y) ){
      barWidth--;
      barManager.setBarWidth(barWidth);
    }// if barWidthDown
    
    if( barWidthUp.isHit(x,y) ){
      barWidth++;
      barManager.setBarWidth(barWidth);
    }// if barWidthUp    
    
    if( applyChanges.isHit(x,y) ){
      state = MAIN_MENU;
      nBalls = new_nBalls;
      fieldLines = newFieldLines;
      loadGame();
      state = GAMEPLAY;
    }// if applyChanges
    
    if( debugTextButton.isHit(x,y) ){
      if(debugText){
        debugText = false;
      }else{
        debugText = true;
      }
    }// if debugTextButton
    
    if( debug2TextButton.isHit(x,y) ){
      if(debug2Text){
        debug2Text = false;
      }else{
        debug2Text = true;
      }
    }// if debug2TextButton
    
    /*
    if( springButton.isHit(x,y) ){
      if(barManager.isSpringEnabled()){
        barManager.setSpringEnabled(false);
      }else{
        barManager.setSpringEnabled(true);
      }
    }// if springButton
      */
    if( springButton.isHit(x,y) ){
      if( debugConsole ){
        debugConsole = false;
        debugConsole2 = true;
      }else{
        debugConsole = true;
        debugConsole2 = false;
      }
    }// if springButton
    
    if( turretButton.isHit(x,y) ){
      if(ballLauncher_bottom.isShootOnRelease()){
        ballLauncher_bottom.setShootOnRelease(false);
        ballLauncher_top.setShootOnRelease(false);
      }else{
        ballLauncher_bottom.setShootOnRelease(true);
        ballLauncher_top.setShootOnRelease(true);
      }
    }// if turretButton     
  }// if debugConsole is active
  else if( debugConsole2 ){
    
    if( turretButton.isHit(x,y) ){
      if(ballLauncher_bottom.isShootOnRelease()){
        ballLauncher_bottom.setShootOnRelease(false);
        ballLauncher_top.setShootOnRelease(false);
      }else{
        ballLauncher_bottom.setShootOnRelease(true);
        ballLauncher_top.setShootOnRelease(true);
      }
    }// if turretButton  
    
    if( debugTextButton.isHit(x,y) ){
      if(debugText){
        debugText = false;
      }else{
        debugText = true;
      }
    }// if debugTextButton
    
    if( debug2TextButton.isHit(x,y) ){
      if(debug2Text){
        debug2Text = false;
      }else{
        debug2Text = true;
      }
    }// if debug2TextButton
    
    if( springButton.isHit(x,y) ){
      if( debugConsole ){
        debugConsole = false;
        debugConsole2 = true;
      }else{
        debugConsole = true;
        debugConsole2 = false;
      }
    }// if springButton

    if( volumeUp.isHit(x,y) ){
      barManager.setBarSlideMultiplier(barManager.getBarSlideMultiplier() + 0.5 );
    }// if volumeUp
    
    if( volumeDown.isHit(x,y) ){
      barManager.setBarSlideMultiplier(barManager.getBarSlideMultiplier() - 0.5 );
    }// if volumeDown
    
    if( subtBall.isHit(x,y) ){
      barManager.setBarRotateMultiplier(barManager.getBarRotateMultiplier() - 0.5 );
    }// if subtBall
    
    if( addBall.isHit(x,y) ){
      barManager.setBarRotateMultiplier(barManager.getBarRotateMultiplier() + 0.5 );
    }// if addBall
    
    if( subtBar.isHit(x,y) ){
      barManager.setBarFriction(barManager.getBarFriction() - 0.05 );
    }// if subtBar
    
    if( addBar.isHit(x,y) ){
      barManager.setBarFriction(barManager.getBarFriction() + 0.05 );
    }// if addBar
    
  }// if debugConsole2 is active
  
  if( state == MAIN_MENU ){
    if(startButton.isHit(x,y)){
      if( animate ){
        animate = false;
        pos = 0;
        bottomButton0.fadeEnable();
        bottomButton0.setFadeOut();
        bottomButton1.fadeEnable();
        bottomButton1.setFadeOut();
        bottomButton2.fadeEnable();
        bottomButton2.setFadeOut();
        bottomButton3.fadeEnable();
        bottomButton3.setFadeOut();
        topButton0.fadeEnable();
        topButton0.setFadeOut();
        topButton1.fadeEnable();
        topButton1.setFadeOut();
        topButton2.fadeEnable();
        topButton2.setFadeOut();
        topButton3.fadeEnable();
        topButton3.setFadeOut();
      }else{
        bottomButton0.setFadeIn();
        bottomButton1.setFadeIn();
        bottomButton2.setFadeIn();
        bottomButton3.setFadeIn();
        topButton0.setFadeIn();
        topButton1.setFadeIn();
        topButton2.setFadeIn();
        topButton3.setFadeIn();
        animate = true;
      }
    }// if start button hit

    if( topButton0.isHit(x,y) || bottomButton3.isHit(x,y) )
      exit();
    
    if( topButton1.isHit(x,y) || bottomButton2.isHit(x,y) )
      state = FOOSBAR;
      
    if( topButton2.isHit(x,y) || bottomButton1.isHit(x,y) ){
      state = GAMEPLAY;
      soundManager.playGameplay();
    }
    if( topButton3.isHit(x,y) || bottomButton0.isHit(x,y) )
      state = SOUNDTEST; 
  }// else-if main menu state
  
  
  else if( state == PAUSE ){
    if(resumeButton.isHit(x,y))
      state = GAMEPLAY;
    if(resetButton.isHit(x,y))
      loadGame();
    if(quitButton.isHit(x,y))
      state = MAIN_MENU;
  }// else if pause state
  
  else if( state == GAMEPLAY ){
    
    // Ball
    for( int i = 0; i < nBalls; i++ ){
      balls[i].isHit(x,y);
    }// for nBalls
    
    // Buttons
    if( pauseButton_top.isHit(x,y) || pauseButton_bottom.isHit(x,y))
      state = PAUSE;
          
    barManager.barsPressed(x,y);
    ballLauncher_top.isHit(x,y);
    ballLauncher_top.rotateIsHit(x,y);
    ballLauncher_bottom.isHit(x,y);
    ballLauncher_bottom.rotateIsHit(x,y);
  }// else-if gameplay state
  
  else if( state == FOOSBAR ){
    testbar.isHit(x,y);
    testbar2.isHit(x,y);
    if( topBack.isHit(x,y) || bottomBack.isHit(x,y) )
      state = MAIN_MENU;
      
    // Ball
    for( int i = 0; i < nBalls; i++ ){
      balls[i].isHit(x,y);
    }// for nBalls     
    
    ballLauncher_top.isHit(x,y);
    ballLauncher_top.rotateIsHit(x,y);
    ballLauncher_bottom.isHit(x,y);
    ballLauncher_bottom.rotateIsHit(x,y);
  }//else if( state == FOOSBAR )
  
  else if( state == SOUNDTEST ){
    if( topBack.isHit(x,y) || bottomBack.isHit(x,y) ){
      state = MAIN_MENU;
      soundManager.stopSounds();
    }
    
    
    if( topSoundButton1.isHit(x,y) || botSoundButton5.isHit(x,y) ){
      //soundManager.stopSounds();
      soundManager.playPostgame();
    }else if( topSoundButton2.isHit(x,y) || botSoundButton4.isHit(x,y) ){
      //soundManager.stopSounds();
      soundManager.playGoal();
    }else if( topSoundButton3.isHit(x,y) || botSoundButton3.isHit(x,y) ){
      //soundManager.stopSounds();
      soundManager.playKick();
    }else if( topSoundButton4.isHit(x,y) || botSoundButton2.isHit(x,y) ){
      //soundManager.stopSounds();
      soundManager.playBounce();
    }else if( topSoundButton5.isHit(x,y) || botSoundButton1.isHit(x,y) ){
      //soundManager.stopSounds();
      soundManager.playGameplay();
    }
      
    
  }//else if( state == SOUNDTEST )
  
}// checkButtonHit

void reloadBall(){
  if( lastScored == 0 ){
    ballLauncher_bottom.enable();
  }else if( lastScored == 1 ){
    ballLauncher_top.enable();
  }
}// reloadBall

void coinToss(){
  coinToss = random(2);
  if( coinToss >= 1 )
    ballLauncher_bottom.enable();
  else if( coinToss < 1 )
    ballLauncher_top.enable();
    
  if( ballsInPlay == nBalls ){
    ballLauncher_top.disable();
    ballLauncher_bottom.disable();
  }
}// coinToss
