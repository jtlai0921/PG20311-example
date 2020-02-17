//
//  Number.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 數值類別
@interface HPNumber : HPMover {
	
	// 數值、定時器、限制時間
	NSInteger value, time, timeLimit;
}

// 初始化
-(id)init;

// 拋棄
-(void)dealloc;

// 數值的取得
-(NSInteger)value;

// 數值的加算
-(void)addValue:(NSInteger)v;

// 數值、描繪尺寸、限制時間的設定
-(void)setValue:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t;

// 移動
-(BOOL)move;

// 描繪
-(void)draw;

// 數值的出現（類別方法）
+(void)launchNumberWithX:(float)x y:(float)y speed:(float)s angle:(float)a value:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t;

@end
