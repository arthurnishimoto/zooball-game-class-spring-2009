package ise.foosball;

import java.util.ArrayList;

import ise.game.GameState;
import ise.gameObjects.*;

import ise.utilities.Timer;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PFont;

import tacTile.net.TouchAPI;
import tacTile.net.Touches;


/**
 * Simple state for quickly testing new Processing code and intended to also test TouchAPI integration
 *
 * @author Arthur Nishimoto
 * @version 0.1
 */
public class FoosballPrototypeState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;

//Overall Program Flags
  String programName = "Zooball";
  float versionNo = 0.3f;

  boolean connectToTacTile = false;
  boolean usingMouse = true;
  boolean applet = false;
  boolean debugText = true;
  boolean debug2Text = false;

  int debugColor;

  int screenWidth;
  int screenHeight;

  //Touch API
  //TouchAPI tacTile;

  //List of Touches
  ArrayList touchList = new ArrayList();

  //Names of machines you might use
  String localMachine = "localhost";
  String tacTileMachine = "tactile.evl.uic.edu";

  //Port for data transfer
  int dataPort = 7000;
  int msgPort = 7340;

  //Generic Data Items
  double timer_g; // Required for button class
  PFont font;

  // Program Specific Code
  int state;
  final static int MAIN_MENU = 0;
  final static int PAUSE = 1;
  final static int GAMEPLAY = 2;

  int lastScored = -1;

  int borderWidth = 0;
  int borderHeight = 100;

  int[] screenDimentions = new int[4];

  float coinToss;
  int sliderMultiplier = 2;
  float tableFriction = 0.00f; // Default = 0.01
  int fieldLines = 5; // Divisions, not actual lines. 1 line appears on screen edge - should be odd #. Default = 9
  int nBars = fieldLines - 1;
  FoosbarManager barManager;
  ParticleManager particleManager;

  public int nBalls = 10;
  public int ballsInPlay = 0;
  public int ballQueue = 0;
  public Ball[] balls;

  Button resumeButton, resetButton, quitButton;

  // Bottom player
  int bottomScore = 0;
  public Turret ballLauncher_bottom;
  Button pauseButton_bottom;
  Button debugTextButton, debug2TextButton;

  // Top Player
  int topScore = 0;
  public Turret ballLauncher_top;
  Button pauseButton_top;

  Goal leftGoal, rightGoal;
  
