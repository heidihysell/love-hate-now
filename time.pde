/**
 * Displays visuals based on the current time of day.
 * Current animations include visualizing the sky as it changes throughout the day.
 * DEPENDENCIES:   Tween - http://www.leebyron.com/else/shapetween/
 */
public class Time {

  boolean debug = false;
  
  controller parent;

  Calendar cal;
  Calendar sunrise;
  Calendar sunset;
  
  int daylightHours;
  int preDawnHours;
  int postTwilightHours;
  float percentage;

  Tween tween;
  float tweenDuration = 0.0;
  
  color currentGradientC1;
  color currentGradientC2;
  color currentGradientC3;
  color currentGradientC4;

  color nextGradientC1;
  color nextGradientC2;
  color nextGradientC3;
  color nextGradientC4;
  
  // TODO: consider importing these from a csv file of colors
  color[] dawnC1Palette={color(20, 8, 57), color(21, 9, 54), color(22, 10, 52), color(24, 11, 49), color(25, 12, 47),
                         color(26, 13, 44), color(27, 15, 42), color(28, 16, 39), color(30, 17, 37), color(31, 18, 34)};

  color[] dawnC2Palette={color(32, 11, 57), color(32, 12, 54), color(32, 13, 52), color(32, 13, 39), color(32, 14, 47),
                        color(31, 15, 44), color(31, 16, 42), color(31, 16, 39), color(31, 17, 37), color(31, 18, 34)};

  color[] dawnC3Palette={color(9, 9, 60), color(10, 10, 57), color(11, 11, 54), color(12, 12, 51), color(13, 13, 48),
                        color(13, 13, 45), color(14, 14, 42), color(15, 15, 39), color(16, 16, 35), color(17, 17, 32)};

  color[] dawnC4Palette={color(9, 9, 60), color(10, 10, 57), color(11, 11, 54), color(12, 12, 51), color(13, 13, 48),
                        color(13, 13, 45), color(14, 14, 42), color(15, 15, 39), color(16, 16, 35), color(17, 17, 32)};


  color[] dayC1Palette={color(134, 61, 7), color(203, 160, 32), color(203, 178, 73), color(177, 166, 119), color(154, 156, 160),
                        color(145, 159, 167), color(136, 161, 175), color(128, 164, 183), color(119, 166, 190), color(122, 168, 191),
                        color(126, 170, 191), color(131, 169, 187), color(139, 165, 171), color(146, 161, 154), color(155, 156, 137),
                        color(164, 152, 118), color(172, 148, 100), color(180, 136, 78), color(187, 115, 52), color(193, 93, 26)};

  color[] dayC2Palette={color(128, 53, 7), color(198, 160, 32), color(198, 159, 68), color(174, 157, 115), color(151, 156, 158),
                        color(139, 157, 167), color(127, 159, 176), color(115, 160, 184), color(103, 161, 193), color(109, 160, 186),
                        color(116, 159, 179), color(125, 158, 171), color(138, 158, 161), color(151, 158, 150), color(167, 159, 136),
                        color(183, 160, 122), color(199, 161, 107), color(213, 157, 86), color(227, 148, 59), color(240, 138, 32)};

  color[] dayC3Palette={color(40, 30, 36), color(70, 52, 60), color(86, 87, 104), color(96, 126, 155), color(105, 161, 200),
                        color(108, 166, 210), color(110, 172, 220), color(113, 177, 230), color(115, 183, 240), color(105, 180, 237),
                        color(96, 177, 234), color(89, 172, 228), color(90, 163, 215), color(90, 154, 203), color(93, 145, 184),
                        color(98, 126, 163), color(103, 128, 141), color(107, 114, 116), color(110, 94, 88), color(114, 75, 60)};

  color[] dayC4Palette={color(37, 26, 36), color(62, 47, 59), color(55, 70, 103), color(38, 94, 155), color(23, 116, 201),
                        color(23, 127, 211), color(24, 138, 221), color(24, 148, 230), color(24, 159, 240), color(39, 161, 238),
                        color(53, 162, 235), color(71, 164, 230), color(96, 165, 219), color(120, 167, 209), color(142, 169, 195),
                        color(163, 172, 181), color(185, 174, 167), color(204, 174, 147), color(220, 171, 122), color(236, 168, 97)};

    
  color[] nightC1Palette={color(200, 72, 0), color(185, 64, 0), color(171, 55, 0), color(149, 43, 0), color(126, 30, 0), 
                          color(91, 20, 8), color(20, 15, 39), color(20, 12, 47), color(20, 9, 55), color(20, 8, 57)};

  color[] nightC2Palette={color(254, 128, 5), color(245, 125, 3), color(235, 122, 0), color(217, 105, 0), color(198, 88, 0), 
                          color(153, 64, 8), color(31, 17, 38), color(31, 14, 49), color(32, 11, 59), color(32, 11, 57)};

