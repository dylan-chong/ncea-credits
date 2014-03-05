//
//  AddViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AddViewController.h"
#import "EditTextBubble.h"

@implementation AddViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.staggered = NO;
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainers];
        [self createAnchors];
    }
    return self;
}

- (void)createBubbleContainers {
    NSArray *titles = [AddViewController getAssessmentViewTitles];
    NSArray *texts = [AddViewController getAssessmentViewTexts];
    NSArray *placeholders = [AddViewController getAssessmentViewPlaceHolders];
    NSArray *types = [AddViewController getAssessmentViewTypes];
    
    self.childBubbles = [EditTextViewController getEditBubblesWithTitles:titles texts:texts placeholders:placeholders types:types delegate:self towardsRightSide:NO andMainBubble:self.mainBubble];

    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (BOOL)isPlaceholderForTitle:(NSString *)title {
    for (EditTextBubbleContainer *b in self.childBubbles) {
        EditTextBubble *bubble  = (EditTextBubble *)b.bubble;
        if ([bubble.titleLabel.text isEqualToString:[title stringByAppendingString:@":"]]) {
            return bubble.isPlaceHolder;
        }
    }
    
    return NO;
}

- (void)startReturnScaleAnimation {
    int count = 0;
    NSArray *titles = [[AddViewController getAssessmentViewTitles] subarrayWithRange:NSMakeRange(0, 3)];
    
    for (NSString *t in titles) {
        if (![self isPlaceholderForTitle:t]) count++;
    }
    
    if (count == 3) {
        [super startReturnScaleAnimation];
    } else {
        NSString *message = @"You must enter details for the AS Number, Name, and Subject.";
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"NCEA Credits" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Don't Save", nil];
        [a show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Cancel
    } else {
        //Don't Save
        [super startReturnScaleAnimation];
    }
}

#warning add other add types 
//private static final String dateOfFinalGradeKey = "assessmentNumberKey";
//private static final String typeOfCreditsKey = "typeOfCreditsKey";
//private static final String levelKey = "levelKey";
//private static final String isUnitStandardKey = "isUnitStandardKey";

+ (NSArray *)getAssessmentViewTitles {
    return @[@"AS Number",
             @"Quick Name",
             @"Subject",
             @"Credits",
             @"Due Date",
             @"Expected Grade",
             @"Pre-Resub Grade",
             @"Practice Grade",
             @"Preliminary Grade",
             @"Final Grade"];
}

+ (NSArray *)getAssessmentViewTexts {
    return  @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
}

+ (NSArray *)getAssessmentViewPlaceHolders {
    return @[@"901234",
             @"Mechanics",
             @"Science",
             @"4",
             @"12/03/14",
             @"Achieved",
             @"Achieved",
             @"Achieved",
             @"Achieved",
             @"Achieved"];
}

+ (NSArray *)getAssessmentViewTypes {
    return @[tNSN(Number),
             tNSN(Text),
             tNSN(Text),
             tNSN(Number),
             tNSN(Date),
             tNSN(Grade),
             tNSN(Grade),
             tNSN(Grade),
             tNSN(Grade),
             tNSN(Grade)];
}

@end