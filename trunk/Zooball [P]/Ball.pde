/**
 * --------------------------------------------- 
 * Ball.pde
 * 
 * Description: Ball object.
 * 
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 1.0
 * 
 * Version Notes:
 * 3/1/09    - Initial version
 * 3/18/09   - Version 0.2 - Initial FSM conversion
 * 3/25/09   - Version 0.3 - Encapsulation fixes for code clarity and easier Java conversion
 * 3/28/09   - displayDebug now takes in a color and font as parameters.
 * 4/1/09    - Ball image support added. Ball image rotates based on ball vector
 *           - Bouncing ball issue at very low velocities fixed.
 * 4/9/09    - Ball rolling animations implemented
 * 4/19/09   - Fireball state added
 *           - [Fixed] If ball gets stuck in screenBorder, ball "pushes" itself out.
 * 4/29/09   - Version 1.0 (Alpha) Physics Implementation
 * --------------------------------------------- 
 */
 
class Ball{
  boolean hasArtwork = false;
  
  int state;
  final static int INACTIVE = 0;
  final static int ACTIVE = 1;
  final static int FIREBALL = 2;
  final static int DECOYBALL = 3;  
  final static int DRUNKBALL = 4;    
  
  float friction = 0.001;
  float xPos, yPos, xVel, yVel, vel, angle;
  float maxVel;
  float diameter;
  int ID_no;
  Ball[] others;
  color ballColor = color(255,255,255);
  
  int screenWidth, screenHeight, borderWidth, borderHeight;
  double gameTimer;
  float fireballDuration = 5;
  float fireballTimer = 0;
  
  Foosbar lastBarHit;
  Foosbar specialSource;
  
  private int current;
  private Vector2D position[];
  private Vector2D velocity[];
  private double direction[];
  private double rotation[];
  private Vector2D forces, wallContacts;
  private double mass, inverseMass, radius, fC;  
  private Image[] images;
  private Image shadow;
  
