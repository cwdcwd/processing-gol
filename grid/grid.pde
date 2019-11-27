int GRID_WIDTH = 1200;
int GRID_HEIGHT = 1200;
int PANEL_HEIGHT = 100;
int SQUARE_SIZE = 40;
int ROW_COUNT = GRID_HEIGHT / SQUARE_SIZE;
int COL_COUNT = GRID_WIDTH / SQUARE_SIZE;
boolean ALIVE = true;
boolean DEAD = false;
color COLOR_DEAD = #0a2b30;
color COLOR_ALIVE = #45dae7;
color COLOR_TEXT = #FFFFFF;
color COLOR_GRID = #303a47;
color COLOR_BTN = #454545;
color COLOR_BG = #635e5d;
boolean IS_RUNNING = false;
int BUTTON_PADDING = 20;
int BUTTON_WIDTH = 125;
int BUTTON_HEIGHT = 50;
int BUTTON_OFFSET_RUN = 20;
int BUTTON_OFFSET_STEP = BUTTON_OFFSET_RUN + BUTTON_WIDTH + BUTTON_PADDING;
String LABEL_RUN = "Run";

int[] lastDragPosition = new int[2];
int[] btnStep = {
  BUTTON_OFFSET_RUN,
  GRID_HEIGHT + BUTTON_PADDING,
  BUTTON_HEIGHT,
  BUTTON_WIDTH
};
int[] btnRun = {
  BUTTON_OFFSET_STEP,
  GRID_HEIGHT + BUTTON_PADDING,
  BUTTON_HEIGHT,
  BUTTON_WIDTH
};
boolean[][] grid = new boolean[ROW_COUNT][COL_COUNT];
int[][] gridSiblingCoordinates = {
  {-1, -1}, {0, -1}, {1, -1},
  {-1, 0},           {1, 0},
  {-1, 1},  {0,1},   {1,1}
};

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
  frameRate(30);
  gridFill(DEAD);
  drawStepButton();
  drawRunButton();
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
  int cursorType = CROSS;
  if (overlaysButton(btnStep)) {
    cursorType = HAND;
  }
  if (overlaysButton(btnRun)) {
    cursorType = HAND;
  }
  cursor(cursorType);
}

void mouseClicked() {
  if (overlaysButton(btnStep)) {
    if (!IS_RUNNING) {
      step();
      redraw();
    }
    return;
  }

  if (overlaysButton(btnRun)) {
    IS_RUNNING = !IS_RUNNING;
    if (IS_RUNNING) {
      loop();
    } else {
      drawRunButton();
      noLoop();
    }
  }

  if (mouseY < GRID_HEIGHT) {
    int rowPosition = floor(mouseX / SQUARE_SIZE);
    int colPosition = floor(mouseY / SQUARE_SIZE);
    grid[rowPosition][colPosition] = (grid[rowPosition][colPosition] == DEAD) ? ALIVE : DEAD;
  }

  redraw();
}

void mouseDragged() {
  // TODO: Grant life on drag.
  if (mouseY >= GRID_HEIGHT) {
    return;
  }
  int rowPosition = floor(mouseX / SQUARE_SIZE);
  int colPosition = floor(mouseY / SQUARE_SIZE);
  if (lastDragPosition[0] != rowPosition || lastDragPosition[1] != colPosition) {
    grid[rowPosition][colPosition] = (grid[rowPosition][colPosition] == DEAD) ? ALIVE : DEAD;
    lastDragPosition[0] = rowPosition;
    lastDragPosition[1] = colPosition;
  }

  redraw();
}

/*

   ___ _   _ ___ _____ ___    _    _     ___ _____   _  _____ ___ ___  _   _ ____
  |_ _| \ | |_ _|_   _|_ _|  / \  | |   |_ _|__  /  / \|_   _|_ _/ _ \| \ | / ___|
   | ||  \| || |  | |  | |  / _ \ | |    | |  / /  / _ \ | |  | | | | |  \| \___ \
   | || |\  || |  | |  | | / ___ \| |___ | | / /_ / ___ \| |  | | |_| | |\  |___) |
  |___|_| \_|___| |_| |___/_/   \_\_____|___/____/_/   \_\_| |___\___/|_| \_|____/


*/

void gridFill(boolean val) {
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

void drawStepButton() {
  drawButton(btnStep, "Step");
}

void drawRunButton() {
  drawButton(btnRun, (IS_RUNNING ? "Stop" : LABEL_RUN ));
}

void drawButton(int[] btn, String label) {
  fill(COLOR_BTN);
  rect(
    btn[0],
    btn[1],
    btn[3],
    btn[2],
    7
  );
  textSize(28);
  fill(COLOR_TEXT);
  text(
    label,
    btn[0] + 35,
    btn[1] + 10,
    btn[3],
    btn[2]
  );

}

boolean overlaysButton(int []btn) {
  return (
    (mouseX > btn[0]) &&
    (mouseX < (btn[0] + btn[3])) &&
    (mouseY > btn[1]) &&
    (mouseY < (btn[1]+btn[2])));
}

/*

   ____  ____   ___   ____ _____ ____ ____ ___ _   _  ____
  |  _ \|  _ \ / _ \ / ___| ____/ ___/ ___|_ _| \ | |/ ___|
  | |_) | |_) | | | | |   |  _| \___ \___ \| ||  \| | |  _
  |  __/|  _ <| |_| | |___| |___ ___) |__) | || |\  | |_| |
  |_|   |_| \_\\___/ \____|_____|____/____/___|_| \_|\____|


*/

void step() {
  boolean[][] gridNew = new boolean[ROW_COUNT][COL_COUNT];
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
    IS_RUNNING = false;
  }
  grid = gridNew;
}

boolean evaluate(int x, int y) {
  if (x >= ROW_COUNT) {
    return DEAD;
  }
  if (y >= COL_COUNT) {
    return DEAD;
  }
  int count = countNeighbors(x, y);
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
  for (int i=0; i < gridSiblingCoordinates.length; ++i) {
    int[] neighbor = getNeighbor(x, y, gridSiblingCoordinates[i]);
    if (grid[neighbor[0]][neighbor[1]] == ALIVE) {
      ++count;
      if (count > 3) {
        return count;
      }
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

color getStateColor(boolean blockState) {
  if (blockState == ALIVE) {
    return COLOR_ALIVE;
  }
  return COLOR_DEAD;
}
