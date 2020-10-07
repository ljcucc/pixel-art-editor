int FONT_SIZE = 14;

CommandDetector cd;
PrintDisplay pd;

void setup(){
  size(800, 600);
  
  cd = new CommandDetector();
  pd = new PrintDisplay();
}

void draw(){
  clear();
  background(255);
  
  cd.render();
  pd.render();
}

void keyTyped() {
  cd.detectTyping();
}
