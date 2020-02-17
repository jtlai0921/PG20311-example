//
//  Shader.fsh
//  Shooting
//
//  Created by hig on 10/10/18.
//  Copyright 2010 HigPen Works. All rights reserved.
//

uniform sampler2D texture;
//uniform lowp vec4 color;
uniform highp vec4 color;

//varying lowp vec2 vTexCoord;
varying highp vec2 vTexCoord;

void main() {
	gl_FragColor=color*texture2D(texture, vTexCoord);
}

/*
uniform sampler2D texture;

varying lowp vec4 vColor;
varying lowp vec2 vTexCoord;

void main() {
	gl_FragColor=vColor*texture2D(texture, vTexCoord);
}
*/

