/**
 * Abstract GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.1
 */ 
abstract class GameState
{
  protected Game game;
  protected Timer timer;
  private volatile int loading;
  private final static int BEFORE = 0;
  private final static int DURING = 1;
  private final static int AFTER = 2;

  

  public GameState( Game game ) {
    this.game = game;
    timer = new Timer( );
    loading = BEFORE;
  }
  
  public boolean isLoading( ) { return loading == DURING; }
  public boolean isLoaded( ) { return loading == AFTER; }
  public final void beginLoad( ) {
    if (loading == BEFORE) {
      loading = DURING;
      
      Runnable loader = new Runnable( ) {
        public void run( ) { load( ); }
      };
      Thread thread = new Thread( loader );
      
      thread.start( );
    }
  }
  protected void load( ) { endLoad( ); }
  protected final void endLoad( ) { loading = AFTER; }
  
  public void reset( ) { timer.reset( ); loading = BEFORE; }
  public void enter( ) { timer.setActive( true ); }
  
  public void exit( ) {
    soundManager.pauseSounds();
    timer.setActive( false );
  }// exit
  
  public void input( ) {
  
    // Displays mouse position
    if(usingMouse){
      float xCoord = (mouseX + screenOffsetX) / screenScale;
      float yCoord = (mouseY - screenOffsetY) / screenScale;

      //Draw mouse
      fill( #000000 );
      noStroke();
      ellipse( xCoord, yCoord, 20, 20 );
    }
    
    if(!mousePressed && usingMouse && recordingMouse)
      mouseRecorder += ( mouseX +" "+ mouseY + " FALSE ");
    else if(mousePressed && usingMouse && recordingMouse)
      mouseRecorder += ( mouseX +" "+ mouseY + " TRUE ");
      
    if( playbackMouse && game.getPlayState().timer.isActive() ){
      if( mousePlayback[playbackItr].length() > 0 ){
        //println("xCoord = "+mousePlayback[playbackItr]);
        //println("yCoord = "+mousePlayback[playbackItr+1]);
        //println("T/F = "+mousePlayback[playbackItr+2]);
        float xCoord = Float.valueOf(mousePlayback[playbackItr].trim()).floatValue();
        float yCoord = Float.valueOf(mousePlayback[playbackItr+1].trim()).floatValue();
        if( mousePlayback[playbackItr+2].equals("TRUE") ){
  	  fill( #FF0000 );
  	  noStroke();
  	  ellipse( xCoord, yCoord, 20, 20 );          
          checkButtonHit(xCoord,yCoord, 1);
        }else{
   	  fill( #000000 );
  	  noStroke();
  	  ellipse( xCoord, yCoord, 20, 20 );              
        }
        playbackItr += 3;
      }// if
      else{
        //println(mousePlayback[playbackItr+1]);
        playbackMouse = false;
        playbackItr = 0;
      }
    }// if playbackMouse
    
    // Process mouse if clicked
    if(mousePressed && usingMouse){
      float xCoord = (mouseX + screenOffsetX) / screenScale;
      float yCoord = (mouseY - screenOffsetY) / screenScale;
  		
      //Draw mouse
      fill( #FF0000 );
      noStroke();
      ellipse( xCoord, yCoord, 20, 20 );
           
      // ANY CHANGES HERE MUST BE COPIED TO TOUCH ELSE-IF BELOW
      checkButtonHit(xCoord,yCoord, 1);
      debugConsole.input(xCoord,yCoord, 1);
    }// if mousePressed
    else if( usingMouse && !connectToTacTile ){
      checkButtonHit(-100, -100, -1); // Allows for a "mouse release" trigger
    }// else if usingMouse
    
    //Process touches off the managedList if there are any touches.
    if ( true ){
      
       
      // Grab the managedList
  	touchList = tacTile.getManagedList();
  
        if( mousePressed ){
          float xCoordm = (mouseX + screenOffsetX) / screenScale;
          float yCoordm = (mouseY - screenOffsetY) / screenScale;
          xCoordm = xCoordm/width;
          yCoordm = (height - yCoordm)/height;

          // Adds  a "mouse touch" to the touchList
          touchList.add( new Touches( 0, 0, xCoordm, yCoordm, 1.0 ) );
        
        }
        if( tacTile.managedListIsEmpty() )
         touchList.add( new Touches( 0, 0, -100, -100, 1.0 ) );
         
        sendTouchList(touchList);
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
  		noStroke();
  		ellipse( xCoord, yCoord, 20, 20 );

                debugConsole.input(xCoord, yCoord, finger);
                // ANY CHANGES HERE MUST BE COPIED TO MOUSE IF ABOVE
                if( !demoMode )
                  checkButtonHit(xCoord, yCoord, finger);
                else
                  checkButtonHit_demo(xCoord, yCoord, finger);
  	}// for touchList
    }// if touch

    // Events that occur during every loop

  }// input()
  
  public void checkButtonHit(float x, float y, int finger){
  }// checkButtonHit
  
  public void sendTouchList(ArrayList touchList){
  }// sendTouchList
  
  public void checkButtonHit_demo(float x, float y, int finger){ // Only used to allow user touches on pause button during demo
  }// checkButtonHit
  
  public void update( ) { timer.update( ); }
  public void draw( ) { }
}
