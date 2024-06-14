class Button {

  int NUM_OF_CORNERS, x, y, radius;
  boolean isActive = false;

  Button(int NUM_OF_CORNERS, int x, int y, int radius) {
    this.NUM_OF_CORNERS = NUM_OF_CORNERS;
    this.x = x;
    this.y = y;
    this.radius = radius;
  }

  void drawButton() {
    styleButton();
    drawShape();
  }

  void styleButton() {
    stroke(0);
    strokeWeight(1);
    //noFill();
    if (NUM_OF_CORNERS==3) {
      fill(255, 0, 0, 120);
    }
    if (NUM_OF_CORNERS==4) {
      fill(220, 30, 0, 120);
    }
    if (isActive) {
      strokeWeight(4);
    }
  }

  boolean checkIfMouseIsOverButton(float mousex, float mousey) {
    int tol = 7;
    if (mousex>=x-radius-tol && mousex<=x+radius+tol && mousey>=y-radius-tol && mousey<=y+radius+tol) {
      return true;
    } else return false;
  }

  void drawShape() {
    beginShape();
    for (int i = 0; i < NUM_OF_CORNERS; i++) {
      vertex(x + cos(i*TWO_PI/NUM_OF_CORNERS) * this.radius, y + sin(i*TWO_PI/NUM_OF_CORNERS) * this.radius);
    }
    endShape(CLOSE);
  }

  void drawMouseover() {
    fill(20, 30, 0, 120);
    drawShape();
  }
}
