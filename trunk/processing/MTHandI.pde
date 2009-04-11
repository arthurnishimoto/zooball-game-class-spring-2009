/**
 * ---------------------------------------------
 * MTHandI.pde
 *
 * Description: Multi-Touch Hand Interface
 *
 * Class:
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows Vista/Windows XP SP2
 * Author: Arthur Nishimoto
 * Version: 0.1
 *
 * Version Notes:
 * 2/13/09	- Initial Version
 *              - Uses timer_g and text needs a font
 * 2/27/09      - Added support for horizontal or vertical finger swipes
 * 3/20/09      - MTFinger modifications for gesture tracking use
 * 3/31/09      - Updated with getGameTimer() and setting debugColor and font
 * ---------------------------------------------
 */
 
 public class MTHandI{
   float xPos, yPos, padDiameter, fingerDistance, handTilt;
   float pinkyDistX, pinkyDistY, thumbDistX, thumbDistY;
   int nFingers;
   boolean active, pressed, leftHand, rightHand;
   MTFinger[] fingers;
   
   color pressed_cl = color( 0, 255, 255 );
   color idle_cl = color( 0, 255, 0 );
   
   MTHandI(float x, float y, float padDia, int numFing, float fingDia){
     xPos = x;
     yPos = y;
     padDiameter = padDia;
     fingers = new MTFinger[numFing];
     nFingers = numFing;
     for(int i = 0; i < numFing; i++){
       fingers[i] = new MTFinger(xPos-padDiameter/2+fingDia/2+ i*(padDiameter/4.5f), height/2, fingDia, this);
     }// for fingerGeneration
   }// MTHandI CTOR
   
   public void display(){
     active = true;  
     if(pressed){
       fill(pressed_cl, 100);
       stroke(pressed_cl);
       ellipse(xPos, yPos, padDiameter, padDiameter);
     }else{
       fill(idle_cl, 100);
       stroke(idle_cl);
       ellipse(xPos, yPos, padDiameter, padDiameter);
     }
     
     for(int i = 0; i < nFingers; i++){
       if( fingers[i].pinky  ){
         pinkyDistX = fingers[i].xPos;
         pinkyDistY = fingers[i].yPos;
       }else if( fingers[i].thumb ){
         thumbDistX = fingers[i].xPos;
         thumbDistY = fingers[i].yPos;
       }
       fingers[i].display();
     }// for fingers
     if(leftHand){
       fingerDistance = sqrt( sq(thumbDistX-pinkyDistX)+sq(thumbDistY-pinkyDistY) );
       handTilt = thumbDistY - pinkyDistY;

     }else if(rightHand){
       fingerDistance = sqrt( sq(pinkyDistX-thumbDistX)+sq(pinkyDistY-thumbDistY) );
       handTilt = pinkyDistY - thumbDistY;
     }
   }// display
   
   public boolean isPressed( float xCoord, float yCoord, int finger, float intensity){
     if( !active )
       return false;
     if( xCoord > xPos-padDiameter/2 && xCoord < xPos+padDiameter/2 && yCoord > yPos-padDiameter/2 && yCoord < yPos+padDiameter/2){
       for(int i = 0; i < nFingers; i++){
         fingers[i].isPressed(xCoord,yCoord, finger, intensity);
           
       }// for fingers
       pressed = true;
       return true;
     }// if x, y in area
     for(int i = 0; i < nFingers; i++){
       fingers[i].reset();      
     }// for fingers
     return false;
   }// isPressed

  public void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,16);
    text("Pressed: "+pressed, 10, 100);
    text("Hand Span: "+fingerDistance, 10, 100+16);
    text("Hand Tilt: "+handTilt, 10, 100+16*2);

    for(int i = 0; i < nFingers; i++){
      fingers[i].displayDebug(debugColor, font);
    }// for fingers
  }// displayDebug
  
  public void displayFinger(int newColor){
    for(int i = 0; i < nFingers; i++){
      fingers[i].displayFinger(newColor);
    }// for fingers
  }// displayDebug
  
  public void setDelay(double newDelay){
    for(int i = 0; i < nFingers; i++){
      fingers[i].buttonDownTime = newDelay;
    }// for fingers
  }// setDelay
  
  public float getSpan(){
    return fingerDistance;
  }// getSpan
  
  public float getTilt(){
    return handTilt;
  }// getTilt

  public void reset(){
    active = false;
    pressed = false;
    for(int i = 0; i < nFingers; i++){
        fingers[i].reset();
    }// for fingers
  }// reset
  
  public void calibrate(String hand){
    
    // Left-handed calibration
    if( hand == "LEFT" ){
      leftHand = true;
      rightHand = false;
      if(nFingers >= 5){
        fingers[0].pinky = true;
        fingers[1].ring = true;
        fingers[2].middle = true;
        fingers[3].index = true;
        fingers[4].thumb = true;
      }// for fingers
    // Right-handed calibration
    }else if( hand == "RIGHT" ){
       leftHand = false;
       rightHand = true;
       if(nFingers >= 5){
        fingers[4].pinky = true;
        fingers[3].ring = true;
        fingers[2].middle = true;
        fingers[1].index = true;
        fingers[0].thumb = true;
      }// for fingers     
    }// if-else left/right-handed
  }// calibrate
  
  void setGameTimer( double timer_g ){
    for(int i = 0; i < nFingers; i++){
      fingers[i].setGameTimer(timer_g);
    }// for fingers
  }// setGameTimer
   
 }// class MTHandI
 
 /**
 * ---------------------------------------------
 * MTFinger
 *
 * Description: Multi-Touch Finger object
 *
 * Class:
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows Vista/Windows XP SP2
 * Author: Arthur Nishimoto
 * Version: 0.1
 *
 * Version Notes:
 * ---------------------------------------------
 */
 
 class MTFinger{
   double buttonDownTime = 0.2;
   double buttonLastPressed = -1;
   double gameTimer;
   
   float swipeThreshold = 30.0;
   float xPos, yPos, intensity;
   float diameter;
   boolean active, pressed, clicked, xSwipe, ySwipe;
   boolean calibrated, pinky, ring, middle, index, thumb;
   float xMove, yMove;
   int fingerID;
   MTHandI hand;
   ArrayList others = new ArrayList(); // List of all other touches
   
   color pressed_cl = color( 255, 0, 0 );
   color clicked_cl = color( 0, 255, 0 );
   color idle_cl = color( 0, 0, 0 );
   
   //PFont font;
   
   MTFinger(float x, float y, float dia, MTHandI newHand){
     xPos = x;
     yPos = y;
     pinky = false;
     ring = false;
     middle = false;
     index = false;
     thumb = false;
     calibrated = false;
     diameter = dia;
     hand = newHand;
   }// MTFinger CTOR

   MTFinger(float x, float y, float dia, int ID, ArrayList otherList){
     xPos = x;
     yPos = y;
     pinky = false;
     ring = false;
     middle = false;
     index = false;
     thumb = false;
     calibrated = false;
     diameter = dia;
     others = otherList;
     fingerID = ID;
   }// MTFinger CTOR
   
   public void display(){
     active = true;
     if(fingerID == -1 && !pressed)
       buttonLastPressed = gameTimer;
     
     if(pressed && !clicked){
       fill(pressed_cl);
       stroke(pressed_cl);
       ellipse(xPos, yPos, diameter, diameter);
     }else if(clicked){
       fill(clicked_cl);
       stroke(clicked_cl);
       ellipse(xPos, yPos, diameter, diameter);
     }else{
       fill(idle_cl);
       stroke(idle_cl);
       ellipse(xPos, yPos, diameter, diameter); 
     }
     
     // Swipe
     if( abs(xMove) >= swipeThreshold ){
       xSwipe = true;
       shoot(4);
     }else{
       xSwipe = false;
     }// if xSwipe

     if( abs(yMove) >= swipeThreshold ){
       ySwipe = true;
       shoot(5);
     }else{
       ySwipe = false;
     }// if xSwipe

   }// display
 
   public void displayDebug(color debugColor, PFont font){
     fill(debugColor);
     textFont(font,16);

     text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
     text("Position: "+xPos+" , "+yPos, xPos+diameter, yPos-diameter/2+16);
     text("Movement: "+xMove+" , "+yMove, xPos+diameter, yPos-diameter/2-16);
     text("FingerID: "+fingerID+" Intensity: "+intensity, xPos+diameter, yPos-diameter/2+16*2);
     text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16*3);
     
     if(buttonLastPressed + buttonDownTime > timer_g)
       text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-timer_g), xPos+diameter, yPos-diameter/2+16*4);
     else
       text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*4);
     if(pinky)
       text("PINKY", xPos+diameter, yPos-diameter/2+16*5);
     else if(ring)
       text("RING", xPos+diameter, yPos-diameter/2+16*5);
     else if(middle)
       text("MIDDLE", xPos+diameter, yPos-diameter/2+16*5);
     else if(index)
       text("INDEX", xPos+diameter, yPos-diameter/2+16*5);
     else if(thumb)
       text("THUMB", xPos+diameter, yPos-diameter/2+16*5);
     
   }// displayDebug 
   
   public void displayFinger(int newColor){
     fill(newColor);
     textFont(font,16);
     if(pinky)
       text("PINKY", xPos, yPos-diameter*.6f);
     else if(ring)
       text("RING", xPos, yPos-diameter*.6f);
     else if(middle)
       text("MIDDLE", xPos, yPos-diameter*.6f);
     else if(index)
       text("INDEX", xPos, yPos-diameter*.6f);
     else if(thumb)
       text("THUMB", xPos, yPos-diameter*.6f);
   }// displayFinger
   
   public boolean isPressed( float xCoord, float yCoord, int finger, float intensityVal){
     if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
       if (buttonLastPressed == 0){
         buttonLastPressed = gameTimer;
       }else if ( buttonLastPressed + buttonDownTime < gameTimer){
         if(fingerID != finger){
           clicked = true;
           buttonLastPressed = gameTimer;

         }
         pressed = true;
         xMove = xCoord-xPos;
         yMove = yCoord-yPos;
         xPos = xCoord;
         yPos = yCoord;
       }else{
         intensity = intensityVal;
         fingerID = finger;
         clicked = false;
         pressed = true;
         xMove = xCoord-xPos;
         yMove = yCoord-yPos;
         xPos = xCoord;
         yPos = yCoord;
         return true;
       }// if-else-if button pressed
     }// if x, y in area
     return false;
   }// isPressed
 
 
    public void calibrate( float xCoord, float yCoord, int finger){
     if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
       switch(finger){
         case(1):
           pinky = true;
           calibrated = true;
           break;
         case(2):
           ring = true;
           calibrated = true;
           break;
         case(3):
           middle = true;
           calibrated = true;
           break;
         case(4):
           index = true;
           calibrated = true;
           break;
         case(5):
           thumb = true;
           calibrated = true;
           break;
         default:
           calibrated = false;
           pinky = false;
           ring = false;
           middle = false;
           index = false;
           thumb = false;
           break;
       }
     }// if x, y in area
     return;
   }// calibrate
   
   public void shoot(int style){
     //particleManager.explodeParticles(100, xPos, yPos, 0, 0, style);
   }// shoot
   
   public void reset(){
     fingerID = -1;
     pressed = false;
   }// reset
   
   // Setters and getters 
   
   public void setButtonDelay(double newDelay){
     buttonDownTime = newDelay;
   }// setDelay
  
   public void setSwipeThreshold(float newThreshold){
     swipeThreshold = newThreshold;
   }// setSwipeThreshold
  
   void setGameTimer( double timer_g ){
     gameTimer = timer_g;
   }// setGameTimer
  
   public float getXPos(){
     return xPos;
   }// getXPos
  
   public float getYPos(){
     return yPos;
   }// getYPos
  
 }// class MTFinger

