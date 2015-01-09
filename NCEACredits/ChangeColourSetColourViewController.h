//
//  ChangeColourSetColourViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeColourSetColourViewControllerDelegate <NSObject>

- (void)setColourVCWillCloseWithSelectedColour:(UIColor *)colour andSubject:(NSString *)subject;

@end

@interface ChangeColourSetColourViewController : UIViewController

@property NSArray *colourButtons;
@property id<ChangeColourSetColourViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *colourView;

@end
