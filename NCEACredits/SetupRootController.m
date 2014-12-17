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

- (void)viewDidAppear:(BOOL)animated {
    if (![CurrentProfile hasAllNecessaryInformationFromSetup]) {
        //Hide the cancel button so that data must be saved using done button
        [_cancelButton setTitle:@""];
        [_cancelButton setTarget:nil];
    }
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
                                              selected:NO
                                          optionalData:0],
             
             [[TableViewCellData alloc] initWithDetail:[NSString stringWithFormat:@"%lu", (unsigned long)[CurrentProfile getYearCurrentlyInUseOtherwiseCurrentDateYear]]
                                                  text:@"Current Year"
                                               reuseId:@"edit"
                                             accessory:UITableViewCellAccessoryNone
                                                 style:UITableViewCellStyleValue1
                                              selected:NO
                                          optionalData:0],
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
                          selected:NO
                          optionalData:0]
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
    
    //Add year button
    [y addObject:[[TableViewCellData alloc] initWithDetail:@""
                                                      text:@"Add year..."
                                                   reuseId:@"add"
                                                 accessory:UITableViewCellAccessoryNone
                                                     style:UITableViewCellStyleDefault
                                                  selected:NO
                                              optionalData:0
                  
                  ]
     ];
    
    return y;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Year Stuff    ************************************
//*************************
//****************
//*********
//****
//*

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
            selected:NO
            optionalData:[self getUnusedYearIdentifer]];
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

//------------------------------ Optional data (year identifiers) ------------------------------
//Year identifiers link the cells to the data

- (NSUInteger)getUnusedYearIdentifer {
    NSArray *usedIDs = [self getAllUsedYearIdentifiers];
    NSUInteger largestID = 0;
    
    //Find an identifier larger than the largest being used
    for (NSNumber *n in usedIDs) {
        if ([n integerValue] > largestID)
            largestID = [n integerValue];
    }
    
    return largestID + 1;
}

- (NSArray *)getAllUsedYearIdentifiers {
    NSMutableArray *used = [[NSMutableArray alloc] init];
    
    if (_yearCells.count > 1) {
        for (int a = 0; a < _yearCells.count - 1; a++) {//-1 to avoid add year button
            [used addObject:[NSNumber numberWithInteger:((TableViewCellData *)_yearCells[a]).optionalData]];
        }
    }
    
    return used;
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
            [self yearWasTappedAtRow:indexPath.row];
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

//------------------------------ Add ------------------------------

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

//------------------------------ Edit Years ------------------------------

- (void)yearWasTappedAtRow:(NSInteger)row {
    //Original cell data
    TableViewCellData *tappedYearData = _yearCells[row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Please type in a year (date), then the primary NCEA Level for that year." preferredStyle:UIAlertControllerStyleAlert];
    
    //Text fields
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = tappedYearData.text;
        textField.placeholder = @"Year (Date)";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = [self getLastCharacterOfString:tappedYearData.detail];
        textField.placeholder = @"NCEA Level 1/2/3/(4)";
    }];
    
    //Done/cancel
    [alert addAction:[UIAlertAction actionWithTitle:@"Done"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self yearCellAtRow:row editWindowDoneClicked:alert];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)yearCellAtRow:(NSUInteger)row editWindowDoneClicked:(UIAlertController *)alert {
    TableViewCellData *data = _yearCells[row];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:1]];
    NSString *invalidityMessage;
    
    //Validate year
    NSString *year = ((UITextField *)alert.textFields[0]).text;
    if ([self isString:year NumbersOnlyAndHasCertainNumberOfCharacters:4]) {
        data.text = year;
        cell.textLabel.text = year;
    } else {
        invalidityMessage = @"Please enter a valid year.";
    }
    
    //Validate level
    NSString *level = ((UITextField *)alert.textFields[1]).text;
    NSUInteger levelInt = [level integerValue];
    if ([self isString:level NumbersOnlyAndHasCertainNumberOfCharacters:1] && levelInt >= 1 && levelInt <= 4) {//Supports NCEA 1-4
        NSString *detail = [NSString stringWithFormat:@"NCEA Level %li", (long) levelInt];
        data.detail = detail;
        cell.detailTextLabel.text = detail;
    } else {
        if (invalidityMessage.length > 0) {
            invalidityMessage = @"Please enter a valid year and NCEA level.";
        } else {
            invalidityMessage = @"Please enter a valid NCEA level.";
        }
    }
    
    //Some stuff not valid
    if (invalidityMessage) {
        UIAlertController *invalidityAlert = [UIAlertController alertControllerWithTitle:AppName message:invalidityMessage preferredStyle:UIAlertControllerStyleAlert];
        [invalidityAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //Reshow edit window after close
            [self yearWasTappedAtRow:row];
        }]];
        [self presentViewController:invalidityAlert animated:YES completion:nil];
    }
}

