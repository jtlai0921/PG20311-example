//
//  ShootingAppDelegate.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 作為應用程式委派的類別（自動建立）

#import "ShootingAppDelegate.h"
#import "ShootingViewController.h"
#import "Common.h"

@implementation ShootingAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationWillResignActive:(UIApplication *)application
{
	[viewController stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[viewController startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[viewController stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
	[viewController release];
	[window release];
	
	[super dealloc];
}

@end
