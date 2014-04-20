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

- (void)createBubbleContainers {
    NSArray *subjectTitles = [[ApplicationDelegate getCurrentProfile] getSubjects];
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithTitles:subjectTitles buttonClickSelector:NSStringFromSelector(@selector(subjectTitleWasPressed:)) target:self staggered:self.staggered andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (void)subjectTitleWasPressed:(BubbleContainer *)sender {
//    BubbleViewController *b;
 #warning TODO: subject bubble press
}




@end