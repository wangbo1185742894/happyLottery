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

- (IBAction)actionAlert:(id)sender {
    [self.delegate showAlertFromBuy];
}

- (void)reloadDateFromPer:(JCZQSchemeItem * )model{
    [self reloadDate:model];
    self.zhongjiangPerLabel.hidden = NO;
    self.zhongjiangMoneyLabel.hidden = NO;
    self.zhongjiangMoneyLabel.text = self.winMoney.text;
    self.zongshouruLabel.hidden = YES;
    self.moneyLabel.hidden = YES;
    self.fanganLabel.hidden = YES;
    self.zhongjaingjinLabel.hidden = YES;
    self.yongJin.text = nil;
    self.winMoney.text = nil;
    self.helpButton.hidden = YES;
}

- (void)reloadDate:(JCZQSchemeItem * )model{
    if ([model.lottery isEqualToString:@"JCZQ"]) {
        self.loterryLabel.text = @"竞彩足球";
        [self.lotteryImage setImage:[UIImage imageNamed:@"footerball.png"]];
    }else {
        self.loterryLabel.text = @"竞彩篮球";
        [self.lotteryImage setImage:[UIImage imageNamed:@"basketball.png"]];
    }
    
    self.labBetBouns.text = [NSString stringWithFormat:@"投注%d元",[model.betCost intValue]];
    self.winLabel.text = model.getSchemeState;
    if ([model.ticketFailRef doubleValue] > 0 && [model.printCount doubleValue]>0) {
        self.labRemark.text = [NSString stringWithFormat:@"（未出票订单已退款）"];
    }else{
        self.labRemark.text = [NSString stringWithFormat:@""];
    }
    if([self.winLabel.text containsString:@"已中奖"]){
        [self.winImage setImage:[UIImage imageNamed:@"win.png"]];
        self.winLabel.textColor = RGBCOLOR(254, 58, 81);
        self.winImage.hidden = NO;
        self.winLabel.hidden = YES;
    } else if([self.winLabel.text containsString:@"未中奖"]){
        [self.winImage setImage:[UIImage imageNamed:@"losing.png"]];
        self.winImage.hidden = NO;
        self.winLabel.hidden = YES;
        self.winLabel.textColor = [UIColor blackColor];
    } else {
        self.winImage.hidden = YES;
        self.winLabel.hidden = NO;
        self.winLabel.textColor = [UIColor blackColor];
    }
    if ([self.winLabel.text isEqualToString:@"待开奖"]||[self.winLabel.text isEqualToString:@"出票中"]) {
        self.yongJin.text = @"-";
        self.winMoney.text = @"-";
        self.moneyLabel.text = @"-";
        self.yongJin.textColor = RGBCOLOR(122, 122, 122);
        self.winMoney.textColor = RGBCOLOR(122, 122, 122);
        self.moneyLabel.textColor = RGBCOLOR(122, 122, 122);
    } else {
        
        self.yongJin.text = [NSString stringWithFormat:@"%.2f元",[model.totalCommission doubleValue]];
        if (model.bonus==nil) {
            self.winMoney.text = @"0元";
        } else {
            self.winMoney.text = [NSString stringWithFormat:@"%.2f元",[model.bonus doubleValue]];
        }
        float num1 = [model.totalCommission floatValue];
        float num2 = [model.bonus floatValue];
        float sum = num1 + num2;
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",sum];
        self.yongJin.textColor = RGBCOLOR(254, 58, 81);
        self.winMoney.textColor = RGBCOLOR(254, 58, 81);
        self.moneyLabel.textColor = RGBCOLOR(254, 58, 81);
    }
    self.zhongjiangPerLabel.hidden = YES;
    self.zhongjiangMoneyLabel.hidden = YES;
    self.zongshouruLabel.hidden = NO;
    self.moneyLabel.hidden = NO;
    self.fanganLabel.hidden = NO;
    self.zhongjaingjinLabel.hidden = NO;
    self.helpButton.hidden = NO;
    if ([model.ticketCount integerValue] == 0||[model.drawCount integerValue] == 0) {
        self.kaijaingOrderLab.text = @"";
    } else if ([self.winLabel.text containsString:@"已中奖"] ||[self.winLabel.text containsString:@"未中奖"])
    {
         self.kaijaingOrderLab.text = [NSString stringWithFormat:@" 当前开奖订单%@/%@单",model.drawCount,model.ticketCount];
    }else {
        self.kaijaingOrderLab.text = @"";
    }
}

@end
