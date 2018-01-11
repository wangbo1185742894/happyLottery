//
//  SchemeInfoViewCell.m
//  happyLottery
//
//  Created by 王博 on 2018/1/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeInfoViewCell.h"

@implementation SchemeInfoViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SchemeInfoViewCell" owner: nil options:nil] lastObject];
    }
    return self;
}

-(void)loadData:(JCZQSchemeItem*)model{
    if ([model.useCoupon boolValue] == YES) {
        
        self.labIsYouhui.text = @"使用优惠券";
    }else{
        self.labIsYouhui.text = @"未使用优惠券";
    }
    self.labZheKouJinE.text = [NSString stringWithFormat:@"%.2f",[model.deduction doubleValue]];
    self.labShiFujine.text =[NSString stringWithFormat:@"%.2f",[model.betCost doubleValue] - [model.deduction doubleValue]];
    self.labZhifuShijian.text = model.finishedTime;
}

@end
