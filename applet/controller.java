import processing.core.*; 
import processing.xml.*; 

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

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class controller extends PApplet {




























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

public void setup() {
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
  if(enableWeather && enableTime) tweenTime = (((weather.sunset().get(Calendar.HOUR_OF_DAY) - weather.sunrise().get(Calendar.HOUR_OF_DAY)) * .1f) * 60);
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

public void draw() { 
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
public void tweet(Status tweet) {
  ts.tweet(tweet);
}

public void stop()
{
  if(enableSound) radio.close();
  if(enableSound) minim.stop();
  super.stop();
}
/*
 * Prints out a PDF render of the current screen when a certain trigger alert is made.
 * In this case we will print a PDF for every new trending topic in NYC on twitter
 *
 */
public class Alert {

  boolean debug = true;
  
  int delayTimer = 300000;
  int startTimer = 0;

  
  String WOEID = "2459115"; // new york  TODO make configurable
  
  // array of the top 10 trends
  JSONObject data;
  JSONObject contents;
  JSONArray trendJSON = new JSONArray();
  ArrayList trends = new ArrayList();
  ArrayList currentTrends = new ArrayList();
  
  boolean alert = false;

  Alert() {
    init();
  };
  
  public void init() {
    startTimer = millis();
    alert=false;
    //request();
  }
  
  public void render() {
    // set the timer to refresh the request
    if(debug) println("render");
    if ((millis() - startTimer) < delayTimer) {
      // if we have encountered a new twitter topic then capture the frame with the new trending topic
    } else {
      startTimer = millis();
      //request();
      if(debug) println("timer reset");
    }
  }
  
  public String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  public void request() {
    String apiUrl = "http://api.twitter.com/1/trends/" + WOEID + "rent.json";
    String request = apiUrl;
    try{
      data = new JSONObject(join(loadStrings(request), ""));
      if(debug) println("trending data: " + data);
      JSONObject result = data.getJSONObject("trends");
      if(debug) println("result: " + result);
      String[] keys = JSONObject.getNames(result);
      if(debug) println("key: " + keys[0]);
      trendJSON = result.getJSONArray(keys[0]);
      currentTrends = new ArrayList();
      for(int i=0; i<trendJSON.length(); i++) {
        if(debug) println("object string: " + trendJSON.getJSONObject(i).getString("name"));
        currentTrends.add(trendJSON.getJSONObject(i).getString("name"));
      }
      if (trends.size() <= 0) { // set the current trends
        trends = currentTrends;
      } else if (!trends.equals(currentTrends)) { // compare the input trends to our last current trends
        trends = currentTrends;
        alert = true;
      }

      if (debug) println("trends: " + trends);
    } catch(Exception e){
      //if loading failed 
      println("Loading Failed");
      e.printStackTrace();
    }
  }
  
  public boolean getAlert() { return alert; }
  public void setAlert(boolean alert) { this.alert = alert; }
  
};
  
/**
 * Collect all of the information and send a request to get mood ever xx minutes once we have a good amount of information
 */
public class Mood {

  boolean debug = false;
  
  // data
  JSONObject data;
  String sourceURL = "";
  String id = "";
  String txt = "";

  Mood(String url, String txt, String id) {
    sourceURL = url;
    this.txt = txt;
    request(url, txt, id);
  };
  
  public void render() {

  }
  
  public String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  public void request(String inputUrl, String inputText, String id) {
    // If you don't have an API key, you can register here: http://www.openamplify.com/member/register
    String apiKey = "edwzvkdxtxg7ag6xnu8dtmxdkbmj5ek4";		// Insert your API key here.
    String analysis = "all";		// all (default), actions, topics, demographics, styles.
    String outputFormat = "json";		// xml (default), json, dart.
    // select either this option or the following... not both.

    try {
      String url_args = URLEncoder.encode("apiKey", "UTF-8") + "=" + URLEncoder.encode(apiKey, "UTF-8");
      url_args += "&" + URLEncoder.encode("analysis", "UTF-8") + "=" + URLEncoder.encode(analysis, "UTF-8");
      url_args += "&" + URLEncoder.encode("outputFormat", "UTF-8") + "=" + URLEncoder.encode(outputFormat, "UTF-8");
//      url_args += "&" + URLEncoder.encode("inputText", "UTF-8") + "=" + URLEncoder.encode(inputText, "UTF-8");
      url_args += "&" + URLEncoder.encode("sourceURL", "UTF-8") + "=" + URLEncoder.encode(inputUrl, "UTF-8");

      // create the URL.
//      URL url = new URL("http://portaltnx20.openamplify.com/AmplifyWeb_v20/AmplifyThis");
      String url = "http://portaltnx20.openamplify.com/AmplifyWeb_v20/AmplifyThis";
      if(debug) println(url_args);
      String request = setupProxy(url + "?" + url_args, "mood" + "-" + id);
      if(debug) println("amplify request " + request);
      String result = join( loadStrings( request ), "");

      if(debug) println(result);
    } catch (Exception e) {}
  }
  
};
public class NYT {

  boolean debug = false;
  
  // data
  JSONObject data;
  JSONObject contents;
  JSONArray results;
  String sourceUrl;

  NYT() {
    init();
  };
  
  public void init() {
    Calendar cal = Calendar.getInstance();
    String end = "" + cal.get(Calendar.YEAR);
    end = (cal.get(Calendar.MONTH) >= 10) ? end + cal.get(Calendar.MONTH) : end + "0" + cal.get(Calendar.MONTH);
    end = (cal.get(Calendar.DAY_OF_MONTH) >= 10) ? end + cal.get(Calendar.DAY_OF_MONTH) : end + "0" + cal.get(Calendar.DAY_OF_MONTH);
    cal.add(Calendar.DAY_OF_YEAR, -1);
    String start = "" + cal.get(Calendar.YEAR);
    start = (cal.get(Calendar.MONTH) >= 10) ? start + cal.get(Calendar.MONTH) : start + "0" + cal.get(Calendar.MONTH);
    start = (cal.get(Calendar.DAY_OF_MONTH) >= 10) ? start + cal.get(Calendar.DAY_OF_MONTH) : start + "0" + cal.get(Calendar.DAY_OF_MONTH);
    request("new+york", start, end);
  }
  
  public void render() {
    try {
      if(debug) println("total: " + contents.getInt("total"));
    } catch (Exception e) {
     if(debug) e.printStackTrace();
    }
  }
  
  public String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    if(debug) println("news url " + encodedURL);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  public void request(String word, String startDate, String endDate) {
    int total = 0;
    String apiUrl = "http://api.nytimes.com/svc/search/v1/article";
    String apiKey  = "e5d3d7f37232216919b1f44bdc88922e:15:58003749";
    String request = setupProxy(apiUrl+ "?query=" + word + "&begin_date=" + startDate + "&end_date=" + endDate + "&api-key=" + apiKey, "nyt");
    sourceUrl = request;
    if(debug) println(request);
    try {
      data = new JSONObject(join(loadStrings(request), ""));
      if(debug) println(data);
      contents = data.getJSONObject("contents");
      results = contents.getJSONArray("results");
      total = contents.getInt("total");
      if(debug) println("There were " + total + " occurences of the term " + word);
    } catch (JSONException e) {
      if(debug) println("There was an error parsing the JSONObject" + e); 
    }
  }
  
  public JSONObject getContents() {
    return contents;
  }
  
};
public class Sound {

  boolean debug = false;
  
  Minim minim;
  AudioPlayer radio;
  
  Sound() {
    // load a URL
    radio = minim.loadFile("http://205.188.215.225:8018/", 2048);
    // play the file
    radio.play();

    init();
  };
  
  public void init() {
  }
  
  public void render() {
     stroke(255);
    // draw the waveforms
    // the values returned by left.get() and right.get() will be between -1 and 1,
    // so we need to scale them up to see the waveform
    // note that if the file is MONO, left.get() and right.get() will return the same value
    for(int i = 0; i < radio.bufferSize()-1; i++)
    {
      float x1 = map(i, 0, radio.bufferSize(), 0, width);
      float x2 = map(i+1, 0, radio.bufferSize(), 0, width);
      line(x1, 50 + radio.left.get(i)*50, x2, 50 + radio.left.get(i+1)*50);
      line(x1, 150 + radio.right.get(i)*50, x2, 150 + radio.right.get(i+1)*50);
    }
  }

}
public class Time {

  boolean debug = true;

  // gradient constants
  int Y_AXIS = 1;
  int X_AXIS = 2;

  Calendar cal;
  Calendar sunrise;
  Calendar sunset;
  
  int daylightHours;
  int preDawnHours;
  int postTwilightHours;
  int percentage;

  Tween tween;

  int currentGradientStart;
  int currentGradientEnd;

  int nextGradientStart;
  int nextGradientEnd;
  
  int[] dawnStartPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                            color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

  int[] dawnEndPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                          color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

  
  int[] dayStartPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                           color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};


  int[] dayEndPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                         color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

    
  int[] nightStartPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                             color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};


  int[] nightEndPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                           color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

  Time(Calendar sunrise, Calendar sunset, Tween settween) {
    // set the current time
    cal = null;
    this.sunrise = sunrise;
    this.sunset = sunset;
    tween = settween;
    tween.start();
  };

  public void init() {
    // if the hour has changed since last time called, then get new information (extra layer of caching)
    Calendar now = Calendar.getInstance();
    if (cal == null || cal.get(Calendar.HOUR_OF_DAY) != now.get(Calendar.HOUR_OF_DAY)) {
      cal = now;
      // find out the amount of daylight hours today
      daylightHours = sunset.get(Calendar.HOUR_OF_DAY) - sunrise.get(Calendar.HOUR_OF_DAY);
      preDawnHours = sunrise.get(Calendar.HOUR_OF_DAY);
      postTwilightHours = 24 - sunset.get(Calendar.HOUR_OF_DAY);
      percentage = 0;
      if (debug) println("nowHour: " + now.get(Calendar.HOUR_OF_DAY) + " sunriseHour: " + sunrise.get(Calendar.HOUR_OF_DAY) + " sunsetHour: " + sunset.get(Calendar.HOUR_OF_DAY));
    }
    if (debug) println("nowHour: " + now + " sunriseHour: " + sunrise + " sunsetHour: " + sunset);
    if(debug) println("sunrise: " + now.compareTo(sunrise));
    if (now.compareTo(sunrise) <= 0) { // dawn
      if(debug) println("predawn");
      tween.setDuration(((preDawnHours * .1f) * 60));
      if(debug) println("howdy: " + (now.get(Calendar.HOUR_OF_DAY) / sunrise.get(Calendar.HOUR_OF_DAY)));
      percentage = ((now.get(Calendar.HOUR_OF_DAY) / sunrise.get(Calendar.HOUR_OF_DAY)) * 100);
      int nowcent = (round(percentage/10)) - 1;
      if(debug) println("percentage: " + percentage + " nowcent: " + nowcent);
      currentGradientStart = dawnStartPalette[nowcent];
      currentGradientEnd = dawnEndPalette[nowcent];
      if (nowcent < 9) {
        nextGradientStart = dawnStartPalette[nowcent];
        nextGradientEnd = dawnEndPalette[nowcent];
      } else {
        nextGradientStart = dayStartPalette[nowcent];
        nextGradientEnd = dayEndPalette[nowcent];
      }
    } 
    else if (now.compareTo(sunset) <= 0) { // day
      if(debug) println("day");
      tween.setDuration(((daylightHours * .1f) * 60));
      percentage = (now.get(Calendar.HOUR_OF_DAY) / sunset.get(Calendar.HOUR_OF_DAY)) * 100;
      int nowcent = (round(percentage/10)) - 1;
      currentGradientStart = dayStartPalette[nowcent];
      currentGradientEnd = dayEndPalette[nowcent];
      if (nowcent < 9) {
        nextGradientStart = dayStartPalette[nowcent];
        nextGradientEnd = dayEndPalette[nowcent];
      } else {
        nextGradientStart = nightStartPalette[nowcent];
        nextGradientEnd = nightEndPalette[nowcent];
      }
    } 
    else { // night
      if(debug) println("night");  
      tween.setDuration(((postTwilightHours * .1f) * 60));
      percentage = (now.get(Calendar.HOUR_OF_DAY) / 24) * 100;
      int nowcent = (round(percentage/10)) - 1;
      if(debug) println("nowcent: " + nowcent);
      currentGradientStart = nightStartPalette[nowcent];
      currentGradientEnd = nightEndPalette[nowcent];
      if (nowcent < 9) {
        nextGradientStart = nightStartPalette[nowcent];
        nextGradientEnd = nightEndPalette[nowcent];
      } else {
        nextGradientStart = dawnStartPalette[nowcent];
        nextGradientEnd = dawnEndPalette[nowcent];
      }
    }
    if(debug) println("percentage: " + percentage + " currentGradientStart: " + currentGradientStart + " nextGradientStart " + nextGradientStart);
  }

  public void render() {
    init();
    // set a gradient based on the time of day
    tweenGradient(0, 0, width, height, currentGradientStart, currentGradientEnd, nextGradientStart, nextGradientEnd, Y_AXIS);
  }

  public void tweenGradient(int x, int y, float w, float h, int c1, int c2, int co1, int co2, int axis) {
    // get the start color and end colors to tween between
    int start = lerpColor( c1, co1, tween.position() );
    int end = lerpColor( c2, co2, tween.position() );
    setGradient(x, y, w, h, start, end, axis);
  }

  public void setGradient(int x, int y, float w, float h, int c1, int c2, int axis ){
    // calculate differences between color components 
    float deltaR = red(c2)-red(c1);
    float deltaG = green(c2)-green(c1);
    float deltaB = blue(c2)-blue(c1);

    // choose axis
    if(axis == Y_AXIS){
      /*nested for loops set pixels
       in a basic table structure */
      // column
      for (int i=x; i<=(x+w); i++){
        // row
        for (int j = y; j<=(y+h); j++){
          int c = color(
          (red(c1)+(j-y)*(deltaR/h)),
          (green(c1)+(j-y)*(deltaG/h)),
          (blue(c1)+(j-y)*(deltaB/h)) 
            );
          set(i, j, c);
        }
      }  
    }  
    else if(axis == X_AXIS){
      // column 
      for (int i=y; i<=(y+h); i++){
        // row
        for (int j = x; j<=(x+w); j++){
          int c = color(
          (red(c1)+(j-x)*(deltaR/h)),
          (green(c1)+(j-x)*(deltaG/h)),
          (blue(c1)+(j-x)*(deltaB/h)) 
            );
          set(j, i, c);
        }
      }  
    }
  }


  public void renderImage() {    
    // for each time palette pixel generate a randomized background that is slightly but constantly changing
    //     tint(0,200,255);
    //    image(img,250,250);
    //    loadPixels();  
    //    for (int x=0; x<width; x++) {
    //      for (int y=0; y<height; y++) {
    //            int c = int(random(50));
    //            color pix = timePalette[c];
    //            fill(pix, 0, 0);
    //            //if(debug) println("pix: " + pix);
    //            int loc = x + y * width;
    //            pixels[loc] = pix;
    //            rect(x, y, 10, 10);
    //      }
    //    }
    //    updatePixels(); 
  }

  public void initImage() {
    // render the background based on the time of day
    // we have 24 hours in the day
    // each hour will be associated with an image that we will use to determine a dynamic background
    //      if(debug) println("current hour" + cal.get(Calendar.HOUR));
    //      String toload = timeOfDayImg[cal.get(Calendar.HOUR_OF_DAY)];
    //      if(debug) println(toload);
    //      img = loadImage(toload);
    //      image(img,0,0);
    //      loadPixels();
    //      currentColor = timeOfDayPallete[cal.get(Calendar.HOUR_OF_DAY)];
    //      for(int i=0; i<500; i++) {
    //        if(debug) println(pixels[i]);
    //        timePalette[i] = pixels[i];
    //      }; 
  }

};

public class TStream {

  boolean debug = false;
  
  // this stores how many tweets we've gotten
  int tweets = 0;
  // and this stores the text of the last tweet
  String tweetText = "";


  TStream(TweetStream s) {
    PFont font = loadFont("fonts/CharcoalCY-24.vlw");
    textFont(font, 24);
    // set up twitter stream object
    s.go();
    init();
  };
  
  public void init() {
  }
  
  public void render() {
    fill(255, 0, 0);
    // draw a box as many pixels wide as the number of tweets we've seen
    rect(20, 20, tweets, 20);
    // and draw the text of the last tweet
    text(tweetText, 10, 70);
  }

  // called by twitter stream whenever a new tweet comes in
  public void tweet(Status tweet) {
    // print a message to the console just for giggles if you like
    if(debug) println("got tweet " + tweet.id());
    // store the latest tweet text
    tweetText = tweet.text();
    // bump our tweet count by one
    tweets += 1;
  }
}
/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 
public class VideoLive {

  Capture video;
  int colorTint;

  VideoLive(Capture cam, int c) {
    this.video = cam;
    colorTint = c;
    init(); 
  }

  public void init() {
    // If no device is specified, will just use the default.
  
    // To use another device (i.e. if the default device causes an error),  
    // list all available capture devices to the console to find your camera.
    //String[] devices = Capture.list();
    //println(devices);
    
    // Change devices[0] to the proper index for your camera.
    //cam = new Capture(this, width, height, devices[0]);
  
    // Opens the settings page for this capture device.
    //camera.settings();
  }


  public void render() {
    if (video.available() == true) {
      video.read();
      tint(colorTint, 126);
      image(video, 0, 0);
      // The following does the same, and is faster when just drawing the image
      // without any additional resizing, transformations, or tint.
      //set(160, 100, video);
    }
  } 
  
}
/*
 * Uses the YAHOO! weather api rss feed
 * http://developer.yahoo.com/weather/
 *
 */
public class Weather {

  boolean debug = true;
  
  // timer information
  int delayTimer = 600000; // should retrieve every 10 minutes
  int startTimer = 0;
  
  String WOEID = "2459115"; // new york  TODO make configurable
  
  String sunrise = "";
  String sunset = "";
  int temp = 0;
  int code = 3200;
  
  HashMap weatherCodes = new HashMap();

  //elements
  proxml.XMLElement xmlWeather;
  proxml.XMLInOut xmlIO;

  Weather(XMLInOut xmlInOut) {
    xmlIO = xmlInOut;
    weatherCodes.put(0, "weather/tornados.png");
    weatherCodes.put(1, "weather/tropicalStorm.png");
    weatherCodes.put(2, "weather/hurricane.png");
    weatherCodes.put(3, "weather/severeThunderstorms.png");
    weatherCodes.put(4, "weather/thunderstaorms.png");
    weatherCodes.put(5, "weather/rainsnow.png");
    weatherCodes.put(6, "weather/rainSleet.png");
    weatherCodes.put(7, "weather/snowSleet.png");
    weatherCodes.put(8, "weather/freezingDrizzel.png");
    weatherCodes.put(9, "weather/drizzel.png");
    weatherCodes.put(10, "weather/freezingRain.png");
    weatherCodes.put(11, "weather/showers.png");
    weatherCodes.put(12, "weather/showers.png");
    weatherCodes.put(13, "weather/snowFlurries.png");
    weatherCodes.put(14, "weather/lightSnowShowers.png");
    weatherCodes.put(15, "weather/blowingSnow.png");
    weatherCodes.put(16, "weather/snow.png");
    weatherCodes.put(17, "weather/hail.png");
    weatherCodes.put(18, "weather/sleet.png");
    weatherCodes.put(19, "weather/dust.png");
    weatherCodes.put(20, "weather/foggy.png");
    weatherCodes.put(21, "weather/haze.png");
    weatherCodes.put(22, "weather/smokey.png");
    weatherCodes.put(23, "weather/blustry.png");
    weatherCodes.put(24, "weather/windy.png");
    weatherCodes.put(25, "weather/cold.png");
    weatherCodes.put(26, "weather/cloudy.png");
    weatherCodes.put(27, "weather/mostlyCloudyNight.png");
    weatherCodes.put(28, "weather/mostlyCloudyDay.png");
    weatherCodes.put(29, "weather/partlyCloudyNight.png");
    weatherCodes.put(30, "weather/partlyCloudyDay.png");
    weatherCodes.put(31, "weather/clearNight.png");
    weatherCodes.put(32, "weather/sunny.png");
    weatherCodes.put(33, "weather/fairNight.png");
    weatherCodes.put(34, "weather/fairDay.png");
    weatherCodes.put(35, "weather/mixedRainHail.png");
    weatherCodes.put(36, "weather/hot.png");
    weatherCodes.put(37, "weather/isolatedThunderstorms.png");
    weatherCodes.put(38, "weather/scatteredThunderstorms.png");
    weatherCodes.put(39, "weather/scatteredThunderstorms.png");
    weatherCodes.put(40, "weather/scatteredShowers.png");
    weatherCodes.put(41, "weather/heavySnow.png");
    weatherCodes.put(42, "weather/scatteredSnowShowers.png");
    weatherCodes.put(43, "weather/heavySnow.png");
    weatherCodes.put(44, "weather/partlyCloudy.png");
    weatherCodes.put(45, "weather/thundershowers.png");
    weatherCodes.put(46, "weather/snowshowers.png");
    weatherCodes.put(47, "weather/isolatedthundershowers.png");
    weatherCodes.put(3200, "weather/notavailable.png");
    init();
  };
  
  public void init() {
    PFont font = loadFont("fonts/CharcoalCY-24.vlw");
    textFont(font, 24);
    request();
  }
  
  public void render() {
    // and draw the text of the last tweet
    text("Current Temp: " + String.valueOf(temp), 10, 90);
    text("Sunrise: " + sunrise, 10, 110);
    text("Sunset: " + sunset().toString(), 10, 130);
    if ((millis() - startTimer) < delayTimer) {
      startTimer = 0; // reset the timer
    } else {
      startTimer = millis();
      init();
    }
  }
  
  public String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  public void request() {
    String apiUrl = "http://weather.yahooapis.com/forecastrss?w=";
    String request = setupProxy(apiUrl+ WOEID, "weather");
    try{
      xmlWeather = xmlIO.loadElementFrom(apiUrl+ WOEID); //loads the XML 
      parseXML();
    }
    catch(Exception e){
      //if loading failed 
      println("Loading Failed");
      e.printStackTrace();
    }
  }
  
  public void parseXML() {
    if(debug) println("parsing xml");
    proxml.XMLElement node, item;
    if(debug) println("accessing nodes: " + xmlWeather.toString());
    node = xmlWeather.firstChild(); //gets to the child we need
    int numberOfNodes = node.countChildren(); //counts the number of children
    if(debug) println("number of nodes: " + numberOfNodes);
    if(debug) println("current node to string: " + node.toString());
    sunrise = node.getChild(10).getAttribute("sunrise");
    sunset = node.getChild(10).getAttribute("sunset");
    if(debug) println("sunrise: " + sunrise + " sunset: " + sunset);
    if(debug) println("temp: " + node.getChild(12).getChild(5).toString());
    temp = node.getChild(12).getChild(5).getIntAttribute("temp");
    code = node.getChild(12).getChild(5).getIntAttribute("code");
    if(debug) println("temp: " + temp + " code: " + code);
  }
  
  public Calendar parseDateString(String timestamp) {
    Calendar cal = Calendar.getInstance();
    try {
      SimpleDateFormat sdf = new SimpleDateFormat("h:mm a", Locale.US);
      Date d = sdf.parse(timestamp);
      Calendar date = Calendar.getInstance();
      date.setTime(d);
      cal.set(Calendar.HOUR_OF_DAY, date.get(Calendar.HOUR_OF_DAY));
      cal.set(Calendar.MINUTE, date.get(Calendar.MINUTE));
    } catch (Exception e) {
      ;
    }
    return cal;
  }
  public Calendar sunrise() {
    return parseDateString(sunrise);
  }
  public Calendar sunset() {
    return parseDateString(sunset);
  }
  public int temp() {
    return temp;
  }
//  int state() { // return the image associated with the state of the weather
//    
//  }
};
  

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "controller" });
  }
}
