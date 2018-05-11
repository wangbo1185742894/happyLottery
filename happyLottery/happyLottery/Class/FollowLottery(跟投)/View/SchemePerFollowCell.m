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
    self.guanZhuBtn.layer.cornerRadius = 5;
    self.guanZhuBtn.layer.borderColor = [UIColor greenColor].CGColor;
    self.guanZhuBtn.layer.borderWidth = 1;
//    if("跟单"){
//    self.genfaLabel.text = @"发单人";
//    self.moneyNameLabel.text = @"张三";
//
//    }
//    else {
//        self.genfaLabel.text = @"已跟投";
//        self.moneyNameLabel.text = @"888元";
//    }
    /*
     
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
