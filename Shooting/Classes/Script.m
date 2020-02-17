//
//  Script.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Boss.h"
#import "Common.h"
#import "Enemy.h"
#import "Script.h"

// 小程式指令類別
@implementation HPScriptCommand

//初始化
-(id)initWithString:s {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		
		// 用,將小程式的文字串隔開
		NSArray* a=[s componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		// 要素有5個時解釋為敵人出現指令
		if ([a count]==5) {
			wait=0;
			type=[[a objectAtIndex:0] intValue];
			positionX=[[a objectAtIndex:1] floatValue];
			positionY=[[a objectAtIndex:2] floatValue];
			speed=[[a objectAtIndex:3] floatValue];
			angle=[[a objectAtIndex:4] floatValue];
		} else
			
		//  要素有5個時解釋為待機指令
		if ([a count]==1) {
			type=-1;
			wait=[[a objectAtIndex:0] intValue];
		}
	}
	return self;
}

// 執行
-(NSInteger)run {
	
	// 若為魔王出現的指令，就讓魔王出現
	if (type==2) {
		[HPBoss launchBoss];
	} else
	
	// 若為魔王出現的指令，就讓敵人出現
	if (type>=0) {
		[HPEnemy launchEnemyWithX:positionX	y:positionY speed:speed angle:angle type:type];
	}
	
	// 回傳代機時間（等級變高的話待機時間就變短）
	return wait/rank;
}

@end


// 小程式類別
@implementation HPScript

//  初始化
-(id)initWithFile:(NSString*)file {
	
	// 父類別部分的初始化
	self=[super init];
	
	// 子類別部分的初始化
	if (self!=nil) {
		
		// 將指令的陣列初始化
		command=[[NSMutableArray alloc] init];
		
		// 讀取小程式的檔案
		NSString* path=[[NSBundle mainBundle] pathForResource:file ofType:@"txt"];
		NSString* text=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
		
		// 以行單位分割小程式
		NSArray* lines=[text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		// 解釋小程式的每一行
		for (NSString* line in lines) {
			
			// 跳過指令那一行，指令之外的行就用小程式類別來解釋
			if ([line length]>0 && [line rangeOfString:@"//"].location==NSNotFound) {
				[command addObject:[[[HPScriptCommand alloc] initWithString:line] autorelease]];
			}
		}
		
		// 不使用for-in語法（快速列舉），使用一般的for寫出下面的程式也可以
		/*
		for (NSInteger i=0; i<[lines count]; i++) {
			NSString* line=[lines objectAtIndex:i];
		*/		
	}
	return self;
}

// 拋棄
-(void)dealloc {
	[command release];
	[super dealloc];
}

// 重新啟動
-(void)reset {
	index=wait=0;
}

// 移動（執行）
-(BOOL)move {
	
	// 魔王出現的時候不執行小程式
	if ([bossPool objectCount]==0) {
		
		// 直到出現待機指令為止，都要持續執行指令
		while (wait==0 && index<[command count]) {
			wait=[(HPScriptCommand*)[command objectAtIndex:index] run];
			index++;
		}
		
		// 減少待機時間
		wait--;
	}
	
	// 若執行到小程式末端就回傳NO
	return wait>=0;
}

@end
