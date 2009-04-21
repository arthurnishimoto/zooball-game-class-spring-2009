/**
 * Over GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class OverState extends GameState
{
  private CircularButton btnReplayBottom, btnReplayTop, btnQuitBottom, btnQuitTop;
  
  public OverState( Game game ) {
    super( game );
  }
  
  public boolean isLoading( ) { return super.isLoading( ) || game.getPlayState( ).isLoading( ); }
  public boolean isLoaded( ) { return super.isLoaded( ) && game.getPlayState( ).isLoaded( ); }
  public void load( ) {
    if ( !game.getPlayState( ).isLoading( ) && !game.getPlayState( ).isLoaded( ) )
      game.getPlayState( ).beginLoad( );
    btnReplayBottom = new CircularButton( "ui\\buttons\\replay\\enabled.png" );
    btnReplayBottom.setPosition( 897.5, 980 );
    btnReplayBottom.setRadius( 50 );
    btnQuitBottom = new CircularButton( "ui\\buttons\\stop\\enabled.png" );
    btnQuitBottom.setPosition( 1022.5, 980 );
    btnQuitBottom.setRadius( 50 );
    btnReplayTop = new CircularButton( "ui\\buttons\\replay\\enabled.png" );
    btnReplayTop.setPosition( 1022.5, 100 );
    btnReplayTop.setRadius( 50 );
    btnReplayTop.setRotation( PI );
    btnQuitTop = new CircularButton( "ui\\buttons\\stop\\enabled.png" );
    btnQuitTop.setPosition( 897.5, 100 );
    btnQuitTop.setRadius( 50 );
    btnQuitTop.setRotation( PI );
    endLoad( );
  }
  
  public void draw( ) {
    drawBackground( );
    drawOverlay( );
    drawButtons( );
    drawDebugText( );
    drawGameOverText( );
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
      text("Red Team Wins", game.getWidth()/2, game.getHeight()/2 + 64*4);
    }else if( yellowTeamWins ){
      fill(255,255,0);
      text("Yellow Team Wins", game.getWidth()/2, game.getHeight()/2 + 64*4);      
    }
    
    fill(255,255,255);
    String buttonText = "GAME OVER";
    text(buttonText, game.getWidth()/2, game.getHeight()/2 + 64*3);

    pushMatrix();
    translate(game.getWidth()/2, game.getHeight()/2 - 64*3);
    rotate(radians(180));
    
    fill(255,255,255);
    text(buttonText, 0, 0 + 64/2);  
    
    if( redTeamWins ){
      fill(255,0,0);
      text("Red Team Wins", 0, 0 + 64*2);
    }else if( yellowTeamWins ){
      fill(255,255,0);
      text("Yellow Team Wins", 0, 0 + 64*2);      
    }
    
    popMatrix();
    textAlign(CORNER);    
  }// drawGameOverText()
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame Rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "OverState"; }
  
  public void checkButtonHit(float x, float y, int finger){
    if( btnReplayBottom.contains(x,y) || btnReplayTop.contains(x,y) ){
      game.reloadState(game.getPlayState());
    }// if replayButton
    
    if( btnQuitBottom.contains(x,y) || btnQuitTop.contains(x,y) ){
      game.setState(game.getMenuState());
    }// if quitButton

  }// checkButtonHit
  
}// class OverState
