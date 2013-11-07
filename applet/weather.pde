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
  
  void init() {
    PFont font = loadFont("fonts/CharcoalCY-24.vlw");
    textFont(font, 24);
    request();
  }
  
  void render() {
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
  
  String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  void request() {
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
  
  void parseXML() {
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
  
  Calendar parseDateString(String timestamp) {
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
  Calendar sunrise() {
    return parseDateString(sunrise);
  }
  Calendar sunset() {
    return parseDateString(sunset);
  }
  int temp() {
    return temp;
  }
//  int state() { // return the image associated with the state of the weather
//    
//  }
};
  
