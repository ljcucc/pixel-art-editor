boolean windowSelected = false;
int currentWindowLevel = 0;

class Window extends ElementUI {
  ArrayList<WindowElement> elements = new ArrayList<WindowElement>();
  int x, y, w = 150, h = 300;
  String windowId = "none";
  int level = 0;
  public boolean center = false;

  public boolean show = false;

  Window(int  x, int y, String windowId) {
    this.x = x;
    this.y = y;
    this.windowId = windowId;

    println("Creating a window with: "+windowId);
  }

  public void enableTitle() {
    add(new Label(windowId, 0, 0));
  }

  public void enableCloseButton() {
    CloseButton cb = new CloseButton(windowId, w-46, 8);
    cb.display = true;
    add(cb);
  }

  public void setup() {
    //drawWindows();
    for (WindowElement item : elements) {
      item.setup();
    }
  }

  public void draw() {
    if (mousePressed && show) {
      if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
        windowSelected = true;
        setCanvasEnable();
      } else {
        windowSelected = false;
        setCanvasEnable();
      }
      //else 
      //canvasEnable = true;
    }
    if (!show) return;

    if (center)
      center();

    drawWindows();
    for (WindowElement item : elements) {
      item.wx = x;
      item.wy = y;
      item.draw();
    }
  }

  public void add(WindowElement e) {
    e.wx = x;
    e.wy = y;
    this.elements.add(e);
    resizingWindow();
  }  
  
  public void resizingWindow(){
    for(WindowElement item: this.elements){
      this.w = max(item.w+60 , this.w);
    }
    
    for(WindowElement item : this.elements){
      if(item instanceof CloseButton){
        item.x = this.w - item.w - lineWeight*3;
        break;
      }
    }
  }

  public void drawWindows() {
    if(this.level > 0){
      noStroke();
      fill(0,0,0,100);
      rect(0,0,width,height);
    } 
    drawBox(x, y, w, h);
  }

  public void onEvent(String name, JSONObject e) {
    if(currentWindowLevel > this.level){
      super.onEvent(name, e);
      return;
    }
    for (WindowElement item : elements) {
      item.onEvent(name, e);
    }
    super.onEvent(name, e);
  }
  public void  onButtonClick(int mX, int mY) {
    if (mX > x && mX < x+w && mY > y && mY < y+h && show) {
      windowSelected = true;
      setCanvasEnable();
      refresh();
    }
  }

  public void onBoardcast(String name, JSONObject e) {
    if (name.equals("changeWindowDisplay")) {
      println(e.getString("id"));
      if (e.getString("id").equals(this.windowId)) {
        this.show = e.getBoolean("show");
        if (this.show) {
          setCanvasEnable(false);
          if(currentWindowLevel < this.level)
            currentWindowLevel = this.level;
        }else{
          if(currentWindowLevel > 0){
          currentWindowLevel = 0;
          }
        }
        //refresh();
      }
    }
  }

  public void center() {
    this.x = (width-w)/2;
    this.y = (height-h)/2;
  }
}

void changeWindowDisplay(String id, boolean state) {
  JSONObject e = new JSONObject();
  e.setBoolean("show", state);
  e.setString("id", id);
  boardcast("changeWindowDisplay", e);
}

class WindowElement extends ElementUI {
  public int
    w = 0, 
    h = 0, 
    x = 0, 
    y = 0, 
    wx, //Window X
    wy; //Window Y

  public boolean display = false;
  public int getWidth() {
    return w;
  }

  public int getHeight() {
    return h;
  }
  
  WindowElement(){
  }
  
  WindowElement(int x,int y){
    this.x = x;
    this.y = y;
    
  }
}

class Button extends WindowElement {
  String label = "BUTTON";
  Button(String label, int x, int y) {
    this.x = x;
    this.y = y;
    this.h = 48+lineWeight*2;
    this.label = label.toUpperCase();
    this.w = int(textWidth(this.label)+24);
  } 

  Button() {
  }

  boolean buttonPressed = false;

