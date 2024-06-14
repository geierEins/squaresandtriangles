class Triangle {

  int NUM_OF_CORNERS = 3;
  PVector [] corners;
  PVector center;
  float radius;

  // ------------------------------------------------- CONSTRUCTORS

  Triangle(PVector center, float radius) {
    this.center = center;
    this.radius = radius;
    corners = new PVector[NUM_OF_CORNERS];
    for (int i = 0; i < corners.length; i++) {
      corners[i] = new PVector();
      corners[i].x = center.x + cos(i*TWO_PI/corners.length) * this.radius;
      corners[i].y = center.y + sin(i*TWO_PI/corners.length) * this.radius;
    }
  }

  Triangle(PVector[] corners) {
    this.corners = new PVector[NUM_OF_CORNERS];
    for (int i = 0; i < this.corners.length; i++) {
      this.corners[i] = corners[i];
    }
    center = getCenterPoint(corners);
  }

  PVector getCenterPoint(PVector[] corners) {
    float centerX = 0;
    float centerY = 0;
    for (int i = 0; i < NUM_OF_CORNERS; i++) {
      centerX += corners[i].x;
      centerY += corners[i].y;
    }
    centerX /= NUM_OF_CORNERS;
    centerY /= NUM_OF_CORNERS;
    return new PVector(centerX, centerY);
  }

  // ------------------------------------------------- LOGIC

  void updateCornerCoos() {
    for (int i = 0; i < corners.length; i++) {
      corners[i] = new PVector();
      corners[i].x = center.x + cos(i*TWO_PI/corners.length) * this.radius;
      corners[i].y = center.y + sin(i*TWO_PI/corners.length) * this.radius;
    }
  }

  // ------------------------------------------------- DRAW 
  void drawTriangle() {
    drawShape();
    //drawCenter();
    drawCorners();
  }

  void drawShape() {
    stroke(0);
    strokeWeight(1);
    //noFill();
    fill(255, 0, 0, 120);
    beginShape();
    for (int i = 0; i < corners.length; i++) {
      vertex(corners[i].x, corners[i].y);
    }
    endShape(CLOSE);
  }

  void drawCenter() {
    noStroke();
    fill(255, 0, 0);
    ellipse(center.x, center.y, 3, 3);
  }

  void drawCorners() {
    for (int i = 0; i < corners.length; i++) {
      ellipse(corners[i].x, corners[i].y, 3, 3);
    }
  }

  // ------------------------------------------------- LOGGING

  void logCoos() {
    println("\n--------- added new triangle ----------------------");
    println("Center:");
    println("\tx: " + center.x + "  \ty: " + center.y + "\n");
    println("Corners:");
    for (int i = 0; i < corners.length; i++) {
      println("\tx"+i+": " + corners[i].x + "  \ty"+i+": " + corners[i].y);
    }
    println("---------------------------------------------------\n");
  }
}
