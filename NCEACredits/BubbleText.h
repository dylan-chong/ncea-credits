//
//  BubbleText.h
//  NCEACredits
//
//  Created by Dylan Chong on 20/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleText : UITextView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text fontOrNil:(UIFont *)fontOrNil;
//+ (BOOL)wordisTooBigToFitDefaultTextViewWithMinimumSizeFont:(NSString *)word;
//+ (NSArray *)splitTextIntoWords:(NSString *)text;
+ (BOOL)textContainsWordsThatWillBeTooLargeForSubtitleBubble:(NSString *)text;

@end

@interface UITextView (Stylesheet)
-(id)styleString;
@end