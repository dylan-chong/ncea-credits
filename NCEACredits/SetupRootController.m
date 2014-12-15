//
//  SetupRootController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SetupRootController.h"
#import "Year.h"
#import "DefaultGoals.h"

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

- (void)createCells {
    if (!_generalCells) {
        //Add general
        _generalCells = [self getGeneralCells];
        
        //Add years
        _yearCells = [self getYearCellDatas];//Includes add year button
        
        //Add goals
        _goalCells = [self getGoalCellDatas];
    }
}

- (NSArray *)getGeneralCells {
    return @[
             [[TableViewCellData alloc] initWithDetail:@"John Appleseed"
                                                  text:@"Name"
                                               reuseId:@"edit"
                                             accessory:UITableViewCellAccessoryNone
                                                 style:UITableViewCellStyleValue1
                                              selected:NO],
             
             [[TableViewCellData alloc] initWithDetail:[NSString stringWithFormat:@"%lu", (unsigned long)[CurrentProfile getYearCurrentlyInUseOtherwiseCurrentDateYear]]
                                                  text:@"Current Year"
                                               reuseId:@"edit"
                                             accessory:UITableViewCellAccessoryNone
                                                 style:UITableViewCellStyleValue1
                                              selected:NO],
             ];
}

- (NSArray *)getGoalCellDatas {
    NSArray *titles = [DefaultGoals getStringsOfGoalTitles];
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    
    for (NSString *s in titles) {
        [datas addObject:[[TableViewCellData alloc]
                          initWithDetail:@""
                          text:s
                          reuseId:@"goal"
                          accessory:UITableViewCellAccessoryNone
                          style:UITableViewCellStyleDefault
                          selected:NO]
         ];
    }
    
    ((TableViewCellData *) datas[0]).accessory = UITableViewCellAccessoryCheckmark;
    
    return datas;
}

- (NSMutableArray *)getYearCellDatas {
    NSMutableArray *y;
    
    if (CurrentProfile.yearCollection.years.count > 0) {
        y = [[CurrentProfile getYearsAsTableDatasForSetup] mutableCopy];
    } else {
        y = [[NSMutableArray alloc] initWithObjects:[self getNewYearObjectWithAlreadyExistingYears:NO], nil];
        //Creates new TableViewCellData not year object. Save year object in doneButtonPressed
    }
    
    [y addObject:[[TableViewCellData alloc] initWithDetail:@""
                                                      text:@"Add year..."
                                                   reuseId:@"add"
                                                 accessory:UITableViewCellAccessoryNone
                                                     style:UITableViewCellStyleDefault
                                                  selected:NO
                  ]
     ];
    
    return y;
}

- (TableViewCellData *)getNewYearObjectWithAlreadyExistingYears:(BOOL)alreadyExistingYears {
    unsigned long year;
    
    if (alreadyExistingYears) {
        year = [self getNewYearDate];
    } else {
        year = [Year getCurrentYearDate];
    }
    
    return [[TableViewCellData alloc]
            initWithDetail:@"NCEA Level 1"
            text:[NSString stringWithFormat:@"%lu", year]
            reuseId:@"year"
            accessory:UITableViewCellAccessoryNone
            style:UITableViewCellStyleValue1
            selected:NO];
}

- (unsigned long)getNewYearDate {
    unsigned long newDate = [CurrentProfile getYearCurrentlyInUseOtherwiseCurrentDateYear];
    
    //is newDate already in use? get older dates until you find one not used
    while ([self checkIfYearDateIsAlreadyListed:newDate] == YES) {
        newDate--;
    }
    
    //newDate is not already in use
    return newDate;
}

