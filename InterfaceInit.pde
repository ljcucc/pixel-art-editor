//# InterfaceInit

int[] canvasRange = {250, 100, width, height};

void uiSetup() {
  int countWidth = 0, startX = padding;
  int[] canvasSize = {132, 132};

  Canvas canvas = new Canvas(canvasSize, canvasRange);

  // MENU
  String[] fileOptions = {"Open file [:e]", "Save file [:w]", "Close [:q]", "New tab [:newtab]"};
  String[] editOptions = {"Undo [u]", "Redo [r]", "Cut [d]", "Copy [c]", "Paste [p]"};
  String[] ViewOptions = {"Move canvas[Arrow key]", "Room in [+]", "Room out [-]"};
  String[] WindowsOptions = {"Commom tools [:win Common tools]"};
  String[] toolsOptions = {"Colors [1~9]", "Pencil [:nofill]", "Eraser [e]", "Fill [:fill]"};
  String[] helpOptions = {"About [:about]", "Command help [:h or :help]"};
  
  MenuButton Menu_File = new MenuButton("File", new MenuBox(fileOptions, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2 ), startX);
  countWidth += Menu_File.getWidth();
  MenuButton Menu_Edit = new MenuButton("Edit", new MenuBox(editOptions, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2), startX+countWidth);
  countWidth += Menu_Edit.getWidth();
  MenuButton Menu_View = new MenuButton("View", new MenuBox(ViewOptions, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2), startX+countWidth);
  countWidth += Menu_View.getWidth();
  MenuButton Menu_Windows = new MenuButton("Windows", new MenuBox(WindowsOptions, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2), startX+countWidth);
  countWidth += Menu_Windows.getWidth();
  MenuButton Menu_Tools = new MenuButton("Tools", new MenuBox(toolsOptions, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2), startX+countWidth);
  countWidth += Menu_Tools.getWidth();
  MenuButton Menu_Help = new MenuButton("Help", new MenuBox(helpOptions, startX+countWidth - lineWeight *2, systemFontSize + padding*2 + lineWeight *2), startX+countWidth);

  //UIs
  ShortcutManager sm = new ShortcutManager();
  
  KeyHintBox editCanvas = new KeyHintBox(0, "␣", "Edit\ncanvas") {

    public void preDraw() {
      super.show = !canvasEnable;
    }
    
    @Override
    public void onActionDo(){
      canvasEnable = true;
      refresh();
      println("action do!");
      //uiRefresh();
    }
  };
  KeyHintBox roomInKey = new KeyHintBox(0, "+","Room In");
  roomInKey.show = true;
  KeyHintBox roomOutKey = new KeyHintBox(0, "-","Room Out");
  roomOutKey.show = true;
  
  sm.addShortcut(editCanvas);
  sm.addShortcut(roomInKey);
  sm.addShortcut(roomOutKey);
  
  
  DialogBox dialogBox = new DialogBox("");
  
  
  Window commonWindow = new Window(30,80,"Common tools");
  //commonWindow.add(new Label("Common tools",0,0));
  commonWindow.add(new ColorButton(0,30));
  commonWindow.add(new ColorButton(40+lineWeight+8,30));
  commonWindow.add(new Button("pick color",16,100){
    public void onClick(){
      changeWindowDisplay("ColorPicker",true);
      refresh();
    }
  });
  commonWindow.w = 230;
  commonWindow.enableTitle();
  commonWindow.enableCloseButton();
  
  Window colorPicker = new Window(0,0,"ColorPicker");
  colorPicker.w = 500;
  colorPicker.level = 1;
  colorPicker.center();
  colorPicker.enableTitle();
  colorPicker.enableCloseButton();
  //colorPicker.add(new Button("test",20,60));
  colorPicker.add(new ColorList(24,60));
  colorPicker.center = true;

  CommandPrompt cp = new CommandPrompt();

  elements.add(canvas);
  elements.add(commonWindow);
  elements.add(colorPicker);
  elements.add(new MenuBar());
  elements.add(dialogBox);
  elements.add(Menu_File);
  elements.add(Menu_Edit);
  elements.add(Menu_View);
  elements.add(Menu_Windows);
  elements.add(Menu_Tools);
  elements.add(Menu_Help);
  elements.add(cp);
  elements.add(sm);
  
  
  //elements.add(roomOutKey);


  //for (int i = 0; i < elements.size(); i++) {
  //  elements.get(i).setup();
  //}
}
