/**
 * Intro GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class IntroState extends GameState
{
  private PImage ISE;
  int pos = 0;
  int finalPos = 150;
  
  public IntroState( Game game ) {
    super( game );
  }
  
  public void load( ) {
    ISE = loadImage( "data/ui/logos/ise1.png" );
        
    endLoad( );
  }
  
  public void enter(){
    timer.reset();
    timer.setActive( true );
    soundManager.stopSounds();
    soundManager.playLogoMusic();
  }// enter()  
  
  public void update( ) {
    super.update( );
    if ( timer.getSecondsActive( ) > 5.0 && pos == finalPos )
      game.setState( game.getMenuState( ) );
  }
  
  public void draw( ) {
    drawBackground( );
    drawDebugText( );
    animateLogo();
  }
  
  private void drawBackground( ) {
    background( 50, 50, 50 );
    fill( 0x00, 0x0, 0x0 );
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "IntroState"; }
  
  private void animateLogo(){
    imageMode(CENTER);
    if( pos < finalPos )
      pos++;
    image(ISE, game.getWidth()/2, game.getHeight()/2 + pos);
    
    textFont(font,64);
    textAlign(CENTER);
    fill( 255,255,255, 255*(pos/finalPos) );
    text("Presents", game.getWidth()/2, game.getHeight()/2 + pos + 64*4);
    
    pushMatrix();
    translate(game.getWidth()/2, game.getHeight()/2 - pos);
    rotate(radians(180));
    image(ISE, 0, 0 );
    text("Presents", 0, 0 + 64*4);
    popMatrix();
    imageMode(CORNERS);
  }// animateLogo
  
  public void checkButtonHit(float x, float y, int finger){
    if( x >= 0 && x <= game.getWidth() )
      if( y >= 0 && y <= game.getHeight() )
        game.setState( game.getMenuState() );
  }// checkButtonHit
}// class IntroState
