//
//  SetupRootController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SetupRootController.h"
#import "Year.h"
#import "GoalMain.h"
#import "TableViewCellData.h"

@interface SetupRootController ()

@end

@implementation SetupRootController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCells {
    //Viewdidappear doesnt call on ipad, but this method runs at the start anyway
    if (![CurrentProfile hasAllNecessaryInformationFromSetup]) {
        //Hide the cancel button so that data must be saved using done button
        [_cancelButton setTitle:@""];
        [_cancelButton setTarget:nil];
    }
    
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
    NSString *name = @"John";
    if (CurrentProfile.profileName && CurrentAppDelegate.setupState == SETUP_STATE_EDIT_PROFILE) name = CurrentProfile.profileName;
    
    NSInteger currentYear = (CurrentAppDelegate.setupState == SETUP_STATE_EDIT_PROFILE) ? CurrentProfile.currentYear : [Year getCurrentYearDate];
    
    return @[
             [[TableViewCellData alloc] initWithDetail:name
                                                  text:@"Name"
                                               reuseId:@"edit"
                                             accessory:UITableViewCellAccessoryNone
                                                 style:UITableViewCellStyleValue1
                                              selected:NO
                                          optionalData:0],
             
             [[TableViewCellData alloc] initWithDetail:[NSString stringWithFormat:@"%lu", (unsigned long)currentYear]
                                                  text:@"Current Year"
                                               reuseId:@"edit"
                                             accessory:UITableViewCellAccessoryNone
                                                 style:UITableViewCellStyleValue1
                                              selected:NO
                                          optionalData:0],
             ];
}

- (NSArray *)getGoalCellDatas {
    NSArray *titles = [[self class] getGoalTitlesForGoals:[GoalMain getAllGoals]];
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
    
    BOOL goalHasBeenSelected = NO;
    if (CurrentProfile.selectedGoalTitle && CurrentAppDelegate.setupState == SETUP_STATE_EDIT_PROFILE) {
        for (TableViewCellData *data in datas) {
            if ([data.text isEqualToString:CurrentProfile.selectedGoalTitle]) {
                data.accessory = UITableViewCellAccessoryCheckmark;
                goalHasBeenSelected = YES;
            }
        }
    }
    
    if (!goalHasBeenSelected) {
        ((TableViewCellData *) datas[0]).accessory = UITableViewCellAccessoryCheckmark;
    }
    
    return datas;
}

+ (NSArray *)getGoalTitlesForGoals:(NSArray *)goals {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (Goal *goal in goals) {
        [titles addObject:goal.title];
    }
    return titles;
}


