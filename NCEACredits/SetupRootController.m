//
//  SetupRootController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SetupRootController.h"
#import "Year.h"

@interface SetupRootController ()

@end

@implementation SetupRootController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getCellData {
    if (!_cellData) {
        _cellData = @[
                      [[TableViewCellData alloc] initWithDetail:@"Abc"
                                                           text:@"Name"
                                                        reuseId:@"edit"
                                                      accessory:UITableViewCellAccessoryNone
                                                       andStyle:UITableViewCellStyleValue2],
                      
                      [[TableViewCellData alloc] initWithDetail:[NSString stringWithFormat:@"%i", [Year getCurrentYearDate]]
                                                           text:@"Current Year"
                                                        reuseId:@"edit"
                                                      accessory:UITableViewCellAccessoryNone
                                                       andStyle:UITableViewCellStyleValue2],
                      
                      [[TableViewCellData alloc] initWithDetail:@""
                                                           text:@"Goal"
                                                        reuseId:@"push"
                                                      accessory:UITableViewCellAccessoryDisclosureIndicator
                                                       andStyle:UITableViewCellStyleDefault],
                      ];
    }
    
    return _cellData;
}

- (TableViewCellData *)getTableViewCellDataAtIndex:(NSInteger)index {
    return (TableViewCellData *)[self getCellData][index];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Table view data source    ************************************
//*************************
//****************
//*********
//****
//*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *t = [self getTableViewCellDataAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t.reuseId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:t.style
                                      reuseIdentifier:t.reuseId];
        cell.detailTextLabel.text = t.detail;
        cell.textLabel.text = t.text;
        cell.accessoryType = t.accessory;
        
        //        if (t.style == UITableViewCellStyleValue2) {
        //            UITapGestureRecognizer *tap =
        //            [[UITapGestureRecognizer alloc] initWithTarget:self
        //                                                    action:@selector(editCellTapped:)];
        //
        //            [cell addGestureRecognizer:tap];
        //        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2) {
        NSString *mes;
        if (indexPath.row == 0) mes = @"Please enter your name.";
        else mes = @"Please enter the current year.";
        
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:AppName
                                                    message:mes
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
        a.alertViewStyle = UIAlertViewStylePlainTextInput;
        a.tag = indexPath.row;
        [a textFieldAtIndex:0].text = [self getTableViewCellDataAtIndex:indexPath.row].detail;
        [a show];
    } else {
        if (indexPath.row == 2)
            [self performSegueWithIdentifier:@"goal" sender:nil];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *input = [alertView textFieldAtIndex:0].text;
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([SetupRootController validateInputText:input atIndexPath:indexPath]) {
        //Valid input
        [self getTableViewCellDataAtIndex:alertView.tag].detail = input;
        cell.detailTextLabel.text = input;
    }
    
    cell.selected = NO;
}

+ (BOOL)validateInputText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
    NSInteger numericValue;
    
    switch (indexPath.row) {
        case 0:
            //Name
            return YES;//Probably nothing ever wrong with name
            break;
            
        case 1:
            //Current Year
            numericValue = [text integerValue];
            
            if (text.length != 4 && [text rangeOfCharacterFromSet:
                                     [[NSCharacterSet decimalDigitCharacterSet]
                                      invertedSet]].location == NSNotFound) {
                                         
                UIAlertView *a = [[UIAlertView alloc] initWithTitle:AppName
                                                            message:@"Please enter a valid year."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                [a show];
                
                return NO;
            }
            
            break;
            
        default:
            break;
    }
    
    return YES;
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
