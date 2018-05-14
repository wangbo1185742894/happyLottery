//
//  PersonCenterCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PersonCenterCell.h"


@implementation PersonCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImage.clipsToBounds = NO;
    self.userImage.contentMode = UIViewContentModeScaleAspectFit;
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds = YES;
    self.initiateStatusFirst.layer.cornerRadius = self.initiateStatusFirst.mj_h / 2;
    self.initiateStatusFirst.layer.masksToBounds = YES;
    self.initiateStatusTwo.layer.cornerRadius = self.initiateStatusTwo.mj_h / 2;
    self.initiateStatusTwo.layer.masksToBounds = YES;
    self.initiateStatusThird.layer.cornerRadius = self.initiateStatusThird.mj_h / 2;
    self.initiateStatusThird.layer.masksToBounds = YES;
    self.initiateStatusForth.layer.cornerRadius = self.initiateStatusForth.mj_h / 2;
    self.initiateStatusForth.layer.masksToBounds = YES;
    self.initiateStatusFifth.layer.cornerRadius = self.initiateStatusFifth.mj_h / 2;
    self.initiateStatusFifth.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell:(PersonCenterModel *)model{
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"]];
    self.userName.text = model.nickName;
    self.fenshiNum.text = [NSString stringWithFormat:@"粉丝%@人",model.attentCount];
    self.initiateStatusSum.text = [NSString stringWithFormat:@"%@元",model.totalInitiateBonus];
}

@end
