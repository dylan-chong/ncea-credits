//
//  ChangeColourNavViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeColourNavViewControllerDelegate <NSObject>
- (void)changeColourNavVCWillClose;
@end

@interface ChangeColourNavViewController : UINavigationController

@property id<ChangeColourNavViewControllerDelegate> delegateForWillCloseMethod;
- (void)callDelegateForWillClose;

@end
