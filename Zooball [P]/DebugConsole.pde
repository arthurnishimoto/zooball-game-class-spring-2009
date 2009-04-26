/**
 * DebugConsole.pde
 *
 * By Arthur Nishimoto
 *
 * Version 2.0 (4/23/09)
 *
 * A debugging console that sits within the game class above all classes.
 * Divided into panels.
 * Panel 1 - Volume, # of balls/bars, Friction, Max ball speed, Turret fire mode, dubug text
 * panel 2 - (Foosbar Controls) Slide, rotation, friction, stoping angles, Bar control modes (fixed, spring, 360)
 *
 */
class DebugConsole{
  Button debugButton;
  
  Button muteButton;
  Button applyChanges;
  
  Button plus1, minus1;
  Button plus2, minus2;
  Button plus3, minus3;
  Button plus4, minus4;
  Button plus5, minus5;
  
  Button round1, round2, round3, round4;
  
  Boolean debugConsole = false;
  Boolean debugPanel2 = false;
  int screenHeight = screen.height;
  int new_nBalls, newFieldLines;
  float timerIncrementer = 0.015; //Default = 0.048; 0.015 for 60 FPS; 0.030 for 30 FPS
  
  DebugConsole(){
    font = loadFont("data/ui/fonts/Arial Bold-14.vlw"); // TEMP
    
    // Button which opens the console
    debugButton = new Button( 50 , screenHeight - borderHeight/2 - 75*0, 50 );
    debugButton.setIdleColor(color(0,10,0));    
    debugButton.setLitColor(color(0,250,50)); 
    
    setupPanel();
  }// CTOR
  
  public void draw(){
    // incrementer adjusted for slower input
    if( frameRate > 55 )
      timerIncrementer = 0.015/2;
    else if( frameRate <= 30 )
      timerIncrementer = 0.015;
      
    if(debugConsole && game.getPlayState().isLoaded() )
      displayPanel_1();
    if(debugPanel2 && game.getPlayState().isLoaded() )
      displayPanel_2();
    if(debugConsole && !(game.getPlayState().isLoaded()) )
      displayPanel_0();
      
    debugButton.process(font, timer_g);
    debugButton.setLit( debugConsole || debugPanel2 );
          
    textAlign(LEFT); // Default
    timer_g += timerIncrementer; //Used for debug since console is indepentent of state
  }// draw()
  
  public void input(float x, float y, int finger){
    if( debugButton.isHit(x,y) ){
      if(debugConsole || debugPanel2 ){
        debugConsole = false;
        debugPanel2 = false;
      }else{
        new_nBalls = nBalls;
        newFieldLines = fieldLines;
        debugConsole = true;
      }
    }// if debugButton
    
    if( debugConsole && game.getPlayState().isLoaded() )
      panel_1_input(x,y,finger);
    else if(debugPanel2 && game.getPlayState().isLoaded() )
      panel_2_input(x,y,finger);
    if(debugConsole && !(game.getPlayState().isLoaded()) )
      panel_0_input(x,y,finger);
  }// input()
  
