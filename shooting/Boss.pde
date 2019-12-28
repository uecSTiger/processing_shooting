// ボスの座標
// ボスの攻撃方法
public class Boss{
  float boss_x, boss_y, boss_w;
  float move_x = 2;
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
    for (int i = 0; i <= 360; i+=10){
      float rad = radians(i);
      bullets.add(new Bullet(boss_x, boss_y, 15, cos(rad), sin(rad), red));
    }
  }
  
  // 遅く船を狙う大きい球
  void fire_slow() {
    PVector direct = new PVector(ship.ship_x - boss_x, ship.ship_y - boss_y);
    direct.normalize(direct);
    bullets.add(new Bullet(boss_x, boss_y, 70, direct.x*4, direct.y*4, yellow));
  }
  // 早く船を狙う小さい球
  void fire_fast() {
    PVector direct = new PVector(ship.ship_x - boss_x, ship.ship_y - boss_y);
    direct.normalize(direct);
    bullets.add(new Bullet(boss_x, boss_y, 10, direct.x * 10, direct.y * 10, green));
  }
  
  // 画面外の弾の削除
  void remove_bullets(){
    for (int i = bullets.size() -1; i >=0 ; i--) {
      Bullet bullet = (Bullet)bullets.get(i);  // ArrayList から Tamaをとりだし
      if (bullet.update() == false)            // update メソッドをよび
        bullets.remove(i);                     // 画面外と船に当たったら、削除
    }
  }
  
  
  void easyBoss(){
    if(frameCount % 60 == 0)              fire_slow();
    if(frameCount % 50 == 0 && hp <=  85) fire_fast();
  }
  
  void normalBoss(){
    if(frameCount %  60 == 0)                 fire_slow();
    if(frameCount %  50 == 0 && hp <=  122.5) fire_fast();
    if(frameCount % 130 == 0 && hp <=     85) boss.fire_360();
  }
  
  void hardBoss(){
    if(frameCount % 30 == 0)                boss.fire_360();
    if(frameCount % 40 == 0 && hp <= 122.5) fire_slow();
    if(frameCount % 20 == 0 && hp <=    85) fire_fast();
  }
 
  
  void move(){
    /*
    stroke(white);
    fill(0, 255 - hp, 0);
    rect(boss_x, boss_y, boss_w, 10);
    */
    pictures = loadImage(picture[1]+".png");
    image(pictures, boss_x-20, boss_y, 60, 40);
    
    // ボスの移動
    if(boss_x >= width || boss_x <= 0)
      move_x = -move_x;
    boss_x += move_x; 
    
    if(level >= 2){
      float move_xa = 3*cos(frameCount/18+10)-1*cos(frameCount/10+10);
      if((boss_x >= width && move_xa > 0) || (boss_x <= 0 && move_xa < 0)){
        boss_x -= move_xa;
      }else{
        boss_x += move_xa;
      }
    }
    
    if(level == 3){
      float move_y = 5*sin(frameCount/18+10)-3*sin(frameCount/10+10);
      if((boss_y >= height && move_y > 0) || (boss_y <= 0 && move_y < 0)){
        boss_y -= move_y;
      }else{
        boss_y += move_y;
      }
    }
    
    boss.remove_bullets();
    
    // 難易度による攻撃手段の変更
    if(level == 1){
      easyBoss();
    }else if(level == 2){
      normalBoss();
    }else if(level == 3){
      hardBoss();
    }
    
  }
  
  void hit(){
      hp -= 255 / BOSS_HP;
      score += 1500;
      if(hp <= 0){
        gameover = true;
        score += 10000;
      }
  }
}
