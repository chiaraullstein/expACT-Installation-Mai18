void setupStrokes() {
  strokesList = new ArrayList<Strokes>();
}

void addVectorPointsStroke() {
  if (strokesList.size()>0){
    strokesList.get(strokesList.size()-1).addPoint(vHR);
    
    if(strokesList.get(strokesList.size()-1).points.size() > 1000)
      strokesList.get(strokesList.size()-1).points.remove(0);
    println("Das hier ist die Anzahl der StokeList Array " + strokesList.size());
  }
}

void clearAllStrokes(){
  strokesList.clear();
}

void drawStrokes() {
  for (Strokes s : strokesList) s.addStrokeWidth(map(vHL.y, -200, 800, 5, 150));
  colorMode(RGB, 255);
  rgb = new PVector(map(vHL.x, -1000, 900, 0, 255), map(vHL.y, -200, 800, 0, 255), map(vHL.z, 8000, 2000, 0, 255));
  for(Strokes s: strokesList) s.addColor(rgb);
  for (Strokes s : strokesList) s.displayStrokes();
}

class Strokes {

  float wS;
  ArrayList<PVector> points;
  ArrayList<PVector> colorList;
  ArrayList<PVector> weightList;

  Strokes(){
    points = new ArrayList<PVector>();
    colorList = new ArrayList<PVector>();
    weightList = new ArrayList<PVector>();
  }
  
  void addColor (PVector colorRGB){
      float cR = colorRGB.x;
      float cG = colorRGB.y;
      float cB = colorRGB.z;
      PVector cRGB = new PVector (cR, cG, cB);
      colorList.add(cRGB);
  }
  
  void addStrokeWidth (float widthS) {
    wS = widthS;
    PVector wSwSwS = new PVector (wS, wS, wS); // muss das wirklich ein PVector sein?
    weightList.add(wSwSwS);
  }
  
  void addPoint (PVector pos) {
    float v1 = pos.x;
    float v2 = pos.y;
    float v3 = pos.z;
    PVector v123 = new PVector (v1, v2, v3);
    points.add(v123);
    println("Wert von Variable pos: " + pos); //das sind genau die selben variablen wie v! das funktioniert also auch
  } 
  
  void displayStrokes(){

    for (int i = 0; i < points.size()-1; i++) {
     
      float i0X = points.get(i).x;
      float i0Y = points.get(i).y;
      float i0Z = points.get(i).z;
      float i1X = points.get(i+1).x;
      float i1Y = points.get(i+1).y;
      float i1Z = points.get(i+1).z;
      
      float fR = colorList.get(i).x;
      float fG = colorList.get(i).y;
      float fB = colorList.get(i).z;
      
      float w2 = weightList.get(i).x;
      
      colorMode(HSB, 100);
      stroke(fR,fG,fB);
      strokeWeight(w2);
      line(i0X,i0Y,i0Z,i1X,i1Y,i1Z);
    }
  }
  
}
