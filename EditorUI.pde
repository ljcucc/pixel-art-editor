public class CommandPrompt extends ElementUI {
  public void onEvent(String type, JSONObject parm) {
  }

  public void setup() {
    
  }

  public void draw() {
    //if (enterCommand) {
    //  refresh();
    //}
    if (enterCommand) {
      textSize(systemFontSize);
      String showString = "> "+commandEntered;
      int w = max(300, Math.round(textWidth(showString))+32);
      drawBox(32, height-100, w, systemFontSize+padding*4);
      fill(0, 230);
      textAlign(LEFT, CENTER);
      text(": "+commandEntered, 32 + padding + lineWeight*2, height-100, w, systemFontSize+padding*4);//32+16, height-100+systemFontSize+padding*2);
    }
  }

  protected void drawBox(int x, int y, int w, int h) {
    h+=lineWeight*2;

    noStroke();
    fill(210, 203, 191, 230);
    rect(x+lineWeight/2, y+lineWeight/2, w-lineWeight, h);
    noFill();

    stroke(0, 230);
    strokeWeight(lineWeight);
    rect(x, y, w, h);

    stroke(0, 150);
    line(x+lineWeight, y+h-lineWeight, x+w-lineWeight, y+h-lineWeight);

    stroke(255);
    strokeWeight(lineWeight);
    rect(x+lineWeight, y+lineWeight, w-lineWeight*2, h-lineWeight*3);
  }

  public void onClick(int mX, int mY) {
  }
}

class KeyHintBox extends ElementUI {
  String shortcut = "";
  String showName = "";
  public int count;
  int margin = 36;
  public boolean show = false;

  KeyHintBox(int count, String shortcut, String name) {
    this.count = count;
    this.shortcut = shortcut;
    this.showName = name;
  }

  public void draw() {
    setup();
  }

  public void setup() {
    preDraw();
    if (show)
      onDraw();
    
  }

  public void preDraw() {
    //show = true;
  }

  private void onDraw() {
    drawBox(width-margin-50-count, height-margin-50-30, 50, 50);
    textAlign(CENTER, CENTER);
    textSize(systemFontSize);
    fill(0);
    text(shortcut, width-margin-50-count, height-margin-50-30, 50, 50);
    textSize(24);
    textAlign(CENTER, BOTTOM);
    stroke(255);
    strokeWeight(3);
    textLeading(18);
    text(showName, width-margin-50/2-count, height-margin+20);
  }

  public void onClick(int mX, int mY) {
    onClick();
    int wh = 50, x = width-margin-50-count, y = height-margin-50-30;
    if (mX > x && mX < x + wh && mY > y && mY < y +wh) {
      onActionDo();
      refresh();
    }
  }
  
  public void onBoardcast(String name,JSONObject e){
    if(name.equals("shortcut")){
      String shortcut = e.getString("keys");
      
      println("key!!!");
      
      if(this.shortcut.equals(shortcut)){
        onActionDo();
        shortcutEntered = "";
      }else if(shortcut.equals(" ") && this.shortcut.equals("␣")){
        onActionDo();
        shortcutEntered = "";
      }
    }
  }
  
  public void onClick(){
  }

  public void onActionDo() {
  }
}

class ShortcutManager extends ElementUI{
  ArrayList<KeyHintBox> shortcuts;
  
  ShortcutManager(){
     shortcuts = new ArrayList<KeyHintBox>();
  }
  
  public void addShortcut(KeyHintBox shortcut){
    shortcuts.add(shortcut);
    
    int count = 0;
    for(KeyHintBox item :shortcuts){
      if(item.show){
        item.count = count;
        count += 100;
      }      
    }
  }
  
  public void setup(){
    int count = 0;
    for(KeyHintBox item :shortcuts){
      if(item.show){
        item.count = count;
        count += 100;
      }      
    }
    
    for(KeyHintBox item :shortcuts){
      item.setup();
    }
  }
  
  public void draw(){
    int count = 0;
    for(KeyHintBox item :shortcuts){
      if(item.show){
        item.count = count;
        count += 100;
      }      
    }
    for(KeyHintBox item :shortcuts){
      item.draw();
    }
  }
  
  //public void onEvent(String name,JSONObject e){
  //}
  
  public void onBoardcast(String name, JSONObject e){
    int count = 0;
    for(KeyHintBox item :shortcuts){
      if(item.show){
        item.count = count;
        count += 100;
      }else{
        println(item.showName+" is not showing");
      }
    }
    for(KeyHintBox item : shortcuts){
      item.onBoardcast(name,e);
    }
  }
  
  public void onClick(int mX,int mY){
    for(KeyHintBox item : shortcuts){
      item.onClick(mX,mY);
    }
  }
}

boolean dialogIsDisplay = false;

class DialogBox extends ElementUI {
  String msg;
  boolean showit = false;
  color textColor = color(0,0,0);
  int w = 500;
  
  DialogBox(String msg) {
    this.msg = msg;
  }

  public void setMessage(String msg) {
    this.msg = msg;
  }

  public void draw() {
    setup();
  }

  public void setup() {
    int 
      h = w/5*3, 
      x = (width-w) /2, 
      y = (height-h) / 2;

    if (mousePressed && mouseX > x && mouseX < x + w && mouseY > y && mouseY < y +h) {
      this.showit = false;
      dialogIsDisplay = false;
    }

    if (showit) {
      //canvasEnable = false;
      drawBox(x, y, w, h);
      fill(textColor);
      textAlign(CENTER, CENTER);
      text(msg, x, y, w, h);
    }
  }

  public void show(String msg) {
    this.showit = true;
    dialogIsDisplay = true;
    this.msg = msg;
  }

  public void onBoardcast(String name, JSONObject e) {
    if (name.equals("showDialog")) {
      if(e.getString("type").equals("error")){
        textColor = color(255,0,0);
      }else{
        textColor = color(0);
      }
      
      if(e.getString("size").equals("small")){
        w = 450;
      }else{
        w = 500;
      }
      
      show(e.getString("msg")+"\n\n\n[Done]");
    }
  }
  
  public void onKeyPressed(int k,int kc){
    if(k == '\n'){
      showit = false;
      msg = "";
    }
  }
}
