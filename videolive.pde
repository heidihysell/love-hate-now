/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */ 
public class VideoLive {

  Capture video;
  color colorTint;

  VideoLive(controller parent) {
    video = new Capture(parent, width, height, 24);
    colorTint = color(255,255,255);
    init(); 
  }

  void init() {
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


  void render() {
    if (video.available() == true) {
      video.read();
      tint(colorTint, 55);//126);
      image(video, 0, 0);
      // The following does the same, and is faster when just drawing the image
      // without any additional resizing, transformations, or tint.
      //set(160, 100, video);
    }
  } 
  
}
