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
    self.agreeBtn.selected = YES;
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionToDelegate:(id)sender {
    [self.delegate goToGroupInform];
}

- (IBAction)actionToAgree:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}

//提交申请
- (IBAction)commitApplyAction:(id)sender {
    [self.delegate applayAgent:self.realName.text telephone:self.telephoneNum.text agree:self.agreeBtn.selected];
}
@end

