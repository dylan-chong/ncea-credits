//
//  ChangeColourRootTableViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeColourSetColourViewController.h"

@interface ChangeColourRootTableViewController : UITableViewController <ChangeColourSetColourViewControllerDelegate>

@property (weak) NSMutableDictionary *subAndCol;
@property NSArray *subjects;

@end
