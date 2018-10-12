//
//  BuyLotteryModel.m
//  happyLottery
//
//  Created by LYJ on 2018/10/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BuyLotteryModel.h"

@implementation BuyLotteryModel

-(NSString *)lotteryImageName{
    if ([self.lotteryCode isEqualToString:@"DLT"]) {
        return @"icon_daletoushouye.png";
    }
    if ([self.lotteryCode isEqualToString:@"SFC"]) {
        return @"icon_shengfucaishouye.png";
    }
    if ([self.lotteryCode isEqualToString:@"RJC"]) {
        return @"icon_shengfucaishouye.png";
    }
    if ([self.lotteryCode isEqualToString:@"JCZQ"]) {
        return @"icon_jingzu.png";
    }
    if ([self.lotteryCode isEqualToString:@"JCGYJ"]) {
        return @"icon_guanyajun.png";
    }
    if ([self.lotteryCode isEqualToString:@"JCGJ"]) {
        return @"icon_guanyajun.png";
    }
    if ([self.lotteryCode isEqualToString:@"SSQ"]) {
        return @"icon_shuangseqiu.png";
    }
    if ([self.lotteryCode isEqualToString:@"JCLQ"]) {
        return @"icon_jinglan.png";
    }
    if ([self.lotteryCode isEqualToString:@"SX115"]){
        
        return @"icon_shiyixuanwu.png";
        
    }
    if ([self.lotteryCode isEqualToString:@"SD115"]){
        
        return @"sdx115.png";
    }
    if ([self.lotteryCode isEqualToString:@"PL3"]){
        
        return @"icon_pai3.png";
    }
    if ([self.lotteryCode isEqualToString:@"PL5"]){
        
        return @"icon_paiwu.png";
    }
    return @"";
}

@end
