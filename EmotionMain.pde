import cvimage.*;
import org.opencv.core.*;
import org.opencv.core.Core;
import org.opencv.face.Face;
import org.opencv.face.Facemark;
import org.opencv.face.EigenFaceRecognizer;
import processing.video.*;
Capture video;
final int W = 640, H = 480;
String faceFile, modelFile;
Facemark fm;
ArrayList<MatOfPoint2f> shapes ;
Point [] pinhua;
float mouthsize=0;
float eyesize=0;
float eyebrow=0;
float mouthheight=0;
boolean debug=false;
float adj0=0, adj1=0, adj2=0;

Particle[] particles;
float alpha;
float speed;
float amount;

void setup() {
  size(1920 , 1080);
  background(0);
  noStroke();
  setParticles();
  FaceSetup();
}

void draw() {
    float red = map(mouseX,0,width,0,255);
  //setParticles();
  frameRate(30);
  float eyes =constrain(eyesize, 0.16, 0.3);
  alpha = map(eyes, 0.2, 0.36, 0, 8);
  fill(0, alpha);
  rect(0, 0, width, height);
  float sp=constrain(mouthheight, 0.1, 0.3);
  speed=map(sp, 0.1, 0.3, 1.5, 2.5);
  float am=constrain(eyebrow, 0.09, 0.14);
  amount =map(am, 0.09, 0.14, 0.8, 2);
  loadPixels();
    float col0=0, col1=0, col2=0;
     if (mouthsize<0.35) { //dark blue
      col0=0;
      col1=44;
      col2=255;
    }
    if (mouthsize>=0.35&&mouthsize<0.37) {//嘴角度控制颜色
      col0=0;
      col1=112;
      col2=255;
    }
    if (mouthsize>=0.37&&mouthsize<0.39) {
      col0=0;
      col1=255;
      col2=219;
    }
    if (mouthsize>=0.39&&mouthsize<0.41) {
      col0=8;
      col1=158;
      col2=255;
    }
     if (mouthsize>=0.41&&mouthsize<0.42) { //purple
      col0=182;
      col1=82;
      col2=255;
    }
    if (mouthsize>=0.42) { //pink
      col0=255;
      col1=106;
      col2=178;
    }
    if (mouthheight>=0.2) {
      col0=255;
      col1=75;
      col2=87;
    }
    adj0 += (col0-adj0)*0.8;
    adj1 += (col1-adj1)*0.8;
    adj2 += (col2-adj2)*0.8;
    
    //adj0 = map(mouthsize,0.3,0.44,0,255);
    //adj1 = map(mouthheight,0.05,0.22,0,200);
    println("red="+ red);
    println("adj0=" + adj0);
    println("adj1=" + adj1);
    println("eyebrow="+eyebrow);
    println("mouthsize="+mouthsize);
    println("mouthheight="+mouthheight);
    println("eyesize="+eyesize);
    println("alpha="+alpha);
  for (Particle p : particles) {
    p.move();
    
  }
  updatePixels();
  FaceUpdate();
}


void keyPressed()
{

  if (key=='d'||key=='D') {
    if (debug==false)
      debug=true;
    else debug=false;

    background(0);
  }
}
