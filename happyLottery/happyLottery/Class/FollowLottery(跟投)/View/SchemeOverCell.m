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
    
    NSString *pass = [schemeDetail.passType componentsJoinedByString:@","];
    pass = [pass stringByReplacingOccurrencesOfString:@"x" withString:@"串"];
    self.passType.numberOfLines = 0;
    self.passType.text = pass;
    self.touzhuCount.text =[NSString stringWithFormat:@"%@倍%@注",schemeDetail.multiple,schemeDetail.units];
}

- (float)dateHeight:(JCZQSchemeItem *)schemeDetail{
    NSString *pass = [schemeDetail.passType componentsJoinedByString:@","];
    if ( [pass boundingRectWithSize:CGSizeMake(94, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+6 > 58) {
        return [pass boundingRectWithSize:CGSizeMake(94, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+6;
    }else{
        return 58;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
