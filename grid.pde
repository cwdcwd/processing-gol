int w=480;
int h=480;
int sqSize=20;

int ALIVE=1;
int DEAD=0;

int []btnStep = {20, h+25, 50, 75 };
int []btnRun  = {btnStep[0]+btnStep[3]+20, h+25, 50, 75 };

int[][] grid         = new int[h/sqSize][w/sqSize];
int[][] neighborHood = new int[8][2];

int emptyColor = 255;
int fillColor = 153;
int btnColor = 127;

long lastTick = 0;
boolean blnRunning = false;

void setup() {
  size(480,580);
  clearGrid();
  drawStepButton();
  drawRunButton();
  loadNeighborhood();
  noLoop();
}

void draw() {
  for(int x=0; x<grid.length; ++x){
    for(int y=0; y<grid[x].length; ++y) {
      stroke(fillColor);
      fill(getStateColor(x,y));
      square(x*sqSize,y*sqSize,sqSize);
    }
  }

  drawRunButton();
  
  if(blnRunning) {
    step();
  }
  
  int s = second(); 
  int m = minute(); 
  int h = hour(); 
  println(h+":"+m+":"+s, 15, 50);
}

void drawStepButton() {
  fill(btnColor);
  rect(btnStep[0], btnStep[1], btnStep[3], btnStep[2],  7); 
  textSize(24); 
  fill(0, 102, 153);
  text("Step", btnStep[0]+10, btnStep[1]+10, btnStep[3], btnStep[2]);
}

void drawRunButton() {
  println("redrawing button");
  fill(btnColor);
  rect(btnRun[0], btnRun[1], btnRun[3], btnRun[2],  7); 
  textSize(24); 
  fill(0, 102, 153);
  text((blnRunning?"Stop":"Run"), btnRun[0]+10, btnRun[1]+10, btnRun[3], btnRun[2]);
}

void loadNeighborhood(){
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

void clearGrid() {
  for(int x=0; x<grid.length; ++x){
    for(int y=0; y<grid[x].length; ++y) {
      grid[x][y] = DEAD;
    }
  }
}

void mouseClicked() {
  println("mouseX:",mouseX);
  println("mouseY:",mouseY);
  int x = mouseX / sqSize;
  int y = mouseY / sqSize;
  println("x:", x, "/ y:", y);
  
  if((x >= grid.length) || (y >= grid[0].length)){
    if((mouseX > btnStep[0])&&(mouseX < (btnStep[0]+btnStep[3]))&&(mouseY > btnStep[1])&&(mouseY < (btnStep[1]+btnStep[2]))){
      println("step button pressed");
      step();
    }
    
    if((mouseX > btnRun[0])&&(mouseX < (btnRun[0]+btnRun[3]))&&(mouseY > btnRun[1])&&(mouseY < (btnRun[1]+btnRun[2]))){
      println("run button pressed");
      blnRunning=!blnRunning;
 
      if(blnRunning) {
        loop();
      } else {
        noLoop();
        redraw();
      }
    }
  } else {
    grid[x][y] = (grid[x][y]==ALIVE)? DEAD : ALIVE;
    redraw();
    
    evaluate(x,y);
  }
}

void step() {
  int[][] gridNew = new int[h/sqSize][w/sqSize];

  for(int x=0;x<grid.length;++x) {
    for(int y=0;y<grid[x].length;++y) {
      gridNew[x][y]=evaluate(x,y);
    }
  }
  grid=gridNew;
  redraw();
}

int getStateColor(int x, int y) {
  if(grid[x][y] == ALIVE)
    return fillColor;
   
   return emptyColor;
}

int evaluate(int x,int y) {
  int state = DEAD;
  if((x >= grid.length) || (y >= grid[0].length)){
    return state;
  }
  
  //evaluate neighbor
  if(grid[x][y] == ALIVE) {
    println("currently alive");
   } else {
    println("currently dead");
  }
  
  int []pos={x,y};
  int count=countNeighbors(pos);
  println("neighbors: "+count);
    
  if(count<2) {
    state=DEAD;
  }
    
  if(((count == 2) && (grid[x][y] == ALIVE)) || (count == 3)) {
    state=ALIVE;
  }
    
  if(count>3) {
    state=DEAD;
  }

  print("new state is ");

  if(state == ALIVE) {
    println("alive");
   } else {
    println("dead");
  }

  return state;
}

int countNeighbors(int []pos){
  int count = 0;
  for(int i=0;i<neighborHood.length;++i) {
    int []neighbor=getNeighbor(pos, neighborHood[i]);
    
    if(grid[neighbor[0]][neighbor[1]] == ALIVE) {
      ++count;
    }
  }
  
  return count;
}

int [] getNeighbor(int []position, int[] neighbor) {
// [ -1,-1  0,-1  1,-1 ]      [ 0,0 1,0 2,0 ]
// [ -1, 0  0, 0  1, 0 ]  ==> [ 0,1 1,1 2,1 ]
// [ -1, 1  0, 1  1, 1 ]      [ 0,2 1,2 2,2 ]
 
  int []neighborPos = new int[2];
  int x = position[0];
  int y = position[1];
 
  neighborPos[0] = x + neighbor[0];         
  neighborPos[1] = y + neighbor[1];

  neighborPos[0] = (neighborPos[0]<0)?neighborPos[0]+grid.length   :( (neighborPos[0]>=grid.length)   ?neighborPos[0]-grid.length    :neighborPos[0]);
  neighborPos[1] = (neighborPos[1]<0)?neighborPos[1]+grid[0].length:( (neighborPos[1]>=grid[0].length)?neighborPos[1]-grid[0].length :neighborPos[1]);

  return neighborPos;
}
