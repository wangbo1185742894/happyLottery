//
//  PostSchemeViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowSchemeViewCell.h"
@interface FollowSchemeViewCell()
{
    __weak IBOutlet UIImageView *imgLotteryIcon;
    __weak IBOutlet UILabel *labPersonName;
    __weak IBOutlet UILabel *labZigouCost;
    __weak IBOutlet UIImageView *imgWinState;
    __weak IBOutlet UILabel *labTime;
    
    __weak IBOutlet UILabel *labWinState;
    __weak IBOutlet UILabel *labPassType;
    __weak IBOutlet UILabel *labLottery;
    __weak IBOutlet UILabel *labWonCost;
}
@end

@implementation FollowSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    imgLotteryIcon.layer.cornerRadius = imgLotteryIcon.mj_h / 2;
    imgLotteryIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadData:(JCZQSchemeItem * )model{
    if (model.initiateUrl .length == 0) {
        [imgLotteryIcon setImage:[UIImage imageNamed:@"usermine"]];
    }else{
        [imgLotteryIcon sd_setImageWithURL:[NSURL URLWithString:model.initiateUrl]];
    }
    labPersonName.text = model.initiateNickname == nil?[model.mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"]:model.initiateNickname;
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
        labWinState.textColor = SystemLightGray;;
    }
    
    labZigouCost.text =[NSString stringWithFormat:@"跟投：%@元", model.betCost];
}

@end
