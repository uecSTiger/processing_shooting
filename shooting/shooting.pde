makeEnemy enemy;
Enemys administration;
Ship ship;
Bullet bullet;

final int SHIP_Bsize = 13; // 船の弾の大きさ
final int ENEMY_size = 20; // 敵の大きさ
final int SHIP_HP = 10;    // 船が耐えられる回数
int score = 0;
boolean gameover = false;

color red = #ff0000, green = #00ff00, blue = #0000ff;
color white = #ffffff, yellow = #ffff00;

PFont font;

void setup(){
   size(320, 640);
   frameRate(30);
   noCursor();
   
   ship = new Ship(160, 480);
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
    if(ship.ship_Gflag == true && (dist(enemy_x, enemy_y, ship.ship_bx, ship.ship_by) < ((ENEMY_size+SHIP_Bsize)/2))){ // distに
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
  float bullet_x, bullet_y;
  
  Bullet(int x, int y){
    bullet_x = x;
    bullet_y = y;
  }
  
  boolean update(){
    bullet_y -= 5;
    stroke(0, 255, 255);
    ellipse(bullet_x, bullet_y, 10, 10);
    
    // area check
    if(bullet_y <= 0)
      return false;
      
    // hit check
    for(int i= administration.enemys.size()-1; i>=0; i--){
      makeEnemy enemy = (makeEnemy)administration.enemys.get(i);
      if(dist(bullet_x, bullet_y, enemy.enemy_x, enemy.enemy_y) <= 10){
         println("bullet hit");
         return false;
      }
    }
    return true;
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
  if(gameover){
    background(0);
    textAlign(CENTER);
    textSize(50);
    fill(255 * sin(frameCount), 255, 255 * cos(frameCount));
    text("Score:"+score, width / 2, height / 2);
  }else{
    background(0);
    administration.make_enemy();
    ship.update(mouseX, mouseY);
    printData();  // 経過時間とスコア表示
  }
}  
