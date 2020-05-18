//# MenuUI

/*

 # MenuUI class:
 * MenuBox
 * MenuButton
 * MenuBar
 
 */
 
boolean menuOpened = false;
public class MenuButton extends ElementUI {
  MenuBox menuSheet;
  String title;
  int x;
  float w;

  MenuButton(String title, MenuBox menu, int x) {
    this.menuSheet = menu;
    this.title = title;
    this.x = x;
    textSize(systemFontSize);
    w = textWidth(this.title) + systemFontSize + padding*2;
  }

  boolean mouseCovered = false;

  public void draw() {
    //drawMenuButton(title, x);
    setup();

    boolean willRefresh = false;

    if (menuSheet.showMenu && mousePressed && !(mouseX > x && mouseX-4 < x+w && mouseY > 0 && mouseY < systemFontSize + padding)) {
      println("pressed outline #1");

      menuSheet.onClick(mouseX, mouseY);

      menuSheet.hide();
      allMenuBoxStatus = false;
      willRefresh = true;
    }

    if (mouseX > x && mouseX < x+w-systemFontSize && mouseY > 0 && mouseY < systemFontSize + padding) {
      if (!mouseCovered) {
        mouseCovered = true;
        willRefresh = true;
      }
    } else if (mouseCovered) {
      mouseCovered = false;
    }

    boolean coverdInsideMenuBar = (mouseY > 0 && mouseY < systemFontSize + padding);

    if (allMenuBoxStatus && mouseCovered && !menuSheet.showMenu && coverdInsideMenuBar) {
      menuSheet.show();
      willRefresh = true;
    } else if (allMenuBoxStatus && !mouseCovered && menuSheet.showMenu && coverdInsideMenuBar) {
      menuSheet.hide();
      willRefresh = true;
    }

    if (willRefresh) {
      uiRefresh();
      refresh();
    }

    menuSheet.draw();
  }

  public void setup() {
    textSize(systemFontSize);
    w = textWidth(this.title) + systemFontSize + padding*2;
    
    drawMenuButton(title, x);

    if (mouseCovered) {
      fill(0, 0, 0, 70);
      noStroke();
      rect(x-padding, padding, this.getWidth()-padding, systemFontSize + padding);
    }

    this.menuSheet.setup();
  }

  public void onClick(int mX, int mY) {

    //float w = textWidth(this.title);
    

    //menuSheet.onClick(mX, mY);

    if (mX > x && mX < x+w-padding*2 && mY > 0 && mY < systemFontSize + padding) {
      menuSheet.toggle();
      setCanvasEnable(false);
      allMenuBoxStatus = menuSheet.showMenu;
    } else {
      menuSheet.hide();
    }
  }

  protected int drawMenuButton(String text, int x) {
    //int ans = -1;

    textAlign(LEFT, CENTER);
    
    textSize(systemFontSize);
    fill(0);
    text(text, x, padding*2+systemFontSize/4);

    return x;
  }

  public float getWidth() {
    textSize(systemFontSize);
    return textWidth(this.title) + padding*2 + lineWeight *2;
  }
}
public class MenuBox  extends ElementUI {
  private String[] options;
  int x, y, h, w = 150;
  public boolean showMenu;
  int maxWidth = 200; //min width

  MenuBox(String[] options, int x, int y) {
    this.options = options;
    this.x = x;
    this.y = y;
    this.h = (options.length == 0 ?1:options.length) * (systemFontSize + padding*2) ;
  }  

  public void draw() {
    if (showMenu) {
      ArrayList<MenuBoxItem> menuOptions = getMenuBoxItemFromCurrentStatus(maxWidth);
      for (MenuBoxItem current : menuOptions) {
        current.draw();
      }
    }
  }

  public void setup() {
    if (showMenu && allMenuBoxStatus) {
      ArrayList<MenuBoxItem> menuOptions = getMenuBoxItemFromCurrentStatus();


      //get max width of menu items that makes text won't overflow.
      for (MenuBoxItem current : menuOptions) 
        maxWidth = max(Math.round(current.getWidth()), maxWidth);

      //reset all item's width
      menuOptions = getMenuBoxItemFromCurrentStatus(maxWidth);

      drawBox(this.x, this.y, maxWidth, h+lineWeight*2);

      //draw items
      for (MenuBoxItem current : menuOptions) {
        current.setup();
        maxWidth = max(Math.round(current.getWidth()), maxWidth);
      }
    }
  }