- (BOOL)checkIfYearDateIsAlreadyListed:(unsigned long)toCheck {
    NSArray *listedYears = [self getYearDatesOfListedYears];
    
    for (int a = 0; a < listedYears.count; a++) {
        if ([(NSString *)listedYears[a] integerValue] == toCheck) {
            //is in use
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)getYearDatesOfListedYears {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < _yearCells.count - 1; a++) {
        [array addObject:((TableViewCellData *) _yearCells[a]).text];
    }
    
    return array;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Getting cell data    ************************************
//*************************
//****************
//*********
//****
//*

- (TableViewCellData *)getTableViewCellDataAtIndexPath:(NSIndexPath *)indexPath {
    [self createCells];
    NSArray *section;
    
    switch (indexPath.section) {
        case 0:
            section = _generalCells;
            break;
            
        case 1:
            section = _yearCells;
            break;
            
        case 2:
            section = _goalCells;
            break;
            
        default:
            break;
    }
    
    TableViewCellData *t = section[indexPath.row];
    
    return t;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Table view cells   ************************************
//*************************
//****************
//*********
//****
//*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    [self createCells];
    if (section == 0)
        return _generalCells.count;
    else if (section == 1)
        return _yearCells.count;
    else
        return _goalCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *t = [self getTableViewCellDataAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t.reuseId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:t.style
                                      reuseIdentifier:t.reuseId];
    }
    
    cell.detailTextLabel.text = t.detail;
    cell.textLabel.text = t.text;
    cell.accessoryType = t.accessory;
    cell.selected = t.selected;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"General Details";
    } else if (section == 1) {
        return @"Years of NCEA";
    } else {
        return @"Goal to Achieve";
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Cell tapped    ************************************
//*************************
//****************
//*********
//****
//*

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *pressedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [pressedCell setSelected:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //Name
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:AppName
                                                        message:@"Please enter your name."
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
            a.alertViewStyle = UIAlertViewStylePlainTextInput;
            a.tag = indexPath.row;
            [a textFieldAtIndex:0].text = [self getTableViewCellDataAtIndexPath:indexPath].detail;
            [a show];
        } else {
            //Current year cell
            [self currentYearSelected];

        }
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == _yearCells.count - 1) {
            //Add year
            [self addYearCellAndData];
            [pressedCell setSelected:NO];
        } else {
            //Year tapped
            
        }
    
    } else if (indexPath.section == 2) {
        
        //Goal
        //hide all checkmarks
        
        UITableViewCell *cell;
        TableViewCellData *data;
        for (int a = 0; a < _goalCells.count; a++) {
            data = ((TableViewCellData *)_goalCells[a]);
            cell = [self.tableView cellForRowAtIndexPath:
                    [NSIndexPath indexPathForRow:a
                                       inSection:indexPath.section]];
            
            if (a == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                data.accessory = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                data.accessory = UITableViewCellAccessoryNone;
            }
        }
    }
}

- (void)addYearCellAndData {
    NSInteger index = _yearCells.count - 1;
    TableViewCellData *d = [self getNewYearObjectWithAlreadyExistingYears:YES];
    [_yearCells insertObject:d atIndex:index];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[path]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:path animated:NO];
}

- (void)yearWasTappedAtIndex:(NSInteger)index {
    
}

//------------------------------ Selecting year ------------------------------
- (void)currentYearSelected { //Current Year button (second item)
    UIAlertController *alert = [UIAlertController
                            alertControllerWithTitle:AppName
                            message:@"Choose your year\n(or close this and add a new one)."
                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int a = 0; a < _yearCells.count - 1; a++) { // -1 cos last item in _year cells is add year
        TableViewCellData *year = (TableViewCellData *)_yearCells[a];
        UIAlertAction *action = [UIAlertAction
                                 actionWithTitle:year.text
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action) {
                                     //Use method below
                                     [self setCurrentYear:a];
                                 }];
        [alert addAction:action];
    }
    
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {
                                //Do nothing on cancel
                            }]];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)setCurrentYear:(unsigned long)indexFromYears {
    NSString *text = [self getYearDatesOfListedYears][indexFromYears];
    ((TableViewCellData *)_generalCells[1]).text = text;
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].detailTextLabel.text = text;
}

//------------------------------ Alert View Textbox ------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *input = [alertView textFieldAtIndex:0].text;
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([SetupRootController validateInputText:input atIndexPath:indexPath]) {
        //Valid input
        [self getTableViewCellDataAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]].detail = input;
        cell.detailTextLabel.text = input;
    }
}

+ (BOOL)validateInputText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            //Name
            return YES;//Probably nothing ever wrong with name
            break;
            
        case 1:
            //Current Year
            
            if (text.length != 4 || [text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
                
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

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Swipe to Delete    ************************************
//*************************
//****************
//*********
//****
//*

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row != _yearCells.count - 1) {
            
            if ([self getYearDatesOfListedYears].count > 1) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete pressed
        [_yearCells removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Finish    ************************************
//*************************
//****************
//*********
//****
//*

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
#warning TODO: save data to profile ad hide
    
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
