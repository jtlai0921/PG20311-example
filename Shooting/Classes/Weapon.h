//
//  Weapon.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 武器類別
@interface HPWeapon : HPMover {
	
	// 攻擊力
	float attack;
}

// 初始化
-(id)init;

// 移動
-(BOOL)move;

// 設定尺寸
-(void)setSizes;

// 取得攻擊力
-(float)attack;

// 發射武器（類別方法）
+(void)shootWeaponWithX:(float)x y:(float)y speed:(float)s angle:(float)a;

@end
