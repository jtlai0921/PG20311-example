//
//  ShootingViewController.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 作為View的控制器的類別（自動建立）

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface ShootingViewController : UIViewController
{
	EAGLContext *context;
	GLuint program;
	
	BOOL animating;
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	/*
	 Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	 CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	 The NSTimer object is used only as fallback when running on a pre-3.1 device where CADisplayLink isn't available.
	 */
	id displayLink;
	NSTimer *animationTimer;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;

@end
