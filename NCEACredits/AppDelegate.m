//
//  AppDelegate.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HomeButton.h"

#define FILE_EXTENSION_INCLUDING_DOT @".nceacredits"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self getStatusBarHeight];
    //For old versions
    [self checkForFilesWIthJSONExtension];
    
    return YES;
}

- (void)checkForFilesWIthJSONExtension {
    NSString *docsDir = [self getDocumentsDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *e;
    NSArray *files = [manager contentsOfDirectoryAtPath:docsDir error:&e];
    if (e) NSLog(@"%@", [e localizedDescription]);
    
    for (NSString *file in files) {
        if (![file isEqualToString:APP_SETTINGS_FILE_NAME_WITH_EXT]) {
            NSArray *components = [file componentsSeparatedByString:@"."];
            if ([[components lastObject] isEqualToString:@"json"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"You must delete the app due to updates. If you don't want to, rename all .json files in the documents directory to .nceacredits" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                break;
            }
        }
    }
}

- (Profile *)getCurrentProfile {
    if (_currentProfile) {
        //app count
        if (!_hasAddedToAppLaunchCount) {
            _currentProfile.appOpenTimes++;
            self.hasAddedToAppLaunchCount = YES;
        }
        return _currentProfile;
    } else {
        [self loadProfileWithFileName:CurrentAppSettings.lastProfileFileName];
        return _currentProfile;
    }
}

- (AppSettings *)getAppSettings {
    if (_appSettings)
        return _appSettings;
    else {
        [self loadAppSettings];
        return _appSettings;
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Save/Load    ************************************
//*************************
//****************
//*********
//****
//*

- (NSString *)getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = paths[0];
    return documentsDir;
}

- (void)saveCurrentProfileAndAppSettings {
    if (!(DEBUG_MODE_ON && NO_SAVE_MODE)) {
        NSData *data = [CurrentProfile convertToJSONAsRoot];
        
        NSString *documentsDir = [self getDocumentsDirectory];
        NSString *currentProfileFileName = [self getFileNameWithProfileName:CurrentProfile.profileName];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDir, currentProfileFileName];
        
        BOOL savedProfile = [data writeToFile:filePath atomically:YES];
        NSLog(@"Profile '%@' %@ saved.", currentProfileFileName, (savedProfile) ? @"was" : @"was not");
        
        //Save app settings
        NSString *appSettingsPath = [NSString stringWithFormat:@"%@/%@", documentsDir, APP_SETTINGS_FILE_NAME_WITH_EXT];
        CurrentAppSettings.lastProfileFileName = currentProfileFileName;
        NSData *appSettData = [CurrentAppSettings convertToJSONAsRoot];
        [appSettData writeToFile:appSettingsPath atomically:YES];
        
        BOOL savedAppSettings = [data writeToFile:filePath atomically:YES];
        NSLog(@"App Settings %@ saved.", (savedAppSettings) ? @"was" : @"was not");
    } else {
        NSLog(@"Didn't save - No save mode is on.");
    }
}

- (NSString *)getFileNameWithProfileName:(NSString *)profile {
    NSString *file = [profile stringByAppendingString:FILE_EXTENSION_INCLUDING_DOT];
    
    return file;
}

//------------------------------ Load ------------------------------
- (void)loadAppSettings {
    NSString *docDir = [self getDocumentsDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDir, APP_SETTINGS_FILE_NAME_WITH_EXT];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    AppSettings *a;
    if (data) {
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        if (e)
            NSLog(@"%@", [e localizedDescription]);
        
        a = [[AppSettings alloc] initWithPropertiesOrNil:dict];
        NSLog(@"App Settings was loaded");
    } else {
        a = [[AppSettings alloc] initWithPropertiesOrNil:nil];
        NSLog(@"New App Settings was created");
    }
    
    _appSettings = a;
}

- (void)loadProfileWithFileName:(NSString *)fileName {
    NSString *docDir = [self getDocumentsDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    Profile *p;
    if (data) {
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        if (e)
            NSLog(@"%@", [e localizedDescription]);
        
        p = [[Profile alloc] initWithPropertiesOrNil:dict];
        NSLog(@"Profile '%@' was loaded", CurrentAppSettings.lastProfileFileName);
    } else {
        p = [[Profile alloc] initWithPropertiesOrNil:nil];
        NSLog(@"New Profile was created");
    }
    
    _currentProfile = p;
}

//------------------------------ Other ------------------------------
- (void)deleteProfileWithProfileName:(NSString *)pName {
    NSString *docDir = [self getDocumentsDirectory];
    NSString *fileName = [self getFileNameWithProfileName:pName];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *e;
    [manager removeItemAtPath:path error:&e];
    if (e) NSLog(@"%@", [e localizedDescription]);
}

- (NSArray *)getUsedProfileNames {
    NSString *docsDir = [self getDocumentsDirectory];
    
    NSError *e;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileNames = [manager contentsOfDirectoryAtPath:docsDir error:&e];
    if (e) NSLog(@"%@", [e localizedDescription]);
    
    NSMutableArray *profileNames = [[NSMutableArray alloc] init];
    for (NSString *name in fileNames) {
        if ([name containsString:FILE_EXTENSION_INCLUDING_DOT]) {
            [profileNames addObject:[name substringToIndex:name.length - FILE_EXTENSION_INCLUDING_DOT.length]];
        }
    }
    
    return profileNames;
}

- (void)switchToProfile:(NSString *)name {
    [self saveCurrentProfileAndAppSettings];
    
    NSString *fileName = [self getFileNameWithProfileName:name];
    [self loadProfileWithFileName:fileName];
    CurrentAppSettings.lastProfileFileName = fileName;
    [CurrentAppDelegate saveCurrentProfileAndAppSettings];
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
    CGSize size = [self getScreenSize];
    if (size.width > size.height) return YES;
    else return NO;
}

- (CGFloat)getStatusBarHeight {
    //try any store height if possible
    if ((_statusBarHeight && _statusBarHeight == 0) || !_statusBarHeight) {
        _statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    
    if ([self deviceIsInLandscape] && [Styles getDevice] == iPhone) {
        return 0;
    } else {
        return _statusBarHeight;
    }
}

- (BOOL)statusBarIsShowing {
    if ([Styles getDevice] == iPhone && [CurrentAppDelegate deviceIsInLandscape])
        return NO;
    return YES;
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    self.currentProfile = nil;
    self.appSettings = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([CurrentProfile hasAllNecessaryInformationFromSetup])
        [self saveCurrentProfileAndAppSettings];
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