  /**
   * Creates a new Ball object.
   *
   * @param newX - initial x position
   * @param newY - initial y position
   * @param newDiameter - initial diameter
   * @param ID - unique Ball ID
   * @param otr - Array of all other Ball objects for collision purposes
   * @param screenDim - Screen and border parameters for edge collision
   */
  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr, int[] screenDim){
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    
    state = INACTIVE; // Initial state
    xPos = newX;
    yPos = newY;
    xVel = random(5) + -1*random(5);
    yVel = random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
    hasArtwork = false;
    lastBarHit = null;
    specialSource = null;
    
    current = 0;
    position = new Vector2D[] { new Vector2D( newX, newY ), new Vector2D( newX, newY ) };
    velocity = new Vector2D[] { new Vector2D( 0, 0 ), new Vector2D( 0, 0 ) };
    direction = new double[] { 0, 0 };
    rotation = new double[] { 0, 0 };
    forces = new Vector2D( 0, 0 );
    wallContacts = new Vector2D( 0, 0 );
    mass = 5;
    inverseMass = 1 / mass;
    radius = 25;
    // Friction = -mu * mass * gravity * (velocity / |velocity|)
    // fC = -mu * mass * gravity;
    fC = -0.05 * mass * 500; // gravity ~9.8m/s^2 what is that in px/s^2
  }// Ball CTOR
  
  /**
   * Creates a new Ball object with images
   *
   * @param newX - initial x position
   * @param newY - initial y position
   * @param newDiameter - initial diameter
   * @param ID - unique Ball ID
   * @param otr - Array of all other Ball objects for collision purposes
   * @param screenDim - Screen and border parameters for edge collision
   */
  Ball(float newX, float newY, float newDiameter, int ID, Ball[] otr, int[] screenDim, PImage[] newImages){
    // Sets the screen size and border size - Used for edge collision
    screenWidth = screenDim[0];
    screenHeight = screenDim[1];
    borderWidth = screenDim[2];
    borderHeight = screenDim[3];
    
    state = INACTIVE; // Initial state
    xPos = newX;
    yPos = newY;
    xVel = random(5) + -1*random(5);
    yVel = random(5) + -1*random(5);
    diameter = newDiameter;
    ID_no = ID;
    others = otr;
    hasArtwork = true;
    lastBarHit = null;
    specialSource = null;
    
    images = new Image[25];
    for ( int i = 0; i < 25; i++ ) {
      images[i] = new Image( "objects/ball/" + i + ".gif" );
      images[i].setSize( 50, 50 );
      images[i].setPosition( -25, -25 );
    }
    shadow = new Image( "objects/ball/shadow.png" );
    shadow.setSize( 50, 50 );
    shadow.setPosition( -25, -25 );
    
    current = 0;
    position = new Vector2D[] { new Vector2D( newX, newY ), new Vector2D( newX, newY ) };
    velocity = new Vector2D[] { new Vector2D( 0, 0 ), new Vector2D( 0, 0 ) };
    direction = new double[] { 0, 0 };
    rotation = new double[] { 0, 0 };
    forces = new Vector2D( 0, 0 );
    wallContacts = new Vector2D( 0, 0 );
    mass = 5;
    inverseMass = 1 / mass;
    radius = 25;
    // Friction = -mu * mass * gravity * (velocity / |velocity|)
    // fC = -mu * mass * gravity;
    fC = -0.05 * mass * 500; // gravity ~9.8m/s^2 what is that in px/s^2
  }// Ball CTOR  
  
  /**
   * Performs actions of the Ball class based on its current state
   *
   * @param timer_g - double used as the game timer
   */
  void process(double timer_g){
    if(state == ACTIVE){
      display();
      //collide(balls);
      setGameTimer(timer_g);
      move();
    }else if(state == INACTIVE){
      // inactive state
    }else if(state == FIREBALL){
      display();
      //collide(balls);
      setGameTimer(timer_g);
      move();
    }else if(state == DECOYBALL){
      display();
      //collide(balls);
      setGameTimer(timer_g);
      move();
    }
  }// process
  
  /**
   * Displays Ball
   */
  void display(){
    xPos = (float)getX();
    yPos = (float)getY();
   
    if( !displayArt || !hasArtwork ){
      
    fill(ballColor);
    noStroke();
    ellipse(xPos, yPos, diameter, diameter);

    }else if( displayArt && hasArtwork){
      pushMatrix( );
      translate( (float)position[current].x, (float)position[current].y);
      pushMatrix( );
      rotate( PI - (float)direction[current] );
      images[(int)(map( (float)rotation[current], 0, TWO_PI, 24, 0 ) + 0.5 )].draw( );
      popMatrix( );
      shadow.draw( );
      popMatrix();
    }// if displayArt
  
    if( state == FIREBALL ){
      fill(255, random(255), 0, random(100) + 150);
      noStroke();
      ellipse(xPos, yPos, diameter + 10, diameter + 10);
    }
    
  }// display
  
  /**
   * Displays debug information
   *
   * @param 
   * @param
   */
  void displayDebug(color debugColor, PFont font){
     fill(debugColor);
     textFont(font,16);
     text("ID: " + ID_no, xPos+diameter, yPos-diameter/2 );
     text("Last Bar Hit: " + lastBarHit, xPos+diameter, yPos-diameter/2 + 16*1);
     text("Special Source: " + specialSource, xPos+diameter, yPos-diameter/2 + 16*2);
     
     fill(255,255,255);
     stroke(0,255,0);
     ellipse(xPos, yPos - diameter/2, 5, 5); // Top hitbox
     ellipse(xPos - diameter/2, yPos, 5, 5); // Left hitbox
     ellipse(xPos + diameter/2, yPos, 5, 5); // Right hitbox
     ellipse(xPos, yPos + diameter/2, 5, 5); // Bottom hitbox
     
     fill( 255 );
     pushMatrix( );
     translate( (float)position[current].x, (float)position[current].y);
     ellipse( 0, 0, (float)(radius+radius), (float)(radius+radius) );
     stroke( 255, 0, 0 );
     line( 0, 0, (float)velocity[current].x, (float)velocity[current].y );
     rotateZ( HALF_PI - (float)direction[current] );
     rotateY( HALF_PI + (float)rotation[current] );
     stroke(0, 0, 255);
     line(0, 0, (float)radius, 0);
     stroke(0, 255, 0);
     line(0, 0, (float)-radius, 0);
     noStroke();
     popMatrix();
  }// displayDebug
    
  /**
   * Changes the direction and velocity of the ball.  - Obsolete
   * Used for ball/wall or ball/foosmen collision
   *
   * @param hitDirection - 1: reverses x velocity, 2: reverses y velocity, 3: reverse both x and y
   * @param xVeloc - x velocity added
   * @param yVeloc - y velocity added
   */
  void kickBall( int hitDirection, float xVeloc, float yVeloc ){
    if(state == INACTIVE)
      return;

    // Basic implementation
    if( hitDirection == 1 || hitDirection == 3) // Reverse x
      xVel *= -1;
    if( hitDirection == 2 || hitDirection == 3) // Reverse y
      yVel *= -1;
    xVel += xVeloc;
    yVel += yVeloc;
  }// kickBall
  
  /** 
   * Ball was launched with a specific location using a specific velocity.
   *
   * @param x - initial x position
   * @param y - initial y position
   * @param xVeloc - initial x velocity
   * @param yVeloc - initial y velocity
   */
  void launchBall(float x, float y, float xVeloc, float yVeloc){
    this.setPosition(x,y);
    this.setVelocity(xVeloc,yVeloc);
    //xPos = x;
    //yPos = y;
    //xVel = xVeloc;
    //yVel = yVeloc;
    lastBarHit = null;
    setActive();
  }//launchBall 
  
   /** 
   * Ball was launched with a specific location using a specific velocity.
   * Fireball variant
   *
   * @param x - initial x position
   * @param y - initial y position
   * @param xVeloc - initial x velocity
   * @param yVeloc - initial y velocity
   */
  void launchFireball(float x, float y, float xVeloc, float yVeloc){
    this.setPosition(x,y);
    this.setVelocity(xVeloc,yVeloc);
    
    //xPos = x;
    //yPos = y;
    //xVel = xVeloc;
    //yVel = yVeloc;
    setFireball();
  }//launchFireball
  
  /** 
   * Ball was launched with a specific location using a specific velocity.
   * Decoyball varient
   *
   * @param x - initial x position
   * @param y - initial y position
   * @param xVeloc - initial x velocity
   * @param yVeloc - initial y velocity
   */
  void launchDecoyball(float x, float y, float xVeloc, float yVeloc){
    this.setPosition(x,y);
    this.setVelocity(xVeloc,yVeloc);
    
    //xPos = x;
    //yPos = y;
    //xVel = xVeloc;
    //yVel = yVeloc;
    setDecoyball();
  }//launchBall   
  /** 
   * Stops ball
   */
  void stopBall(){
    this.setVelocity(0,0);
  }//stopBall   
  
  /**
   * Checks if ball was hit from an input device
   *
   * @param x - input x coordinate
   * @param y - input y coordinate
   */
  void isHit( float x, float y ){
    if(state == INACTIVE)
      return;
    
    if( getSpeed() > 1 )
      return;

    if( x > xPos-diameter/2 && x < xPos+diameter/2 && y > yPos-diameter/2 && y < yPos+diameter/2 ){
      float newVel =  random(-500, 500);
      while( newVel < 40 && newVel > -40 )
        newVel =  random(-500, 500);
      xVel = newVel;
      
      newVel =  random(-500, 500);
      while( newVel < 40 && newVel > -40 )
        newVel =  random(-500, 500);
      yVel = newVel;
      soundManager.playKick();
      setVelocity(xVel,yVel);
    }// if
  }// is Hit
  
  /**
   * Handles ball/ball collision - Obsolete
   *
   * @param others - Array of all ball objects
   */
  void collide(Ball[] others) {
    float spring = 0.05;
    
    if(state == INACTIVE)
      return;
      
    for (int i = 0; i < others.length; i++) {
      if( others[i].state == INACTIVE )
        continue;
      float dx = others[i].xPos - xPos;
      float dy = others[i].yPos - yPos;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = xPos + cos(angle) * minDist;
        float targetY = yPos + sin(angle) * minDist;
        float ax = (targetX - others[i].xPos) * spring;
        float ay = (targetY - others[i].yPos) * spring;
        xVel -= ax;
        yVel -= ay;
        others[i].xVel += ax;
        others[i].yVel += ay;
      }// if distance < minDist
    }// for others[i]
  }// collide
  
  public void collide( Line wall ) {
    Vector2D p = wall.closestPoint( position[current] );
    Vector2D n = Vector2D.sub( position[current], p ); // normal pointing towards the ball
    
    // check for interpenetration
    if ( n.magnitudeSquared( ) > radius*radius )
      return;
    
    // the ball is touching the wall
    wallContacts.add( n ); // keep track of this to use in collisions with foosbar collisions
    
    // "A collision occurs when a point on one body touches a point on another body with a
    //  negative relative normal velocity."
    if ( velocity[current].dot( n ) >= 0 ) // relative normal velocity, the wall isn't moving
       return;
     
    double elasticity = 0.8; // 1 = elastic, 0 = plastic
    //      -(1 + e) * v . n
    //  j = -----------------
    //       n . n  * ( 1/M )
    double impulse = Vector2D.scale( velocity[current], -( 1 + elasticity ) ).dot( n ) / ( n.dot( n ) / mass );
    //              j
    //  vB2 = vB1 + - * n
    //              M
    velocity[current].add( Vector2D.scale( n, impulse / mass ) );
    // TODO: move ball to touch exactly at p
    n.norm( );
    n.scale( radius );
    p.add( n );
    position[current].x = p.x;
    position[current].y = p.y;
    soundManager.playBounce();
  }
  
  public void clearWallContacts( ) {
    wallContacts.x = 0;
    wallContacts.y = 0;
  }
  public Vector2D getWallContacts( ) { return new Vector2D( wallContacts ); }
  
  public void step( double dt ) {
    // Runge-Kutta Order 4
    Vector2D p1 = position[current];
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
    position[next].set( position[current] );
    position[next].add( v4 );
     
    // v(n+1) = v(n) + (h/6)*(a1 + 2*a2 + 2*a3 + a4)
    a2.scale( 2 );
    a3.scale( 2 );
    a4.add( a3 );
    a4.add( a2 );
    a4.add( a1 );
    a4.scale( dt / 6.0 );
    velocity[next].set( velocity[current] );
    velocity[next].add( a4 );

    // Velocity might converge to something like, 0.038590812... px/s so just kill it.
    //if ( velocity[current].x == velocity[next].x && Math.abs( velocity[next].x ) < 0.5 )
      //velocity[next].x = 0;
    //if ( velocity[current].y == velocity[next].y && Math.abs( velocity[next].y ) < 0.5 )
      //velocity[next].y = 0;
    if ( velocity[next].x != 0 || velocity[next].y != 0 ) {
      // Changing the rotation when the velocity drops to zero would cause it to "jump"
      direction[next] = Math.atan2( velocity[next].x, velocity[next].y );
      // circumfrence = 2*pi * r;
      // revolutions = distance / circumfrence
      // rotation = revolutions * 2*pi = (distance / (2*pi * r)) * 2*pi = distance / r
      rotation[next] = normalizeRotation( rotation[current] + v4.magnitude( ) / radius );
    }
    ballOutOfBounds();
    current = next;
  }
  // TODO: Use position to check for booster? Probably not worth it...
  // Currently calculates friction, but assumes other external forces are constant through step
  // i.e. If it was on the booster before the step, it assumes it stays on the booster throughout the step
  // And if it was off the booster before the step, it assumes it stays off the booster througout the step
  private Vector2D acceleration( Vector2D position, Vector2D velocity ) {
    // sliding friction
    Vector2D fF = new Vector2D( velocity );
    fF.norm( );
    fF.scale( fC );
    // add to existing forces
    Vector2D a = new Vector2D( forces );
    a.add( fF );
    // divide by mass
    a.scale( inverseMass ); // a = F/m
    return a;
  }
  public void clearForces( ) {
    forces.x = 0;
    forces.y = 0;
  }
  public void addForce( Vector2D force ) {
    forces.x += force.x;
    forces.y += force.y;
  }
  
  // This was intended for backtracking which probably won't be implemented
  public void undoStep( ) {
    current ^= 1;
  }
  
  private double normalizeRotation( double r ) {
    while ( r < 0 )
      r += Math.PI + Math.PI;
    while ( r >= Math.PI + Math.PI )
      r -= Math.PI + Math.PI;
    return r;
  }// normalizeRotation
  
  public double getMass( ) { return mass; }
  public double getRadius( ) { return radius; }
  public double getX( ) { return position[current].x; }
  public double getY( ) { return position[current].y; }
  public Vector2D getPosition( ) { return position[current]; }
  public void setPosition( double x, double y ) {
    this.position[current].x = x;
    this.position[current].y = y;
  }
  public Vector2D getVelocity( ) { return velocity[current]; }
  public void setVelocity( double x, double y ) {
    velocity[current].x = x;
    velocity[current].y = y;
    direction[current] = Math.atan2( velocity[current].x, velocity[current].y );
  }
  
  public double getRotation( ) { return rotation[current]; }
  public void setRotation( double rotation ) {
    this.rotation[current] = normalizeRotation( rotation );
    this.rotation[current^1] = this.rotation[current];
  }
  
  /**
   * Moves the position of the ball based on its velocity
   */
  void move() {
    xVel = (float)getVelocity().x;
    yVel = (float)getVelocity().y;
    
    vel = sqrt(abs(sq(xVel))+abs(sq(yVel)));
        
    if( isFireball() ){
      if( fireballTimer < gameTimer )
        setActive();
    }else
      fireballTimer = 0;
    
    // Restricts maximum speed
    if( xVel > maxVel )
      xVel = maxVel;
    if( yVel > maxVel )
      yVel = maxVel;
    if( xVel < -maxVel )
      xVel = -maxVel;
    if( yVel < -maxVel )
      yVel = -maxVel;

    this.setVelocity(xVel, yVel);
  }// move

  boolean ballOutOfBounds(){
    if( this.position[current].x < 0 || this.position[current].x > width || this.position[current].y < 0 || this.position[current].y > height ){
      this.setPosition( width/2, height/2 );
      return true;
    }
    return false;
  }

  /**
   * Checks if ball is in active state.
   */
  boolean isActive(){
    if(state == ACTIVE)
      return true;
    else
      return false;  
  }// isActive

  /**
   * Checks if ball is in inactive state.
   */
  boolean isInactive(){
    if(state == INACTIVE)
      return true;
    else
      return false;  
  }// isInactive

  /**
   * Checks if ball is in fireball state.
   */
  boolean isFireball(){
    if(state == FIREBALL)
      return true;
    else
      return false;  
  }// isFireball

  /**
   * Checks if ball is in fireball state.
   */
  boolean isDecoyball(){
    if(state == DECOYBALL)
      return true;
    else
      return false;  
  }// isFireball
    
  // Getters/Setters
  
  int getID(){
    return ID_no;
  }//getID
  
  float getSpeed(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getSpeed
  
  float getAngle(){
    return sqrt(sq(xVel)+sq(yVel));
  }// getAngle  
  
  void setActive(){
    state = ACTIVE;
    specialSource = null;
  }// setActive

  void setInactive(){
    state = INACTIVE;
    this.setVelocity(0,0);
  }// setInactive
  
  void setFireball(){
    state = FIREBALL;
    fireballTimer = (float)gameTimer + fireballDuration;
  }// setFireball

  void setDecoyball(){
    state = DECOYBALL;
  }// setDecoyball
  
  void setMaxVel(float newMax){
    maxVel = newMax;
  }//setMaxVel
  
  void setColor(color newColor){
    ballColor = newColor;
  }// setColor

  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer

  void setFriction( float newFriction){
    friction = newFriction;
  }// setFriction
}//class Ball
