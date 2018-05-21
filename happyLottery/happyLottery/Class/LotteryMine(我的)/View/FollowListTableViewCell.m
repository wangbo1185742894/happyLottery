

//
//  FollowListTableViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowListTableViewCell.h"

@implementation FollowListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)loadData:(FollowListModel *)model{
    self.labNickName.text = model.selfNickname==nil?[model.selfCardCode stringByReplacingCharactersInRange:NSMakeRange(2,4) withString:@"****"]:model.selfNickname;
    self.labNickName.adjustsFontSizeToFitWidth=YES;
    self.FollowCost.text = [NSString stringWithFormat:@"%.2f",[model.followCost doubleValue]];
    self.bouns.text = [NSString stringWithFormat:@"%.2f",[model.bonus doubleValue]];
    self.yongjin.text = [NSString stringWithFormat:@"%.2f",[model.commission doubleValue]];
}

@end
