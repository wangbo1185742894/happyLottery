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
        return @"icon_guanyajun.png";
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
        
        return @"sdx115.png";
    }
    if ([self.lottery isEqualToString:@"PL3"]){
        
        return @"icon_pai3.png";
    }
    if ([self.lottery isEqualToString:@"PL5"]){
        
        return @"icon_paiwu.png";
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
        NSString *itemNmae  = [_memberTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return  itemNmae;
    }else{
        return _nickName;
    }
}

@end
