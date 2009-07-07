/**
 * Menu GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class MenuState extends GameState
{
  private Image selectTeam, selectField, aboutBackground, controlsBackground;
  private CircularButton zooballLogo, zooballLogo_dragon, zooballLogo_tiger, zooballLogo_start;
  private MTButton bottomDragon, bottomTiger, topDragon, topTiger;
  private MTButton topAbout, topTutorial, topQuit, topControls;
  private MTButton bottomAbout, bottomTutorial, bottomQuit, bottomControls;
  private MTButton bottomBack, topBack;
  private MTButton easyButton, normalButton, hardButton;
  
  private FoosbarManager FM;
  
  boolean topChosen = false;
  boolean bottomChosen = false;
  boolean topDragonTeam = false;
  boolean bottomDragonTeam = false;
  boolean topTigerTeam = false;
  boolean bottomTigerTeam = false;
  boolean playEnabled = false;
  
  final private static int MENU = 1;
  final private static int FIELD_SELECT = 2;
  final private static int ABOUT = 3;
  final private static int CONTROLS = 4;
  
  int state = MENU;
  double menuTransitionDelay;
  
  public MenuState( Game game ) {
    super( game );
  }// CTOR
  
  public void load( ) {
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
    
    bottomDragon = new MTButton( game.parent, 50 + 469, (int)game.getHeight() - 100, loadImage("data/ui/buttons/dragons/disabled.png") );
    bottomDragon.setLitImage( loadImage("data/ui/buttons/dragons/enabled.png") );
    bottomDragon.setDelay(1);
    bottomTiger = new MTButton( game.parent, (int)game.getWidth() - 50 - 469, (int)game.getHeight() - 100, loadImage("data/ui/buttons/tigers/disabled.png") );
    bottomTiger.setLitImage( loadImage("data/ui/buttons/tigers/enabled.png") );
    bottomTiger.setDelay(1);
    
    topDragon = new MTButton( game.parent, (int)game.getWidth() - 50 - 469, 100,  loadImage("data/ui/buttons/dragons/disabled.png") );
    topDragon.setLitImage( loadImage("data/ui/buttons/dragons/enabled.png") );
    topDragon.setRotation( PI );
    topDragon.setDelay(1);
    topTiger = new MTButton( game.parent, 50 + 469, 100,  loadImage("data/ui/buttons/tigers/disabled.png") );
    topTiger.setLitImage( loadImage("data/ui/buttons/tigers/enabled.png") );
    topTiger.setRotation( PI );
    topTiger.setDelay(1);
    
    bottomAbout = new MTButton( game.parent, (int)game.getWidth()/2 - 200 , (int)game.getHeight() - 250,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    bottomAbout.setButtonText("About");
    bottomAbout.setDoubleSidedText(false);
    topAbout = new MTButton( game.parent, (int)game.getWidth()/2 + 200 , 250,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    topAbout.setButtonText("About");
    topAbout.setDoubleSidedText(false);
    topAbout.setRotation(PI);
    
    bottomTutorial = new MTButton( game.parent, (int)game.getWidth()/2 + 000, (int)game.getHeight() - 250,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    bottomTutorial.setButtonText("Tutorial");
    bottomTutorial.setDoubleSidedText(false);
    topTutorial = new MTButton( game.parent, (int)game.getWidth()/2 - 000, 250,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    topTutorial.setButtonText("Tutorial");
    topTutorial.setDoubleSidedText(false);
    topTutorial.setRotation(PI);

    bottomQuit = new MTButton( game.parent, (int)game.getWidth()/2 + 200, (int)game.getHeight() - 250,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    bottomQuit.setButtonText("Quit");
    bottomQuit.setDoubleSidedText(false);
    topQuit = new MTButton( game.parent, (int)game.getWidth()/2 - 200, 250,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    topQuit.setButtonText("Quit");
    topQuit.setDoubleSidedText(false);
    topQuit.setRotation(PI);
    
    bottomBack = new MTButton( game.parent, (int)game.getWidth() - 100, (int)game.getHeight() - 70,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    bottomBack.setButtonText("Back");
    bottomBack.setDoubleSidedText(false);
    topBack = new MTButton( game.parent, 100,  70,  loadImage("data/ui/buttons/greenGlow/enabled.png") );
    topBack.setButtonText("Back");
    topBack.setDoubleSidedText(false);
    topBack.setRotation(PI);
    
    bottomControls = new MTButton( game.parent, (int)game.getWidth() - 100, (int)game.getHeight() - 70, loadImage("data/ui/buttons/greenGlow/enabled.png"));
    bottomControls.setButtonText("Controls");
    bottomControls.setDoubleSidedText(false);
    topControls = new MTButton( game.parent, 100,  70, loadImage("data/ui/buttons/greenGlow/enabled.png"));
    topControls.setButtonText("Controls");
    topControls.setDoubleSidedText(false);
    topControls.setRotation(PI);
    
    easyButton = new MTButton( game.parent, (int)game.getWidth()/2 - 500, (int)game.getHeight()/2,  loadImage("data/ui/buttons/easy_field.png") );
    normalButton = new MTButton( game.parent, (int)game.getWidth()/2, (int)game.getHeight()/2,  loadImage("data/ui/buttons/normal_field.png") );
    hardButton = new MTButton( game.parent, (int)game.getWidth()/2 + 500, (int)game.getHeight()/2,  loadImage("data/ui/buttons/hard_field.png") );
    
    endLoad( );
  }// load
  
  public void enter( ) {
    demoMode = false;
    playbackMouse = false;
    playbackItr = 0;
    timer.setActive( true );
    soundManager.playJungle();
    state = MENU;
  }// enter
  
  public void update( ) {
    super.update( );
    //if ( timer.getSecondsActive( ) > 5.0 )
    //  game.setState( game.getPlayState( ) );
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
    
    bottomBack.process(font, timer.getSecondsActive());
    topBack.process(font, timer.getSecondsActive());
    FM.displayZones();    
    FM.display();
    controlsBackground.draw();
  }// drawAboutButtons
  
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
          state = MENU;
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

        break;
    }// switch
  }// checkButtonHit
  
}// class MenuState
