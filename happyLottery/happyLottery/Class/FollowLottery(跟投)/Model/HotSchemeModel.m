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

-(NSString *)getDetailContent{
    NSArray *pass= [self.passTypes componentsSeparatedByString:@","];
    NSMutableArray *mPass = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str  in pass) {
        if ([str isEqualToString:@"1x1"]) {
            [mPass addObject: @"单关"];
        }else{
            [mPass addObject: [str stringByReplacingOccurrencesOfString:@"x" withString:@"串"]];
        }
    }
    
    return [NSString stringWithFormat:@"%@  %@",self.leagueNames,[mPass componentsJoinedByString:@" "]];
}

-(NSString *)getContent{
    NSArray *pass= [self.passTypes componentsSeparatedByString:@","];
    NSMutableArray *mPass = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < pass.count ;i ++) {
        NSString *str = [pass objectAtIndex:i];
        if (i >=2) {
            break;
        }
        if ([str isEqualToString:@"1x1"]) {
            [mPass addObject: @"单关"];
        }else{
            [mPass addObject: [str stringByReplacingOccurrencesOfString:@"x" withString:@"串"]];
        }
    }
    
    NSArray *leaArray= [self.leagueNames componentsSeparatedByString:@","];
    NSMutableArray *mleaArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < leaArray.count ;i ++) {
        NSString *str = [leaArray objectAtIndex:i];
        if (i >=2) {
            break;
        }
        [mleaArray addObject: str];
    }
    return [NSString stringWithFormat:@"%@  %@",[mleaArray  componentsJoinedByString:@" "],[mPass componentsJoinedByString:@" "]];
}
-(NSString *)nickName{
    if (_nickName == nil || _nickName.length == 0) {
        NSString *itemNmae  = [_cardCode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"****"];
        return  itemNmae;
    }else{
        return _nickName;
    }
}

@end
