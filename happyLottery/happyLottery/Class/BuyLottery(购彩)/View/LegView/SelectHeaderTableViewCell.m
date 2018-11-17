//
//  SelectHeaderTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SelectHeaderTableViewCell.h"

@implementation SelectHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)reloadDateWithMoney:(double)money{
    _moneyLab.text = [NSString stringWithFormat:@"%.2f元", money];
}

@end
