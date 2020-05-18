//# ActionEngine
JavascriptEngine js = new JavascriptEngine();
public void runCommand(String unparsedCommand) {
  String[] command = unparsedCommand.split(" ");
  String name = command[0];
  try {
    if(unparsedCommand.trim().equals("")){
      return;
    }
    if(unparsedCommand.indexOf("#") == 0){
      return;
    }
    if (unparsedCommand.indexOf("js ") == 0) {
      unparsedCommand =unparsedCommand.substring(3, unparsedCommand.length());
      println(unparsedCommand);

      js.code = unparsedCommand;
      js.exec();

      return;
    }

    if (unparsedCommand.indexOf("jsf ") == 0) {
      unparsedCommand =unparsedCommand.substring(4, unparsedCommand.length());
      println(unparsedCommand);



      js.loadFromFile(unparsedCommand);
      js.exec();

      //  https://docs.oracle.com/javase/6/docs/technotes/guides/scripting/programmer_guide/index.html
      //  https://docs.oracle.com/javase/8/docs/technotes/guides/scripting/prog_guide/javascript.html#A1147187

      return;
    }

    if (name.equals("q")) {
      println("Application quit.");
      exit();
      return;
    }

    if (name.equals("e")) {
      selectInput("Open file", "fileSelected");
      return;
    }

    if (name.equals("fs")) {
      fullScreen();
      return;
    }
    
    if(name.equals("resizable")){
      surface.setResizable(true);
      return;
    }
    
    if (unparsedCommand.indexOf("win ") == 0) {
      unparsedCommand =unparsedCommand.substring(4, unparsedCommand.length());
      println(unparsedCommand);
      String windowId = unparsedCommand;
      
      changeWindowDisplay(windowId,true);
      return;
    }

    if (name.equals("set")) {
      String setType = command[1];
      String value = command[2];
      if (command[1].equals("fps")) {
        fps = Integer.valueOf(command[2]);
        return;
      }
      if (command[1].equals("font")) {
        pixelFont = loadFont("fonts/"+command[2]);
        textFont(pixelFont);
      }
      if (setType.equals("fontSize")) {
        systemFontSize = Integer.valueOf(value);
      }
      if (setType.equals("padding")) {
        padding = Integer.valueOf(value);
      }
      if(setType.equals("canvasEnable")){
        if(value.equals("true")){
          canvasEnable = true;
        }else if(value.equals("false")){
          canvasEnable = false;
        }else{
          throw new Exception(value+" is an unknow type");
        }
      }
      return;
    }

    if (name.equals("system")) {
      String actionName = command[1];
      if (actionName.equals("refresh")) {
        refresh();
      }
      return;
    }

    if (command[0].equals("newtab")) {
      println("creating tabs");
      return;
    }
    
    if(command[0].equals("about")){
      alert("Pixeler is an pixel art editor which base on Processing and Java 8, also open source on Github, you can find the project on @ljcucc/pixeler","About");
      return;
    }
    
    for (int i = 0; i < elements.size(); i++) {  
      if (elements.get(i).onAction(name))
        return;
    }
    
    error("command not found:\""+command[0]+"\" in "+unparsedCommand,"ActionEngine");
  }
  catch(Exception e) {
    error("get an error during execute actoin: "+e,"ActionEngine Exception catcher");
  }
}

void runCommandFromFile(String path) {
  for (String code : loadStrings(path)) {
    runCommand(code);
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
}

String getStringFromFile(String path) {
  String ans = "";
  String[] lines = loadStrings(path);
  for (int i = 0; i < lines.length; i++) {
    ans+=lines[i] +"\n";
  }

  return ans;
}
