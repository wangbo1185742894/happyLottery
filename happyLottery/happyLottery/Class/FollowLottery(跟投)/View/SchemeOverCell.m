//
//  SchemeOverCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeOverCell.h"

@implementation SchemeOverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}



- (void)reloadDate :(JCZQSchemeItem *)schemeDetail{
    NSMutableArray *mPass = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < schemeDetail.passType.count ;i ++) {
        NSString *str = [schemeDetail.passType objectAtIndex:i];
        if ([str isEqualToString:@"1x1"]) {
            [mPass addObject: @"单关"];
        }else{
            [mPass addObject: [str stringByReplacingOccurrencesOfString:@"x" withString:@"串"]];
        }
    }
    NSString *pass = [mPass componentsJoinedByString:@","];
    self.passType.numberOfLines = 0;
    self.passType.text = pass;
    self.touzhuCount.text =[NSString stringWithFormat:@"%@倍%@注",schemeDetail.multiple,schemeDetail.units];
}

- (float)dateHeight:(JCZQSchemeItem *)schemeDetail{
    NSString *pass = [schemeDetail.passType componentsJoinedByString:@","];
    if ( [pass boundingRectWithSize:CGSizeMake(94, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+30 > 58) {
        return [pass boundingRectWithSize:CGSizeMake(94, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+30;
    }else{
        return 58;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
