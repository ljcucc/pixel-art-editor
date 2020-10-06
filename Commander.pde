import java.util.regex.*;  

int FONT_SIZE = 14;

class CommandDetector{
  private boolean commandDetected = false;
  private String recorded = "";
  
  private PFont font;
  private CommandViewer cv;
  private Commander c;
  
  CommandDetector(CommandViewer cv, Commander c){
    this.font = loadFont("fonts/Monospaced-48.vlw");
    
    this.cv = cv;
    this.c = c;
  }
  
  private void detectTyping(){
    if(key == ':'){
      this.commandDetected = true;
      println("command start");
      return; // detected command is typing with ':' head.
    }
    
    if(key == '\n'){
      c.run(this.recorded);
      this.commandDetected = false;
      this.recorded = "";
    }
    
    if(commandDetected){
      this.recorded += key;
      println(this.recorded);
    }
  }
  
  public void render(){
    if(!commandDetected) return;
    noStroke();
    fill(200);
    rect(0, height-30-FONT_SIZE, width, 20+FONT_SIZE);
    
    fill(0);
    textFont(this.font);
    textSize(FONT_SIZE);
    text(":"+this.recorded, 4, height-20);
  }
}

class Commander{
  public void run(String command){
    command = "("+command+")";
    String[] strSpl = command.split("\"");
    
    for(int i = 0; i < strSpl.length; i++){
      if(i%2 == 1)
        strSpl[i] = "\""+strSpl[i].replaceAll(" ", "!!whitespace!!")
        .replaceAll("(", "!!str_pstart!!")
        .replaceAll(")", "!!str_pend!!")+"\"";
      else
        strSpl[i] = strSpl[i].replaceAll("(", " ( ").replaceAll(")", " ) ");
    }
    
    String strwhtBan = String.join("", strSpl);
    println(String.join(",",strwhtBan.split(" ")));
    
    
    if(command.equals("load")){
      println("load image");
    }
    
    if(command.equals("q") || command.equals("quit")){
      exit();
    }
  }
}
