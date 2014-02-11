//
//  AppDelegate.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Profile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) MainViewController *mainViewController;
@property (nonatomic) Profile *currentProfile;

- (Profile *)getCurrentProfile;

@end
