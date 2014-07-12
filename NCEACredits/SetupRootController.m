//
//  SetupRootController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SetupRootController.h"
#import "Year.h"
#import "TableViewCellData.h"

@interface SetupRootController ()

@end

@implementation SetupRootController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _cellData = @[
                      [[TableViewCellData alloc] initWithDetail:@"Name"
                                                           text:@"Abc"
                                                        reuseId:nil
                                                       andStyle:UITableViewCellStyleValue2],
                      
                      [[TableViewCellData alloc] initWithDetail:@"Current Year"
                                                           text:[NSString stringWithFormat:@"%i", [Year getCurrentYearDate]]
                                                        reuseId:nil
                                                       andStyle:UITableViewCellStyleValue2],
                      
                      [[TableViewCellData alloc] initWithDetail:@"Years"
                                                           text:@""
                                                        reuseId:nil
                                                       andStyle:UITableViewCellStyleDefault],
                      
                      [[TableViewCellData alloc] initWithDetail:@"Goal"
                                                           text:@""
                                                        reuseId:nil
                                                       andStyle:UITableViewCellStyleDefault],
                      ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (TableViewCellData *)getTableViewCellDataAtIndex:(NSInteger)index {
    return (TableViewCellData *)_cellData[index];
}

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
    
    UITableViewCell *cell; //= [tableView dequeueReusableCellWithIdentifier:t.reuseId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:t.style
                                      reuseIdentifier:t.reuseId];
        cell.detailTextLabel.text = t.detail;
        cell.textLabel.text = t.text;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
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
