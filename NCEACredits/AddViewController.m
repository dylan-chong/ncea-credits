//
//  AddViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 15/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AddViewController.h"
#import "AddView.h"

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)d
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = d;
        self.bubbleView = [[AddView alloc] init];
        [self.view addSubview:self.bubbleView];
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


@end
