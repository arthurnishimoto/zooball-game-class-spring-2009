/**
 * ---------------------------------------------
 * Foosbar.pde
 *
 * Description: Foosbar object containing foosmen
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 1.0
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/28/09   - FSM implementation
 * 4/1/09    - "Spring-loaded" foosbar option added
 * 4/3/09    - Added barRotation and support for 360 images
 * 4/10/09   - Basic hit zones added. Bar rotation multipler.
 *           - Ball/bar basic top,left,bottom,right zone collision implemented. Bar at certain angle stops ball
 * 4/16/09   - Fixed "shaky" bar during very low rotation velocities
 * 4/21/09   - Version 0.3 - Revised "Spring-loaded" option for bar rotation. Applies velocity on press release.
 * 4/24/09   - Catch/release ball and associated effects added.
 * 4/29/09   - Version 0.9 - Partial physics integration
 * 6/15/09   - Version 0.9.1 - Left/right bar zones added. Partial "Spring-mode" re-integration
 * 6/19/09   - Version 1.0 - Spring-mode fully integrated. Gestures added: Two-touch to reset bar in full rotation mode.
 * ---------------------------------------------
 */

class Foosbar{
  // Foosman Geometry
  private double FOOSMAN_WIDTH, FOOSMAN_HALF_WIDTH, BALL_RADIUS, BALL_DIAMETER;
  private Vector2D A, B, C, D;
  private double PLAY_FIELD_Z; // negative distance from center of rod to center of ball on field
  private double MIN_ROTATION, MAX_ROTATION, MIN_OFFSET, MAX_OFFSET;
  // FoosBar Physics
  private int current;
  private Vector2D position[]; // x doesn't change
  private Vector2D velocity[]; // x=angular, y=linear
  private float maxAngularVelocity = 200;
  private float maxLinearVelocity = 20000;
  private double rotation[]; // angular rotation, normalized from -pi to pi
  private Vector2D forces; // I don't think this will actually be used
  private Vector2D friction; // Although this is probalby technically incorrect, allow for different friction in different directions
  private double mass, momentOfInertia;
  // Foosmen Instances
  private double[] foosmenPositions;
  private double radius;  

  float xPos, yPos, barWidth, barHeight, yMinTouchArea, yMaxTouchArea;
  color teamColor;
  float buttonPos;
  float buttonValue;
  boolean pressed, active, xSwipe, ySwipe, hasBall, atTopEdge, atBottomEdge;
  boolean centerZonePressed, leftZonePressed, rightZonePressed;
  float centerZoneWidth = 50;
  float xMove, yMove;
  float swipeThreshold = 30.0;
  float sliderMultiplier = 2;
  float rotateMultiplier = 2;
  int nPlayers, zoneFlag;
  MTFinger fingerTest;
  Foosmen[] foosPlayers;
  Ball[] ballArray;
  float spring = 0.01;
  
  int minThrowSpeed = 10; // Minimum x velocity needed to throw ball
  
  // bar Rotation
  float barRotation = 0;
  float rotateVelocity;
  float maxRotateVelocity = 10;
  float barFriction = 0.15;
  boolean isCatching;
  
  // On Fire Debuff
  float orig_sliderMultiplier = sliderMultiplier;
  float orig_rotateMultiplier = rotateMultiplier;
  float debuffDuration = 7;
  float debuffTimer = 0;
  double gameTimer;
  boolean debuffed = false;
  
  // Spring-Mode
  boolean springEnabled = false;
  boolean leftZoneHeld = false;
  boolean rightZoneHeld = false;
  float releaseVelocity = 30;
  
  boolean rotationEnabled = true;

  // Internal tracking of how many touches in a touch zone
  ArrayList touches = new ArrayList();
  
  boolean hasSpecial = true; // If foosbar has special ability ready

  boolean dragons = false;
  boolean tigers = false;

  PImage[] foosmenImages;
  
  int playerWidth = 50;
  int playerHeight = 60;
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  
  //Statistics
  int numStatistics = 20;
  byte[] statistics;
  byte[] record;
  
  /**
   * Setups a new Foosbar object.
   *
   * @param new_xPos- initial x position
   * @param new_yPos - initial y position
   * @param new_barWidth - initial bar zone width
   * @param new_barHeight - initial bar zone height
   * @param players - Number of foosmen on the bar
   * @param tColor - Color of the foosmen
   * @param zoneFlg - Zone flag: 0 = (top half of screen), 1 = (bottom half of screen), else (height of screen)
   */  
  Foosbar(float new_xPos, float new_yPos, float new_barWidth, float new_barHeight, int players, color tColor, int zoneFlg, PImage[] images){
    int foosmen = players;
    float x = new_xPos;
    float y = new_yPos;
    
    // Geometry
    FOOSMAN_WIDTH = 53;
    FOOSMAN_HALF_WIDTH = 26.5;
    BALL_RADIUS = 25;
    BALL_DIAMETER = 50;
    A = new Vector2D( -16, 40 );
    B = new Vector2D( -7, -106 );
    C = new Vector2D( 7, -106 );
    D = new Vector2D( 16, 40 );
    PLAY_FIELD_Z = -68; // This allows for a wider cross-section
    double a = -PLAY_FIELD_Z;
    double h = C.magnitude( );
    MIN_ROTATION = -Math.acos( a/h );
    MAX_OFFSET = Math.sqrt( h*h - a*a );
    h = B.magnitude( );
    MAX_ROTATION = Math.acos( a/h );
    MIN_OFFSET = -Math.sqrt( h*h - a*a );
  
    // instance variables
    if ( foosmen == 1 )
      foosmenPositions = new double[] { 0 };
    else if ( foosmen == 2)
      foosmenPositions = new double[] { -(FOOSMAN_WIDTH + 100), FOOSMAN_WIDTH + 100 };
    else if ( foosmen == 3 )
      foosmenPositions = new double[] { -(FOOSMAN_WIDTH + 165), 0, (FOOSMAN_WIDTH + 165) };
    else if ( foosmen == 4 )
      foosmenPositions = new double[] { -2*(FOOSMAN_WIDTH + 90), -(FOOSMAN_WIDTH + 90), 0, (FOOSMAN_WIDTH + 90), 2*(FOOSMAN_WIDTH + 90) };
    else if ( foosmen == 5 )
      foosmenPositions = new double[] { -2*(FOOSMAN_WIDTH + 90), -(FOOSMAN_WIDTH + 90), 0, (FOOSMAN_WIDTH + 90), 2*(FOOSMAN_WIDTH + 90) };
    else
      throw new IllegalArgumentException("Invalid number of foosmen - " + foosmen + ". Number must be 1, 2, 3, or 5.");
    radius = 0.5 * (foosmenPositions[foosmenPositions.length-1] - foosmenPositions[0] + FOOSMAN_WIDTH);
    position = new Vector2D[] { new Vector2D( x, y ), new Vector2D( x, y ) };
    velocity = new Vector2D[] { new Vector2D( 0, 0 ), new Vector2D( 0, 0 ) };
    rotation = new double[] { 0, 0 };
    forces = new Vector2D( 0, 0 );
    //mass = 35 + foosmen * 5; // mass of bar plus mass of each foosman
    mass = 100 + foosmen * 20;
    friction = new Vector2D( -2 * mass * 500, -0.5 * mass * 500 ); // gravity ~9.8m/s^2 what is that in px/s^2

    double height = 0.5 * ( (A.y - B.y) + (D.y - C.y) );
    double width = 0.5 * ( (D.x - A.x) + (C.x - B.x) );
    momentOfInertia = mass * ( height*height + width*width ) / 12;
    
    xPos = new_xPos;
    yPos = new_yPos;
    barWidth = new_barWidth;
    barHeight = new_barHeight;
    buttonPos = yPos;
    nPlayers = players;
    fingerTest = new MTFinger(new_xPos, new_yPos, 30, null);
    atTopEdge = false;
    atBottomEdge = false;
    teamColor = tColor;
    zoneFlag = zoneFlg;
    foosmenImages = images;
    statistics = new byte[numStatistics];
    record = loadBytes("data/records/"+this.getFoosbarID()+".dat");  
  }// CTOR
  
