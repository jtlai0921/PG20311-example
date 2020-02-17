//
//  Number.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Number.h"

// 數值類別
@implementation HPNumber

// 初始化
-(id)init {
	self=[super init];
	if (self!=nil) {
		hitSize=0;
	}
	return self;
}

// 拋棄
-(void)dealloc {
	[super dealloc];
}

// 數值的取得
-(NSInteger)value {
	return value;
}

// 數值的加算
-(void)addValue:(NSInteger)v {
	value+=v;
}

// 數值、描繪尺寸、限制時間的設定
-(void)setValue:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t {
	value=v;
	drawSize=d;
	time=0;
	timeLimit=t;
	if (timeLimit<=0) timeLimit=-1;
}

// 移動
-(BOOL)move {
	
	// 限制時間有效的時候（正值），達到限制時間就把數值刪除
	if (timeLimit>0) {
		if (time==timeLimit) {
			return FALSE;
		}
		time++;
	}
	return [super move];
}

// 描繪
-(void)draw {
	float x=positionX;
	NSInteger v=value;
	
	// 將數值從下位數一個一個從右描繪到左
	do {
		[numberTexture[v%10] drawWithX:x y:positionY width:drawSize height:drawSize 
			red:1.0f green:1.0f blue:1.0f 
			alpha:MIN((float)(timeLimit-time)/timeLimit*5, 1.0f) rotation:rotation];
		v/=10;
		x-=drawSize*2;
	} while (v>0);
}

// 數值的出現（類別方法）
+(void)launchNumberWithX:(float)x y:(float)y speed:(float)s angle:(float)a value:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t {
	HPNumber* n=[numberPool addObject];
	[n setX:x y:y speed:s angle:a];
	[n setValue:v drawSize:d timeLimit:t];
}

@end
