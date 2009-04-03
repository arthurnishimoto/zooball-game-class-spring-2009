/**
 * ---------------------------------------------
 * SoundManager.pde
 *
 * Description: Sound Manager
 *
 * Class: CS 426 Spring 2009
 * System: Processing 1.0.1/Eclipse 3.4.1, Windows XP SP2/Windows Vista
 * Author: Arthur Nishimoto - Infinite State Entertainment
 * Version: 0.1
 * 
 * Version Notes:
 * 4/2/09    - Initial version
 * ---------------------------------------------
 */
import ddf.minim.*;

class SoundManager{
  // SOUND
  Minim minim;
  
  // Sample Names
  AudioPlayer goal, gameplay, postgame;
  AudioSample aPlayer, kick, bounce;

  // parent type must match main class 
  SoundManager(FoosballDemo parent){
    minim = new Minim(parent);
    
    // Load Samples
    aPlayer = minim.loadSample("data/sounds/swoosh.wav");
    kick = minim.loadSample("data/sounds/kick.wav");
    bounce = minim.loadSample("data/sounds/bounce.wav");
    
    // Load Player
    goal = minim.loadFile("data/sounds/gooaal.wav");
    gameplay = minim.loadFile("data/sounds/gameplay.wav");
    postgame = minim.loadFile("data/sounds/postgame.wav");
  }// Constructor
  
  void soundTest(){
    aPlayer.trigger();
  }// soundTest

  void playKick(){
    kick.trigger();
  }// playKick
  
  void playBounce(){
    bounce.trigger();
  }// playBounce

  void playGoal(){
    goal.rewind();
    goal.play();
  }// playGoal
  
  void playGameplay(){
    gameplay.rewind();
    gameplay.play();
  }// playGameplay
  
  void playPostgame(){
    postgame.rewind();
    postgame.play();
  }// playPostgame
  
  void stopSounds(){
    goal.pause();
    gameplay.pause();
    postgame.pause();
    
    goal.rewind();
    gameplay.rewind();
    postgame.rewind();
  }// stopSounds
}// class soundManager
