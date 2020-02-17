//
//  Enemy.h
//  Shooting
//
//  Copyright 2010 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 敵人類別
@interface HPEnemy : HPMover {
	
	// 類型、定時器
	NSInteger type, time;
	
	// 傷害
	float damage;
	
	// 上次的座標
	float prevPositionX, prevPositionY;
}

// 初始化
-(id)init;

// 移動
-(BOOL)move;

// 設定類型
-(void)setType:(NSInteger)t;

// 敵人的出現（類別方法）
+(void)launchEnemyWithX:(float)x y:(float)y speed:(float)s angle:(float)a type:(NSInteger)t;

@end

