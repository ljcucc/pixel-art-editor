class CommandDetector{
  private boolean commandDetected = false;
  private String recorded = "";
  
  private PFont font;
  
  CommandDetector(){
    this.font = loadFont("fonts/Monospaced-48.vlw");
  }
  
  private void detectTyping(){
    if(key == ':'){
      this.commandDetected = true;
      println("command start");
      return; // detected command is typing with ':' head.
    }
    
    if(key == '\n'){
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
    rect(0, height-50, width, 40);
    
    fill(0);
    textFont(this.font);
    textSize(18);
    text(":"+this.recorded, 4, height-20);
  }
}
