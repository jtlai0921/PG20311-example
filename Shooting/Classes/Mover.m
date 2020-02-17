//
//  Mover.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Mover.h"
#import "Texture.h"

// 移動物體類別
@implementation HPMover

// 取得座標
-(float)positionX {
	return positionX;
}
-(float)positionY {
	return positionY;
}

// 座標與速度的設定
-(void)setX:(float)x y:(float)y speed:(float)s angle:(float)a {
	positionX=x;
	positionY=y;
	speed=s;
	angle=a;
	rotation=rotationRate=0;
}

// 移動
-(BOOL)move {
	
	// 對座標加上速度
	float r=(float)M_PI*2*angle;
	positionX+=cosf(r)*speed;
	positionY+=sinf(r)*speed;
	
	// 更新旋轉角度
	rotation+=rotationRate;
	
	// 在可移動範圍內就回傳YES，在可移動範圍外就回傳NO
	return 
		-movableWidth<positionX+drawSize && positionX-drawSize<movableWidth &&
		-movableHeight<positionY+drawSize && positionY-drawSize<movableHeight;
}

// 描繪
-(void)draw {
	[texture drawWithX:positionX y:positionY 
		width:drawSize height:drawSize 
		red:1.0f green:1.0f blue:1.0f alpha:1.0f rotation:rotation];
}

// 與其他移動物體的接觸判定處理
-(BOOL)doesHitMover:(HPMover*)m {
	
	// 座標的差
	float dx=positionX-m->positionX, dy=positionY-m->positionY;
	
	// 接觸判定的半徑的和
	float h=hitSize+m->hitSize;
	
	// 如果中心彼此之間的距離小於接觸判定半徑的和，
	// 那就當做有接觸，回傳YES
	return dx*dx+dy*dy<h*h;
	
	// 雖然可以使用求取平方根的sqrtf，但不用的話速度比較快
	// return sqrtf(dx*dx+dy*dy)<h;
}

// 移動所有位於物件儲存池裡的移動物體（類別方法）
+(void)moveObjectPool:op {
	for (NSInteger i=[op objectCount]-1; i>=0; i--) {
		if (![(HPMover*)[op objectAtIndex:i] move]) {
			[op removeObjectAtIndex:i];
		}
	}
}

// 描繪所有位於物件儲存池裡的移動物體（類別方法）
+(void)drawObjectPool:op {
	for (NSInteger i=[op objectCount]-1; i>=0; i--) {
		[(HPMover*)[op objectAtIndex:i] draw];
	}	
}

// 刪除所有位於物件儲存池裡的移動物體（類別方法）
+(void)clearObjectPool:op {
	for (NSInteger i=[op objectCount]-1; i>=0; i--) {
		[op removeObjectAtIndex:i];
	}
}

@end

