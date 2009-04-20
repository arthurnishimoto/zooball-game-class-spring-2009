/**
 * The main GameState. Gameplay happens here.
 *
 * Author:  Andy Bursavich
 * Version: 0.5
 */
class PlayState extends GameState
{
  private Image imgPitch, imgStadiumTop, imgStadiumBottom, imgStadiumLeft, imgStadiumRight;
  private CircularButton btnPauseTop, btnPauseBottom;
  
  public PlayState( Game game ) {
    super( game );
  }
  
  public void load( ) {
    imgPitch = new Image( "objects\\stadium\\pitch.png" );
    imgPitch.setPosition( 75, 25 );
    imgStadiumTop = new Image( "objects\\stadium\\top.png" );
    imgStadiumTop.setPosition( 0, 0 );
    imgStadiumBottom = new Image( "objects\\stadium\\bottom.png" );
    imgStadiumBottom.setPosition( 0, 1055 );
    imgStadiumLeft = new Image( "objects\\stadium\\left.png" );
    imgStadiumLeft.setPosition( 0, 25 );
    imgStadiumRight = new Image( "objects\\stadium\\right.png" );
    imgStadiumRight.setPosition( 1845, 25 );
    btnPauseBottom = new CircularButton( "ui\\buttons\\pause\\enabled.png" );
    btnPauseBottom.setPosition( 1882.5, 1027.5 );
    btnPauseBottom.setRadius( 27.5 );
    btnPauseTop = new CircularButton( "ui\\buttons\\pause\\enabled.png" );
    btnPauseTop.setPosition( 37.5, 52.5 );
    btnPauseTop.setRadius( 27.5 );
    btnPauseTop.setRotation( PI );
    endLoad( );
  }
  
  public void draw( ) {
    drawBackground( );
    drawPitch( );
    drawStadium( );
    drawButtons( );
    drawDebugText( );
  }
  
  private void drawBackground( ) {
    background( 0 );
    //fill( 20, 200, 20 ); // green
    //rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private void drawPitch( ) {
    imgPitch.draw( );
  }
  
  private void drawStadium( ) {
    imgStadiumTop.draw( );
    imgStadiumBottom.draw( );
    imgStadiumLeft.draw( );
    imgStadiumRight.draw( );
    // If we only have one team configuration, these rectangles could just be incorporated into the above textures...
    /*
    // UIC Goal
    fill( 255 );
    rect(1845, 411, 75, 258 );
    fill( 0xCC, 0, 0 );
    rect(1845, 415, 75, 250 );
    // UIC Side Marker
    rect(75, 6, 1770, 13);
    // LSU Goal
    fill( 255 );
    rect(0, 411, 75, 258 );
    fill( 0xFD, 0xD0, 0x23 );
    rect(0, 415, 75, 250 );
    // LSU Side Marker
    rect(75, 1061, 1770, 13);
    */
  }
  
  private void drawButtons( ) {
    btnPauseBottom.draw( );
    btnPauseTop.draw( );
  }
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "PlayState"; }
}
