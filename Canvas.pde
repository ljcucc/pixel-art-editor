boolean canvasEnable = true;
short enableCanvas = 0;
class Canvas extends ElementUI {
  public int[] canvasRange;
  int[] canvasSize, lastPosition = {-1, -1};  
  ArrayList<Layer> layers;
  int currentLayerIndex = 0;
  PGraphics canvas;
  int canvasRoom = 5;
  boolean fillColor = false;
  boolean lastPressed = false;
  
  color penColor = color(0,0,0);

  Canvas(int[] canvasSize, int[] canvasRange) {
    this.canvasSize = canvasSize;
    this.canvasRange = canvasRange;

    layers = new ArrayList<Layer>();
    Layer background = new Layer(canvasSize[0], canvasSize[1]);
    background.g = canvasSetup(background.g);
    layers.add(background);
    canvas = createGraphics(canvasSize[0], canvasSize[1]);
  }

  public void setup() {    
    
  }

  public void draw() {
    renderingLayer();
    
    if (mousePressed && canvasEnable && !menuOpened) {

      lastPressed = true;
      Layer current = layers.get(currentLayerIndex);

      PGraphics returnResult = paintEvent(current.g);
      current.g = returnResult;

      layers.set(currentLayerIndex, current);

      renderingLayer();
    } else if (lastPressed) {
      lastPressed = false;
      lastPosition[0] = -1;
      lastPosition[1] = -1;
    }
  }

  void renderingLayer() {
    PGraphics layer = createGraphics(this.canvasSize[0], this.canvasSize[1]);
    //println("canvasRange:"+canvasSize[0]+","+canvasSize[1]);
    layer.beginDraw();
    for (Layer currentLayer : layers) {
      PImage image = currentLayer.getImage();
      //println("image:"+image.width+","+image.height);
      //println("layer:"+layer.width+","+layer.height);
      layer.image(image, 0, 0);
    }
    layer.endDraw();

    int currentPixel = 0;
    layer.loadPixels();
    noStroke();
    //strokeWeight(1);
    //stroke(200);
    for (int canvasH = 0; canvasH < this.canvasSize[1]; canvasH++) {
      for (int canvasW = 0; canvasW < canvasSize[0]; canvasW++) {
        final int 
          startX = canvasW*canvasRoom+this.canvasRange[0], 
          startY = canvasH*canvasRoom+this.canvasRange[1], 
          endX = canvasRoom, 
          endY = canvasRoom;

        color current = layer.pixels[currentPixel];

        fill(red(current), green(current), blue(current));
        rect(startX, startY, endX, endY);

        currentPixel++;
      }
    }
  }

  PGraphics canvasSetup(PGraphics background) {
    //background = createGraphics(canvasSize[0], canvasSize[1]);

    background.noSmooth();
    background.beginDraw();
    background.background(255);
    background.endDraw();

    background.loadPixels();
    background.updatePixels();
    return background;
  }

  PGraphics paintEvent(PGraphics currentLayer) {

    int  // get the position of pixel that mouseClick on canvas;
      x = (mouseX - this.canvasRange[0])/this.canvasRoom, 
      y = (mouseY - this.canvasRange[1])/this.canvasRoom;

    if (fillColor) { //if fillColor mode is on, then don't paint canvas.
      return fillColor(currentLayer, x, y);
    }


    if (lastPosition[0] == -1 && lastPosition[1] == -1) { //Make sure canvas can draw line from user last path
      this.lastPosition[0] = x;
      this.lastPosition[1] = y;
    }
    
    //Start drawing canvas from last press to current press, to make sure the draw won't be SOME DOTS, it'll be a string line.

    currentLayer.beginDraw();
    currentLayer.image(canvas, 0, 0);
    currentLayer.stroke(penColor);
    currentLayer.line(lastPosition[0], lastPosition[1], x, y);
    currentLayer.endDraw();

    this.lastPosition[0] = x;
    this.lastPosition[1] = y;

    return currentLayer;
  }

  //int[][] floodFillPixels;

  protected PGraphics fillColor(PGraphics currentLayer, int mX, int mY) {
    FloodFill ff = new FloodFill(currentLayer,this.penColor);
    ff.buildFill(mX, mY);
    ff.fill();
    return ff.layerGraphic;
  }

