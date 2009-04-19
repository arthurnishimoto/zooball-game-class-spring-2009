/**
 * The main GameState. Gameplay happens here.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class PlayState extends GameState
{
  Image pitch, stadiumTop, stadiumBottom, stadiumLeft, stadiumRight;
  
  public PlayState( Game game ) {
    super( game );
  }
  
  public void load( ) {
    pitch = Image.getImage( "objects\\stadium\\pitch.png" );
    pitch.setX( 75 );
    pitch.setY( 25 );
    stadiumTop = Image.getImage( "objects\\stadium\\top.png" );
    stadiumTop.setX( 0 );
    stadiumTop.setY( 0 );
    stadiumBottom = Image.getImage( "objects\\stadium\\bottom.png" );
    stadiumBottom.setX( 0 );
    stadiumBottom.setY( 1055 );
    stadiumLeft = Image.getImage( "objects\\stadium\\left.png" );
    stadiumLeft.setX( 0 );
    stadiumLeft.setY( 25 );
    stadiumRight = Image.getImage( "objects\\stadium\\right.png" );
    stadiumRight.setX( 1845 );
    stadiumRight.setY( 25 );
    endLoad( );
  }
  
  public void draw( ) {
    drawBackground( );
    drawPitch( );
    drawStadium( );
    drawDebugText( );
  }
  
  private void drawBackground( ) {
    background( 0 );
    fill( 20, 200, 20 ); // green
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }
  
  private void drawPitch( ) {
    pitch.draw( );
  }
  
  private void drawStadium( ) {
    stadiumTop.draw( );
    stadiumBottom.draw( );
    stadiumLeft.draw( );
    stadiumRight.draw( );
    
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
  
  private void drawDebugText( ) {
    game.drawDebugText( "Frame rate: " + frameRate + "\nSeconds: " + timer.getSecondsActive() );
  }
  
  public String toString( ) { return "PlayState"; }
}
