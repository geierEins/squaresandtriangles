import java.util.Arrays; //<>// //<>// //<>// //<>// //<>// //<>// //<>//

class Manager {

  ArrayList<Triangle> triangles, triangleCandidates;
  ArrayList<Square> squares, squareCandidates;
  ArrayList<Edge> outerEdges;
  int MODE;
  int buttonSize = 30;
  Helper helper;
  Button triangleB, squareB;

  // --------- constructor ------------------------
  Manager() {
    setupObjects();
  }

  void setupObjects() {
    helper = new Helper();
    triangleB = new Button(3, width/2-buttonSize*2, buttonSize+5, buttonSize/2);
    squareB = new Button(4, width/2+buttonSize*2, buttonSize+5, buttonSize/2);
    triangles = new ArrayList<Triangle>();
    triangleCandidates = new ArrayList<Triangle>();
    squares = new ArrayList<Square>();
    squareCandidates = new ArrayList<Square>();
    outerEdges = new ArrayList<Edge>();

    //startWithASquare();
    startWithATriangle();
  }

  void startWithASquare() {
    MODE = 1;
    addSquare(new Square(new PVector(width/2, height/2), 25));
    squareB.isActive = true;
  }

  void startWithATriangle() {
    MODE = -1;
    addTriangle(new Triangle(new PVector(width/2, height/2), 25));
    triangleB.isActive = true;
  }

  void changeModeToTriangle() {
    //if (triangles.size()+squares.size()==1) {
    //  squares.clear();
    //  squareCandidates.clear();
    //  outerEdges.clear();
    //  addTriangle(new Triangle(new PVector(width/2, height/2), 25));
    //}
    MODE = -1;
    calculateTriangleCandidatesFromOuterEdges();
    triangleB.isActive=true;
    squareB.isActive=false;
  }

  void changeModeToSquare() {
    //if (triangles.size()+squares.size()==1) {
    //  triangles.clear();
    //  triangleCandidates.clear();
    //  outerEdges.clear();
    //  addSquare(new Square(new PVector(width/2, height/2), 25));
    //}
    MODE = 1;
    calculateSquareCandidatesFromOuterEdges();
    squareB.isActive=true;
    triangleB.isActive=false;
  }

  void deleteLastEntryByMode() {
    int lastIndex;
    if (MODE == - 1) {
      lastIndex = triangles.size()-1;
      triangles.remove(lastIndex);
      lastIndex = outerEdges.size()-1;
      outerEdges.remove(lastIndex);
      //outerEdges.remove(lastIndex-1);
      //outerEdges.remove(lastIndex-2);
      calculateSquareCandidatesFromOuterEdges();
    }
    if (MODE == 1) {
      lastIndex = squares.size()-1;
      squares.remove(lastIndex);
      lastIndex = outerEdges.size()-1;
      outerEdges.remove(lastIndex);
      outerEdges.remove(lastIndex-1);
      outerEdges.remove(lastIndex-2);
      outerEdges.remove(lastIndex-3);
      calculateSquareCandidatesFromOuterEdges();
    }
  }

  // --------- add triangle -----------------------
  void addTriangleIfMouseOverCandidate(float mousex, float mousey) {
    PVector mouseCoos = new PVector(mousex, mousey);
    //for (Triangle candidate : candidates) {
    for (int i = 0; i < triangleCandidates.size(); i++) {
      //candidates.get(i).logCoos();
      if (helper.checkIfInsideAnotherTriangle(mouseCoos, triangleCandidates.get(i).corners)) {
        addTriangle(triangleCandidates.get(i));
        break;
      }
    }
  }

  void addTriangle(Triangle newTriangle) {
    // add triangle to triangles
    triangles.add(newTriangle);
    //logNumberOfTriangles(); //<>//

    // add edges (point pairs + direction) to edges
    addTriangleEdgesToArrayList(newTriangle);

    // update edges (delete duplicates)
    updateOuterEdgesArrayList();
    //logNumberOfOuterEdges();
    //logOuterEdges();

    // calculate new candidates by (outer) edges
    calculateTriangleCandidatesFromOuterEdges();
    //logNumberOfTriangleCandidates();
  }

