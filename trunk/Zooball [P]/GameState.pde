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
  public void exit( ) { timer.setActive( false ); }
  
  public void input( ) {
    // Process mouse if clicked
    if(mousePressed && usingMouse){
      float xCoord = mouseX;    
      float yCoord = mouseY;
  		
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
  		noStroke();
  		ellipse( xCoord, yCoord, 20, 20 );

                // ANY CHANGES HERE MUST BE COPIED TO MOUSE IF ABOVE
                checkButtonHit(xCoord, yCoord, finger);
                debugConsole.input(xCoord, yCoord, finger);
  	}// for touchList
    }// if touch
    else if(connectToTacTile){ 
      checkButtonHit(-100, -100, -1); // Allows for a "touch release" trigger
    }// if tacTileList empty else
    // Events that occur during every loop

  }// input()
  
  public void checkButtonHit(float x, float y, int finger){
  }// checkButtonHit

  public void update( ) { timer.update( ); }
  public void draw( ) { }
}
