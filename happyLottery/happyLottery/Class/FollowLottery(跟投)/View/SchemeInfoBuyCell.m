//
//  SchemeInfoBuyCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeInfoBuyCell.h"

@implementation SchemeInfoBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(JCZQSchemeItem * )model{
    
   
    if ([model.lottery isEqualToString:@"JCZQ"]) {
        self.loterryLabel.text = @"竞彩足球";
        [self.lotteryImage setImage:[UIImage imageNamed:@"footerball.png"]];
    }else {
        self.loterryLabel.text = @"竞彩篮球";
        [self.lotteryImage setImage:[UIImage imageNamed:@"basketball.png"]];
    }
    self.labBetBouns.text = [NSString stringWithFormat:@"投注%@元",model.betCost];
    self.winLabel.text = model.getSchemeState;
    if([self.winLabel.text containsString:@"已中奖"]){
        [self.winImage setImage:[UIImage imageNamed:@"win.png"]];
        self.winLabel.textColor = RGBCOLOR(254, 58, 81);
        self.winImage.hidden = NO;
    } else if([self.winLabel.text containsString:@"未中奖"]){
        [self.winImage setImage:[UIImage imageNamed:@"losing.png"]];
        self.winImage.hidden = NO;
        self.winLabel.textColor = [UIColor blackColor];
    } else {
        self.winImage.hidden = YES;
        self.winLabel.textColor = [UIColor blackColor];
    }
    if ([self.winLabel.text isEqualToString:@"待开奖"]) {
        self.yongJin.text = @"-";
        self.winMoney.text = @"-";
        self.moneyLabel.text = @"-";
        self.yongJin.textColor = RGBCOLOR(122, 122, 122);
        self.winMoney.textColor = RGBCOLOR(122, 122, 122);
        self.moneyLabel.textColor = RGBCOLOR(122, 122, 122);
    } else {
        self.yongJin.text = [NSString stringWithFormat:@"%@元",model.totalCommission];
        self.winMoney.text = [NSString stringWithFormat:@"%@元",model.earnings==nil?@"0":model.earnings];
        int num1 = [model.totalCommission intValue];
        int num2 = [model.earnings intValue];
        int sum = num1 + num2;
        self.moneyLabel.text = [NSString stringWithFormat:@"%d元",sum];
        self.yongJin.textColor = RGBCOLOR(254, 58, 81);
        self.winMoney.textColor = RGBCOLOR(254, 58, 81);
        self.moneyLabel.textColor = RGBCOLOR(254, 58, 81);
    }
  
}

@end