  void addTriangleEdgesToArrayList(Triangle newTriangle) {
    outerEdges.add(new Edge(newTriangle.corners[0], newTriangle.corners[1], helper.getDirectionFromTriangleCorners(newTriangle.corners[0], newTriangle.corners[1], newTriangle.corners[2])));
    outerEdges.add(new Edge(newTriangle.corners[1], newTriangle.corners[2], helper.getDirectionFromTriangleCorners(newTriangle.corners[1], newTriangle.corners[2], newTriangle.corners[0])));
    outerEdges.add(new Edge(newTriangle.corners[2], newTriangle.corners[0], helper.getDirectionFromTriangleCorners(newTriangle.corners[2], newTriangle.corners[0], newTriangle.corners[1])));
  }

  void calculateTriangleCandidatesFromOuterEdges() {
    triangleCandidates.clear();
    for (Edge e : outerEdges) {
      Triangle candidate = helper.createTriangleFromEdge(e);
      triangleCandidates.add(candidate);
    }
  }

  // --------- add square ------------------------
  void addSquareIfMouseOverCandidate(float mousex, float mousey) {
    PVector mouseCoos = new PVector(mousex, mousey);
    for (int i = 0; i < squareCandidates.size(); i++) {
      if (helper.checkIfInsideAnotherSquare(mouseCoos, squareCandidates.get(i).corners)) {
        addSquare(squareCandidates.get(i));
        break;
      }
    }
  }

  void addSquare(Square newSquare) {
    // add triangle to triangles
    squares.add(newSquare);
    //logNumberOfSquares();

    // add edges (point pairs) to edges
    addSquareEdgesToArrayList(newSquare);

    // update edges (delete duplicates)
    updateOuterEdgesArrayList();
    //logNumberOfOuterEdges();

    // calculate new candidates by (outter) edges
    calculateSquareCandidatesFromOuterEdges();
    //logNumberOfSquareCandidates();
  }

  void addSquareEdgesToArrayList(Square newSquare) {
    outerEdges.add(new Edge(newSquare.corners[0], newSquare.corners[1], PVector.sub(newSquare.corners[1], newSquare.corners[2])));
    outerEdges.add(new Edge(newSquare.corners[1], newSquare.corners[2], PVector.sub(newSquare.corners[2], newSquare.corners[3])));
    outerEdges.add(new Edge(newSquare.corners[2], newSquare.corners[3], PVector.sub(newSquare.corners[3], newSquare.corners[0])));
    outerEdges.add(new Edge(newSquare.corners[3], newSquare.corners[0], PVector.sub(newSquare.corners[0], newSquare.corners[1])));
  }

  void calculateSquareCandidatesFromOuterEdges() {
    squareCandidates.clear();
    for (Edge e : outerEdges) {
      Square candidate = helper.createSquareFromEdge(e);
      squareCandidates.add(candidate);
    }
  }

  // ---------- outer edges update ----------------
  void updateOuterEdgesArrayList() {
    ArrayList<Edge> uniqueEdges = new ArrayList<Edge>();
    for (Edge edge : outerEdges) {
      boolean isDuplicate = false;
      for (int i = 0; i<uniqueEdges.size(); i++) {
        // check for unique edges
        if (helper.areEdgesEqualWithTolerance(edge, uniqueEdges.get(i))) {
          isDuplicate = true;
          uniqueEdges.remove(i);
          break;
        }
      }
      if (!isDuplicate) {
        uniqueEdges.add(edge);
      }
    }
    outerEdges.clear();
    outerEdges.addAll(uniqueEdges);
  }

  //------------------------------------------ Draw
  void drawAll() {
    drawTriangleWorld();
    drawSquareWorld();
    drawOuterEdges(); // good check to see correct outer edges calculation
    drawButtons();
  }

