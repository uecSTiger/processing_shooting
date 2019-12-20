// 敵の弾
public class Bullet{
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
