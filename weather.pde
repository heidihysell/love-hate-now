/*
 * Uses the YAHOO! weather api rss feed
 * http://developer.yahoo.com/weather/
 *
 */
public class Weather {

  boolean debug = false;
  
  // timer information
  int delayTimer = 600000; // should retrieve every 10 minutes
  int startTimer = 0;
  
  String WOEID = "2459115"; // new york  TODO make configurable
  
  String sunrise = "";
  String sunset = "";
  int temp = 0;
  int windSpeed = 1;
  int code = 3200;
  
  HashMap weatherCodes = new HashMap();

  //elements
  proxml.XMLElement xmlWeather;
  proxml.XMLInOut xmlIO;

  Weather(controller parent) {
    
    xmlIO = new XMLInOut(parent);
//    PeasyCam peasycam = new PeasyCam(parent, 1600);
    weatherCodes.put(0, "weather/tornados.svg");
    weatherCodes.put(1, "weather/tropicalStorm.svg");
    weatherCodes.put(2, "weather/hurricane.svg");
    weatherCodes.put(3, "weather/severeThunderstorms.svg");
    weatherCodes.put(4, "weather/thunderstaorms.svg");
    weatherCodes.put(5, "weather/rainsnow.svg");
    weatherCodes.put(6, "weather/rainSleet.svg");
    weatherCodes.put(7, "weather/snowSleet.svg");
    weatherCodes.put(8, "weather/freezingDrizzel.svg");
    weatherCodes.put(9, "weather/drizzel.svg");
    weatherCodes.put(10, "weather/freezingRain.svg");
    weatherCodes.put(11, "weather/showers.svg");
    weatherCodes.put(12, "weather/showers.svg");
    weatherCodes.put(13, "weather/snowFlurries.svg");
    weatherCodes.put(14, "weather/lightSnowShowers.svg");
    weatherCodes.put(15, "weather/blowingSnow.svg");
    weatherCodes.put(16, "weather/snow.svg");
    weatherCodes.put(17, "weather/hail.svg");
    weatherCodes.put(18, "weather/sleet.svg");
    weatherCodes.put(19, "weather/dust.svg");
    weatherCodes.put(20, "weather/foggy.svg");
    weatherCodes.put(21, "weather/haze.svg");
    weatherCodes.put(22, "weather/smokey.svg");
    weatherCodes.put(23, "weather/blustry.svg");
    weatherCodes.put(24, "weather/windy.svg");
    weatherCodes.put(25, "weather/cold.svg");
    weatherCodes.put(26, "weather/cloudy.svg");
    weatherCodes.put(27, "weather/mostlyCloudyNight.svg");
    weatherCodes.put(28, "weather/mostlyCloudyDay.svg");
    weatherCodes.put(29, "weather/partlyCloudyNight.svg");
    weatherCodes.put(30, "weather/partlyCloudyDay.svg");
    weatherCodes.put(31, "weather/clearNight.svg");
    weatherCodes.put(32, "weather/sunny.svg");
    weatherCodes.put(33, "weather/fairNight.svg");
    weatherCodes.put(34, "weather/fairDay.svg");
    weatherCodes.put(35, "weather/mixedRainHail.svg");
    weatherCodes.put(36, "weather/hot.svg");
    weatherCodes.put(37, "weather/isolatedThunderstorms.svg");
    weatherCodes.put(38, "weather/scatteredThunderstorms.svg");
    weatherCodes.put(39, "weather/scatteredThunderstorms.svg");
    weatherCodes.put(40, "weather/scatteredShowers.svg");
    weatherCodes.put(41, "weather/heavySnow.svg");
    weatherCodes.put(42, "weather/scatteredSnowShowers.svg");
    weatherCodes.put(43, "weather/heavySnow.svg");
    weatherCodes.put(44, "weather/partlyCloudy.svg");
    weatherCodes.put(45, "weather/thundershowers.svg");
    weatherCodes.put(46, "weather/snowshowers.svg");
    weatherCodes.put(47, "weather/isolatedthundershowers.svg");
    weatherCodes.put(3200, "weather/notavailable.svg");
    init();
  };
  
  void init() {
    PFont font = loadFont("fonts/CharcoalCY-24.vlw");
    textFont(font, 56);
    request();    
    //loomingCloudInit(peasycam);
  }
  
  void render() {
    // and draw the text of the last tweet
    fill(255, 255, 255);
    if(debug) text("Current Temp: " + String.valueOf(temp), -1200, 190);
    if(debug) text("Sunrise: " + sunrise, -1200, 240);
    if(debug) text("Sunset: " + sunset, -1200, 290);
    // TODO: test different weather conditions and show only the applicable condition
    //loomingCloudDraw();
  }
  
  // http://www.openprocessing.org/visuals/?visualID=6753
//  PeasyCam peasycam;
//  Vec3D globalOffset, avg, cameraCenter;
//  float neighborhood, viscosity, speed, turbulence, cameraRate, rebirthRadius, spread, independence, dofRatio;
//  int n, rebirth;
//  boolean averageRebirth;
//  Vector particles;
//  PeasyCam cam;
//  Plane focalPlane;
//
//  void loomingCloudInit() {
//    // initializations
//    n = 1000;
//    neighborhood = 700;
//    speed = windSpeed;
//    viscosity = .9;
//    spread = 100;
//    independence = .15;
//    dofRatio = 50;
//    rebirth = 0;
//    rebirthRadius = 250;
//    turbulence = 5.0;
//    cameraRate = .5;
//    averageRebirth = false;
//    
//    cam = peasycam;
// 
//    cameraCenter = new Vec3D();
//    avg = new Vec3D();
//    globalOffset = new Vec3D(0, 1. / 3, 2. / 3);
//    
//    float[] camPosition = cam.getPosition();
//    focalPlane = new Plane(avg, new Vec3D(camPosition[0], camPosition[1], camPosition[2]));
//    
//    particles = new Vector();
//    for(int i = 0; i < n; i++) {
//      particles.add(new CloudParticle(rebirthRadius, particles, avg, focalPlane, dofRatio, neighborhood, globalOffset, independence, viscosity, spread, speed));
//    } 
//  }

//  void loomingCloudDraw() {
//    avg = new Vec3D();
//    for(int i = 0; i < particles.size(); i++) {
//      CloudParticle cur = ((CloudParticle) particles.get(i));
//      avg.addSelf(cur.position);
//    }
//    avg.scaleSelf(1. / particles.size());
//    
//    cameraCenter.scaleSelf(1 - cameraRate);
//    cameraCenter.addSelf(avg.scale(cameraRate));
//    
//    translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);
//    
//    noFill();
//    hint(DISABLE_DEPTH_TEST);
//    for(int i = 0; i < particles.size(); i++) {
//      CloudParticle cur = ((CloudParticle) particles.get(i));
//      cur.update();
//      cur.draw();
//    }
//    
//    for(int i = 0; i < rebirth; i++)
//      randomParticle().resetPosition();
//    
//    if(particles.size() > n) {
//      particles.setSize(n);
//    }
//    while(particles.size() < n) {
//      particles.add(new CloudParticle(rebirthRadius, particles, avg, focalPlane, dofRatio, neighborhood, globalOffset, independence, viscosity, spread, speed));
//    }
//    
//    globalOffset.addSelf(
//      turbulence / neighborhood,
//      turbulence / neighborhood,
//      turbulence / neighborhood);
//
//  }
//  
//  CloudParticle randomParticle() {
//    return ((CloudParticle) particles.get((int) random(particles.size())));
//  }
//  
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
    windSpeed = node.getChild(8).getIntAttribute("speed");
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
  
