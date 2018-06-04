//
//  GroupFollowCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupFollowCell.h"

@implementation GroupFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cornorView.layer.masksToBounds = YES;
    self.cornorView.layer.cornerRadius = 5;
    self.gendanBtn.layer.masksToBounds = YES;
    self.gendanBtn.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(NSString *)followCount{
    self.followCountLab.text = followCount;
}

@end
