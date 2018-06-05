//
//  AdvantageLeftCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AdvantageLeftCell.h"

@implementation AdvantageLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(NSDictionary *)dic{
    [self.xuHaoImage setImage:[UIImage imageNamed:[dic objectForKey:@"xuhaoImage"]]];
    [self.womanImage setImage:[UIImage imageNamed:[dic objectForKey:@"xuanyanImage"]]];
    self.infoLabelOne.text = [dic objectForKey:@"xuanyanOne"];
    self.infoLabelTwo.text = [dic objectForKey:@"xuanyanTwo"];
    self.infoLabelThree.text = [dic objectForKey:@"xuanyanThree"];
}

@end
