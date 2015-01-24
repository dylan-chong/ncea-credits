//
//  StatsPopupRootTableViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 14/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatsPopupRootTableViewController : UITableViewController

@property NSArray *subjectsArrayOfAssessmentsArrays;
@property NSString *subjectOrNilForTotal;
@property NSString *gradeText;
@property NSString *priorityText;
@property NSUInteger totalCredits;

@end
