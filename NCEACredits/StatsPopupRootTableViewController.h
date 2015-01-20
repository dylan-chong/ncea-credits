//
//  StatsPopupRootTableViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 14/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatsPopupRootDelegate <NSObject>

- (NSArray *)getAssessments;
- (NSString *)getSubjectOrNil;
- (NSString *)getGradeText;

@end


@interface StatsPopupRootTableViewController : UITableViewController

@property id<StatsPopupRootDelegate>delegateForData;
@property NSArray *assessments;
@property NSString *subjectOrNil, *gradeText;

@end
