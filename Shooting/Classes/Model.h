//
//  Model.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "Texture.h"

// 模型類別（使用頂點緩充器物件描繪）
@interface HPModel : NSObject {
	
	// 材質
	HPTexture* hpTexture;
	
	// 頂點座標、材質座標、頂點編號
	GLuint positionsBuffer, texCoordsBuffer, indicesBuffer;
	
	// 頂點編號個數
	GLsizei indicesCount;
}

// 初始化
-(id)initWithPositions:(GLfloat*)p positionsSize:(GLsizei)ps 
	texCoords:(GLfloat*)t texCoordsSize:(GLsizei)ts 
	indices:(GLushort*)i indicesSize:(GLsizei)is 
	texFile:(NSString*)file;

// 拋棄
-(void)dealloc;

// 描繪
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz;

@end

//-------------------------------------------------------------------------

// 模型類別（使用陣列描繪）
/*
@interface HPModel : NSObject {
	
	// 材質
	HPTexture* hpTexture;
	
	// 頂點座標、材質座標
	GLfloat *positions, *texCoords;
	
	// 頂點編號
	GLushort* indices;
	
	// 頂点番号数
	GLsizei indicesCount;
}

// 初始化
-(id)initWithPositions:(GLfloat*)p texCoords:(GLfloat*)t 
	indices:(GLushort*)i indicesCount:(GLsizei)c texFile:(NSString*)file;

// 拋棄
-(void)dealloc;

// 描繪
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz;

@end
*/

