

public interface Touchable
{
  public boolean contains( Vector2D touch );
  public void clear( );
  public void touch( int id, Vector2D position, long touchTime, long timeNow );
}
