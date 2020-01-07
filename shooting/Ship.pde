// 自機の船
// 船の攻撃
// ボスへの当たり判定
public class Ship{
  int x, y;             // 船の座標
  int bx, by;           // 攻撃の球の座標
  int size = width/20+height/20;
  boolean bflag = false;     // 攻撃しているかの判断
  float hp = 255;
  
  Ship(int _x, int _y){
    x = _x;
    y = _y;
  }
  
  // 座標の更新
  void update(float _x, float _y){
    // マウスカーソルでの移動の場合, 速度の問題でワープが起きる(解決するためマウスの方向へ割合移動)
    PVector direct = new PVector(_x-x, _y-y);
    
    x+=(int)direct.x/20;
    y+=(int)direct.y/20;
    
/*     
  // マウス位置での制御
  ship_x = x;
  ship_y = y;
  // キーボード移動の場合は移動と攻撃の発射(任意)の両立が難しい
  void update(){
    if (keyPressed) {
      if (keyCode == RIGHT) ship_x += 10;
      if (keyCode == LEFT)  ship_x -= 10;
      if (keyCode == UP)    ship_y -= 10;
      if (keyCode == DOWN)  ship_y += 10;
    }
*/
    if(x >= width) x = width;
    if(x <= 0) x = 0;
    if(y >= height) y = height;
    if(y <= 0) y = 0;

    // 攻撃タイミングの管理
    if(mousePressed){ 
      //line(x, y, x, 0);
      if(bflag == false){
        bflag = true;
        bx = x;
        by = y-20;
      }
    } 
    if(by <= 0)
      bflag = false;
    
    
    // 攻撃の作成
    if(bflag == true){
      stroke(255);
      fill(255);
      ellipse(bx, by, SHIP_Bsize, SHIP_Bsize);  // 攻撃する球(1発のみ)
      fill(255-(255*sin(frameCount))*0.3);
      ellipse(bx, by+12, SHIP_Bsize-2, SHIP_Bsize-2);
      fill(255-(255*sin(frameCount))*0.5);
      ellipse(bx, by+24, SHIP_Bsize-4, SHIP_Bsize-4);
      fill(255-(255*sin(frameCount))*0.7);
      ellipse(bx, by+37, SHIP_Bsize-6, SHIP_Bsize-6);      
      by -= 10; // 弾の速さ
      
      /* ボスに攻撃が当たったら */
      if(boss_pop == true && (dist(bx, by, boss.x, boss.y) < (SHIP_Bsize+60)/2)){
        boss.hit();
        println("boss hit");
        bflag = false;
      }
    }
    
    // 船の描画
    /*
    stroke(255);    
    fill(hp);
    triangle(ship_x, ship_y-13, ship_x-13, ship_y+18, ship_x+13, ship_y+18);
    */
    pictures = loadImage(picture[0]+".png");
    image(pictures, x-20, y-20, size, size);
    
    // HPゲージの描画
    if(hp >= 60) stroke(white);
    else stroke(red);
    noFill();
    rect(x, y+size, 25.5, height/100);
    if(hp >= 60) fill(white);
    else fill(red);
    rect(x, y+size, hp/10, height/100);
    
  }
  
  // 船のHP管理
  void hit(){
    hp -= 255/SHIP_HP;
    if(hp <= 0)
      gameover = true;
  }
}

