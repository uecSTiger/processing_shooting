makeEnemy enemy;
Enemys administration;
Ship ship;
Bullet bullet;
Boss boss;

final int SHIP_Bsize = 13;  // 船の弾の大きさ
final int ENEMY_size = 20;  // 敵の大きさ
final int SHIP_HP = 10;     // 船が耐えられる回数
final int BOSS_HP = 20;     // ボスが耐えられる回数
int score = 0;
int step = 0; // 待ち時間調整(Boss 表示用)
boolean boss_pop = false;
boolean gameover = false;

color red = #ff0000, green = #00ff00, blue = #0000ff;
color white = #ffffff, yellow = #ffff00;

PFont font;

void setup(){
   size(320, 640);
   frameRate(30);
   noCursor();
   
   ship = new Ship(-100, 480);
   enemy = new makeEnemy(160, 0, -3, 5, red);
   administration = new Enemys();
   
/*********** フォントの設定  *************/
/* フォントをVLWフォーマットに変換・作成 */
   font = createFont("MS Mincho", 48);       // ＭＳ明朝 「MS Mincho」
   textFont(font);                           // フォントを指定する
/*****************************************/
}


// 複数の敵の座標方向を管理
class Enemys{
  ArrayList enemys;
  
  Enemys(){
    enemys = new ArrayList();
  }
  
  // 敵生成
  void make_enemy(){
    for(int i= enemys.size()-1; i >= 0; i--){
      makeEnemy enemy = (makeEnemy)enemys.get(i);
      if(enemy.update() == false)
        enemys.remove(i);
    }
    // 30フレームごとに敵生成
    if(frameCount % 40 == 0){
      float x = random(width); // 生成座標
      float y = 0;
      float dx = (int)random(5);  // 敵のx方向に進む速さ
      float dy = random(20)/4;    // 敵のy方向に進む速さ
      if(dy < 0.5) dy = 0.5;
      
      enemys.add(new makeEnemy(x, y, dx, dy, red));
    }
    
    // 連続して同じ方向に連結した敵
    
    // 船の方に行く敵(早い)
    if(frameCount % 80 == 0){
      float x = random(width); // 生成座標
      float y = 0;
      PVector direct = new PVector(ship.ship_x - x, ship.ship_y);
      direct.normalize(direct);
      enemys.add(new makeEnemy(x, y, direct.x*4, direct.y*4, yellow));
    }
    
    // 横から出てくる
    if(frameCount % 40 == 0 && frameCount >= frameRate*30){
      float x = int(random(2))+1; // 生成座標
      if(x == 2) x = 0; else x = width;
      float y = random(height/2)+(height/4);
      PVector direct = new PVector(ship.ship_x - x, ship.ship_y - y);
      direct.normalize(direct);
      
      enemys.add(new makeEnemy(x, y, direct.x*6, direct.y*4, blue));
    }
    
    // 下から上へ船へ向かって進む
    if(frameCount % 130 == 0 && frameCount >= frameRate*50){
      float x = random(width); // 生成座標
      float y = height;
      PVector direct = new PVector(ship.ship_x - x, ship.ship_y - y);
      direct.normalize(direct);
      enemys.add(new makeEnemy(x, y, direct.x*15, direct.y*15, green));
    }
    
    //上から横一列で出てくる
    if(frameCount % 200 == 0 && frameCount >= frameRate*70){
      for(int i=0; i<=width; i+= ENEMY_size)
        enemys.add(new makeEnemy(i, 0, 0, 3, red));
    }
    
    // 放射状に出てくる
    if(frameCount % 200 == 100 && frameCount >= frameRate*70){
      float x = random(width); // 生成座標
      for (int i = 180; i >= 0; i-=10){
        float rad = radians(i);
        enemys.add(new makeEnemy(x, 0, cos(rad), sin(rad), red));
      }
    }
  }
}

// 1体の敵の座標、方向（早さ）を管理(生成)
class makeEnemy{
  float enemy_x, enemy_y, dx, dy; // 敵の座標と方向
  color col; // 敵の色
  
  makeEnemy(float x, float y, float Dx, float Dy, color Col){
    enemy_x = x;
    enemy_y = y;
    dx = Dx;
    dy = Dy;
    col = Col; 
  }
  
  boolean update(){
    enemy_x += dx;
    enemy_y += dy;
    
    stroke(col);
    fill(col);
    ellipse(enemy_x, enemy_y, ENEMY_size, ENEMY_size);
     
    // area check
    if(enemy_x <= 0 || enemy_x >= width)
      dx = -dx;
    if(enemy_y <= 0 || enemy_y >= height)
      return false;
      
    // hit check
    // 船が敵に当たった
    if(dist(enemy_x, enemy_y, ship.ship_x, ship.ship_y) <= ENEMY_size/2){
      println("ship hit");
      ship.hit();
      return false;
    }
    
    // 攻撃が敵に当たった
    if(ship.ship_Gflag == true && (dist(enemy_x, enemy_y, ship.ship_bx, ship.ship_by) < ((ENEMY_size+SHIP_Bsize)/2))){
      println("ship shoot");
      score += 100;
      ship.ship_Gflag = false;
      
      return false;
    }
    
    return true;
  }
}

// 自機の船
class Ship{
  int ship_x, ship_y;             // 船の座標
  int ship_bx, ship_by;           // 攻撃の球の座標
  boolean ship_Gflag = false;     // 攻撃しているかの判断
  float hp = 255;
  
  Ship(int x, int y){
    ship_x = x;
    ship_y = y;
  }
  
