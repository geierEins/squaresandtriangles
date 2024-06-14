class Square {
  int NUM_OF_CORNERS = 4;
  PVector [] corners;
  PVector center;
  float radius;

  Square(PVector center, float radius) {
    this.center = center;
    this.radius = radius;
    corners = new PVector[NUM_OF_CORNERS];
    for (int i = 0; i < corners.length; i++) {
      corners[i] = new PVector();
      corners[i].x = center.x + cos(i*TWO_PI/corners.length) * this.radius;
      corners[i].y = center.y + sin(i*TWO_PI/corners.length) * this.radius;
    }
  }

  Square(PVector[] fromCorners) {
    corners = new PVector[NUM_OF_CORNERS];
    for (int i = 0; i < fromCorners.length; i++) {
      this.corners[i] = fromCorners[i];
    }
  }

  // ------------------------------------------------- DRAW 
  void drawSquare() {
    drawShape();
    //drawCenter();
    drawCorners();
  }

  void drawShape() {
    stroke(0);
    strokeWeight(1);
    //noFill();
    fill(220, 30, 0, 120);
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
