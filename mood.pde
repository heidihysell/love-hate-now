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
  
  void render() {

  }
  
  String setupProxy(String url, String id) {
    String requestURL = "";
    String proxyURL = "http://heidihysell.com/projects/mood/proxy.php";
    String encodedURL = URLEncoder.encode(url);
    requestURL = proxyURL + "?id=" + id + "&url=" + encodedURL;
    return requestURL;
  }
  
  void request(String inputUrl, String inputText, String id) {
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
