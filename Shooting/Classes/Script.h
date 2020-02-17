//
//  Script.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import <Foundation/Foundation.h>

// 小程式指令類別
@interface HPScriptCommand : NSObject {
	
	// 類型、待機時間
	NSInteger type, wait;
	
	// 座標、速度（大小和角度）
	float positionX, positionY, speed, angle;
}

// 初始化
-(id)initWithString:(NSString*)s;

// 執行
-(NSInteger)run;

@end

//-------------------------------------------------------------------------

// 小程式類別
@interface HPScript : NSObject {
	
	// 指令的陣列
	NSMutableArray* command;
	
	// 執行中的位置、待機時間
	NSInteger index, wait;
}

// 初始化
-(id)initWithFile:(NSString*)file;

// 拋棄
-(void)dealloc;

// 重新啟動
-(void)reset;

// 移動（執行）
-(BOOL)move;

@end

