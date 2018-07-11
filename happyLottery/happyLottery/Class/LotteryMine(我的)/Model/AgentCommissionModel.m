//
//  AgentCommissionModel.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AgentCommissionModel.h"

@implementation AgentCommissionModel

-(NSString *)lotteryIcon{
    if ([self.lottery isEqualToString:@"DLT"]) {
        return @"icon_daletoushouye.png";
    }
    if ([self.lottery isEqualToString:@"SFC"] || [self.lottery isEqualToString:@"RJC"]) {
        return @"icon_shengfucaishouye.png";
    }
    if ([self.lottery isEqualToString:@"JCZQ"]) {
        return @"icon_jingzu.png";
    }
    if ([self.lottery isEqualToString:@"JCGYJ"]) {
        return @"icon_guanyajun.png";
    }
    if ([self.lottery isEqualToString:@"JCGJ"]) {
        return @"first.png";
    }
    if ([self.lottery isEqualToString:@"SSQ"]) {
        return @"icon_shuangseqiu.png";
    }
    if ([self.lottery isEqualToString:@"JCLQ"]) {
        return @"icon_jinglan.png";
    }
    if ([self.lottery isEqualToString:@"SX115"]){
        
        return @"icon_shiyixuanwu.png";
        
    }
    if ([self.lottery isEqualToString:@"SD115"]){
        
        return @"icon_sdx115.png";
    }
    if ([self.lottery isEqualToString:@"PL3"]){
        
        return @"icon_pai3.png";
    }
    if ([self.lottery isEqualToString:@"PL5"]){
        
        return @"icon_paiwu.png";
    }
    return @"";
}


@end
