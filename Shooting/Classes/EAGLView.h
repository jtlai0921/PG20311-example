//
//  EAGLView.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 對應OpenGL的View的類別（自動建立）

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

// 對應OpenGL的View的類別
// 追加深度render緩衝器的宣告
// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer.
	GLint framebufferWidth;
	GLint framebufferHeight;
	
	// 追加深度render緩衝器（depthRenderbuffer）的宣告
	// The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
	GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;
}

@property (nonatomic, retain) EAGLContext *context;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end
