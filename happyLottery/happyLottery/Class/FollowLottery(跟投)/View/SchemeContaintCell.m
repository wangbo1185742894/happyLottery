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
        self.introduceLabel.text = @"———— 赔率以票面为准，请查看订单详情 —————";
    }else {
        self.introduceLabel.text = @"————— 赔率以票面为准，请查看订单详情 —————";
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

- (void)reloadPassTypeDate:(JCZQSchemeItem *)model{
    NSMutableArray *mPass = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < model.passType.count ;i ++) {
        NSString *str = [model.passType objectAtIndex:i];
        if ([str isEqualToString:@"1x1"]) {
            [mPass addObject: @"单关"];
        }else{
            [mPass addObject: [str stringByReplacingOccurrencesOfString:@"x" withString:@"串"]];
        }
    }
    NSString *pass = [mPass componentsJoinedByString:@","];
    self.passTypeLab.numberOfLines = 0;
    self.passTypeLab.text = pass;
}

- (IBAction)actionOrderDetail:(id)sender {
    [self.delegate goOrderList];

}

- (float)dateHeight:(JCZQSchemeItem *)schemeDetail{
    NSString *pass = [schemeDetail.passType componentsJoinedByString:@","];
    if ([Utility isIphone5s]) {
        return [pass boundingRectWithSize:CGSizeMake(207, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+50;
    }
    else {
        return [pass boundingRectWithSize:CGSizeMake(262, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+50;
    }
}

@end
