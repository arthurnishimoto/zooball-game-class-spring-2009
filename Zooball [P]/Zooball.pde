import processing.opengl.*;

Game game;

void setup( ) {
  Image.setPApplet( this ); // Image stores a static instance of this PApplet to call Processing methods. This must be set before creating any Image objects.
  size( screen.width, screen.height, OPENGL );
  //size( 960, 540, OPENGL );
  game = new Game( );
}

void draw( ) {
  game.loop( );
}

void keyPressed( KeyEvent e ) {
  if ( game != null ) {
    if ( e.getKeyChar( ) == 'd' || e.getKeyChar( ) == 'D' )
      game.toggleDebugMode(  );
    else if ( e.getKeyChar( ) == 's' || e.getKeyChar( ) == 'S' )
      game.toggleStrokeMode( );
  }
  super.keyPressed( e ); // Pass event up the chain so ESC still works
}
