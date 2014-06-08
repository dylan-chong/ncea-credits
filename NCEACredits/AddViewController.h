//
//  AddViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextViewController.h"

@interface AddViewController : EditTextViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble;

+ (NSArray *)getItemData;

@end
