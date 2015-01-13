//
//  AppSettings.h
//  NCEACredits
//
//  Created by Dylan Chong on 23/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Styles.h"

#define APP_SETTINGS_FILE_NAME_WITH_EXT @"App_Settings.sett"

#define SETUP_STATE_BLANK 0
#define SETUP_STATE_NEW_PROFILE_NOT_INITIAL 1
#define SETUP_STATE_NEW_PROFILE_INITIAL 2
#define SETUP_STATE_EDIT_PROFILE 3

@interface AppSettings : ToJSONTemplate

@property NSString *lastProfileFileName;
@property NSInteger setupState;
@property BOOL hasOpenedStatsMenuBefore;

@property NSString *lastEnteredFinalGrade, *lastEnteredPrelimGrade, *lastEnteredExpectGrade, *lastEnteredSubject;
@property BOOL lastEnteredWasInternal;

@property AnimationSpeedSelection animationSpeed;

- (NSData *)convertToJSONAsRoot;
- (void)logJSONText;

@end
