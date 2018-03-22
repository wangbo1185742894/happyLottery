//
//  NumberSelectView.h
//  Lottery
//
//  Created by YanYan on 6/4/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberSelectViewDelegate <NSObject>
- (void) didSelectNumber: (int) number;

@end

@interface NumberSelectView : UIView <UITableViewDelegate, UITableViewDataSource> {
    __weak IBOutlet UITableView *tableViewContent_;
    __weak IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
    
    int selectedNumber;
    CGFloat maxListHeight;
}

@property int startNumber;
@property int numberCount;
@property (nonatomic, weak) id<NumberSelectViewDelegate> delegate;

- (void) setup;
- (void) showMeWithSelectedNumber: (int) selectedNum;
- (IBAction) hideMe;
@end
