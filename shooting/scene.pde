// sceneごとのフラグ管理を行う
// menu画面
// ゲーム画面
class Scene{
  public boolean boss_pop = false;   // ボスの出現状態
  private int boss_frame = 130; // ボスに行くフレーム時間
  public int frame_cnt = 0;    // 制限時間
  private int step = 0;               // "Boss"画面表示時間
  public float start_time = 0;       // ゲームの経過時間
  
  Scene(){
  }
  
  void game_init(){
    
    level = 0;
    score = 0;
    ship = null;
    ship = new Ship(160, 480);  
    if(boss_pop){
      boss = null;  // 念のために
      boss_pop = false;
    }
    if(bossBgm.isPlaying()) bossBgm.pause();
    if(enemyBgm.isPlaying()) enemyBgm.pause();
    enemyBgm.loop(0);
    gameover = false;
    
    // 敵の初期化
    for(int i= maneger.enemys.size()-1; i >= 0; i--){
      makeEnemy enemy = (makeEnemy)maneger.enemys.get(i);
      maneger.enemys.remove(i);
    }
    for(int i= maneger.cenemys.size()-1; i >= 0; i--){
      makeChaiseEnemy cenemy = (makeChaiseEnemy)maneger.cenemys.get(i);
      maneger.cenemys.remove(i);
    }
  }
  
  void level(){
    if (level == 0){
      menu();
      start_time = (float)millis()/1000;
      frame_cnt = frameCount;
    }
    if (level == 1){
      scene.playGame();//easy();  難易度ごとに弾の種類を変える
      boss_frame = 60;
    }
    if (level == 2){
      scene.playGame();//normal();
      boss_frame = 90;
    }
    if (level == 3){
      scene.playGame();//hard();
      boss_frame = 120;
    }
    if (level == 5)  scene.playGame();//check.play();  違うのクラスへ
  }
  
  //メニュー画面
  void menu() {
    background(0);
    textAlign(CENTER);
    
    textSize(40);
    fill(white);
    text("EASY", width/2, 80);
    textSize(20);
    text("Press E To Start", width/2, 100);
    
    textSize(40);
    text("NORMAL", width/2, 140);
    textSize(20);
    text("Press N To Start", width/2, 160);
    
    textSize(40);
    text("HARD", width/2, 200);
    textSize(20);
    text("Press H To Start", width/2, 220);
    
    textSize(40);
    fill(255);
    text("Check", width/2, 350);
    textSize(20);
    text("Press c To Start", width/2, 370);
    
    textSize(40);
    fill(255);
    text("Check", width/2, 350);
    textSize(20);
    text("Escキーで終了", width/2, height-200);
    
    textSize(20);
    fill(255);
    textAlign(RIGHT);
    text("音楽: OtoLogic  ", width, height-100);
    text("画像: いらすとや", width, height-70);
    
    if (keyPressed) {
      if (key == 'e') level = 1;
      if (key == 'n') level = 2;
      if (key == 'h') level = 3;
      if (key == 'c') level = 5;
      if (key == ESC) exit();
    }
  }
  
  void gameoverText(){
      background(0);
      textAlign(CENTER);
      textSize(50);
      if(ship.hp <= 0){
        fill(blue);
        text("YOU LOSE", width/2, height/2);
      }else{
        fill(255 * sin(frameCount), 255, 255 * cos(frameCount));
        text("YOU WIN", width/2, height/2);
      }
      text("Score:"+score, width/2, height/2+70);
      
      fill(white);
      textSize(20);
      text("Press Z To Go back menu", width/2, height/2+180);
      textSize(30);
      text("MENU", width/2, height/2+220);
      
      // Menuへ戻る
      if (keyPressed){
        if (key == 'z'){
          game_init();
        }
      }
       
  }
  
  void bossButtle(){
     if(boss_pop == false){
        background(0);
        // ボスに行く前に敵の削除
        for(int i= maneger.enemys.size()-1; i >= 0; i--){
          makeEnemy enemy = (makeEnemy)maneger.enemys.get(i);
          maneger.enemys.remove(i);
        }
        step = frameCount-frame_cnt;  // "Boss"の表示時間の調整
        
        // ボスの表示
        if(enemyBgm.isPlaying()) enemyBgm.pause();
        bossBgm.loop(0);
        boss = new Boss(160, 30, 15);
        boss_pop = true;
     }
      
      // "Boss"の表示
      if(step >= (frameCount-frame_cnt)-(frameRate*1.5)){
        textSize(130);
        fill(red);
        textAlign(CENTER);
        text("Boss", width/2, height/2);
      }    
    
      boss.move();   // ボスの移動
  }
  
  
  void playGame(){
    if(gameover || (frameCount-frame_cnt >= frameRate*300)){
      gameoverText();
      
    }else{
      background(0);
      
      // ボスに行く時間の前だったら
      if(frameCount-frame_cnt <= frameRate*boss_frame){
        maneger.make_enemy();  // ボスの前の敵を表示
        
      }else{
        bossButtle();
 
      }
      
      // 船の座標位置   
      ship.update(mouseX, mouseY);  // mouseX, mouseY
      printData();  // 経過時間とスコア表示
    }
  }
}
