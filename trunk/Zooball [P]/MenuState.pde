/**
 * Menu GameState.
 *
 * Author:  Andy Bursavich
 * Version: 0.3
 */
class MenuState extends GameState
{
  private CircularButton zooballLogo, zooballLogo_dragon, zooballLogo_tiger, zooballLogo_start;
  private Button bottomDragon, bottomTiger, topDragon, topTiger;
  boolean topChosen = false;
  boolean bottomChosen = false;
  boolean topDragonTeam = false;
  boolean bottomDragonTeam = false;
  boolean topTigerTeam = false;
  boolean bottomTigerTeam = false;
  boolean playEnabled = false;
  
  public MenuState( Game game ) {
    super( game );
  }// CTOR
  
  public void load( ) {
    // spin a while to test the loading screen
    int max = Integer.MAX_VALUE >> 6;
    Random r = new Random( );
    
    for ( int i = 0; i < max; i++ )
      r.nextDouble( );   

    zooballLogo = new CircularButton("data/ui/logos/zooball.png");
    zooballLogo.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo.setRadius( 393/2 );
    
    zooballLogo_dragon = new CircularButton("data/ui/logos/zooball_dragons.png");
    zooballLogo_dragon.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo_dragon.setRadius( 393/2 );
    
    zooballLogo_tiger = new CircularButton("data/ui/logos/zooball_tigers.png");
    zooballLogo_tiger.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo_tiger.setRadius( 393/2 );
    
    zooballLogo_start = new CircularButton("data/ui/logos/zooball_ready.png");
    zooballLogo_start.setPosition( game.getWidth()/2, game.getHeight()/2 );
    zooballLogo_start.setRadius( 393/2 );  
    
    bottomDragon = new Button( 50 + 469, (int)game.getHeight() - 161, "data/ui/buttons/dragons/disabled.png");
    bottomDragon.setLitImage( loadImage("data/ui/buttons/dragons/enabled.png") );
    bottomTiger = new Button( (int)game.getWidth() - 50 - 469, (int)game.getHeight() - 161, "data/ui/buttons/tigers/disabled.png");
    bottomTiger.setLitImage( loadImage("data/ui/buttons/tigers/enabled.png") );
 
    topDragon = new Button( (int)game.getWidth() - 50 - 469, 161, "data/ui/buttons/dragons/disabled.png");
    topDragon.setLitImage( loadImage("data/ui/buttons/dragons/enabled.png") );
    topDragon.setRotation( PI );
    topTiger = new Button( 50 + 469, 161, "data/ui/buttons/tigers/disabled.png");
    topTiger.setLitImage( loadImage("data/ui/buttons/tigers/enabled.png") );
    topTiger.setRotation( PI );
    
    endLoad( );
  }// load
  
  public void update( ) {
    super.update( );
    //if ( timer.getSecondsActive( ) > 5.0 )
    //  game.setState( game.getPlayState( ) );
  }// update
  
  public void draw( ) {
    drawBackground( );
    drawButtons();

    if( bottomDragonTeam && topTigerTeam ){
      zooballLogo_start.draw();
      redTeamTop = false;
      playEnabled = true;
    }
    else if( topDragonTeam && bottomTigerTeam ){
      zooballLogo_start.draw();
      redTeamTop = true;
      playEnabled = true;
    } 
    
    else if( bottomTigerTeam || topTigerTeam ){
      zooballLogo_tiger.draw();
      playEnabled = false;
    }else if( bottomDragonTeam || topDragonTeam ){
      zooballLogo_dragon.draw();
      playEnabled = false;
    }else{
      zooballLogo.draw();
      playEnabled = false;
    }
    drawDebugText( );
  }// draw
  
  private void drawBackground( ) {
    background( 0 );
    //fill( 0x00, 0x33, 0x66 ); // blue
    fill( 250, 161, 36 ); // 
    rect( 0, 0, game.getWidth( ), game.getHeight( ) );
  }// drawBackground
  
  private void drawButtons(){
    bottomTiger.process(font, timer.getSecondsActive());
    bottomTiger.setLit( (bottomChosen && bottomTigerTeam) );
    bottomDragon.process(font, timer.getSecondsActive());
    bottomDragon.setLit( (bottomChosen && bottomDragonTeam) );
    
    topTiger.process(font, timer.getSecondsActive());
    topTiger.setLit( (topChosen && topTigerTeam) );
    topDragon.process(font, timer.getSecondsActive());
    topDragon.setLit( (topChosen && topDragonTeam) );
  }// drawButtons
  
  private void drawDebugText( ) {
    game.drawDebugText( "State: " + this + "\nFrame rate: " + new DecimalFormat("0.0").format(frameRate) + "\nSeconds: " + timer.getSecondsActive() );
  }// drawDebugText
  
  public String toString( ) { return "MenuState"; }
  
  public void checkButtonHit(float x, float y, int finger){
    if( zooballLogo.contains(x,y) && playEnabled ){
      game.reloadState( game.getPlayState() );
      game.setState( game.getPlayState() );
    }
    if( bottomDragon.isHit(x,y) ){
      bottomChosen = true;
      bottomDragonTeam = true;
      bottomTigerTeam = false;
    }if( bottomTiger.isHit(x,y) ){
      bottomChosen = true;
      bottomDragonTeam = false;
      bottomTigerTeam = true;
    }
    if( topDragon.isHit(x,y) ){
      topChosen = true;
      topTigerTeam = false;
      topDragonTeam = true;
    }if( topTiger.isHit(x,y) ){
      topChosen = true;
      topTigerTeam = true;
      topDragonTeam = false;
    }      
  }// checkButtonHit
  
}// class MenuState
