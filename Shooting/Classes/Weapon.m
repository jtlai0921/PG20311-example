//
//  Weapon.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Weapon.h"

// 武器類別
@implementation HPWeapon

// 初始化
-(id)init {
	self=[super init];
	if (self!=nil) {
		texture=weaponTexture;
	}
	return self;
}

// 移動
-(BOOL)move {
	
	// 描繪尺寸、接觸判定尺寸、攻擊力的更新
	drawSize+=0.004f;
	hitSize+=0.004f;
	attack-=0.001f;
	return [super move];
}

// 尺寸的設定
-(void)setSizes {
	
	// 描繪尺寸、接觸判定尺寸、攻擊力的初始化
	drawSize=0.1f;
	hitSize=0.1f;
	attack=0.05f;
}

// 取得攻擊力
-(float)attack {
	return attack;
}

// 發射武器（類別方法）
+(void)shootWeaponWithX:(float)x y:(float)y speed:(float)s angle:(float)a {
	HPWeapon* w=[weaponPool addObject];
	[w setX:x y:y speed:s angle:a];
	[w setSizes];
}

@end
