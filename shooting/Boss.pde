// ボスの座標
// ボスの攻撃方法
public class Boss{
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
