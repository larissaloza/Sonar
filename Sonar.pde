
import gab.opencv.*;  // Import the OpenCV library for image processing
import peasy.PeasyCam;  // Import the PeasyCam library for easy 3D camera control
import processing.video.*;  // Import the video library for video capture
import ddf.minim.*;  // Import the Minim library for audio playback

int numPixels;  // Declare a variable to hold the total number of pixels in the video
int[] backgroundPixels;  // Declare an array to store the background pixel colors

Capture video;  // Declare a Capture object for video input
PGraphics videoBuffer;  // Declare a PGraphics object to store the video frames
PeasyCam cam;  // Declare a PeasyCam object for controlling the 3D camera

OpenCV opencv;  // Declare an OpenCV object for processing the video frames
Minim minim;  // Declare a Minim object for audio playback
AudioPlayer player;  // Declare an AudioPlayer object for playing the audio file

int cnt = 0;  // Initialize a counter to control the background capture interval


void setup() {
  size(1280, 960, P3D);  // Set up the sketch window size  and use the P3D renderer for 3D graphics

 video = new Capture(this, width, height, 30);  // Initialize the video capture with the same width and height as the window, and set the frame rate to 30 FPS
  video.start();  // Start the video capture
  videoBuffer = createGraphics(width, height, P3D);  // Create a PGraphics object with the same dimensions as the window, using the P3D renderer

  cam = new PeasyCam(this, 600);  // Initialize the PeasyCam object with a starting distance of 600 units

  numPixels = video.width * video.height;  // Calculate the total number of pixels in the video
  backgroundPixels = new int[numPixels];  // Initialize the backgroundPixels array with the same size as the number of pixels
  loadPixels();  // Load the pixel data into the pixels[] array
  
    opencv = new OpenCV(this, video);  // Initialize the OpenCV object with the video capture as input
  minim = new Minim(this);  // Initialize the Minim object
  player = minim.loadFile("experimental.mp3");  // Load the audio file from the data folder
  player.loop();  // Loop the audio file continuously
}


void draw() {
  
 // BACKGROUND SUBSTRACTION
  frameRate(30);

  if (video.available()) {  // Check if a new video frame is available
    video.read();  // Read the new frame from the video
    video.loadPixels();  // Load the pixel data from the video frame

    int presenceSum = 0;  // Initialize a variable to sum the color differences between the current and background pixels

    for (int i = 0; i < numPixels; i++) {  // Loop through all the pixels in the video frame
      color currColor = video.pixels[i];  // Get the current pixel color
      color bkgdColor = backgroundPixels[i];  // Get the corresponding background pixel color
      int currR = (currColor >> 16) & 0xFF;  // Extract the red component of the current pixel color
      int currG = (currColor >> 8) & 0xFF;  // Extract the green component of the current pixel color
      int currB = currColor & 0xFF;  // Extract the blue component of the current pixel color
      int bkgdR = (bkgdColor >> 16) & 0xFF;  // Extract the red component of the background pixel color
      int bkgdG = (bkgdColor >> 8) & 0xFF;  // Extract the green component of the background pixel color
      int bkgdB = bkgdColor & 0xFF;  // Extract the blue component of the background pixel color
      int diffR = abs(currR - bkgdR);  // Calculate the absolute difference in the red component
      int diffG = abs(currG - bkgdG);  // Calculate the absolute difference in the green component
      int diffB = abs(currB - bkgdB);  // Calculate the absolute difference in the blue component
      presenceSum += diffR + diffG + diffB;  // Add the differences to the presenceSum
      pixels[i] = color(diffR, diffG, diffB);  // Set the pixel color in the display to the difference
    }
    updatePixels();  // Update the display with the new pixel data
    // println(presenceSum);  // Print the sum of differences (presence) to the console

    if (cnt == 20 || cnt == 0) {  // Check if it's time to update the background (every 20 frames)
      if (cnt == 20) {
        cnt = 0;  // Reset the counter if it reached the number set above
      }

      video.loadPixels();  // Load the current video pixels
      arraycopy(video.pixels, backgroundPixels);  // Copy the current frame's pixels to the backgroundPixels array
    }

    cnt++;  // Increment the counter
  }
  
  
  //VIDEO A LINEAS HORIZONTALES EN 3D  
  // background(50);  // Background color

  if (video.available()) {
    video.read();  // Read the new video frame into the Capture object
  }

  videoBuffer.beginDraw();  // Begin drawing on the videoBuffer
  videoBuffer.image(video, 0, 0);  // Draw the current video frame onto the videoBuffer
  videoBuffer.endDraw();  // End drawing on the videoBuffer

  videoBuffer.loadPixels();  // Load the pixel data from the videoBuffer for processing

  translate(-width / 2, -height / 2, 0);  // Translate the origin to the center of the screen for easier 3D manipulation
  strokeWeight(1);  // Set the stroke weight to 1 pixel for drawing
  noFill();  // Disable filling shapes with color (only draw outlines)

  // Loop through the videoBuffer in the y-direction with a step of 4 pixels
  for (int y = 0; y < videoBuffer.height; y += 4) {
    beginShape();  // Begin a new shape (a polyline)
    for (int x = 0; x < videoBuffer.width; x++) {
      int pixelValue = videoBuffer.pixels[x + (y * videoBuffer.width)];  // Get the pixel value at (x, y) in the videoBuffer
      float brightnessValue = brightness(pixelValue);  // Calculate the brightness of the pixel (0 to 255)
      float z = map(brightnessValue, 0, 255, -200, 200);  // Map the brightness value to a z-coordinate in the range of -200 to 200
      stroke(brightnessValue);  // Set the stroke color based on the brightness value
      vertex(x, y, z);  // Define a vertex in 3D space at (x, y, z)
    }
    endShape();  // End the shape (the polyline)
  }
  
   //Sound and brightest point
    
  opencv.loadImage(video);  // Load the current video frame into OpenCV for processing

  PVector loc = opencv.max();  // Find the brightest point (maximum intensity) in the video frame

  // Map the x-coordinate of the brightest point to the volume range (0.0 to 1.0)
  float volume = map(loc.x, 0, width, 0.0, 1.0);
  player.setGain(volume * 50 - 50);  // Adjust the volume of the audio player (Minim's setGain method uses dB, so map volume from [0,1] to [-50,50] dB)
 
           saveFrame ("output/frame-####.png");   
  //guardar frame en carpeta output como .png
  
}

void keyPressed() {
  video.loadPixels();  // Load the current video pixels
  arraycopy(video.pixels, backgroundPixels);  // Copy the current frame's pixels to the backgroundPixels array (manual background reset)
}

//void captureEvent(Capture c) {
//  c.read();  // Read the incoming video frame into the Capture object
//}
