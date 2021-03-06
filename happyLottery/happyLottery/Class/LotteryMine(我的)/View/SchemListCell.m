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
    __weak IBOutlet NSLayoutConstraint *imagIconHeight;
    __weak IBOutlet NSLayoutConstraint *imageIconWidth;
    
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
    if ([model.costType isEqualToString:@"CASH"]) {
        labSchemeCost.text = [NSString stringWithFormat:@"%@元",model.betCost] ;

    }else{
        
        labSchemeCost.text = [NSString stringWithFormat:@"%@分",model.betCost] ;
    }
    labSchemeDate.text = [[model.createTime componentsSeparatedByString:@" "] firstObject];
    
    labSchemeLottery.text = [self getLotteryByCode:model.lottery];
    imgLotteryIcon.image = [UIImage imageNamed:model.lotteryIcon];
    if ([model.lottery isEqualToString:@"JCGJ"]||[model.lotteryIcon isEqualToString:@"JCGYJ"]||[model.lottery isEqualToString:@"DLT"]||[model.lottery isEqualToString:@"SSQ"]) {
//        imagIconHeight.constant = 39;
//        imageIconWidth.constant = 39;
    }
    
    labSchemeState.text = [model getSchemeState];
    
    BOOL isWon = [[model getSchemeState] containsString:@"已中奖"] || [[model getSchemeState] containsString:@"中奖(已取票)"];
    
    imgWinState.hidden = !isWon;
    if (isWon) {
        labSchemeState.textColor = SystemRed;
        if ([model.costType isEqualToString:@"CASH"]) {
            labSchemeState.text = [NSString stringWithFormat:@"中奖%.2f元",[model.bonus doubleValue]];
        }else{
            labSchemeState.text = [NSString stringWithFormat:@"中奖%.2f分",[model.bonus doubleValue]];
        }
    }else{
        labSchemeState.textColor = SystemLightGray;
    }
}

-(NSString *)getLotteryByCode:(NSString *)code{
     return [BaseModel getLotteryByName:code];
}

@end
