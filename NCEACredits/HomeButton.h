//
//  HomeButton.h
//  NCEACredits
//
//  Created by Dylan Chong on 26/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "CornerButton.h"
#import "BubbleContainer.h"

@class SimpleSelectionViewController;
@interface HomeButton : CornerButton

- (id)initWithSimpleVC:(SimpleSelectionViewController *)simpleVC;
@property (nonatomic, weak) SimpleSelectionViewController *simpleVC;
@end
