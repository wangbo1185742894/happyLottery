//
//  LegOrderIntroTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderIntroTableViewCell.h"


@implementation LegOrderIntroTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.size.width -= 12;
    [super setFrame:frame];
}

- (void)reloadDate:(NSDictionary *)dic {
    self.orderTimeLab.text = dic[@"timeLab"];
    self.orderInfoLab.text = dic[@"infoLab"];
}

@end
