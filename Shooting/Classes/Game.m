//
//  Game.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 遊戲本體的類別

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "Boss.h"
#import "Bullet.h"
#import "Button.h"
#import "BossModel.h"
#import "Common.h"
#import "Game.h"
#import "Mover.h"
#import "Enemy.h"
#import "Weapon.h"
#import "Number.h"
#import "Script.h"
#import "Texture.h"

// 遊戲本體的類別
@implementation HPGame

// 用於檢測加速度的委派
-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	accelerationX=[acceleration x];
	accelerationY=[acceleration y];
	accelerationZ=[acceleration z];
}

// 設定的儲存
-(void)save {
	
	// 保存最高得分與操作類型的設定
	NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
	[def setInteger:topScore forKey:@"topScore"];
	[def setInteger:controlType forKey:@"controlType"];
	[def synchronize];
}

// 設定的下載
-(void)load {
	
	// 製作最高得分與操作類型的初始值
	NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:0], @"topScore",
		[NSNumber numberWithInt:0], @"controlType", 
		nil];

	// 讀取最高得分與操作類型的設定
	NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
	[def registerDefaults:dic];
	topScore=[def integerForKey:@"topScore"];
	controlType=[def integerForKey:@"controlType"];
}

// 讀取音效檔
-(AVAudioPlayer*)playerWithFile:file {
	
	// 製作檔案的路徑與URL
	NSString* path=[[NSBundle mainBundle] pathForResource:file ofType:@"caf"];
	NSURL* url=[NSURL fileURLWithPath:path];
	
	// 由檔案製作播放器
	AVAudioPlayer* player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[player prepareToPlay];
	
	// 回傳播放器的實體＝
	return [player autorelease];
}

// 初始化
-(id)init {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		
		// 讀取材質
		bulletTexture=[[HPTexture alloc] initWithFile:@"Bullet.png"];
		myShipTexture[0]=[[HPTexture alloc] initWithFile:@"MyShip0.png"];
		myShipTexture[1]=[[HPTexture alloc] initWithFile:@"MyShip1.png"];
		myShipDestroyedTexture=[[HPTexture alloc] initWithFile:@"MyShipDestroyed.png"];
		enemyTexture[0]=[[HPTexture alloc] initWithFile:@"Enemy0.png"];
		enemyTexture[1]=[[HPTexture alloc] initWithFile:@"Enemy1.png"];
		weaponTexture=[[HPTexture alloc] initWithFile:@"Weapon.png"];
		padTexture=[[HPTexture alloc] initWithFile:@"Pad.png"];
		for (NSInteger i=0; i<10; i++) {
			numberTexture[i]=[[HPTexture alloc] initWithFile:[NSString stringWithFormat:@"Number%d.png",i]];
		}
		backgroundTexture=[[HPTexture alloc] initWithFile:@"Background.jpg"];
		titleTexture=[[HPTexture alloc] initWithFile:@"Title.png"];
		for (NSInteger i=0; i<3; i++) {
			controlTexture[i]=[[HPTexture alloc] initWithFile:[NSString stringWithFormat:@"Control%d.png",i]];
		}
		newRecordTexture=[[HPTexture alloc] initWithFile:@"NewRecord.png"];
		gameOverTexture=[[HPTexture alloc] initWithFile:@"GameOver.png"];
		
		// 讀取模型
		bossModel=[[HPModel alloc] initWithPositions:bossPositions positionsSize:bossPositionsSize 
			texCoords:bossTexCoords texCoordsSize:bossTexCoordsSize 
			indices:bossIndices indicesSize:bossIndicesSize texFile:@"Boss.jpg"];
		
		
		// 製作物件儲存池
		myShipPool=[[HPObjectPool alloc] initWithClass:HPMyShip.class];
		bulletPool=[[HPObjectPool alloc] initWithClass:HPBullet.class];
		enemyPool=[[HPObjectPool alloc] initWithClass:HPEnemy.class];
		weaponPool=[[HPObjectPool alloc] initWithClass:HPWeapon.class];
		numberPool=[[HPObjectPool alloc] initWithClass:HPNumber.class];
		bossPool=[[HPObjectPool alloc] initWithClass:HPBoss.class];
		buttonPool=[[HPObjectPool alloc] initWithClass:HPButton.class];
		
		// 讀取小程式
		script=[[HPScript alloc] initWithFile:@"Script"];
		
		// 檢測加速度的準備（委派的登錄、設定告知的間隔）
		[UIAccelerometer sharedAccelerometer].delegate=self;
		[UIAccelerometer sharedAccelerometer].updateInterval=1.0/60;
			
		// OpenGL ES的初始化（2.0, 1.1共用的初始化）
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		if (glContext.API==kEAGLRenderingAPIOpenGLES2) {

			// OpenGL ES 2.0的初始化
			glUniformTexture=glGetUniformLocation(glProgram, "texture");
			glUniformMatrix=glGetUniformLocation(glProgram, "matrix");
			glUniformColor=glGetUniformLocation(glProgram, "color");
			glBindAttribLocation(glProgram, 0, "position");
			glBindAttribLocation(glProgram, 1, "coord");
 			glEnableVertexAttribArray(0);
			glEnableVertexAttribArray(1);
		} else {

			// OpenGL ES 1.1的初始化
			glEnable(GL_TEXTURE_2D);
			glEnableClientState(GL_VERTEX_ARRAY);
			glEnableClientState(GL_TEXTURE_COORD_ARRAY);			
		}

		// 音效的初始化
		// 設定音樂類型，讓音效與BGM同時播放
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

		// 讀取音效檔
		buttonPlayer=[[self playerWithFile:@"Button"] retain];
		hitPlayer=[[self playerWithFile:@"Hit"] retain];
		enemyPlayer=[[self playerWithFile:@"Enemy"] retain];
		bossPlayer=[[self playerWithFile:@"Boss"] retain];

		// BGM的初始化
		// 只有在用iOS裝置實機測試時，才編譯包含這個的處理
		#if !TARGET_IPHONE_SIMULATOR
		musicPlayer=[MPMusicPlayerController applicationMusicPlayer];
		[musicPlayer setQueueWithQuery:[MPMediaQuery albumsQuery]];		
		musicPlayer.repeatMode=MPMusicRepeatModeAll;
		musicPlayer.shuffleMode=MPMusicShuffleModeSongs;
		#endif
		
		// 遊戲的狀態的初始化（觸控的狀態、遊戲的狀態、捲軸位置、描繪次數）
		touched=NO;		
		state=1;
		backgroundY=0;
		drawTime=0;
		
		// 設定的下載
		[self load];
		
		// 調整長寬比
		glGetIntegerv(GL_VIEWPORT, (GLint*)&viewport);
		
		// 在iPad的環境下，畫面的橫向要契合iPhone的時候執行以下處理
		/*
		float sh=screenHeight;
		screenHeight=screenWidth*viewport.h/viewport.w;
		padY*=screenHeight/sh;
		*/

		// 在iPad的環境下，畫面的縱向要契合iPhone的時候執行以下處理
		/*
		float sw=screenWidth;
		screenWidth=screenHeight*viewport.w/viewport.h;
		padX*=screenWidth/sw;
		*/
		
		// 在iPad的環境下，將假想遙控面版的尺寸縮小
		if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
			padSize/=2;
			padX-=padSize;
			padY-=padSize;
		}		
	}
	return self;
}

