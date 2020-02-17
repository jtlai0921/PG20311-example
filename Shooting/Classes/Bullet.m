//
//  Bullet.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Bullet.h"
#import "Common.h"

// 子彈類別
@implementation HPBullet

// 初始化
-(id)init {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		positionX=positionY=speed=angle=0;
		texture=bulletTexture;		
		drawSize=0.025f;
		hitSize=0.02f;
	}
	return self;
}

// 移動
-(BOOL)move {
	
	// 與自機的接觸判定處理
	if ([myShip doesHitMover:self]) {
		[myShip destroy];
		return NO;
	}
	return [super move];
}

// 發射方向彈（類別方法）
+(void)shootDirectionalBulletWithX:(float)x y:(float)y speed:(float)s angle:(float)a {
	[[bulletPool addObject] setX:x y:y speed:s angle:a];
}

// 發射狙擊彈（類別方法）
+(void)shootAimingBulletWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty {
	[[bulletPool addObject] setX:x y:y speed:s angle:atan2f(ty-y, tx-x)/(float)M_PI/2];
}

// 發射固定方向n-way彈（類別方法）
+(void)shootDirectionalNWayBulletsWithX:(float)x y:(float)y speed:(float)s angle:(float)a angleRange:(float)ar count:(NSUInteger)c {
	for (int i=0; i<c; i++) {
		[HPBullet shootDirectionalBulletWithX:x y:y speed:s angle:a-ar/2+ar*i/(c-1)];
	}
}

// 發射狙擊n-way彈（類別方法）
+(void)shootAimingNWayBulletsWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty angleRange:(float)ar count:(NSUInteger)c {
	[HPBullet shootDirectionalNWayBulletsWithX:x y:y speed:s angle:atan2f(ty-y, tx-x)/(float)M_PI/2 angleRange:ar count:c];
}

@end