  public void onClick(int mX, int mY) {
    if (showMenu) {
      ArrayList<MenuBoxItem> menuOptions = getMenuBoxItemFromCurrentStatus();
      for (MenuBoxItem current : menuOptions) {
        current.onClick(mX, mY);
      }
      //hide();
      allMenuBoxStatus = false;
      menuOpened = true;
    }
  }

  protected void drawBox(int x, int y, int w, int h) {
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

  public void show() {
    showMenu = true;
    allMenuBoxStatus = true;
    
    setCanvasEnable(false);
  }

  public void hide() {
    showMenu = false;
  }

  public void toggle() {
    //println("menu toggling");
    showMenu = !showMenu;
    //allMenuBoxStatus = showMenu;
    
    if(allMenuBoxStatus){
      setCanvasEnable(false);
    }
  }

  private ArrayList<MenuBoxItem> getMenuBoxItemFromCurrentStatus() {
    return getMenuBoxItemFromCurrentStatus(200);
  }

  private ArrayList<MenuBoxItem> getMenuBoxItemFromCurrentStatus(int w) {
    int startX = this.x + padding, startY = this.y + padding;
    ArrayList<MenuBoxItem> menuOptionButtons = new ArrayList<MenuBoxItem>();
    for (String current : options) {
      MenuBoxItem item = new MenuBoxItem(current, "id", startX, startY, w);
      startY += item.getHeight();
      menuOptionButtons.add(item);
    }

    return menuOptionButtons;
  }
}

public class MenuBoxItem extends ElementUI {

  int x, y, w;
  String title;

  public MenuBoxItem(String title, String id, int x, int y, int w) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.title = title;
  }

  public void setup() {
    textSize(systemFontSize);
    fill(0);
    //textAlign(LEFT,TOP);
    textAlign(LEFT,CENTER);
    text(title, x+padding, y+padding+systemFontSize/4);
  }

  public void draw() {
    int boxHeight = systemFontSize+padding*2;
    boolean mouseCovered = mouseX > x &&mouseX < x+w && mouseY > y && mouseY < y+boxHeight;
    if (mouseCovered) {
      fill(0, 70);
      noStroke();
      rect(x, y, this.w-padding*2, boxHeight);
    }
  }

  public void onClick(int mX, int mY) {
    int boxHeight = systemFontSize+padding*2;
    boolean buttonClicked = mX > x && mX < x+w && mY > y && mY < y+boxHeight;
    if (buttonClicked) {
      allMenuBoxStatus = false;
      
      println("clicked:"+title);
      String command = title.split("\\[")[1]; //get key THIS-> "[":q]
      command = command.substring(0, command.length()-1); // remove last char
      if (command.indexOf(":") == 0) {
        command = command.substring(1, command.length());
        runCommand(command);
        //refresh();
      }
    }
  }

  public int getHeight() {
    int ans = systemFontSize + padding *2 ;
    return  ans;
  }

  public float getWidth() {
    textSize(systemFontSize);
    return textWidth(title) + padding *2 + lineWeight *4;
  }

  public void setWidth(int w) {
    this.w = w;
  }
}

public class MenuBar extends ElementUI {
  public void setup() {
    noStroke();
    fill(210, 203, 191);
    rect(0, 0, width, systemFontSize + padding*2 + lineWeight *2);

    stroke(255);
    strokeWeight(lineWeight);
    line(0, systemFontSize + padding*2 + lineWeight, width, systemFontSize + padding*2 + lineWeight);

    stroke(0);
    line(0,  systemFontSize + padding*2  + lineWeight*2, width, systemFontSize + padding*2  + lineWeight*2);
  }

  public void draw() {
    setup();
  }

  public void onEvent(String type, JSONObject parm) {
  }

  public void onClick(int mX, int mY) {
    if (mY > systemFontSize + padding) {
      allMenuBoxStatus = false;
    }
  }
}
