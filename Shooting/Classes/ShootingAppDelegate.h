//
//  ShootingAppDelegate.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 作為應用程式委派的類別（自動建立）

#import <UIKit/UIKit.h>

@class ShootingViewController;

@interface ShootingAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	ShootingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ShootingViewController *viewController;

@end

