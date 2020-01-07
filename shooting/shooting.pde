// メインのコード(setup, draw, グローバル変数)

/****************************************
船のダメージの可視化(ゲージ, エフェクト) 
難易度の作成
カーソル方向に船を移動(船の移動方法(カーソル移動, マウス移動))

難易度による敵の大きさの変化
難易度によるボスの強さの調整
難易度によるボスの大きさ動きの変化
ボスでのスコアの減点をどうするか
敵の画像化(もしくは形を凝る), 画像の場合は敵数を減らす
出現方法の調整
画面サイズの調整による影響の軽減

makeCEをmakeEクラスの派生に
変数の宣言場所等の調整

*****************************************
音楽: https://otologic.jp/free/bgm/game-shooter-nes01.html  (OtoLogic)
イラスト: https://www.irasutoya.com/
****************************************/
import ddf.minim.*;

makeEnemy enemy;
Enemys maneger;
Ship ship;
Bullet bullet;
Boss boss;
Scene scene;
Minim minim;
AudioPlayer enemyBgm, bossBgm;
AudioSample shoot;

final int SHIP_Bsize = 10;  // 船の弾の大きさ
final int ENEMY_size = 30;  // 敵の大きさ
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

PImage pictures;                   // 背景画像用の  PImage       
final String picture[] = {"spaceShip_400x234","ufo_400x315"};

void setup(){
   size(640, 640);
   frameRate(30);
   //noCursor();
    
   scene = new Scene(); 
   ship = new Ship(160, 480);
   enemy = new makeEnemy(160, 0, -3, 5, red);
   maneger = new Enemys();
   minim = new Minim(this);
   enemyBgm = minim.loadFile("Stage.mp3");
   bossBgm = minim.loadFile("Boss.mp3");
   shoot = minim.loadSample("Shoot.mp3");
   enemyBgm.loop();
   
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


void stop()
{
  enemyBgm.close();
  bossBgm.close();
  shoot.close();
  minim.stop();
  super.stop();
}
