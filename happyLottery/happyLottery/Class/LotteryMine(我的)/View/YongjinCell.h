//
//  YongjinCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentCommissionModel.h"

@interface YongjinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgicon;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTouzhu;
@property (weak, nonatomic) IBOutlet UILabel *labYongjin;
-(void)loadData:(AgentCommissionModel *)model;
@end
