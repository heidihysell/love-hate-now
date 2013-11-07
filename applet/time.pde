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

  color currentGradientStart;
  color currentGradientEnd;

  color nextGradientStart;
  color nextGradientEnd;
  
  color[] dawnStartPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                            color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

  color[] dawnEndPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                          color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

  
  color[] dayStartPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                           color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};


  color[] dayEndPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                         color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

    
  color[] nightStartPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                             color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};


  color[] nightEndPalette={color(25, 0, 0), color(50, 0, 0), color(75, 0, 0), color(100, 0, 0), color(125, 0, 0),
                           color(150, 0, 0), color(175, 0, 0), color(200, 0, 0), color(225, 0, 0), color(255, 0, 0)};

  Time(Calendar sunrise, Calendar sunset, Tween settween) {
    // set the current time
    cal = null;
    this.sunrise = sunrise;
    this.sunset = sunset;
    tween = settween;
    tween.start();
  };

  void init() {
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
      tween.setDuration(((preDawnHours * .1) * 60));
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
      tween.setDuration(((daylightHours * .1) * 60));
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
      tween.setDuration(((postTwilightHours * .1) * 60));
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

  void render() {
    init();
    // set a gradient based on the time of day
    tweenGradient(0, 0, width, height, currentGradientStart, currentGradientEnd, nextGradientStart, nextGradientEnd, Y_AXIS);
  }

  void tweenGradient(int x, int y, float w, float h, color c1, color c2, color co1, color co2, int axis) {
    // get the start color and end colors to tween between
    color start = lerpColor( c1, co1, tween.position() );
    color end = lerpColor( c2, co2, tween.position() );
    setGradient(x, y, w, h, start, end, axis);
  }

  void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ){
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
          color c = color(
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
          color c = color(
          (red(c1)+(j-x)*(deltaR/h)),
          (green(c1)+(j-x)*(deltaG/h)),
          (blue(c1)+(j-x)*(deltaB/h)) 
            );
          set(j, i, c);
        }
      }  
    }
  }


  void renderImage() {    
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

  void initImage() {
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

