//
//  LegOrderStatueWaitTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/7.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderStatueWaitTableViewCell.h"
#import "Utility.h"

@implementation LegOrderStatueWaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.continueBtn.layer.masksToBounds = YES;
    self.continueBtn.layer.cornerRadius = 8;
}

- (IBAction)actionToRecharege:(id)sender {
    [self.delegate actionToRecharge];
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
@end
