//
//  Common.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 在遊戲內使用全域變數

#import "Game.h"
#import "Model.h"
#import "Mover.h"
#import "MyShip.h"
#import "Number.h"
#import "ObjectPool.h"
#import "Script.h"
#import "Texture.h"

// OpenGL ES相關
extern EAGLContext* glContext;
extern GLuint glProgram;
extern GLuint glUniformTexture, glUniformMatrix, glUniformColor;

// 遊戲本體
extern HPGame* game;

// 物件儲存池
extern HPObjectPool *myShipPool, *bulletPool, *enemyPool, *weaponPool, *numberPool, *bossPool, *buttonPool;

// 自機
extern HPMyShip* myShip;

// 得分
extern HPNumber* score;

// 材質
extern HPTexture 
	*bulletTexture, *myShipTexture[2], *myShipDestroyedTexture, *enemyTexture[], *weaponTexture, *padTexture, *numberTexture[10], *backgroundTexture, 
	*titleTexture, *controlTexture[4], *newRecordTexture, *gameOverTexture;

// 畫面的座標
extern float screenWidth, screenHeight, movableWidth, movableHeight, originalWidth, originalHeight;

// 假想遙控面版
extern float padX, padY, padSize, padMargin;

// 加速度
extern float minAcceleration, maxAcceleration;
extern float accelerationX, accelerationY, accelerationZ;

// 觸控
extern float touchX, touchY;
extern BOOL touched, previousTouched;

// 小程式
extern HPScript* script;

// 等級
extern float rank;

// 模型
extern HPModel* bossModel;

// 按鈕
extern NSInteger buttonIndex;

// 操作類型、最高得分
extern NSInteger controlType, topScore;

// 音效
extern AVAudioPlayer *buttonPlayer, *hitPlayer, *enemyPlayer, *bossPlayer;

// BGM
extern MPMusicPlayerController* musicPlayer;

