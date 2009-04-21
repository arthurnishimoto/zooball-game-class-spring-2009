/**
 * @TODO Quickly added for user test. - CLEAN UP LATER
 */
class DebugConsole{
  Button debugButton;
  
  Button debugTextButton, debug2TextButton;
  Button springButton, turretButton;
  Button addBall, subtBall;
  Button addBar, subtBar;
  Button volumeUp, volumeDown;
  Button muteButton;
  Button applyChanges;
  Button addFriction, subtFriction;
  Button barWidthUp, barWidthDown;
  Boolean debugConsole = false;
  Boolean debugConsole2 = false;
  int screenHeight = screen.height;
  int new_nBalls, newFieldLines;
  float timerIncrementer = 0.015; //Default = 0.048; 0.015 for 60 FPS; 0.030 for 30 FPS
  
  DebugConsole(){
    font = loadFont("data/ui/fonts/Arial Bold-14.vlw"); // TEMP
    
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

  }// CTOR
  
  public void draw(){

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
        
        subtFriction.process(font, timer_g);
        textAlign(CENTER);
        fill(color(255,255,255));
        textFont(font,18);
        if( debugConsole )
          text("Friction\n("+tableFriction+")", 175, screenHeight - borderHeight/2 - 65*2);
        else if( debugConsole2 )
          text("Max Stop\nAngle ("+barManager.getMaxStopAngle()+")", 175, screenHeight - borderHeight/2 - 65*2);
        addFriction.process(font, timer_g);
        
        barWidthDown.process(font, timer_g);
        textAlign(CENTER);
        fill(color(255,255,255));
        textFont(font,18);
        if(debugConsole)
          text("Bar Width\n("+barWidth+")", 175, screenHeight - borderHeight/2 - 65*1);
        else if(debugConsole2)
          text("Min Stop\nAngle ("+barManager.getMinStopAngle()+")", 175, screenHeight - borderHeight/2 - 65*1);
        barWidthUp.process(font, timer_g);
        
        debugTextButton.process(font, timer_g);
        debug2TextButton.process(font, timer_g);
        springButton.process(font, timer_g);
        turretButton.process(font, timer_g);
      }// if debugConsole

      debugButton.process(font, timer_g += timerIncrementer);
      debugButton.setLit( debugConsole || debugConsole2 );    
      textAlign(LEFT);
  }// draw()
  
  
  public void input(float x, float y, int finger){
    fill(0,255,0);
    ellipse(x,y,10,10);
    if( debugButton.isHit(x,y) ){
      fill(0,0,255);
      ellipse(x,y,10,10);
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
        nBalls = new_nBalls;
        fieldLines = newFieldLines;
        game.reloadState( game.getPlayState() );
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
      
      //if( springButton.isHit(x,y) ){
      //  if(barManager.isSpringEnabled()){
      //    barManager.setSpringEnabled(false);
      //  }else{
      //    barManager.setSpringEnabled(true);
      //  }
      //}// if springButton
        
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
      if( subtFriction.isHit(x,y) ){
        if( barManager.getMaxStopAngle() > 0 )
          barManager.setMaxStopAngle(barManager.getMaxStopAngle() - 15);
      }// if subtFriction
      
      if( addFriction.isHit(x,y) ){
        if( barManager.getMaxStopAngle() < 360 )
          barManager.setMaxStopAngle(barManager.getMaxStopAngle() + 15);
      }// if addFriction 
      
      if( barWidthDown.isHit(x,y) ){
        if( barManager.getMinStopAngle() > 0 )
          barManager.setMinStopAngle(barManager.getMinStopAngle() - 15);
      }// if barWidthDown
      
      if( barWidthUp.isHit(x,y) ){
        if( barManager.getMinStopAngle() < 360 )
          barManager.setMinStopAngle(barManager.getMinStopAngle() + 15);
      }// if barWidthUp  
      
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

  }// input()
}// class

