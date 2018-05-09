//
//  PostSchemeViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowSchemeViewCell.h"
@interface FollowSchemeViewCell()
{
    __weak IBOutlet UIImageView *imgLotteryIcon;
    __weak IBOutlet UILabel *labPersonName;
    __weak IBOutlet UILabel *labZigouCost;
    __weak IBOutlet UIImageView *imgWinState;
    __weak IBOutlet UILabel *labTime;
    
    __weak IBOutlet UIView *labWinState;
    __weak IBOutlet UILabel *labPassType;
    __weak IBOutlet UILabel *labLottery;
}
@end

@implementation FollowSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
