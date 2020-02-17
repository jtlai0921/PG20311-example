//
//  Game.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 遊戲本體的類別

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>

// 代表View port（描繪區域）的結構體
typedef struct {

	// 起始座標
	GLint x, y;
	
	// 尺寸（寬度與高度）
	GLsizei w, h;
} HPViewport;

// 遊戲本體的類別
@interface HPGame : NSObject <UIAccelerometerDelegate> {
	
	// 遊戲的狀態、用於調整描繪次數的定時器
	NSInteger state, drawTime;
	
	// 捲軸的位置
	float backgroundY;
	
	// View port
	HPViewport viewport;
}

// 初始化
-(id)init;

// 拋棄
-(void)dealloc;

// 移動
-(void)move;

// 描繪
-(void)draw;

// 設定的下載
-(void)load;

// 設定的儲存
-(void)save;

// 讀取音效檔
-(AVAudioPlayer*)playerWithFile:file;

@end