// 拋棄
-(void)dealloc {
	
	// 小程式
	[script release];

	// 物件儲存池
	[myShip release];
	[bulletPool release];
	[enemyPool release];
	[weaponPool release];
	[numberPool release];
	[bossPool release];
	[buttonPool release];

	// 材質
	[bulletTexture release];
	[myShipTexture[0] release];
	[myShipTexture[1] release];
	[myShipDestroyedTexture release];
	[enemyTexture[0] release];
	[enemyTexture[1] release];
	[weaponTexture release];
	[padTexture release];
	for (NSInteger i=0; i<10; i++) {
		[numberTexture[i] release];
	}
	[titleTexture release];
	for (NSInteger i=0; i<3; i++) {
		[controlTexture[i] release];
	}
	[newRecordTexture release];
	[gameOverTexture release];

	// 模型
	[bossModel release];

	// 音效
	[buttonPlayer release];
	[hitPlayer release];
	[enemyPlayer release];
	[bossPlayer release];
	
	[super dealloc];
}

// 移動
-(void)move {
	
	// 依照遊戲的狀態分開處理
	switch (state) {
			
		// 標題準備
		case 1:
			
			// 顯示標題、操作類型、最高得分
			if ([buttonPool objectCount]==0) {
				buttonIndex=-1;
				[HPButton launchButtonWithX:0 y:0.25f texture:titleTexture width:1 height:1 index:0];
				[HPButton launchButtonWithX:0 y:-1 texture:controlTexture[controlType] width:1 height:0.25f index:1];
				[HPNumber launchNumberWithX:screenWidth-0.1f y:screenHeight-0.1f speed:0 angle:0 value:topScore drawSize:0.1f timeLimit:0];
				state=2;
			}
			break;
		
		// 標題
		case 2:
			switch (buttonIndex) {
				
				// 點選標題按鈕就開始遊戲
				case 0:
					[buttonPool removeObjectAtIndex:1];
					[HPMover clearObjectPool:numberPool];
					state=3;
					break;
				
				// 點選操作類型按鈕就變更操作類型
				case 1:
					controlType=(controlType+1)%3;
					[self save];
					buttonIndex=-1;
					[HPButton launchButtonWithX:0 y:-1 texture:controlTexture[controlType] width:1 height:0.25f index:1];
					break;
			}
			break;
			
		// 遊戲準備
		case 3:			
			if ([buttonPool objectCount]==0) {
				
				// 得分的顯示
				[HPNumber launchNumberWithX:screenWidth-0.1f y:screenHeight-0.1f speed:0 angle:0 value:0 drawSize:0.1f timeLimit:0];
				score=[numberPool objectAtIndex:0];
				
				// 自機出現
				[HPMyShip launchMyShip];
				
				// 開始小程式
				[script reset];
				
				// 等級的設定
				rank=1;
				
				// iOS裝置為實機的情況下播放BGM
				#if !TARGET_IPHONE_SIMULATOR
				[musicPlayer play];
				#endif

				state=4;
			}
			break;
			
		// 遊戲
		case 4:
			
			// 執行小程式
			if (![script move]) {
				[script reset];
			}
			
			// 移動自機、子彈、敵人等物件
			[HPMover moveObjectPool:myShipPool];
			[HPMover moveObjectPool:bulletPool];
			[HPMover moveObjectPool:enemyPool];
			[HPMover moveObjectPool:weaponPool];
			[HPMover moveObjectPool:numberPool];
			[HPMover moveObjectPool:bossPool];
			
			// 等級上升
			rank+=0.001f;
			
			// 自機若被破壞就轉移到Game over
			if ([myShipPool objectCount]==0) {
				
				// 如果得分沒有破紀錄就顯示Game over，有破紀錄就顯示Nre Record
				buttonIndex=-1;
				if (topScore<[score value]) {
					topScore=[score value];
					[self save];
					[HPButton launchButtonWithX:0 y:0 texture:newRecordTexture width:1 height:0.25f index:0];
				} else {
					[HPButton launchButtonWithX:0 y:0 texture:gameOverTexture width:1 height:0.25f index:0];
				}
				
				// iOS為實機執行的情況下，中斷BGM前進倒下一首曲子
				#if !TARGET_IPHONE_SIMULATOR
				[musicPlayer pause];
				[musicPlayer skipToNextItem];
				#endif

				state=5;
			}
			break;
		
		// Game over
		case 5:
			
			// 若點選Game over按鈕，就刪除子彈、敵人、武器等物件
			if (buttonIndex==0) {
				[HPMover clearObjectPool:bulletPool];
				[HPMover clearObjectPool:enemyPool];
				[HPMover clearObjectPool:weaponPool];
				[HPMover clearObjectPool:numberPool];
				[HPMover clearObjectPool:bossPool];
				state=1;
			}
			break;
			
	}
	
	// 移動按鈕
	[HPMover moveObjectPool:buttonPool];
	
	// 背景的捲軸
	backgroundY-=0.002f;
	backgroundY-=(NSInteger)backgroundY;
}

