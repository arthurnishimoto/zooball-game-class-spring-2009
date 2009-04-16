package ise.foosball;

import ise.objects.Ball;
import ise.utilities.Timer;
import processing.core.PApplet;

public class PingPongBall extends Ball {

	  public PingPongBall( PApplet p, Timer timer, float x, float y ) {
			super(p, timer, x, y, 30, 0.1f);
		    color = p.color(255, 255, 255);
		  } // end Ball()

}