/**
   * Creates a new FoosballPrototypeState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballPrototypeState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
    
    screenWidth = p.screen.width;
    screenHeight = p.screen.height;
    debugColor = p.color( 255, 255, 255 );
    font = p.loadFont("CourierNew36.vlw");
    
    if ( connectToTacTile ){
        //ALTERNATIVE: constructor to setup the connection on TacTile
        //tacTile = new TouchAPI( this );

        //size of the screen
        p.size( screenWidth, screenHeight, PConstants.OPENGL); // OPENGL on tacTile causes connect failure if placed after TouchAPI CTOR
        
        //Create connection to Touch Server
        //tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);
        
    } else {
        //ALTERNATIVE: constructor to setup the connection LOCALLY on your machine
        //tacTile = new TouchAPI( this, 7000);



        //size of the screen
        if(applet){
          screenWidth = 1280;
          screenHeight = 1024;
          p.size( 1280, 1024 ); // applet
        }else{
          // TacTile Resolution
          //screenWidth = 1920;
          //screenHeight = 1080;
          p.size( screenWidth, screenHeight, PConstants.OPENGL);
        }
        
        //Create connection to Touch Server
        //tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
    }

    screenDimentions[0] = screenWidth;
    screenDimentions[1] = screenHeight;
    screenDimentions[2] = borderWidth;
    screenDimentions[3] = borderHeight;
    
    //color of the background
    p.background( 10 , 60 , 10 );
    //timer_g = 0;
    state = GAMEPLAY; // Initial State
    
    //set frameRate
    p.frameRate(30); // Note tacTile generally runs at 16 FPS w/o OPENGL
    
    //load font  
    font = p.loadFont("CourierNew36.vlw"); 
    
    // Program specific setup:
    balls = new Ball[nBalls];
    timer_g = 0;
    ballsInPlay = 0;
    bottomScore = 0;
    topScore = 0;
    barManager = new FoosbarManager( fieldLines, 200, screenDimentions, balls, p );
    particleManager = new ParticleManager( 2000, 5, p );
    
    ballLauncher_bottom = new Turret( 75 , screenWidth/2 , screenHeight - 100, 150, 50, this);
    ballLauncher_bottom.faceUp();
    ballLauncher_top = new Turret( 75 , screenWidth/2 , 0 + 100, 150, 50, this);
    ballLauncher_top.faceDown();
    
    coinToss();
      
    pauseButton_bottom = new Button( 50, 50 , 0 + borderHeight/2);
    pauseButton_top = new Button( 50, screenWidth - 50, screenHeight - borderHeight/2);
    
    resumeButton = new Button( 100, screenWidth/4, screenHeight/2);
    resumeButton.setIdleColor(p.color(0,255,0));
    resumeButton.setButtonText("RESUME");
    
    resetButton = new Button( 100, 3*screenWidth/4, screenHeight/2);
    resetButton.setIdleColor(p.color(0,255,100));
    resetButton.setButtonText("RESET");
    
    quitButton = new Button( 100, screenWidth/2, screenHeight/2);
    quitButton.setIdleColor(p.color(0,100,100));
    quitButton.setButtonText("QUIT");

    leftGoal = new Goal( borderWidth, p.height/2, 100, 300 , 0, balls);
    rightGoal = new Goal( screenWidth-borderWidth-100, p.height/2, 100, 300 , 1, balls);
    
    debugTextButton = new Button( 50, screenWidth - 50, screenHeight - borderHeight/2 - 75*1 );
    debugTextButton.setIdleColor(p.color(0,50,50));
    
    debug2TextButton = new Button( 50, screenWidth - 50, screenHeight - borderHeight/2 - 75*2 );
    debug2TextButton.setIdleColor(p.color(0,50,50));
    
    for( int i = 0; i < nBalls; i++ ){
      // Syntax: Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr)
      //balls[i] = new Ball( width-borderWidth-50, height/2, 50, i, balls);
      balls[i] = new Ball( borderWidth+p.random(p.width-borderWidth-100), borderHeight+p.random(p.height+borderHeight), 50, i, balls, screenDimentions);
      balls[i].setFriction(tableFriction);
    }
    
  } // end FoosballPrototypeState()

  private void coinToss() {
	  coinToss = p.random(2);
	  if( coinToss >= 1 )
	    ballLauncher_bottom.enable();
	  else if( coinToss < 1 )
	    ballLauncher_top.enable();
	    
	  if( ballsInPlay == nBalls ){
	    ballLauncher_top.disable();
	    ballLauncher_bottom.disable();
	  }
}

/**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
	  //clear backgrd
	  p.background( 10 , 60 , 10 );

	  // Program Specific Code:
	  p.fill( 100 , 50 , 0 );
	  p.noStroke();
	  p.rect( borderWidth, 0, screenWidth-borderWidth*2, borderHeight ); // Top border
	  p.rect( borderWidth, screenHeight-borderHeight, screenWidth-borderWidth*2, borderHeight ); // Bottom border
	  p.rect( 0, borderHeight, borderWidth, screenHeight-borderHeight*2 ); // Left border
	  p.rect( screenWidth-borderWidth, borderHeight, borderWidth, screenHeight-borderHeight*2 ); // Right border

	  if( ballsInPlay != 0 && ballsInPlay <= nBalls )
	    coinToss();
	  if( ballsInPlay == 0)
	    reloadBall();
	  
	  ballLauncher_bottom.process(p, timer_g);
	  ballLauncher_top.process(p, timer_g);
	  
	  // Vertical Lines
	  p.fill( 0 , 50 , 0 );
	  p.noStroke();
	  for( int x = 0 ; x < fieldLines ; x++ ){
	    p.rect( x*(screenWidth)/fieldLines, borderHeight, 2, screenHeight-borderHeight*2 );
	  }
	  

	  barManager.displayZones(p);
	  particleManager.display();
	  
	  for( int i = 0; i < nBalls; i++ ){
	    //int effectDensity, float newDia, float xPos, float yPos, float xVel, float yVel, int colorFlag
	    if( balls[i].isActive() && state == GAMEPLAY ){
	      particleManager.trailParticles( 1, balls[i].diameter, balls[i].xPos, balls[i].yPos, 0, 0, 0 );
	      balls[i].process(p);
	    }
	  }// for all balls
	  
	  leftGoal.collide(balls);
	  rightGoal.collide(balls);
	  
	  barManager.process(p, balls, timer_g);

	  leftGoal.display(p);
	  if( leftGoal.scored() )
	    bottomScore ++;
	    
	  rightGoal.display(p);
	  if( rightGoal.scored() )
	    topScore ++;
	  
	  pauseButton_top.process(p, font, timer_g);
	  pauseButton_bottom.process(p, font, timer_g);
	  debugTextButton.process(p, font, timer_g);
	  debug2TextButton.process(p, font, timer_g);
	  
	  //Pause
	  if( state == PAUSE ){
	    p.fill( 0 , 0 , 0 , 150);
	    p.stroke(0 , 0 , 0 , 150);
	    p.rect( 0, 0, screenWidth, screenHeight );
	    resumeButton.process(p, font, timer_g);
	    resetButton.process(p, font, timer_g);
	    quitButton.process(p, font, timer_g);
	  }
	  
	  // Generic debug info
	  if(debugText){
	    p.textAlign(p.LEFT);
	    p.fill(debugColor);
	    p.textFont(font,16);
	    p.text("Resolution: "+p.width+" , "+p.height, 16, 16*1);  
	    p.text("MousePos: "+p.mouseX+" , "+p.mouseY, 16, 16*2);
	    p.text("Timer: "+timer_g, 16, 16*3);
	    p.text("FPS: "+p.frameRate, 16, 16*4);
	    p.text("Table Friction: "+tableFriction, 16, 16*5);
	    p.text("Top (Blue) Score: "+topScore, 16, 16*9);
	    p.text("Bottom (Red) Score: "+bottomScore, 16, 16*10);
	    p.text("Last Scored (Top = 0, Bottom = 1): "+lastScored, 16, 16*11);
	    if(  nBalls > 0 ){
	      p.text("Ball 0 Speed: "+balls[0].getSpeed(), 16, 16*6);
	      p.text("Ball 0 xVel: "+balls[0].xVel, 16, 16*7);
	      p.text("Ball 0 yVel: "+balls[0].yVel, 16, 16*8);
	    }
	    // Program specific debug info
	    if( state == GAMEPLAY && debug2Text){
	      barManager.displayDebug(debugColor, font);
	      particleManager.displayDebug(p, debugColor, font);
	      leftGoal.displayDebug(p, debugColor, font);
	      rightGoal.displayDebug(p, debugColor, font);
	      for( int i = 0; i < nBalls; i++ )
	        balls[i].displayDebug(p, game);
	    }
	  }// if debugtext
	  
	  p.fill(debugColor);
	  p.textFont(font,16);
	  p.text("Infinite State Entertainment", screenWidth - 280, screenHeight - 16*2);
	  p.text("'"+programName+"' Prototype v"+versionNo, screenWidth - 280, screenHeight - 16*1);
	  
	  
  } // end draw()

  private void reloadBall() {
	  if( lastScored == 0 ){
		    ballLauncher_bottom.enable();
		  }else if( lastScored == 1 ){
		    ballLauncher_top.enable();
		  }
}

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
  } // end init()

  /**
   * Temporally used to test TouchAPI integration.
   *
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( TouchAPI tacTile ) {
	  // Generic input code
	  // Process mouse if clicked
	  if(p.mousePressed && usingMouse){
		float xCoord = p.mouseX;    
		float yCoord = p.mouseY;
			
		//Draw mouse
	    p.fill( 0xffFF0000 );
		p.stroke( 0xffFF0000 );
		p.ellipse( xCoord, yCoord, 20, 20 );

	        // ANY CHANGES HERE MUST BE COPIED TO TOUCH ELSE-IF BELOW
	        checkButtonHit(xCoord,yCoord, 1);
	  }// if mousePressed
	  
	  //Process touches off the managedList if there are any touches.
	  else if ( ! tacTile.managedListIsEmpty()  ){
	    // Grab the managedList
		touchList = tacTile.getManagedList();
	    // Cycle though the touches 
		for ( int index = 0; index < touchList.size(); index ++ ){
			//Grab a touch
			Touches curTouch = (Touches) touchList.get(index);

			//Grab data
			float xCoord = curTouch.getXPos() * p.width;    
			float yCoord = p.height - curTouch.getYPos() * p.height;

	  		//Get finger ID
			int finger = curTouch.getFinger();
			
			//Draw finger 
			p.fill( 0xffFF0000 );
			p.stroke( 0xffFF0000 );
			p.ellipse( xCoord, yCoord, 20, 20 );
	                
	        // ANY CHANGES HERE MUST BE COPIED TO MOUSE IF ABOVE
	        checkButtonHit(xCoord, yCoord, finger);
		}// for touchList
	  } else {
	    checkButtonHit(-100,-100,-1);
	    // Reset objects based on timer_g
	    for( int x = 0 ; x < fieldLines ; x++ ){
	      barManager.reset();
	    }
	  ballLauncher_top.resetButton();
	  ballLauncher_bottom.resetButton();
	  }// if tacTileList empty else
	  
	  timer_g = timer_g + 0.048f;	  
  } // end input()

  private void checkButtonHit(float x, float y, int intensity) {
	  if( state == PAUSE ){
		    if(resumeButton.isHit(x,y))
		      state = GAMEPLAY;
		    //if(resetButton.isHit(x,y))
		    //  setup();
		    if(quitButton.isHit(x,y))
		      exit();
		  }else if( state == GAMEPLAY ){
		    
		    // Ball
		    for( int i = 0; i < nBalls; i++ ){
		      balls[i].isHit(x,y);
		    }// for nBalls
		    
		    // Buttons
		    if( pauseButton_top.isHit(x,y) || pauseButton_bottom.isHit(x,y))
		      state = PAUSE;
		    
		    if( debugTextButton.isHit(x,y) ){
		      if(debugText){
		        debugText = false;
		        debugTextButton.setIdleColor(p.color(0,50,50));
		      }else{
		        debugText = true;
		        debugTextButton.setIdleColor(p.color(0,250,250));
		      }
		    }
		    if( debug2TextButton.isHit(x,y) ){
		      if(debug2Text){
		        debug2Text = false;
		        debug2TextButton.setIdleColor(p.color(0,50,50));
		      }else{
		        debug2Text = true;
		        debug2TextButton.setIdleColor(p.color(0,250,250));
		      }
		    }
		    
		    barManager.barsPressed(x,y);
		    ballLauncher_top.isHit(x,y);
		    ballLauncher_top.rotateIsHit(x,y);
		    ballLauncher_bottom.isHit(x,y);
		    ballLauncher_bottom.rotateIsHit(x,y);
		  }
  }

/**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public String toString(  ) {
    return "Foosball Prototype State";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballPrototypeState
