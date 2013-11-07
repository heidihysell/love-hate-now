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
  
  void init() {
  }
  
  void render() {
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
