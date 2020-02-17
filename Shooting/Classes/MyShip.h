//
//  MyShip.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 自機類別
@interface HPMyShip : HPMover {
	
	// 移動起始座標、觸控起始座標
	float beganX, beganY, beganTouchX, beganTouchY;
	
	// 破壞狀態（若被破壞就為YES）
	BOOL destroyed;
	
	// 定時器（動畫、破壞、武器的發射）
	NSInteger animationTime, destroyTime, weaponTime;
}

// 初始化
-(id)init;

// 移動
-(BOOL)move;

// 描繪
-(void)draw;

// 破壞
-(void)destroy;

// 重新啟動
-(void)reset;

// 自機的出現（類別方法）
+(void)launchMyShip;

@end

