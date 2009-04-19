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
