//
//  main.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import <UIKit/UIKit.h>

// Main Routine（自動建立）
int main(int argc, char *argv[]) {
	
	// 建立自動釋放池
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// 執行應用程式的Main Routine
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    
	// 釋放自動釋放池
	[pool release];
	
	// 結束
    return retVal;
}
