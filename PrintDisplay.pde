class PrintDisplay{
  protected PFont font;
  protected String displayString = "";
  
  PrintDisplay(){
    this.font = loadFont("fonts/Monospaced-48.vlw");
  }
  
  public void render(){
    fill(0);
    textFont(this.font);
    textSize(FONT_SIZE);
    text(this.displayString,20,20);
  }
}
