// 1体の敵の座標、方向（早さ）を管理(生成)
// 敵の当たり判定
public class makeEnemy{
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
    if(dist(enemy_x, enemy_y, ship.ship_x, ship.ship_y) <= ENEMY_size){
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
