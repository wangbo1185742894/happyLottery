//
//  ApplyInputCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ApplyInputCell.h"



@implementation ApplyInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)commitApplyAction:(id)sender {
    [self.delegate applayAgent:self.realName.text telephone:self.telephoneNum.text];
}
@end
