Tama tama;
Boss boss;
Ship ship;
PFont font;

color red = #ff0000, green = #00ff00, blue = #0000ff;
color white = #ffffff, yellow = #ffff00;
boolean gameover = false; // 勝ち負けフラグ

// setup
void setup(){
     size(320, 320);
     frameRate(30);
     noCursor();  // clear mouse cursor
     
     boss = new Boss(160, 30, 15);
     ship = new Ship(160, 160);
     
     /********* フォントの設定  ************/
     // フォントをVLWフォーマットに変換・作成
     font = createFont("MS Mincho", 48);        // ＭＳ明朝 「MS Mincho」
     textFont(font);                            // フォントを指定する
     /**************************************/
}

// my ship function
class Ship{
  int sx, sy;     // 船の場所
  int hp = 255;   // 船のHP
  
  Ship(int x, int y){
     sx = x;
     sy = y;
  }
  
  void updata(int x, int y){
     sx = x;
     sy = y;
     stroke(white);
     fill(255 - hp, 0, 0);
     triangle(x, y - 7, x - 10, y + 7, x + 10, y + 7);
 
    if (mousePressed) {
      line(x, y, x, 0);
      if (abs(sx - boss.bx) < (boss.bw / 2)) // レーザーとボスとの当たり判定
        boss.hit();
    }
  }
  
  void hit(){
    hp -= 5;
    if(hp <= 0)
      gameover = true;
  }
}

// tama class
class Tama{
  float tx, ty, tr, dx, dy; // 球の座標と方向
  color col; // 球の色
  
  Tama(float x, float y, float r, float Dx, float Dy, color Col){
    tx = x;
    ty = y;
    tr = r;
    dx = Dx;
    dy = Dy;
    col = Col;
  }
  
  boolean update(){
       tx += dx;
       ty += dy;
       stroke(col);
       noFill();
       ellipse(tx, ty, tr, tr); 
      
      // area check
       if (ty >= height || ty <= 0 || tx >= width || tx <= 0)
         return false;
       // hit check
       if(dist(tx, ty, ship.sx, ship.sy) <= tr/2 + 2){
         println("ship hit");
         ship.hit();
         return false;
  }
       return true;
  }
}

class Boss{
  float bx, by;        // ボスの座標
  float bw;            // ボスの幅
  float hp = 255;      // ボスのHP
  float bx_move= 2;    // ボスの動く量 
  ArrayList danmaku;   // ボスが吐く球の配列
 
  Boss(float x, float y, float w) {
    bx = x;
    by = y;
    bw = w;
    danmaku = new ArrayList();
  }
 
 // ボスから360°円形放射
  void fire_360(){
    for (int i = danmaku.size() -1; i >=0 ; i--) {
      Tama t = (Tama)danmaku.get(i);  // ArrayList から Tamaをとりだし
      if (t.update() == false)        // update メソッドをよび
        danmaku.remove(i);            // 画面外と船に当たったら、削除
    }
    
    if(frameCount % 30 == 0){
      for (int i = 0; i <= 360; i+=10){
       float rad = radians(i);
       danmaku.add(new Tama(bx, by, 15, cos(rad), sin(rad), red));
     }
    }
  }
  
  // 遅くf船を狙う大きい球
  void fire_slow() {
    if(frameCount % 40 == 0){
      PVector direct = new PVector(ship.sx - bx, ship.sy - by);
      direct.normalize(direct);
      danmaku.add(new Tama(bx, by, 70, direct.x*4, direct.y*4, yellow));
    }
  }
  // 早く船を狙う小さい球
  void fire_fast() {
   if(frameCount % 20 == 0){
      PVector direct = new PVector(ship.sx - bx, ship.sy - by);
      direct.normalize(direct);
      danmaku.add(new Tama(bx, by, 10, direct.x * 10, direct.y * 10, green));
    }
  }
  
  void move(){
    stroke(white);
    fill(0, 255 - hp, 0);
    rect(bx, by, bw, 10);
    if(bx >= width || bx <= 0)
      bx_move= -bx_move;
       
    bx += bx_move; 
    boss.fire_360();
    if(hp <= 122.5)
      fire_slow();
    if(hp <= 85)
      fire_fast();
  }
  
  void hit(){
      hp -= 0.5;
      if(hp <= 0)
        gameover = true;
  }
}

// print time
void print_time() {
  float ft = (float)millis() / 1000;
 
  fill(white);
  textSize(30);
  textAlign(RIGHT);
  text(nf(ft, 1, 2), width, 24);
}

void draw(){  
     if(gameover){  // game over
        textAlign(CENTER);
        textSize(70);
        if(ship.hp <= 0){
          fill(blue);
        text("YOU LOSE", width / 2, height / 2);
        } else {
          fill(255 * sin(frameCount), 255, 255 * cos(frameCount));
          text("YOU WIN", width / 2, height / 2);
        }
     }else{
       background(0); // clear
       print_time();  // 経過時間表示
       ship.updata(mouseX, mouseY);
       boss.move();
     }
}
