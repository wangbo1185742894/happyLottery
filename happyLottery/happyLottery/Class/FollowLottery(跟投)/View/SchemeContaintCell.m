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
    if ([Utility isIphone5s]) {
        self.introduceLabel.text = @"————赔率以票面为准，请查看订单详情—————";
    }else {
        self.introduceLabel.text = @"———————赔率以票面为准，请查看订单详情———————";
    }
    self.introduceLabel.keyWord = @"赔率以票面为准，请查看订单详情";
  
    self.introduceLabel.keyWordColor = RGBCOLOR(255, 173, 29);
    self.introduceLabel.keyWordFont =  [UIFont systemFontOfSize:12];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(JCZQSchemeItem * )model{
//    if ([model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        self.introduceLabel.hidden = YES;
        self.dingDan.hidden = YES;
//    }
}

- (IBAction)actionOrderDetail:(id)sender {
    [self.delegate goOrderList];

}

@end
