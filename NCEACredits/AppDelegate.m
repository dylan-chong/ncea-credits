//
//  AppDelegate.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (Profile *)getCurrentProfile {
    if (_currentProfile)
        return _currentProfile;
    else {
#warning TODO: load JSON (and save a file that says which one should be loaded next time)
        Profile *p = [[Profile alloc] initWithPropertiesOrNil:nil];
        _currentProfile = p;
        return p;
    }
}

- (void)saveCurrentProfile {
   
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Screen    ************************************
//*************************
//****************
//*********
//****
//*

- (CGSize)getScreenSize {
    if (!CGSizeEqualToSize(_screenSize, CGSizeZero))
        return _screenSize;
    else {
        _screenSize = [AppDelegate getScreenSizeBasedOnCurrentOrientation];
        return _screenSize;
    }
}

+ (CGSize)getScreenSizeBasedOnCurrentOrientation {
    //Only use if initial _screenSize does not exist
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}

- (void)setScreenSize:(CGSize)size {
    //Set this when the viewWillTransitionToSize: withTransitionCoordinator: method is called
    _screenSize = size;
}

- (BOOL)deviceIsInLandscape {
    CGSize screenSize = [AppDelegate getScreenSizeBasedOnCurrentOrientation];
    if (screenSize.width > screenSize.height) return YES;
    else return NO;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Delegate    ************************************
//*************************
//****************
//*********
//****
//*

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
