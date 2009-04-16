package ise.foosball;

import java.util.ArrayList;

import ise.game.GameState;

import ise.utilities.Timer;

import processing.core.PApplet;

import tacTile.net.TouchAPI;
import tacTile.net.Touches;


/**
 * TODO: DOCUMENT ME!
 *
 * @author Andy Bursavich
 * @version 0.1
 */
public class FoosballPlayState implements GameState {
  private FoosballGame game;
  private PApplet p;
  private Timer timer;

/**
   * Creates a new FoosballPlayState object.
   *
   * @param p DOCUMENT ME!
   * @param game DOCUMENT ME!
   */
  public FoosballPlayState( PApplet p, FoosballGame game ) {
    this.p = p;
    this.game = game;
    timer = new Timer(  );
  } // end FoosballPlayState()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void draw(  ) {
    p.background( 20, 200, 20 );
    game.addDebugLine("Play Time: " + timer.getTimeActive());
  } // end draw()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void enter(  ) {
    timer.setActive( true );
  } // end enter()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void exit(  ) {
    timer.setActive( false );
  } // end exit()
  
  public void init(  ) {
	  timer.reset();
  }

  /**
   * TODO: DOCUMENT ME!
   *
   * @param tacTile DOCUMENT ME!
   */
  @Override
  public void input( TouchAPI tacTile ) {
	  // Process mouse if clicked
	  if(p.mousePressed){
		float xCoord = p.mouseX;    
		float yCoord = p.mouseY;
			
		//Draw mouse
		p.fill( 255,0,0 );
		p.stroke( 255,0,0 );
		p.ellipse( xCoord, yCoord, 20, 20 );
        p.noStroke(); // Prevents draw finger from affecting later draw calls
        
	    // ANY CHANGES HERE MUST BE COPIED TO TOUCH ELSE-IF BELOW
	    //p.checkButtonHit(xCoord,yCoord, 1, 0.5);
	  }// if mousePressed
	  
	  //Process touches off the managedList if there are any touches.
	  else if ( ! tacTile.managedListIsEmpty() ){
	    // Grab the managedList
		ArrayList touchList = tacTile.getManagedList();
	    // Cycle though the touches 
		for ( int index = 0; index < touchList.size(); index ++ ){
			//Grab a touch
			Touches curTouch = (Touches) touchList.get(index);

			//Grab data
			float xCoord = curTouch.getXPos() * p.width;    
			float yCoord = p.height - curTouch.getYPos() * p.height;

	  		//Get finger ID
			int finger = curTouch.getFinger();
	        float intensity = curTouch.getIntensity();
			
			//Draw finger 
			p.fill( 255,0,0 );
			p.stroke( 255,0,0 );
			p.ellipse( xCoord, yCoord, 20, 20 );
	        p.noStroke(); // Prevents draw finger from affecting later draw calls
	        
	        // ANY CHANGES HERE MUST BE COPIED TO MOUSE IF ABOVE
	        //p.checkButtonHit(xCoord, yCoord, finger, intensity);
		}// for touchList
	  }// if tacTileList empty else
	  // Events that occur during every loop

  }// end input()

  /**
   * TODO: DOCUMENT ME!
   *
   * @return DOCUMENT ME!
   */
  public String toString(  ) {
    return "Foosball Play State - Touch Test";
  } // end toString()

  /**
   * TODO: DOCUMENT ME!
   */
  @Override
  public void update(  ) {
    timer.update(  );
  } // end update()
} // end FoosballPlayState
