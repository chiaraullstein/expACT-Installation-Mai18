/* --------------------------------------------------------------------------
 * expACT - INSTALLATION
 * --------------------------------------------------------------------------
 * Werkschau 2018 | Färberei München
 * Chiara Ullstein
 * Kunst und Multimedia an der Ludwig-Maximilians-Universität in München
 * --------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
SimpleOpenNI context;

Skeleton skeleton;

float   zoomF = 0.6f;
float   rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                              // the data from openni comes upside down

// vectors for the right and left hand position
PVector vHR = new PVector(100, 100, 100);
PVector vHL = new PVector(100, 100, 100);

PVector      bodyCenter = new PVector();
PVector      bodyDir = new PVector();
ArrayList<Integer> users = new ArrayList<Integer>();//this will keep track of the most recent user added
PVector pos = new PVector();//this will store the position of the user

//für Stroke Farbe
ArrayList<Strokes> strokesList;
PVector rgb;
String timestamp;

boolean showGUI = true; //____for GUI______________

int windowHeight;
int windowWidth;

float minZ = 1000;
float maxZ = 2000;
float minX = 500;
float maxX = -500;

void setup() {
  smooth();
  setupStrokes();

  skeleton = new Skeleton();
  
  context = new SimpleOpenNI(this); 
  
  if(context.isInit() == false){
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }

  // meine Bewegungen sollen in Projektion gespiegelt angezeigt werden
  context.setMirror(true);

  // enable depthMap generation 
  context.enableDepth();
  // enable skeleton generation for all joints - tracking wird eingeschalten
  context.enableUser();
}

public int sketchWidth() {
  windowWidth = int(displayWidth);
  return displayWidth;
}

public int sketchHeight() {
  windowHeight = int(displayHeight);
  return displayHeight;
}

public String sketchRenderer() {
  return P3D; 
}

void draw() {
    
  colorMode(RGB,255);
  //background(255);

  context.update(); // kann man das nur dann updaten lassen, wenn sich das Skelet bewegt hat? 30.06
  
  // set the scene position
  translate(width/2, height/2, 0);
  scale(zoomF);
  rotateX(rotX);
  translate(0,0,-1500);  // set the rotation center of the scene 1500 infront of the camera ***** das hier dann dem konkreten Raum für die Ausstellung anpassen! 30.06 *****
  
  for (int i=1; i<=1; i++){
    if (context.isTrackingSkeleton(i)){
      skeleton.calcVectors(i);        
      //context.getCoM(1, pos);
      //if (pos.z > minZ && pos.z < maxZ && pos.x > maxX && pos.x < minX){
      if (skeleton.torso.z > minZ && skeleton.torso.z < maxZ && skeleton.torso.x > maxX && skeleton.torso.x < minX){
        background(255);
        skeleton.recognized = true;
      } else {
        skeleton.recognized = false;
      }
    } else {
      skeleton.recognized = false;
    }
  }

  if (skeleton.recognized == true) {
    rotX = radians(180);
    addVectorPointsStroke();
    // display skeleton for test purposes
    /*for (int i=1; i<=1; i++){
      skeleton.drawSkeleton(i);
    }*/
  }
  
  if (skeleton.recognized == false) {
    background(0);
    rotX += 0.01f;
    /*strokeWeight(20);
    context.drawCamFrustum();*/  // translate in 3D benötigt P3D --> Also nicht auf OpenGL umschalten!!!*/
  }
  
  drawStrokes();
  
  // save tif
  if (random(1) < 0.0002) {
      timestamp = "Werkschau2018_Werke" +"/"+ year() +":"+ nf(month(),2) +":"+ nf(day(),2) + "-"  + nf(hour(),2) +"."+ nf(minute(),2) +"."+ nf(second(),2);
      saveFrame(timestamp+".tif");
  }
  

}

// -----------------------------------------------------------------
// events are called whenever a new/ old person enters/ exits the tracking area

// a new person enters the tracking area
void onNewUser(SimpleOpenNI curContext,int userId)
{
    println("onNewUser - userId: " + userId);
    println("\tstart tracking skeleton");
    clearAllStrokes();
    users.add(userId);
    context.startTrackingSkeleton(userId);
  
    // whenever a new person has been recognized, a new Stokes is generated.
    strokesList.add(new Strokes());
}

// a new person exists the tracking area
void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
  users.remove(userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  println("onVisibleUser - userId: " + userId);
  users.remove(userId);
}
