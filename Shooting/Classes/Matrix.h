//
//  Matrix.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 矩陣計算用的函數群

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>

// 單位矩陣
extern void hpMatrixIdentity(GLfloat* m);

// 矩陣積
extern void hpMatrixMultiply(GLfloat* m, const GLfloat* n);

// 放大縮小
extern void hpMatrixScale(GLfloat* m, GLfloat x, GLfloat y, GLfloat z);

// 旋轉（X軸、Y軸、Z軸）
extern void hpMatrixRotateX(GLfloat* m, GLfloat r);
extern void hpMatrixRotateY(GLfloat* m, GLfloat r);
extern void hpMatrixRotateZ(GLfloat* m, GLfloat r);

// 平行移動
extern void hpMatrixTranslate(GLfloat* m, GLfloat x, GLfloat y, GLfloat z);

// 映射轉換
extern void hpMatrixProjection(GLfloat* m, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat fz);
