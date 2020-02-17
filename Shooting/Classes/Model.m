//
//  Model.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Model.h"
#import "Matrix.h"

// 模型類別（使用頂點緩充器物件描繪）
@implementation HPModel

// 初始化（使用陣列將3D模型初始化）
-(id)initWithPositions:(GLfloat*)p positionsSize:(GLsizei)ps 
	texCoords:(GLfloat*)t texCoordsSize:(GLsizei)ts 
	indices:(GLushort*)i indicesSize:(GLsizei)is 
	texFile:(NSString*)file
{
	// 父類別部分的初始化
	self=[super init];
	
	// 父類別部分的初始化
	if (self!=nil) {
		
		// 材質
		hpTexture=[[HPTexture alloc] initWithFile:file];
		
		// 頂點編號個數
		indicesCount=is/sizeof(GLushort);
		
		// 頂點座標
		glGenBuffers(1, &positionsBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, positionsBuffer);
		glBufferData(GL_ARRAY_BUFFER, ps, p, GL_STATIC_DRAW);
		
		// 材質座標
		glGenBuffers(1, &texCoordsBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordsBuffer);
		glBufferData(GL_ARRAY_BUFFER, ts, t, GL_STATIC_DRAW);
		
		// 頂點標號
		glGenBuffers(1, &indicesBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, is, i, GL_STATIC_DRAW);
		
		// 緩衝器的繫結
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	}
	return self;
}

// 拋棄
-(void)dealloc {
	[hpTexture release];
	glDeleteBuffers(1, &positionsBuffer);
	glDeleteBuffers(1, &texCoordsBuffer);
	glDeleteBuffers(1, &indicesBuffer);
	[super dealloc];
}

// 描繪
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz 
{
	// 視點、前方平面、後方平面的各個Z座標視點
	const GLfloat eye=10, nearZ=5, farZ=100;
	
	// 矩陣的計算
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	s*=eye/nearZ;
	hpMatrixScale(matrix, s, s, s);
	hpMatrixRotateX(matrix, rx);
	hpMatrixRotateY(matrix, ry);
	hpMatrixRotateZ(matrix, rz);
	hpMatrixTranslate(matrix, x, y, z-eye);
	hpMatrixTranslate(matrix, x, y, z);
	hpMatrixProjection(matrix, screenWidth, screenHeight, nearZ, farZ);

	// 以下的放大縮小因為和上述的映射轉換一起執行所以可以省略
	// hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, -1);
	
	
	// OpenGL ES 2.0的處理
	if (glContext.API==kEAGLRenderingAPIOpenGLES2) {
		
		// 著色器、材質、矩陣、顏色的設定
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glUniform4f(glUniformColor, r, g, b, a);
		
		// 頂點座標、材質座標的設定
		glBindBuffer(GL_ARRAY_BUFFER, positionsBuffer);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordsBuffer);
		glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, 0);
		
		// 著色器的驗證
		glValidateProgram(glProgram);
	} else 
	
	// OpenGL ES 1.1的處理
	{
		// 顏色的設定
		glColor4f(r, g, b, a);
		glBindBuffer(GL_ARRAY_BUFFER, positionsBuffer);
		
		// 頂點座標、材質座標的設定
		glVertexPointer(3, GL_FLOAT, 0, 0);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordsBuffer);
		glTexCoordPointer(2, GL_FLOAT, 0, 0);
		
		// 矩陣的設定
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }
	
	// 啟用深度檢測
	glEnable(GL_DEPTH_TEST);
	
	// 啟用Culling
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	
	// 材質的設定
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, [hpTexture glTexture]);
	
	// 多邊形的描繪
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
	glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_SHORT, 0);
	
	// 緩衝器的釋放
	glBindBuffer(GL_ARRAY_BUFFER, 0);	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	
	// 停用深度測試與Culling
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);
}

@end

//-------------------------------------------------------------------------

// 模型類別（使用陣列來描繪）
/*
@implementation HPModel

// 初始化
-(id)initWithPositions:(GLfloat*)p texCoords:(GLfloat*)t 
	indices:(GLushort*)i indicesCount:(GLsizei)c texFile:(NSString*)file
{
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		
		// 材質
		hpTexture=[[HPTexture alloc] initWithFile:file];
		
		// 頂點座標、材質座標、頂點編號
		positions=p;
		texCoords=t;
		indices=i;
		
		// 頂點編號個數
		indicesCount=c;
	}
	return self;
}

// 拋棄
-(void)dealloc {
	[hpTexture release];
	[super dealloc];
}

// 描繪
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz 
{
	// 視點、前方平面、後方平面的各個Z座標
	const GLfloat eye=10, nearZ=5, farZ=15;
	
	// 矩陣的計算（執行映射轉換時）
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	s*=eye/nearZ;
	hpMatrixScale(matrix, s, s, s);
	hpMatrixRotateX(matrix, rx);
	hpMatrixRotateY(matrix, ry);
	hpMatrixRotateZ(matrix, rz);
	hpMatrixTranslate(matrix, x, y, z-eye);
	hpMatrixProjection(matrix, screenWidth, screenHeight, nearZ, farZ);
	
	// 矩陣的計算（不執行映射轉換時）
	// GLfloat matrix[16];
	// hpMatrixIdentity(matrix);
	// hpMatrixScale(matrix, s, s, s);
	// hpMatrixRotateX(matrix, rx);
	// hpMatrixRotateY(matrix, ry);
	// hpMatrixRotateZ(matrix, rz);
	// hpMatrixTranslate(matrix, x, y, z);
	// hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, -1);
	
	// OpenGL ES 2.0的處理
	if (glContext.API==kEAGLRenderingAPIOpenGLES2) {
		
		// 著色器、材質、矩陣、顏色的設定
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glUniform4f(glUniformColor, r, g, b, a);
		
		// 頂點座標、材質座標的設定
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, positions);
		glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
		
		// 著色器的驗證
		glValidateProgram(glProgram);
	} else 
	
	// OpenGL ES 1.1的處理
	{
		// 顏色的設定
		glColor4f(r, g, b, a);
		
		// 頂點座標、材質座標的設定
		glVertexPointer(3, GL_FLOAT, 0, positions);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		
		// 矩陣的設定
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }
	
	// 啟用深度檢測
	glEnable(GL_DEPTH_TEST);
	
	// 啟用Culling
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	
	// 材質的設定
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, [hpTexture glTexture]);
	
	// 多邊形的描繪
	glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_SHORT, indices);
	
	// 停用深度檢測與Culling
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);
}

@end
*/