  private void setupPanel(){
    muteButton = new Button( 250 + 75, screenHeight - borderHeight/2 - 65*5 - 25, 100, 50 );
    muteButton.setIdleColor(color(60,10,10));
    muteButton.setLitColor(color(255, 0, 0));
    muteButton.setButtonText("MUTE");
    muteButton.setDoubleSidedText(false);
    
    minus1 = new Button( 50, screenHeight - borderHeight/2 - 65*5 - 25, 50, 50 );
    minus1.setIdleColor(color(250,250,250));
    minus1.setDoubleSidedText(false);
    minus1.setButtonText("-");
    minus2 = new Button( 50, screenHeight - borderHeight/2 - 65*4 - 25, 50, 50 );
    minus2.setIdleColor(color(250,250,250));
    minus2.setDoubleSidedText(false);
    minus2.setButtonText("-");
    minus3 = new Button( 50, screenHeight - borderHeight/2 - 65*3 - 25, 50, 50 );
    minus3.setIdleColor(color(250,250,250));
    minus3.setDoubleSidedText(false);
    minus3.setButtonText("-");
    minus4 = new Button( 50, screenHeight - borderHeight/2 - 65*2 - 25, 50, 50 );
    minus4.setIdleColor(color(250,250,250));
    minus4.setDoubleSidedText(false);
    minus4.setButtonText("-");
    minus5 = new Button( 50, screenHeight - borderHeight/2 - 65*1 - 25, 50, 50 );
    minus5.setIdleColor(color(250,250,250));
    minus5.setDoubleSidedText(false);
    minus5.setButtonText("-");
    
    plus1 = new Button( 250, screenHeight - borderHeight/2 - 65*5 - 25, 50, 50 );
    plus1.setIdleColor(color(250,250,250));
    plus1.setDoubleSidedText(false);
    plus1.setButtonText("+");
    plus2 = new Button( 250, screenHeight - borderHeight/2 - 65*4 - 25, 50, 50 );
    plus2.setIdleColor(color(250,250,250));
    plus2.setDoubleSidedText(false);
    plus2.setButtonText("+");
    plus3 = new Button( 250, screenHeight - borderHeight/2 - 65*3 - 25, 50, 50 );
    plus3.setIdleColor(color(250,250,250));
    plus3.setDoubleSidedText(false);
    plus3.setButtonText("+");
    plus4 = new Button( 250, screenHeight - borderHeight/2 - 65*2 - 25, 50, 50 );
    plus4.setIdleColor(color(250,250,250));
    plus4.setDoubleSidedText(false);
    plus4.setButtonText("+");
    plus5 = new Button( 250, screenHeight - borderHeight/2 - 65*1 - 25, 50, 50 );
    plus5.setIdleColor(color(250,250,250));
    plus5.setDoubleSidedText(false);
    plus5.setButtonText("+");
    
    round1 = new Button( 375 , screenHeight - borderHeight/2 - 75*3, 50 );
    round1.setDoubleSidedText(false);
    round1.setIdleColor(color(0,50,50));
    round2 = new Button( 375 , screenHeight - borderHeight/2 - 75*2, 50 );
    round2.setDoubleSidedText(false);
    round2.setIdleColor(color(0,50,50));
    round3 = new Button( 375 , screenHeight - borderHeight/2 - 75*1, 50 );
    round3.setDoubleSidedText(false);
    round3.setIdleColor(color(0,50,50));
    round4 = new Button( 375 , screenHeight - borderHeight/2 - 75*0, 50 );
    round4.setDoubleSidedText(false);
    round4.setIdleColor(color(0,50,50));
    
    applyChanges = new Button( 125, screenHeight - borderHeight/2 - 65*0 - 25, 200, 50 );
    applyChanges.setIdleColor(color(60,10,10, 1));
    applyChanges.setLitColor(color(255, 0, 0));
    applyChanges.setDoubleSidedText(false);  
    
  }// setupPanel
  
  private void displayPanel_0(){
    // background
    fill(color(0,0,0, 150));
    stroke(color(0,0,0));
    rect(0, screenHeight - borderHeight/2 - 75*5, 450 , 450 );    
    
    // Buttons
    muteButton.process(font, timer_g);
    muteButton.setLit( soundManager.isMuted() );
        
    minus1.process(font, timer_g);
    fill(255,255,255);
    text("Volume\n("+soundManager.getGain()+")", 175, screenHeight - borderHeight/2 - 65*5);
    plus1.process(font, timer_g);

    round1.process(font, timer_g);
    round1.setButtonText("");
    round1.setLitColor( color(0, 255, 0) );
    round1.setLit( false );
      
    round2.process(font, timer_g);
    round2.setButtonText("Debug\nText");
    round2.setLitColor( color(255, 0, 0) );
    round2.setLit( debugText );
    
    round3.process(font, timer_g);
    round3.setButtonText("");
    round3.setLitColor( color(0,250,250) );
    round3.setLit( false );
    
    round4.process(font, timer_g);
    round4.setButtonText("");
    round4.setLitColor( color(0,250,250) );
    round4.setLit( false );
    
    textAlign(LEFT);    
  }// displayPanel_0
  
