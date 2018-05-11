//
//  SchemeContainInfoCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeContainInfoCell.h"

@implementation SchemeContainInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderNoLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.orderNoLab.layer.borderWidth = 0.5;
    self.orderNoLab.numberOfLines = 2;
    self.groupMatchLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.groupMatchLab.layer.borderWidth = 0.5;
    self.betContentLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.betContentLab.layer.borderWidth = 0.5;
    self.matchResultLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.matchResultLab.layer.borderWidth = 0.5;
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
