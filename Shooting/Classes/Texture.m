//
//  Texture.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 材質的類別

#import "Common.h"
#import "Texture.h"
#import "Matrix.h"

@implementation HPTexture

// 讀取檔案
-(id)initWithFile:(NSString*)file {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		
		// 讀取圖案
		CGImageRef image=[UIImage imageNamed:file].CGImage;
		if (!image) {
			NSLog(@"Error: %@ is not found.", file);
			return 0;
		}
		
		// 在記憶體上描繪像素
		size_t w=CGImageGetWidth(image), h=CGImageGetHeight(image);
		GLubyte* data=(GLubyte*)calloc(1, w*h*4);
		CGContextRef context=CGBitmapContextCreate(data, w, h, 8, w*4, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(context, CGRectMake(0, 0, (CGFloat)w, (CGFloat)h), image);
		CGContextRelease(context);
		
		// 製作材質
		glGenTextures(1, &texture);
		glBindTexture(GL_TEXTURE_2D, texture);
		
		// 設定材質的濾鏡（執行線狀補間運算）
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

		// 設定材質的濾鏡（取得距離最近的點）
		// glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		// glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		
		// 對材質設定像素
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
		
		// 釋放記憶體
		free(data);
	}
	return self;
}

// 拋棄
-(void)dealloc {
	if (texture) {
		glDeleteTextures(1, &texture);
	}
	[super dealloc];
}

// 取得材質名稱
-(GLuint)glTexture {
	return texture;
}

// 描繪（無材質座標的設定）
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
{
	// 呼叫有材質的描繪處理
	[self drawWithX:x y:y width:w height:h red:r green:g blue:b alpha:a rotation:rot fromU:0.0f fromV:0.0f toU:1.0f toV:1.0f];
}

// 描繪（有材質座標的設定）
// 不使用頂點
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
	fromU:(GLfloat)fu fromV:(GLfloat)fv toU:(GLfloat)tu toV:(GLfloat)tv 
{
	// 頂點座標
	const GLfloat positions[]={
		-1, -1, 1, -1, -1, 1, 1, 1
	};
	
	// 材質座標
	const GLfloat texCoords[]={
		fu, tv, tu, tv, fu, fv, tu, fv
	};
	
	// 矩陣（為了提昇速度，直接計算最後的矩陣）
	GLfloat c=cosf(rot*M_PI*2), s=sinf(rot*M_PI*2);
	GLfloat matrix[16]={
		c*w/screenWidth, s*w/screenHeight, 0, 0,
		-s*h/screenWidth, c*h/screenHeight, 0, 0,
		0, 0, 1, 0, 
		x/screenWidth, y/screenHeight, 0, 1
	};
		
	// 矩陣（使用矩陣用的函數群）
	/*
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	hpMatrixScale(matrix, w, h, 1);
	hpMatrixRotateZ(matrix, rot);
	hpMatrixTranslate(matrix, x, y, 0);
	hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, 1);
	*/
	
	// OpenGL ES 2.0的處理
	if (glContext.API==kEAGLRenderingAPIOpenGLES2) {
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glUniform4f(glUniformColor, r, g, b, a);
		glVertexAttribPointer(0, 2, GL_FLOAT, 0, 0, positions);
		glVertexAttribPointer(1, 2, GL_FLOAT, 0, 0, texCoords);
		glValidateProgram(glProgram);
	} else 
	
	// OpenGL ES 1.1的處理
	{
		glVertexPointer(2, GL_FLOAT, 0, positions);
		glColor4f(r, g, b, a);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }

	// OpenGL ES 2.0/1.1共用的處理
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//-------------------------------------------------------------------------

// 描繪（有材質座標的設定）
// 使用頂點色
/*
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
			 red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
		   fromU:(GLfloat)fu fromV:(GLfloat)fv toU:(GLfloat)tu toV:(GLfloat)tv 
{
 	// 頂點座標
	const GLfloat positions[]={
		-1, -1, 1, -1, -1, 1, 1, 1
	};

	// 頂點色
	const GLfloat colors[]={
		r, g, b, a, r, g, b, a, r, g, b, a, r, g, b, a
	};

	// 材質座標
	const GLfloat texCoords[]={
		fu, tv, tu, tv, fu, fv, tu, fv
	};
	
	// 矩陣
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	hpMatrixScale(matrix, w, h, 1);
	hpMatrixRotateZ(matrix, rot);
	hpMatrixTranslate(matrix, x, y, 0);
	hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, 1);
	
	// OpenGL ES 2.0的處理
	if ([glContext API]==kEAGLRenderingAPIOpenGLES2) {
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glVertexAttribPointer(0, 2, GL_FLOAT, 0, 0, positions);
		glVertexAttribPointer(1, 4, GL_FLOAT, 0, 0, colors);
		glVertexAttribPointer(2, 2, GL_FLOAT, 0, 0, texCoords);
		glValidateProgram(glProgram);
	} else 
 
	// OpenGL ES 1.1的處理
	{
		glVertexPointer(2, GL_FLOAT, 0, positions);
		glColorPointer(4, GL_FLOAT, 0, colors);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }
	
	// OpenGL ES 2.0/1.1共用的處理
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
*/

@end

