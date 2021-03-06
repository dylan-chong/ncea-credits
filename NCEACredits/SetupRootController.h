//
//  SetupRootController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetupRootControllerDelegate <NSObject>

- (void)setuphasBeenDismissed;

@end

@interface SetupRootController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property NSArray *generalCells, *goalCells;
@property NSMutableArray *yearCells;

@property id<SetupRootControllerDelegate>delegate;

@end
