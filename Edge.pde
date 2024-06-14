class Edge{

  PVector sharedPoint1, sharedPoint2, direction;
  
  Edge(PVector sharedPoint1, PVector sharedPoint2, PVector originalCornerPoint){
    this.sharedPoint1 = sharedPoint1;
    this.sharedPoint2 = sharedPoint2;
    this.direction = originalCornerPoint;
  }
  
}
