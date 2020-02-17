//
//  BossModel.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 魔王的3D模型

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>

// 頂點座標
extern GLfloat bossPositions[];

// 頂點編號
extern GLushort bossIndices[];

// 材質座標
extern GLfloat bossTexCoords[];

// 頂點編號個數
extern GLsizei bossIndicesCount;

// 頂點座標、材質座標、頂點標號的byte數
extern GLsizei bossPositionsSize, bossTexCoordsSize, bossIndicesSize;

