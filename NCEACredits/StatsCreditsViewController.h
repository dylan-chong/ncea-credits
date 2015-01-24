//
//  StatsCreditsViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 31/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionViewController.h"
#import "StatsSubjectsViewController.h"

@interface StatsCreditsViewController : SimpleSelectionViewController

@property NSArray *assessmentsForPopup;
@property NSString *subjectForPopup;
@property NSString *gradeText;

@end
