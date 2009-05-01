import processing.net.*;

import processing.opengl.*;
import tacTile.net.*;

Game game;

void setup( ) {
  Image.setPApplet( this ); // Image stores a static instance of this PApplet to call Processing methods. This must be set before creating any Image objects.
  size( screen.width, screen.height, OPENGL );
  //size( 960, 540, OPENGL );
  game = new Game( null );
  //game = new Game( new TouchAPI( this, 7000, 7340, "localhost" ) );
}

void draw( ) {
  game.loop( );
}

void keyPressed( KeyEvent e ) {
  if ( game != null ) {
    if ( e.getKeyChar( ) == 'd' || e.getKeyChar( ) == 'D' )
      game.toggleDebugMode( );
    else if ( e.getKeyChar( ) == 'w' || e.getKeyChar( ) == 'W' )
      game.getPlayState().toggleWireframeMode( );
    else if ( e.getKeyChar( ) == '1' )
      game.getPlayState( ).test1( );
    else if ( e.getKeyChar( ) == '2' )
      game.getPlayState( ).test2( );
    else if ( e.getKeyChar( ) == '3' )
      game.getPlayState( ).test3( );
    else if ( e.getKeyChar( ) == '4' )
      game.getPlayState( ).test4( );
    else if ( e.getKeyChar( ) == '5' )
      game.getPlayState( ).test5( );
    else if ( e.getKeyChar( ) == '6' )
      game.getPlayState( ).test6( );
    else if ( e.getKeyChar( ) == '7' )
      game.getPlayState( ).test7( );
    else if ( e.getKeyChar( ) == '8' )
      game.getPlayState( ).test8( );
  }
  super.keyPressed( e ); // Pass event up the chain so ESC still works
}