  //------------------------------------------ triangle
  void drawTriangleWorld() {
    drawTriangles();
    if (MODE==-1) {
      drawTriangleCandidateIfMouseOverTriangleCandidate(mouseX, mouseY);
    }
    //drawTriangleCandidates();
  }

  void drawTriangles() {
    for (int i = 0; i < triangles.size(); i++) {
      triangles.get(i).drawTriangle();
    }
  }

  void drawTriangleCandidates() {
    for (int i = 0; i < triangleCandidates.size(); i++) {
      triangleCandidates.get(i).drawShape();
    }
  }

  void drawTriangleCandidateIfMouseOverTriangleCandidate(float mousex, float mousey) {
    PVector mouseCoos = new PVector(mousex, mousey);
    for (Triangle candidate : triangleCandidates) {
      if (helper.checkIfInsideAnotherTriangle(mouseCoos, candidate.corners)) {
        candidate.drawShape();
        break;
      }
    }
  }

  //------------------------------------------ square
  void drawSquareWorld() {
    drawSquares();
    if (MODE==1) {
      drawSquareCandidateIfMouseOverSquareCandidate(mouseX, mouseY);
    }
  }

  void drawSquares() {
    for (int i = 0; i < squares.size(); i++) {
      squares.get(i).drawSquare();
    }
  }

  void drawSquareCandidates() {
    for (int i = 0; i < squareCandidates.size(); i++) {
      squareCandidates.get(i).drawShape();
    }
  }

  void drawSquareCandidateIfMouseOverSquareCandidate(float mousex, float mousey) {
    PVector mouseCoos = new PVector(mousex, mousey);
    for (Square candidate : squareCandidates) {
      if (helper.checkIfInsideAnotherSquare(mouseCoos, candidate.corners)) {
        candidate.drawShape();
        break;
      }
    }
  }

  // -------------------- buttons ---------------------------------

  void drawButtons() {
    squareB.drawButton();
    if (squareB.checkIfMouseIsOverButton(mouseX, mouseY)) {
      squareB.drawMouseover();
    }
    triangleB.drawButton();
    if (triangleB.checkIfMouseIsOverButton(mouseX, mouseY)) {
      triangleB.drawMouseover();
    }
  }

  void drawOuterEdges() {
    for (Edge e : outerEdges) {
      stroke(0, 0, 255);
      strokeWeight(3);
      line(e.sharedPoint1.x, e.sharedPoint1.y, e.sharedPoint2.x, e.sharedPoint2.y);
    }
    // draw original corner point
    for (Edge e : outerEdges) {
      fill(0, 255, 0);
      noStroke();
      ellipse(e.direction.x, e.direction.y, 5, 5);
    }
  }

  // ----------------------------------------- Logging
  void logNumberOfTriangleCandidates() {
    println("Number of Triangle Candidates: " + triangleCandidates.size());
  }
  void logNumberOfTriangles() {
    println("Number of Triangles: " + triangles.size());
  }
  void logNumberOfSquareCandidates() {
    println("Number of Square Candidates: " + squareCandidates.size());
  }
  void logNumberOfSquares() {
    println("Number of Squares: " + squares.size());
  }

  void logNumberOfOuterEdges() {
    println("Number of OuterEdges: " + outerEdges.size());
  }
  void logOuterEdges() {
    for (int i = 0; i < outerEdges.size(); i++) {
      println("Edge " + i + ": ");
      println("     P1: " + outerEdges.get(i).sharedPoint1);
      println("     P2: " + outerEdges.get(i).sharedPoint2);
      println("     DIR: " + outerEdges.get(i).direction);
      println("     DIR(mag): " + outerEdges.get(i).direction.mag());
    }
  }
  void logOuterEdgeCoos() {
    for (Edge e : outerEdges) {
      println("Edge: " + "x: " + e.sharedPoint1.x, "y: " + e.sharedPoint1.y + " ---------------- " + "x:" + e.sharedPoint2.x, "y: " + e.sharedPoint2.y);
    }
  }
}
