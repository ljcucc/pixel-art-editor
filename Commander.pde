import java.util.regex.*;  
import java.lang.*;

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
    this.parenthesize(this.tokenize(command));
  }
  
  private String[] tokenize(String command){
    command = command;
    String[] strSpl = command.split("\"");
    
    for(int i = 0; i < strSpl.length; i++){
      if(i%2 == 1)
        strSpl[i] = strSpl[i].replaceAll(" ", "!!whitespace!!")
        .replaceAll("[\\(]", "!!str_pstart!!")
        .replaceAll("[\\)]", "!!str_pend!!");
      else
        strSpl[i] = strSpl[i].replaceAll("[\\(]", " ( ").replaceAll("[\\)]", " ) ");
    }
    
    String[] result = String.join("\"", strSpl).trim().split(" ");
    
    for(int i = 0; i < result.length; i++){
      result[i] = result[i].replaceAll("!!whitespace!!", " ");
    }
    
    println(String.join(",",result));
    
    return result;
  }
  
  private void parenthesize(String[] tonkenized){
    for(int i = 0; i < tonkenized.length; i++){
      if(tonkenized[i].equals("(")) tonkenized[i] = "[\"";
      else if(tonkenized[i].equals(")")) tonkenized[i] = "\"]";
      else tonkenized[i] = (
        tonkenized[i].charAt(0) == '\"'?
          (tonkenized[i].charAt(tonkenized[i].length()-1) != '\"'? tonkenized[i] + "\"" : tonkenized[i]) :
          
          (isNaN(tonkenized[i]) ? 
            "\"$"+tonkenized[i]+"\"" :
            tonkenized[i]
          )
      );
    }
    
    String JSON = "["+String.join(",", tonkenized).replaceAll("!!str_pstart!!", "(").replaceAll("!!str_pend!!", ")")+"]";
    println(JSON);
    
  }
}

boolean isNaN(String value){
  try{
    Integer.parseInt(value);
    return false;
   }catch(Exception e){
    return true;
   }
}
