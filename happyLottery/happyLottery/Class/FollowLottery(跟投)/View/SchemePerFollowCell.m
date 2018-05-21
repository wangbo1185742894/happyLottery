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
- (IBAction)actionFollowList:(id)sender {
    [self.delegate gotoFollowList];
}

- (void)reloadDate:(JCZQSchemeItem * )model schemeType:(NSString *)schemeType isAttend:(BOOL)isAttend{
    if([schemeType isEqualToString:@"BUY_INITIATE"]){
        [self.guanZhuBtn setTitle:@"跟单列表>" forState:UIControlStateNormal];
        self.genfaLabel.text = @"已跟投";
        self.moneyNameLabel.text = [NSString stringWithFormat:@"%@元",model.totalFollowCost];
    }
    else {
        self.guanZhuBtn.layer.cornerRadius = 5;
        self.guanZhuBtn.layer.borderColor = RGBCOLOR(18, 199, 146).CGColor;
        self.guanZhuBtn.layer.borderWidth = 1;
        NSString *str;
        if (isAttend) {
            str = @"已关注";
        } else {
            str = @"+ 关注";
        }
        [self.guanZhuBtn setTitle:str forState:UIControlStateNormal];
        self.genfaLabel.text = @"发单人";
        self.moneyNameLabel.text = model.initiateNickname== nil?[model.cardCode stringByReplacingCharactersInRange:NSMakeRange(2,4) withString:@"****"]:model.initiateNickname;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
