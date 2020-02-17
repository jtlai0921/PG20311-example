//
//  Common.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 在遊戲內使用全域變數

#import "Common.h"

// OpenGL ES相關
EAGLContext* glContext;
GLuint glProgram;
GLuint glUniformTexture, glUniformMatrix, glUniformColor;

// 遊戲本體
HPGame* game;

// 物件儲存池
HPObjectPool *myShipPool, *bulletPool, *enemyPool, *weaponPool, *numberPool, *bossPool, *buttonPool;

// 自機
HPMyShip* myShip;

// 得分
HPNumber* score;

// 材質
HPTexture 
	*bulletTexture, *myShipTexture[2], *myShipDestroyedTexture, *enemyTexture[2], *weaponTexture, *padTexture, *numberTexture[10], *backgroundTexture, 
	*titleTexture, *controlTexture[4], *newRecordTexture, *gameOverTexture;

// 畫面的座標
float screenWidth=1.0f, screenHeight=1.5f, movableWidth=1.1f, movableHeight=1.6f, originalWidth=1.0f, originalHeight=1.5f;

// 假想遙控面版
float padX=-0.7, padY=-1.2, padSize=0.25, padMargin=0.05;

// 加速度
float minAcceleration=0.1, maxAcceleration=0.3;
float accelerationX, accelerationY, accelerationZ;

// 觸控
float touchX, touchY;
BOOL touched, previousTouched;

// 小程式
HPScript* script;

// 等級
float rank;

// 模型
HPModel* bossModel;

// 按鈕
NSInteger buttonIndex;

// 操作模式、最高得分
NSInteger controlType, topScore;

// 音效
AVAudioPlayer *buttonPlayer, *hitPlayer, *enemyPlayer, *bossPlayer;

// BGM
MPMusicPlayerController* musicPlayer;