  private void panel_0_input(float x, float y, int finger){
  
    if( muteButton.isHit(x,y) ){
      if( soundManager.isMuted() )
        soundManager.unmute();
      else
        soundManager.mute();
    }// if muteButton
      
    if( minus1.isHit(x,y) ){
      soundManager.subtractGain();
    }// if minus 1
    if( plus1.isHit(x,y) ){
      soundManager.addGain();
    }// if plus 1

    if( minus2.isHit(x,y) ){
    }// if minus 2
    if( plus2.isHit(x,y) ){
    }// if plus 2
    
    if( minus3.isHit(x,y) ){

    }// if minus 3
    if( plus3.isHit(x,y) ){

    }// if plus 3
    
    if( minus4.isHit(x,y) ){

    }// if minus 4
    if( plus4.isHit(x,y) ){

    }// if plus 4
    
    if( minus5.isHit(x,y) ){

    }// if minus 5
    if( plus5.isHit(x,y) ){

    }// if plus5
    
    if( round1.isHit(x,y) ){

    }// if round1
    
    if( round2.isHit(x,y) ){
      if( debugText ){
        debugText = false;
      }else{
        debugText = true;
      }
    }// if round2
    
    if( round3.isHit(x,y) ){

    }// if round3
    
    if( round4.isHit(x,y) ){
    }// if round4
  }// panel_0_input()
  
  private void displayPanel_1(){
    // background
    fill(color(0,0,0, 150));
    stroke(color(0,0,0));
    rect(0, screenHeight - borderHeight/2 - 75*5, 450 , 450 );    
    
    // Buttons
    muteButton.process(font, timer_g);
    muteButton.setLit( soundManager.isMuted() );
    
    applyChanges.process(font, timer_g);
    if( new_nBalls != nBalls || fieldLines != newFieldLines ){
      applyChanges.setButtonText("APPLY CHANGES\n (Requres Restart)");
      applyChanges.setLit( true );
    }else{
      applyChanges.setButtonText("");
      applyChanges.setLit( false );      
    }
        
    minus1.process(font, timer_g);
    fill(255,255,255);
    text("Volume\n("+soundManager.getGain()+")", 175, screenHeight - borderHeight/2 - 65*5);
    plus1.process(font, timer_g);
    
    minus2.process(font, timer_g);
    fill(255,255,255);
    text("Balls\n("+new_nBalls+")", 175, screenHeight - borderHeight/2 - 65*4);
    plus2.process(font, timer_g);
 
    minus3.process(font, timer_g);
    fill(255,255,255);
    text("Bars\n("+(newFieldLines - 1)+")", 175, screenHeight - borderHeight/2 - 65*3);    
    plus3.process(font, timer_g);

    minus4.process(font, timer_g);
    fill(255,255,255);
    text("Friction\n("+tableFriction+")", 175, screenHeight - borderHeight/2 - 65*2);   
    plus4.process(font, timer_g);

    minus5.process(font, timer_g);
    fill(255,255,255);
    text("Maximum Ball\nSpeed ("+maxBallSpeed+")", 175, screenHeight - borderHeight/2 - 65*1);
    plus5.process(font, timer_g);

    round1.process(font, timer_g);
    round1.setButtonText("Turret\nMode");
    round1.setLitColor( color(0, 255, 0) );
    round1.setLit( ballLauncher_bottom.isShootOnRelease() );
      
    round2.process(font, timer_g);
    round2.setButtonText("Debug\nText");
    round2.setLitColor( color(255, 0, 0) );
    round2.setLit( debugText );
    
    round3.process(font, timer_g);
    round3.setButtonText("Panel\n2");
    round3.setLitColor( color(0,250,250) );
    round3.setLit( debugPanel2 );
    
    round4.process(font, timer_g);
    round4.setButtonText("");
    round4.setLitColor( color(0,250,250) );
    round4.setLit( false );
    
    textAlign(LEFT);
  }// displayPanel_1
  
