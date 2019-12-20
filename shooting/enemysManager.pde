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
    
    // 40フレームごとに敵生成
    if(frameCount % 40 == 0){
      float x = random(width); // 生成座標
      float y = 0;
      float dx = (int)random(5);  // 敵のx方向に進む速さ
      float dy = random(20)/4;    // 敵のy方向に進む速さ
      if(dy < 0.5) dy = 0.5;
      
      enemys.add(new makeEnemy(x, y, dx, dy, red));
    }
    
    // 100フレームごとに追跡する敵生成
    if(frameCount % 100 == 0){
      float x = random(width); // 生成座標
      float y = 0;
      float dx = (int)random(5);  // 敵のx方向に進む速さ
      float dy = random(20)/4;    // 敵のy方向に進む速さ
      if(dy < 1.5) dy = 2;
      
      cenemys.add(new makeChaiseEnemy(x, y, dx, dy, orange));
    }
    
    
    // 船の方に行く敵(早い)
    if(frameCount % 80 == 0){
      float x = random(width); // 生成座標
      float y = 0;
      PVector direct = new PVector(ship.ship_x - x, ship.ship_y);
      direct.normalize(direct);
      enemys.add(new makeEnemy(x, y, direct.x*4, direct.y*4, yellow));
    }
    
    // 横から出てくる
    if(frameCount % 40 == 0 && frameCount >= frameRate*30){
      float x = int(random(2))+1; // 生成座標
      if(x == 2) x = 0; else x = width;
      float y = random(height/2)+(height/4);
      PVector direct = new PVector(ship.ship_x - x, ship.ship_y - y);
      direct.normalize(direct);
      
      enemys.add(new makeEnemy(x, y, direct.x*6, direct.y*4, blue));
    }
    
    // 下から上へ船へ向かって進む
    if(frameCount % 130 == 0 && frameCount >= frameRate*50){
      float x = random(width); // 生成座標
      float y = height;
      PVector direct = new PVector(ship.ship_x - x, ship.ship_y - y);
      direct.normalize(direct);
      enemys.add(new makeEnemy(x, y, direct.x*15, direct.y*15, green));
    }
    
    //上から横一列で出てくる
    if(frameCount % 200 == 0 && frameCount >= frameRate*70){
      for(int i=0; i<=width; i+= ENEMY_size)
        enemys.add(new makeEnemy(i, 0, 0, 3, red));
    }
    
    // 放射状に出てくる
    if(frameCount % 200 == 100 && frameCount >= frameRate*70){
      float x = random(width); // 生成座標
      for (int i = 180; i >= 0; i-=10){
        float rad = radians(i);
        enemys.add(new makeEnemy(x, 0, cos(rad), sin(rad), red));
      }
    }
    
    // 連続して同じ方向に連結した敵
    if(frameCount % 200 == 0 || assosiation_flag > 0){
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
}


