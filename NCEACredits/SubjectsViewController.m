//
//  SubjectsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 21/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SubjectsViewController.h"

@implementation SubjectsViewController

- (void)createBubbleContainers {
    NSDictionary *subjectTitles = [CurrentProfile getSubjectsAndColoursOrNilForCurrentYear];
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectsWithColoursOrNot:subjectTitles buttonClickSelector:NSStringFromSelector(@selector(subjectTitleWasPressed:)) target:self staggered:self.staggered andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (void)subjectTitleWasPressed:(BubbleContainer *)sender {
    NSAssert(NO, @"You must override this method");
#warning TODO: subject bubble press
}

@end