  private void panel_1_input(float x, float y, int finger){
  
    if( muteButton.isHit(x,y) ){
      if( soundManager.isMuted() )
        soundManager.unmute();
      else
        soundManager.mute();
    }// if muteButton
      
    if( minus1.isHit(x,y) ){
      soundManager.subtractGain();
    }// if minus 1
    if( plus1.isHit(x,y) ){
      soundManager.addGain();
    }// if plus 1

    if( minus2.isHit(x,y) ){
      if( new_nBalls > 0 )
        new_nBalls --;
    }// if minus 2
    if( plus2.isHit(x,y) ){
      if( new_nBalls >= 0 )
        new_nBalls ++;
    }// if plus 2
    
    if( minus3.isHit(x,y) ){
      if( newFieldLines > 1 )
        newFieldLines--;
    }// if minus 3
    if( plus3.isHit(x,y) ){
      if( newFieldLines >= 1 )
        newFieldLines++;
    }// if plus 3
    
    if( minus4.isHit(x,y) ){
      tableFriction -= 0.01;
    }// if minus 4
    if( plus4.isHit(x,y) ){
      tableFriction += 0.01;
    }// if plus 4
    
    if( minus5.isHit(x,y) ){
      maxBallSpeed--;
    }// if minus 5
    if( plus5.isHit(x,y) ){
      maxBallSpeed++;
    }// if plus5
    
    if( round1.isHit(x,y) ){
      if(ballLauncher_bottom.isShootOnRelease()){
        ballLauncher_bottom.setShootOnRelease(false);
        ballLauncher_top.setShootOnRelease(false);
      }else{
        ballLauncher_bottom.setShootOnRelease(true);
        ballLauncher_top.setShootOnRelease(true);
      }
    }// if round1
    
    if( round2.isHit(x,y) ){
      if( debugText ){
        debugText = false;
      }else{
        debugText = true;
      }
    }// if round2
    
    if( round3.isHit(x,y) ){
      debugPanel2 = true;
      debugConsole = false;
    }// if round3
    
    if( round4.isHit(x,y) ){
    }// if round4
    
    if( applyChanges.isHit(x,y) ){
      nBalls = new_nBalls;
      fieldLines = newFieldLines;
      game.reloadState( game.getPlayState() );
    }// if applyChanges
      
  }// panel_1_input()
  
