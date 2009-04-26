import processing.opengl.*;
import processing.net.*;
import tacTile.net.*;

Game game;

Boolean connectToTacTile = false;
Boolean usingMouse = true;
Boolean scaleScreen = true; // All input is off-centered when scaled

//Touch API
TouchAPI tacTile;

//List of Touches
ArrayList touchList = new ArrayList();

//Names of machines you might use
String localMachine = "localhost";
String tacTileMachine = "tactile.evl.uic.edu";

//Port for data transfer
int dataPort = 7000;
int msgPort = 7340;
  
SoundManager soundManager;  
DebugConsole debugConsole;
  
void setup( ) {
  Image.setPApplet( this ); // Image stores a static instance of this PApplet to call Processing methods. This must be set before creating any Image objects.
  
  size( screen.width, screen.height, OPENGL ); // OPENGL causes connect failure if placed after TouchAPI CTOR
  //size( 960, 540, OPENGL );
  
  if( connectToTacTile ){
    //Create connection to Touch Server
    tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);
  }else{
    //Create connection to Touch Server
    tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
  }// if-else tacTile
  
  soundManager = new SoundManager(this);
  debugConsole = new DebugConsole();
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
