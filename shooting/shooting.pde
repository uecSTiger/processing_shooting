Tama tama;
Boss boss;

// setup
void setup(){
     size(320, 320);
     frameRate(30);
     noCursor();  // clear mouse cursor
     
     boss = new Boss(160, 30);
}

// my ship function
void ship(int x, int y){
     stroke(255,255,255);
     noFill();
     triangle(x, y - 7, x - 10, y + 7, x + 10, y + 7);
     if (mousePressed){
       line(x, y- 7 , x, 0);
     }
}

// tama class
class Tama{
  float tx, ty, tr, dx, dy;
  Tama(float x, float y, float r, float cos, float sin){
    tx = x;
    ty = y;
    tr = r;
    dx = cos;
    dy = sin;
  }
  boolean update(){
       tx += dx;
       ty += dy;
       stroke(255, 0, 0);
       ellipse(tx, ty, tr, tr);  
       if (ty >= height || ty <= 0 || tx >= width || tx <= 0){
         return false;
       }else{
         return true;
       }
  }
}

class Boss{
  float bx, by;        // ボスの座標
  float bx_move= 2, by_move=2; // ボスの動く量 
  ArrayList danmaku;  // ボスが弾を吐くので、ここに移動
 
  Boss(float x, float y) {
    bx = x;
    by = y;  
    danmaku = new ArrayList();
  }
 
  void fire_360(){
    for (int i = danmaku.size() -1; i >=0 ; i--) {
      Tama t = (Tama)danmaku.get(i);  // ArrayList から Tamaをとりだし
      if (t.update() == false)   // update メソッドをよび
        danmaku.remove(i);   // 画面外だったら、削除
    }
    
    if(frameCount % 30 == 0){
      for (int i = 0; i <= 360; i+=10){
       float rad = radians(i);
       danmaku.add(new Tama(bx, by, 10, cos(rad), sin(rad)));
     }
    }
  }
  
  void move(){
    rect(bx, by, 15, 15);
    if(frameCount % 2 == 0){
      if(bx >= width || bx <= 0)
        bx_move= -bx_move;
       
      bx += bx_move;
    }
    boss.fire_360();
  }
}

void draw(){
     background(0); // clear
     ship(mouseX, mouseY);
     boss.move();
}
