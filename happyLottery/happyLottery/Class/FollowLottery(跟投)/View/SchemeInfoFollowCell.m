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
    self.labBetBouns.text = model.betCost;
    self.moneyLabel.text = [self getWinningStatus:model];
    
}

-(NSString *)getWinningStatus:( JCZQSchemeItem*)model{
    if ([model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        self.winImage.hidden = YES;
        self.winLabel.text = @"待开奖";
        return @"0.00元";
    }
    if ([model.winningStatus isEqualToString:@"NOT_LOTTERY"]) {
        [self.winImage setImage:[UIImage imageNamed:@"losing.png"]];
        self.winLabel.text = @"未中奖";
        return @"0.00元";
    }
    if ([model.bonus doubleValue] != 0) {
        [self.winImage setImage:[UIImage imageNamed:@"win.png"]];
        self.winLabel.text = @"已中奖";
        return [NSString stringWithFormat:@"%.2f元",[model.bonus doubleValue]];
    }
    return @"0.00元";
}

@end
