class Helper { //<>//

  boolean areEdgesEqualWithTolerance(Edge edge, Edge uniqueEdge) {
    int tolerance = 3;
    if ((areEqualWithTolerance(edge.sharedPoint1.x, uniqueEdge.sharedPoint1.x, tolerance) && areEqualWithTolerance(edge.sharedPoint1.y, uniqueEdge.sharedPoint1.y, tolerance)
      && areEqualWithTolerance(edge.sharedPoint2.x, uniqueEdge.sharedPoint2.x, tolerance) && areEqualWithTolerance(edge.sharedPoint2.y, uniqueEdge.sharedPoint2.y, tolerance)) ||
      (areEqualWithTolerance(edge.sharedPoint1.x, uniqueEdge.sharedPoint2.x, tolerance) && areEqualWithTolerance(edge.sharedPoint1.y, uniqueEdge.sharedPoint2.y, tolerance)
      && areEqualWithTolerance(edge.sharedPoint2.x, uniqueEdge.sharedPoint1.x, tolerance) && areEqualWithTolerance(edge.sharedPoint2.y, uniqueEdge.sharedPoint1.y, tolerance))) {
      return true;
    } else return false;
  }

  boolean areEqualWithTolerance(float num1, float num2, int decimalPlaces) {
    // Berechne die Toleranz basierend auf der Anzahl der Nachkommastellen
    float tolerance = (float) Math.pow(10, -decimalPlaces);

    // Berechne die absolute Differenz zwischen den beiden Zahlen
    float difference = Math.abs(num1 - num2);

    // Überprüfe, ob die Differenz kleiner oder gleich der Toleranz ist
    return difference <= tolerance;
  }

  // ------------------------------------ triangle related -----------------------------------

  // part 1: create uni-usable edges from triangle (works)
  PVector getDirectionFromTriangleCorners(PVector sharedPoint1, PVector sharedPoint2, PVector oppositeCornerPoint) {
    // Berechne den Mittelpunkt zwischen sharedPoint1 und sharedPoint2
    PVector midpoint = new PVector((sharedPoint1.x + sharedPoint2.x) / 2, (sharedPoint1.y + sharedPoint2.y) / 2);
    // Berechne den Vektor von oppositeCornerPoint zum Mittelpunkt
    PVector direction = PVector.sub(midpoint, oppositeCornerPoint);

    // Normiere den Richtungsvektor
    direction.normalize();
    return direction;
  }

  // part 2: create triangles from edges (works)
  Triangle createTriangleFromEdge(Edge e) {
    PVector[] corners = new PVector[3];
    corners[0] = e.sharedPoint1;
    corners[1] = e.sharedPoint2;
    
    e.direction.normalize();

    // 1. Berechne den Mittelpunkt
    PVector midpoint = new PVector((e.sharedPoint1.x + e.sharedPoint2.x) / 2, (e.sharedPoint1.y + e.sharedPoint2.y) / 2);

    // 2. Berechne den Vektor von sharedPoint1 zu sharedPoint2 für die Seitenlänge
    PVector sideVector = new PVector((e.sharedPoint1.x - e.sharedPoint2.x), (e.sharedPoint1.y - e.sharedPoint2.y));
    float sideLength = sideVector.mag();

    // 3. Berechne den Vektor für den dritten Punkt (e.direction * sidelength * wurzel 3 durch 2)
    PVector thirdPointVector = e.direction.copy().mult(sideLength*(sqrt(3)/2));

    // 4. Addiere sharedPoint1 zu thirdPointVector, um den dritten Punkt zu erhalten
    PVector thirdPoint = PVector.add(midpoint, thirdPointVector);
    corners[2] = thirdPoint;

    return new Triangle(corners);
  }

  // used for mouseover checks (works)
  boolean checkIfInsideAnotherTriangle(PVector point, PVector[] corners) {
    // Berechne die Vektoren von den Ecken zu dem gegebenen Punkt
    PVector v0 = PVector.sub(corners[2], corners[0]);
    PVector v1 = PVector.sub(corners[1], corners[0]);
    PVector v2 = PVector.sub(point, corners[0]);
    // Berechne die Skalarprodukte
    float dot00 = PVector.dot(v0, v0);
    float dot01 = PVector.dot(v0, v1);
    float dot02 = PVector.dot(v0, v2);
    float dot11 = PVector.dot(v1, v1);
    float dot12 = PVector.dot(v1, v2);
    // Berechne die Baryzentrischen Koordinaten
    float denom = (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) / denom;
    float v = (dot00 * dot12 - dot01 * dot02) / denom;
    // Überprüfe, ob der Punkt innerhalb des Dreiecks liegt
    return (u >= 0) && (v >= 0) && (u + v <= 1);
  }

  // ------------------------------------ square related -----------------------------------
  Square createSquareFromEdge(Edge e) {
    PVector[] corners = new PVector[4];
    corners[0] = e.sharedPoint1;
    corners[1] = e.sharedPoint2;

    // 1. Berechne den Vektor von sharedPoint1 zu sharedPoint2 für die Seitenlänge
    PVector sideVector = new PVector((e.sharedPoint1.x - e.sharedPoint2.x), (e.sharedPoint1.y - e.sharedPoint2.y));
    float sideLength = sideVector.mag();

    // 2. Berechne den Vektor für den dritten Punkt (e.direction * sidelength * wurzel 3 durch 2)
    PVector directionalSidelengthVector = e.direction.normalize().mult(sideLength);

    // 4. Addiere sharedPoint1 zu thirdPointVector, um den dritten Punkt zu erhalten
    PVector thirdPoint = PVector.add(e.sharedPoint2, directionalSidelengthVector);
    PVector fourthPoint = PVector.add(e.sharedPoint1, directionalSidelengthVector);
    corners[2] = thirdPoint;
    corners[3] = fourthPoint;

    return new Square(corners);
  }

  boolean checkIfInsideAnotherSquare(PVector point, PVector[] corners) {
    int n = corners.length;
    boolean inside = false;
    for (int i = 0, j = n - 1; i < n; j = i++) {
      PVector vi = corners[i];
      PVector vj = corners[j];
      if (((vi.y > point.y) != (vj.y > point.y)) &&
        (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x)) {
        inside = !inside;
      }
    }
    return inside;
  }
}
