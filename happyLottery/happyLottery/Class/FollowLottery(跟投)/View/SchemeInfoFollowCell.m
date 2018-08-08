//
//  SchemeInfoFollowCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeInfoFollowCell.h"

@implementation SchemeInfoFollowCell

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
    self.labBetBouns.text = [NSString stringWithFormat:@"投注%d元",[model.betCost intValue]];
    self.moneyLabel.text = [self getWinningStatus:model];
    if ([model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        self.moneyLabel.textColor = RGBCOLOR(122, 122, 122);
    } else {
        self.moneyLabel.textColor = RGBCOLOR(254, 58, 81);
    }
    self.winLabel.text = model.getSchemeState;
    if ([model.ticketFailRef doubleValue] > 0 && [model.printCount doubleValue] >0) {
        self.labRemark.text = [NSString stringWithFormat:@"（未出票订单已退款）"];
    }else{
        self.labRemark.text = [NSString stringWithFormat:@""];
    }
    if([self.winLabel.text containsString:@"已中奖"]){
        self.moneyLabel.textColor = RGBCOLOR(254, 58, 81);
        [self.winImage setImage:[UIImage imageNamed:@"win.png"]];
        self.winLabel.textColor = RGBCOLOR(254, 58, 81);
        self.winImage.hidden = NO;
        self.winLabel.hidden = YES;
    } else if([self.winLabel.text containsString:@"未中奖"]){
        [self.winImage setImage:[UIImage imageNamed:@"losing.png"]];
        self.winLabel.textColor = [UIColor blackColor];
        self.winImage.hidden = NO;
        self.winLabel.hidden = YES;
    } else {
        self.winImage.hidden = YES;
        self.winLabel.hidden = NO;
        self.winLabel.textColor = [UIColor blackColor];
    }
    if ([model.schemeStatus isEqualToString:@"INIT"]) {
        self.zongShouruLabel.hidden = YES;
        self.moneyLabel.hidden = YES;
        self.winLabel.textColor = [UIColor blackColor];
        self.shuoMingBtn.hidden = YES;
    }
    if ([model.ticketCount integerValue] == 0||[self.winLabel.text isEqualToString:@"待支付"]||[self.winLabel.text isEqualToString:@"方案取消"]||[self.winLabel.text isEqualToString:@"已退款"]||[model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        self.kaijiangOrderLab.text = @"";
    } else {
        self.kaijiangOrderLab.text = [NSString stringWithFormat:@" 当前开奖订单%@/%@单",model.drawCount,model.ticketCount];
    }
}

-(NSString *)getWinningStatus:( JCZQSchemeItem*)model{

    if ([model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        return @"-";
    }
    if ([model.winningStatus isEqualToString:@"NOT_LOTTERY"]) {
        return @"0.00元";
    }
    if ([model.earnings doubleValue] != 0) {
        return [NSString stringWithFormat:@"%.2f元",[model.earnings doubleValue]];
    }
    return @"0.00元";
}

- (IBAction)actionToSHuo:(id)sender {
    [self.delegate showAlertFromFollow];
}

@end
