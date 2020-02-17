//
//  MyShip.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "MyShip.h"
#import "Weapon.h"

// 自機類別
@implementation HPMyShip

// 初始化
-(id)init {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		angle=0;
		speed=0.03f;
		drawSize=0.15f;
	}
	return self;
}

// 破壞
-(void)destroy {
	if (!destroyed) {
		
		// 破壞狀態與定時器的設定
		destroyed=YES;
		destroyTime=0;
		
		// 讓接觸判定失效
		hitSize=-100;
		
		// 調降等級
		rank=MAX(rank/2, 1);
		
		// 播放音效
		[hitPlayer play];
	}
}

// 描繪
-(void)draw {
	
	// 破壞時
	if (destroyed) {
		
		// 讓自機漸漸消失
		if (destroyTime<=60) {
			float t=MIN(destroyTime/60.0f, 1);
			[myShipDestroyedTexture drawWithX:positionX y:positionY 
				width:drawSize*(1+t) height:drawSize*(1+t) 
				red:1.0f green:1.0f blue:1.0f alpha:1-t rotation:0.0f];
		} else 
		
		// 讓自機漸漸出現（復活時）	
		if (destroyTime>=120) {
			float t=MIN((destroyTime-120)/60.0f, 1);
			[texture drawWithX:positionX y:positionY 
				width:drawSize height:drawSize 
				red:1.0f green:1.0f blue:1.0f alpha:t rotation:0.0f];
		}
	} else 
	
	// 一般的時候
	{
		[super draw];
	}
}

// 移動
-(BOOL)move {
	
	// 破壞時
	if (destroyed) {
		
		// 定時器的更新
		destroyTime++;
		
		// 1秒後刪除自機（不讓自機復活時的處理）
		if (destroyTime==60) {
			return NO;
		}
		
		// 3秒後讓自機復活（讓自機復活時的處理）
		/*
		if (destroyTime==180) {
			destroyed=NO;
			hitSize=0.05f;
		}
		*/
		
		// 2秒後才能操作自機
		if (destroyTime<120) {
			return YES;
		}
	}
	
	// 動畫
	texture=myShipTexture[animationTime/10];
	animationTime=(animationTime+1)%20;
	
	// 武器
	if (weaponTime==0) {
		[HPWeapon shootWeaponWithX:positionX y:positionY+0.15f 
			speed:0.05f angle:0.25f];
	}
	weaponTime=(weaponTime+1)%5;
	
	// 觸控與滑動
	if (controlType==0) {
		
		// 對應觸控開始的位置與相對的滑動量來移動自機
		if (!previousTouched && touched) {
			beganX=positionX;
			beganY=positionY;
			beganTouchX=touchX;
			beganTouchY=touchY;
		}
		float tx=beganX+touchX-beganTouchX, ty=beganY+touchY-beganTouchY;
		float vx=tx-positionX, vy=ty-positionY, l=sqrtf(vx*vx+vy*vy);
		if (l>speed) {
			positionX+=vx/l*speed;
			positionY+=vy/l*speed;
		} else {
			positionX=tx;
			positionY=ty;
		}

		// 將自機直接移動到觸控的位置
		/*
			positionX=touchX;
			positionY=touchY;
		*/
		
		// 將自機漸漸移動到觸控的位置
		/*
			float vx=touchX-positionX, vy=touchY-positionY, l=sqrtf(vx*vx+vy*vy);
			if (l>speed) {
				positionX+=vx/l*speed;
				positionY+=vy/l*speed;
			} else {
				positionX=touchX;
				positionY=touchY;
			}
		*/
	}
	
	// 加速感應器
	if (controlType==1) {
		
		// 調整到只要適度傾斜iOS裝置就出現最大速度
		float vx=accelerationX, vy=accelerationY, l=sqrtf(vx*vx+vy*vy);
		float s=MIN(MAX((l-minAcceleration)/(maxAcceleration-minAcceleration), 0), 1)*speed;
		if (l>0) {
			positionX+=vx/l*s;
			positionY+=vy/l*s;
		}
		
		// 單純由加速度計算速度
		/*
			positionX+=accelerationX*speed;
			positionY+=accelerationY*speed;
		*/
	}

	// 假想遙控面版
	if (controlType==2) {
		
		// 對應距離假想遙控面版中心的距離，調整自機的速度大小
		if (touched) {
			float vx=touchX-padX, vy=touchY-padY, l=sqrtf(vx*vx+vy*vy);
			if (l<=padSize) {
				float s=MIN(MAX((l-padMargin)/(padSize-padMargin*2), 0), 1)*speed;
				positionX+=vx/l*s;
				positionY+=vy/l*s;
			}
		}

		// 速度一定，讓自機朝假想遙控面版被觸控的方向移動
		/*
		if (touched) {
			float vx=touchX-padX, vy=touchY-padY, l=sqrtf(vx*vx+vy*vy);
			if (l<=padSize) {
				positionX+=vx/l*speed;
				positionY+=vy/l*speed;
			}
		}
		*/
	}
	
	// 更新自機的座標
	float sx=screenWidth-drawSize, sy=screenHeight-drawSize;
	positionX=MIN(MAX(positionX, -sx), sx);
	positionY=MIN(MAX(positionY, -sy), sy);	
	
	return YES;
}

// 重新啟動
// 在自機出現時將各種變數初始化
-(void)reset {
	
	// 接觸判定
	hitSize=0.02f;

	// 座標、移動起始座標、接觸起始座標、加速度
	positionX=beganX=0;
	positionY=beganY=-1;
	beganTouchX=touchX;
	beganTouchY=touchY;
	accelerationX=accelerationY=0;	

	// 材質、破壞狀態、動畫的定時器、武器的定時器
	texture=myShipTexture[0];
	destroyed=NO;
	animationTime=0;
	weaponTime=0;
}

// 自機的出現（類別方法）
+(void)launchMyShip {
	myShip=[myShipPool addObject];
	[myShip reset];
}

@end

