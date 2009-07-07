import MTButton.*;

import echoClient.*;

import processing.opengl.*;
import processing.net.*;
import tacTile.net.*;

EchoClient client = new EchoClient();
Game game;

Boolean connectToTacTile = true;
Boolean usingMouse = true;
Boolean scaleScreen = true; // All input is off-centered when scaled

Boolean recordingMouse = false;
Boolean playbackMouse = false;
String[] mousePlayback;
String[] demoPlayback;
String mouseRecorder = "";
int playbackItr = 0;

Boolean quit = false;

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
  size( screen.width, screen.height, OPENGL );

  if( connectToTacTile ){
    //Create connection to Touch Server
    tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);
  }else{
    //Create connection to Touch Server
    tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
  }// if-else tacTile
  
  soundManager = new SoundManager(this);
  debugConsole = new DebugConsole(this);
  demoPlayback = loadStrings("data/tutorial.txt");
  Image.setPApplet( this ); // Image stores a static instance of this PApplet to call Processing methods. This must be set before creating any Image objects.
  
  game = new Game( this );
}

void draw( ) {
  game.loop( );
  if( recordingMouse ){
    fill(255,0,0);
    ellipse(10,10,10,10);
  }else if( playbackMouse ){
    fill(0,255,0);
    ellipse(10,10,10,10);
  }
  
  // Probably could override stop() in the future
  if(quit){
    client.informLauncher();
    exit();
  }
}// draw

void keyPressed( KeyEvent e ) {
  if(key==27){
    client.informLauncher(); // Sends message if esc key pressed
  }
  
  if ( game != null ) {
    if ( e.getKeyChar( ) == 'q'){
      if(debugConsoleBool)
        debugConsoleBool = false;
      else
        debugConsoleBool = true;
    }
    else if ( e.getKeyChar( ) == 'd' || e.getKeyChar( ) == 'D' )
      game.toggleDebugMode(  );
    else if ( e.getKeyChar( ) == 's' || e.getKeyChar( ) == 'S' )
      game.toggleStrokeMode( );
    else if ( e.getKeyChar( ) == 'Q' || e.getKeyChar( ) == 'Q' )
      if( recordingMouse ){
        recordingMouse = false;
        mouseRecorder += " EOF ";
        String words = mouseRecorder;
        String[] list = split(words, ' ');
        // now write the strings to a file, each on a separate line
        saveStrings("data/list.txt", list);
      }else
         recordingMouse = true;
    else if ( e.getKeyChar( ) == 'W' || e.getKeyChar( ) == 'W' ){
      if( playbackMouse ){
        playbackMouse = false;
      }else{
        playbackMouse = true;
        mousePlayback = loadStrings("data/list.txt");
      }
      
    }// else-if recording
 
  }// if game != null
  super.keyPressed( e ); // Pass event up the chain so ESC still works
}// keyPressed

