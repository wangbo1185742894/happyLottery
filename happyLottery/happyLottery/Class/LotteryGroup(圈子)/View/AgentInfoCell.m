//
//  AgentInfoCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AgentInfoCell.h"

@implementation AgentInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headUrlImge.clipsToBounds = NO;
    self.headUrlImge.contentMode = UIViewContentModeScaleAspectFit;
    self.headUrlImge.layer.cornerRadius = self.headUrlImge.mj_h / 2;
    self.headUrlImge.layer.masksToBounds = YES;
    self.headUrlImge.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headUrlImge.layer.borderWidth = 2;
    if ([Utility isIphoneX]) {
        self.shareBtnTopCon.constant = 35;
    } else {
        self.shareBtnTopCon.constant = 25;
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionToMember:(id)sender {
    [self.delegate agentMember];
    
}

- (IBAction)actionToShare:(id)sender {
    [self.delegate actionShare];
}

- (void)reloadDate:(AgentInfoModel *)model isMaster:(BOOL)ismaster{
    [self.headUrlImge sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"] completed:nil];
    if (model.circleName.length == 0) {
        self.circleNameLab.text = [NSString stringWithFormat:@"@%@",model._id];
    } else {
        self.circleNameLab.text = model.circleName;
    }
    if (model.notice.length == 0) {
        self.circleNotice.text = @"投必中圈子帮你发现，更多中奖的理由和信息...";
    } else {
        self.circleNotice.text = model.notice;
    }
    self.memberCountLab.text = model.memberCount;
    self.totalBonusLab.text = [NSString stringWithFormat:@"%.2f",[model.totalBonus doubleValue]];
    if (ismaster ) {
        self.shareBtn.hidden = NO;
    }else {
        self.shareBtn.hidden = YES;
    }
}

@end
