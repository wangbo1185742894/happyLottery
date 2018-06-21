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
        return @"shengfucai.png";
    }
    if ([self.lottery isEqualToString:@"JCZQ"]) {
        return @"footerball.png";
    }
    if ([self.lottery isEqualToString:@"JCGYJ"]) {
        return @"Championship.png";
    }
    if ([self.lottery isEqualToString:@"JCGJ"]) {
        return @"first.png";
    }
    if ([self.lottery isEqualToString:@"SSQ"]) {
        return @"shuangseqiu.png";
    }
    if ([self.lottery isEqualToString:@"JCLQ"]) {
        return @"basketball.png";
    }
    return @"";
}


@end
