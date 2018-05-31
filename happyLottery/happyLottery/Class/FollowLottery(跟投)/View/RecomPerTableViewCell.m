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
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)reloadDate:(RecomPerModel * )model categoryCode:(NSString *)categoryCode{
    self.userName.text = model.nickname==nil?[model.cardCode stringByReplacingCharactersInRange:NSMakeRange(2,4) withString:@"****"]:model.nickname;
    if ([categoryCode isEqualToString:@"Cowman"]) {
        self.infoOneSum.hidden = YES;
        self.infoOneLabel.hidden = YES;
        self.infoTwoLabel.text = @"总中奖(元)";
        if (model.totalBouns==nil) {
            self.infoTwoSum.text = @"0";
        } else {
            
            self.infoTwoSum.text = [NSString stringWithFormat:@"%.2f",[model.totalBouns doubleValue]];
        }
    } else if ([categoryCode isEqualToString:@"Redman"]){
        self.infoOneLabel.text = @"跟投人次";
        self.infoTwoLabel.text = @"带红人次";
        self.infoOneSum.text = model.followCount==nil?@"0":model.followCount;
        self.infoTwoSum.text = model.redCount==nil?@"0":model.redCount;
    } else {
        self.infoOneSum.hidden = YES;
        self.infoOneLabel.hidden = YES;
        self.infoTwoLabel.text = @"中奖次数";
        self.infoTwoSum.text = model.winCount==nil?@"0":model.winCount;
    }
}


@end
