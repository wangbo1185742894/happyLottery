//
//  SchemeContaintCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeContaintCell.h"
#import "JCLQOrderDetailInfoViewController.h"

@implementation SchemeContaintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)actionOrderDetail:(id)sender {
    [self.delegate goOrderList];

}

@end
