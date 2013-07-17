final int HORIZONTAL = 0;
final int VERTICAL   = 1;
final int UPWARDS    = 2;
final int DOWNWARDS  = 3;


public class Widget {
 
  PVector pos;
  PVector extents;
  String name;
  
  color inactiveColor = color(20);
  color activeColor = color(100);
  color bgColor = inactiveColor;
  color lineColor = color(200);
//  PApplet app;
  
  public Widget(PApplet p, String name, int x, int y, int w, int h) {
//    this.app = p;
    pos = new PVector(x, y);
    extents = new PVector(w, h);
    this.name = name;
    p.registerMethod("mouseEvent", this);
  }
  
  // OVERRIDE ME
  void display() {
  }
  
  void setInactiveColor(color c)
  {
    inactiveColor = c;
    bgColor = inactiveColor;
  }
  
  color getInactiveColor()
  {
    return inactiveColor;
  }
  
  void setActiveColor(color c)
  {
    activeColor = c;
  }
  
  color getActiveColor()
  {
    return activeColor;
  }
  
  void setLineColor(color c)
  {
    lineColor = c;
  }
  
  color getLineColor()
  {
    return lineColor;
  }
  
  boolean isClicked() {
    if (mouseX > pos.x && mouseX < pos.x+extents.x 
      && mouseY > pos.y && mouseY < pos.y+extents.y) {
      return true;
    } else {
      return false;
    }
  }
  
  String getName() {
    return name;
  }
  
  void setName(String name) {
    this.name = name;
  }
   
   
  public void mouseEvent(MouseEvent event) {
    //if (event.getFlavor() == MouseEvent.PRESS)
    //{
    //  mousePressed();
    //}
  }
  
  boolean mousePressed() {
    return isClicked();
  }
  
  boolean mouseDragged() {
    return isClicked();
  }
  
  boolean mouseReleased() {
    return isClicked();
  }
  
}


public class Button extends Widget {

  public Button(PApplet p, String nm, int x, int y, int w, int h) {
    super(p, nm, x, y, w, h);
  }
  
  void display() {
    pushStyle();
    stroke(lineColor);
    fill(bgColor);
    rect(pos.x, pos.y, extents.x, extents.y);

    fill(lineColor);
    textAlign(CENTER, CENTER);
    text(name, pos.x + 0.5*extents.x, pos.y + 0.5* extents.y);
    popStyle();
  }


  public void mouseEvent(MouseEvent event) {
    switch(event.getAction()){
      case MouseEvent.PRESS: 
        bgColor = activeColor;
        break;
      case MouseEvent.RELEASE:
        bgColor = inactiveColor;
        break;
    }
  }
    
}

public class Toggle extends Button
{
  boolean on = false;

  public Toggle(PApplet p, String nm, int x, int y, int w, int h) {
    super(p, nm, x, y, w, h);
  }


  boolean get() {
    return on;
  }

  void set(boolean val) {
    on = val;
    if (on)
    {
      bgColor = activeColor;
    }
    else
    {
      bgColor = inactiveColor;
    }
  }

  void toggle(){
    set(!on);
  }

  public void mouseEvent(MouseEvent event) {
    switch(event.getAction()){
      case MouseEvent.RELEASE:
        toggle();
        break;
    }
  }

  
  boolean mousePressed()
  {
    return super.isClicked();
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      toggle();
    }
    return false;
  }
}


public class Slider extends Widget
{
  float minimum;
  float maximum;
  float val;
  int textWidth = 60;
  int orientation = HORIZONTAL;
  color bgColor = color( 44, 150,209, 140);

  public Slider(PApplet p, String nm, float v, float min, float max, int x, int y, int w, int h, int ori)
  {
    super(p, nm, x, y, w, h);
    val = v;
    minimum = min;
    maximum = max;
    orientation = ori;
    if(orientation == HORIZONTAL)
      textWidth = 0;
    else
      textWidth = 0;
  }

  float get()
  {
    return val;
  }

  void set(float v)
  {
    val = v;
    val = constrain(val, minimum, maximum);
  }

  void display()
  {
    pushStyle();
    stroke(lineColor);
    noFill();
    if(orientation ==  HORIZONTAL){
      rect(pos.x+textWidth, pos.y, extents.x-textWidth, extents.y);
    } else {
      rect(pos.x, pos.y+textWidth, extents.x, extents.y-textWidth);
    }
    noStroke();
    fill(bgColor);
    float sliderPos; 
    if(orientation ==  HORIZONTAL){
        sliderPos = map(val, minimum, maximum, 0, extents.x-textWidth-4); 
        rect(pos.x+textWidth+2, pos.y+2, sliderPos, extents.y-4);
    } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textWidth-4); 
        rect(pos.x+2, pos.y+textWidth+2, extents.x-4, sliderPos);
    } else if(orientation == UPWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textWidth-4); 
        rect(pos.x+2, pos.y+textWidth+2 + (extents.y-textWidth-4-sliderPos), extents.x-4, sliderPos);
    };
    pushStyle();
    textAlign(LEFT, TOP);
    fill(lineColor);
    text(name, pos.x + 5, pos.y + 2);
    popStyle();
    popStyle();
  }

  public void mouseEvent(MouseEvent event) {
    
    int x = event.getX();
    int y = event.getY();
    
    if (isClicked()) {
      switch(event.getAction()){
        case MouseEvent.DRAG:
          if(orientation == HORIZONTAL){
            set(map(x, pos.x+textWidth, pos.x+extents.x-4, minimum, maximum));
          } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
            set(map(y, pos.y+textWidth, pos.y+extents.y-4, minimum, maximum));
          } else if(orientation == UPWARDS){
            set(map(x, pos.y+textWidth, pos.y+extents.y-4, maximum, minimum));
          };
          break;
        case MouseEvent.RELEASE:
          if(orientation ==  HORIZONTAL){
            set(map(mouseX, pos.x+textWidth, pos.x+extents.x-10, minimum, maximum));
          } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
            set(map(mouseY, pos.y+textWidth, pos.y+extents.y-10, minimum, maximum));
          } else if(orientation == UPWARDS){
            set(map(mouseY, pos.y+textWidth, pos.y+extents.y-10, maximum, minimum));
          };
          break;
      }
    }
  }
  
}


