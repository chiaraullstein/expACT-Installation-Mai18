class Skeleton {

  PVector head, neck, shoulderL, shoulderR, elbowL, elbowR, handL, handR, torso, hipL, hipR, kneeL, kneeR, footL, footR;
  boolean recognized;
  int userId = 0;
  //int[]   depthMap = context.depthMap();

  public Skeleton () {
    head = new PVector(0, 0, 0);
    neck = new PVector(0, 0, 0);
    shoulderL = new PVector(0, 0, 0);
    shoulderR = new PVector(0, 0, 0);    
    elbowL = new PVector(0, 0, 0);
    elbowR = new PVector(0, 0, 0);     
    handL = new PVector(0, 0, 0);
    handR = new PVector(0, 0, 0);
    torso = new PVector(0, 0, 0);
    hipL = new PVector(0, 0, 0);
    hipR = new PVector(0, 0, 0);
    kneeL = new PVector(0, 0, 0);
    kneeR = new PVector(0, 0, 0);
    footL = new PVector(0, 0, 0);
    footR = new PVector(0, 0, 0);
    recognized = false;
  }

  // immer in DRAW
  void calcVectors (int userId) {
  
  int[] userList = context.getUsers();
      
      for (int i=0; i<userList.length; i++) {
        
          // Variablen hoch geholt um die Boundary nach hinten und zu den Seiten festlegen zu können
          context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_FOOT, footR);
          context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, handL);
          context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, handR);
          float boundary_z = footR.z;
          float boundary_x_left = torso.x;
          float boundary_x_right = torso.x;
          println("das ist torso - z: "+ torso.z);
          println("das ist torso- - x: "+ torso.x);
          println("das ist torso - x: "+ torso.x);
          println("vorläufige UserList[i]: " + userList[i]);
          
          // mit Test die Begrenzungen einstellen. 
          /*if (context.isTrackingSkeleton(userList[i]) && boundary_z < 2000 && boundary_x_left > -700 && boundary_x_right < 700) {
            recognized = true;
            userId = userList[i];
            //background(#FFDA1F);
          } else if (context.isTrackingSkeleton(userList[i]) && boundary_z > 2000 && boundary_x_left < -700 && boundary_x_right > 700) {
            recognized = false;
          } else {
            recognized = false;
          }*/
      }

    println("Das ist die geupdatete userId: " + userId);
    
    println("Recognized wurde erkannt");
    //PVector buffer = null;
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
    //println("head: " + head);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, neck);
    //println("neck: " + neck);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, shoulderL);
    //println("shoulder: " + shoulderL); 
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, shoulderR); 
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, elbowL); 
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, elbowR);       
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, handL);
    //handL.add(buffer);
    //handL.mult(0.5);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, handR);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, torso);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, hipL);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, hipR);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, kneeL);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, kneeR);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, footL);
    context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, footR);
    
    vHR = handR;
    vHL = handL; 
  }

  void drawSkeleton(int userId) {
    //float distanceScalar;
    //distanceScalar = (525/headPosition.z);
    pushMatrix();
    float headSize = 200;
    translate(head.x, head.y, head.z);
    fill (rgb.x, rgb.y, rgb.z);
    sphere(headSize/2); //Kopf vergrößert sich :(
    //ellipse(0,0,200,200);
    popMatrix();

    strokeWeight(15);

    drawLimb(head, neck);
    
    drawLimb(neck, shoulderL);
    drawLimb(shoulderL, elbowL);
    drawLimb(elbowL, handL);
    
    drawLimb(neck, shoulderR);
    drawLimb(shoulderR, elbowR);
    drawLimb(elbowR, handR);
    
    drawLimb(shoulderL, torso);
    drawLimb(shoulderR, torso);

    drawLimb(torso, hipL);
    drawLimb(hipL, kneeL);
    drawLimb(kneeL, footL);
    
    drawLimb(torso, hipR);
    drawLimb(hipR, kneeR);
    drawLimb(kneeR, footR);

    //getBodyDirection(userId, bodyCenter, bodyDir);

    bodyDir.mult(200);  // 200mm length
    bodyDir.add(bodyCenter);

    stroke(255, 200, 200);
    line(bodyCenter.x, bodyCenter.y, bodyCenter.z, bodyDir.x, bodyDir.y, bodyDir.z);
    println("Das ist der body Center:" + bodyCenter);

    strokeWeight(1);
  }

  void drawLimb(PVector jointType1, PVector jointType2) {
    //jointType1 = new PVector(0, 0, 0);
    //jointType2 = new PVector(0, 0, 0);
    PVector jointPos1 = new PVector();
    //PVector jointPos2 = new PVector();
    //float  confidence;
  
    // draw the joint position
    // confidence = context.getJointPositionSkeleton(userId, jointType1, jointPos1);
    // confidence = context.getJointPositionSkeleton(userId, jointType2, jointPos2);
  
    // stroke(255, 0, 0, confidence * 200 + 55);
    //line(jointPos1.x, jointPos1.y, jointPos1.z, jointPos2.x, jointPos2.y, jointPos2.z);    
    
    stroke(255, 0, 0, 200);
    line(jointType1.x, jointType1.y, jointType1.z, jointType2.x, jointType2.y, jointType2.z);
  
    //drawJointOrientation(userId, jointType1, jointPos1, 50);
  }
  
}

