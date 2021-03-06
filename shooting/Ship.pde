// 自機の船
// 船の攻撃
// ボスへの当たり判定
class Ship{
  private static final int SHIP_HP = 10;     // 船が耐えられる回数
  public int x, y;                           // 船の座標
  public int bx, by;                         // 攻撃の球の座標
  private final int size = width/20+height/20;
  boolean bflag = false;                     // 攻撃しているかの判断
  private float hp = 255;
  private PImage picture;
  
  Ship(int _x, int _y){
    x = _x;
    y = _y;
  }
  
  void hpBar(){
    // HPゲージの描画
    rectMode(CORNER);
    if(hp >= 60) stroke(white);
    else stroke(red);
    noFill();
    rect(x, y+size, 25.5, height/100);
    if(hp >= 60) fill(white);
    else fill(red);
    rect(x, y+size, hp/10, height/100);
  }
  
  void shoot(){
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
  }
  
  void hitCheck(){
    /* ボスに攻撃が当たったら */
    if(scene.boss_pop == true && (dist(bx, by, boss.x, boss.y) < (SHIP_Bsize+60)/2)){
      boss.hit();
      bflag = false;
    }
    
    if(by <= 0)
      bflag = false;
      
  }
  
  // 座標の更新
  void update(float _x, float _y){
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
        shoot.trigger();
        bx = x;
        by = y-20;
      }
    } 
    
    // 攻撃の作成と当たり判定
    if(bflag == true){
      shoot();     
      hitCheck();
    }
    // 船の描画
    picture = loadImage("spaceShip_400x234.png");
    image(picture, x-20, y-20, size, size);
    hpBar();
    
  }
  
  // 船のHP管理
  void hit(){
    hp -= 255/SHIP_HP;
    if(hp <= 0)
      gameover = true;
  }
}

