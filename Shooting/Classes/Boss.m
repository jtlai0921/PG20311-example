//
//  Boss.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Boss.h"
#import "Bullet.h"
#import "Common.h"
#import "Number.h"
#import "Weapon.h"

// 魔王類別
@implementation HPBoss

// 重新啟動
-(void)reset {
	
	// 座標
	positionX=0;
	positionY=0.5f;
	
	// 角度
	rotationX=rotationY=rotationZ=0;
	
	// 描繪尺寸、接觸判定尺寸、傷害
	drawSize=hitSize=damage=0;
	
	// 狀態、定時器、持續時間
	state=1;
	time=0;
	duration=120;
}

// 移動
-(BOOL)move {
	
	// 從定時器與持續時間來計算用於角度等變化的值
	float t=(float)time/duration;
	
	// 依照狀況分開處理
	switch (state) {
			
		// 狀態1（出現）
		case 1:
			
			// 圍繞Z軸旋轉，一邊漸漸變大變濃一邊出現
			drawSize=0.5f*t;
			rotationZ=2.0f*t;
			alpha=t;
			
			// 經過一定時間後轉移到狀態2
			time++;
			if (time==duration) {
				drawSize=0.5f;
				hitSize=0.4f;
				rotationZ=0;
				alpha=1;
				state=2;
				time=0;
				duration=240/rank;
			}
			break;
			
		// 狀態2（漩渦飛彈+Y軸旋轉）
		case 2:
			
			// 約每0.16秒發射固定方向的n-way彈
			if (time%10==0) {
				[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
					speed:0.02f angle:t*0.5f angleRange:0.8f count:5];
			}
			
			// 每0.5秒發射狙擊彈
			if (time%30==0) {
				[HPBullet shootAimingBulletWithX:positionX y:positionY 
					speed:0.03f targetX:[myShip positionX] targetY:[myShip positionY]];
			}
			
			// 圍繞Y軸旋轉
			rotationY=t;
			
			// 一定時間後轉移到狀態3
			time++;
			if (time==duration) {
				rotationY=0;
				state=3;
				time=0;
				duration=240/rank;
			}
			break;
		
		// 狀態3（放射狀n-way彈＋X軸旋轉）
		case 3:
			
			// 約每0.5秒發射放射狀的n-way彈
			if (time%30==0) {
				for (NSInteger i=0; i<3; i++) {
					for (NSInteger j=0; j<3; j++) {
						[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
							speed:0.02f+i*0.005f angle:t*2+j*0.02f angleRange:0.8f count:5];
					}
				}
			}
			
			// 圍繞X軸旋轉
			rotationX=t;
			
			// 一定時間後轉移到狀態4
			time++;
			if (time==duration) {
				rotationX=0;
				state=4;
				time=0;
				duration=240/rank;
			}
			break;

		// 狀態4（漩渦飛彈＋Y軸旋轉）
		case 4:
			
			// 約每0.16秒發射固定方向的n-way彈
			if (time%10==0) {
				[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
					speed:0.02f angle:-t*0.5f angleRange:0.8f count:5];
			}
			
			// 每0.5秒發射狙擊彈
			if (time%30==0) {
				[HPBullet shootAimingBulletWithX:positionX y:positionY 
					speed:0.03f targetX:[myShip positionX] targetY:[myShip positionY]];
			}
			
			// 圍繞Y軸旋轉
			rotationY=-t;
			
			// 一定時間後轉移到狀態5
			time++;
			if (time==duration) {
				rotationY=0;
				state=5;
				time=0;
				duration=240/rank;
			}
			break;

		// 狀態5（波狀n-way彈＋X軸旋轉）
		case 5:
			
			// 約每0.08秒發射波狀n-way彈
			if (time%5==0) {
				[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
					speed:0.02f angle:sinf(t*M_PI*3)*0.1f angleRange:0.8f count:5];
			}
			
			// 圍繞X軸旋轉
			rotationX=-t;
			
			// 一定時間後轉移到狀態2
			time++;
			if (time==duration) {
				rotationX=0;
				state=2;
				time=0;
				duration=240/rank;
			}
			break;

		// 狀態6（破壞）
		case 6:
			
			// 圍繞Z軸旋轉，逐漸變小變薄漸漸消失
			drawSize=1-t;
			rotationZ=4.0f*(1-t);
			alpha=1-t;
			
			// 一定時間後轉移到狀態-1（消失）
			time++;
			if (time==duration) {
				state=-1;
			}
			break;
	}
	
	// 接觸判定處理
	if (hitSize>0) {
		
		// 和武器的接觸判定處理
		for (NSInteger i=[weaponPool objectCount]-1; i>=0; i--) {
			HPWeapon* w=(HPWeapon*)[weaponPool objectAtIndex:i];
			
			// 接觸到武器時
			if ([w doesHitMover:self]) {
				
				// 傷害的加算
				damage+=[w attack]*0.1f;
				
				// 得分的計算與顯示
				NSInteger v=(NSInteger)([w attack]*[w attack]*10000*rank);
				[HPNumber launchNumberWithX:[w positionX]+0.08f y:[w positionY] 
					speed:0.01f angle:0.25f value:v drawSize:0.04f timeLimit:30];
				[score addValue:v];
				
				// 刪除武器
				[weaponPool removeObjectAtIndex:i];
			}
		}
		
		// 對應傷害程度更新描繪尺寸與接觸判定尺寸
		drawSize=0.5f*(1.0f+damage);
		hitSize=0.4f*(1.0f+damage);
		
		// 被破壞時
		if (damage>=1) {
			
			// 得分的計算與顯示
			NSInteger v=(NSInteger)(100000*rank*rank);
			[HPNumber launchNumberWithX:positionX+0.7f y:positionY 
				speed:0.005f angle:0.25f value:v drawSize:0.14f timeLimit:120];
			[score addValue:v];
			
			// 播放音效
			[bossPlayer play];
			
			// 轉移到狀態6（破壞）
			hitSize=0;
			state=6;
			time=0;
			duration=120;
		}
	}
	
	// 若為狀態-1（消失）就回NO，其它狀態就回傳YES
	return state!=-1;
}

// 描繪
-(void)draw {
	[bossModel drawWithX:positionX y:positionY z:0 
		scale:drawSize
		red:1.0f-damage*0.4f 
		green:1.0f-damage*0.7f
		blue:1.0f-damage*0.9f
		alpha:alpha
		rotationX:rotationX rotationY:rotationY rotationZ:rotationZ];
}

// 魔王的出現（類別方法）
+(void)launchBoss {
	[[bossPool addObject] reset];
}

@end
