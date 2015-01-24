//
//  EditAssessmentViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 18/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextViewController.h"
#import "Assessment.h"

@interface EditAssessmentViewController : EditTextViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andAssessmentOrNil:(Assessment *)assessment;
@property Assessment *assessment;

+ (NSArray *)getItemDataWithAssessmentOrNil:(Assessment *)assessment;

@end
