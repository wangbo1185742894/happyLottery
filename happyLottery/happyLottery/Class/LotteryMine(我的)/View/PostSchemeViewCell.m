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
    NSString *pass = [model.passType componentsJoinedByString:@","];
    pass = [pass stringByReplacingOccurrencesOfString:@"x" withString:@"串"];
    labPassType.text = pass;
    labLottery.text = [model getLotteryByName];
    labTime .text = [[model.createTime componentsSeparatedByString:@" "] firstObject];
    labWinState.text = model.getSchemeState;
    if([model .getSchemeState rangeOfString:@"已中奖"].length > 0){
        
        labWonCost.text = [NSString stringWithFormat:@"%@元",model.bonus];
        labWonCost.hidden = NO;
        imgWinState.hidden = NO;
        labWinState.textColor = RGBCOLOR(254, 58, 81);
    }else{
        imgWinState.hidden = YES;
        labWonCost.hidden  = YES;
        labWinState.textColor = [UIColor blackColor];
    }
    
    labZigouCost.text =[NSString stringWithFormat:@"自购：%@元", model.betCost];
}
@end