  public void step( double dt ) {
    // Runge-Kutta Order 4
    Vector2D p1 = new Vector2D( rotation[current], position[current].y );
    Vector2D v1 = velocity[current];
    Vector2D a1 = acceleration( p1, v1 );

    Vector2D p2 = Vector2D.add( p1, Vector2D.scale( v1, 0.5*dt ) );
    Vector2D v2 = Vector2D.add( v1, Vector2D.scale( a1, 0.5*dt ) );
    Vector2D a2 = acceleration( p2, v2 );

    Vector2D p3 = Vector2D.add( p1, Vector2D.scale( v2, 0.5*dt ) );
    Vector2D v3 = Vector2D.add( v1, Vector2D.scale( a2, 0.5*dt ) );
    Vector2D a3 = acceleration( p3, v3 );

    Vector2D p4 = Vector2D.add( p1, Vector2D.scale( v3, dt ) );
    Vector2D v4 = Vector2D.add( v1, Vector2D.scale( a3, dt ) );
    Vector2D a4 = acceleration( p4, v4 );

    int next = current ^ 1;

    // p(n+1) = p(n) + (h/6)*(v1 + 2*v2 + 2*v3 + v4)
    v2.scale( 2 );
    v3.scale( 2 );
    v4.add( v3 );
    v4.add( v2 );
    v4.add( v1 );
    v4.scale( dt / 6.0 );
    position[next].y = position[current].y + v4.y;
    rotation[next] = normalizeRotation( rotation[current] + v4.x );

    // v(n+1) = v(n) + (h/6)*(a1 + 2*a2 + 2*a3 + a4)
    a2.scale( 2 );
    a3.scale( 2 );
    a4.add( a3 );
    a4.add( a2 );
    a4.add( a1 );
    a4.scale( dt / 6.0 );
    velocity[next].set( velocity[current] );
    velocity[next].add( a4 );

    // Velocity might converge to something like, 0.038590812... radians/s so just kill it.
    if ( velocity[current].x == velocity[next].x && Math.abs( velocity[next].x ) < 0.5 )
      velocity[next].x = 0;
    // Velocity might converge to something like, 0.038590812... px/s so just kill it.
    if ( velocity[current].y == velocity[next].y && Math.abs( velocity[next].y ) < 2 )
      velocity[next].y = 0;
    current = next;
  }// step

  private Vector2D acceleration( Vector2D position, Vector2D velocity ) {
    // sliding friction
    Vector2D direction = new Vector2D( velocity.x == 0 ? 0 : velocity.x < 0 ? -1 : 1, velocity.y == 0 ? 0 : velocity.y < 0 ? -1 : 1 );
    return new Vector2D( direction.x * friction.x / momentOfInertia, direction.y * friction.y / mass );
  }// acceleration
  
  /**
   * Setups ball pointers and screen dimentions before bar generation
   */
  void setupBars(int[] screenDim, Ball[] balls){
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    ballArray = balls;
    generateBars(); // Create foosbars after screen/border dimentions are known
  }// setupBars  
  
