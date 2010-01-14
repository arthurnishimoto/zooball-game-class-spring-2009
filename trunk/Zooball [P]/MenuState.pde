/**
 * Menu GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class MenuState extends GameState
{
  private Image selectTeam, selectField, aboutBackground, controlsBackground;
  private PImage dragonEnabled, dragonDisabled, tigerEnabled, tigerDisabled, greenGlowDisabled, greenGlowEnabled;
  private CircularButton zooballLogo, zooballLogo_dragon, zooballLogo_tiger, zooballLogo_start;
  private MTButton bottomDragon, bottomTiger, topDragon, topTiger;
  private MTButton topAbout, topTutorial, topQuit, topControls;
  private MTButton bottomAbout, bottomTutorial, bottomQuit, bottomControls;
  private MTButton bottomBack, topBack;
  private MTButton easyButton, normalButton, hardButton;
  
  private MTButton topFixedButton, topSpringButton, topRotateButton;
  private MTButton bottomFixedButton, bottomSpringButton, bottomRotateButton;
  
  private FoosbarManager FM;
  
  boolean topChosen = false;
  boolean bottomChosen = false;
  boolean topDragonTeam = false;
  boolean bottomDragonTeam = false;
  boolean topTigerTeam = false;
  boolean bottomTigerTeam = false;
  boolean playEnabled = false;
  
  boolean top_fixed_controls = false;
  boolean top_spring_controls = false;
  boolean top_rotate_controls = false;
  boolean bottom_fixed_controls = false;
  boolean bottom_spring_controls = false;
  boolean bottom_rotate_controls = false;
  
  final private static int MENU = 1;
  final private static int FIELD_SELECT = 2;
  final private static int ABOUT = 3;
  final private static int CONTROLS = 4;
  
  int state = MENU;
  double menuTransitionDelay;
  
  public MenuState( Game game ) {
    super( game );
  }// CTOR
  
  private float SCREEN_LEFT=0, SCREEN_RIGHT=1920, SCREEN_TOP=0, SCREEN_BOTTOM=1080,
    FIELD_LEFT=SCREEN_LEFT+100, FIELD_RIGHT=SCREEN_RIGHT-100, FIELD_TOP=SCREEN_TOP+100, FIELD_BOTTOM=SCREEN_BOTTOM-100;
  private Line[] horzWalls;
  private long lastUpdate = 0; // physics time in microseconds
    
  public void load( ) {
    lastUpdate = 0;
    horzWalls = new Line[6];
    // top and bottom of field
    horzWalls[0] = new Line( FIELD_LEFT, FIELD_TOP, FIELD_RIGHT, FIELD_TOP );
    horzWalls[1] = new Line( FIELD_LEFT, FIELD_BOTTOM, FIELD_RIGHT, FIELD_BOTTOM );
    
    dragonEnabled = loadImage("data/ui/buttons/dragons/enabled.png");
    dragonDisabled = loadImage("data/ui/buttons/dragons/disabled.png");
    tigerEnabled = loadImage("data/ui/buttons/tigers/enabled.png");
    tigerDisabled = loadImage("data/ui/buttons/tigers/disabled.png");
    greenGlowDisabled = loadImage("data/ui/buttons/greenGlow/disabled.png");
    greenGlowEnabled = loadImage("data/ui/buttons/greenGlow/enabled.png");
    
    screenDimensions[0] = (int)game.getWidth( );
    screenDimensions[1] = (int)game.getHeight( );
    screenDimensions[2] = borderWidth;
    screenDimensions[3] = borderHeight;
    
    FM = new FoosbarManager( 5, barWidth, screenDimensions, balls, red_foosmanImages, yellow_foosmanImages);

    selectTeam = new Image("data/ui/text/selectTeam.png");
    selectField = new Image("data/ui/text/selectPlayMode.png");
    aboutBackground = new Image("data/ui/logos/about2.png");
    controlsBackground = new Image("data/ui/logos/controls.png");
    
    zooballLogo = new CircularButton("data/ui/logos/zooball.png");
    zooballLogo.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo.setRadius( 393/2 );
    
    zooballLogo_dragon = new CircularButton("data/ui/logos/zooball_dragons.png");
    zooballLogo_dragon.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo_dragon.setRadius( 393/2 );
    
    zooballLogo_tiger = new CircularButton("data/ui/logos/zooball_tigers.png");
    zooballLogo_tiger.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo_tiger.setRadius( 393/2 );
    
    zooballLogo_start = new CircularButton("data/ui/logos/zooball_ready.png");
    zooballLogo_start.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo_start.setRadius( 393/2 );  
    
    bottomDragon = new MTButton( game.parent, 50 + 469, (int)game.getHeight() - 100, dragonDisabled );
    bottomDragon.setLitImage( dragonEnabled );
    bottomDragon.setDelay(1);
    bottomTiger = new MTButton( game.parent, (int)game.getWidth() - 50 - 469, (int)game.getHeight() - 100, tigerDisabled );
    bottomTiger.setLitImage( tigerEnabled );
    bottomTiger.setDelay(1);
    
    topDragon = new MTButton( game.parent, (int)game.getWidth() - 50 - 469, 100,  dragonDisabled );
    topDragon.setLitImage( dragonEnabled );
    topDragon.setRotation( PI );
    topDragon.setDelay(1);
    topTiger = new MTButton( game.parent, 50 + 469, 100,  tigerDisabled );
    topTiger.setLitImage( tigerEnabled );
    topTiger.setRotation( PI );
    topTiger.setDelay(1);
    
    bottomAbout = new MTButton( game.parent, (int)game.getWidth()/2 - 200 , (int)game.getHeight() - 250,  greenGlowEnabled );
    bottomAbout.setButtonText("About");
    bottomAbout.setDoubleSidedText(false);
    topAbout = new MTButton( game.parent, (int)game.getWidth()/2 + 200 , 250,  greenGlowEnabled );
    topAbout.setButtonText("About");
    topAbout.setDoubleSidedText(false);
    topAbout.setRotation(PI);
    
    bottomTutorial = new MTButton( game.parent, (int)game.getWidth()/2 + 000, (int)game.getHeight() - 250,  greenGlowEnabled );
    bottomTutorial.setButtonText("Tutorial");
    bottomTutorial.setDoubleSidedText(false);
    topTutorial = new MTButton( game.parent, (int)game.getWidth()/2 - 000, 250,  greenGlowEnabled );
    topTutorial.setButtonText("Tutorial");
    topTutorial.setDoubleSidedText(false);
    topTutorial.setRotation(PI);

    bottomQuit = new MTButton( game.parent, (int)game.getWidth()/2 + 200, (int)game.getHeight() - 250,  greenGlowEnabled );
    bottomQuit.setButtonText("Quit");
    bottomQuit.setDoubleSidedText(false);
    topQuit = new MTButton( game.parent, (int)game.getWidth()/2 - 200, 250,  greenGlowEnabled );
    topQuit.setButtonText("Quit");
    topQuit.setDoubleSidedText(false);
    topQuit.setRotation(PI);
    
    bottomBack = new MTButton( game.parent, (int)game.getWidth() - 100, (int)game.getHeight() - 70,  greenGlowEnabled );
    bottomBack.setButtonText("Back");
    bottomBack.setDoubleSidedText(false);
    topBack = new MTButton( game.parent, 100,  70,  greenGlowEnabled );
    topBack.setButtonText("Back");
    topBack.setDoubleSidedText(false);
    topBack.setRotation(PI);
    
    bottomControls = new MTButton( game.parent, (int)game.getWidth() - 100, (int)game.getHeight() - 70, greenGlowEnabled );
    bottomControls.setButtonText("Controls");
    bottomControls.setDoubleSidedText(false);
    topControls = new MTButton( game.parent, 100,  70, greenGlowEnabled );
    topControls.setButtonText("Controls");
    topControls.setDoubleSidedText(false);
    topControls.setRotation(PI);
    
    easyButton = new MTButton( game.parent, (int)game.getWidth()/2 - 500, (int)game.getHeight()/2,  loadImage("data/ui/buttons/easy_field.png") );
    normalButton = new MTButton( game.parent, (int)game.getWidth()/2, (int)game.getHeight()/2,  loadImage("data/ui/buttons/normal_field.png") );
    hardButton = new MTButton( game.parent, (int)game.getWidth()/2 + 500, (int)game.getHeight()/2,  loadImage("data/ui/buttons/hard_field.png") );
    
    bottomFixedButton = new MTButton( game.parent, (int)game.getWidth()/2 - 200 , (int)game.getHeight() - 150,  greenGlowDisabled );
    bottomFixedButton.setLitImage( greenGlowEnabled );
    bottomFixedButton.setButtonText("Fixed");
    bottomFixedButton.setDoubleSidedText(false);
    
    bottomSpringButton = new MTButton( game.parent, (int)game.getWidth()/2 - 000 , (int)game.getHeight() - 150,  greenGlowDisabled );
    bottomSpringButton.setLitImage( greenGlowEnabled );
    bottomSpringButton.setButtonText("Spring");
    bottomSpringButton.setDoubleSidedText(false);
    
    bottomRotateButton = new MTButton( game.parent, (int)game.getWidth()/2 + 200 , (int)game.getHeight() - 150,  greenGlowDisabled );
    bottomRotateButton.setLitImage( greenGlowEnabled );
    bottomRotateButton.setButtonText("Full Rotate");
    bottomRotateButton.setDoubleSidedText(false);
    
    topFixedButton = new MTButton( game.parent, (int)game.getWidth()/2 + 200 , 150,  greenGlowDisabled );
    topFixedButton.setLitImage( greenGlowEnabled );
    topFixedButton.setButtonText("Fixed");
    topFixedButton.setDoubleSidedText(false);
    topFixedButton.setRotation(PI);
    
    topSpringButton = new MTButton( game.parent, (int)game.getWidth()/2 - 000 , 150,  greenGlowDisabled );
    topSpringButton.setLitImage( greenGlowEnabled );
    topSpringButton.setButtonText("Spring");
    topSpringButton.setDoubleSidedText(false);
    topSpringButton.setRotation(PI);
    
    topRotateButton = new MTButton( game.parent, (int)game.getWidth()/2 - 200 , 150,  greenGlowDisabled );
    topRotateButton.setLitImage( greenGlowEnabled );
    topRotateButton.setButtonText("Full Rotate");
    topRotateButton.setDoubleSidedText(false);
    topRotateButton.setRotation(PI);
    endLoad( );
  }// load
  
  public void enter( ) {
    demoMode = false;
    playbackMouse = false;
    playbackItr = 0;
    timer.setActive( true );
    soundManager.playJungle();
    state = MENU;
    //state = CONTROLS;
  }// enter
  
  public void update( ) {
    super.update( ); // update PlayState timer
    long time = timer.getMicrosecondsActive( ); // get current game time
    // step until physics time is caught with up or past current game time
    while ( lastUpdate < time ) {
      // The chosen step size means that the physics is updated 200 times/second,
      // or about 3.333 times/frame when running at 60 frames/second. This size can
      // be lowered to prevent tunneling (objects passing through each other, before
      // collision can be detected) or raised if performance is an issue (but it isn't).
      //step( 0.005 ); // step physics objects forward by 0.005 seconds and handle collisions
      if(state == CONTROLS){
        FM.step( 0.005 );
        FM.collide( horzWalls );
      }
      lastUpdate += 5000; // update physics time by the equivalent 5000 microseconds
    }

  }// update
  
  public void draw( ) {
    drawBackground( );
    switch(state){
      case(MENU):
        drawMenuButtons();
        break;
      case(FIELD_SELECT):
        drawFieldSelect();
        break;
      case(ABOUT):
        drawAbout();
        break;
      case(CONTROLS):
        drawControls();
        break;
      default:
        println("Warning: Unknown sub-state "+state+"called in MenuState.");
        break;
    }// switch

    drawDebugText( );
  }// draw
  
  private void drawBackground( ) {
    background( 0 );
    //fill( 0x00, 0x33, 0x66 ); // blue
    fill( 250, 161, 36 ); // 
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }// drawBackground
  
  private void drawFieldSelect(){
    selectField.draw();
    bottomBack.process(font, timer.getSecondsActive());
    topBack.process(font, timer.getSecondsActive()); 
    easyButton.process(font, timer.getSecondsActive());
    normalButton.process(font, timer.getSecondsActive());
    hardButton.process(font, timer.getSecondsActive());
  }// drawFieldSelect
  
  private void drawAbout(){
    aboutBackground.draw();
    bottomBack.process(font, timer.getSecondsActive());
    topBack.process(font, timer.getSecondsActive());
  }// drawAboutButtons
  
  private void drawControls(){
    bottomFixedButton.setLit(bottom_fixed_controls);
    bottomSpringButton.setLit(bottom_spring_controls);
    bottomRotateButton.setLit(bottom_rotate_controls);
    
    topFixedButton.setLit(top_fixed_controls);
    topSpringButton.setLit(top_spring_controls);
    topRotateButton.setLit(top_rotate_controls);
    
    
    if( top_fixed_controls && bottom_fixed_controls ){
      zooballLogo_start.draw();
    }else if( top_spring_controls && bottom_spring_controls ){
      zooballLogo_start.draw();
    }else if( top_rotate_controls && bottom_rotate_controls ){
      zooballLogo_start.draw();
    }else{
      zooballLogo.draw();
    }
    
    bottomBack.process(font, timer.getSecondsActive());
    topBack.process(font, timer.getSecondsActive());

    FM.process(null, timer.getSecondsActive(), this);
    FM.displayZones();
    //FM.displayDebug(color(0,0,0), font);
    FM.display();
    
    bottomFixedButton.process(font, timer.getSecondsActive());
    bottomSpringButton.process(font, timer.getSecondsActive());
    bottomRotateButton.process(font, timer.getSecondsActive());
    
    topFixedButton.process(font, timer.getSecondsActive());
    topSpringButton.process(font, timer.getSecondsActive());
    topRotateButton.process(font, timer.getSecondsActive());
    
    pushMatrix();
    translate( game.getWidth()/2, game.getHeight()/2 );
    
    drawControlTextBox( 1 );
    
    rotate(PI);
    
    drawControlTextBox( 0 );
    
    popMatrix();
    controlsBackground.draw();
  }// drawAboutButtons
  
  private void drawControlTextBox(int pos){
    fill(0,0,0, 150);
    rect( 0-820, 250, 500, 200 );
    
    textFont(font,18);
    //fill(255,255,255);
    fill(50,255,50);
    noStroke();
    
    if( pos == 1 ){
      if( bottom_fixed_controls )
        text( "Fixed Control Mode: \nSlide the foosbar up and down. No rotation control." , 0 - 800, 250 + 30 );
      else if( bottom_spring_controls )
        text( "Spring Control Mode: \nTouch left/right touch zone to spring back.\nRelease to rotate forward." , 0 - 800, 250 + 30 );
      else if( bottom_rotate_controls )
        text( "Rotate Control Mode: \nTouch left/right to rotate foosbar.\nCatch balls by holding back slightly. (See tutorial)" , 0 - 800, 250 + 30 );
      else
        text( "Select a control mode." , 0 - 800, 250 + 30 );
        
      text( "Try out the control mode by pressing on the touch\nbox on you side of the table." , 0 - 800, 250 + 160 ); 
    }else if( pos == 0 ){
      if( top_fixed_controls )
        text( "Fixed Control Mode: \nSlide the foosbar up and down. No rotation control." , 0 - 800, 250 + 30 );
      else if( top_spring_controls )
        text( "Spring Control Mode: \nTouch left/right touch zone to spring back.\nRelease to rotate forward.\nCatch balls by holding back." , 0 - 800, 250 + 30 );
      else if( top_rotate_controls )
        text( "Rotate Control Mode: \nTouch left/right to rotate foosbar.\nCatch balls by holding back slightly. (See tutorial)" , 0 - 800, 250 + 30 );
      else
        text( "Select a control mode." , 0 - 800, 250 + 30 );
        
      text( "Try out the control mode by pressing on the touch\nbox on you side of the table." , 0 - 800, 250 + 160 ); 
    }// if-else
    

  }// drawControlTextBoxes
  
  private void drawMenuButtons(){
    selectTeam.draw();
    bottomAbout.process(font, timer.getSecondsActive());
    bottomTutorial.process(font, timer.getSecondsActive());
    bottomQuit.process(font, timer.getSecondsActive());
    //bottomControls.process(font, timer.getSecondsActive());
    
    topAbout.process(font, timer.getSecondsActive());
    topTutorial.process(font, timer.getSecondsActive());
    topQuit.process(font, timer.getSecondsActive());
    //topControls.process(font, timer.getSecondsActive());
    
    bottomTiger.process(font, timer.getSecondsActive());
    bottomTiger.setLit( (bottomChosen && bottomTigerTeam) );
    bottomDragon.process(font, timer.getSecondsActive());
    bottomDragon.setLit( (bottomChosen && bottomDragonTeam) );
    
    topTiger.process(font, timer.getSecondsActive());
    topTiger.setLit( (topChosen && topTigerTeam) );
    topDragon.process(font, timer.getSecondsActive());
    topDragon.setLit( (topChosen && topDragonTeam) );
    
    if( bottomDragonTeam && topTigerTeam ){
      zooballLogo_start.draw();
      redTeamTop = false;
      playEnabled = true;
    }
    else if( topDragonTeam && bottomTigerTeam ){
      zooballLogo_start.draw();
      redTeamTop = true;
      playEnabled = true;
    } 
    
    else if( bottomTigerTeam || topTigerTeam ){
      zooballLogo_tiger.draw();
      playEnabled = false;
    }else if( bottomDragonTeam || topDragonTeam ){
      zooballLogo_dragon.draw();
      playEnabled = false;
    }else{
      zooballLogo.draw();
      playEnabled = false;
    }
    
  }// drawButtons
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }// drawDebugText
  
  public String toString( ) { return "MenuState"; }
  
  public void checkButtonHit(float x, float y, int finger){
    switch(state){
      case(MENU):
        if( zooballLogo.contains(x,y) && playEnabled ){
          FM = new FoosbarManager( 5, barWidth, screenDimensions, balls, red_foosmanImages, yellow_foosmanImages);
          state = CONTROLS;
          menuTransitionDelay = timer.getSecondsActive() + 2;
          //game.reloadState( game.getPlayState() );
          //game.setState( game.getPlayState() );
        }
        if( bottomDragon.isHit(x,y) ){
          bottomChosen = true;
          bottomDragonTeam = true;
          bottomTigerTeam = false;
          soundManager.playFire();
        }if( bottomTiger.isHit(x,y) ){
          bottomChosen = true;
          bottomDragonTeam = false;
          bottomTigerTeam = true;
          soundManager.playTiger();
        }
        if( topDragon.isHit(x,y) ){
          topChosen = true;
          topTigerTeam = false;
          topDragonTeam = true;
          soundManager.playFire();
        }if( topTiger.isHit(x,y) ){
          topChosen = true;
          topTigerTeam = true;
          topDragonTeam = false;
          soundManager.playTiger();
        }
        if( topAbout.isHit(x,y) || bottomAbout.isHit(x,y) ){
          state = ABOUT;
        }
        if( topQuit.isHit(x,y) || bottomQuit.isHit(x,y) ){
          game.setState( game.getLeavingState() );
        }
        if( topTutorial.isHit(x,y) || bottomTutorial.isHit(x,y) ){
          demoMode = true;
          game.reloadState( game.getPlayState() );
          game.setState( game.getPlayState() );
        }        
        break;
      case(ABOUT):
        if( topBack.isHit(x,y) || bottomBack.isHit(x,y) )
          state = MENU;
        break;
      case(FIELD_SELECT):
        if( topBack.isHit(x,y) || bottomBack.isHit(x,y) )
          state = CONTROLS;
        if( easyButton.isHit(x,y) && menuTransitionDelay < timer.getSecondsActive() ){
          FIELD_MODE = 1;
          demoMode = false;
          game.reloadState( game.getPlayState() );
          game.setState( game.getPlayState() );
        }
        if( normalButton.isHit(x,y) && menuTransitionDelay < timer.getSecondsActive() ){
          FIELD_MODE = 2;
          demoMode = false;
          game.reloadState( game.getPlayState() );
          game.setState( game.getPlayState() );
        }
        if( hardButton.isHit(x,y) && menuTransitionDelay < timer.getSecondsActive() ){
          FIELD_MODE = 3;
          demoMode = false;
          game.reloadState( game.getPlayState() );
          game.setState( game.getPlayState() );
        }
        break;
      case(CONTROLS):
        if( topBack.isHit(x,y) || bottomBack.isHit(x,y) )
          state = MENU;
        
        if( bottom_fixed_controls ){
          FM.setBottomSpringEnabled(false);
          FM.setBottomRotationEnabled(false);
        }else if( bottom_spring_controls){
          FM.setBottomSpringEnabled(true);
          FM.setBottomRotationEnabled(false);         
        }else if( bottom_rotate_controls){
          FM.setBottomSpringEnabled(false);
          FM.setBottomRotationEnabled(true);
        }
        
        if( top_fixed_controls ){
          FM.setTopSpringEnabled(false);
          FM.setTopRotationEnabled(false);
        }else if( top_spring_controls){
          FM.setTopSpringEnabled(true);
          FM.setTopRotationEnabled(false);         
        }else if( top_rotate_controls){
          FM.setTopSpringEnabled(false);
          FM.setTopRotationEnabled(true);
        }
        
        if( bottomFixedButton.isHit(x,y) ){
          bottom_fixed_controls = true;
          bottom_spring_controls = false;
          bottom_rotate_controls = false;

        }
        if( bottomSpringButton.isHit(x,y) ){
          bottom_fixed_controls = false;
          bottom_spring_controls = true;
          bottom_rotate_controls = false;
        }
        if( bottomRotateButton.isHit(x,y) ){
          bottom_fixed_controls = false;
          bottom_spring_controls = false;
          bottom_rotate_controls = true;
        }
        
        if( topFixedButton.isHit(x,y) ){
          top_fixed_controls = true;
          top_spring_controls = false;
          top_rotate_controls = false;
          FM.setTopSpringEnabled(false);
          FM.setTopRotationEnabled(false);
        }
        if( topSpringButton.isHit(x,y) ){
          top_fixed_controls = false;
          top_spring_controls = true;
          top_rotate_controls = false;
          FM.setTopRotationEnabled(false);
          FM.setTopSpringEnabled(true);
        }
        if( topRotateButton.isHit(x,y) ){
          top_fixed_controls = false;
          top_spring_controls = false;
          top_rotate_controls = true;
          FM.setTopSpringEnabled(false);
          FM.setTopRotationEnabled(true);
        }
        
        if( top_fixed_controls && bottom_fixed_controls ){
          if( zooballLogo_start.contains(x,y)  && menuTransitionDelay < timer.getSecondsActive() ){
            menuTransitionDelay = timer.getSecondsActive() + 2;
            state = FIELD_SELECT;
          }
          springMode = false;
          rotateMode = false;
        }else if( top_spring_controls && bottom_spring_controls ){
          if( zooballLogo_start.contains(x,y)  && menuTransitionDelay < timer.getSecondsActive() ){
            state = FIELD_SELECT;
            menuTransitionDelay = timer.getSecondsActive() + 2;
          }
          springMode = true;
          rotateMode = false;
        }else if( top_rotate_controls && bottom_rotate_controls ){
          if( zooballLogo_start.contains(x,y)  && menuTransitionDelay < timer.getSecondsActive() ){
            state = FIELD_SELECT;
            menuTransitionDelay = timer.getSecondsActive() + 2;
          }
          springMode = false;
          rotateMode = true;
        }
        
        ArrayList touchList = tacTile.getManagedList();
        if( mousePressed ){
          float xCoordm = (mouseX + screenOffsetX) / screenScale;
          float yCoordm = (mouseY - screenOffsetY) / screenScale;
          xCoordm = xCoordm/width;
          yCoordm = (height - yCoordm)/height;

          // Adds  a "mouse touch" to the touchList
          touchList.add( new Touches( 0, 0, xCoordm, yCoordm, 1.0 ) );
        
        } else {
          FM.barsPressed(-100,-100);
          FM.sendTouchList(null, true);
        }
        
        if(connectToTacTile)
          FM.sendTouchList( touchList, false );
        
        
        break;
    }// switch
  }// checkButtonHit
  
}// class MenuState
