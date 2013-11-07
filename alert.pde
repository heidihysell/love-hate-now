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
  
  void init() {
    startTimer = millis();
    alert=false;
    //request();
  }
  
  void render() {
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
  
  String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  void request() {
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
  
  boolean getAlert() { return alert; }
  void setAlert(boolean alert) { this.alert = alert; }
  
};
  
