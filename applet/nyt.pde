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
  
  void init() {
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
  
  void render() {
    try {
      if(debug) println("total: " + contents.getInt("total"));
    } catch (Exception e) {
     if(debug) e.printStackTrace();
    }
  }
  
  String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    if(debug) println("news url " + encodedURL);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  void request(String word, String startDate, String endDate) {
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
  
  JSONObject getContents() {
    return contents;
  }
  
};
