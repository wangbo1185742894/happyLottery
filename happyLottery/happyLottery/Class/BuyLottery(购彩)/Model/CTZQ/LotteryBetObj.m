//
//  LotteryBetObj.m
//  Lottery
//
//  Created by Yang on 15/7/2.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "LotteryBetObj.h"
#import "LotteryManager.h"

@implementation LotteryBetObj


- (id)numberDesc{

    if ([_lotteryType isEqualToString:@"DLT"]||[_lotteryType isEqualToString:@"SSQ"]) {
        
        NSString * numDesc = [_number stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSArray * numArray = [numDesc componentsSeparatedByString:@"#"];
        
        NSMutableAttributedString *numDescString = [[NSMutableAttributedString alloc] init];
        
        NSMutableDictionary *typeQuDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        typeQuDictionary[NSForegroundColorAttributeName] = RGBCOLOR(153, 102, 51);
        [numDescString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@",_playTypeName] attributes: typeQuDictionary]];
        
        if ([_addtional intValue] == 1) {
            [numDescString appendAttributedString:[[NSAttributedString alloc] initWithString: @"(追加)" attributes: typeQuDictionary]];
        }
        
        NSMutableDictionary *qianQuDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        qianQuDictionary[NSForegroundColorAttributeName] = [UIColor redColor];
        [numDescString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"  %@",numArray[0]] attributes: qianQuDictionary]];
        NSMutableDictionary *danHaoDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        danHaoDictionary[NSForegroundColorAttributeName] = RGBCOLOR(0, 0, 255);
        [numDescString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@",numArray[1]] attributes: danHaoDictionary]];
        return numDescString;
    }else if ([_lotteryType isEqualToString:@"X115"]){
        NSString * numDesc = [_number stringByReplacingOccurrencesOfString:@"," withString:@" "];
        
        NSMutableAttributedString *numDescString = [[NSMutableAttributedString alloc] init];
        
        NSMutableDictionary *typeQuDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        typeQuDictionary[NSForegroundColorAttributeName] = RGBCOLOR(153, 102, 51);
        [numDescString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@",_playTypeName] attributes: typeQuDictionary]];
        NSMutableDictionary *numDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        numDictionary[NSForegroundColorAttributeName] = [UIColor redColor];
        [numDescString appendAttributedString:[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"  %@",numDesc] attributes: numDictionary]];
        return numDescString;
    }
    return  nil;
}



// jingcai
- (NSString *)playTypeNameWithCode:(NSString *)codeString{

    NSString * code;
    if ([codeString rangeOfString:@"_"].location != NSNotFound) {
        NSRange rang = [codeString rangeOfString:@"_"];
        code = [codeString substringToIndex:rang.location];
    }else{
        code = codeString;
    }
    NSString * typeName;
    if ([code isEqualToString:@"SPF"]) {
        typeName = @"胜平负";
    }else if ([code isEqualToString:@"RQSPF"]){
        typeName = @"让球胜平负";
    }else if ([code isEqualToString:@"HHGG"]){
        typeName = @"混合";
    }else if ([code isEqualToString:@"JQS"]){
        typeName = @"进球数";
    }else if ([code isEqualToString:@"BF"]){
        typeName = @"比分";
    }else if ([code isEqualToString:@"BQC"]){
        typeName = @"半全场";
    }
    return typeName;
}

- (NSString *)xiaBiaoChaiFen:(NSString *)value matchKey:(NSString *)matchKey{

    NSArray * array = [value componentsSeparatedByString:@"_"];
    if (array.count !=2) {
        return nil;
    }
    NSString * playType = array[0];
    int playValue = [array[1] intValue];

    NSDictionary * jingCaiCode = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiCode" ofType:@"plist"]];
//    NSDictionary * jingCaiCode = _dicForWinCodeDic;
    NSDictionary * playCodeDic = jingCaiCode[playType];
    NSArray * allKeys = [playCodeDic  allKeys];

    NSMutableArray * items = [NSMutableArray arrayWithCapacity:allKeys.count];
    int baseNum = 0;
    if([playType isEqualToString:@"SPF"]){
        baseNum = 100;
    }else if ([playType isEqualToString:@"RQSPF"]){
        baseNum = 200;
    }else if ([playType isEqualToString:@"BQC"]){
        baseNum = 400;
    }else if ([playType isEqualToString:@"JQS"]){
        baseNum = 300;
    }else if ([playType isEqualToString:@"BF"]){
        baseNum = 500;
    }
    
    for(NSString * key in allKeys){
        [items addObject:[NSString stringWithFormat:@"%d",[key intValue]-baseNum]];
    }
    NSMutableArray * keyItemArrayTemp = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString * item in items){
        
        int v = 1<<[item intValue];
        if ((v & playValue) > 0) {
            [keyItemArrayTemp addObject:item];
        }
    }
    
    NSArray *  keyItemArray = [keyItemArrayTemp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * stringFir = (NSString *)obj1;
        NSString * stringSec = (NSString *)obj2;
        if ([stringFir intValue] > [stringSec intValue] ) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    NSMutableString * typeAppear = [NSMutableString string];
    NSDictionary * oddsDic;
    NSDictionary * oddsCodeTypeDic;
    if (_odds) {
        oddsDic = [_odds valueForKey:matchKey];
        oddsCodeTypeDic = self.dicForWinCodeDic[playType];
    }
    for (int i=0;i<keyItemArray.count;i++){
        NSString * keyItem = keyItemArray[i];
        NSDictionary * infoDic = playCodeDic[[NSString stringWithFormat:@"%d",[keyItem intValue]+baseNum]];
        NSString * type =[playType isEqualToString:@"JQS"]?[NSString stringWithFormat:@"%@球",infoDic[@"appear"]]:infoDic[@"appear"];
        if([type isEqualToString:@"7球"])
        {
            type = @"7+球";
        }
        
        if ([playType isEqualToString:@"SPF"]) {
            if (type.length == 2) {
                type = [type substringFromIndex:1];
            }
        }else if ([playType isEqualToString:@"RQSPF"]){
            if (type.length == 3) {
                type = [type stringByReplacingOccurrencesOfString:@"球" withString:@""];
            }
        }
        if (type && type.length != 0) {
            [typeAppear appendString:type];
        }
        if (oddsDic) {
            NSString * code;
            for (NSString * key in [oddsCodeTypeDic allKeys]){
                NSString * value = oddsCodeTypeDic[key];
                if ([value isEqualToString:type]) {
                    code = key;
                    break;
                }
            }
            if (code) {
                 NSString * odd = [NSString stringWithFormat:@"%@",[oddsDic valueForKey:code]];
                
                NSString *strodd = [odd stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                strodd = [strodd stringByReplacingOccurrencesOfString:@" " withString:@""];
                strodd = [strodd stringByReplacingOccurrencesOfString:@"(" withString:@""];
                strodd = [strodd stringByReplacingOccurrencesOfString:@")" withString:@""];
                strodd = [strodd stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                if (![strodd isEqualToString:@""]) {
                    [typeAppear appendString:[NSString stringWithFormat:@"@%@元",strodd]];
                }
            }
        }
        if(i < keyItemArray.count-1){
            [typeAppear appendString:@" "];
        }
    }
    return typeAppear;
}

- (NSDictionary *)dicForWinCodeDic{

    if (_dicForWinCodeDic == nil) {
        _dicForWinCodeDic = @{@"SPF":@{@"3":@"胜",@"1":@"平",@"0":@"负"},
                                  @"RQSPF":@{@"3":@"让胜",@"1":@"让平",@"0":@"让负"},
                                  @"JQS":@{@"0":@"0球",@"1":@"1球",@"2":@"2球",@"3":@"3球",@"4":@"4球",@"5":@"5球",@"6":@"6球",@"7":@"7+球"},
                                  @"BQC":@{@"00":@"负负",@"01":@"负平",@"03":@"负胜",@"10":@"平负",@"11":@"平平",@"13":@"平胜",@"30":@"胜负",@"31":@"胜平",@"33":@"胜胜"},
                                  @"BF":@{@"10":@"1:0",@"20":@"2:0",@"21":@"2:1",@"30":@"3:0",@"31":@"3:1",@"32":@"3:2",@"40":@"4:0",@"41":@"4:1",@"42":@"4:2",@"50":@"5:0",@"51":@"5:1",@"52":@"5:2",@"90":@"胜其它",@"00":@"0:0",@"11":@"1:1",@"22":@"2:2",@"33":@"3:3",@"99":@"平其它",@"01":@"0:1",@"02":@"0:2",@"12":@"1:2",@"03":@"0:3",@"13":@"1:3",@"23":@"2:3",@"04":@"0:4",@"14":@"1:4",@"24":@"2:4",@"05":@"0:5",@"15":@"1:5",@"25":@"2:5",@"09":@"负其它"}
                                  };

    }
    return _dicForWinCodeDic;
}

- (NSString *)resultStringForWinInfo:(NSString *)code{
    
    NSArray * array = [code componentsSeparatedByString:@"_"];
    if (array.count !=2) {
        return nil;
    }
    NSString * playType = array[0];
    NSString * numCode = array[1];

    
    NSDictionary * typeDic = self.dicForWinCodeDic[playType];
    NSString * value = typeDic[numCode];
    return value;
}

- (NSString *)lotteryResultString:(NSString *)matchKey playType:(NSString *)playType{
    NSArray * array = [playType componentsSeparatedByString:@"_"];
    if (array.count !=2) {
        return nil;
    }
    NSString * playTypeCode = array[0];

    NSString * matchResultstr = _lotteryNumDic[matchKey];
    
    if(matchResultstr != nil)
    {
    NSData *jsonData = [matchResultstr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                   options:NSJSONReadingMutableContainers
                     error:&err];
    
    NSString * resutl  = dic[playTypeCode];
    NSArray * resultArray = [resutl componentsSeparatedByString:@"@"];
    NSDictionary * typeDic = self.dicForWinCodeDic[playTypeCode];
    
    NSString * value = typeDic[resultArray[0]];

    return value;
    }
    return nil;
}

@end
