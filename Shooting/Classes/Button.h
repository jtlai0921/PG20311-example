//
//  Button.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 按鈕類別
@interface HPButton : HPMover {
	
	// 狀態、按鈕編號
	NSInteger state, index;
	
	// 寬度、高度、顏色、alpha值、放大縮小率
	float width, height, color, alpha, scale;
}

// 移動
-(BOOL)move;

// 描繪
-(void)draw;

// 材質、尺寸、按鈕編號的設定
-(void)setTexture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i;

// 顏色、alpha值、放大縮小率的補間運算
-(void)interpolateColor:(GLfloat)c alpha:(GLfloat)a scale:(GLfloat)s;

// 按鈕的出現（類別方法）
+(void)launchButtonWithX:(float)x y:(float)y texture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i;

@end
