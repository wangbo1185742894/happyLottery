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
    self.touzhuCount.text =[NSString stringWithFormat:@"%@倍%@注",schemeDetail.multiple,schemeDetail.units];
    if ([Utility isIphone5s]) {
        self.widthCons.constant = 70;
        self.leftCons.constant = 5;
        self.rightCons.constant = 5;
    }else {
        self.widthCons.constant = 94;
        self.leftCons.constant = 16;
        self.rightCons.constant = 10;
    }
    self.infoLabel.hidden = YES;
    self.heightCons.constant = 0;
    if ([schemeDetail.lottery isEqualToString:@"JCZQ"]) {
        self.infoLabel.hidden = NO;
        self.heightCons.constant = 27;
    }
    if([schemeDetail.schemeSource isEqualToString:@"BONUS_OPTIMIZE"]){
        self.touzhuText.hidden = YES;
        self.touzhuCount.hidden = YES;
    }else {
        self.touzhuText.hidden = NO;
        self.touzhuCount.hidden = NO;
    }
    if ([schemeDetail.schemeType isEqualToString:@"BUY_FOLLOW"]) {
        if ([schemeDetail.gainRedPacket boolValue]) {
            self.redPackImg.hidden = NO;
            [self.redPackImg setImage:[UIImage imageNamed:@"redNew_close.png"]];
        }else {
            self.redPackImg.hidden = YES;
        }
    } else {
        if ([schemeDetail.hasRedPacket boolValue]) {
            self.redPackImg.hidden = NO;
            [self.redPackImg setImage:[UIImage imageNamed:@"redNew_close.png"]];
        }else {
            self.redPackImg.hidden = YES;
        }
    }
}

- (float)dateHeight:(JCZQSchemeItem *)schemeDetail{
    NSString *pass = [schemeDetail.passType componentsJoinedByString:@","];
    if ([Utility isIphone5s]) {
        if ( [pass boundingRectWithSize:CGSizeMake(70, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+70 > 58) {
            return [pass boundingRectWithSize:CGSizeMake(70, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+70;
        }else{
            return 58;
        }
    }
    else {
        if ( [pass boundingRectWithSize:CGSizeMake(94, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+50 > 58) {
            return [pass boundingRectWithSize:CGSizeMake(94, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height+50;
        }else{
            return 58;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