  color[] nightC3Palette={color(117, 55, 32), color(114, 47, 16), color(110, 39, 0), color(89, 34, 7), color(68, 28, 15), 
                          color(44, 22, 24), color(14, 15, 38), color(12, 12, 47), color(9, 9, 58), color(9, 9, 60)};

  color[] nightC4Palette={color(252, 165, 72), color(224, 128, 36), color(196, 90, 0), color(154, 67, 3), color(113, 44, 6), 
                          color(69, 24, 15), color(20, 15, 39), color(15, 12, 48), color(9, 9, 58), color(9, 9, 60)};

  Time(controller parent, Calendar sunrise, Calendar sunset) {
    // set the current time
    this.parent = parent;
    cal = null;
    this.sunrise = sunrise;
    this.sunset = sunset;
    int tweenTime = (int)(((sunset.get(Calendar.HOUR_OF_DAY) - sunrise.get(Calendar.HOUR_OF_DAY)) * .1) * 60) * 60;
    if(debug) println("TweenTime: " + tweenTime);
    tween = new Tween(parent, tweenTime, Tween.SECONDS, Shaper.QUADRATIC);
    tween.start();
  };

  void init() {
    // if the hour has changed since last time called, then get new information (extra layer of caching)
    Calendar now = Calendar.getInstance();
    if (debug) {
      sunrise.set(Calendar.HOUR_OF_DAY, 6);
      sunrise.set(Calendar.MINUTE, 0);
      sunset.set(Calendar.HOUR_OF_DAY, 18);
      sunset.set(Calendar.MINUTE, 0);
      now.set(Calendar.HOUR_OF_DAY, 18);
      now.set(Calendar.MINUTE, 36); 
    }
    if (cal == null || cal.get(Calendar.HOUR_OF_DAY) != now.get(Calendar.HOUR_OF_DAY)) {
      cal = now;
      // find out the amount of daylight hours today
      daylightHours = sunset.get(Calendar.HOUR_OF_DAY) - sunrise.get(Calendar.HOUR_OF_DAY);
      preDawnHours = sunrise.get(Calendar.HOUR_OF_DAY);
      postTwilightHours = 24 - sunset.get(Calendar.HOUR_OF_DAY);
      percentage = 0;
    }

    // TODO: only execute the below if the current duration interval for the tween has passed
    if(debug) println("compare: " + now.compareTo(sunrise));
    if (now.compareTo(sunrise) < 0) { // dawn
      tweenDuration = ((preDawnHours * .1) * 60) * 60;
      percentage = (((new Long(now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)).floatValue()) / (new Long(sunrise.get(Calendar.HOUR_OF_DAY) * 60 + sunrise.get(Calendar.MINUTE)).floatValue())) * 100.0);
      int nowcent = (round(percentage/10));
      if(debug) println("now: " + (now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)) + " sunrise: " + (sunrise.get(Calendar.HOUR_OF_DAY) * 60 + sunrise.get(Calendar.MINUTE)) + " percentage: " + (((new Long(now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE))).floatValue() / (new Long(sunrise.get(Calendar.HOUR_OF_DAY) * 60 + sunrise.get(Calendar.MINUTE))).floatValue()) * 100.0));
      if(debug) println("Daylight Hours: " + daylightHours + " Predawn Hours: " + preDawnHours + " Twilight Hours: " + postTwilightHours + " predawn percentage: " + percentage + " nowcent: " + nowcent);
      // GRADIENT COLOR TWEEN
      currentGradientC1 = dawnC1Palette[nowcent];
      currentGradientC2 = dawnC2Palette[nowcent];
      currentGradientC3 = dawnC3Palette[nowcent];
      currentGradientC4 = dawnC4Palette[nowcent];
      if (nowcent < 9) {
        nextGradientC1 = dawnC1Palette[nowcent + 1];
        nextGradientC2 = dawnC2Palette[nowcent + 1];
        nextGradientC3 = dawnC3Palette[nowcent + 1];
        nextGradientC4 = dawnC4Palette[nowcent + 1];
      } else {
        nextGradientC1 = dayC1Palette[0];
        nextGradientC2 = dayC2Palette[0];
        nextGradientC3 = dayC3Palette[0];
        nextGradientC4 = dayC4Palette[0];
      }
    } 
    else if (now.compareTo(sunset) < 0) { // day
      if(debug) println("day");
      tweenDuration = ((daylightHours * .1) * 60) * 60;
      float currTimeDiff = (new Long(now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)).floatValue()) - (new Long(sunrise.get(Calendar.HOUR_OF_DAY) * 60 + sunrise.get(Calendar.MINUTE)).floatValue());
      float sunriseSunsetDiff = (new Long(sunset.get(Calendar.HOUR_OF_DAY) * 60 + sunset.get(Calendar.MINUTE)).floatValue()) - (new Long(sunrise.get(Calendar.HOUR_OF_DAY) * 60 + sunrise.get(Calendar.MINUTE)).floatValue());
      percentage = ((currTimeDiff / sunriseSunsetDiff) * 100.0);
      int nowcent = (round(percentage/5));
      if(debug) println("now: " + (now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)) + " sunrise: " + (sunrise.get(Calendar.HOUR_OF_DAY) * 60 + sunrise.get(Calendar.MINUTE)) + " sunset: " + (sunset.get(Calendar.HOUR_OF_DAY) * 60 + sunset.get(Calendar.MINUTE)) + " percentage: " + ((currTimeDiff / (new Long(sunset.get(Calendar.HOUR_OF_DAY) * 60 + sunset.get(Calendar.MINUTE))).floatValue()) * 100.0) * .5);
      if(debug) println("currTimeDiff: " + currTimeDiff + " percentage: " + percentage + " nowcent: " + nowcent);
      // GRADIENT COLOR TWEEN
      currentGradientC1 = dayC1Palette[nowcent];
      currentGradientC2 = dayC2Palette[nowcent];
      currentGradientC3 = dayC3Palette[nowcent];
      currentGradientC4 = dayC4Palette[nowcent];
      if (nowcent < 19) {
        nextGradientC1 = dayC1Palette[nowcent + 1];
        nextGradientC2 = dayC2Palette[nowcent + 1];
        nextGradientC3 = dayC3Palette[nowcent + 1];
        nextGradientC4 = dayC4Palette[nowcent + 1];
      } else {
        nextGradientC1 = nightC1Palette[0];
        nextGradientC2 = nightC2Palette[0];
        nextGradientC3 = nightC3Palette[0];
        nextGradientC4 = nightC4Palette[0];
      }
    } 
    else { // night
      if(debug) println("night");  
      tweenDuration = ((postTwilightHours * .1) * 60) * 60;
      float currTimeDiff = (new Long(now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)).floatValue()) - (new Long(sunset.get(Calendar.HOUR_OF_DAY) * 60 + sunset.get(Calendar.MINUTE)).floatValue());
      float sunsetMidnightDiff = (new Long(23 * 60 + 59).floatValue()) - (new Long(sunset.get(Calendar.HOUR_OF_DAY) * 60 + sunset.get(Calendar.MINUTE)).floatValue());
      percentage = ((currTimeDiff / sunsetMidnightDiff) * 100.0);
      int nowcent = round(percentage/10);
      if(debug) println("Daylight Hours: " + daylightHours + " Predawn Hours: " + preDawnHours + " Twilight Hours: " + postTwilightHours + " predawn percentage: " + percentage + " nowcent: " + nowcent);
      // GRADIENT COLOR TWEEN
      currentGradientC1 = nightC1Palette[nowcent];
      currentGradientC2 = nightC2Palette[nowcent];
      currentGradientC3 = nightC3Palette[nowcent];
      currentGradientC4 = nightC4Palette[nowcent];
      if (nowcent < 9) {
        nextGradientC1 = nightC1Palette[nowcent + 1];
        nextGradientC2 = nightC2Palette[nowcent + 1];
        nextGradientC3 = nightC3Palette[nowcent + 1];
        nextGradientC4 = nightC4Palette[nowcent + 1];
      } else {
        nextGradientC1 = dawnC1Palette[0];
        nextGradientC2 = dawnC2Palette[0];
        nextGradientC3 = dawnC3Palette[0];
        nextGradientC4 = dawnC4Palette[0];
      }
    }
    tween.setDuration(tweenDuration, Tween.SECONDS);
  }

  void render() {
    init();
    // set a gradient based on the time of day
    // GRADIENT COLOR TWEEN
    tweenGradient(0, 0, width, height, currentGradientC1, currentGradientC2, currentGradientC3, currentGradientC4, nextGradientC1, nextGradientC2, nextGradientC3, nextGradientC4);
  }

  // GRADIENT COLOR TWEEN
  void tweenGradient(int x, int y, float w, float h, color c1, color c2, color c3, color c4, color co1, color co2, color co3, color co4) {
    // get the start color and end colors to tween between
    color tweenC1 = lerpColor( c1, co1, tween.position() );
    color tweenC2 = lerpColor( c2, co2, tween.position() );
    color tweenC3 = lerpColor( c3, co4, tween.position() );
    color tweenC4 = lerpColor( c3, co4, tween.position() );
    setGradient(x, y, w, h, tweenC1, tweenC2, tweenC3, tweenC4);
  }

  void setGradient(int x, int y, float w, float h, color c1, color c2, color c3, color c4){
        beginShape(QUADS);
        fill(c1);
        vertex(0,0);
        fill(c2);
        vertex(w,0);
        fill(c4);
        vertex(w,h);
        fill(c3);
        vertex(0,h);
        endShape();
  }
};

