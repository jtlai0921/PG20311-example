//
//  ShootingViewController.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 作為View的控制器的類別（自動建立）
// 追加檢測觸控、遊戲本體初始化等處理

#import <QuartzCore/QuartzCore.h>
#import "ShootingViewController.h"
#import "EAGLView.h"
#import "Common.h"

@interface ShootingViewController ()
@property (nonatomic, retain) EAGLContext *context;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ShootingViewController

@synthesize animating, context;

// 追加檢測觸控的處理

// 觸控後直接滑動時要呼叫的方法
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// 保存上次是否為觸控狀態
	previousTouched=touched;
	
	// 取得在View當中觸控的座標
	CGPoint p=[[touches anyObject] locationInView:[self view]];
	
	// 轉換成遊戲的座標系（X方向為-1到1、Y方向為-1.5到1.5等等）
	CGRect r=[[self view] bounds];
	touchX=(p.x*2/r.size.width-1)*screenWidth;
	touchY=(1-p.y*2/r.size.height)*screenHeight;
	
	// iPad環境下變更View port時的座標修正
	touchX*=r.size.width/r.size.height*screenHeight;
}

// 觸控開始時要呼叫的方法
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// 呼叫共用的處理（滑動時的處理）
	[self touchesMoved:touches withEvent:event];
	
	// 將狀態設為「觸控中」
	touched=YES;
}

// 觸控結束的時候（手指離開）要呼叫的方法
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {

	// 呼叫共用的處理（滑動時的處理）
	[self touchesMoved:touches withEvent:event];

	// 將狀態設為「觸控中」
	touched=NO;
}

// 觸控被中斷時（例如來電等情況）要呼叫的方法
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {

	// 呼叫共用的處理（滑動時的處理）
	[self touchesMoved:touches withEvent:event];

	// 將狀態設為「非觸控中」
	touched=NO;
}

// View controller初始化時要呼叫的方法
- (void)awakeFromNib
{
	// 下列程式碼為在iOS模擬器中執行OpenGL ES 2.0
	EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

	// 在iOS模擬器中執行OpenGL ES 1.1的除錯時，要設定成以下的處理
	// EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	
	if (!aContext)
	{
		aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	}
	
	if (!aContext)
		NSLog(@"Failed to create ES context");
	else if (![EAGLContext setCurrentContext:aContext])
		NSLog(@"Failed to set ES context current");
	
	self.context = aContext;
	[aContext release];
	
	[(EAGLView *)self.view setContext:context];
	[(EAGLView *)self.view setFramebuffer];
	
    if ([context API] == kEAGLRenderingAPIOpenGLES2)
        [self loadShaders];
	
	animating = FALSE;
	displayLinkSupported = FALSE;
	animationFrameInterval = 1;
	displayLink = nil;
	animationTimer = nil;
	
	// Use of CADisplayLink requires iOS version 3.1 or greater.
	// The NSTimer object is used as fallback when it isn't available.
	NSString *reqSysVer = @"3.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
		displayLinkSupported = TRUE;

	// 為了使用來自遊戲本體程式碼的OpenGL ES的context和著色器（program）
	// 要先代入全域變數（glContext, glProgram）
	glContext=context;
	glProgram=program;
	
	// 製作遊戲本體的類別（HPGmae）的實體
	game=[[HPGame alloc] init];
}

// View controller的拋棄
- (void)dealloc
{
	// 拋棄遊戲本體的實體
	[game release];
	
	if (program)
	{
		glDeleteProgram(program);
		program = 0;
	}
	
	// Tear down context.
	if ([EAGLContext currentContext] == context)
		[EAGLContext setCurrentContext:nil];
	
	[context release];
	
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self startAnimation];
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self stopAnimation];
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	if (program)
	{
		glDeleteProgram(program);
		program = 0;
	}

	// Tear down context.
	if ([EAGLContext currentContext] == context)
		[EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (NSInteger)animationFrameInterval
{
	return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
	/*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void)startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			/*
			 CADisplayLink is API new in iOS 3.1. Compiling against earlier versions will result in a warning, but can be dismissed if the system version runtime check for CADisplayLink exists in -awakeFromNib. The runtime check ensures this code will not be called in system versions earlier than 3.1.
			*/
			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawFrame)];
			[displayLink setFrameInterval:animationFrameInterval];
			
			// The run loop will retain the display link on add.
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawFrame) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}

- (void)drawFrame
{
	//---------------------------------------------------------------
	[game move];
	[(EAGLView *)self.view setFramebuffer];
	[game draw];
	[(EAGLView *)self.view presentFramebuffer];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
	GLint status;
	const GLchar *source;
	
	source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
	if (!source)
	{
		NSLog(@"Failed to load vertex shader");
		return FALSE;
	}
	
	*shader = glCreateShader(type);
	glShaderSource(*shader, 1, &source, NULL);
	glCompileShader(*shader);
	
#if defined(DEBUG)
	GLint logLength;
	glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0)
	{
		GLchar *log = (GLchar *)malloc(logLength);
		glGetShaderInfoLog(*shader, logLength, &logLength, log);
		NSLog(@"Shader compile log:\n%s", log);
		free(log);
	}
#endif
	
	glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
	if (status == 0)
	{
		glDeleteShader(*shader);
		return FALSE;
	}
	
	return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
	GLint status;
	
	glLinkProgram(prog);
	
#if defined(DEBUG)
	GLint logLength;
	glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0)
	{
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(prog, logLength, &logLength, log);
		NSLog(@"Program link log:\n%s", log);
		free(log);
	}
#endif
	
	glGetProgramiv(prog, GL_LINK_STATUS, &status);
	if (status == 0)
		return FALSE;
	
	return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
	GLint logLength, status;
	
	glValidateProgram(prog);
	glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0)
	{
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(prog, logLength, &logLength, log);
		NSLog(@"Program validate log:\n%s", log);
		free(log);
	}
	
	glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
	if (status == 0)
		return FALSE;
	
	return TRUE;
}

- (BOOL)loadShaders
{
	GLuint vertShader, fragShader;
	NSString *vertShaderPathname, *fragShaderPathname;
	
	// Create shader program.
	program = glCreateProgram();
	
	// Create and compile vertex shader.
	vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
	if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
	{
		NSLog(@"Failed to compile vertex shader");
		return FALSE;
	}
	
	// Create and compile fragment shader.
	fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
	if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
	{
		NSLog(@"Failed to compile fragment shader");
		return FALSE;
	}
	
	// Attach vertex shader to program.
	glAttachShader(program, vertShader);
	
	// Attach fragment shader to program.
	glAttachShader(program, fragShader);
	
	// Bind attribute locations.
	// This needs to be done prior to linking.
//	glBindAttribLocation(program, ATTRIB_VERTEX, "position");
//	glBindAttribLocation(program, ATTRIB_COLOR, "color");
	
	// Link program.
	if (![self linkProgram:program])
	{
		NSLog(@"Failed to link program: %d", program);
		
		if (vertShader)
		{
			glDeleteShader(vertShader);
			vertShader = 0;
		}
		if (fragShader)
		{
			glDeleteShader(fragShader);
			fragShader = 0;
		}
		if (program)
		{
			glDeleteProgram(program);
			program = 0;
		}
		
		return FALSE;
	}
	
	// Get uniform locations.
//	uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
	
	// Release vertex and fragment shaders.
	if (vertShader)
		glDeleteShader(vertShader);
	if (fragShader)
		glDeleteShader(fragShader);
	
	return TRUE;
}

@end