  public void importLayer(ArrayList<Layer> layers) { //import a project
    this.layers = layers;
  }

  public void drawPoint(int X, int Y) {
    Layer layer = layers.get(currentLayerIndex);
    layer.g.point(X,Y);
  }

  public color getPoint(int X, int Y) {
    Layer layer = layers.get(currentLayerIndex);
    PGraphics tempCanvas = layer.g;
    return tempCanvas.get(X, Y);
  }

  public boolean onAction(String name) {

    if (name.equals("nofill")) {
      fillColor = false;
      return true;
    }

    if (name.equals("fill")) {
      fillColor = true;
      return true;
    }
    return false;
  }

  public void onBoardcast(String name, JSONObject e) {
    if (name.equals("moveCanvas")) {
      int x = e.getInt("x"), 
        y = e.getInt("y");

      this.canvasRange[0] = x;
      this.canvasRange[1] = y;
    }

    if (name.equals("shortcut")) {
      if (shortcutEntered.equals("+")) {
        int changeValue = 1;
        if (this.canvasRoom + changeValue > 0) {
          canvasRoom += changeValue;
        }
        shortcutEntered = "";
      }else if(shortcutEntered.equals("-")){
        int changeValue = -1;
        if(this.canvasRoom + changeValue > 0){
          canvasRoom += changeValue;
        }
        shortcutEntered = "";
      }
    }
    
    if(name.equals("setPenColor")){
      println("changing pen color");
      penColor = e.getInt("color");
    }

    if (name.equals("roomChange")) {
    }
  }
  
  public void onClick(int mX, int mY){
    setCanvasEnable(true);
  }
  
  public void onButtonClick(int mX,int mY){
    if (menuOpened) {
      menuOpened = false;
      return;
    }
  }
}

class Layer {
  public PGraphics g;
  int[] canvasSize;

  Layer(int w, int h) {
    g = createGraphics(w, h);
    g.noSmooth();
    int [] cs = {w, h};
    canvasSize = cs;
  }

  PImage getImage() {
    PImage pi = createImage(this.canvasSize[0], this.canvasSize[1], ARGB);
    pi.loadPixels();
    g.loadPixels();
    pi.pixels = g.pixels;
    pi.updatePixels();
    g.updatePixels();
    return pi;
  }
}

class FloodFill {
  public PGraphics layerGraphic;
  color penColor;
  int startX, startY;
  int level = 0;
  ArrayList<ArrayList<int[]>> pixels;
  ArrayList<int[]> pixelsExist;

  FloodFill(PGraphics lg,color penColor) {
    this.layerGraphic = lg;
    this.penColor = penColor;

    pixels = new ArrayList<ArrayList<int[]>>();
    pixelsExist = new ArrayList<int[]>();
  }

  public void buildFill(int x, int y) { //Build the rendering map that fill the map
    startX = x;
    startY = y;

    int[] level1 = {x, y};
    pixels.add(new ArrayList<int[]>()); //Add level 0
    pixels.get(pixels.size()-1).add(level1); //ser level 0
    pixelsExist.add(level1);

    pixels.add(new ArrayList<int[]>());

    while (true) {
      for (int[] item : pixels.get(pixels.size()-2)) {
        floodFill(item[0], item[1]);
      }
      if (pixels.get(pixels.size()-1).size() <= 0)
        break;
      //println("level builded:"+(pixels.size()-1));
      pixels.add(new ArrayList<int[]>());

      //if((pixels.size()-1) > 300){
      //  break;
      //}
    }
  }

  public void fill() { //Fill map from rendering builded
    layerGraphic.beginDraw();
    layerGraphic.fill(penColor);
    for (ArrayList<int[]> list : pixels) {
      for (int[] pixel : list) {
        layerGraphic.point(pixel[0], pixel[1]);
      }
    }
    layerGraphic.endDraw();
  }

