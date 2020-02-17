//
//  Shader.vsh
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 頂點著色器（不使用頂點色時）

// 矩陣
uniform mat4 matrix;

// 頂點座標
attribute vec4 position;

// 材質座標
attribute vec2 texCoord;

// 材質座標（輸出給片段著色器）
varying vec2 vTexCoord;

// 著色器本體
void main() {

	// 以矩陣轉換頂點座標後輸出
	gl_Position=matrix*position;

	// 直接輸出材質座標
	vTexCoord=texCoord;
}

//-------------------------------------------------------------------------

// 頂點著色器（使用頂點色時）
/*

// 矩陣
uniform mat4 matrix;

// 頂點座標
attribute vec4 position;

// 頂點色（每個頂點不同）
attribute vec4 color;

// 材質座標
attribute vec2 texCoord;

// 頂點色（用來輸出給片段著色器）
varying vec4 vColor;

// 材質座標（用來輸出給片段著色器）
varying vec2 vTexCoord;

// 著色器本體
void main() {
	
	// 以矩陣轉換頂點座標後輸出
	gl_Position=matrix*position;

	// 直接輸出頂點色
	vColor=color;

	// 直接輸出材質座標
	vTexCoord=texCoord;
}

*/
