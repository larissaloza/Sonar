This project is a multimedia Processing sketch that integrates video capture, audio playback, and 3D visualizations using several libraries: OpenCV for image processing, PeasyCam for 3D camera control, Processing's video library for video capture, and Minim for audio playback.

Overview:
Video Capture: The sketch captures video input using the Capture class and stores the frames in a PGraphics buffer. It processes each frame pixel by pixel to perform background subtraction, where differences between the current frame and a saved background frame are highlighted.

Background Subtraction: Using the OpenCV library, the sketch processes each frame to calculate the color difference between the current frame and a static background, creating a dynamic visual representation of motion or presence in the scene. The background updates every 20 frames or upon a key press.

3D Visualization: The video is also rendered as a series of horizontal lines in 3D space, where each line's depth is determined by the brightness of the corresponding pixel. This creates a dynamic 3D wave-like structure that responds to the video content.

Audio Integration: The project plays an audio file using the Minim library. The brightness of the video frame determines the volume of the audio, dynamically adjusting based on the position of the brightest pixel.

Libraries:
OpenCV (gab.opencv.*): Used for computer vision tasks, particularly for processing the video input and detecting the brightest point in each frame.
PeasyCam (peasy.PeasyCam): Provides intuitive camera control for navigating the 3D scene created from the video frames.
Processing Video Library (processing.video.*): Handles real-time video capture, allowing the sketch to read and process live video frames.
Minim (ddf.minim.*): Manages audio playback, allowing the sketch to play an MP3 file and adjust its volume in response to video input.

Features:
Real-time video capture and background subtraction: Highlights motion or differences from the static background.
3D representation of video frames: The brightness of each pixel affects the Z-axis position of corresponding points in the 3D space, creating a dynamic waveform.
Interactive audio-visual experience: The brightness of the video controls the volume of the audio track, creating an interplay between the visual and audio components.
Frame saving: Each processed frame can be saved as a PNG file in an output directory.
