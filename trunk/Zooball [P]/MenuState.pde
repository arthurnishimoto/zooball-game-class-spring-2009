class MenuState extends GameState
{
  public MenuState( Game game ) {
    super( game );
  }
  
  public void load( ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 5;
    Random r = new Random(  );

    for ( int i = 0; i < max; i++ )
      r.nextDouble(  );

    super.load( );
  }
  
  public void draw( ) {
    drawBackground( );
  }
  
  private void drawBackground( ) {
    background( 0x00, 0x33, 0x66 ); // blue
  }
}
