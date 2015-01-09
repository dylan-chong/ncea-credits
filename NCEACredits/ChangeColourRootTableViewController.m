//
//  ChangeColourRootTableViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "ChangeColourRootTableViewController.h"
#import "ChangeColourSubjectColourTableViewCell.h"

@interface ChangeColourRootTableViewController ()

@end

@implementation ChangeColourRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _subAndCol = [CurrentProfile getCurrentYear].subjectsAndColours.subjectsAndColours;
    _subjects = [Styles sortArray:[_subAndCol allKeys]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Data Source    ************************************
//*************************
//****************
//*********
//****
//*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _subAndCol.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeColourSubjectColourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subjectID" forIndexPath:indexPath];
    
    NSString *subject = _subjects[indexPath.row];
    cell.textLabel.text = subject;
    
    UIColor *colour = [_subAndCol objectForKey:subject];
    [cell setColourViewColour:colour];

    return cell;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Nav    ************************************
//*************************
//****************
//*********
//****
//*

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *t = ((ChangeColourSubjectColourTableViewCell *)sender).textLabel.text;
    
    UIViewController *newController = [segue destinationViewController];
    [newController.navigationItem setTitle:t];
}

@end