  // 座標の更新
  void update(int x, int y){
    ship_x = x;
    ship_y = y;
    stroke(255);    
    fill(hp);
    triangle(x, y-7, x-10, y+7, x+10, y+7);
    
    // 攻撃タイミングの管理
    if(mousePressed){ 
      //line(x, y, x, 0);
      if(ship_Gflag == false){
        ship_Gflag = true;
        ship_bx = ship_x;
        ship_by = ship_y;
      }
    } 
    if(ship_by <= 0){
      ship_Gflag = false;
    }
    
    // 攻撃の作成
    if(ship_Gflag == true){
      fill(255);
      ellipse(ship_bx, ship_by, SHIP_Bsize, SHIP_Bsize);  // 攻撃する球(1発のみ)
      ship_by -= 10; // 弾の速さ
      
      // ボスに攻撃が当たったら
      if(boss_pop == true && (dist(ship_bx, ship_by, boss.boss_x, boss.boss_y) < (SHIP_Bsize+15)/2)){
        boss.hit();
        println("boss hit");
        ship_Gflag = false;
      }
    }
  }
  
  void hit(){
    hp -= 255/SHIP_HP;
    if(hp <= 0)
      gameover = true;
  }
}

// 敵の弾
class Bullet{
  float bullet_x, bullet_y, bullet_r, dx, dy; // ボスの弾の座標と大きさと方向
  color col;
  
  Bullet(float x, float y, float r, float Dx, float Dy, color Col){
    bullet_x = x;
    bullet_y = y;
    bullet_r = r;
    dx = Dx;
    dy = Dy;
    col = Col;
  }
  
  boolean update(){
    bullet_x += dx;
    bullet_y += dy;
    stroke(col);
    fill(col);
    ellipse(bullet_x, bullet_y, bullet_r, bullet_r);
    
    // area check
    if(bullet_y <= 0)
      return false;
      
    // area check
    if (bullet_y >= height || bullet_y <= 0 || bullet_x >= width || bullet_x <= 0)
       return false;
    // hit check
    if(dist(bullet_x, bullet_y, ship.ship_x, ship.ship_y) <= (bullet_r/2 + 2)){
       println("ship hit");
       ship.hit();
       return false;
    }
       return true;
  }
}

class Boss{
  float boss_x, boss_y, boss_w;
  float move = 2;
  float hp = 255;
  ArrayList bullets;
  
  Boss(float x, float y, float w){
    boss_x = x;
    boss_y = y;
    boss_w = w;
    bullets = new ArrayList();
  }
  
  // ボスから360°円形放射
  void fire_360(){
    for (int i = bullets.size() -1; i >=0 ; i--) {
      Bullet bullet = (Bullet)bullets.get(i);  // ArrayList から Tamaをとりだし
      if (bullet.update() == false)        // update メソッドをよび
        bullets.remove(i);            // 画面外と船に当たったら、削除
    }
    
    if(frameCount % 30 == 0){
      for (int i = 0; i <= 360; i+=10){
        float rad = radians(i);
        bullets.add(new Bullet(boss_x, boss_y, 15, cos(rad), sin(rad), red));
      }
    }
  }
  
  // 遅く船を狙う大きい球
  void fire_slow() {
    if(frameCount % 40 == 0){
      PVector direct = new PVector(ship.ship_x - boss_x, ship.ship_y - boss_y);
      direct.normalize(direct);
      bullets.add(new Bullet(boss_x, boss_y, 70, direct.x*4, direct.y*4, yellow));
    }
  }
  // 早く船を狙う小さい球
  void fire_fast() {
   if(frameCount % 20 == 0){
      PVector direct = new PVector(ship.ship_x - boss_x, ship.ship_y - boss_y);
      direct.normalize(direct);
      bullets.add(new Bullet(boss_x, boss_y, 10, direct.x * 10, direct.y * 10, green));
    }
  }
  
  void move(){
    stroke(white);
    fill(0, 255 - hp, 0);
    rect(boss_x, boss_y, boss_w, 10);
    if(boss_x >= width || boss_x <= 0)
      move= -move;
       
    boss_x += move; 
    boss.fire_360();
    if(hp <= 122.5)
      fire_slow();
    if(hp <= 85)
      fire_fast();
  }
  
  void hit(){
      hp -= 255 / BOSS_HP;
      score += 1500;
      if(hp <= 0)
        gameover = true;
  }
}
    
// スコアと経過時間の表示
void printData() {
  float ft = (float)millis() / 1000;
  fill(white);
  textSize(30);
  textAlign(RIGHT);
  text(nf(ft, 1, 2), width, 24);
  
  textAlign(LEFT);
  text("score:"+score, 0, 24);
}


void draw(){
  if(gameover || frameCount >= frameRate*300){
    background(0);
    textAlign(CENTER);
    textSize(50);
    if(ship.hp <= 0){
      fill(blue);
      text("YOU LOSE", width/2, height/2);
    }else{
      score += 10000;
      fill(255 * sin(frameCount), 255, 255 * cos(frameCount));
      text("YOU WIN", width/2, height/2);
    }
    text("Score:"+score, width/2, height/2+70);
    
  }else{
    background(0);
    
    if(frameCount <= frameRate*150){
      administration.make_enemy();
    }else{
      if(boss_pop == false){
        background(0);
        for(int i= administration.enemys.size()-1; i >= 0; i--){
          makeEnemy enemy = (makeEnemy)administration.enemys.get(i);
          administration.enemys.remove(i);
        }
        step = frameCount;
        
        boss = new Boss(160, 30, 15);
        boss_pop = true;
      }
      if(step >= frameCount-45){
        textSize(130);
        fill(red);
        textAlign(CENTER);
        text("Boss", width/2, height/2);
      }    
    
      boss.move();
      
    }
    ship.update(mouseX, mouseY);
    printData();  // 経過時間とスコア表示
  }
}  
