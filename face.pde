void FaceSetup() {
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  faceFile = "haarcascade_frontalface_default.xml";
  modelFile = "face_landmark_model.dat";
  fm = Face.createFacemarkKazemi();
  fm.loadModel(dataPath(modelFile));
  video = new Capture(this, W, H);
  video.start();  
  pinhua=new Point[68];
  for (int i=0; i<68; i++) {
    pinhua[i]=new Point();
    pinhua[i].x=0;
    pinhua[i].y=0;
  }
}


void FaceUpdate() {
  if (debug)
    image(video, 0, 0);
  if (shapes!=null) {
    PVector origin = new PVector(0, 0);
    for (MatOfPoint2f sh : shapes) {
      Point [] pts = sh.toArray();
      drawFacemarks(pts, origin);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
  c.updatePixels();
  shapes=detectFacemarks(c);
}

private ArrayList<MatOfPoint2f> detectFacemarks(PImage i) {
  ArrayList<MatOfPoint2f> shapes = new ArrayList<MatOfPoint2f>();
  CVImage im = new CVImage(i.width, i.height);
  im.copyTo(i);
  MatOfRect faces = new MatOfRect();
  Face.getFacesHAAR(im.getBGR(), faces, dataPath(faceFile)); 
  if (!faces.empty()) {
    fm.fit(im.getBGR(), faces, shapes);
  }
  return shapes;
}

private void drawFacemarks(Point [] p, PVector o) {
  int keypoint[]={
    0, 16, //脸两侧
    17, 18, 19, 20, 21, //左眉毛
    22, 23, 24, 25, 26, // 右眉毛
    36, 37, 38, 39, 40, 41, //左眼
    42, 43, 44, 45, 46, 47, //右眼
    48, //嘴左
    51, //嘴上
    54, //嘴右
    57//嘴下
  };
  pushStyle();
  noStroke();
  fill(255);
  for (int j=0; j<keypoint.length; j++) {
    for (int i=0; i<p.length; i++) {
      if (i==keypoint[j]) {
        if (dist((float)p[0].x+o.x, (float)p[0].y+o.y, (float)p[16].x+o.x, (float)p[16].y+o.y)>20) {
          pinhua[i].x+=((float)p[i].x+o.x-pinhua[i].x)*0.4;
          pinhua[i].y+=((float)p[i].y+o.y-pinhua[i].y)*0.4;
        }
        if (debug)
          ellipse((float)pinhua[i].x, (float)pinhua[i].y, 3, 3);
      }
    }
  }
  popStyle();
  float nowmouth=dist((float)pinhua[48].x, (float)pinhua[48].y, (float)pinhua[54].x, (float)pinhua[54].y)/(dist((float)pinhua[0].x, (float)pinhua[0].y, (float)pinhua[16].x, (float)pinhua[16].y)+0.01);
  mouthsize+=(nowmouth-mouthsize)*0.1;//嘴宽

  float dist1=dist((float)pinhua[37].x, (float)pinhua[37].y, (float)pinhua[41].x, (float)pinhua[41].y);
  float dist2=dist((float)pinhua[38].x, (float)pinhua[38].y, (float)pinhua[40].x, (float)pinhua[40].y);
  float dist3=dist((float)pinhua[43].x, (float)pinhua[43].y, (float)pinhua[47].x, (float)pinhua[47].y);
  float dist4=dist((float)pinhua[44].x, (float)pinhua[44].y, (float)pinhua[46].x, (float)pinhua[46].y);
  float dist5=dist((float)pinhua[36].x, (float)pinhua[36].y, (float)pinhua[39].x, (float)pinhua[39].y);
  float dist6=dist((float)pinhua[42].x, (float)pinhua[42].y, (float)pinhua[45].x, (float)pinhua[45].y);

  float noweye=((dist1+dist2+dist3+dist4)/2)/(dist5+dist6+0.01);
  eyesize+=(noweye-eyesize)*0.1;//眼睛大小

  float nowbrow=dist((float)pinhua[21].x, (float)pinhua[21].y, (float)pinhua[22].x, (float)pinhua[22].y)/(dist((float)pinhua[0].x, (float)pinhua[0].y, (float)pinhua[16].x, (float)pinhua[16].y)+0.01);
  eyebrow+=(nowbrow-eyebrow)*0.1;//眉毛间距

  float nowmouthheight=dist((float)pinhua[51].x, (float)pinhua[51].y, (float)pinhua[57].x, (float)pinhua[57].y)/(dist((float)pinhua[0].x, (float)pinhua[0].y, (float)pinhua[16].x, (float)pinhua[16].y)+0.01);
  mouthheight+=(nowmouthheight-mouthheight)*0.1;//嘴高

}
