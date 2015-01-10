//
//  AppDelegate.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Styles.h"
#import "Profile.h"
#import "AppSettings.h"

@class MainViewController, AppSettings;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) MainViewController *mainViewController;
@property (nonatomic) Profile *currentProfile;
@property (nonatomic) CGSize screenSize;
@property (nonatomic) AppSettings *appSettings;
@property CGFloat statusBarHeight;

- (Profile *)getCurrentProfile;
- (AppSettings *)getAppSettings;

- (NSString *)getDocumentsDirectory;
- (void)saveCurrentProfileAndAppSettings;
- (void)deleteProfileWithProfileName:(NSString *)pName;
- (void)switchToProfile:(NSString *)name;
- (NSArray *)getUsedProfileNames;
- (void)setScreenSize:(CGSize)size;
- (CGSize)getScreenSize;
- (BOOL)deviceIsInLandscape;
- (CGFloat)getStatusBarHeight;

@end