// 描繪
-(void)draw {
	
	// 若要將描繪的次數折半（每秒30影格），要執行下列處理
	/*
	drawTime=1-drawTime;
	if (drawTime!=0) return;
	*/

	// 在iPad的環境下，設定畫面兩側有留白的View port
//	GLsizei w=viewport.h*screenWidth/screenHeight;
//	glViewport((viewport.w-w)/2, 0, w, viewport.h);

	// 依照下列寫法，留白會出現在畫面右側
	// glViewport(0, 0, w, viewport.h);

	// 要顯示背景的話就執行下列處理
	// 清除深度緩衝器，描繪背景的材質
	glClear(GL_DEPTH_BUFFER_BIT);
	[backgroundTexture drawWithX:0.0f y:0.0f width:screenWidth height:screenHeight 
		red:1.0f green:1.0f blue:1.0f alpha:1.0f 
		rotation:0.0f fromU:0.0f fromV:backgroundY toU:1.0f toV:backgroundY+screenHeight];

 	// 不顯示背景的話就執行下列處理
	// 清除顏色緩衝器和深度緩衝器
	/*
	glClearColor(1, 1, 1, 1);
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	*/

	// 魔王、敵人、自機等物件的描繪
	[HPMover drawObjectPool:bossPool];
	[HPMover drawObjectPool:enemyPool];
	[HPMover drawObjectPool:myShipPool];
	[HPMover drawObjectPool:weaponPool];
	[HPMover drawObjectPool:bulletPool];
	[HPMover drawObjectPool:numberPool];
	[HPMover drawObjectPool:buttonPool];

	// 顯示假想遙控面版
	if ([myShipPool objectCount]>0 && controlType==2) {
		[padTexture drawWithX:padX y:padY width:padSize height:padSize 
			red:1.0f green:1.0f blue:1.0f alpha:0.4f rotation:0.0f];
	}
}

@end
