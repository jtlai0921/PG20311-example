//
//  Bullet.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 子彈類別
@interface HPBullet : HPMover {}

// 初始化
-(id)init;

// 移動
-(BOOL)move;

// 發射方向彈（類別方法）
+(void)shootDirectionalBulletWithX:(float)x y:(float)y speed:(float)s angle:(float)a;

// 發射狙擊彈（類別方法）
+(void)shootAimingBulletWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty;

// 發射固定方向n-way彈（類別方法）
+(void)shootDirectionalNWayBulletsWithX:(float)x y:(float)y speed:(float)s angle:(float)a angleRange:(float)ar count:(NSUInteger)c;

// 發射狙擊n-way彈（類別方法）
+(void)shootAimingNWayBulletsWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty angleRange:(float)ar count:(NSUInteger)c;

@end

