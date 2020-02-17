//
//  Enemy.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Bullet.h"
#import "Common.h"
#import "Enemy.h"
#import "Number.h"
#import "Weapon.h"

// 敵人類別
@implementation HPEnemy

// 初始化
-(id)init {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		drawSize=0.25f;
		hitSize=0.2f;
	}
	return self;
}

// 移動
-(BOOL)move {
	
	// 每1秒發射子彈
	if (time==60) {
		
		// 敵人類型0發射固定方向n-way彈
		if (type==0) {
			[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
				speed:0.02f angle:0.75f angleRange:0.9f count:10];
		} else 
		
		// 敵人類型1發射狙擊n-way彈
		{
			[HPBullet shootAimingNWayBulletsWithX:positionX y:positionY 
				speed:0.02f targetX:[myShip positionX] targetY:[myShip positionY] angleRange:0.1f count:5];
		}
	}
	time=(time+1)%240;
	
	// 和武器的接觸判定處理
	for (NSInteger i=[weaponPool objectCount]-1; i>=0; i--) {
		HPWeapon* w=(HPWeapon*)[weaponPool objectAtIndex:i];
		
		// 接觸到武器時的處理
		if ([w doesHitMover:self]) {
			
			// 傷害的加算
			damage=MIN(damage+[w attack], 1.0f);
			
			// 得分的加算與顯示
			NSInteger v=(NSInteger)([w attack]*[w attack]*10000*rank);
			[HPNumber launchNumberWithX:positionX+0.08f y:positionY speed:0.01f angle:0.25f value:v drawSize:0.04f timeLimit:30];
			[score addValue:v];
			
			// 刪除武器
			[weaponPool removeObjectAtIndex:i];
		}
	}
	
	// 描繪尺寸與接觸判定尺寸的計算（對應傷害做變化）
	drawSize=0.25f*(1.0f+damage);
	hitSize=0.2f*(1.0f+damage);
	
	// 若從可移動範圍內跑到可移動範圍外，加算分數
	if (
		-screenWidth<prevPositionX && prevPositionX<screenWidth &&
		-screenHeight<prevPositionY && prevPositionY<screenHeight &&
		(positionX<=-screenWidth || screenWidth<=positionX ||
		 positionY<=-screenHeight || screenHeight<=positionY)
	) {
		// 得分的加算與顯示
		NSInteger v=(NSInteger)(damage*damage*10000*rank);
		[HPNumber launchNumberWithX:positionX+0.35f y:positionY speed:0.02f angle:angle+0.5f value:v drawSize:0.07f timeLimit:60];
		[score addValue:v];
		
		// 播放音效
		[enemyPlayer play];
	}
	
	// 將目前的座標記錄為上一次的座標
	prevPositionX=positionX;
	prevPositionY=positionY;
	
	// 與自機的接觸判定處理（若是接觸就破壞自機）
	if ([myShip doesHitMover:self]) {
		[myShip destroy];
	}
	
	return [super move];
}

// 描繪
-(void)draw {
	[texture drawWithX:positionX y:positionY 
		width:drawSize height:drawSize
		red:1.0f-damage*0.4f 
		green:1.0f-damage*0.7f
		blue:1.0f-damage*0.9f
	 	alpha:1.0f
		rotation:rotation];
}

// 設定類型
-(void)setType:(NSInteger)t {
	
	// 類型、材質
	type=t;
	texture=enemyTexture[t];
	
	// 旋轉角度
	rotation=0;
	rotationRate=(t*2-1)*0.01f;
	
	// 傷害
	damage=0;
	
	// 座標
	prevPositionX=positionX;
	prevPositionY=positionY;
	
	// 定時器
	time=0;
}

// 敵人的出現（類別方法）
+(void)launchEnemyWithX:(float)x y:(float)y speed:(float)s angle:(float)a type:(NSInteger)t {
	HPEnemy* e=[enemyPool addObject];
	[e setX:x y:y speed:s angle:a];
	[e setType:t];
}

@end
