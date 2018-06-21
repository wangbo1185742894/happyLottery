//
//  PromptCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PromptCell.h"

@implementation PromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.infoLabel.keyWord = @"400-600-5558";
    self.infoLabel.keyWordColor = RGBCOLOR(18, 199, 146);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
