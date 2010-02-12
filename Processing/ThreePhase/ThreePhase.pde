import peasy.*;

PeasyCam cam;

int inputWidth, inputHeight;
float[][] phase, distance, order;
boolean[][] mask, process;
color[][] colors;

boolean update;

void setup() {
  size(480, 640, P3D);
  
  loadImages();
  inputWidth = phase1Image.width;
  inputHeight = phase1Image.height;
  phase = new float[inputHeight][inputWidth];
  distance = new float[inputHeight][inputWidth];
  order = new float[inputHeight][inputWidth];
  mask = new boolean[inputHeight][inputWidth];
  process = new boolean[inputHeight][inputWidth];
  colors = new color[inputHeight][inputWidth];
  
  cam = new PeasyCam(this, width);  
  setupControls();

  update = true;
}

void draw () {
  background(0);
  translate(-width / 2, -height / 2);
  
  if(update) {
    phaseWrap();
    phaseUnwrap();
    update = false;
    //saveImage(order, "order.png"); // uncomment to visualize the unwrapping order
  }
  
  noFill();
  for (int y = 0; y < inputHeight; y += renderDetail) {
    float planephase = 0.5 - (y - (inputHeight / 2)) / zskew;
    for (int x = 0; x < inputWidth; x += renderDetail)
      if (!mask[y][x]) {
        stroke(colors[y][x], 255);
        point(x, y, (phase[y][x] - planephase) * zscale);
      }
  }
  
  if(takeScreenshot) {
    saveFrame(day() + " " + hour() + " " + minute() + " " + second() + ".png");
    takeScreenshot = false;
  }
}

void saveImage(float[][] ref, String name) {
  pushStyle();
  colorMode(RGB, 1.0);
  PImage img = createImage(inputWidth, inputHeight, GRAY);
  img.loadPixels();
  for(int y = 0; y < inputHeight; y++) {
    for(int x = 0; x < inputWidth; x++) {
      img.pixels[y * inputWidth + x] = color(ref[y][x] * 16 % 1.);
    }
  }
  img.save(name);
  popStyle();
}
