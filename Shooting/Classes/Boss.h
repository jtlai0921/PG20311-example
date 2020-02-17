//
//  Boss.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 魔王類別
@interface HPBoss : HPMover {

	// 狀態、定時器、持續時間
	NSInteger state, time, duration;

	// 傷害、alpha值、旋轉角度（X軸、Y軸、Z軸）
	float damage, alpha, rotationX, rotationY, rotationZ;
}

// 重新啟動
-(void)reset;

// 移動
-(BOOL)move;

// 描繪
-(void)draw;

// 魔王的出現（類別方法）
+(void)launchBoss;

@end

