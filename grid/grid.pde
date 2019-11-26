int GRID_WIDTH = 600;
int GRID_HEIGHT = 600;
int PANEL_HEIGHT = 100;
int SQUARE_SIZE=20;
int ROW_COUNT = GRID_HEIGHT / SQUARE_SIZE;
int COL_COUNT = GRID_WIDTH / SQUARE_SIZE;
int[][] grid = new int[ROW_COUNT][COL_COUNT];
int neighborhoodCount = 8;
int[][] neighborHood = new int[neighborhoodCount][2];
int ALIVE = 1;
int DEAD = 0;
int[] btnStep = {20, GRID_HEIGHT + 25, 50, 75};
int[] btnRun = {btnStep[0] + btnStep[3] + 20, GRID_HEIGHT + 25, 50, 75 };
color COLOR_DEAD = #FFFFFF;
color COLOR_ALIVE = #222222;
color COLOR_TEXT = #000000;
color COLOR_GRID = #000000;
color COLOR_BTN = #EEEEEE;
color COLOR_BG = #FFFFFF;
boolean IS_RUNNING = false;

/*

    ____    _    _     _     ____    _    ____ _  ______
   / ___|  / \  | |   | |   | __ )  / \  / ___| |/ / ___|
  | |     / _ \ | |   | |   |  _ \ / _ \| |   | ' /\___ \
  | |___ / ___ \| |___| |___| |_) / ___ \ |___| . \ ___) |
   \____/_/   \_\_____|_____|____/_/   \_\____|_|\_\____/


*/

void settings() {
  size(GRID_WIDTH, GRID_HEIGHT + PANEL_HEIGHT);
}

void setup() {
  background(COLOR_BG);
  frameRate(15);
  arrayFill(DEAD);
  drawStepButton();
  drawRunButton();
  loadNeighborhood();
  noLoop();
}

void draw() {
  for (int x=0; x < ROW_COUNT; ++x) {
    for (int y=0; y < COL_COUNT; ++y) {
      stroke(COLOR_GRID);
      fill(getStateColor(grid[x][y]));
      square(x * SQUARE_SIZE, y * SQUARE_SIZE, SQUARE_SIZE);
    }
  }
  drawRunButton();
  if (IS_RUNNING) {
    step();
  }
}

void mouseMoved() {
  int x = mouseX / SQUARE_SIZE;
  int y = mouseY / SQUARE_SIZE;
  int cursorType = CROSS;
  if ((x >= ROW_COUNT) || (y >= COL_COUNT)) {
    if (overlaysButton(btnStep)) {
      cursorType = HAND;
    }
    if (overlaysButton(btnRun)) {
      cursorType = HAND;
    }
  }
  cursor(cursorType);
}

void mouseClicked() {
  int x = mouseX / SQUARE_SIZE;
  int y = mouseY / SQUARE_SIZE;
  if ((x >= ROW_COUNT) || (y >= COL_COUNT)) {
    handleButtonClick();
    redraw();
    return;
  }
  grid[x][y] = (grid[x][y] == DEAD) ? ALIVE : DEAD;
  evaluate(x, y);
  redraw();
}

void mouseDragged() {
  // TODO: Grant life on drag.
}

/*

   ___ _   _ ___ _____ ___    _    _     ___ _____   _  _____ ___ ___  _   _ ____
  |_ _| \ | |_ _|_   _|_ _|  / \  | |   |_ _|__  /  / \|_   _|_ _/ _ \| \ | / ___|
   | ||  \| || |  | |  | |  / _ \ | |    | |  / /  / _ \ | |  | | | | |  \| \___ \
   | || |\  || |  | |  | | / ___ \| |___ | | / /_ / ___ \| |  | | |_| | |\  |___) |
  |___|_| \_|___| |_| |___/_/   \_\_____|___/____/_/   \_\_| |___\___/|_| \_|____/


*/

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

void arrayFill(int val) {
  for (int x = 0; x < ROW_COUNT; ++x) {
    for (int y = 0; y < COL_COUNT; ++y) {
      grid[x][y] = val;
    }
  }
}

/*

   ____  _   _ _____ _____ ___  _   _ ____
  | __ )| | | |_   _|_   _/ _ \| \ | / ___|
  |  _ \| | | | | |   | || | | |  \| \___ \
  | |_) | |_| | | |   | || |_| | |\  |___) |
  |____/ \___/  |_|   |_| \___/|_| \_|____/


*/

// TODO: refactor buttons into classes with descriptive properties.
void drawStepButton() {
  fill(COLOR_BTN);
  rect(btnStep[0], btnStep[1], btnStep[3], btnStep[2], 7);
  textSize(24);
  fill(COLOR_TEXT);
  text("Step", btnStep[0] + 10, btnStep[1] + 10, btnStep[3], btnStep[2]);
}
// TODO: refactor button drawing
void drawRunButton() {
  fill(COLOR_BTN);
  rect(btnRun[0], btnRun[1], btnRun[3], btnRun[2], 7);
  textSize(24);
  fill(COLOR_TEXT);
  text((IS_RUNNING ? "Stop" : "Run" ), btnRun[0] + 10, btnRun[1] + 10, btnRun[3], btnRun[2]);
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
    if (!IS_RUNNING) {
      step();
    }
    return;
  }

  if (overlaysButton(btnRun)) {
    IS_RUNNING = !IS_RUNNING;
    if (IS_RUNNING) {
      loop();
    } else {
      noLoop();
    }
  }
}

/*

   ____  ____   ___   ____ _____ ____ ____ ___ _   _  ____
  |  _ \|  _ \ / _ \ / ___| ____/ ___/ ___|_ _| \ | |/ ___|
  | |_) | |_) | | | | |   |  _| \___ \___ \| ||  \| | |  _
  |  __/|  _ <| |_| | |___| |___ ___) |__) | || |\  | |_| |
  |_|   |_| \_\\___/ \____|_____|____/____/___|_| \_|\____|


*/

void step() {
  int[][] gridNew = new int[ROW_COUNT][COL_COUNT];
  boolean isGraveyard = true;
  for (int x = 0; x < ROW_COUNT; ++x) {
    for (int y = 0; y < COL_COUNT; ++y) {
      gridNew[x][y] = evaluate(x, y);
      if (gridNew[x][y] == ALIVE) {
        isGraveyard = false;
      }
    }
  }
  if (isGraveyard) {
    println("Extermination successful");
    IS_RUNNING = false;
  }
  grid = gridNew;
}

int evaluate(int x, int y) {
  // moves off the board are dead (possible?)
  if (x >= ROW_COUNT) {
    return DEAD;
  }
  if (y >= COL_COUNT) {
    return DEAD;
  }
  int count = countNeighbors(x, y);
  println("currently: ", str(grid[x][y]), " neighbors: ", count);
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
  neighborPos[0] = positionWithinBoundary(neighborPos[0], ROW_COUNT);
  neighborPos[1] = positionWithinBoundary(neighborPos[1], COL_COUNT);
  return neighborPos;
}

int positionWithinBoundary(int pos, int count) {
  if (pos < 0) return pos + count;
  if (pos >= count) return pos - count;
  return pos;
}

color getStateColor(int blockState) {
  if (blockState == ALIVE)
    return COLOR_ALIVE;
  return COLOR_DEAD;
}
