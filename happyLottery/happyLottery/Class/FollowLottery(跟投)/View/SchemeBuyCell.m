//
//  SchemeBuyCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeBuyCell.h"

@implementation SchemeBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(JCZQSchemeItem*)model{
    if ([model.useCoupon boolValue] == YES) {
        self.labIsYouhui.text = @"使用优惠券";
    }else{
        self.labIsYouhui.text = @"未使用优惠券";
    }
    if ([model.costType isEqualToString:@"CASH"]) {
        self.labZheKouJinE.text = [NSString stringWithFormat:@"%.2f元",[model.deduction doubleValue]];
        self.labShiFujine.text =[NSString stringWithFormat:@"%.2f元",[model.realSubAmounts doubleValue]];
        self.labZhifuShijian.text = model.subTime;
    }
}

@end
