// メインのコード(setup, draw, グローバル変数)

/*********************************************************************************
音楽: https://otologic.jp/free/bgm/game-shooter-nes01.html  (OtoLogic)
イラスト: https://www.irasutoya.com/
****************************************/
import ddf.minim.*;

Enemys maneger;
Ship ship; 
Boss boss; 
Scene scene; 
Minim minim; 
AudioPlayer enemyBgm, bossBgm;
AudioSample shoot;

final int SHIP_Bsize = 10;  // 船の弾の大きさ
int score = 0;              // スコア
int level = 0;              // 難易度

boolean gameover = false;   //ゲームの終わり

/* 色 */
color red = #ff0000, green = #00ff00, blue = #0000ff;
color white = #ffffff, yellow = #ffff00, orange = #ffa500;
color purple = #800080;     

void setup(){
   size(640, 640);
   frameRate(30);
   //noCursor();
   //noSmooth();
    
   scene = new Scene(); 
   ship = new Ship(160, 480);
   maneger = new Enemys();
   minim = new Minim(this);
   enemyBgm = minim.loadFile("Stage.mp3");
   bossBgm = minim.loadFile("Boss.mp3");
   shoot = minim.loadSample("Shoot.mp3");
   enemyBgm.loop();
   
/*********** フォントの設定  *************/
/* フォントをVLWフォーマットに変換・作成 */
   PFont font;
   font = createFont("MS Mincho", 48);    // ＭＳ明朝 「MS Mincho」
   textFont(font);                        // フォントを指定する
/*****************************************/
}
    
// スコアと経過時間の表示
void printData() {
  float time = (float)millis()/1000 - scene.start_time;
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
