//
//  OmitEnquiresTableViewCell.h
//  Lottery
//
//  Created by only on 16/11/9.
//  Copyright © 2016年 AMP. All rights reserved.
//

//11选5遗漏查询
#import <UIKit/UIKit.h>
#import "QmitModel.h"
#define NSNotificationModelSelect @"NSNotificationModelSelect"
@interface OmitEnquiresTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property(assign,nonatomic)NSInteger selectNum;
@property (weak, nonatomic) IBOutlet UILabel *avgNumbsLabel;//平均遗漏
@property (weak, nonatomic) IBOutlet UILabel *preOutProbLabel;//欲出几率
@property (weak, nonatomic) IBOutlet UILabel *curDayOutLabel;//本日已出
@property (weak, nonatomic) IBOutlet UILabel *daysNoOutLabel;
@property(strong,nonatomic)QmitModel *model;

@property (nonatomic, copy) NSString * sureString;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)setCellValueFromModel:(QmitModel *)model andIndexPath:(NSIndexPath *)indexPath;
@end
