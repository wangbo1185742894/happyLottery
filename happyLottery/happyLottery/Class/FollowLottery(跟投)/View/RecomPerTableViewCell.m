//
//  RecomPerTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//


#import "RecomPerTableViewCell.h"

@implementation RecomPerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.orderImage.clipsToBounds = NO;
    self.orderImage.contentMode = UIViewContentModeScaleAspectFit;
    self.userImage.clipsToBounds = NO;
    self.userImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(RecomPerModel * )model categoryCode:(NSString *)categoryCode{
    self.userName.text = model.nickname;
    
    if ([categoryCode isEqualToString:@"Cowman"]) {
        self.infoOneSum.hidden = YES;
        self.infoOneLabel.hidden = YES;
        self.infoTwoLabel.text = @"总中奖元";
        self.infoTwoSum.text = model.totalBonus==nil?@"0":model.totalBonus ;
    } else if ([categoryCode isEqualToString:@"Redman"]){
        self.infoOneLabel.text = @"跟投人次";
        self.infoTwoLabel.text = @"带红人数";
        self.infoOneSum.text = model.followCount;
        self.infoTwoSum.text = model.redCount;
    } else {
        self.infoOneSum.hidden = YES;
        self.infoOneLabel.hidden = YES;
        self.infoTwoLabel.text = @"中奖次数";
        self.infoTwoSum.text = model.winCount;
    }
}
//- (void)reloadDate:(RecomPerModel * )model{
//    [self.personImage setImage:[UIImage imageNamed:model.personImageName]];
//    self.personName.text = model.personName;
//    self.personInfo.text = model.personInfo;
//}

@end
