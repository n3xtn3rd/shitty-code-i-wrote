int gridSize = 50;
int xCells = 0, yCells = 0;
Snake snake;

void setup() {
  size(801, 801);
  frameRate(30);
  
  for (int i=0; i*gridSize<width; i++) {
    stroke(255);
    line(i*gridSize, 0, i*gridSize, height-height%gridSize);
    xCells = i;
  }
  
  for (int i=0; i*gridSize<height; i++) {
    stroke(255);
    line(0, i*gridSize, width-width%gridSize, i*gridSize);  
    yCells = i;
  }
  
  snake = new Snake(gridSize, xCells-1, yCells-1);
}

void draw() {
  background(0);

  
  /*for (int i=0; i*gridSize<width; i++) {
    stroke(255);
    line(i*gridSize, 0, i*gridSize, height-height%gridSize);
    xCells = i;
  }
  
  for (int i=0; i*gridSize<height; i++) {
    stroke(255);
    line(0, i*gridSize, width-width%gridSize, i*gridSize);  
    yCells = i;
  }*/
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {
        snake.setSpeed(0,-1);
      } else if (keyCode == DOWN) {
        snake.setSpeed(0,1);
      } else if (keyCode == LEFT) {
        snake.setSpeed(-1,0);
      } else if (keyCode == RIGHT) {
        snake.setSpeed(1,0);
      }
    }
      
    if (key == ' ') {
      if (snake.checkForCollision()) {
        snake = new Snake(gridSize, xCells-1, yCells-1);  
      }
    }
  }
  
  snake.draw();
  

}

/*void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      snake.setSpeed(0,-1);
    } else if (keyCode == DOWN) {
      snake.setSpeed(0,1);
    } else if (keyCode == LEFT) {
      snake.setSpeed(-1,0);
    } else if (keyCode == RIGHT) {
      snake.setSpeed(1,0);
    }
  }
    
  if (key == ' ') {
    if (snake.checkForCollision()) {
      snake = new Snake(gridSize, xCells-1, yCells-1);  
    }
  }
}*/
