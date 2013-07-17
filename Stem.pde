// A stem is a one of the loops that we'll be playing

Maxim maxim;

public class Stem {
  PVector pos;
  PVector extent;
  int resolution;
  AudioPlayer player;
  ArrayList<ArrayList<Float>> specs;
  ArrayList<Float> powers;
  public PlayPause playPause;
  StopButton stopButton;
  MuteButton muteButton;
  VolumeSlider volume;
  Slider cutoff;
  Slider reso;
  String fileName;
  float[] spec;
  color bgcolor;
  float max_cutoff;
  float spacing;
  
  
  public Stem (PApplet p, String fileName, color bgcolor, int resolution, int w, int h, int x, int y) {
    maxim = new Maxim(p);
    this.resolution = resolution;
    player = maxim.loadFile(fileName);
    player.setAnalysing(true);
    player.volume(1);
    max_cutoff = 44100/4;
    spacing = height/resolution;
    // the gui
    playPause = new PlayPause(p, "playPause", x, y + h, w/2, w/2);
    stopButton = new StopButton(p, "stop", (int) (x + (w/2)), y + h, w/2, w/2);
    muteButton = new MuteButton(p, "MUTE", x, y + h + (int) (w/2), w, w/2);
    volume = new VolumeSlider(p, "VOL", 1, 0, 1, x, y + h + w, w, 50);
    cutoff = new Slider(p, "CUT", max_cutoff, 0, max_cutoff, x, y + h + w + 50, w, 50, 0);
    reso = new Slider(p, "RESO", 0.5, 0.1f, 1, x, y + h + w + 100, w, 50, 0);
    
    specs = new ArrayList<ArrayList<Float>>(resolution);
    powers = new ArrayList<Float>(resolution); 
    pos = new PVector(x, y);
    extent = new PVector(w, h);
    this.fileName = fileName;
    this.bgcolor = bgcolor;
  }
  
  void pause () {
    player.stop();
    playPause.set(false);
  }
    
  void play () {
    player.play();
    playPause.set(true);
  }
  
  void stop () {
    player.stop();
    player.cue(0);
    specs.clear();
    playPause.set(false);
  }
  
  void mute () {
    volume.set(0);
  }
  
  void unMute() {
    volume.set(1);
  }
  
  void applyFilters() {
    float c, r;
    c = cutoff.get();
    r = reso.get();
    player.setFilter(c, r);
  };
 
  void drawButtons() {
    playPause.display();
    stopButton.display();
    muteButton.display();
    volume.display();
    cutoff.display();
    reso.display();
  }
  
  void draw () {
    pushStyle();
    fill(51,51,51);
    stroke(255);
    rect(pos.x, pos.y, extent.x, extent.y);
    popStyle();
    
    applyFilters();
    
    if (player.isPlaying()) {
      spec = player.getPowerSpectrum();
      if (spec != null) {
        if (specs.size() == resolution) specs.remove(0);
      
        // we have to convert it to an array for some crazy strange reason
        ArrayList<Float> currentSpec = new ArrayList<Float>(spec.length);
        for(int i = 0; i < spec.length; i++) {
          currentSpec.add(spec[i]);
        }
         
        specs.add(currentSpec); 
      }
    }
    
    
    drawScanLines();
    drawPlayHead();
    // draw the controls;
    drawButtons();
    
    pushStyle();
    fill(bgcolor);
    stroke(255);
    rect(pos.x, pos.y, extent.x, 20);
    textAlign(CENTER, CENTER);
    fill(255);
    text(fileName, pos.x + 0.5*extent.x, pos.y + 10);
    popStyle();
  }
  
  void drawPlayHead() {
    
    float yPos = map(player.getCurrentTimeMs(), 0, player.getLengthMs(), pos.y + extent.y, pos.y + 20);
    pushStyle();
    strokeWeight(1.5);
    stroke(243,255,23);
    line(pos.x, yPos, pos.x + extent.x, yPos);
    popStyle();
  }
  
