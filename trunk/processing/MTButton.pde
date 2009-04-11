/**
 * ---------------------------------------------
 * MTButton.pde
 *
 * Description: Simple button class. Either uses a rectangular image or a basic circle
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1
 * 
 * Version Notes:
 * 2/6/09    - Initial version
 * 3/28/09   - Added button text
 * 4/1/09    - Support for rectuangular buttons
 *           - Button text displays up and down
 * 4/4/09    - Added a lit state
 * ---------------------------------------------
 */
 
class Button{
  PImage buttonImage;
  int xPos, yPos;
  double buttonDownTime = 1;
  double buttonLastPressed = -1;
  double gameTimer;
  boolean hasImage = false;
  boolean isRound = false;
  boolean isRectangle = false;
  boolean pressed, lit;
  float diameter;
  float rHeight, rWidth;
  color idle_cl = color(#000000);
  color lit_cl = color( 255, 255, 255 );
  color pressed_cl = color(#FF0000);

  boolean active;
  String buttonText = "";
  color buttonTextColor = color(0,0,0);
  boolean doubleSidedText = true;
  boolean invertText = false;
  
  int fadeAmount = 1;
  int fadeSpeed = 5;
  boolean fadeIn, fadeOut;
  color fadeColor = color(0,0,0);
  boolean fadeEnable = false;
  boolean doneFading = true;
   
  Button( int new_xPos, int new_yPos, float newDia ){
    diameter = newDia;
    xPos = new_xPos;
    yPos = new_yPos;
    isRound = true;
  }// Button CTOR

  Button( int new_xPos, int new_yPos, float newWidth, float newHeight ){
    rWidth = newWidth;
    rHeight = newHeight;
    xPos = new_xPos;
    yPos = new_yPos;
    isRectangle = true;
  }// Button CTOR
  
  Button( int new_xPos, int new_yPos, String newImage ){
    buttonImage = loadImage(newImage);
    xPos = new_xPos-buttonImage.width/2;
    yPos = new_yPos-buttonImage.height/2;
    diameter = buttonImage.width;
    hasImage = true;
  }// Button CTOR

  void process(PFont font, double timer_g){
    display(font);
    //displayDebug(color(0,255,0), font);
    //displayEdges(color(255,255,255));
    setGameTimer(timer_g);
  }// process
  
  void display(PFont font){
    if( fadeAmount <= 1 )
      active = true;
   
    if(hasImage)
      image( buttonImage, xPos, yPos );
    else if(!pressed && !lit){
      fill(idle_cl);
      stroke(idle_cl);
      if(isRound)
        ellipse( xPos, yPos, diameter, diameter );
      else if(isRectangle)
        rect( xPos, yPos, rWidth, rHeight );
    }else if(lit){
      fill(lit_cl);
      stroke(lit_cl);
      if(isRound)
        ellipse( xPos, yPos, diameter, diameter );
      else if(isRectangle)
        rect( xPos, yPos, rWidth, rHeight );
    }else if(pressed){
      fill(pressed_cl);
      stroke(pressed_cl);
      if(isRound)
        ellipse( xPos, yPos, diameter, diameter );
      else if(isRectangle)
        rect( xPos, yPos, rWidth, rHeight );
    }
    
    fill(buttonTextColor);
    textFont(font,16);
    textAlign(CENTER);
  
    int textShift = 0;
    if( doubleSidedText )
      textShift = 16;
    
    if( doubleSidedText || !invertText ){
      if( isRound )
        text(buttonText, xPos, yPos + textShift);
      else if( hasImage )
        text(buttonText, xPos + buttonImage.width/2, yPos + buttonImage.height/2 + textShift);
      else if ( isRectangle )
        text(buttonText, xPos + rWidth/2, yPos + rHeight/2 + textShift);
    }// if text not inverted
    
    if( doubleSidedText || invertText ){
      pushMatrix();
      if( isRound )
        translate(xPos, yPos - textShift);
      else if( hasImage )
        translate(xPos + buttonImage.width/2, yPos + buttonImage.height/2 - textShift);
      else if ( isRectangle )
        translate(xPos + rWidth/2, yPos + rHeight/2 - textShift);
      rotate(radians(180));
      textAlign(CENTER);
      text(buttonText, 0, 0);  
      popMatrix();
    }// if doubleSidedtext
    
    if(fadeEnable){
      if(fadeIn && fadeAmount > 0)
        fadeAmount -= fadeSpeed;
      else if(fadeOut && fadeAmount < 256)
        fadeAmount += fadeSpeed;
      else
        doneFading = true;
    }// if fadeEnable
    
    fill(fadeColor,fadeAmount);
    noStroke();
    if(hasImage)
      rect( xPos, yPos, buttonImage.width, buttonImage.height );
    if(isRectangle)
      rect( xPos, yPos, rWidth, rHeight );
    if(isRound)
      ellipse( xPos, yPos, diameter, diameter );
  }// display
    
  void displayEdges(color debugColor){
    fill(debugColor);

    if(isRound){
      ellipse( xPos-diameter/2, yPos-diameter/2, 10, 10 ); // Top left
      ellipse( xPos+diameter/2, yPos-diameter/2, 10, 10 ); // Top Right
      ellipse( xPos-diameter/2, yPos+diameter/2, 10, 10 ); // Bottom left
      ellipse( xPos+diameter/2, yPos+diameter/2, 10, 10 ); // Bottom Right      
    }else if(hasImage){
      ellipse( xPos, yPos, 10, 10 ); // Top left
      ellipse( xPos+buttonImage.width, yPos+buttonImage.height, 10, 10 ); // Bottom Right
      ellipse( xPos+buttonImage.width, yPos, 10, 10 ); // Top right
      ellipse( xPos, yPos+buttonImage.height, 10, 10 );// Bottom Left 
    }else if(isRectangle){
      ellipse( xPos, yPos, 10, 10 ); // Top left
      ellipse( xPos+rWidth, yPos+rHeight, 10, 10 ); // Bottom Right
      ellipse( xPos+rWidth, yPos, 10, 10 ); // Top right
      ellipse( xPos, yPos+rHeight, 10, 10 );// Bottom Left       
    }
  }//  displayEdges
  
  void displayDebug(color debugColor, PFont font){
    fill(debugColor);
    textFont(font,16);

    text("Pressed: "+pressed, xPos+diameter, yPos-diameter/2);
    text("Button Delay: "+buttonDownTime, xPos+diameter, yPos-diameter/2+16);
    if(buttonLastPressed + buttonDownTime > gameTimer)
      text("Button Downtime Remain: "+((buttonLastPressed + buttonDownTime)-gameTimer), xPos+diameter, yPos-diameter/2+16*2);
    else
      text("Button Downtime Remain: 0", xPos+diameter, yPos-diameter/2+16*2);
  }// displayDebug
    
  boolean isHit( float xCoord, float yCoord ){
    if( !active || fadeAmount > 1 )
      return false;
    if(isRound){
      if( xCoord > xPos-diameter/2 && xCoord < xPos+diameter/2 && yCoord > yPos-diameter/2 && yCoord < yPos+diameter/2){
        if (buttonLastPressed == 0){
          buttonLastPressed = gameTimer;
        }else if ( buttonLastPressed + buttonDownTime < gameTimer){
          buttonLastPressed = gameTimer;
          pressed = true;
          return true;
        }// if-else-if button pressed
      }// if x, y in area
    }else if(hasImage){
      if( xCoord > xPos && xCoord < xPos+buttonImage.width && yCoord > yPos && yCoord < yPos+buttonImage.height){
        if (buttonLastPressed == 0){
          buttonLastPressed = gameTimer;
        }else if ( buttonLastPressed + buttonDownTime < gameTimer){
          buttonLastPressed = gameTimer;
          pressed = true;
          return true;
        }// if-else-if button pressed
      }// if x, y in area
    }else if(isRectangle){
       if( xCoord > xPos && xCoord < xPos+rWidth && yCoord > yPos && yCoord < yPos+rHeight){
        if (buttonLastPressed == 0){
          buttonLastPressed = gameTimer;
        }else if ( buttonLastPressed + buttonDownTime < gameTimer){
          buttonLastPressed = gameTimer;
          pressed = true;
          return true;
        }// if-else-if button pressed
      }// if x, y in area     
    }
    pressed = false;
    return false;
  }// isHit
  
  void resetButton(){
    pressed = false;
  }// resetButton;
  
  // Setters and Getters
  
  void setIdleColor(color newColor){
    idle_cl = newColor;
  }// setIdleColor

  void setLitColor(color newColor){
    lit_cl = newColor;
  }// setLitColor
  
  void setLit(boolean newBool){
    lit = newBool;
  }// setLit
  
  void setPressedColor(color newColor){
    pressed_cl = newColor;
  }// setPressedColor
  
  void setButtonText(String newText){
    buttonText = newText;
  }// setButtonText  
  
  void setButtonTextColor(color newColor){
    buttonTextColor = newColor;
  }// setButtonText 

  void setDoubleSidedText( boolean newBool ){
    doubleSidedText = newBool;
  }// setDoubleSidedText
  
  void setInvertedText( boolean newBool ){
    invertText = newBool;
    doubleSidedText = !newBool;
  }// setInvertedText
  
  void setDelay(double newDelay){
    buttonDownTime = newDelay;
  }// setDelay
  
  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer

  void setFadeOut(){
    fadeAmount = 1;
    fadeOut = true;
    fadeIn = false;
    doneFading = false;
  }// setFadeOut
  
  void setFadeIn(){
    fadeAmount = 255;
    fadeOut = false;
    fadeIn = true;
    doneFading = false;
  }// setFadeOut
  
  void setFadeColor(color newColor){
    fadeColor = newColor;
  }// setFadeColor
  
  void fadeEnable(){
    fadeEnable = true;
  }// fadeEnable
  
  void fadeDisable(){
    fadeEnable = true;
  }// fadeEnable   
 
  boolean isActive(){
    if(active)
      return true;
    else
      return false;  
  }// isActive
  
  boolean isDoneFading(){
    return doneFading;
  }// isDoneFading
}// class Button

