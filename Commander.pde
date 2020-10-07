import java.util.regex.*;  
import java.lang.*;

class CommandDetector{
  protected boolean commandDetected = false;
  protected String recorded = "";
  
  protected PFont font;
  
  CommandDetector(){
    this.font = loadFont("fonts/Monospaced-48.vlw");
  }
  
  private void detectTyping(){
    if(key == ':'){
      this.commandDetected = true;
      println("command start");
      return; // detected command is typing with ':' head.
    }
    
    if(key == '\n' && this.commandDetected){
      runLisp(this.recorded);
      this.commandDetected = false;
      this.recorded = "";
    }
    
    if(key == '\u0008' && this.commandDetected){
      if(this.recorded.length() <= 0) return;
      
      this.recorded = this.recorded.substring(0, this.recorded.length() -1);
      return;
    }
    
    if(commandDetected){
      this.recorded += key;
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

void runLisp(String command){
  CommandExec(parseJSONArray(parenthesize(tokenize(command))));
}

String[] tokenize(String command){
    //command = command;
    String[] strSpl = command.split("\"");
    
    for(int i = 0; i < strSpl.length; i++){
      if(i%2 == 1)
        strSpl[i] = strSpl[i].replaceAll(" ", "!!whitespace!!")
        .replaceAll("[\\(]", "!!str_pstart!!")
        .replaceAll("[\\)]", "!!str_pend!!");
      else
        strSpl[i] = strSpl[i].replaceAll("[\\(]", " ( ").replaceAll("[\\)]", " ) ");
    }
    
    String[] result = String.join("\"", strSpl).trim().split("\\s+");
    
    for(int i = 0; i < result.length; i++){
      result[i] = result[i].replaceAll("!!whitespace!!", " ");
    }
    
    println(String.join(",",result));
    
    return result;
  }

 String parenthesize(String[] tonkenized){
    for(int i = 0; i < tonkenized.length; i++){
      if(tonkenized[i].equals("(")) tonkenized[i] = "[\"\"";
      else if(tonkenized[i].equals(")")) tonkenized[i] = "\"\"]";
      else if(tonkenized[i].length() == 0) tonkenized[i] = tonkenized[i];
      else tonkenized[i] = (
        tonkenized[i].charAt(0) == '\"'?
          (tonkenized[i].charAt(tonkenized[i].length()-1) != '\"'? tonkenized[i] + "\"" : tonkenized[i]) :
          
          (isNaN(tonkenized[i]) ? 
            "\"$"+tonkenized[i]+"\"" :
            tonkenized[i]
          )
      );
    }
    
    return "["+String.join(",", tonkenized).replaceAll("!!str_pstart!!", "(").replaceAll("!!str_pend!!", ")")+"]";
    
  }
boolean isNaN(String value){
  try{
    Integer.parseInt(value);
    return false;
   }catch(Exception e){
    return true;
   }
}
