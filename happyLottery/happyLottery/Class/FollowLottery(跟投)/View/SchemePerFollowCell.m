//
//  SchemePerFollowCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemePerFollowCell.h"

@implementation SchemePerFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)reloadDate:(JCZQSchemeItem * )model schemeType:(NSString *)schemeType{
    if([schemeType isEqualToString:@"BUY_INITIATE"]){
        self.guanZhuBtn.titleLabel.text = @"跟单列表 >";
        self.genfaLabel.text = @"已跟投";
        self.moneyNameLabel.text = [NSString stringWithFormat:@"%@元",model.totalFollowCost];
    }
    else {
        self.guanZhuBtn.layer.cornerRadius = 5;
        self.guanZhuBtn.layer.borderColor = RGBCOLOR(18, 199, 146).CGColor;
        self.guanZhuBtn.layer.borderWidth = 1;
        self.guanZhuBtn.titleLabel.text = @"+ 关注";
        self.genfaLabel.text = @"发单人";
        self.moneyNameLabel.text = model.initiateNickname;
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
