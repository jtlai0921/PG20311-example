//
//  Texture.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 材質的類別

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface HPTexture : NSObject {
	
	// OpenGL ES的材質名稱
	GLuint texture;
}

// 讀取檔案
-(id)initWithFile:(NSString*)file;

// 拋棄
-(void)dealloc;

// 描繪（設有材質座標）
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
	fromU:(GLfloat)fu fromV:(GLfloat)fv toU:(GLfloat)tu toV:(GLfloat)tv;

// 描画（未設有材質座標）
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot;

// 取得材質名稱
-(GLuint)glTexture;

@end

