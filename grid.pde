int w=480;
int h=480;
int sqSize=20;

int btnX=20;
int btnY=h+25;
int btnH=50;
int btnW=75;

int[][] grid=new int[h/sqSize][w/sqSize];


int emptyColor = 255;
int fillColor = 153;
int btnColor = 127;

StringDict patterns;

long lastTick = 0;

void setup() {
  patterns=new StringDict();

  
  size(480,580);
  clearGrid();
  drawButton();
  noLoop();
}

void draw() {
  for(int x=0; x<grid.length; ++x){
    for(int y=0; y<grid[x].length; ++y) {
      stroke(fillColor);
      fill(grid[x][y]);
      square(x*sqSize,y*sqSize,sqSize);
    }
  }
}

void drawButton() {
  fill(btnColor);
  rect(btnX, btnY, btnW, btnH,  7); 
  textSize(24); 
  fill(0, 102, 153);
  text("Run", btnX+10, btnY+10, btnW, btnH);
}

void clearGrid() {
  for(int x=0; x<grid.length; ++x){
    for(int y=0; y<grid[x].length; ++y) {
      grid[x][y] = emptyColor;
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
    if((mouseX > btnX)&&(mouseX < (btnX+btnW))&&(mouseY > btnY)&&(mouseY < (btnY+btnH))){
      println("button pressed");
    }
  } else {
    grid[x][y] = (grid[x][y] == emptyColor)? fillColor: emptyColor;
    redraw();
  }
}

void step(){
  
  
}
