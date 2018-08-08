//
//  SuoSchemeViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SuoSchemeViewCell.h"

@implementation SuoSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.publicTime.layer.masksToBounds = YES;
    self.publicTime.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(JCZQSchemeItem * )model{
    [self.publicTime setTitle:[NSString stringWithFormat:@"公开时间：%@", [model.sellEndTime substringWithRange:NSMakeRange(5, 11)]] forState:0];
}

@end
