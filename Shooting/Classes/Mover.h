//
//  Mover.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Texture.h"

// 移動物體類別
@interface HPMover : NSObject {
	
	// 座標
	float positionX, positionY;
	
	// 速度的大小、角度
	float speed, angle;
	
	// 材質
	HPTexture* texture;
	
	// 描繪尺寸、接觸判定尺寸
	float drawSize, hitSize;
	
	// 旋轉角度、旋轉速度
	float rotation, rotationRate;
}

// 取得座標
-(float)positionX;
-(float)positionY;

// 座標與速度的設定
-(void)setX:(float)x y:(float)y speed:(float)s angle:(float)a;

// 移動
-(BOOL)move;

// 描繪
-(void)draw;

// 與其他移動物體的接觸判定
-(BOOL)doesHitMover:(HPMover*)m;

// 移動所有位於物件儲存池裡的移動物體（類別方法）
+(void)moveObjectPool:op;

// 描繪所有位於物件儲存池裡的移動物體（類別方法）
+(void)drawObjectPool:op;

// 刪除所有位於物件儲存池裡的移動物體（類別方法）
+(void)clearObjectPool:op;

@end
