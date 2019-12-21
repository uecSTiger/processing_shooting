// メインのコード(setup, draw, グローバル変数)

/****************************************
敵の画像化
出現方法の調整
画面サイズの調整による影響の軽減
****************************************/

makeEnemy enemy;
Enemys maneger;
Ship ship;
Bullet bullet;
Boss boss;
Scene scene;

final int SHIP_Bsize = 10;  // 船の弾の大きさ
final int ENEMY_size = 20;  // 敵の大きさ
final int SHIP_HP = 10;     // 船が耐えられる回数
final int BOSS_HP = 20;     // ボスが耐えられる回数
int score = 0;              // スコア
int step = 0;               // "Boss"画面表示時間
int level = 0;              // 難易度
float start_time = 0;       // ゲームの経過時間
boolean boss_pop = false;   // ボスの出現状態
boolean gameover = false;   //ゲームの終わり

/* 色 */
color red = #ff0000, green = #00ff00, blue = #0000ff;
color white = #ffffff, yellow = #ffff00, orange = #ffa500;
color purple = #800080;

PFont font;

void setup(){
   size(320, 640);
   frameRate(30);
   noCursor();
    
   scene = new Scene(); 
   ship = new Ship(160, 480);
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
  float time = (float)millis()/1000 - start_time;
  fill(white);
  textSize(30);
  textAlign(RIGHT);
  text(nf(time, 1, 2), width, 24);
  
  textAlign(LEFT);
  text("score:"+score, 0, 24);
}


void draw(){
  scene.level();
}  
