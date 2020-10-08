import java.util.regex.*;  
import java.lang.*;

class CommandDetector{
  protected boolean commandDetected = false;
  protected String recorded = "";
  
  protected boolean error = false;
  protected String errorMsg = "";
  
  protected PFont font;
  
  CommandDetector(){
    this.font = loadFont("fonts/Monospaced-48.vlw");
  }
  
  private void detectTyping(){
    if(key == ':' && !this.commandDetected){
      this.commandDetected = true;
      error = false;
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
    if(!commandDetected && !error) return;
    
    noStroke();
    if(commandDetected && !error)
      fill(200);
    else
      fill(216, 35, 35);
    rect(0, height-30-FONT_SIZE, width, 20+FONT_SIZE);
    
    fill(commandDetected && !error? 0: 255);
    textFont(this.font);
    textSize(FONT_SIZE);
    if(commandDetected && !error)
      text(":"+this.recorded, 4, height-20);
    else
      text(this.errorMsg, 12, height-20);
    
  }
  
  public void error(String msg){
    error = true;
    errorMsg = msg;
  }
}

void runLisp(String command){
  CmdExec(parseJSONArray(parenthesize(tokenize(command))));
}

String[] tokenize(String command){
    //command = command;
    String[] strSpl = command.split("\"");
    
    for(int i = 0; i < strSpl.length; i++){
      if(i%2 == 1)
        strSpl[i] = strSpl[i].replaceAll(" ", "!!whitespace!!")
        .replaceAll("\\(", "!!str_pstart!!")
        .replaceAll("\\)", "!!str_pend!!");
      else
        strSpl[i] = strSpl[i].replaceAll("\\(", " ( ").replaceAll("\\)", " ) ");
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
      println("tonkenized[i]: "+tonkenized[i]);
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
      
      println("tonkenized[i] after: "+tonkenized[i]);
    }
    
    return "["+String.join(",", tonkenized).replaceAll("!!str_pstart!!", "(").replaceAll("!!str_pend!!", ")")+"]";
    
  }
boolean isNaN(String value){
  try{
    Float.parseFloat(value);
    return false;
   }catch(Exception e){
    return true;
   }
}
