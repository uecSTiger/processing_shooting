// 1体の敵の座標、方向（早さ）を管理(生成)
// 敵の当たり判定
// easyとnormalの時はスコアが0以下にはならない
class makeChaiseEnemy{
  static final int ENEMY_size = 30;  // 敵の大きさ
  float x, y, dx, dy; // 敵の座標と方向
  color col; // 敵の色
  
  makeChaiseEnemy(float _x, float _y, float _dx, float _dy, color _col){
    x = _x;
    y = _y;
    dx = _dx;
    dy = _dy;
    col = _col; 
  }
  
  boolean update(){
    if(frameCount % 70 == 0){
      PVector direct = new PVector(ship.x - x, ship.y - y);
      direct.normalize(direct);
      if(direct.x >= 0.5){
        dx = (direct.x - 0.1) * 2;
      }else if(direct.x <= -0.5){
        dx = (direct.x + 0.1) * 2;
      }else{
        dx = direct.x*3;
      }
    }
    x += dx;
    y += dy;
    
    stroke(col);
    fill(col);
    rectMode(CENTER);
    rect(x, y, ENEMY_size, ENEMY_size);
     
    // area check
    if(x <= 0 || x >= width)
      dx = -dx;
    if(y <= 0 || y >= height)
      return false;
      
    // hit check
    // 船が敵に当たった
    if(dist(x, y, ship.x, ship.y) <= (ENEMY_size+ship.size)/2){
      ship.hit();
      return false;
    }
    
    // 攻撃が敵に当たった
    if(ship.bflag == true && (dist(x, y, ship.bx, ship.by) < ((ENEMY_size+SHIP_Bsize)/2))){
      score += 100;
      ship.bflag = false;
      
      return false;
    }
    
    return true;
  }
}
