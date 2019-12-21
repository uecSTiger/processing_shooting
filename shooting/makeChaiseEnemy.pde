// 1体の敵の座標、方向（早さ）を管理(生成)
// 敵の当たり判定
public class makeChaiseEnemy{
  float cenemy_x, cenemy_y, cdx, cdy; // 敵の座標と方向
  color col; // 敵の色
  
  makeChaiseEnemy(float x, float y, float Dx, float Dy, color Col){
    cenemy_x = x;
    cenemy_y = y;
    cdx = Dx;
    cdy = Dy;
    col = Col; 
  }
  
  boolean update(){
    if(frameCount % 70 == 0){
      PVector direct = new PVector(ship.ship_x - cenemy_x, ship.ship_y - cenemy_y);
      direct.normalize(direct);
      if(direct.x >= 0.5){
        cdx = (direct.x - 0.1) * 2;
      }else if(direct.x <= -0.5){
        cdx = (direct.x + 0.1) * 2;
      }else{
        cdx = direct.x*3;
      }
    }
    cenemy_x += cdx;
    cenemy_y += cdy;
    
    stroke(col);
    fill(col);
    ellipse(cenemy_x, cenemy_y, ENEMY_size, ENEMY_size);
     
    // area check
    if(cenemy_x <= 0 || cenemy_x >= width)
      cdx = -cdx;
    if(cenemy_y <= 0 || cenemy_y >= height)
      return false;
      
    // hit check
    // 船が敵に当たった
    if(dist(cenemy_x, cenemy_y, ship.ship_x, ship.ship_y) <= ENEMY_size){
      println("ship hit");
      ship.hit();
      return false;
    }
    
    // 攻撃が敵に当たった
    if(ship.ship_Gflag == true && (dist(cenemy_x, cenemy_y, ship.ship_bx, ship.ship_by) < ((ENEMY_size+SHIP_Bsize)/2))){
      println("ship shoot");
      score += 100;
      ship.ship_Gflag = false;
      
      return false;
    }
    
    return true;
  }
}
