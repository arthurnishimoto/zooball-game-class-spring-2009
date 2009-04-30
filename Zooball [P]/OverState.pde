/**
 * Over GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class OverState extends GameState
{
  private CircularButton btnReplayBottom, btnReplayTop, btnQuitBottom, btnQuitTop;
  private Image gameOver;
  
  public OverState( Game game ) {
    super( game );
  }
  
  public boolean isLoading( ) { return super.isLoading( ) || game.getPlayState( ).isLoading( ); }
  public boolean isLoaded( ) { return super.isLoaded( ) && game.getPlayState( ).isLoaded( ); }
  public void load( ) {
    if ( !game.getPlayState( ).isLoading( ) && !game.getPlayState( ).isLoaded( ) )
      game.getPlayState( ).beginLoad( );
    btnReplayBottom = new CircularButton( "data/ui/buttons/replay/enabled.png" );
    btnReplayBottom.setPosition( 897.5, 980 );
    btnReplayBottom.setRadius( 50 );
    btnQuitBottom = new CircularButton( "data/ui/buttons/stop/enabled.png" );
    btnQuitBottom.setPosition( 1022.5, 980 );
    btnQuitBottom.setRadius( 50 );
    btnReplayTop = new CircularButton( "data/ui/buttons/replay/enabled.png" );
    btnReplayTop.setPosition( 1022.5, 100 );
    btnReplayTop.setRadius( 50 );
    btnReplayTop.setRotation( PI );
    btnQuitTop = new CircularButton( "data/ui/buttons/stop/enabled.png" );
    btnQuitTop.setPosition( 897.5, 100 );
    btnQuitTop.setRadius( 50 );
    btnQuitTop.setRotation( PI );
    gameOver = new Image("data/ui/text/GameOver2.png");
    gameOver.setPosition(0,0);
    endLoad( );
  }
  
  public void enter(){
    timer.reset();
    timer.setActive( true );
    soundManager.stopSounds();
    soundManager.playPostgame();
  }// enter()
  
  public void draw( ) {
    drawBackground( );
    drawOverlay( );
    drawDebugText( );
    drawGameOverText( );
    
    if( timer.getSecondsActive() > 5 )
      barManager.displayStats();
    drawButtons( );
  }// draw()
  
  private void drawBackground( ) {
    boolean debugMode = game.isDebugMode( );
    if ( debugMode ) game.toggleDebugMode( );
    game.getPlayState().draw( );
    if ( debugMode ) game.toggleDebugMode( );
  }
  
  private void drawOverlay( ) {
    fill( 0, 128 );
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private void drawButtons( ) {
    btnReplayBottom.draw( );
    btnQuitBottom.draw( );
    btnReplayTop.draw( );
    btnQuitTop.draw( );
  }
  
  private void drawGameOverText(){
    textFont(font,64);
    textAlign(CENTER);

    if( redTeamWins ){
      fill(255,0,0);
      text("Dragon Team Wins", game.getWidth()/2, game.getHeight()/2 + 64*4);
    }else if( yellowTeamWins ){
      fill(255,255,0);
      text("Tiger Team Wins", game.getWidth()/2, game.getHeight()/2 + 64*4);      
    }else{
      fill(0,255,0);
      text("DRAW", game.getWidth()/2, game.getHeight()/2 + 64*4);
    }

    gameOver.draw();

    pushMatrix();
    translate(game.getWidth()/2, game.getHeight()/2 - 64*3);
    rotate(radians(180));
   
    if( redTeamWins ){
      fill(255,0,0);
      text("Dragon Team Wins", 0, 0 + 64*2);
    }else if( yellowTeamWins ){
      fill(255,255,0);
      text("Tiger Team Wins", 0, 0 + 64*2);      
    }else{
      fill(0,255,0);
      text("DRAW", 0, 0 + 64*2);            
    }
    
    popMatrix();
    textAlign(LEFT);    
  }// drawGameOverText()
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame Rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "OverState"; }
  
  public void checkButtonHit(float x, float y, int finger){
    if( timer.getSecondsActive() < 5 ) // Prevent accidental button press when screen first appears.
      return;
    
    if( btnReplayBottom.contains(x,y) || btnReplayTop.contains(x,y) ){
      game.reloadState(game.getPlayState());
      barManager.updateFoosbarRecord();
    }// if replayButton
    
    if( btnQuitBottom.contains(x,y) || btnQuitTop.contains(x,y) ){
      game.setState(game.getMenuState());
      barManager.updateFoosbarRecord();
    }// if quitButton

  }// checkButtonHit
  
}// class OverState
