//
//  SetupNavigationController.m
//  NCEACredits
//
//  Created by Dylan Chong on 13/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SetupNavigationController.h"

@interface SetupNavigationController ()

@end

@implementation SetupNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

+ (NSString *)getStoryboardFileName {
    if ([Styles getDevice] == iPad) {
        return @"SetupStoryboard~ipad";
    } else {
        return @"SetupStoryboard~iphone";
    }
}

+ (void)showStoryboardFromViewController:(UIViewController *)vc {
    UIStoryboard *setupStoryboard = [UIStoryboard storyboardWithName:[SetupNavigationController getStoryboardFileName]
                                                              bundle:nil];
    
    UIViewController *sbvc = [setupStoryboard instantiateInitialViewController];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [vc presentViewController:sbvc
                     animated:YES
                   completion:^{}
     ];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
