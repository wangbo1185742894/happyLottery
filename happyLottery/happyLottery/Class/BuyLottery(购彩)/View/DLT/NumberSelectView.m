//
//  NumberSelectView.m
//  Lottery
//
//  Created by YanYan on 6/4/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "NumberSelectView.h"

#define VerticalPadding 50
@implementation NumberSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) setup {
    self.clipsToBounds = YES;
    
    tableViewContent_.delegate = self;
    tableViewContent_.dataSource = self;
    self.numberCount = 0;
    self.startNumber = 0;
    maxListHeight = self.bounds.size.height - VerticalPadding * 2;
}

- (void) showMeWithSelectedNumber: (int) selectedNum {
    NSInteger cellCount = [self tableView: tableViewContent_ numberOfRowsInSection: 0];
    CGFloat tableViewHeight = cellCount*[self tableView: tableViewContent_ heightForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]];
    
    if (tableViewHeight > maxListHeight) {
        tableViewHeight = maxListHeight;
    }
    tableViewHeightConstraint.constant = tableViewHeight;
    
    selectedNumber = selectedNum;
    [tableViewContent_ reloadData];
    
    self.alpha = 0;
    [self.superview bringSubviewToFront: self];
    [UIView animateWithDuration: 0.3
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];
}

- (IBAction) hideMe {
    [UIView animateWithDuration: 0.3
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.superview sendSubviewToBack: self];
                     }];
}

- (int) numberForRow: (NSIndexPath *) indexPath {
    int curNumber = self.startNumber + (int)indexPath.row;
    return curNumber;
}

#pragma UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    int curNumber = [self numberForRow: indexPath];
    cell.textLabel.text = [NSString stringWithFormat: @"%d", curNumber];
    if (curNumber == selectedNumber) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableViewContent_ deselectRowAtIndexPath: indexPath animated: YES];
    int curNumber = [self numberForRow: indexPath];
    if (curNumber != selectedNumber) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: selectedNumber-self.startNumber inSection: 0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell = [tableView cellForRowAtIndexPath: indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    
    selectedNumber = curNumber;
    [self.delegate didSelectNumber: selectedNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
@end
