void boardcast(String name, JSONObject e) {
  for (ElementUI item : elements) {
    item.onBoardcast(name, e);
  }
}

void error(String msg, String title) {
  JSONObject e = new JSONObject();
  e.setString("msg", "-- Error on ["+title+"] --\n\n"+msg);
  e.setString("type", "error");
  e.setString("size", "small");
  boardcast("showDialog", e);
}

void alert(String msg, String title) {
  JSONObject e = new JSONObject();
  e.setString("msg", "-- ["+title+"] --\n\n"+msg);
  e.setString("type", "normal");
  e.setString("size", "normal");
  boardcast("showDialog", e);
}

void drawBox(int x, int y, int w, int h, color c) {
  h+=lineWeight*2;

  noStroke();
  fill(c);
  rect(x+lineWeight/2, y+lineWeight/2, w-lineWeight, h);
  noFill();

  stroke(0);
  strokeWeight(lineWeight);
  rect(x, y, w, h);

  stroke(0, 150);
  line(x+lineWeight, y+h-lineWeight, x+w-lineWeight, y+h-lineWeight);

  stroke(255, 200);
  strokeWeight(lineWeight);
  rect(x+lineWeight, y+lineWeight, w-lineWeight*2, h-lineWeight*3);
}


void drawBox(int x, int y, int w, int h) {
  h+=lineWeight*2;

  noStroke();
  fill(210, 203, 191);
  rect(x+lineWeight/2, y+lineWeight/2, w-lineWeight, h);
  noFill();

  stroke(0);
  strokeWeight(lineWeight);
  rect(x, y, w, h);

  stroke(0, 150);
  line(x+lineWeight, y+h-lineWeight, x+w-lineWeight, y+h-lineWeight);

  stroke(255);
  strokeWeight(lineWeight);
  rect(x+lineWeight, y+lineWeight, w-lineWeight*2, h-lineWeight*3);
}

color colorPickerDialog() {
  return 0;
}

void setCanvasEnable(boolean b){ //<>//
  canvasEnable = b && !(
    menuOpened || 
    dialogIsDisplay||
    allMenuBoxStatus ||
    windowSelected ||
    currentWindowLevel > 0
  );
}

void setCanvasEnable(){
  setCanvasEnable(true);
}

boolean isMouseCovered(int mX,int mY,int x,int y,int w,int h){
  return mX > x && mX < x+w && mY > y && mY < y+h;
}
