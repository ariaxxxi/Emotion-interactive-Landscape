void setParticles() {
  particles = new Particle[10000];
  for (int i = 0; i < 10000; i++) {
    float x = random(width);
    float y = random(height);
    particles[i]= new Particle(x, y );
  }
}

class Particle {
  float posX, posY, incr, theta;
  color  c;

  Particle(float xIn, float yIn) {
    posX = xIn;
    posY = yIn;
  }

  public void move() {
    update();
    wrap();
    display();
  }

  void update() {
    incr +=  0.01*speed;
    float k = 0.02 * map(mouthsize, 0.3 , 0.44 , 0.05 , 0.45);
    theta = noise(posX * k , posY * .009 , incr) * TWO_PI;
    posX += 0 * sin(theta); //was cos
    posY += 1 *speed* tan(theta);
  }

  void display() {

    if (posX > 0 && posX < width && posY > 0  && posY < height) {
      pixels[(int)posX + (int)posY * width] = color(adj0, adj1, adj2);
    }
  }

  void wrap() {
    if (posX < 0) posX = width;
    if (posX > width ) posX =  0;
    if (posY < 0 ) posY = height;
    if (posY > height) posY =  0;
  }
}
