//
//  Shader.vsh
//  Shooting
//
//  Created by hig on 10/10/18.
//  Copyright 2010 HigPen Works. All rights reserved.
//

uniform mat4 matrix;

attribute vec4 position;
attribute vec2 texCoord;

varying vec2 vTexCoord;

void main() {
	gl_Position=matrix*position;
	vTexCoord=texCoord;
}

/*
uniform mat4 matrix;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vColor;
varying vec2 vTexCoord;

void main() {
	gl_Position=matrix*position;
	vColor=color;
	vTexCoord=texCoord;
}
*/
