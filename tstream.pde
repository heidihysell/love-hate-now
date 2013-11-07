public class TStream {

  boolean debug = true;
  
  // this stores how many tweets we've received per hour
  int tweetsPerHour = 0;
  // time last tweet came through
  Calendar lastTweetTime;
  // and this stores the text of the last tweet
  String currentTweet = "";
  // stores the last 50 tweets for retrieval of history by other tools (mood)
  String[] tweets = new String[50];


  TStream(){
    PFont font = loadFont("fonts/CharcoalCY-24.vlw");
    textFont(font, 24);
    // set up twitter stream object
    init();
  };
  
  void init() {
  }
  
  void render() {
    //fill(255, 255, 255);
    // draw a box as many pixels wide as the number of tweets we've seen
//    rect(-1200, 335, tweets, 20);
    // and draw the text of the last tweet
//    text(, -1200, 390);
//  int b=0;
//  int i=0;
//  int t=0;
//  int d=0;
//  int a=0;
//  int n=0;
//  int c=0;
//  int e=0;
//   n=tweetsPerHour&63;
//   for(background(i=0);i++<n*n;stroke(-1,e+=n-dist(a=f(),b=f(),c=f(),d=f())-e))
//     if(e>0)line(a,b,c,d);
//   int f(){return int(500*noise(t++%4>1?i/n:i%n,t%2*n+t/1E6))};
//  background(255);
//  translate(width/2, height/2);
//  float a = 0.0;
//  rotateX(a);
//  rotateY(a*2);
//  rect(-200, -200, 400, 400);
//  rotateX(PI/2);
//  rect(-200, -200, 400, 400);
//  a += 0.01;

  }

  // called by twitter stream whenever a new tweet comes in
  void tweet(Status tweet) {
    // print a message to the console just for giggles if you like
    if (tweet != null) {
      Calendar now = Calendar.getInstance();
      // store the latest tweet text
      currentTweet = tweet.text();
      if(debug) println(currentTweet);
      // bump our tweet count by one
      if (lastTweetTime == null || lastTweetTime.get(Calendar.HOUR_OF_DAY) == now.get(Calendar.HOUR_OF_DAY)) {
        tweetsPerHour++;
        // BEWARE: PROCESSING IS BEING TEMPERMENTAL WITH THESE LINES
//        if (tweets.length < 50) {
//          if(debug) println("adding historical tweet");
//          tweets[tweetsPerHour] = currentTweet;
//        }
      } else {
       lastTweetTime = now; 
       tweetsPerHour = 0;
        // BEWARE: PROCESSING IS BEING TEMPERMENTAL WITH THESE LINES
//       tweets = new String[50];
      }
    }
  }
  
}
