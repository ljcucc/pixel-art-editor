import javax.script.*;


//Const variables
final String pixelrc = "_pixelrc";

int canvasRoom = 5, systemFontSize = 20, padding = 6, lineWeight = 3,lastWidth = width, lastHeight = height;
PGraphics canvas;
PFont pixelFont;
long renderingTimes = 0;
JSONObject systemProp ;

int[] canvasPosition = {60, 60};

void settings() {
  noSmooth();
  systemProp = loadJSONObject("config.json");

  systemFontSize = systemProp.getInt("systemFontSize");
  lineWeight = systemProp.getInt("lineWeight");

  println(P2D);

  if (systemProp.getBoolean("fullScreen")) {
    fullScreen(P2D);
  } else {
    size(720, 480, FX2D);/*FX2D*/
  }
}

void setup() {
  surface.setResizable(true);


  System.out.println("Application is running");

  //background and windows setup
  background(100, 85, 98);

  pixelFont = loadFont("fonts/Munro-60.vlw");
  textFont(pixelFont);


  uiSetup(); // setup UI elemenets
  runCommandFromFile(pixelrc);
  
  refresh();
}
boolean menuShow = false;

long lasttime = millis();
int fps = 0;
int[] lastMousePosition = {0, 0};

boolean setuped = false;
void draw() {
  if (!setuped) {
    setuped = true;
    frame.setLocation(displayWidth/2-width/2, displayHeight/2-height/2);
  }

  if (lastWidth != width || lastHeight != height) {
    if (width < 400) {
      width = 400;
    }

    if (height < 400) {
      height = 400;
    }

    lastWidth = width;
    lastHeight = height;

    println("Window resize!!");
    refresh();
  }

  if (lastMousePosition[0] != mouseX || lastMousePosition[1] != mouseY) {
    lastMousePosition[0] = mouseX;
    lastMousePosition[1] = mouseY;
    refresh();
  }

  if (menuShow) {
    //drawBox(16, 50, 200, 300);
  }

  //if (millis() - lasttime > fps) {
  //  lasttime = millis();
  //  //println(++renderingTimes);
  //  uiRendering();
  //}
}

int[] lastMousePositionButtonEvent = {0, 0};
void mousePressed() {
  lastMousePositionButtonEvent[0] = mouseX;
  lastMousePositionButtonEvent[1] = mouseY;
  refresh();
}

void mouseClicked() {
  //if((mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 50) || menuShow){
  //  menuShow = !menuShow;
  //}

  int mX = mouseX, mY = mouseY;

  for (int i = elements.size()-1; i > 0; i--) {
    //elements.get(i).Element(mX, mY);
    JSONObject event = new JSONObject();
    event.setInt("mouseX", mX);
    event.setInt("mouseY", mY);

    elements.get(i).onEvent("click", event);
  }

  if (mX == lastMousePositionButtonEvent[0] && mY == lastMousePositionButtonEvent[1]) {
    for (short i = 0; i < elements.size(); i++) {
      //elements.get(i).Element(mX, mY);
      JSONObject event = new JSONObject();
      event.setInt("mouseX", mX);
      event.setInt("mouseY", mY);

      elements.get(i).onEvent("buttonClick", event);
    }

    lastMousePositionButtonEvent[0] = 0;
    lastMousePositionButtonEvent[1] = 0;
  }  

  refresh();
}

void refresh() {
  renderingTimes++;
  clear();
  background(100, 85, 98);
  //renderingLayer(canvas);
  uiRefresh();

  fill(0, 200);
  textSize(26);
  textAlign(RIGHT, BOTTOM);
  text(shortcutEntered, width, height);
}

boolean enterCommand = false;
String commandEntered = "";
String shortcutEntered = "";

void keyTyped() {
  //if command typed

  if (!enterCommand && key == ':') {
    enterCommand = true;
    commandEntered = "";
    refresh();
    return;
  }

  if (enterCommand) { //on command typed
    switch(key) {
    case 8:
      if (commandEntered.length() > 0) {
        commandEntered = commandEntered.substring(0, commandEntered.length()-1);
      } else {
        enterCommand = false;
        commandEntered = "";
        //refresh();
        return;
      }

      break;
    case '\n':
      enterCommand = false;
      refresh();
      runCommand(commandEntered);
      refresh();
      commandEntered = "";

      return;
    default:
      commandEntered+=key;
    }
  } else {//on shortcut typed
    switch(key) {
    case 8:
      shortcutEntered = "";
      break;
    case '\n':
      shortcutEntered = "";
      break;
    case 27:
      //println("ESC");
      break;
    default:
      shortcutEntered += key;
    }

    JSONObject e = new JSONObject();
    println("typing");
    e.setString("keys", shortcutEntered);
    boardcast("shortcut", e);
  }

  refresh();
}

void keyPressed() {
  //refresh();

  if (key==27) {
    key=9487;
    onESC();
  }

  if (key == CODED) {
    keyCodePressed();
    refresh();
    return;
  }

  for (int i = 0; i < elements.size(); i++) {
    //elements.get(i).Element(mX, mY);
    JSONObject event = new JSONObject();
    event.setInt("key", key);
    event.setInt("keyCode", keyCode);

    elements.get(i).onEvent("keyPressed", event);
  }

  //if (keyCode == UP) {
  //}

  refresh();
}

//onKeyCodePressed
void keyCodePressed() {
  if (!canvasEnable) {
    switch(keyCode) {
    case UP:
      canvasRange[1]+=10;
      break;
    case DOWN:
      canvasRange[1]-=10;
      break;
    case LEFT:
      canvasRange[0]+=10;
      break;
    case RIGHT:
      canvasRange[0]-=10;
      break;
    }
  }
}

//onESC pressed
void onESC() {
  enterCommand = false;
  commandEntered = "";
  shortcutEntered = "";
  uiRefresh();
  refresh();

  //Goback from insert mode
  canvasEnable = false;
}
