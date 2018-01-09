//
//  SchemListCell.m
//  happyLottery
//
//  Created by 王博 on 2018/1/3.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemListCell.h"

@interface SchemListCell ()
{
    
    __weak IBOutlet UILabel *labSchemeCost;
    __weak IBOutlet UILabel *labSchemeDate;
    __weak IBOutlet UILabel *labSchemeLottery;
    __weak IBOutlet UILabel *labSchemeState;
    __weak IBOutlet UIImageView *imgLotteryIcon;
    __weak IBOutlet UIImageView *imgWinState;
}
@end

@implementation SchemListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"SchemListCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)refreshData:(JCZQSchemeItem*)model{
    labSchemeCost.text = [NSString stringWithFormat:@"%@元",model.betCost] ;
    labSchemeDate.text = [[model.createTime componentsSeparatedByString:@" "] firstObject];
    
    labSchemeLottery.text = [self getLotteryByCode:model.lottery];
    imgLotteryIcon.image = [UIImage imageNamed:model.lotteryIcon];
    imgWinState.hidden = ![model.won boolValue];
    
    labSchemeState.text = [model getSchemeState];
}

-(NSString *)getLotteryByCode:(NSString *)code{
    if ([code isEqualToString:@"JCZQ"]) {
        return @"竞彩足球";
    } //以后加彩种 在这加
    return @"彩票";
}

@end
