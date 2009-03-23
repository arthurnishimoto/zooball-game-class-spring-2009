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
  private Game game;
  private TouchAPI tacTile;

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
    game.loop( this, tacTile );
  } // end draw()

  /**
   * DOCUMENT ME!
   *
   * @param e DOCUMENT ME!
   */
  public void keyPressed( KeyEvent e ) {
    if ( game != null ) {
      if ( e.getKeyChar(  ) == 'd' ) {
        game.toggleDebugMode(  );
      } // end if
      else if ( game.isDebugMode(  ) && ( e.getKeyChar(  ) == 's' ) ) {
        GameState state = game.getGameState(  );

        if ( state == game.getMenuState(  ) ) {
          game.setState( game.getPlayState(  ) );
        } // end if
        else if ( state == game.getPlayState(  ) ) {
          game.setState( game.getPausedState(  ) );
        } // end else if
        else if ( state == game.getPausedState(  ) ) {
          game.setState( game.getOverState(  ) );
        } // end else if
        else if ( state == game.getOverState(  ) ) {
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
    // I haven't been able to get the TouchAPI to run in eclipse
    //tacTile = new TouchAPI( this, DATA_PORT, MSG_PORT, tacTileHost );
    size( screen.width, screen.height, PConstants.OPENGL );
    game = new Game( this );
  } // end setup()
} // end Main
