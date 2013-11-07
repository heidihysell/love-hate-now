import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import megamu.shapetween.*;

import toxi.util.datatypes.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh.*;
import toxi.math.conversion.*;

import toxi.util.datatypes.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh.*;
import toxi.math.conversion.*;

import proxml.*;
import org.json.*;
import java.util.Calendar;
import processing.video.*;
import com.twitter.processing.*;
import ddf.minim.*;
import processing.pdf.*;

import processing.opengl.*;


/**
 * MOOD
 * May 2010
 * Heidi Hysell - heidi@heidihysell.com
 *
 * Data generated art piece.
 * List of elements that piece includes goes here.
 * Include credits for APIs here
 */

boolean debug = true;

int delayTimer = 3600000;
int startTimer = 0;

boolean enableSound = true;
boolean enableTwitter = false;
boolean enableVideo = true;
boolean enableTime = true;
boolean enableWeather = true;
boolean enableNews = false;
boolean enableMood = false;
boolean enableAlert = false;

Sound sound;
AudioPlayer radio;
TStream ts;
VideoLive videolive;
Time time;
Weather weather;
NYT nyt;
Mood mood;
Alert alert;

void setup() {
  size(720, 480, OPENGL); 
  smooth();
  frameRate(40);

  // order matters here
  try {
    if(enableSound) sound = new Sound(this);
  } catch (Exception e) { enableSound = false; }
  
  if(enableVideo) videolive = new VideoLive(this);
  if(enableWeather) weather = new Weather(this);
  if(enableWeather && enableTime) time = new Time(this, weather.sunrise(), weather.sunset());  
  if(enableAlert) alert = new Alert();
  if(enableNews) nyt = new NYT();
//   if(enableNews && enableTwitter && enableMood) mood = new Mood(nyt.getSourceUrl(), nyt.getResults().toString(), "news");
  if(enableTwitter) {
    try {
      TweetStream s = new TweetStream(this, "stream.twitter.com", 80, "1/statuses/filter.json?locations=-74,40,-73,41", "subcultured", "cl0ckw0rk");
      s.go();
      ts = new TStream();//this);
    } catch (Exception e) { enableTwitter=false; }
  }
};

void draw() { 
  // render current animation
  boolean renderPDF = false;
  if (enableAlert) {
     alert.render();
     renderPDF = alert.getAlert();
     alert.setAlert(false);
     if(enableAlert && renderPDF) {
       if(debug) println("render pdf start");
      beginRecord(PDF, "shockandawe.pdf");
       if(debug) println("hello");
     }
   }

  if(enableWeather && enableTime) time.render();
  if(enableVideo) videolive.render();
  if(enableWeather) weather.render();
  if(enableNews) nyt.render();
  if(enableTwitter) ts.render();
  if(enableAlert && renderPDF) {
    if(debug) println("render pdf end");
    endRecord();
    // saveFrame("processing_sketch_saveFrame_test-####.png");
  }
};

// called by twitter stream whenever a new tweet comes in
void tweet(Status tweet) {

}

void stop()
{
  if(enableSound) sound.stop();
  super.stop();
}
