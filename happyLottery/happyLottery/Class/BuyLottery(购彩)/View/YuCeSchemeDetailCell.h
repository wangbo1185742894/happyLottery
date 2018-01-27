//
//  YuCeSchemeDetailCell.h
//  Lottery
//
//  Created by onlymac on 2017/10/16.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuCeScheme.h"
#import "jcBetContent.h"
#import "MGLabel.h"
@interface YuCeSchemeDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MGLabel *zhuDuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *keDuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *wangfaLabel;
@property (weak, nonatomic) IBOutlet UILabel *touzhuneirongLabel;
@property (weak, nonatomic) IBOutlet UILabel *rqshuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topwangFaConstraints;
@property(nonatomic,assign)NSInteger num;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)refreshData:(jcBetContent*)scheme;
@end
