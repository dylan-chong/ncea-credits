//
//  GradesViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SubjectsViewController.h"
#import "ChangeColourNavViewController.h"

@interface GradesViewController : SubjectsViewController <ChangeColourNavViewControllerDelegate>

@property CornerButton *setColourButton;

@end
