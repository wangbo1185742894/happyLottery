//
//  CTZQMatch.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQMatch.h"

@implementation CTZQMatch
-(instancetype)init{
    if (self =[super init]) {
        self.selectedS = @"0";
        self.selectedP = @"0";
        self.selectedF = @"0";
        self.danTuo = @"0";
        self.oddsSStr = [[NSMutableAttributedString alloc] initWithString:@""];
        self.oddsPStr = [[NSMutableAttributedString alloc] initWithString:@""];
        self.oddsFStr = [[NSMutableAttributedString alloc] initWithString:@""];
        
        _oddsS = @"0";
        _oddsP = @"0";
        _oddsF = @"0";
        _oddsSNum = @"1.0";
        _oddsPNum = @"1.0";
        _oddsFNum = @"1.0";
        
    }
    return self;
}

- (void)matchInfoWith:(NSDictionary *)infoDic{
//    match.id_ = [NSString stringWithFormat:@"%zd",i];
//    match.guestName = [NSString stringWithFormat:@"34萨克斯城竞技new"];    //萨克斯城竞技
//    match.homeName = [NSString stringWithFormat:@"12温哥华白帽op"];     // 温哥华白帽
//    match.hot = [NSString stringWithFormat:@"%@",@(100+i)];          // 0
//    match.leagueName = [NSString stringWithFormat:@"美联"];   // 美国职业大联
//    
//    match.matchNum = [NSString stringWithFormat:@"%@",@(i+1)];       // 周日 035
//    
//    match.matchDate = @"2016-03-31";        //
//    match.matchKey = [NSString stringWithFormat:@"%zd",20160428+i];     //150712035
//    match.startTime = [NSString stringWithFormat:@"03-30 12:45"];    // 2015-07-13
//    match.status = @"0";       // 0
//    
//    match.oddsS = @"0";
//    match.oddsP = @"1";
//    match.oddsF = @"-1";
//    match.oddsSNum = @"2.3";
//    match.oddsPNum = @"-3.4";
//    match.oddsFNum = @"4.5";
    self.id_ = [NSString stringWithFormat:@"%@",infoDic[@"serialNumber"]];
    self.matchNum = self.id_;
    NSString *strTemp;
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@",infoDic[@"matchDesc"]];
    strTemp = [desc stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *arrTemp = [strTemp componentsSeparatedByString:@"VS"];
    self.homeName = arrTemp[0];
    self.guestName = arrTemp[1];
    self.leagueName = @"";
    
    self.startTime = [NSString stringWithFormat:@"%@",infoDic[@"matchDate"]];
    if ([[infoDic allKeys] containsObject:@"startTime"]) {
        self.startTime = [NSString stringWithFormat:@"%@",infoDic[@"startTime"]];
    }
    CGFloat time = [self.startTime doubleValue] / 1000;
    if (time == 0) {
        self.startTime = @"";
    }else{
        self.startTime = [Utility timeStringFromFormat:@"MM-dd HH:mm" withTI:time];
    }
    
    
    if ([[infoDic allKeys] containsObject:@"leagueName"]) {
        self.leagueName = [NSString stringWithFormat:@"%@",infoDic[@"leagueName"]];
    }
   
  
    desc = [NSMutableString stringWithFormat:@"%@",[self subStringByStr:[NSString stringWithFormat:@"%@",infoDic[@"sp"]] RemoveStrArr:@[@"[",@"]",@"\\",@"\"",]]];
    NSLog(@"%@",desc);
    
    arrTemp = [desc componentsSeparatedByString:@","];
    if (arrTemp.count == 3) {
        self.oddsSNum = arrTemp[0];
        self.oddsPNum = arrTemp[1];
        self.oddsFNum = arrTemp[2];
    }
    
    if (infoDic[@"changed"]) {
//        NSLog(@"11198 %@",infoDic[@"changed"]);
        desc = [NSMutableString stringWithFormat:@"%@",[self subStringByStr:[NSString stringWithFormat:@"%@",infoDic[@"changed"]] RemoveStrArr:@[@"[",@"]"]]];
//        NSLog(@"11098 chenge%@",desc);
        
        arrTemp = [desc componentsSeparatedByString:@","];
//        NSLog(@"11998 sp change %@",arrTemp);
        if (arrTemp.count == 3) {
            self.oddsS = arrTemp[0];
            self.oddsP = arrTemp[1];
            self.oddsF = arrTemp[2];
        }
    }
    
}

- (NSString*)subStringByStr:(NSString*)string RemoveStrArr:(NSArray *)strArr{
    for (NSString *str in strArr) {
        NSMutableString *mutableStrTemp = [[NSMutableString alloc] initWithString:string];
        string = [mutableStrTemp stringByReplacingOccurrencesOfString:str withString:@""];
    }
    return string;
}

- (NSComparisonResult)compareMatch:(CTZQMatch *)match {
   
    NSComparisonResult result;
    if ([self.id_ integerValue] >=[match.id_ integerValue]) {
        result =  NSOrderedDescending;
    }else{
        result = NSOrderedAscending;
    }
    return result;
}

@end
