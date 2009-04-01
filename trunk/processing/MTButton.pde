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
  boolean pressed, xSwipe, ySwipe;
  float diameter;
  color idle_cl = color(#000000);
  color pressed_cl = color(#FF0000);
  boolean active;
  String buttonText = "";
   
  Button( float newDia , int new_xPos, int new_yPos){
    diameter = newDia;
    xPos = new_xPos;
    yPos = new_yPos;
    hasImage = false;
    isRound = true;
  }// Button CTOR
  
  Button( String newImage , int new_xPos, int new_yPos ){
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
    active = true;
   
    if(hasImage)
      image( buttonImage, xPos, yPos );
    else if(isRound && !pressed){
      fill(idle_cl);
      stroke(idle_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }else if(isRound && pressed){
      fill(pressed_cl);
      stroke(pressed_cl);
      ellipse( xPos, yPos, diameter, diameter );
    }
    
    fill(#000000);
    textFont(font,16);
    textAlign(CENTER);
    text(buttonText, xPos, yPos);
    textAlign(LEFT);
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
    if( !active )
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
  
  void setPressedColor(color newColor){
    pressed_cl = newColor;
  }// setPressedColor
  
  void setButtonText(String newText){
    buttonText = newText;
  }// setButtonText  

  void setDelay(double newDelay){
    buttonDownTime = newDelay;
  }// setDelay
  
  void setGameTimer( double timer_g ){
    gameTimer = timer_g;
  }// setGameTimer
 
  boolean isActive(){
    if(active)
      return true;
    else
      return false;  
  }// isActive
}// class Button

