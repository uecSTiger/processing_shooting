// メインのコード(setup, draw, グローバル変数)
makeEnemy enemy;
Enemys maneger;
Ship ship;
Bullet bullet;
Boss boss;

final int SHIP_Bsize = 10;  // 船の弾の大きさ
final int ENEMY_size = 20;  // 敵の大きさ
final int SHIP_HP = 10;     // 船が耐えられる回数
final int BOSS_HP = 20;     // ボスが耐えられる回数
int score = 0;
int step = 0; // 待ち時間調整(Boss 画面表示用)
boolean boss_pop = false;
boolean gameover = false;

color red = #ff0000, green = #00ff00, blue = #0000ff;
color white = #ffffff, yellow = #ffff00, orange = #ffa500;
color purple = #800080;

PFont font;

void setup(){
   size(320, 640);
   frameRate(30);
   noCursor();
     
   ship = new Ship(-100, 480);
   enemy = new makeEnemy(160, 0, -3, 5, red);
   maneger = new Enemys();
   
/*********** フォントの設定  *************/
/* フォントをVLWフォーマットに変換・作成 */
   font = createFont("MS Mincho", 48);    // ＭＳ明朝 「MS Mincho」
   textFont(font);                        // フォントを指定する
/*****************************************/

}
    
// スコアと経過時間の表示
void printData() {
  float ft = (float)millis() / 1000;
  fill(white);
  textSize(30);
  textAlign(RIGHT);
  text(nf(ft, 1, 2), width, 24);
  
  textAlign(LEFT);
  text("score:"+score, 0, 24);
}


void draw(){
  if(gameover || frameCount >= frameRate*300){
    background(0);
    textAlign(CENTER);
    textSize(50);
    if(ship.hp <= 0){
      fill(blue);
      text("YOU LOSE", width/2, height/2);
    }else{
      score += 10000;
      fill(255 * sin(frameCount), 255, 255 * cos(frameCount));
      text("YOU WIN", width/2, height/2);
    }
    text("Score:"+score, width/2, height/2+70);
    
  }else{
    background(0);
    
    if(frameCount <= frameRate*130){
      maneger.make_enemy();
      
    }else{
      if(boss_pop == false){
        background(0);
        for(int i= maneger.enemys.size()-1; i >= 0; i--){
          makeEnemy enemy = (makeEnemy)maneger.enemys.get(i);
          maneger.enemys.remove(i);
        }
        step = frameCount;
        
        boss = new Boss(160, 30, 15);
        boss_pop = true;
      }
      if(step >= frameCount-45){
        textSize(130);
        fill(red);
        textAlign(CENTER);
        text("Boss", width/2, height/2);
      }    
    
      boss.move();
      
    }
    
    // 船の座標位置   
    ship.update(mouseX, mouseY);
    printData();  // 経過時間とスコア表示
  }
}  
