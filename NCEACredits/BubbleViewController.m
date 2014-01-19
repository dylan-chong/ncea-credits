//
//  BubbleViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"

@implementation BubbleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bubbleView = [[BubbleView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _bubbleView.frame = CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight]);
    [_bubbleView repositionBubbles];
}

- (NSUInteger)supportedInterfaceOrientations {
    Device d = [Styles getDevice];
    
    if (d == iPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

//Parents call the child's subclassed method
- (void)toTransitionHasFinishedWithButton:(BubbleContainer *)container {
    
}


@end
