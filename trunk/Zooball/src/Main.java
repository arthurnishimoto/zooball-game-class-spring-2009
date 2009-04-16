import ise.foosball.FoosballGame;

import ise.game.GameState;

import processing.core.PApplet;
import processing.core.PConstants;

import tacTile.net.*;

import java.awt.event.KeyEvent;

import javax.swing.JOptionPane;


/**
 * Sets up Processing and the TacTile then calls game loop
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class Main extends PApplet {
  private static final long serialVersionUID = 7150518280552892074L;
  private static final int DATA_PORT = 7000;
  private static final int MSG_PORT = 7340;
  private static String tacTileHost = "";
  private FoosballGame game;
  private TouchAPI tacTile;
  private boolean played = false;

  /**
   * Main method
   *
   * @param args ignored
   */
  public static void main( String[] args ) {
    String[] displayNames = new String[] { "LSU", "UIC", "Local" };
    String[] hostNames = new String[] { "tactile.cct.lsu.edu", "tactile.evl.uic.edu", "localhost" };

    int response = JOptionPane.showOptionDialog( null, "Which Touch Server would you like to use?",
                                                 "Touch Server", 0, JOptionPane.QUESTION_MESSAGE,
                                                 null, displayNames, null );

    if ( response != -1 ) {
      tacTileHost = hostNames[response];

      PApplet.main( new String[] { "--present", "Main" } );
    } // end if
  } // end main()

  /**
   * Method called repeatedly by Processing
   */
  public void draw(  ) {
    game.loop( tacTile );
  } // end draw()

  /**
   * DOCUMENT ME!
   *
   * @param e DOCUMENT ME!
   */
  public void keyPressed( KeyEvent e ) {
    if ( game != null ) {
      if ( e.getKeyChar(  ) == 'd' || e.getKeyChar(  ) == 'D' ) {
        game.toggleDebugMode(  );
      } // end if
      else if ( game.isDebugMode(  ) && ( e.getKeyChar(  ) == 's' || e.getKeyChar(  ) == 'S' ) ) {
        GameState state = game.getGameState(  );

        if ( state == game.getMenuState(  ) ) {
          game.getTestState().init();
          game.setState( game.getTestState(  ) );
        } // end if
        else if ( state == game.getTestState(  ) ) {
        	if (played) {
        		game.setState( game.getOverState(  ) );
        	}
        	else {
        		game.setState( game.getPausedState(  ) );
        	}
        	played = !played;
        } // end else if
        else if ( state == game.getPausedState(  ) ) {
          game.setState( game.getTestState(  ) );
        } // end else if
        else if ( state == game.getOverState(  ) ) {
          game.setState( game.getPlayState(  ) );
        } // end else if
        else if ( state == game.getPlayState(  ) ) {
            game.setState( game.getMenuState(  ) );
        } // end else if
      } // end else if
      else if ( e.getKeyCode(  ) == KeyEvent.VK_ESCAPE ) {
        game.setState( game.getLeavingState(  ) );
      } // end else if
    } // end if
  } // end keyPressed()

  /**
   * DOCUMENT ME!
   */
  public void setup(  ) {
	size( screen.width, screen.height, PConstants.OPENGL ); // Must be placed before tacTile to prevent TouchAPI connect failure
    tacTile = new TouchAPI( this, DATA_PORT, MSG_PORT, tacTileHost );
    game = new FoosballGame( this );
  } // end setup()
} // end Main
