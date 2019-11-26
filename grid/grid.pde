int w = 600;
int h = 600;
int PANEL_HEIGHT = 100;
int sqSize=20;
int rows = h / sqSize;
int cols = w / sqSize;
int[][] grid = new int[rows][cols];
int neighborhoodCount = 8;
int[][] neighborHood = new int[neighborhoodCount][2];
int ALIVE = 1;
int DEAD = 0;
int[] btnStep = {20, h + 25, 50, 75};
int[] btnRun = {btnStep[0] + btnStep[3] + 20, h + 25, 50, 75 };
color deadColor = #FFFFFF;
color aliveColor = #222222;
color textColor = #000000;
color gridColor = #000000;
color btnColor = #EEEEEE;
color background = #FFFFFF;
long lastTick = 0;
boolean blnRunning = false;

void settings() {
  size(w, h + PANEL_HEIGHT);
}

void setup() {
  background(background);
  frameRate(15);
  clearGrid();
  drawStepButton();
  drawRunButton();
  loadNeighborhood();
  noLoop();
}

void draw() {
  for (int x=0; x < rows; ++x) {
    for (int y=0; y < cols; ++y) {
      stroke(gridColor);
      fill(getStateColor(grid[x][y]));
      square(x * sqSize, y * sqSize, sqSize);
    }
  }
  drawRunButton();
  if (blnRunning) {
    step();
  }
}



// TODO: refactor buttons into classes with descriptive properties.
void drawStepButton() {
  fill(btnColor);
  rect(btnStep[0], btnStep[1], btnStep[3], btnStep[2], 7);
  textSize(24);
  fill(textColor);
  text("Step", btnStep[0] + 10, btnStep[1] + 10, btnStep[3], btnStep[2]);
}
// TODO: refactor button drawing
void drawRunButton() {
  println("drawing run button");
  fill(btnColor);
  rect(btnRun[0], btnRun[1], btnRun[3], btnRun[2], 7);
  textSize(24);
  fill(textColor);
  text((blnRunning?"Stop":"Run"), btnRun[0] + 10, btnRun[1] + 10, btnRun[3], btnRun[2]);
}

void loadNeighborhood() {
  // top left
  neighborHood[0][0]=-1;
  neighborHood[0][1]=-1;
  // top center
  neighborHood[1][0]=0;
  neighborHood[1][1]=-1;
  // top right
  neighborHood[2][0]=1;
  neighborHood[2][1]=-1;
  // mid left
  neighborHood[3][0]=-1;
  neighborHood[3][1]=0;
  // mid right
  neighborHood[4][0]=1;
  neighborHood[4][1]=0;
  // bottom left
  neighborHood[5][0]=-1;
  neighborHood[5][1]=1;
  // bottom center
  neighborHood[6][0]=0;
  neighborHood[6][1]=1;
  // bottom right
  neighborHood[7][0]=1;
  neighborHood[7][1]=1;
}
// TODO: Rename arrayFill?
void clearGrid() {
  for (int x = 0; x < rows; ++x) {
    for (int y = 0; y < cols; ++y) {
      grid[x][y] = DEAD;
    }
  }
}


void mouseMoved() {
  int x = mouseX / sqSize;
  int y = mouseY / sqSize;
  int cursorType = CROSS;
  if ((x >= rows) || (y >= cols)) {
    if (overlaysButton(btnStep)) {
      cursorType = HAND;
    }
    if (overlaysButton(btnRun)) {
      cursorType = HAND;
    }
  }
  cursor(cursorType);
}

boolean overlaysButton(int []btn) {
  return (
    (mouseX > btn[0]) &&
    (mouseX < (btn[0] + btn[3])) &&
    (mouseY > btn[1]) &&
    (mouseY < (btn[1]+btn[2])));
}

// TODO: move button handling into button class instances.
void handleButtonClick() {
  if (overlaysButton(btnStep)) {
    println("step button pressed");
    step();
    return;
  }

  if (overlaysButton(btnRun)) {
    println("run button pressed");
    blnRunning = !blnRunning;
    if (blnRunning) {
      loop();
      return;
    } else {
      redraw();
      noLoop();
    }
  }
}

void mouseClicked() {
  // global sqSize
  int x = mouseX / sqSize;
  int y = mouseY / sqSize;

  println("mouseClickedX: MOUSE:", mouseX, " COMPUTED:", x);
  println("mouseClickedY: MOUSE:", mouseY, " COMPUTED:", y);
  // global rows and cols
  if ((x >= rows) || (y >= cols)) {
    handleButtonClick();
    return;
  }
  // global grid
  grid[x][y] = (grid[x][y] == DEAD) ? ALIVE : DEAD;
  redraw();
  evaluate(x, y);
}

void step() {
  // global sqSize
  int[][] gridNew = new int[h/sqSize][w/sqSize];
  // global rows
  for (int x=0; x < rows; ++x) {
    // global cols
    for (int y=0; y < cols; ++y) {
      gridNew[x][y] = evaluate(x, y);
    }
  }
  // global grid
  grid = gridNew;
  // global blnRunning
  if (!blnRunning) {
    redraw();
  }
}

color getStateColor(int blockState) {
  if (blockState == ALIVE)
    return aliveColor;
  return deadColor;
}

class Neighborhood {
  int[][] state = new int[8][2];
  Neighborhood () {
    state[0][0]=-1;
    state[0][1]=-1;
    // top center
    state[1][0]=0;
    state[1][1]=-1;
    // top right
    state[2][0]=1;
    state[2][1]=-1;
    // mid left
    state[3][0]=-1;
    state[3][1]=0;
    // mid right
    state[4][0]=1;
    state[4][1]=0;
    // bottom left
    state[5][0]=-1;
    state[5][1]=1;
    // bottom center
    state[6][0]=0;
    state[6][1]=1;
    // bottom right
    state[7][0]=1;
    state[7][1]=1;
  }
}

int evaluate(int x, int y) {
  // moves off the board are dead (possible?)
  if (x >= rows) {
    return DEAD;
  }
  if (y >= cols) {
    return DEAD;
  }

  //
  int count = countNeighbors(x, y);
  println("currently: " + str(grid[x][y]));
  println("neighbors: " + count);
  if (count < 2) {
    return DEAD;
  }
  if (count > 3) {
    return DEAD;
  }
  if ((count == 2) && (grid[x][y] == ALIVE)) {
    return ALIVE;
  }
  if (count == 3) {
    return ALIVE;
  }
  return DEAD;
}

int countNeighbors(int x, int y) {
  int count = 0;
  for (int i=0; i < neighborHood.length; ++i) {
    int[] neighbor = getNeighbor(x, y, neighborHood[i]);
    if (grid[neighbor[0]][neighbor[1]] == ALIVE) {
      ++count;
    }
  }
  return count;
}

int[] getNeighbor(int x, int y, int[] neighbor) {
  // [ -1,-1  0,-1  1,-1 ]      [ 0,0 1,0 2,0 ]
  // [ -1, 0  0, 0  1, 0 ]  ==> [ 0,1 1,1 2,1 ]
  // [ -1, 1  0, 1  1, 1 ]      [ 0,2 1,2 2,2 ]
  int[] neighborPos = new int[2];
  neighborPos[0] = x + neighbor[0];
  neighborPos[1] = y + neighbor[1];
  neighborPos[0] = positionWithinBoundary(neighborPos[0], rows);
  neighborPos[1] = positionWithinBoundary(neighborPos[1], cols);
  return neighborPos;
}

int positionWithinBoundary(int pos, int count) {
  if (pos < 0) return pos + count;
  if (pos >= count) return pos - count;
  return pos;
}
