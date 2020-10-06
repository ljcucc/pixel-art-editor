//# Element

ArrayList<ElementUI> elements = new ArrayList<ElementUI>();

/*UML X
 
 # interface - Element
 + void setup();
 + void draw();
 + void uiUpdate();
 + EventRange getEventRange();
 # interface - ElementOnEventListener
 + void onEvent(HashMap event);
 */

boolean allMenuBoxStatus = false;

void uiRefresh() {
   uiRendering();
}

//uiSetup plz goto "InterfaceInit"

void uiRendering() {

  renderingTimes++;
  
  for (short i = 0; i < elements.size(); i++) {
    elements.get(i).draw();
  }
}

public interface Element {
  public void setup();
  public void draw();
  
  public void onEvent(String type, JSONObject parm);
}
public class ElementUI implements Element {
  public void setup() {
  }

  public void draw() {
  }
  
  public void onEvent(String type, JSONObject e) {
    if (type.equals("click"))
      onClick(e.getInt("mouseX"), e.getInt("mouseY"));
    else if (type.equals("pressed"))
      onKeyPressed(e.getInt("key"), e.getInt("keyCode"));
    else if (type.equals("menuToggle"))
      onMenuClick(e.getBoolean("state"));
    else if (type.equals("boardcast"))
      onBoardcast(e.getString("name"), e);
    if (type.equals("buttonClick"))
      onButtonClick(e.getInt("mouseX"), e.getInt("mouseY"));
      
    refresh();
  }

  public void onClick(int mX, int mY) {}
  public void onKeyPressed(int key, int keyCode) {}
  public boolean onAction(String actionName) {
    return false;
  }
  public void onMenuClick(boolean status) {}
  public void onBoardcast(String name, JSONObject e) {}  
  public void onButtonClick(int mX,int mY){}
}

interface ElementOnEventListener {
  public void onEvent(HashMap event);
}
