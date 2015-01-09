//
//  ChangeColourRootTableViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "ChangeColourRootTableViewController.h"
#import "ChangeColourSubjectColourTableViewCell.h"
#import "ChangeColourNavViewController.h"

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
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

- (IBAction)saveButtonPressed:(id)sender {
    [ApplicationDelegate saveCurrentProfileAndAppSettings];
    
    ChangeColourNavViewController *navVC = (ChangeColourNavViewController *)self.navigationController;
    [navVC callDelegateForWillClose];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setColourVCWillCloseWithSelectedColour:(UIColor *)colour andSubject:(NSString *)subject {
    [_subAndCol setObject:colour forKey:subject];
    
    [self refreshColoursInTableView];
}

- (void)refreshColoursInTableView {
    [self.tableView beginUpdates];
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for (int a = 0; a < _subjects.count; a++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:a inSection:0];
        [paths addObject:path];
        ChangeColourSubjectColourTableViewCell *cell = (ChangeColourSubjectColourTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        
        NSString *subject = _subjects[a];
        [cell setColourViewColour:[_subAndCol objectForKey:subject]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *t = ((ChangeColourSubjectColourTableViewCell *)sender).textLabel.text;
    
    ChangeColourSetColourViewController *newController = [segue destinationViewController];
    newController.delegate = self;
    [newController.navigationItem setTitle:t];
}

@end
