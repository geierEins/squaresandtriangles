Manager m; //<>//

void setup() {
  size(1000, 700);
  m = new Manager();
}

void draw() {
  background(230);
  textAlign(CENTER);
  text("PRESS TAB FOR RESTART", width/2, height-10);
  m.drawAll();
}

void mouseReleased() {
  // Klick auf Button
  if (m.triangleB.checkIfMouseIsOverButton(mouseX, mouseY)) {
    println("TRIANGLE MODE");
    m.changeModeToTriangle();
  }

  if (m.squareB.checkIfMouseIsOverButton(mouseX, mouseY)) {
    println("SQUARE MODE");
    m.changeModeToSquare();
  }

  // Klick ins Feld
  if (m.MODE==-1) { // -1
    m.addTriangleIfMouseOverCandidate(mouseX, mouseY);
  }
  if (m.MODE== 1) {
    m.addSquareIfMouseOverCandidate(mouseX, mouseY);
  }
}

void keyPressed() {
  if (keyCode == TAB) {
    m.setupObjects();
  }
  if (keyCode == BACKSPACE) {
    //m.deleteLastEntryByMode();
  }

  
}
