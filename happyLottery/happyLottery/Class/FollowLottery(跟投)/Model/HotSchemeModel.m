//
//  HotSchemeModel.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "HotSchemeModel.h"

@implementation HotSchemeModel

-(NSString *)lotteryIcon{
    if ([self.lottery isEqualToString:@"DLT"]) {
        return @"daletou.png";
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

-(NSString *)getContent{
    NSArray *pass= [self.passTypes componentsSeparatedByString:@","];
    NSMutableArray *mPass = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str  in pass) {
        if ([str isEqualToString:@"x1"]) {
            [mPass addObject: @"单关"];
        }else{
            [mPass addObject: [str stringByReplacingOccurrencesOfString:@"x" withString:@"串"]];
        }
    }
    
    return [NSString stringWithFormat:@"%@  %@",self.leagueNames,[mPass componentsJoinedByString:@" "]];
}

@end