- (NSMutableArray *)getYearCellDatas {
    NSMutableArray *y;
    
    if (CurrentProfile.yearCollection.years.count > 0 && CurrentAppDelegate.setupState == SETUP_STATE_EDIT_PROFILE) {
        y = [[CurrentProfile getYearsAsTableDatasForSetup] mutableCopy];
    } else {
        y = [[NSMutableArray alloc] initWithObjects:[self getNewYearObjectWithAlreadyExistingYears:NO], nil];
        //Creates new TableViewCellData not year object. Save year object in doneButtonPressed
    }
    
    //Add year button
    [y addObject:[[TableViewCellData alloc] initWithDetail:nil
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
    unsigned long newDate = [Year getCurrentYearDate];
    
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
            [self namePressed];
        } else {
            //Current year cell
            [self currentYearSelectedAndAllowCancelButton:YES];
            
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

- (void)namePressed {
    //Name
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Please enter your name." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = ((TableViewCellData *)_generalCells[0]).detail;
        textField.placeholder = @"Your name";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *name = ((UITextField *)alert.textFields[0]).text;
        name = [name stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
        name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        ((TableViewCellData *)_generalCells[0]).detail = name;
        
        //Update cell
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.detailTextLabel.text = name;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
    
    [self sortAndRefreshYears];
}

- (void)sortAndRefreshYears {
    TableViewCellData *addButton = [_yearCells lastObject];
    [_yearCells removeLastObject];
    
    _yearCells = [[Styles sortArray:_yearCells byPropertyKey:@"text" ascending:NO] mutableCopy];
    [_yearCells addObject:addButton];
    
    for (NSInteger a = 0; a < _yearCells.count; a++) {
        TableViewCellData *data = _yearCells[a];
        NSIndexPath *path = [NSIndexPath indexPathForItem:a inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        
        cell.textLabel.text = data.text;
        if (data.detail) cell.detailTextLabel.text = data.detail;
    }
}

//------------------------------ Edit Years ------------------------------

- (void)yearWasTappedAtRow:(NSInteger)row {
    //Original cell data
    TableViewCellData *tappedYearData = _yearCells[row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Please type in a year (date), then the main NCEA Level for that year." preferredStyle:UIAlertControllerStyleAlert];
    
    //Text fields
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = tappedYearData.text;
        textField.placeholder = @"Year (Date)";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = tappedYearData.detail;
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
    NSString *invalidityMessage;
    
    //Validate year
    NSString *year = ((UITextField *)alert.textFields[0]).text;
    if ([self isString:year NumbersOnlyAndHasCertainNumberOfCharacters:4]) {
        data.text = year;
    } else {
        invalidityMessage = @"Please enter a valid year.";
    }
    
    //Validate level
    NSString *level = [self getLastCharacterOfString:((UITextField *)alert.textFields[1]).text];
    NSUInteger levelInt = [level integerValue];
    if ([self isString:level NumbersOnlyAndHasCertainNumberOfCharacters:1] && levelInt >= 1 && levelInt <= 4) {//Supports NCEA 1-4
        NSString *detail = [NSString stringWithFormat:@"NCEA Level %li", (long) levelInt];
        data.detail = detail;
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
        [invalidityAlert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //Reshow edit window after close
            [self yearWasTappedAtRow:row];
        }]];
        [self presentViewController:invalidityAlert animated:YES completion:nil];
    }
    
    [self sortAndRefreshYears];
    [self makeSureValidCurrentYearIsSelected];
}

- (BOOL)makeSureValidCurrentYearIsSelected {
    NSInteger currentYear = [((TableViewCellData *)_generalCells[1]).detail integerValue];
    
    for (int a = 0; a < _yearCells.count - 1; a++) {
        NSInteger thisYear = [((TableViewCellData *)_yearCells[a]).text integerValue];
        if (currentYear == thisYear) {
            return YES;
            //Current year exists
        }
    }
    
    //Current year doesn't exist
    if (_yearCells.count - 1 > 1) {
        [self currentYearSelectedAndAllowCancelButton:NO];
    } else {
        NSInteger onlyYear = [((TableViewCellData *)_yearCells[0]).text integerValue];
        NSString *onlyYearString = [NSString stringWithFormat:@"%li", (long)onlyYear];
        ((TableViewCellData *)_generalCells[1]).detail = onlyYearString;
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].detailTextLabel.text = onlyYearString;
    }
    return NO;
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
- (void)currentYearSelectedAndAllowCancelButton:(BOOL)allowCancel { //Current Year button (second item)
    NSString *message;
    if (allowCancel) message = @"Choose the current year\n(or close this and add a new one).";
    else message = @"Choose the current year.";
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:AppName
                                message:message
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
    
    if (allowCancel) {
        [alert addAction:
         [UIAlertAction actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                handler:nil]];
    }
    
    alert.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    alert.popoverPresentationController.sourceView = self.tableView;
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setCurrentYear:(NSInteger)indexFromYears {
    NSString *text = [self getYearDatesOfListedYears][indexFromYears];
    ((TableViewCellData *)_generalCells[1]).detail = text;
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
        
        [self makeSureValidCurrentYearIsSelected];
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

- (void)closeSetupWithoutFurtherAdoAndHasSaved:(BOOL)saved {
    if (saved) {
        [self dismissViewControllerAnimated:YES completion:^{
            [_delegate setuphasBeenDismissed];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self closeSetupWithoutFurtherAdoAndHasSaved:NO];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    if (![self checkForDuplicateYears]) {
        
        //Modify current profile
        BOOL wasAbleToSave = [self applySettingsToCurrentProfile];
        
        //Dismiss setup window
        if (wasAbleToSave) {
            [self closeSetupWithoutFurtherAdoAndHasSaved:YES];
        }
        
    } else {
        //Duplicate alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"You seem to have duplicate years. Duplicate NCEA levels are allowed, but not years." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//------------------------------ Subfunctions of done ------------------------------
- (BOOL)checkForDuplicateYears {
    //Shortcut to get year without having to cast to type each time
    TableViewCellData * (^Year)(NSInteger) = ^(NSInteger index) {
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

- (BOOL)applySettingsToCurrentProfile {
    NSString *newName = ((TableViewCellData *)_generalCells[0]).detail;
    
    Profile *p = CurrentProfile;
    
    if (CurrentAppDelegate.setupState == SETUP_STATE_NEW_PROFILE_NOT_INITIAL) {
        if ([self checkForFileConflictWithNewName:newName]) {
            return NO;
        } else {
            p = [[Profile alloc] initWithPropertiesOrNil:nil];
        }
    } else if (CurrentAppDelegate.setupState == SETUP_STATE_EDIT_PROFILE) {
        //not initial setup
        NSString *oldName = CurrentProfile.profileName;
        if (![newName isEqualToString:oldName]) {
            //name changed, must delete old file
            [CurrentAppDelegate deleteProfileWithProfileName:oldName];
        }
    } else {
        //SETUP_STATE_NEW_PROFILE_INITIAL
    }
    
    //Apply general things first
    p.profileName = newName;
    p.currentYear = [((TableViewCellData *)_generalCells[1]).detail integerValue];
    
    //Apply selected goal
    for (TableViewCellData *goalData in _goalCells) {
        if (goalData.accessory == UITableViewCellAccessoryCheckmark) {
            p.selectedGoalTitle = goalData.text;
            break;
        }
    }
    
    //------------------------------ Year stuff ------------------------------
    //Remove add year button so that for-in loops can be used (actual cell isnt removed)
    [_yearCells removeLastObject];
    
    NSMutableArray *yearsToKeep = [[NSMutableArray alloc] init];//Remove all years that are not in _yearCells
    
    //Go through existing years, applying changes to NCEA level
    NSMutableArray *existingYears = p.yearCollection.years;
    for (Year *year in existingYears) {
        //Make sure to find the right year
        for (TableViewCellData *data in _yearCells) {
            if (year.identifier == data.optionalData) { //use ID to find matches
                year.primaryLevelNumber = [[self getLastCharacterOfString:data.detail] integerValue];
                year.yearDate = [data.text integerValue];
                
                [_yearCells removeObject:data]; //Remove data as it's job is done
                [yearsToKeep addObject:year];
                break;
            }
        }
    }
    
    //Create blank years for remaining datas
    for (TableViewCellData *dataToCreateYear in _yearCells) {
        Year *newYear = [[Year alloc] initWithPropertiesOrNil:nil];
        newYear.yearDate = [dataToCreateYear.text integerValue];
        newYear.primaryLevelNumber = [[self getLastCharacterOfString:dataToCreateYear.detail] integerValue];
        newYear.identifier = dataToCreateYear.optionalData;
        [yearsToKeep addObject:newYear];
    }
    
    p.yearCollection.years = yearsToKeep;
    p.currentYear = [((TableViewCellData *)_generalCells[1]).detail integerValue];
    
    if (CurrentAppDelegate.setupState) [CurrentAppDelegate setCurrentProfile:p];
    [CurrentAppDelegate saveCurrentProfileAndAppSettings];
    
    return YES;
}

- (BOOL)checkForFileConflictWithNewName:(NSString *)newName {
    NSArray *profileNames = [CurrentAppDelegate getUsedProfileNames];
    for (NSString *name in profileNames) {
        if ([name isEqualToString:newName]) {
            //name is already used - avoid file conflict
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"There is already a profile with this name." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return YES;
        }
    }
    
    return NO;
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
