//
//  SetupRootController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellData.h"

@interface SetupRootController : UITableViewController <UIAlertViewDelegate>
@property NSArray *cellData;
@property TableViewCellData *addYearData;
@end
