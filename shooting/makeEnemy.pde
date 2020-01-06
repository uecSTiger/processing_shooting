// 1体の敵の座標、方向（早さ）を管理(生成)
// 敵の当たり判定
public class makeEnemy{
  float x, y, dx, dy; // 敵の座標と方向
  color col; // 敵の色
  
  makeEnemy(float _x, float _y, float _dx, float _dy, color _col){
    x = _x;
    y = _y;
    dx = _dx;
    dy = _dy;
    col = _col; 
  }
  
  boolean hitCheck(){
    // 船が敵に当たった
    if(dist(x, y, ship.ship_x, ship.ship_y) <= (ENEMY_size+ship.ship_size)/2){
      println("ship hit");
      ship.hit();
      score -= 200;
      if(score < 0 && level <= 2) score = 0;
      return false;
    }
    
    // 船の攻撃が敵に当たった
    if(ship.ship_Gflag == true && (dist(x, y, ship.ship_bx, ship.ship_by) < ((ENEMY_size+SHIP_Bsize)/2))){
      println("ship shoot");
      score += 100;
      ship.ship_Gflag = false;
      return false;
    }
    
    return true;
  }
  
  boolean update(){
    x += dx;
    y += dy;
    
    stroke(col);
    fill(col);
    ellipse(x, y, ENEMY_size, ENEMY_size);
    
    
    // area check
    if(x <= 0 || x >= width)
      dx = -dx;
    if(y <= 0 || y >= height)
      return false;
      
    // hit check
    return hitCheck();
   
  }
}
