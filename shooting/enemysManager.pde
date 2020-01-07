// 複数の敵の座標方向を管理
// 敵の出現方法の管理
public class Enemys{
  ArrayList enemys;
  ArrayList cenemys;
  int assosiation_flag = 0;
  
  Enemys(){
    enemys = new ArrayList();
    cenemys = new ArrayList();
  }
  
  // ランダムに出現する敵の作成
  void baseEnemy(int cnt){  
      float x = random(width); // 生成座標
      float y = 0;
      float dx = (int)random(5);  // 敵のx方向に進む速さ
      float dy = random(20)/4;    // 敵のy方向に進む速さ
      if(dy < 0.5) dy = 0.5;
      
      enemys.add(new makeEnemy(x, y, dx, dy, red));
  }
  
  // 一定時間ごとに敵の方向に向き(x_axis)を変更する敵を作成
  void baseCEnemy(int cnt){
      float x = random(width); // 生成座標
      float y = 0;
      float dx = (int)random(5);  // 敵のx方向に進む速さ
      float dy = random(20)/4;    // 敵のy方向に進む速さ
      if(dy < 1.5) dy = 2;
      
      cenemys.add(new makeChaiseEnemy(x, y, dx, dy, green));
  }
  
  // 船の方に行く敵(早い)
  void rapidEnemy(int cnt){
      float x = random(width); // 生成座標
      float y = 0;
      PVector direct = new PVector(ship.x - x, ship.y);
      direct.normalize(direct);
      enemys.add(new makeEnemy(x, y, direct.x*4, direct.y*4, yellow));
  } 
  
  // 横から出てくる
  void sideEnemy(int cnt){
      float x = int(random(2))+1; // 生成座標
      if(x == 2) x = 0; else x = width;
      float y = random(height/2)+(height/4);
      PVector direct = new PVector(ship.x - x, ship.y - y);
      direct.normalize(direct);
      
      enemys.add(new makeEnemy(x, y, direct.x*6, direct.y*4, orange));
  }
  
  // 下から上へ船へ向かって進む
  void belowEnemy(int cnt){
      float x = random(width); // 生成座標
      float y = height;
      PVector direct = new PVector(ship.x - x, ship.y - y);
      direct.normalize(direct);
      enemys.add(new makeEnemy(x, y, direct.x*15, direct.y*15, blue));
  }
  
  //上から横一列で出てくる
  void rowEnemy(int cnt){
    for(int i=0; i<=width; i+= ENEMY_size)
      enemys.add(new makeEnemy(i, 0, 0, 3, red));
  }
 
 // 放射状に出てくる   
 void radialEnemy(int cnt){
      float x = random(width); // 生成座標
      for (int i = 180; i >= 0; i-=10){
        float rad = radians(i);
        enemys.add(new makeEnemy(x, 0, cos(rad), sin(rad), red));
      }
 }
 // 連続して同じ方向に連結した敵
 void connectedEnemy(int cnt){
    if(cnt % 200 == 0 || assosiation_flag > 0){
      float x = 160; // 生成座標
      float y = 0;
      if(assosiation_flag < 5){
        cenemys.add(new makeChaiseEnemy(x, y+assosiation_flag*30, 0, 5, purple));
        assosiation_flag++;
      }else{
        assosiation_flag = 0;
      }
    }
 }
 
 void checkEnemy(int cnt){
    if(cnt % 100 == 0){
      float x = width/2; // 生成座標
      float y = height/2;
      enemys.add(new makeEnemy(x, y, 0, 0, red));
    }
 }
 
 
 void easyEnemy(){
    int cnt =frameCount-scene.frame_cnt; // 各ゲームごとのフレームの経過
   
    if(cnt %  50 == 0)                        baseEnemy(cnt); 
    if(cnt % 120 == 0)                        rapidEnemy(cnt); 
    if(cnt % 350 == 0 && cnt >= frameRate*45) radialEnemy(cnt); 
    //if(cnt % 150 == 0 && cnt >= frameRate*40) sideEnemy(cnt);    
 }
 
 void normalEnemy(){
    int cnt =frameCount-scene.frame_cnt; // 各ゲームごとのフレームの経過
    
    if(cnt %  30 == 0)                        baseEnemy(cnt); 
    if(cnt %  60 == 0)                        rapidEnemy(cnt); 
    if(cnt %  80 == 0 && cnt >= frameRate*20) baseCEnemy(cnt);
    if(cnt %  90 == 0 && cnt >= frameRate*45) sideEnemy(cnt);
    if(cnt % 250 == 0 && cnt >= frameRate*60) radialEnemy(cnt);
    if(cnt % 110 == 0 && cnt >= frameRate*70) belowEnemy(cnt);
 }
 
 void hardEnemy(){
    int cnt =frameCount-scene.frame_cnt; // 各ゲームごとのフレームの経過

    if(cnt %  40 ==   0)                        baseEnemy(cnt);  
    if(cnt % 100 ==   0)                        baseCEnemy(cnt);
    if(cnt %  80 ==   0)                        rapidEnemy(cnt); 
    if(cnt %  40 ==   0 && cnt >= frameRate*30) sideEnemy(cnt);
    if(cnt %  40 ==   0 && cnt >= frameRate*40) belowEnemy(cnt);
    if(cnt % 130 ==   0 && cnt >= frameRate*50) rowEnemy(cnt); 
    if(cnt % 200 ==   0 && cnt >= frameRate*70) radialEnemy(cnt); 
    if(cnt % 200 == 100 && cnt >= frameRate*70) connectedEnemy(cnt); 
 }
 
 void check(){
    int cnt =frameCount-scene.frame_cnt; // 各ゲームごとのフレームの経過
    
    if(cnt %  40 == 0) checkEnemy(cnt);
    if(cnt >= frameRate*45){
      level = 0;
      scene.game_init();
    }
 }
   
  
  // 敵生成
  void make_enemy(){ 
    for(int i= enemys.size()-1; i >= 0; i--){
      makeEnemy enemy = (makeEnemy)enemys.get(i);
      if(enemy.update() == false)
        enemys.remove(i);
    }
    
    for(int i= cenemys.size()-1; i >= 0; i--){
      makeChaiseEnemy cenemy = (makeChaiseEnemy)cenemys.get(i);
      if(cenemy.update() == false)
        cenemys.remove(i);
    }
   
   if(level == 1){
     easyEnemy();
   }else if(level == 2){
     normalEnemy();
   }else if(level == 3){
     hardEnemy();
   }else{
     check();
   }
   
  }
}


