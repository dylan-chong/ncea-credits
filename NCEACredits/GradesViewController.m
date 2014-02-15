//
//  GradesViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GradesViewController.h"

@interface GradesViewController ()

@end

@implementation GradesViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainers];
    }
    return self;
}

- (void)createBubbleContainers {
    NSArray *subjectTitles = [[ApplicationDelegate getCurrentProfile] getSubjects];
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithTitles:subjectTitles buttonClickSelector:NSStringFromSelector(@selector(subjectTitleWasPressed:)) target:self andMainBubble:self.mainBubble];
}

- (void)subjectTitleWasPressed:(BubbleContainer *)sender {
    BubbleViewController *b;

}

@end