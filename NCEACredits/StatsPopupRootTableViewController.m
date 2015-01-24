//
//  StatsPopupRootTableViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 14/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "StatsPopupRootTableViewController.h"
#import "StatsPopupNavViewController.h"

#define ALL_SUBJECTS_TITLE @"All Subjects"
#define TITLE_SPACE @" - "
#define CREDIT_GRADE_FORMAT @"%li (%@)"
#define SUBJECT_FORMAT @"%@ (%lu/%lu)"

@interface StatsPopupRootTableViewController ()

@end

@implementation StatsPopupRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setValuesRequired];
    [self setTitle];
}

- (void)setValuesRequired {
    StatsPopupNavViewController *vc = (StatsPopupNavViewController *)self.navigationController;
    _subjectOrNilForTotal = vc.subjectOrNilForTotal;
    _subjectsArrayOfAssessmentsArrays = vc.subjectsArrayOfAssessmentsArrays;
    _gradeText = vc.gradeText;
    _priorityText = vc.priorityText;
}

- (void)setTitle {
    NSString *title;
    
    if (_subjectOrNilForTotal) title = _subjectOrNilForTotal;
    else title = ALL_SUBJECTS_TITLE;
    
    title = [title stringByAppendingString:[NSString stringWithFormat:@"%@%@", TITLE_SPACE, _priorityText]];
    
    self.navigationItem.title = title;
}

- (NSUInteger)getTotalCredits {
    if (_totalCredits) return _totalCredits;
    
    NSUInteger total = 0;
    for (NSArray *assessmentsForSubject in _subjectsArrayOfAssessmentsArrays) {
        for (Assessment *assessment in assessmentsForSubject) {
            total += assessment.creditsWhenAchieved;
        }
    }
    
    _totalCredits = total;
    return total;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = _subjectsArrayOfAssessmentsArrays.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = ((NSArray *)_subjectsArrayOfAssessmentsArrays[section]).count;
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *assessmentArray = _subjectsArrayOfAssessmentsArrays[section];
    Assessment *a = assessmentArray[0];
    
    NSUInteger total = [self getTotalCredits];
    NSUInteger subjectCredits = 0;
    for (Assessment *assessment in assessmentArray) {
        subjectCredits += assessment.creditsWhenAchieved;
    }
    
    return [NSString stringWithFormat:SUBJECT_FORMAT, a.subject, (unsigned long)subjectCredits, (unsigned long)total];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assessmentGradeCell" forIndexPath:indexPath];
    
    NSArray *assessmentsForSubject = _subjectsArrayOfAssessmentsArrays[indexPath.section];
    Assessment *assessment = assessmentsForSubject[indexPath.row];

    cell.textLabel.text = assessment.quickName;
    cell.detailTextLabel.text = [NSString stringWithFormat:CREDIT_GRADE_FORMAT, (unsigned long)assessment.creditsWhenAchieved, [[self class] getGradeTextForCellWithGradeText:_gradeText]];
    
    return cell;
}

+ (NSString *)getGradeTextForCellWithGradeText:(NSString *)text {
    if (text.length == 0) return @"None";
    
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSString *abbr = @"";
    for (NSString *word in words) {
        abbr = [abbr stringByAppendingString:[word substringToIndex:1]];
    }
    
    return abbr;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Navigation    ************************************
//*************************
//****************
//*********
//****
//*

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
