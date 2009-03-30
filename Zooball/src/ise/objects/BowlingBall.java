package ise.objects;

import ise.utilities.Timer;
import processing.core.PApplet;

public class BowlingBall extends Ball {

	  public BowlingBall( PApplet p, Timer timer, float x, float y ) {
			super(p, timer, x, y, 30, 10f);
		    color = p.color(0, 0, 0);
		  } // end Ball()

}
