class JavascriptEngine{
  String code = "";
  
  public void exec(){
    error("Javascript plugin engine is not support on Andorid and Developmenet version of PC program now on."
    ,"ScriptEngine");
  }
  
  public void loadFromFile(String path){
    error("Javascript plugin engine is not support on Andorid and Developmenet version of PC program now on.",
    "ScriptEngine");
  }
}


//class JavascriptEngine {
//  ScriptEngineManager factory = new ScriptEngineManager();
//  ScriptEngine engine = factory.getEngineByName("JavaScript");

//  public String code = "";

//  JavascriptEngine(String code) {
//    this.code = code;
//    init();
//  }

//  JavascriptEngine() {
//  }

//  public void loadFromFile(String path) {
//    String codes = getStringFromFile(path);
//    this.code = codes;
//    init();
//  }
  
//  protected void init(){
//    engine.put("Editor", new EditorAPI());
//    engine.put("system", new SystemJS());
//    engine.put("Element", new ElementJS());
//  }

//  public String exec() {
//    //JSONObject ans = new JSONObject();
    
    
//    Object result = "no answer found.";
//    try {
//      result = engine.eval(code);
//    }
//    catch(Exception e) {
//      println("catch a error during javascript execution:"+e);
//    }

//    if (result instanceof String[]) {
//      println("typeof String[]");
//      String[] array = (String[])result;
//      for (String o : array) {
//        println(o.toString());
//      }
//    } else if (result instanceof int[]) {
//      println("typeof int[]");
//      int[] array = (int[])result;
//      for (int o : array) {
//        println(o);
//      }
//    } else {
//      //println("unknow type of Object");
//    }

//    return result.toString();
//  }
//}


//public class EditorAPI {
//  int startX = padding,countWidth = 0;

//  public void hi() {
//    println("Hello world");
//  }

//  public Element createMenu(String title, String[] menus) {
//    println(countWidth+","+startX);
//    MenuButton menuButton = new MenuButton(title, new MenuBox(menus, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2 ), startX + countWidth);
//    //elements.add(menuButton);
    
//    countWidth += menuButton.getWidth();
//    //println("Menu added:"+title+","+countWidth);
//    //return Math.round(menuButton.getWidth());
//    return menuButton;
//  }

//  public Element createMenuBar() {
//    return new MenuBar();
//  }

//  public void setupElements() {
//    println("init Elements...");
//    for (int i = 0; i < elements.size(); i++) {
//      elements.get(i).setup();
//    }
//  }
  
//  public void finish(){
//    runCommand("q");
//  }
  
//  public void setProp(String key,boolean value){
//    systemProp.setBoolean(key,value);
//  }
  
//  public void addElement(ElementUI e){
//    elements.add(e);
//  }
  
//  public void makeToast(String text){
//    println("toast: "+text);
//  }

//  @Override
//    public String toString() {
//    println("foo is toString...");
//    return "String!!!!!!!";
//  }
//}

//public class SystemJS{
//  public int getWidth(){
//    return width;
//  }
  
//  public int getHeight(){
//    return height;
//  }
//}

//public class ElementJS{
//  public Element createCanvas(int[] canvasSize, int[] canvasRange){
//    Canvas c = new Canvas(canvasSize,canvasRange);
//    return c;
//  }
//}