  private void displayPanel_2(){
    // background
    fill(color(0,0,0, 150));
    stroke(color(0,0,0));
    rect(0, screenHeight - borderHeight/2 - 75*5, 450 , 450 );    
    
    // Buttons
    minus1.process(font, timer_g);
    fill(255,255,255);
    text("Bar Slide\n("+barManager.getBarSlideMultiplier()+")", 175, screenHeight - borderHeight/2 - 65*5);
    plus1.process(font, timer_g);
    
    minus2.process(font, timer_g);
    fill(255,255,255);
    text("Bar Rotation\n("+barManager.getBarRotateMultiplier()+")", 175, screenHeight - borderHeight/2 - 65*4);
    plus2.process(font, timer_g);
 
    minus3.process(font, timer_g);
    fill(255,255,255);
    text("Bar Friction\n("+barManager.getBarFriction()+")", 175, screenHeight - borderHeight/2 - 65*3); 
    plus3.process(font, timer_g);

    minus4.process(font, timer_g);
    fill(255,255,255);
    text("Max Stop\nAngle ("+barManager.getMaxStopAngle()+")", 175, screenHeight - borderHeight/2 - 65*2); 
    plus4.process(font, timer_g);

    minus5.process(font, timer_g);
    fill(255,255,255);
    text("Min Stop\nAngle ("+barManager.getMinStopAngle()+")", 175, screenHeight - borderHeight/2 - 65*1);
    plus5.process(font, timer_g);

    round1.process(font, timer_g);
    round1.setButtonText("Spring\nMode");
    round1.setLitColor( color(255, 255, 0) );
    round1.setLit( barManager.isSpringEnabled() );
      
    round2.process(font, timer_g);
    round2.setButtonText("Rotate\nMode");
    round2.setLitColor( color(255, 255, 0) );
    round2.setLit( barManager.isRotationEnabled() );
    
    round3.process(font, timer_g);
    round3.setButtonText("Panel\n2");
    round3.setLitColor( color(0,250,250) );
    round3.setLit( debugPanel2 );
    
    round4.process(font, timer_g);
    round4.setButtonText("");
    round4.setLitColor( color(0,250,250) );
    round4.setLit( false );
    
    textAlign(LEFT);
  }// displayPanel_2
  
  private void panel_2_input(float x, float y, int finger){
    if( minus1.isHit(x,y) ){
      barManager.setBarSlideMultiplier(barManager.getBarSlideMultiplier() - 0.5 );
    }// if minus 1
    if( plus1.isHit(x,y) ){
      barManager.setBarSlideMultiplier(barManager.getBarSlideMultiplier() + 0.5 );
    }// if plus 1

    if( minus2.isHit(x,y) ){
      barManager.setBarRotateMultiplier(barManager.getBarRotateMultiplier() - 0.5 );
    }// if minus 2
    if( plus2.isHit(x,y) ){
      barManager.setBarRotateMultiplier(barManager.getBarRotateMultiplier() + 0.5 );
    }// if plus 2
    
    if( minus3.isHit(x,y) ){
      barManager.setBarFriction(barManager.getBarFriction() - 0.05 );
    }// if minus 3
    if( plus3.isHit(x,y) ){
      barManager.setBarFriction(barManager.getBarFriction() + 0.05 );
    }// if plus 3
    
    if( minus4.isHit(x,y) ){
      if( barManager.getMaxStopAngle() > 0 )
        barManager.setMaxStopAngle(barManager.getMaxStopAngle() - 15);
    }// if minus 4
    if( plus4.isHit(x,y) ){
      if( barManager.getMaxStopAngle() < 360 )
        barManager.setMaxStopAngle(barManager.getMaxStopAngle() + 15);
    }// if plus 4
    
    if( minus5.isHit(x,y) ){
      if( barManager.getMinStopAngle() > 0 )
        barManager.setMinStopAngle(barManager.getMinStopAngle() - 15);
    }// if minus 5
    if( plus5.isHit(x,y) ){
      if( barManager.getMinStopAngle() < 360 )
        barManager.setMinStopAngle(barManager.getMinStopAngle() + 15);
    }// if plus5
    
    if( round1.isHit(x,y) ){
      if( barManager.isSpringEnabled() ){
        barManager.setSpringEnabled(false);
        barManager.setRotationEnabled(false);
      }else{
        barManager.setSpringEnabled(true);
        barManager.setRotationEnabled(false);
      }
    }// if round1
    
    if( round2.isHit(x,y) ){
      if( barManager.isRotationEnabled() ){
        barManager.setRotationEnabled(false);
        barManager.setSpringEnabled(false);
      }else{
        barManager.setSpringEnabled(false);
        barManager.setRotationEnabled(true);
      }
    }// if round2
    
    if( round3.isHit(x,y) ){
      debugPanel2 = false;
      debugConsole = true;
    }// if round3
    
    if( round4.isHit(x,y) ){
    }// if round4
      
  }// panal_2_input()
}// class

