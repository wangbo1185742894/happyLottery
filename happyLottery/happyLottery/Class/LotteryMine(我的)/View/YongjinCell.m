//
//  YongjinCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "YongjinCell.h"

@implementation YongjinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(AgentCommissionModel *)model{
    self.labName.text = model.viewName;
    self.labTime.text = model.createTime;
    self.labYongjin.text = [NSString stringWithFormat:@"%.1f",[model.commission doubleValue]];
    self.labTouzhu.text = model.subCost;
    self.imgicon.image = [UIImage imageNamed:[model lotteryIcon]];
}

@end
