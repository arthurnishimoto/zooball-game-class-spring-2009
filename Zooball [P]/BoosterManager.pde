class BoosterManager{
  private Booster[] boosters;
  int nBoosters = 12;
  int difficultyLevel;
  
  final static int EASY = 1;
  final static int MEDIUM = 2;
  final static int HARD = 3;
  
  float FIELD_LEFT, FIELD_RIGHT, FIELD_TOP, FIELD_BOTTOM, ZONE_WIDTH;
    
  BoosterManager(int level, float[] fieldDimensions){
    difficultyLevel = level;
    FIELD_LEFT = fieldDimensions[0];
    FIELD_RIGHT = fieldDimensions[1];
    FIELD_TOP = fieldDimensions[2];
    FIELD_BOTTOM = fieldDimensions[3];
    ZONE_WIDTH = fieldDimensions[4];
    generateBoosters();
  }// CTOR
  
  private void generateBoosters(){
    switch(difficultyLevel){
      case(EASY):
        boosters = new Booster[12];
        boosters[0] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_TOP+150, new Vector2D( 0, 1500 ) );
        boosters[1] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_TOP+150, new Vector2D( 0, 1500 ) );
        boosters[2] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_BOTTOM-150, new Vector2D( 0, -1500 ) );
        boosters[3] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_BOTTOM-150, new Vector2D( 0, -1500 ) );
        boosters[4] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_TOP+315, new Vector2D( -1200, 900 ) );
        boosters[5] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_TOP+315, new Vector2D( 1200, 900 ) );
        boosters[6] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_BOTTOM-315, new Vector2D( -1200, -900 ) );
        boosters[7] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_BOTTOM-315, new Vector2D( 1200, -900 ) );
        boosters[8] = new BoosterCorner( FIELD_LEFT, FIELD_TOP, 90, 250, new Vector2D( 80, 80 ) );
        boosters[9] = new BoosterCorner( FIELD_LEFT, FIELD_BOTTOM, 90, -250, new Vector2D( 80, -80 ) );
        boosters[10] = new BoosterCorner( FIELD_RIGHT, FIELD_TOP, -90, 250, new Vector2D( -80, 80 ) );
        boosters[11] = new BoosterCorner( FIELD_RIGHT, FIELD_BOTTOM, -90, -250, new Vector2D( -80, -80 ) );
        break;
      case(MEDIUM):
        boosters = new Booster[0];
        break;
      case(HARD):
        boosters = new Booster[12];
        boosters[0] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_TOP+150, new Vector2D( 0, -1500 ) );
        boosters[1] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_TOP+150, new Vector2D( 0, -1500 ) );
        boosters[2] = new BoosterStrip( FIELD_LEFT + 3*ZONE_WIDTH, FIELD_BOTTOM-150, new Vector2D( 0, 1500 ) );
        boosters[3] = new BoosterStrip( FIELD_RIGHT - 3*ZONE_WIDTH, FIELD_BOTTOM-150, new Vector2D( 0, 1500 ) );
        boosters[4] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_TOP+315, new Vector2D( 1200, -900 ) );
        boosters[5] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_TOP+315, new Vector2D( -1200, -900 ) );
        boosters[6] = new BoosterStrip( FIELD_LEFT + 1.5*ZONE_WIDTH, FIELD_BOTTOM-315, new Vector2D( 1200, 900 ) );
        boosters[7] = new BoosterStrip( FIELD_RIGHT - 1.5*ZONE_WIDTH, FIELD_BOTTOM-315, new Vector2D( -1200, 900 ) );
        boosters[8] = new BoosterCorner( FIELD_LEFT, FIELD_TOP, 90, 250, new Vector2D( 80, 80 ) );
        boosters[9] = new BoosterCorner( FIELD_LEFT, FIELD_BOTTOM, 90, -250, new Vector2D( 80, -80 ) );
        boosters[10] = new BoosterCorner( FIELD_RIGHT, FIELD_TOP, -90, 250, new Vector2D( -80, 80 ) );
        boosters[11] = new BoosterCorner( FIELD_RIGHT, FIELD_BOTTOM, -90, -250, new Vector2D( -80, -80 ) );
        break;
      default:
        println("Warning: Invalid booster difficulty specified - Level:"+difficultyLevel+".");
        break;
    }// switch
  }// generateBoosters()
  
  public void display(){
    for ( int i = 0; i < boosters.length; i++ )
      boosters[i].draw( );
  }// display
  
  public void displayDebug(){
    for ( int i = 0; i < boosters.length; i++ )
      boosters[i].drawDebug( );
  }// displayDebug
  
  public Booster[] getBoosters(){
    return boosters;
  }// getBoosters
  
}// class BoosterManager