  protected void floodFill(int x, int y) { //Process of build rendering map
    int[] pixel = new int[2];
    ArrayList<int[]> ps = pixels.get(pixels.size()-1);


    if (isMovable(x, y+1)) {
      pixel[0] = x;
      pixel[1] = y+1;
      ps.add(pixel);
      pixelsExist.add(pixel);
      //println("added");
    } 
    if (isMovable(x, y-1)) {
      pixel[0] = x;
      pixel[1] = y - 1;
      ps.add(pixel);
      pixelsExist.add(pixel);
      //println("added");
    }
    if (isMovable(x+1, y)) {
      pixel[0] = x+1;
      pixel[1] = y;
      ps.add(pixel);
      pixelsExist.add(pixel);
      //println("added");
    }
    if (isMovable(x-1, y)) {
      pixel[0] = x-1;
      pixel[1] = y;
      ps.add(pixel);
      pixelsExist.add(pixel);
      //println("added");
    } 
    pixels.set(pixels.size()-1, ps);
  }

  protected boolean isMovable(int x, int y) { //checking the pointer is movable
    int[] p = {x, y};
    if (existPosition(p))
      return false;
    int pixel = layerGraphic.get(x, y);
    return pixel == -1;
  }

  protected boolean existPosition(int[] value) { // checking the pixel are already painted
    for (int[] i : pixelsExist) {
      if (i[0] == value[0] && i[1] == value[1]) {
        return true;
      }
    }
    return false;
  }
}

public enum Direction { //Direction for FloodFill class
  UP, DOWN, LEFT, RIGHT, CURRENT
};

//class CanvasTrutle {
//  public PGraphics canvas;
//  int positionX, positionY;
//  protected boolean penIsDown = false;
//  color penColor;



//  public CanvasTrutle(PGraphics canvas, int positionX, int positionY, color penColor) {
//    this.canvas = canvas;

//    this.positionX = positionX;
//    this.positionY = positionY;

//    this.penColor = penColor;
//  }

//  public boolean canDraw(Direction dir) {
//    int x = positionX, y = positionY;
//    switch(dir) {
//    case UP:
//      y --;
//      break;
//    case DOWN:
//      y ++;
//      break;
//    case LEFT:
//      x --;
//      break;
//    case RIGHT:
//      x ++;
//      break;
//    case CURRENT:
//      break;
//    default:
//      println("type not found");
//    }

//    boolean resultEdge = moveWillTouchEdge(x, y);

//    //if (y < 0) {
//    //  y = 0;
//    //} else if (y > canvas.height) {
//    //  y = canvas.height;
//    //} else if (x < 0) {
//    //  x = 0;
//    //} else if (x > canvas.width) {
//    //  x = canvas.width;
//    //}

//    println(canvas.get(x, y) +" and "+penColor);

//    if (resultEdge)
//      return false;

//    return canvas.get(x, y) == 0 || canvas.get(x, y) == -1;
//  }

//  public void startDraw() {
//    println("start draw");
//    canvas.beginDraw();
//    penIsDown = true;
//  }

//  public void endDraw() {
//    println("end draw");
//    canvas.endDraw();
//    penIsDown = false;
//  }

//  public void move(Direction dir) {
//    print("trutle is moving :x"+new Integer(positionX)+", y:"+new Integer(positionY));
//    switch(dir) {
//    case UP:
//      println("UP");
//      positionY --;
//      break;
//    case DOWN:
//      println("DOWN");
//      positionY ++;
//      break;
//    case LEFT:
//      println("LEFT");
//      positionX --;
//      break;
//    case RIGHT:
//      println("RIGHT");
//      positionX++;
//      break;
//    }

//    if (positionY < 0) {
//      positionY = 0;
//    } else if (positionY > canvas.height) {
//      positionY = canvas.height;
//    } else if (positionX < 0) {
//      positionX = 0;
//    } else if (positionX > canvas.width) {
//      positionX = canvas.width;
//    }

//    draw();
//  }

//  private void draw() {
//    if (penIsDown)
//      canvas.point(positionX, positionY);
//    println("drawing...");
//  }

//  private boolean moveWillTouchEdge(int x, int y) {
//    return y < 0||
//      y > canvas.height||
//      x < 0||
//      x > canvas.width;
//  }

//  public void goTo(int x, int y) {
//    positionX = x;
//    positionY = y;
//  }
//}
