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

boolean enableSound = false;
boolean enableTwitter = false;
boolean enableVideo = false;
boolean enableTime = true;
boolean enableWeather = true;
boolean enableNews = false;
boolean enableMood = false;
boolean enableAlert = false;

Minim minim;
AudioPlayer radio;
TStream ts;
VideoLive videolive;
Time time;
Weather weather;
NYT nyt;
Mood mood;
proxml.XMLInOut XMLInOut;
Alert alert;
Tween tween;

void setup() {
  size(640, 480); 
  smooth();
  frameRate(40);

  // order matters here
  if(enableSound) minim = new Minim(this);
  // load a URL
  if(enableSound) radio = minim.loadFile("http://205.188.215.225:8018/", 2048);
  // play the file
  if(enableSound) radio.play();
  
  if(enableTwitter) {
    TweetStream s = new TweetStream(this, "stream.twitter.com", 80, "1/statuses/filter.json?locations=-74,40,-73,41", "subcultured", "cl0ckw0rk");
    ts = new TStream(s);
  }

  if(enableWeather) XMLInOut = new XMLInOut(this);
  if(enableWeather) weather = new Weather(XMLInOut);
  float tweenTime = 0;
  if(enableWeather && enableTime) tweenTime = (((weather.sunset().get(Calendar.HOUR_OF_DAY) - weather.sunrise().get(Calendar.HOUR_OF_DAY)) * .1) * 60);
  if(debug && enableWeather && enableTime) println("TweenTime: " + tweenTime);
  if(enableWeather && enableTime) tween = new Tween(this, tweenTime, Tween.SECONDS, Shaper.QUADRATIC);
  if(enableWeather && enableTime) time = new Time(weather.sunrise(), weather.sunset(), tween);

  if(enableVideo) {
    Capture cam = new Capture(this, width, height, 24);
    videolive = new VideoLive(cam, color(55,55,55));
  }
  
  if(enableAlert) alert = new Alert();

  if(enableNews) nyt = new NYT();
//   if(enableNews && enableTwitter && enableMood) mood = new Mood(nyt.getSourceUrl(), nyt.getResults().toString(), "news");
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

  if(enableTwitter) ts.render();
  if(enableVideo) videolive.render();
  if(enableWeather && enableTime) time.render();
  if(enableWeather) weather.render();
  if(enableNews) nyt.render();
  if(enableAlert && renderPDF) {
    if(debug) println("render pdf end");
    endRecord();
  }
};

// called by twitter stream whenever a new tweet comes in
void tweet(Status tweet) {
  ts.tweet(tweet);
}

void stop()
{
  if(enableSound) radio.close();
  if(enableSound) minim.stop();
  super.stop();
}
