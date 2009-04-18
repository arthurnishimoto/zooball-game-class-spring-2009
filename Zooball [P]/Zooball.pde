import processing.opengl.*;

Game game;

void setup( ) {
  size( screen.width, screen.height, OPENGL );
  game = new Game( );
}

void draw( ) {
  game.loop( );
}
