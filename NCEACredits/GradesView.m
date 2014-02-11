//
//  GradesView.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GradesView.h"

@implementation GradesView

- (id)initWithMainBubble:(BubbleContainer *)mainBubble {
    self = [super initWithFrame:CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight])];
    if (self) {
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainers];
    }
    return self;
}

- (void)createBubbleContainers {
    NSArray *subjectTitles = [[ApplicationDelegate getCurrentProfile] getSubjects];
    self.childBubbles = [SimpleSelectionView getArrayOfBubblesWithTitles:subjectTitles buttonClickSelector:NSStringFromSelector(@selector(subjectTitleWasPressed:)) target:self andMainBubble:self.mainBubble];
}

- (void)subjectTitleWasPressed:(BubbleContainer *)bubble {
    BubbleViewController *b;
#warning transition to grade bubble
    [self startTransitionToChildBubble:bubble];
}

@end