  public void draw () {
    if (mousePressed) {
      buttonPressed = mouseX > wx+x && mouseX < wx+x+w && mouseY > wy+y && mouseY < wy+y+h;
    }
    if (buttonPressed)
      drawPressed(wx+x, wy+y, w, h, color(40, 53, 147));
    else drawBox(wx+x, wy+y, w, h, color(40, 53, 147));
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(label, wx+x, wy+y, w, h);
  }

  public void onClick(int mX, int mY) {
    if (mX > wx+x && mX < wx+x+w && mY > wy+y && mY < wy+y+h) {
      println("window button clicked");
      buttonPressed = false;
      refresh();
      onClick();
    }
  }

  public void onClick() {
  }

  void drawPressed(int x, int y, int w, int h, color c) {
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

    stroke(150, 200);
    strokeWeight(lineWeight);
    rect(x+lineWeight, y+lineWeight, w-lineWeight*2, h-lineWeight*3);
  }
}

class ColorButton extends WindowElement {
  ColorButton() {
    w = 40;
    h = 40;
  }
  ColorButton(int x, int y) {
    this.x = x;
    this.y = y;

    w = 40;
    h = 40;
  }

  public void onButtonClick(int mX, int mY) {
    if (mX > wx+x+16 && mX < wx+x+16+w && mY > wy+y+16 && mY < wy+y+16+h) {
      JSONObject e = new JSONObject();
      e.setInt("color", int(color(255, 0, 0)));
      boardcast("setPenColor", e);
    }
  }

  public void draw() {
    drawColorButton();
  }

  public void setup() {
    drawColorButton();
  }

  public void drawColorButton() {
    drawBox(wx+x+16, wy+y+16, w, h-lineWeight, color(255, 0, 0));
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
}

class Label extends WindowElement {
  String text = "";
  public int padding = 12;

  Label(String text, int x, int y) {
    this.text = text;
    this.x = x;
    this.y = y;
  }

  public void setup() {
    //draw();
  }

  public void draw() {
    fill(0);
    textSize(24);
    textAlign(LEFT, TOP);
    text(text, wx+x+padding, wy+y+padding);
  }
}

class CloseButton extends Button {
  String windowId;
  CloseButton(String windowId, int x, int y) {
    super();
    this.x = x;
    this.y = y;

    this.w = 40;
    this.h = 40;

    this.windowId = windowId;
  }

  public void draw() {
    if (display) {
      noStroke();
      if (mousePressed) {
        buttonPressed = mouseX > wx+x && mouseX < wx+x+w && mouseY > wy+y && mouseY < wy+y+h;
      }
      if (buttonPressed) {
        super.drawPressed(wx+x, 
          wy+y, 
          w, 
          h, color(255, 0, 0, 150));
      } else drawBox(wx+x, 
        wy+y, 
        w, 
        h, color(255, 0, 0, 150));

      fill(0);
      textAlign(CENTER, CENTER);
      text("X", 
        wx+x, 
        wy+y, 
        w, 
        h);
    }
  }

  public void onClick() {
    JSONObject e = new JSONObject();
    e.setBoolean("show", false);
    e.setString("id", windowId);
    boardcast("changeWindowDisplay", e);
  }
}

class ColorList extends WindowElement{
  color selected = color(255,0,0);
  
  ColorList(int x,int y){
    super(x,y);
    this.w = 510;
    this.h = 10;
  }
  public void draw() {
    drawColorList();
    if(mousePressed && isMouseCovered(mouseX,mouseY, wx+x,wy+y+20,w,35)){
      println("selecting color");
      selected = get(mouseX,mouseY);
    }
  }
  
  void drawColorList(){
    colorMode(HSB, 255); // Start drawing Color List

    int count  = 0;
    noStroke();
    for (int i = 0; i < 255; i++) {      
      fill(i, 255, 255);
      rect(wx+x+count++*2, wy+y+20, 2, 35);
    }

    colorMode(RGB,255); // End for drawing Color List
    
    fill(selected);
    rect(wx+x,wy+y+70,50,50);
  }
}

class WindowDiv extends WindowElement {
  public void setup() {
  }

  public void draw() {
  }
}
