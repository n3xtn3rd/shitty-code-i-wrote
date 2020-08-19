class Snake {
  int freezedFrames = 5;
  int currentFrame = 0;
  int xCells, yCells;
  int gridSize;
  
  int xSpeed, ySpeed;
  float flicker = 0.5;
  float fIncrease = -0.05;
  
  PVector head = new PVector();
  ArrayList<PVector> tail = new ArrayList<PVector>();
  PVector food = new PVector();
  
  ArrayList<PVector> pending = new ArrayList<PVector>();
  
  int score = 0;
  int scoreLevel = 0;
  
  Snake(int gridSize, int xCells, int yCells) {
    this.gridSize = gridSize;
    this.xCells = xCells;
    this.yCells = yCells;
    
    head.x = 3;
    head.y = 0;
    
    xSpeed = 1;
    ySpeed = 0;
    
    tail();
    newFood();
  }
  
  void moveToNextPosition() {
    checkForFood();
    
    PVector prevHead = new PVector(head.x, head.y);
    nextPosition();
    
    ArrayList<PVector> newTail = new ArrayList<PVector>();
    newTail.add(prevHead);
    
    for (int i = 0; i < tail.size()-1; i++) {
      newTail.add(tail.get(i));
    }
    
    tail = newTail;
    
    if (pending.size() > 0) {
      //println("pending points");
      
      for (int i = 0; i < pending.size(); i++) {
        if (!checkForPointInSnake(pending.get(i))) {
          //println("addToTail();");
          
          PVector point = new PVector(pending.get(i).x, pending.get(i).y);
          addToTail(point);
          pending.remove(i);
          
          break;
        }
      }
    }
  }
  
  void draw() {
    rectMode(CORNER);
    println(currentFrame+" / "+freezedFrames+" / "+scoreLevel);
    if (!checkForCollision()) {
      if (freezedFrames == currentFrame) {
        moveToNextPosition();
        currentFrame = 0;
      } else if (scoreLevel > 5 && freezedFrames > 1) {
        scoreLevel = 0;
        currentFrame = 0;
        freezedFrames--;
      }
      stroke(0);
      strokeWeight(gridSize*0.05);
      
      fill(flicker*192, flicker*192, 0);
      rect(food.x*gridSize, food.y*gridSize, gridSize, gridSize);
      
      fill(0, 255, 0);
      rect(head.x*gridSize, head.y*gridSize, gridSize, gridSize);
      
      for (int i = 0; i < tail.size(); i++) {
        rect(tail.get(i).x*gridSize, tail.get(i).y*gridSize, gridSize, gridSize);
      }
      setFace();
    } else {
      stroke(255);
      strokeWeight(1);

      fill(flicker*255, 0, 0);
      rect(head.x*gridSize, head.y*gridSize, gridSize, gridSize);
      
      for (int i = 0; i < tail.size(); i++) {
        rect(tail.get(i).x*gridSize, tail.get(i).y*gridSize, gridSize, gridSize);
      }
      
      fill(255);
      textSize(16);
      text("Press SPACE to restart!", 10, 90);
    }
    
    fill(255);
    textSize(16);
    text("Score: "+score, 10, 30); 
    text("Snake Size: "+(tail.size()+1), 10, 60);
    
    if (flicker < 0.25 || flicker > 1)
      fIncrease = -fIncrease;
       
    flicker += fIncrease;
    currentFrame++;
    //println(flicker);
  }
  
  void setSpeed(int xSpeed, int ySpeed) {
    if (this.xSpeed != -xSpeed && this.ySpeed != -ySpeed) {
      this.xSpeed = xSpeed;
      this.ySpeed = ySpeed;
    }
  }
  
  void nextPosition() {
    if (xSpeed != 0) {
      if (head.x + xSpeed < 0) {
        head.x = xCells;
      } else if (head.x + xSpeed > xCells) {
        head.x = 0;
      } else {
        head.x += xSpeed;
      }
    } else {
      if (head.y + ySpeed < 0) {
        head.y = yCells;
      } else if (head.y + ySpeed > yCells) {
        head.y = 0;
      } else {
        head.y += ySpeed; 
      }
    }
  }
  
  void setFace() {
    // Eyes
    float xPos1 = 0;
    float yPos1 = 0;
    float xPos2 = 0;
    float yPos2 = 0;
    float xWidth = 0;
    float yWidth = 0;
    
    // Tongue
    float xPos3 = 0;
    float yPos3 = 0;
    float xPos4 = 0;
    float yPos4 = 0;
    
    if (xSpeed == 0) {
      // UP AND DOWN
      xWidth = gridSize*0.25;
      yWidth = gridSize*0.15;
      
      xPos1 = head.x*gridSize+gridSize*0.25;
      xPos2 = head.x*gridSize+gridSize*0.75;
      xPos3 = head.x*gridSize+gridSize*0.33;
      xPos4 = head.x*gridSize+gridSize*0.67;
      
      if (ySpeed == 1) {
        // DOWN
        yPos1 = head.y*gridSize+gridSize*0.75;
        yPos2 = head.y*gridSize+gridSize*0.75;
        yPos3 = head.y*gridSize+gridSize*1;
        yPos4 = head.y*gridSize+gridSize*1.15;
      } else {
        // UP
        yPos1 = head.y*gridSize+gridSize*0.25;
        yPos2 = head.y*gridSize+gridSize*0.25;
        yPos3 = head.y*gridSize+gridSize*0;
        yPos4 = head.y*gridSize+gridSize*-0.15;
      }
    } else {
      // LEFT AND RIGHT      
      xWidth = gridSize*0.15;
      yWidth = gridSize*0.25;
      
      yPos1 = head.y*gridSize+gridSize*0.25;
      yPos2 = head.y*gridSize+gridSize*0.75;
      yPos3 = head.y*gridSize+gridSize*0.33;
      yPos4 = head.y*gridSize+gridSize*0.67;
      
      if (xSpeed == 1) {
        // RIGHT
        xPos1 = head.x*gridSize+gridSize*0.75;
        xPos2 = head.x*gridSize+gridSize*0.75;
        xPos3 = head.x*gridSize+gridSize*1;
        xPos4 = head.x*gridSize+gridSize*1.15;
      } else {
        // LEFT
        xPos1 = head.x*gridSize+gridSize*0.25;
        xPos2 = head.x*gridSize+gridSize*0.25;
        xPos3 = head.x*gridSize+gridSize*0;
        xPos4 = head.x*gridSize+gridSize*-0.15;
      }
    }
    
    strokeWeight(0);
    
    fill(0);
    ellipse(xPos1, yPos1, xWidth, yWidth);  
    ellipse(xPos2, yPos2, xWidth, yWidth);  
    
    rectMode(CORNERS);
    fill(255,0,0);
    rect(xPos3, yPos3, xPos4, yPos4);
  }
  
  void tail() {
      tail.add(new PVector(2, 0));
      tail.add(new PVector(1, 0));
      tail.add(new PVector(0, 0));
  }
  
  void addToPending(PVector point) {
    pending.add(point);
  }
  
  void addToTail(PVector point) {
    tail.add(point);
  }
  
  boolean checkForPointInSnake(PVector point) {
    if (head.equals(point))
      return true;
    
    for (int i = 0; i < tail.size(); i++) {
       if (tail.get(i).equals(point))
         return true;
    }
    
    return false;
  }
  
  boolean checkForCollision() {
    for (int i = 0; i < tail.size(); i++) {
       if (tail.get(i).equals(head))
         return true;
    }
    
    return false;
  }
  
  void newFood() {
    food.x = floor(random(0, xCells+0.99));
    food.y = floor(random(0, yCells+0.99));
  }
  
  void checkForFood() {
    if (food.equals(head)) {
      score++;
      scoreLevel++;
      addToPending(new PVector(head.x, head.y));
      newFood();
    }
  }
}
