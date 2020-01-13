// 敵の弾
class Bullet{
  private float x, y, r, dx, dy; // ボスの弾の座標と大きさと方向
  private color col;
  
  Bullet(float _x, float _y, float _r, float _dx, float _dy, color _col){
    x = _x;
    y = _y;
    r = _r;
    dx = _dx;
    dy = _dy;
    col = _col;
  }
  
  // 弾の位置の更新(画面外の弾(false)はリストから削除)
  boolean update(){
    x += dx;
    y += dy;
    stroke(col);
    fill(col);
    ellipse(x, y, r, r);
    
    // 弾の範囲
    if(y <= 0)
      return false;
      
    // 出現範囲の判定
    if (y >= height || y <= 0 || x >= width || x <= 0)
       return false;
    // あたり判定
    if(dist(x, y, ship.x, ship.y) <= (r/2 + 2)){
       ship.hit();
       score -= 300;
       if(score < 0 && level <= 2) score = 0;
       return false;
    }
       return true;
  }
}
