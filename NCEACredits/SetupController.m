//
//  SetupController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SetupController.h"

@interface SetupController ()

@end

@implementation SetupController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

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

- (void)showFromViewController:(UIViewController *)controller {
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [controller presentViewController:self
                             animated:YES
                           completion:
     
     ^{
         
         //*
         //****
         //*********
         //****************
         //*************************
         //************************************************************************
         //*************************
         //****************
         //*********
         //****
         //*
#warning TODO: remove modalvc
         //*
         //****
         //*********
         //****************
         //*************************
         //************************************************************************
         //*************************
         //****************
         //*********
         //****
         //*
         UIStoryboard *setupStoryboard = [UIStoryboard storyboardWithName:[SetupController getStoryboardFileName]
                                                      bundle:nil];
         UIViewController *vc = [setupStoryboard instantiateInitialViewController];
         [self presentViewController:vc
                            animated:YES
                          completion:^{}];
     }];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

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