  void drawScanLines() {
    // paint the lines
    
    
    for (int current = specs.size() - 1; current >= 0 ; current--) {
      
      ArrayList<Float> thisSpec = specs.get(current);
      //float pow = powers.get(current);
      
           
      // calculate the baseline y position
      int yPos = (int) map(current, resolution, 0, pos.y + 40, pos.y + extent.y);
      
      pushStyle();

      stroke(255);
      fill(bgcolor);
      // begin drawing the spikes
      strokeWeight(0.5);
      beginShape();
      vertex(pos.x, yPos + (spacing/2));
      for (int i = 0; i < thisSpec.size(); i++) {
        int xPos = (int) map(i, 0, thisSpec.size(), pos.x, pos.x + extent.x);
        float yOffset = map(thisSpec.get(i), 0, 0.5, 0, spacing/2); 
        vertex(xPos, yPos - yOffset );
      }
      vertex(pos.x + extent.x, yPos + (spacing/2));
      endShape();

      popStyle();
      
    }
  
  }
  
  
  
  public class PlayPause extends Toggle {
 
    public PlayPause(PApplet p, String nm, int x, int y, int w, int h) {
      super(p, nm, x, y, w, h);
    }
  
    void display() {
      pushStyle();
      stroke(255);
      fill(bgColor);
      rect(pos.x, pos.y, extents.x, extents.y);
      
      if (player.isPlaying()) {
        // we are playing
        // draw the pause thing
        pushMatrix();
        pushStyle();
        stroke(255);
        noFill();
        translate((pos.x) + extents.x/2, (pos.y) + extents.y/2);
        line(-5, -10, -5, 10);
        line(5, -10, 5, 10);
        popStyle();
        popMatrix();
      } else {
        // we are paused
        // draw the play thing
        pushMatrix();
        pushStyle();
        strokeWeight(0.5);
        stroke(255);
        noFill();
        translate((pos.x) + extents.x/2, (pos.y) + extents.y/2);
        beginShape();
        vertex(-5, -10);
        vertex(10, 0);
        vertex(-5, 10);
        endShape(CLOSE);
        popStyle();
        popMatrix();
      }
      popStyle();
    }
    
    public void mouseEvent(MouseEvent event) {
      if (super.isClicked()) {
        switch(event.getAction()){
          case MouseEvent.RELEASE:
            if (player.isPlaying()) {
              pause();
            } else {
              play();
            }
            break;
        }
      }
    }
    
  }
  
  // The Stop Button of the stem,
  // stops and cues the audio
  public class StopButton extends Button {
    public StopButton(PApplet p, String nm, int x, int y, int w, int h) {
      super(p, nm, x, y, w, h);
    }
  
    void display() {
      pushStyle();
      stroke(255);
      fill(bgColor);
      rect(pos.x, pos.y, extents.x, extents.y);
     
      pushMatrix();
      pushStyle();
      strokeWeight(0.5);
      stroke(255);
      noFill();
      translate(pos.x + extents.x/2, pos.y + extents.y/2);
      rect(-10, -10, 20, 20);
      popStyle();
      popMatrix();
      
      popStyle();
    }
  
    public void mouseEvent(MouseEvent event) {
      if (super.isClicked()) {
        switch(event.getAction()){
          case MouseEvent.RELEASE:
            stop();
            break;
        }
        super.mouseEvent(event);
      }
    }
  }
  
  public class MuteButton extends Toggle {
    public MuteButton(PApplet p, String nm, int x, int y, int w, int h) {
      super(p, nm, x, y, w, h);
    }
    
    public void mouseEvent(MouseEvent event) {
      if (super.isClicked()) {
        switch(event.getAction()){
          case MouseEvent.RELEASE:
            if (get()) {
              unMute();
            } else {
              mute();
            }
            toggle();
            break;
        }
      }
    }
    
  
  }
  
  public class VolumeSlider extends Slider {
    public VolumeSlider(PApplet p, String nm, float v, float min, float max, int x, int y, int w, int h) {
      super(p, nm, v, min, max, x, y, w, h, 0);
    }
    
    void set(float v)
    {
      val = v;
      val = constrain(val, minimum, maximum);
      player.volume(val);
    }
    
  }
  

  
}
  
  