- (BOOL)isString:(NSString *)string NumbersOnlyAndHasCertainNumberOfCharacters:(NSUInteger)number {
    //Make sure its 4 chars long and all numbers
    if (string.length != number || [string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        return NO;
    
    return YES;
}

- (NSString *)getLastCharacterOfString:(NSString *)string {
    return [string substringFromIndex:string.length - 1];
}

//------------------------------ Selecting current year ------------------------------
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
                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setCurrentYear:(unsigned long)indexFromYears {
    NSString *text = [self getYearDatesOfListedYears][indexFromYears];
    ((TableViewCellData *)_generalCells[1]).text = text;
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].detailTextLabel.text = text;
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
    //Only allow deleting of years
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

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    if (![self checkForDuplicateYears]) {
        //Modify current profile
        [self applySettingsToCurrentProfile];
        
        //Dismiss setup window
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        //Duplicate alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"You seem to have duplicate years. Duplicate NCEA levels are allowed, but not years." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//------------------------------ Subfunctions of done ------------------------------
- (BOOL)checkForDuplicateYears {
    //Shortcut to get year without having to cast to type each time
    TableViewCellData * (^Year)(int) = ^(int index) {
        return _yearCells[index];
    };
    
    for (int a = 0; a < _yearCells.count - 1; a++) {
        for (int b = 0; b < _yearCells.count - 1; b++) {
            if (b != a) {//Don't compare a year with itself
                if ([Year(a).text isEqualToString:Year(b).text]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)applySettingsToCurrentProfile {
    //Apply general things first
    CurrentProfile.profileName = ((TableViewCellData *)_generalCells[0]).detail;
    CurrentProfile.currentYear = [((TableViewCellData *)_generalCells[1]).detail integerValue];
    
    //Apply selected goal
    for (TableViewCellData *goalData in _goalCells) {
        if (goalData.accessory == UITableViewCellAccessoryCheckmark) {
            CurrentProfile.selectedGoalTitle = goalData.text;
            break;
        }
    }
    
    //------------------------------ Year stuff ------------------------------
    //Remove add year button so that for-in loops can be used (actual cell isnt removed)
    [_yearCells removeLastObject];
    
    //Go through existing years, applying changes to NCEA level
    NSMutableArray *existingYears = CurrentProfile.yearCollection.years;
    for (Year *year in existingYears) {
        //Make sure to find the right year
        for (TableViewCellData *data in _yearCells) {
            if (year.identifier == data.optionalData) { //use ID to find matches
                year.primaryLevelNumber = [[self getLastCharacterOfString:data.detail] integerValue];
                year.yearDate = [data.text integerValue];
                
                [_yearCells removeObject:data]; //Remove data as it's job is done
                break;
            }
        }
    }
    
    //Create blank years for remaining datas
    for (TableViewCellData *dataToCreateYear in _yearCells) {
        Year *newYear = [[Year alloc] initWithJSONOrNil:nil];
        newYear.yearDate = [dataToCreateYear.text integerValue];
        newYear.primaryLevelNumber = [[self getLastCharacterOfString:dataToCreateYear.detail] integerValue];
        newYear.identifier = dataToCreateYear.optionalData;
        [CurrentProfile.yearCollection.years addObject:newYear];
    }
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
