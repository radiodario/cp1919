

Stem t1, t2, t3, t4, t5, t6;
PlayAll playAll;
//PlayPause 

void setup() {
  size(1280,768);
  float w = width / 6;
  float h = height / 2.5;
  float margin = w * 0.05;
  
  println("width: " + w + ", height: " + h + ", margin: " + margin);
  
  t1 = new Stem(this, "Kick.wav",  color( 44, 34,209, 240), 10, (int) (w - margin), (int) h, (int) (margin)  , (int) margin);
  t2 = new Stem(this, "Snare.wav", color(205, 38, 12, 240), 10, (int) (w - margin), (int) h, (int) (w + (margin))  , (int) margin);
  t3 = new Stem(this, "Hats.wav",  color( 63,174, 86, 240), 10, (int) (w - margin), (int) h, (int) (w*2 + (margin)), (int) margin);
  t4 = new Stem(this, "Blips.wav", color(235,141, 87, 240), 10, (int) (w - margin), (int) h, (int) (w*3 + (margin)), (int) margin);
  t5 = new Stem(this, "Bass.wav",  color(157,235,146, 240), 10, (int) (w - margin), (int) h, (int) (w*4 + (margin)), (int) margin);
  t6 = new Stem(this, "Lead.wav",  color(235,146,229, 240), 10, (int) (w - margin), (int) h, (int) (w*5 + (margin)), (int) margin);
  
  playAll = new PlayAll(this, "PLAY ALL",(int) margin,(int) height-80,(int) (width-margin*2), 70); 
  
}

void draw() {
  background(30, 30, 30);
  t1.draw();
  t2.draw();
  t3.draw();
  t4.draw();
  t5.draw();
  t6.draw();
  
  playAll.display();

}


public class PlayAll extends Toggle {
  public PlayAll(PApplet p, String nm, int x, int y, int w, int h) {
    super(p, nm, x, y, w, h);
  }
  
  public void mouseEvent(MouseEvent event) {
    if (isClicked()) {
    switch(event.getAction()){
      case MouseEvent.RELEASE:
        if (get()) {
          t1.stop();
          t2.stop();
          t3.stop();
          t4.stop();
          t5.stop();
          t6.stop();
        } else {
          t1.play();
          t2.play();
          t3.play();
          t4.play();
          t5.play();
          t6.play();
        }
        toggle();
        break;
    }
    }
  }
  
}


