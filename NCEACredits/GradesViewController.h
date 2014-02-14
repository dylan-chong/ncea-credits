//
//  GradesViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "SimpleSelectionViewController.h"

@interface GradesViewController : SimpleSelectionViewController <SimpleSelectionDelegate>

- (id)initWithMainBubble:(BubbleContainer *)mainBubble;

@end
