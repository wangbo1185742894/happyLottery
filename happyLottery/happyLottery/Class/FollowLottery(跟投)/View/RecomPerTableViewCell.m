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

}

- (void)reloadDate:(RecomPerModel * )model categoryCode:(NSString *)categoryCode{
    if ([categoryCode isEqualToString:@"Cowman"]) {
        self.infoOneSum.hidden = YES;
        self.infoOneLabel.hidden = YES;
        self.infoOneSum.text = nil;
        self.infoOneLabel.text = nil;
        self.infoTwoLabel.text = @"总中奖元";
    } else if ([categoryCode isEqualToString:@"Redman"]){
        self.infoOneLabel.text = @"跟投人次";
        self.infoTwoLabel.text = @"带红人数";
    } else {
        self.infoOneSum.hidden = YES;
        self.infoOneLabel.hidden = YES;
        self.infoOneSum.text = nil;
        self.infoOneLabel.text = nil;
        self.infoTwoLabel.text = @"中奖次数";
    }
}
//- (void)reloadDate:(RecomPerModel * )model{
//    [self.personImage setImage:[UIImage imageNamed:model.personImageName]];
//    self.personName.text = model.personName;
//    self.personInfo.text = model.personInfo;
//}

@end
