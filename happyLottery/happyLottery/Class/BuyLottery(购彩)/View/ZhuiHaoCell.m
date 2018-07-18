//
//  ZhuiHaoCell.m
//  happyLottery
//
//  Created by LYJ on 2018/7/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ZhuiHaoCell.h"

@implementation ZhuiHaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.beiShutf.layer.borderColor = RGBCOLOR(230, 230, 230).CGColor;
    self.beiShutf.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionDown:(id)sender {
    if ([self.beiShutf.text integerValue] <=1) {
        return;
    }
    [self.delegate beishuChange:@"down" sender:sender];
}
- (IBAction)actionUp:(id)sender {
    if ([self.beiShutf.text integerValue] >= 99) {
        return;
    }
    [self.delegate beishuChange:@"up" sender:sender];
}

@end
