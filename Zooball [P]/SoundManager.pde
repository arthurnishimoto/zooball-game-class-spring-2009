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
 * 4/9/09    - Music stops if played if currently playing. Music loops.
 * ---------------------------------------------
 */
import ddf.minim.*;

class SoundManager{
  boolean muted = false;
  
  float gain = 0;
  
  
  // SOUND
  Minim minim;
  
  // Sample Names
  AudioPlayer goal, gameplay, postgame, jungle;
  AudioSample aPlayer, kick, bounce, decoyDeath, launchBall, fire, sizzle, tiger, launch, swoosh, elephant;
  AudioSample logoMusic;

  // parent type must match main class 
  SoundManager(Zooball parent){
    minim = new Minim(parent);
    
    // Load Samples - Quickly repeated sounds
    kick = minim.loadSample("data/sounds/kick.wav");
    bounce = minim.loadSample("data/sounds/bounce.wav");
    decoyDeath = minim.loadSample("data/sounds/pacdies.mp3");
    logoMusic = minim.loadSample("data/sounds/logo_TEMP.wav");
    launchBall = minim.loadSample("data/sounds/launch.wav");
    fire = minim.loadSample("data/sounds/fire.wav");
    sizzle = minim.loadSample("data/sounds/sizzle.wav");
    tiger = minim.loadSample("data/sounds/tiger.wav");
    launch = minim.loadSample("data/sounds/launch.wav");
    swoosh = minim.loadSample("data/sounds/swoosh.wav");
    elephant = minim.loadSample("data/sounds/elephant.wav");
    
    // Load Player - Longer sounds like music
    goal = minim.loadFile("data/sounds/goal.wav");
    gameplay = minim.loadFile("data/sounds/gameplay.wav");
    postgame = minim.loadFile("data/sounds/postgame.wav");
    jungle = minim.loadFile("data/sounds/jungle.wav");

    // Known commands for Minim AudioSample and AudioPlayer
    // mute, unmute, isMuted, setGain, getGain.
    // Gain is a range from 6.0206 to -80. Default == 0
    
    if(muted)
      mute();
    else
      unmute();
  }// Constructor

  // Manager only functions
  float getGain(){
    return gain;
  }// getGain
  
  boolean isMuted(){
    return muted;
  }// isMuted
  
  // Global Sound functions - All functions must be updated was a sound is added
  void mute(){
    kick.mute();
    bounce.mute();
    goal.mute();
    decoyDeath.mute();
    logoMusic.mute();
    gameplay.mute();
    postgame.mute();
    launchBall.mute();
    fire.mute();
    sizzle.mute();
    tiger.mute();
    jungle.mute();
    launch.mute();
    swoosh.mute();
    elephant.mute();
    muted = true;
  }// mute
  
  void unmute(){
    kick.unmute();
    bounce.unmute();
    goal.unmute();
    decoyDeath.unmute();
    logoMusic.unmute();
    gameplay.unmute();
    postgame.unmute();
    launchBall.unmute();
    fire.unmute();
    sizzle.unmute();
    tiger.unmute();
    jungle.unmute();
    launch.unmute();
    swoosh.unmute();
    elephant.unmute();
    muted = false;
  }// unmute  

  boolean setGain(float newGain){
    if( newGain > 6.0206 || newGain < -80 ) // Vaid gain range
      return false;
    gain = newGain;
    
    kick.setGain(gain);
    bounce.setGain(gain);
    goal.setGain(gain);
    decoyDeath.setGain(gain);
    logoMusic.setGain(gain);
    gameplay.setGain(gain);
    postgame.setGain(gain);
    launchBall.setGain(gain);
    fire.setGain(gain);
    sizzle.setGain(gain);
    tiger.setGain(gain);
    jungle.setGain(gain);
    launch.setGain(gain);
    swoosh.setGain(gain);
    elephant.setGain(gain);
    return true;
  }// setGain
  
  boolean addGain(){
    if( gain >= 6.0206) // maximum gain
      return false;
    else if( gain >= 0 )
      gain += 0.5;
    else if( gain < 0 )
      gain += 1;
    setGain(gain);
    return true;
  }// addGain
  
  boolean subtractGain(){
    if( gain <= -80 ) // minimum gain
      return false;
    else if( gain >= 0.5 )
      gain -= 0.5;
    else if( gain <= 0 )
      gain -= 1;
    setGain(gain);
    return true;    
  }// soubractGain
    
  void stopSounds(){
    goal.pause();
    gameplay.pause();
    postgame.pause();
    jungle.pause();
    
    goal.rewind();
    gameplay.rewind();
    postgame.rewind();
    jungle.rewind();
  }// stopSounds
  
  void pauseSounds(){
    goal.pause();
    gameplay.pause();
    postgame.pause();
    jungle.pause();
  }// pauseSound
  
  
  // Individual Sound Functions - Should only have to add a new function for a new sound
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
 
  void playDecoyDeath(){
    decoyDeath.trigger();
  }// playDecoyDeath
  
  void playLogoMusic(){
    logoMusic.trigger();
  }// playLogoMusic
  
  void playLaunchBall(){
    launchBall.trigger();
  }// playLaunchBall
  
  void playFire(){
    fire.trigger();
  }// playFire
  
  void playSizzle(){
    sizzle.trigger();
  }// playSizzle
  
  void playTiger(){
    tiger.trigger();
  }// playTiger
  
  void playLaunch(){
    launch.trigger();
  }// playLaunch
  
  void playSwoosh(){
    swoosh.trigger();
  }// playSwoosh
  
  void playElephant(){
    elephant.trigger();
  }// playElephant
  
  void playGameplay(){
    if( gameplay.isPlaying() ){
      gameplay.pause();
      return;
    }
    gameplay.rewind();
    gameplay.loop();
  }// playGameplay
  
  void playPostgame(){
    if( postgame.isPlaying() ){
      postgame.pause();
      return;
    }
    postgame.rewind();
    postgame.loop();
  }// playPostgame
  
   void playJungle(){
    if( jungle.isPlaying() ){
      jungle.pause();
      return;
    }
    jungle.rewind();
    jungle.loop();
  }// playJungle
}// class soundManager
