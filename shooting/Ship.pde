// 自機の船
// 船の攻撃
// ボスへの当たり判定
public class Ship{
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
    
    // 攻撃タイミングの管理
    if(mousePressed){ 
      //line(x, y, x, 0);
      if(ship_Gflag == false){
        ship_Gflag = true;
        ship_bx = ship_x;
        ship_by = ship_y-20;
      }
    } 
    if(ship_by <= 0){
      ship_Gflag = false;
    }
    
    // 攻撃の作成
    if(ship_Gflag == true){
      stroke(255);
      fill(255);
      ellipse(ship_bx, ship_by, SHIP_Bsize, SHIP_Bsize);  // 攻撃する球(1発のみ)  後ろに大きさとかを変えて作ると流れるように見える
      fill(255-(255*sin(frameCount))*0.3);
      ellipse(ship_bx, ship_by+12, SHIP_Bsize-2, SHIP_Bsize-2);
      fill(255-(255*sin(frameCount))*0.5);
      ellipse(ship_bx, ship_by+24, SHIP_Bsize-4, SHIP_Bsize-4);
      fill(255-(255*sin(frameCount))*0.7);
      ellipse(ship_bx, ship_by+37, SHIP_Bsize-6, SHIP_Bsize-6);      
      ship_by -= 10; // 弾の速さ
      
      // ボスに攻撃が当たったら
      if(boss_pop == true && (dist(ship_bx, ship_by, boss.boss_x, boss.boss_y) < (SHIP_Bsize+15)/2)){
        boss.hit();
        println("boss hit");
        ship_Gflag = false;
      }
    }
    
    // 船の描画
    stroke(255);    
    fill(hp);
    triangle(x, y-13, x-13, y+18, x+13, y+18);
  }
  
  void hit(){
    hp -= 255/SHIP_HP;
    if(hp <= 0)
      gameover = true;
  }
}

