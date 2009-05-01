/**
 * Over GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class OverState extends GameState
{
  private CircularButton btnReplayBottom, btnReplayTop, btnQuitBottom, btnQuitTop;
  private Image gameOver_dragonWin, gameOver_tigerWin;
  
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
    gameOver_dragonWin = new Image("data/ui/text/GameOver_TopDragonWin.png");
    gameOver_dragonWin.setPosition(0, 0);
    gameOver_tigerWin = new Image("data/ui/text/GameOver_BottomTigersWin.png");
    gameOver_tigerWin.setPosition(0, 0);
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
    
    if( timer.getSecondsActive() > 7 )
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
    pushMatrix();
    if( redTeamTop && redTeamWins )
      gameOver_dragonWin.draw();
    else if( !redTeamTop && redTeamWins ){
      translate(game.getWidth(), game.getHeight());
      rotate(radians(180));
      gameOver_dragonWin.draw();
    }else if( redTeamTop && yellowTeamWins )
      gameOver_tigerWin.draw();
    else if( !redTeamTop && yellowTeamWins ){
      translate(game.getWidth(), game.getHeight());
      rotate(radians(180));
      gameOver_tigerWin.draw();
    }
    popMatrix();
 
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
