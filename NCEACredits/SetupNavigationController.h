//
//  SetupNavigationController.h
//  NCEACredits
//
//  Created by Dylan Chong on 13/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupNavigationController : UINavigationController

+ (NSString *)getStoryboardFileName;
+ (void)showStoryboardFromViewController:(UIViewController *)vc;
@property id delegateToPassOnToRootController;

@end
