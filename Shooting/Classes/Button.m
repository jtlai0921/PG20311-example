//
//  Button.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Button.h"
#import "Common.h"

// 按鈕類別
@implementation HPButton

// 材質、尺寸、按鈕編號的設定
-(void)setTexture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i {
	
	// 材質、尺寸、按鈕編號
	texture=t;
	width=w;
	height=h;
	index=i;
	
	// alpha值、顏色、放大縮小率、狀態
	alpha=0.9f;
	color=1;
	scale=0;
	state=1;
}

// 顏色、alpha值、放大縮小率的補間運算
-(void)interpolateColor:(GLfloat)c alpha:(GLfloat)a scale:(GLfloat)s {
	const float f=0.05f;
	if (fabs(c-color)<f) color=c; else color+=(c<color)?-f:f;
	if (fabs(a-alpha)<f) alpha=a; else alpha+=(a<alpha)?-f:f;
	if (fabs(s-scale)<f) scale=s; else scale+=(s<scale)?-f:f;
}

// 移動
-(BOOL)move {
	
	// 依照狀態分開處理
	switch (state) {
		
		// 狀態1（出現）
		case 1:
			
			// 稍微有點暗，完全不透明，原本的尺寸
			[self interpolateColor:0.9f alpha:1 scale:1];
			
			// 若觸控按鈕就轉移到狀態2
			if (!previousTouched && touched && 
				fabs(touchX-positionX)<width && fabs(touchY-positionY)<height
			) {
				state=2;
			}
			break;
		
		// 狀態2（按下）
		case 2:
			
			// 稍微有點亮，完全不透明，稍大的尺寸
			[self interpolateColor:1.2f alpha:1 scale:1.2f];
			
			// 如果在按鍵內側觸碰並離開就轉移到狀態3
			if (fabs(touchX-positionX)<width && fabs(touchY-positionY)<height) {
				if (!touched) {
					buttonIndex=index;
					[buttonPlayer play];
					state=3;
				}
			} else 
			
			// 手指若跑出按鈕外側就轉移到狀態1
			{
				state=1;
			}
			break;
		
		// 狀態3（刪除）
		case 3:
			
			// 稍微有點亮，完全透明，尺寸為0
			[self interpolateColor:1.2f alpha:0 scale:0];
			
			// 如果變成完全透明就轉移到狀態-1
			if (alpha==0) {
				state=-1;
			}
			break;
	}
	
	// 狀態為-1就回傳NO，其它狀態就回傳YES
	return state!=-1;
}

// 描繪
-(void)draw {
	[texture drawWithX:positionX y:positionY 
		width:width*scale height:height*scale 
		red:color green:color blue:color alpha:alpha 
		rotation:0];
}

// 按鈕的出現（類別方法）
+(void)launchButtonWithX:(float)x y:(float)y texture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i {
	HPButton* b=[buttonPool addObject];
	[b setX:x y:y speed:0 angle:0];
	[b setTexture:t width:w height:h index:i];
}

@end
