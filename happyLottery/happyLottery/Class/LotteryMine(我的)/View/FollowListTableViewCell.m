

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
    if ([model.gainRedPacket boolValue]) {
        self.redImage.hidden = NO;
        if ([model.openStatus isEqualToString:@"LOCK"]) {
            [self.redImage setImage:[UIImage imageNamed:@"rengouredsuoding.png"]];
        }else if ([model.openStatus isEqualToString:@"UN_OPEN"]) {
            [self.redImage setImage:[UIImage imageNamed:@"rengouredjiesuo.png"]];
        }else if ([model.openStatus isEqualToString:@"OPEN"]) {
            [self.redImage setImage:[UIImage imageNamed:@"rengoureddakai.png"]];
        }else if ([model.openStatus isEqualToString:@"INVALID"]) {
            [self.redImage setImage:[UIImage imageNamed:@"rengouredsuoding.png"]];
        }
    }else {
        self.redImage.hidden = YES;
    }
}

@end
