//
//  Shader.fsh
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 片段著色器（不使用頂點色時）

// 材質
uniform sampler2D texture;

// 整體色（模型整體共用）
uniform lowp vec4 color;

// 材質座標
varying lowp vec2 vTexCoord;

// 著色器本體
void main() {

	// 將頂點色與材質顏色相乘後輸出
	gl_FragColor=color*texture2D(texture, vTexCoord);
}

//-------------------------------------------------------------------------

// 片段著色器（使用頂點色時）
/*

// 材質
uniform sampler2D texture;

// 頂點色（每個頂點不同）
varying lowp vec4 vColor;

// 材質座標
varying lowp vec2 vTexCoord;

// 著色器本體
void main() {

	// 將頂點色與材質顏色相乘後輸出
	gl_FragColor=vColor*texture2D(texture, vTexCoord);
}

*/

