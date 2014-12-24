//
//  AppSettings.h
//  NCEACredits
//
//  Created by Dylan Chong on 23/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APP_SETTINGS_FILE_NAME_WITH_EXT @"App_Settings.sett"

@interface AppSettings : ToJSONTemplate

@property NSString *lastProfileFileName;
- (NSData *)convertToJSONAsRoot;

@end
