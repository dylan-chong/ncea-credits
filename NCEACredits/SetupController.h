//
//  SetupController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupController : UINavigationController

- (void)showFromViewController:(UIViewController *)controller;
+ (NSString *)getStoryboardFileName;

@end
