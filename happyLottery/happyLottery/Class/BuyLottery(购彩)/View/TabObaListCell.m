//
//  TabObaListCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "TabObaListCell.h"

@implementation TabObaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadData:(LegWordModel *)model{
    if (model.isSelect == YES) {
        self.labObaRemark.text = @"注：倒计时结束后会默认选中他";
    }else{
        self.labObaRemark.text = @"";
    }
    self.labObaName.text = model.legName;
    if ([model.cost integerValue] == 0) {
        self.labObaCost.text = @"";
    }else{
        self.labObaCost.text = [NSString stringWithFormat:@"一次%@元",model.cost];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
