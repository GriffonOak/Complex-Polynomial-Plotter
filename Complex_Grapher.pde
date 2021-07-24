
//CENTREING AND SCALING
float scaleHeight = 2;
float scaleWidth = 2;
PVector centrePoint = new PVector(0, 0);

//COLOR
int hueBuckets = 256;

//FUNCTION
float[] polynomial = {1, 0, 0, 0, 0, 1};

void setup() {
  size(1600, 800); 
  colorMode(HSB, TAU, 1, 1.0);
}

void draw() {

  loadPixels();
  for (int i = 0; i < width/2; i++) {
    for (int j = 0; j < height; j++) {
      pixels[i + j * width] = assignColour(scaleCoord(i, j));
    }
  }
  updatePixels();

  loadPixels();
  for (int i = width/2; i < width; i++) {
    for (int j = 0; j < height; j++) {
      PVector original = scaleCoord(i-width/2, j);
      PVector transformed = function(original, polynomial);

      pixels[i + j * width] = assignColour(transformed);
    }
  }
  updatePixels();
}

PVector scaleCoord(int x, int y) {
  float newX = map(x, 0, width/2, centrePoint.x - scaleWidth, centrePoint.x + scaleWidth);
  float newY = map(y, 0, height, centrePoint.y - scaleHeight, centrePoint.y + scaleHeight);

  return new PVector(newX, newY);
}

float invDistance(float d) {
  return 1 - 1/(2*d+1);
}

color assignColour(PVector a) {
  float dist = dist(0, 0, a.x, a.y);
  float angle = atan2(a.y, a.x) + TAU / 2;

  return color(angle, 1, invDistance(dist));
}


PVector function(PVector input, float[] coefficients) {
  PVector result = new PVector(0, 0);
  for (int i = 0; i < coefficients.length; i++) {
    if (coefficients[i] == 0) {
      continue;
    } else {
      PVector next = complexPower(input, i);
      next.mult(coefficients[i]);
      result.add(next);
    }
  }
  return result;
}

PVector complexPower(PVector input, int power) {
  float dist = dist(0, 0, input.x, input.y);
  float angle = atan2(input.y, input.x); 


  float newDist = pow(dist, power);
  float newAngle = power * angle;

  float x = newDist * cos(newAngle);
  float y = newDist * sin(newAngle);

  return new PVector(x, y);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e > 0) {
    scaleWidth *= (4.0/3.0);
    scaleHeight *= (4.0/3.0);
  } else if (e < 0) {
    scaleWidth *= (3.0/4.0);
    scaleHeight *= (3.0/4.0);
  }
}