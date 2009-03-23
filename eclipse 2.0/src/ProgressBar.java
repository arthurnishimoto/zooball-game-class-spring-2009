import processing.core.PApplet;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version $Revision$
 */
public class ProgressBar {
  public static final int LEFT_TO_RIGHT = 0;
  public static final int RIGHT_TO_LEFT = 1;
  private static final int MILLIS = 6000;
  private Vector2D position;
  private Vector2D size;
  private float border;
  private float progress;
  private int direction;

/**
   * Creates a new ProgressBar object.
   *
   * @param x DOCUMENT ME!
   * @param y DOCUMENT ME!
   * @param width DOCUMENT ME!
   * @param height DOCUMENT ME!
   */
  public ProgressBar( float x, float y, float width, float height ) {
    border = 2.0f;
    direction = LEFT_TO_RIGHT;
    position = new Vector2D( x, y );
    size = new Vector2D( width, height );
  } // end ProgressBar()

  /**
   * DOCUMENT ME!
   *
   * @param size DOCUMENT ME!
   */
  public void setBorderSize( float size ) {
    border = size;
  } // end setBorderSize()

  /**
   * DOCUMENT ME!
   *
   * @param direction DOCUMENT ME!
   */
  public void setDirection( int direction ) {
    this.direction = direction;
  } // end setDirection()

  /**
   * DOCUMENT ME!
   *
   * @param p DOCUMENT ME!
   */
  public void draw( PApplet p ) {
    p.noStroke(  );
    p.fill( 255 );
    p.rect( position.x, position.y, size.x, size.y );
    p.fill( 50 );
    p.rect( position.x + border, position.y + border, size.x - border - border,
            size.y - border - border );
    p.fill( 0, 0xCC, 0 );

    if ( direction == LEFT_TO_RIGHT ) {
      p.rect( position.x + border, position.y + border, ( size.x - border - border ) * progress,
              size.y - border - border );
    } // end if
    else {
      p.rect( position.x + size.x, position.y + border,
              ( ( border + border ) - size.x ) * progress, size.y - border - border );
    } // end else
  } // end draw()

  /**
   * DOCUMENT ME!
   *
   * @param timer DOCUMENT ME!
   */
  public void update( Timer timer ) {
    progress = ( timer.getMillisecondsActive(  ) % MILLIS ) / (float) ( MILLIS - 1 );
  } // end update()
} // end ProgressBar
