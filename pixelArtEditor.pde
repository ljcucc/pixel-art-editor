CommandDetector cd;

void setup(){
  size(800, 600);
  
  cd = new CommandDetector(new CommandViewer(), new Commander());
}

void draw(){
  clear();
  background(255);
  
  cd.render();
}

void keyTyped() {
  cd.detectTyping();
}