  /**
   * Creates the foosbars and sets the zones. setupBars() must be called before this. 
   */
  void generateBars(){
    if(zoneFlag == 0){
      if( redTeamTop )
        dragons = true;
      else
        tigers = true;
      yMinTouchArea = borderHeight;
      try{
      yMaxTouchArea = game.getHeight()/2 - borderHeight;
      }catch(Exception e){}
    }else if(zoneFlag == 1){
      if( !redTeamTop )
        dragons = true;
      else
        tigers = true;
      try{
      yMinTouchArea = game.getHeight()/2;
      yMaxTouchArea = game.getHeight()/2 - borderHeight;
      }catch(Exception e){}
    }else{
      yMinTouchArea = 0;
      yMaxTouchArea = game.getHeight();      
    }
    
    foosPlayers = new Foosmen[nPlayers];
    //FoosPlayer( int x, int y, int newWidth, int newHeight, int nBalls, Foosbar parent)
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i] = new Foosmen( xPos, (float)(position[current].y + foosmenPositions[i]), playerWidth, playerHeight, ballArray.length , this);
    }
  }// ScrollBar CTOR
  
  void display(){
    if( position[current].y < 0 || position[current].y > game.getHeight() )
      position[current].y = game.getHeight()/2;    
    
    // Converts physics rotation angle (radians -PI to PI) to Foosmen angle (degrees 0 - 360 );
    if( zoneFlag == 0 )
      barRotation = degrees( -(float)this.getRotation() );
    else if( zoneFlag == 1 )
      barRotation = degrees( (float)this.getRotation() );
    if( barRotation < 0 )
      barRotation += 360;
    
    // Anchors foosmen to position specified by Foosbar
    for( int i = 0; i < nPlayers; i++ ){
      foosPlayers[i].display();
      foosPlayers[i].setPosition( xPos, (float)(position[current].y + foosmenPositions[i]) );
    }
    active = true;
    
    if(debuffed){
      sliderMultiplier = 0.5;
      rotateMultiplier = 0.5;   
      if( debuffTimer < gameTimer ){
        debuffTimer = 0;
        debuffed = false;
      }
    }else{
      sliderMultiplier = orig_sliderMultiplier;
      rotateMultiplier = orig_rotateMultiplier;
    }

    if( hasBall && abs(xMove) > minThrowSpeed )
      for(int i = 0; i < foosPlayers.length; i++)
        foosPlayers[i].releaseBall();

    if(springEnabled){
      // If released, spin
      if( touches.size() == 0 && rightZoneHeld ){
        rightZoneHeld = false;
        setAngularVelocity(releaseVelocity);
      }
      if( touches.size() == 0 && leftZoneHeld ){
        leftZoneHeld = false;
        setAngularVelocity(-releaseVelocity);
      }
      if( touches.size() == 0 && hasBall )
        for(int i = 0; i < foosPlayers.length; i++)
          foosPlayers[i].releaseBall();
    }
      
    if( hasBall )
      this.setRotation(0); // Locks bar rotation if hasBall
  }// display

  void displayStats(){
    fill( 0, 0, 0, 150 );
    rect(xPos - barWidth/2, yMinTouchArea, barWidth, yMaxTouchArea);
    
    textAlign(CENTER);
    fill(teamColor);
    textFont(font,14);
 
    if( zoneFlag == 1){

      text( getFoosbarInfo(), xPos, yMinTouchArea + 32);
    }else if( zoneFlag == 0){
      pushMatrix();
      translate( xPos, yMinTouchArea + yMaxTouchArea - 32);
      rotate( PI );
      text( getFoosbarInfo(),0, 0);
      popMatrix();
    }//
    textAlign(LEFT);
  }// displayStats
  
  void displayZones(){
    noStroke();
    
    // Zone Bar
    //if(pressed)
    //  fill( #00FF00, 50);
    //else if(hasBall)
    //  fill( #FF0000, 50);
    //else
      //fill( #AAFFAA, 50);
    noStroke();
    
    // Left zone (for bottom player) right for top
    if(leftZonePressed){
      fill( #00FF00, 100 ); // temp
    }else
      fill( #AAFFAA, 50);
    rect(xPos - barWidth/2, yMinTouchArea, barWidth/2 - centerZoneWidth/2, yMaxTouchArea);
    
    // Right zone (for bottom player) left for top
    if(rightZonePressed){
      fill( #00FF00, 100 ); // temp
    }else
      fill( #AAFFAA, 50);
    rect(xPos + centerZoneWidth/2, yMinTouchArea, barWidth/2 - centerZoneWidth/2, yMaxTouchArea);
    
    // Center Zone Bar
    if(centerZonePressed)
      fill( #00FFFF, 100);
    else
      fill( #00AAAA, 50);
    rect(xPos - centerZoneWidth/2, yMinTouchArea, centerZoneWidth, yMaxTouchArea);
  }// displayZones
  
  void displayDebug(color debugColor, PFont font){
    // This jumble of code is for debugging... to be able to see what's
    // going on with the physics model behind the foosman sprites.
    double sinTheta = Math.sin( rotation[current] );
    double cosTheta = Math.cos( rotation[current] );
    Vector2D a = rotatePoint( A, sinTheta, cosTheta );
    Vector2D b = rotatePoint( B, sinTheta, cosTheta );
    Vector2D c = rotatePoint( C, sinTheta, cosTheta );
    Vector2D d = rotatePoint( D, sinTheta, cosTheta );
    pushMatrix( );
    translate( (float)position[current].x, (float)position[current].y );
    fill( 0, 0 );
    //*
    stroke( 255, 225, 0 );
    ellipse( 0, 0, (float)(radius+radius), (float)(radius+radius) );
    stroke( 255, 0, 0 );
    rect( (float)MIN_OFFSET, (float)(foosmenPositions[0]-FOOSMAN_HALF_WIDTH), (float)(MAX_OFFSET-MIN_OFFSET), (float)(foosmenPositions[foosmenPositions.length-1]-foosmenPositions[0]+FOOSMAN_WIDTH) );
    stroke( 255, 255, 0 );
    rect( (float)(MIN_OFFSET-BALL_RADIUS), (float)(foosmenPositions[0]-FOOSMAN_HALF_WIDTH-BALL_RADIUS), (float)(MAX_OFFSET-MIN_OFFSET+BALL_DIAMETER), (float)(foosmenPositions[foosmenPositions.length-1]-foosmenPositions[0]+FOOSMAN_WIDTH+BALL_DIAMETER) );
    //*/
    for ( int i = 0; i < foosmenPositions.length; i++ ) {
      pushMatrix( );
      translate( 0, (float)foosmenPositions[i] );
      //*
      // connections
      stroke( 255, 0, 255 );
      line( (float)a.x, (float)FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
      line( (float)c.x, (float)FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
      line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)-FOOSMAN_HALF_WIDTH );
      line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)-FOOSMAN_HALF_WIDTH );      
      if ( rotation[current] < 0.5*Math.PI && rotation[current] > -0.5*Math.PI ) {
        // bottom
        stroke( 0, 0, 255 );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)c.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)b.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
        // top
        stroke( 0, 255, 255 );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)a.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)d.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
      } 
      else {
        // top
        stroke( 0, 255, 255 );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)a.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)d.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)-FOOSMAN_HALF_WIDTH, (float)d.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)a.x, (float)FOOSMAN_HALF_WIDTH, (float)d.x, (float)FOOSMAN_HALF_WIDTH );
        // bottom
        stroke( 0, 0, 255 );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)c.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)-FOOSMAN_HALF_WIDTH );
        line( (float)c.x, (float)FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
        line( (float)b.x, (float)-FOOSMAN_HALF_WIDTH, (float)b.x, (float)FOOSMAN_HALF_WIDTH );
      }
      //*/
      // intersection
      double[] x = intersectionFoosmanX( );
      if( x != null ) {
        stroke( 255, 0, 0 );
        line( (float)(x[0]-position[current].x), (float)-FOOSMAN_HALF_WIDTH, (float)(x[0]-position[current].x), (float)FOOSMAN_HALF_WIDTH );
        line( (float)(x[0]-position[current].x), (float)FOOSMAN_HALF_WIDTH, (float)(x[1]-position[current].x), (float)FOOSMAN_HALF_WIDTH );
        line( (float)(x[0]-position[current].x), (float)-FOOSMAN_HALF_WIDTH, (float)(x[1]-position[current].x), (float)-FOOSMAN_HALF_WIDTH );
        line( (float)(x[1]-position[current].x), (float)-FOOSMAN_HALF_WIDTH, (float)(x[1]-position[current].x), (float)FOOSMAN_HALF_WIDTH );
        stroke( 255, 255, 0 );
        rect( (float)(x[0]-position[current].x-BALL_RADIUS), (float)(-FOOSMAN_HALF_WIDTH-BALL_RADIUS), (float)((x[1]-position[current].x)-(x[0]-position[current].x)+BALL_DIAMETER), (float)(FOOSMAN_WIDTH+BALL_DIAMETER) );
      }
      popMatrix( );
    }
    noStroke( );
    popMatrix( );
    
    fill(debugColor);
    textFont(font,12);
    
    if( debuffTimer - gameTimer > 0)
      text("Debuff Time Remaining "+(debuffTimer - gameTimer), xPos, yPos+barHeight/2-16*10);
    text("Bar Rotation: "+barRotation, xPos, yPos+barHeight/2-16*9);
    text("Rotate Velocity: "+ rotateVelocity, xPos, yPos+barHeight/2-16*8);
    text("Active: "+pressed, xPos, yPos+barHeight/2-16*7);
    text("Y Position: "+position[current].y, xPos, yPos+barHeight/2-16*6);
    text("Movement: "+xMove+" , "+yMove, xPos, yPos+barHeight/2-16*5);
    text("Touches in zone: "+touches.size(), xPos, yPos+barHeight/2-16*11);
    if( barRotation > foosPlayers[0].minStopAngle && barRotation < foosPlayers[0].maxStopAngle )
      text(" CATCHING ", xPos, yPos+barHeight/2-16*4);
    else if( barRotation < 375-foosPlayers[0].minStopAngle && barRotation > 375-foosPlayers[0].maxStopAngle )
      text(" BLOCKING ", xPos, yPos+barHeight/2-16*4);
    text("Players: "+nPlayers, xPos, yPos+barHeight/2-16*3);
    if(atTopEdge)
      text("atTopEdge", xPos, yPos+barHeight/2-16*2);
    else if(atBottomEdge)
      text("atBottomEdge", xPos, yPos+barHeight/2-16*2);
    else if(dragons)
      text("DRAGONS/RED", xPos, yPos+barHeight/2-16*2);
    else if(tigers)
      text("TIGERS/YELLOW", xPos, yPos+barHeight/2-16*2);      
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].displayDebug(debugColor, font);
  }// displayDebug
  
  void displayHitbox(){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].displayHitbox(); 
  }// displayHitbox
 
  public boolean isAbovePlayField( ) {
    return ( rotation[current] < MIN_ROTATION ) || ( rotation[current] > MAX_ROTATION );
  }
  
  // TODO: currently this only works on horizontal wall, generalize it to vertical or angled
  public boolean collide( Line wall ) {
    double pY = wall.getP1( ).y;
    double nY = position[current].y - pY; // normal pointing towards the ball
    
    // check for interpenetration
    if ( nY*nY > radius*radius )
      return false;
    
    // "A collision occurs when a point on one body touches a point on another body with a
    //  negative relative normal velocity."
    if ( velocity[current].y * nY >= 0 ) // relative normal velocity, the wall isn't moving
       return false;
     
    double elasticity = 0.2; // 1 = elastic, 0 = plastic
    //      -(1 + e) * v . n
    //  j = -----------------
    //       n . n  * ( 1/M )
    double impulse = -(1+elasticity) * velocity[current].y * nY / ( nY * nY / mass );
    //              j
    //  vF2 = vF1 + - * n
    //              M
    velocity[current].y += nY * impulse / mass;
    
    nY = nY == 0 ? 0 : nY > 0 ? 1 : -1; // normalize nY
    position[current].y = pY + nY * radius;
    
    return true;
  }
  
   public boolean collide( Ball ball ) {
    // players are rotated above the play field
    if ( isAbovePlayField( ) )
      return false;

    double ballRight = ball.getX( ) + ball.getRadius( );
    double ballLeft = ball.getX( ) - ball.getRadius( );
    // ball outside of bar's reach
    if ( ( ballLeft > position[current].x + MAX_OFFSET ) || ( ballRight < position[current].x + MIN_OFFSET ) )
      return false;
    
    double ballTop = ball.getY( ) - ball.getRadius( );
    double ballBottom = ball.getY( ) + ball.getRadius( );
    double barTop = position[current].y + foosmenPositions[0] - FOOSMAN_HALF_WIDTH;
    double barBottom = position[current].y + foosmenPositions[foosmenPositions.length-1] + FOOSMAN_HALF_WIDTH;
    // ball is above or below bar's players
    if( ballBottom < barTop || ballTop > barBottom )
      return false;
 
    double[] foosmanX = intersectionFoosmanX( ); // the previous checks are to avoid getting the intersection when possible
    double barLeft = foosmanX[0];
    double barRight = foosmanX[1];
    // ball is left or right of bar's players
    if ( ballRight < barLeft || ballLeft > barRight )
      return false;
      
    //  We now know the intersection of the foosmen with the playing field, and that
    //  the ball is inside the smallest bounding box that includes all players.
    //  +---------------+
    //  |               |
    //  |               |
    //  |     +---+     |
    //  |     |   |     |
    //  |     | F |     |
    //  |     |   |     |
    //  |     +---+     |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |     +---+     |
    //  |     |   |     |
    //  |     | F |     |
    //  |     |   |     |
    //  |     +---+     |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |               |
    //  |     +---+     |
    //  |     |   |     |
    //  |     | F |     |
    //  |     |   |     |
    //  |     +---+     |
    //  |               |
    //  |               |
    //  +---------------+
    //  Next we need to check each individual player - one more bounding box.  If the
    //  ball is in this last bounding box, we need to check distance to each line of
    //  the player.
    
    for ( int i = 0; i < foosmenPositions.length; i++ ) {
      // check the last bounding box possible, the one that only includes a single player
      double playerTop = position[current].y + foosmenPositions[i] - FOOSMAN_HALF_WIDTH;
      double playerBottom = position[current].y + foosmenPositions[i] + FOOSMAN_HALF_WIDTH;
      if ( ( ballBottom >= playerTop ) || ( ballTop <= playerBottom ) ) {
        //  Now we know that the ball is inside the player's individual bounding box.
        //  +---------------+
        //  |               |
        //  |               |
        //  |     +---+     |
        //  |     |   |     |
        //  |     | F |     |
        //  |     |   |     |
        //  |     +---+     |
        //  |               |
        //  |               |
        //  +---------------+
        Line[] lines = new Line[4];
        lines[0] = new Line( barLeft, playerTop, barRight, playerTop ); // top of player
        lines[1] = new Line( barLeft, playerBottom, barRight, playerBottom ); // bottom of player
        lines[2] = new Line( barLeft, playerTop, barLeft, playerBottom ); // left of player
        lines[3] = new Line( barRight, playerTop, barRight, playerBottom ); // right of player
        
        //  Ball might interpenetrate the player such that two lines have two different
        //  closest points.  We need to get the closest of these.
        //
        //  L0 = lines[0], CP0 = closest point on L0 to center of ball
        //  L1 = lines[1], CP1 = closest point on L1 to center of ball
        //  L2 = lines[2], CP2 = closest point on L2 to center of ball
        //  L3 = lines[3], CP3 = closest point on L3 to center of ball
        //
        //               /--------------------\
        //              /                      \
        //   +-----L0--/-CP0                    \
        //   |       `/ ``|                      \
        //   |      `/   `|                       \
        //   |      |     |      CENTER            |
        //  CP2     |    CP3       OF              |
        //   |      |     |       BALL             |
        //   |       \    |                       /
        //   L2       \   L3                     /
        //   |         \``|                     /
        //   |          \ |                    /
        //   |           \+-------------------/
        //   |            |
        //   |            |
        //   |            |
        //   +-----L1----CP1
        //
        //  CP0 and CP3 are both inside the ball, but CP3 is closer to the center of the ball.
        //  So use it.
        
        Vector2D ballCenter = ball.getPosition( );
        
        Vector2D[] points = new Vector2D[4];
        points[0] = lines[0].closestPoint( ballCenter );
        points[1] = lines[1].closestPoint( ballCenter );
        points[2] = lines[2].closestPoint( ballCenter );
        points[3] = lines[3].closestPoint( ballCenter );
        
        // assume point[0] is the closest
        Vector2D p = points[0];
        double cd2 = Vector2D.sub( points[0], ballCenter ).magnitudeSquared( ); // cd2 = (closest distance)^2
        // check to see if point[1] is closer
        double d2 = Vector2D.sub( points[1], ballCenter ).magnitudeSquared( ); // d2 = distance^2
        if ( d2 < cd2 ) {
          p = points[1];
          cd2 = d2;
        }
        // check to see if point[2] is closer
        d2 = Vector2D.sub( points[2], ballCenter ).magnitudeSquared( );
        if ( d2 < cd2 ) {
          p = points[2];
          cd2 = d2;
        }
        // check to see if point[3] is closer
        d2 = Vector2D.sub( points[3], ballCenter ).magnitudeSquared( );
        if ( d2 < cd2 ) {
          p = points[3];
          cd2 = d2;
        }
        
               // closest touching the ball
        if ( cd2 <= ball.getRadius( ) * ball.getRadius( ) ) {
          //println("BALL IS TOUCHING FOOSMAN " + (i+1) + " AT TIME: " + game.state.timer.getSecondsActive( ) );
          
          //*
          /////////    HACK FOR FOOSMAN COMING DOWN ON TOP OF BALL    \\\\\\\\\\
          
          int previous = current ^ 1;
          
          if ( rotation[previous] > MAX_ROTATION ) {
            // Foosman just came down from the left side (its moving to the right) and is inside the ball.
            // So move the left side of the ball to the right side of the foosman.
            ballCenter.x = points[3].x + ball.getRadius( );
            ball.setPosition( ballCenter.x, ballCenter.y );
            p = points[3]; // change the point of collision
          }
          // foosman just came down from the left side
          else if ( rotation[previous] < MIN_ROTATION ) {
            // Foosman just came down from the right side (its moving to the left) and is inside the ball.
            // So move the right side of the ball to the left side of the foosman.
            ballCenter.x = points[2].x - ball.getRadius( );
            ball.setPosition( ballCenter.x, ballCenter.y );
            p = points[3]; // change the point of collision
          }
          
          /////////                     END HACK                      \\\\\\\\\\
          //*/
          
          
          // So now we know that the ball and the player are either touching or interpentrating.
          // We need to get their relative normal velocity. If they are moving apart, there is no
          // collision.
          
          Vector2D n = Vector2D.sub( ballCenter, p ); // normal pointing towards the ball
          
          // We need to get the linear velocity for the player. We already have it's y component,
          // but the x component needs to be calculated from it's angular velocity.
          double rFPx = PLAY_FIELD_Z; // This should really be a vector in (x, z), but I just ignore the z and hope for the best
          Vector2D vFP = new Vector2D( velocity[current].x * rFPx, velocity[current].y ); // velocity of foosplayer at p, neglects velocity in z
          Vector2D vBP = ball.getVelocity( ); // velocity of ball at p
          Vector2D vBF = Vector2D.sub( vBP, vFP ); // relative velocity of ball with respect to foosplayer
          
          // "A collision occurs when a point on one body touches a point on another body with a
          //  negative relative normal velocity."
          if ( vBF.dot( n ) >= 0 ) // relative normal velocity
            return false;
            
          //println("BALL IS COLLIDING WITH FOOSMAN " + (i+1) + " AT TIME: " + game.state.timer.getSecondsActive( ) );
          
          // If we got to here, a collision occured!... Now calculate impulse and apply it.
          Vector2D ballVelocity = ball.getVelocity( );
          double elasticity = 0.8;
          double impulse;
          if ( n.y != 0 ) {
            if ( ball.getWallContacts( ).y * n.y >= 0 ) {
              // We don't have to worry about the ball touching the wall. Just apply the impulse to both and be done with it.
              
              //        -(1 + e) * vBF . n
              //  j = ------------------------
              //      n . n  * ( 1/mB + 1/mF )
              impulse = vBF.y * -( 1 + elasticity ) * n.y / ( n.y * n.y * ( 1/mass + 1/ball.getMass( ) ) );
              //              j
              //  vB2 = vB1 + -- * n
              //              mB 
              ballVelocity.y = ballVelocity.y + n.y * impulse / ball.getMass( );
              //              j
              //  vF2 = vF1 - -- * n
              //              mF
              velocity[current].y = velocity[current].y - n.y * impulse / mass;
            }
            else {
              // The ball is touching the wall in the direction we're trying to hit it. We need to apply some trickery.
              // Trickery 1: Lower the elasticity for the ball collision.
              // impulse = vBF.x * -( 1 + elasticity ) * n.x / ( n.x * n.x / ball.getMass( ) + ( rFPdotN * rFPdotN / momentOfInertia ) );
              impulse = vBF.y * -( 1 - 0.1 ) * n.y / ( n.y * n.y * ( 1/mass + 1/ball.getMass( ) ) );
              ballVelocity.y = ballVelocity.y + n.y * impulse / ball.getMass( );
              // Trickery 2: Have the foosman hit a horizontal "wall" at the point on the ball that it really.
              double nY = n.y == 0 ? 0 : n.y > 0 ? 1 : -1; // normalize nY
              double pY = ballCenter.y + ball.getRadius( ) * -nY;
              collide( new Line(0, pY, 1920, pY ) );
              // TODO: Something similar for X
            }
          }
          if ( n.x != 0 ) {
            double rFPdotN = rFPx * n.x; // ignores z of rFP
            if ( ball.getWallContacts( ).x * n.x >= 0 ) {
              // We don't have to worry about the ball touching the wall. Just apply the impulse to both and be done with it.
              
              //                 -(1 + e) * vBF . n
              //  j = ------------------------------------------
              //      n . n  * ( 1/mB ) + ( ( rFP . n )^2 ) / If
              impulse = vBF.x * -( 1 + elasticity ) * n.x / ( n.x * n.x / ball.getMass( ) + ( rFPdotN * rFPdotN / momentOfInertia ) );
              //              j
              //  vB2 = vB1 + -- * n
              //              mB
              ballVelocity.x = ballVelocity.x + n.x * impulse / ball.getMass( );
              //               rFPperp . jn
              //  wF2 = wF1 - --------------    <--- w = angular velocity
              //                     I
              velocity[current].x = velocity[current].x - rFPx * n.x * impulse / momentOfInertia;
            }
            else {
              // The ball is touching the wall in the direction we're trying to hit it. We need to apply some trickery.
              // Trickery 1: Lower the elasticity for the ball collision.
              impulse = vBF.x * -( 1 - 0.5 ) * n.x / ( n.x * n.x / ball.getMass( ) + ( rFPdotN * rFPdotN / momentOfInertia ) );
              ballVelocity.x = ballVelocity.x + n.x * impulse / ball.getMass( );
              // Trickery 2: Just flip the velocity of the foosman and dampen it until I can figure out something better.
              velocity[current].x = -velocity[current].x*0.5;
              // Trickery 3: rotate the player backward to before they hit, to prevent a foosman from passing through the ball.
              rotation[current] = rotation[previous]; // This is not correct, but will fail semi-gracefully... TODO: calculate rotation needed to put the foosbar in the correct spot
            }
          }
          ball.setVelocity( ballVelocity.x, ballVelocity.y );
          
          // TODO: If ball is not touching a wall, move it to touch at point at p. If the ball
          // is touching the wall, move the player to touch at point p.
          
          ball.lastBarHit = this; // Ball records it hit this foosbar
          
          // Stops ball when "wedged" by Foosmen at a certain angle (opposite of catching angle)
          if( barRotation > 300 && barRotation < 315 ){
            if( ball.getSpeed() > 1 )
              ball.stopBall();
          }// stops ball when wedged
          
          // Stops ball when "wedged" by Foosmen at a certain angle
          if( barRotation > foosPlayers[0].minStopAngle && barRotation < foosPlayers[0].maxStopAngle )
            if( ball.getSpeed() > 1 )
              foosPlayers[i].catchBall( ball );
          //if( barRotation < 375-foosPlayers[0].minStopAngle && barRotation > 375-foosPlayers[0].maxStopAngle )
          //  if( ball.getSpeed() > 1 )
          //    foosPlayers[i].catchBall( ball );          
          
          //if( springEnabled && rightZonePressed && zoneFlag == 1)
          //  if( ball.getSpeed() > 1 )
          //    foosPlayers[i].catchBall2( ball.getID() );  
              
          foosPlayers[i].specialCollision( ball );
          
          if( ball.getSpeed() > 0 )
            statistics[2] += 1; // Ball hit
            
          return true;
        }
      }
    }
    
    // ball is not inside any of the players' individual bounding box
    return false;
  }

  //               Z
  //               |
  //               |
  //   A           |           D
  //    \          |          /
  //     \         |         /
  // <----\----position-----/----> X
  //       \       |       /
  // ------(X)-----+-----(X)------ PLAY_FIELD_Z
  //         \     |     /
  //          \    |    /
  //           B___|___C
  //               |
  //               |
  private double[] intersectionFoosmanX( ) {
    // no intersection
    if ( isAbovePlayField( ) )
      return null;
    // intersection at one point - b
    if ( rotation[current] == MAX_ROTATION )
    return new double[] { 
      position[current].x + MIN_OFFSET, position[current].x + MIN_OFFSET                 };
    // intersection at one point - c
    if ( rotation[current] == MIN_ROTATION )
    return new double[] { 
      position[current].x + MAX_OFFSET, position[current].x + MAX_OFFSET                 };
    // intersection at two points - on AB, BC, or CD
    double[] points = new double[2];
    int found = 0;
    double sinTheta = Math.sin( rotation[current] );
    double cosTheta = Math.cos( rotation[current] );
    Vector2D a = rotatePoint( A, sinTheta, cosTheta );
    Vector2D b = rotatePoint( B, sinTheta, cosTheta );
    Vector2D c = rotatePoint( C, sinTheta, cosTheta );
    Vector2D d = rotatePoint( D, sinTheta, cosTheta );
    // AB intersects
    if ( b.y < PLAY_FIELD_Z )
      points[found++] = position[current].x + intersectionLineX( a, b );
    // BC intersects
    if ( ( b.y < PLAY_FIELD_Z ) != ( c.y < PLAY_FIELD_Z ) )
      points[found++] = position[current].x + intersectionLineX( b, c );
    // CD intersects
    if ( c.y < PLAY_FIELD_Z )
      points[found++] = position[current].x + intersectionLineX( c, d );
    return points;
  }

  // \           Z
  //  \          |
  //   \         |
  //    A        |
  //     \       |
  // <----\------+-----------> X
  //       \     |
  // ------(X)---|------------ PLAY_FIELD_Z
  //         \   |
  //          B  |
  //           \ |
  private double intersectionLineX( Vector2D a, Vector2D b ) {
    return ( PLAY_FIELD_Z - a.y ) * ( b.x - a.x ) / ( b.y - a.y ) + a.x;
  }

  private Vector2D rotatePoint( Vector2D p, double sinTheta, double cosTheta ) {
    return new Vector2D( p.x * cosTheta + p.y * sinTheta, p.y * cosTheta - p.x * sinTheta );
  }

  private double normalizeRotation( double r ) {
    while ( r < -Math.PI )
      r += Math.PI + Math.PI;
    while ( r > Math.PI )
      r -= Math.PI + Math.PI;
    return r;
  }

  public Vector2D getPosition( ) { return new Vector2D( position[current] ); }
  public void setPosition( double x, double y ) {
    int previous = current^1;
    position[previous].x = x;
    position[previous].y = y;
    position[current].x = x;
    position[current].y = y;
  }
  public Vector2D getVelocity( ) { return velocity[current]; }
  
  public void setAngularVelocity( double angular ){
    if( angular > maxAngularVelocity )
      angular = maxAngularVelocity;
    else if( angular < -maxAngularVelocity )
      angular = -maxAngularVelocity;
      
    int previous = current^1;
    velocity[previous].x = angular;
    velocity[current].x = angular;  
  }
  
  public void setVelocity( double angular, double linear ) {
    if( angular > maxAngularVelocity )
      angular = maxAngularVelocity;
    else if( angular < -maxAngularVelocity )
      angular = -maxAngularVelocity;
    if( linear > maxLinearVelocity )
      linear = maxLinearVelocity;
    else if( linear < -maxLinearVelocity )
      linear = -maxLinearVelocity;
      
    int previous = current^1;
    velocity[previous].x = angular;
    velocity[previous].y = linear;
    velocity[current].x = angular;
    velocity[current].y = linear;
  }
  public double getRotation( ) { return rotation[current]; }
  public void setRotation( double rotation ) {
    this.rotation[current] = normalizeRotation( rotation );
    this.rotation[current^1] = this.rotation[current];
  }
  
  /**
   * Handles user input and collisions with the screen border
   *
   * @param xCoord - x coordinate of user input
   * @param yCoord - y coordinate of user input
   */
  boolean isHit( float xCoord, float yCoord ){
    if(!active)
      return false;
    double xPos = position[current].x;
    double yPos = position[current].y;
    int sensitivityAdjust = 20; // Adjusts touch drags to a 1-to-1 control

    // Left zone (for bottom player) right for top
    if( xCoord > xPos - barWidth/2 && xCoord < xPos - centerZoneWidth/2 && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea){
      leftZonePressed = true;
    }else
      leftZonePressed = false;
    
    if( xCoord > xPos - centerZoneWidth/2 && xCoord < xPos + centerZoneWidth/2 && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea){
      centerZonePressed = true;
    }else
      centerZonePressed = false;
      
    // Right Zone
    if( xCoord > xPos + centerZoneWidth/2 && xCoord < xPos + barWidth/2 && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea){
      rightZonePressed = true;
    }else
      rightZonePressed = false;
    
    // Entire Zone
    if( xCoord > xPos - barWidth/2 && xCoord < xPos + barWidth/2 && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea){
      fingerTest.xMove = xCoord-fingerTest.xPos;
      fingerTest.yMove = yCoord-fingerTest.yPos;
        
      fingerTest.xPos = xCoord;
      fingerTest.yPos = yCoord;
      
      // Tracks the current velocity of a touch
      if( abs(fingerTest.xMove-xMove) < 100) // Prevents sudden sliding of bar
        xMove = fingerTest.xMove;
      if( abs(fingerTest.yMove-yMove) < 100) // Prevents sudden sliding of bar
        yMove = fingerTest.yMove*sliderMultiplier;
      
      if( abs(xMove) > 100 ){
        xMove = 0;
        return false;
      }
      if( abs(yMove) > 100 ){
        yMove = 0;
        return false;
      }
      
      // Set rotational behaviour of bar based on control mode
      if( springEnabled ){
        if( rightZonePressed ){
          this.setRotation(-44.7);
          rotateVelocity = 0;
          rightZoneHeld = true;
        }
        else if( leftZonePressed ){
          this.setRotation(44.7);
          rotateVelocity = 0;
          leftZoneHeld = true;
        }
      }// if spring enabled
      else if( rotationEnabled ){
        rotateVelocity = -(xMove) * rotateMultiplier;
      }// else if rotation enabled
      else{ // Fixed bar mode
        this.setRotation(0);
        rotateVelocity = 0;
      }
      
      // Set sliding velocity of bar
      this.setVelocity( rotateVelocity , yMove * sensitivityAdjust * sliderMultiplier );

      pressed = true;
      return true;
    }// if x, y in area
    pressed = false;
    return false;
  }// isHit
  
  ArrayList touchListIDs = new ArrayList();
  
  // Essentionally a copy of isHit but can calculate multiple touches accuratly
  boolean checkForTouches(ArrayList touchList, boolean isManagedListEmpty){
    if( touchList == null ){
      touches.clear();
      pressed = false;
      return false;
    }else if( isManagedListEmpty && touchList.size() > 0 ) // Prevents last active touch from becoming active for a second
                    touchList.clear();
    //println("Foosbar::checkForTouches() called");
    if(!active)
      return false;
    touchListIDs.clear();
    double xPos = position[current].x;
    double yPos = position[current].y;
    int sensitivityAdjust = 20; // Adjusts touch drags to a 1-to-1 control

    for ( int index = 0; index < touchList.size(); index ++ ){
      //Grab a touch
      Touches curTouch = (Touches) touchList.get(index);
      
      //Grab data
      float xCoord = curTouch.getXPos() * width;    
      float yCoord = height - curTouch.getYPos() * height;
    
      //Get finger ID
      int finger = curTouch.getFinger();
      
      touchListIDs.add((float)finger);
      // Touches in whole touch zone      
      if( xCoord > xPos - barWidth/2 && xCoord < xPos + barWidth/2 && yCoord > yMinTouchArea && yCoord < yMinTouchArea+yMaxTouchArea){
        if( !(touches.contains((float)finger)) ){
          touches.add((float)finger);
        }
                  
      }// if touch on object
      //println( touchListIDs );
      for( int i = 0; i < touches.size(); i++ ){
        if( !touchListIDs.contains( touches.get(i) ) )
          touches.remove(i);
      }
      
      // Reset bar on two or more touches
      if( touches.size() >= 2 ){
        this.setRotation(0);
        rotateVelocity = 0;
        xMove = 0; // Stops spinning on release      
      }else{
        isHit(xCoord,yCoord);
      }
    }// for touchList
    pressed = false;
    return false;
  }// checkForTouches
  
  /**
   * Checks if ball is inside Foosbar touch zone.
   * Formally used to flick balls in area.
   *
   * @param balls - Array of ball objects
   */  
  boolean ballInArea(Ball[] balls){
    /*
    for( int i = 0; i < balls.length; i++ ){
      if( !balls[i].isActive() )
        return false;
      if( balls[i].xPos > xPos && balls[i].xPos < xPos + barWidth ){
        hasBall = true;

        if(pressed){ // If ball is in area and user flicks in area
          if( xMove > 0 && balls[i].xVel > 0){
            balls[i].xVel += xMove; // Add speed to same direction right (+x)
          }else if( xMove < 0 && balls[i].xVel < 0){
            balls[i].xVel -= xMove; // Add speed to same direction left (-x)
          }else if( xMove > 0 && balls[i].xVel < 0){ // if ball +x and swipe -x
            balls[i].xVel = xMove; // Set ball and speed in direction of swipe
          }else if( xMove < 0 && balls[i].xVel > 0){ // if ball -x and swipe +x
            balls[i].xVel = xMove; // Set ball and speed in direction of swipe
          }else if( xMove == 0 ){ // Block the ball
            //balls[i].xVel *= -1; // Bounce
            //balls[i].xVel /= 2; 
          }// if-else
        }// if pressed
        
        return true;
      }// if
    }// for
    hasBall = false;
    */
    return false;
  }// ballInArea
  
  boolean collide(Ball[] balls){
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].collide(balls);
    return false;
  }// collide
 
  void reset(){
    pressed = false;
    //xMove = 0;
    //yMove = 0;
  }// reset
  
  // Setters and Getters
  
  void setButtonPos(float pos){
    buttonPos = -1*(yPos*pos-barWidth*pos-barHeight*pos-yPos);
    buttonValue = (yPos-buttonPos)/(yPos-barWidth-barHeight); // Update debug display
  }// setButtonPos
  
  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
    for( int i = 0; i < nPlayers; i++ )
        foosPlayers[i].setGameTimer(timer_g);
  }// setGameTimer
  
  void setSpringEnabled(boolean enable){
    springEnabled = enable;
  }// setSpringEnabled
  
  void setRotationEnabled(boolean enable){
    rotationEnabled = enable;
  }// setRotationEnabled 
  
  void setBarSlideMultiplier(float newVal){
    sliderMultiplier = newVal;
    orig_sliderMultiplier = newVal;
  }// setBarSlideMultiplier

  void setBarRotateMultiplier(float newVal){
    rotateMultiplier = newVal;
    orig_rotateMultiplier = newVal;
  }// setBarRotateMultiplier
  
  void setMinStopAngle(int newVal){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].setMinStopAngle(newVal);
  }// setMinStopAngle
  
  void setMaxStopAngle(int newVal){
    for( int i = 0; i < nPlayers; i++ )
      foosPlayers[i].setMaxStopAngle(newVal);
  }// setMaxStopAngle
  
  void setDebuff(){
    debuffTimer = debuffDuration + (float)gameTimer;
    debuffed = true;
  }// setDebuff 
    
  float getBarSlideMultiplier(){
    return sliderMultiplier;
  }// getBarSlideMultiplier
  
  float getBarRotateMultiplier(){
    return rotateMultiplier;
  }// getBarRotateMultiplier  
  
  boolean isSpringEnabled(){
    return springEnabled;
  }// isSpringEnabled
  
  boolean isRotationEnabled(){
    return rotationEnabled;
  }// isRotationEnabled
  
  boolean isDragon(){
    return dragons;
  }// isDragon
  
  boolean isTiger(){
    return tigers;
  }// isTiger
  
  int getMinStopAngle(){
    for( int i = 0; i < nPlayers; i++ )
      return foosPlayers[i].getMinStopAngle();
    return 0;
  }// getMinStopAngle
  
  int getMaxStopAngle(){
    for( int i = 0; i < nPlayers; i++ )
      return foosPlayers[i].getMaxStopAngle();
    return 0;
  }// getMaxStopAngle

  int getFoosbarID(){
    if( (redTeamTop && zoneFlag == 0) || (!redTeamTop && zoneFlag == 1) ){
      switch(nPlayers){
        case(1):
          return 0;
        case(2):
          return 1;
        case(3):
          return 3;
        case(5):
          return 2;
        default:
          return -1;    
      }// switch      
    }else if( (redTeamTop && zoneFlag == 1) || (!redTeamTop && zoneFlag == 0) ){
      switch(nPlayers){
        case(1):
          return 4;
        case(2):
          return 5;
        case(3):
          return 7;
        case(5):
          return 6;
        default:
          return -1;    
      }// switch      
    }
    return -1;
  }// getFoosbarID
  
  
  Foosbar getFoosbar(){
    return this;
  }// getFoosbar
  
  void updateFoosbarRecord(){
    if( statistics[0] > record[0] )
      record[0] = statistics[0];
    if( statistics[1] > record[1] )
      record[1] = statistics[1];
    if( statistics[2] > record[2] )
      record[2] = statistics[2];
    if( statistics[3] > record[3] )
      record[3] = statistics[3];
    if( statistics[4] > record[4] )
      record[4] = statistics[4];
    if( statistics[5] > record[5] )
      record[5] = statistics[5];
    if( statistics[6] > record[6] )
      record[6] = statistics[6];
    saveBytes("data/records/"+this.getFoosbarID()+".dat", record);
  }// updateFoosbarRecord
  
  String getFoosbarInfo(){
    if( record == null ){
      saveBytes("data/records/"+this.getFoosbarID()+".dat", statistics);
      record = loadBytes("data/records/"+this.getFoosbarID()+".dat");  
    }else
      record = loadBytes("data/records/"+this.getFoosbarID()+".dat"); 
    
    String output = "";
    
    output += this;    
    output += "\nCurrent Game Statistics\n";
    output += "Goals scored: " + statistics[0];
    if( statistics[0] > record[0] )
      output += " NEW!";
    output += "\nGoals scored on own team: " + statistics[1];
    if( statistics[1] > record[1] )
      output += " NEW!";
    output += "\nBall hits: " + statistics[2];
    if( statistics[2] > record[2] )
      output += " NEW!";
    output += "\nBall stops: " + statistics[3];
    if( statistics[3] > record[3] )
      output += " NEW!";
    output += "\nBalls caught: " + statistics[4];
    if( statistics[4] > record[4] )
      output += " NEW!";
    if( isTiger() )
      output += "\nDragons Tricked: " + statistics[5];
    if( statistics[5] > record[5] )
      output += " NEW!";
    if( isDragon() )
      output += "\nTigers set on fire: " + statistics[6];
    if( statistics[6] > record[6] )
      output += " NEW!";
    output += "\nBoosters used: " + statistics[7];
    if( statistics[7] > record[7] )
      output += " NEW!";
    
    output += "\n\n\n\nAll-Time Records\n\n";
    output += "Goals scored: " + record[0] + "\n";
    output += "Goals scored on own team: " + record[1] + "\n";
    output += "Ball hits: " + record[2] + "\n";
    output += "Ball stops: " + record[3] + "\n";
    output += "Balls caught: " + record[4] + "\n";
    if( isTiger() )
      output += "Dragons Tricked: " + record[5] + "\n";
    if( isDragon() )
      output += "Tigers set on fire: " + record[6] + "\n";    
    output += "Boosters used: " + record[7];
    
    return output;
  }// getFoosbarInfo
  
  public String toString(){
    String output = "";
    
    // Team Name
    if( redTeamTop && zoneFlag == 0)
      output += "Dragons ";
    else if ( redTeamTop && zoneFlag == 1)
      output += "Tigers ";
    else if( !redTeamTop && zoneFlag == 1)
      output += "Dragons ";
    else if ( !redTeamTop && zoneFlag == 0)
      output += "Tigers ";
      
    // Position
    switch(nPlayers){
      case(1):
        output += "Goalkeeper\n";
        break;
      case(2):
        output += "Defense\n";
        break;
      case(3):
        output += "Attack\n";
        break;
      case(5):
        output += "Midfield\n";
        break;
      default:
        output += "UNKNOWN POSITION\n";
        break;      
    }// switch
    return output;
  }//toString()
 
}// class Foosbar

