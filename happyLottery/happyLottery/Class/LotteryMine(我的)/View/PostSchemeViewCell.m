//
//  PostSchemeViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PostSchemeViewCell.h"

@interface PostSchemeViewCell()
{
    __weak IBOutlet UILabel *labWonCost;
    __weak IBOutlet UIImageView *imgLotteryIcon;
    __weak IBOutlet UILabel *labZigouCost;
    __weak IBOutlet UIImageView *imgWinState;
    __weak IBOutlet UILabel *labTime;
    
    __weak IBOutlet UILabel *labWinState;
    __weak IBOutlet UILabel *labPassType;
    __weak IBOutlet UILabel *labLottery;
}
@end

@implementation PostSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadData:(JCZQSchemeItem * )model{
    [imgLotteryIcon setImage:[UIImage imageNamed:model.lotteryIcon]];
    NSMutableArray *mPass = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < model.passType.count ;i ++) {
        NSString *str = [model.passType objectAtIndex:i];
        if ([str isEqualToString:@"1x1"]) {
            [mPass addObject: @"单关"];
        }else{
            [mPass addObject: [str stringByReplacingOccurrencesOfString:@"x" withString:@"串"]];
        }
    }
    NSString *pass = [mPass componentsJoinedByString:@","];
    
    labPassType.text = pass;
    labLottery.text = [model getLotteryByName];
    labTime .text = [[model.createTime componentsSeparatedByString:@" "] firstObject];
    labWinState.text = model.getSchemeState;
    if([model .getSchemeState rangeOfString:@"已中奖"].length > 0){
         labWinState.text = @"中奖";
        labWonCost.text = [NSString stringWithFormat:@"%.2f元",[model.bonus doubleValue]];
        labWonCost.hidden = NO;
        imgWinState.hidden = NO;
        labWinState.textColor = RGBCOLOR(254, 58, 81);
    }else{
         labWinState.text = model.getSchemeState;
        imgWinState.hidden = YES;
        labWonCost.hidden  = YES;
        labWinState.textColor = SystemLightGray;
    }
    
    labZigouCost.text =[NSString stringWithFormat:@"自购：%@元", model.betCost];
}
@end
