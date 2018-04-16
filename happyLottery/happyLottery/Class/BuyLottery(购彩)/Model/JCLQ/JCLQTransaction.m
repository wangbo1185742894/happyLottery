//
//  JCLQTransaction.m
//  Lottery
//
//  Created by 王博 on 16/8/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQTransaction.h"
#import "JCLQMatchModel.h"

@interface JCLQTransaction(){
    
    NSDictionary * hunheHadBetMatchDic;
        
        
        int singleMaxBounds;
        int calculateBetCuntOrMaxBounds;  // 0: betcunt,  1: maxBounds


}

@property (nonatomic , strong) NSArray * curBaseCombines;
// 混合  注数
@property (nonatomic , strong) NSMutableArray * hunHeCombinesString;
@property (nonatomic , strong) NSArray * numArrayContent;

@property (nonatomic , strong) NSMutableArray * odd_HunHeCombinesString;
@property (nonatomic , strong) NSArray * odd_NumArrayContent;

// 混合  最大奖金
@property (nonatomic , strong) NSMutableArray * hunHeBoundCombinesString;
@property (nonatomic , strong) NSArray * hunHeBoundNumArrayContent;


@end

@implementation JCLQTransaction

-(id)init{

    if (self = [super init]) {
        self.matchSelectArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

-(NSInteger)sumSelectPlayType:(NSArray*)array{
    NSInteger num = 0;
    for (NSString *str  in array) {
        num = num+ [str integerValue];
    }
    return num;
}

- (void)getBetCount{
    float danBeiJiangJin = 0.0;
    int betCuntTemp = 0;
    if ([self.chuanFa isEqualToString:@"单场"]) {
        for ( JCLQMatchModel* model in  self.matchSelectArray){
            
            betCuntTemp += [self sumSelectPlayType:model.SFSelectMatch];
            betCuntTemp += [self sumSelectPlayType:model.DXFSelectMatch];
            betCuntTemp += [self sumSelectPlayType:model.SFCSelectMatch];
            betCuntTemp += [self sumSelectPlayType:model.RFSFSelectMatch];
            
            danBeiJiangJin += [[self getMaxOdd:model.SFCOddArray andMatchArray:model.SFCSelectMatch] floatValue];
            danBeiJiangJin += [[self getMaxOdd:model.SFOddArray andMatchArray:model.SFSelectMatch] floatValue];
            danBeiJiangJin += [[self getMaxOdd:model.DXFSOddArray andMatchArray:model.DXFSelectMatch] floatValue];
            danBeiJiangJin += [[self getMaxOdd:model.RFSFOddArray andMatchArray:model.RFSFSelectMatch] floatValue];
        }
    }else{
        NSArray * chuanFaCodeDic = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
        NSString * index = [_chuanFa substringToIndex:1];
        NSDictionary * sectionCodeDic = chuanFaCodeDic[[index intValue]-1];
        NSDictionary * codeDic = sectionCodeDic[_chuanFa];
        NSString * baseNum = codeDic[@"baseNum"];
        
        NSArray * baseNumArray = [baseNum componentsSeparatedByString:@","];
        NSMutableArray * numArray = [NSMutableArray arrayWithCapacity:0];
        
//        if ([self.playType isEqualToString:@"JCLQHHGG"]) {
            NSMutableDictionary * matchGropDic = [NSMutableDictionary dictionary];
            NSMutableArray * matchIndexArray = [NSMutableArray array];
            for (int i=0;i<self.matchSelectArray.count;i++){
                NSString * indexString = [NSString stringWithFormat:@"%d",i];
                JCLQMatchModel *bet = self.matchSelectArray[i];
                matchGropDic[indexString] = bet;
                [matchIndexArray addObject:indexString];
            }
            NSArray * allGroup = [self getCombination:matchIndexArray count:[index intValue]];
            
            for (NSArray * indexArray in allGroup) {
                NSMutableArray * matchArray = [NSMutableArray arrayWithCapacity:indexArray.count];
                for (NSString * indexString in indexArray) {
                    [matchArray addObject:matchGropDic[indexString]];
                }
                self.hunHeCombinesString = [NSMutableArray array];
                self.numArrayContent = [NSMutableArray array];
                self.odd_NumArrayContent = [NSMutableArray array];
                self.odd_HunHeCombinesString = [NSMutableArray array];
                
                [self separateHunheMatchBetNum:matchArray];
                [self arrayRrgodicIndex:0 mutableString:nil];
                [self arrayOddRrgodicIndex:0 mutableString:nil];
                for (int i =0; i<_hunHeCombinesString.count; i++) {
                    NSString * numString = _hunHeCombinesString[i];
                    NSArray * numArray = [numString componentsSeparatedByString:@","];
                    betCuntTemp += (int)[self calculateBetCount:numArray baseNumArray:baseNumArray];
                }
                float odd2 = 0.0;
                for (int i =0; i<_odd_HunHeCombinesString.count; i++) {
                    NSString * numString = _odd_HunHeCombinesString[i];
                    NSArray * numArray = [numString componentsSeparatedByString:@","];
                    NSMutableArray *selectOddFenzhu = [NSMutableArray array];
                    for (NSString *num in baseNumArray) {
                         numArray = [numString componentsSeparatedByString:@","];
                        selectOddFenzhu = [self getCombination:numArray count:[num intValue]];
                        
                        for (NSArray *arr in selectOddFenzhu) {
                            
                            float odd1 = 1.0;
                            for (NSString* item in arr) {
                                odd1 = odd1 * [item floatValue];
                            }
                            
                            if (arr.count == 1) {
                                if (odd1 >50000) {
                                    odd1 = 50000;
                                }
                            }
                            if (arr.count== 2||arr.count== 3) {
                                
                                if (odd1 >100000) {
                                    odd1 = 100000;
                                }
                                
                            }else if (arr.count == 4 || arr.count == 5){
                                if (odd1 > 250000) {
                                    odd1 = 250000;
                                }
                            }if (arr.count >= 6) {
                                if (odd1 >500000) {
                                    odd1 = 500000;
                                }
                            }

                            odd2 = odd2 + odd1;
                        }
                    }
                    
                   
                }
                
                
                
                danBeiJiangJin = danBeiJiangJin + odd2;
                
            }
//        }
        
//        else{
//            for (JCLQMatchModel * bet in  self.matchSelectArray){
//                
//                
//                NSInteger num = [self sumSelectPlayType:bet.SFSelectMatch];
//                num = num +[self sumSelectPlayType:bet.RFSFSelectMatch];
//                num = num +[self sumSelectPlayType:bet.DXFSelectMatch];
//                num = num +[self sumSelectPlayType:bet.SFCSelectMatch];
//                [numArray addObject:@(num)];
//                
//                [self arrayOddRrgodicIndex:0 mutableString:nil];
//                float odd2 = 0.0;
//                for (int i =0; i<_odd_HunHeCombinesString.count; i++) {
//                    NSString * numString = _odd_HunHeCombinesString[i];
//                    NSArray * numArray = [numString componentsSeparatedByString:@","];
//                    NSMutableArray *selectOddFenzhu = [NSMutableArray array];
//                    for (NSString *num in baseNumArray) {
//                        selectOddFenzhu = [self getCombination:numArray count:[num integerValue]];
//                        for (NSArray *arr in selectOddFenzhu) {
//                            
//                            float odd1 = 1.0;
//                            for (NSString* item in arr) {
//                                odd1 = odd1 * [item floatValue];
//                            }
//                            odd2 = odd2 + odd1;
//                        }
//                    }
//                }
//                
//
//            }
//            betCuntTemp += (int)[self calculateBetCount:numArray baseNumArray:baseNumArray];
//        }
    }
    self.betCount = betCuntTemp;
    _maxCount = danBeiJiangJin *2;
    self.betCost = self.betCount * [_beitou intValue] * 2;
}


- (NSArray *) getCombination: (NSMutableArray *) numbs count: (int) combCount {
    if ([numbs count] == combCount) {
        return [NSArray arrayWithObject: numbs];
    } else if (combCount == 1) {
        NSMutableArray *allCombs = [NSMutableArray array];
        for (NSString *str in numbs) {
            [allCombs addObject: [NSArray arrayWithObject: str]];
        }
        return allCombs;
    } else {
        NSMutableArray *allCombs = [NSMutableArray array];
        NSUInteger numbsCount = [numbs count];
        for (int i=0; i<numbsCount; i++) {
            if ((numbsCount - i) == (combCount - 1)) {
                break;
            }
            NSString *curNum = numbs[0];
            [numbs removeObjectAtIndex: 0];
            NSArray *subCombs = [self getCombination: [numbs mutableCopy] count: (combCount - 1)];
            [allCombs addObjectsFromArray: [self mergeComb: curNum fromComb: subCombs]];
        }
        return allCombs;
    }
    return nil;
}

- (NSArray *) mergeComb: (NSString *) num fromComb: (NSArray *) subCombs {
    NSMutableArray *finalCombs = [NSMutableArray arrayWithCapacity: [subCombs count]];
    for (NSArray *cellComb in subCombs) {
        NSMutableArray *cellCombU = [NSMutableArray arrayWithObject: num];
        [cellCombU addObjectsFromArray: cellComb];
        
        [finalCombs addObject: cellCombU];
    }
    return finalCombs;
}


- (double) calculateBetCount:(NSArray *)numArray baseNumArray:(NSArray *)baseNumArray{
    double betCuntTemp = 0;
    self.curBaseCombines = nil;
    int chuanMost = [[_chuanFa substringToIndex:1] intValue];
    
    NSMutableArray * numArrayToCaculatin = [NSMutableArray arrayWithArray:numArray];
    self.curBaseCombines  = [self getCombination: numArrayToCaculatin count:chuanMost];
    
    for (int i =0; i<baseNumArray.count; i++) {
        NSString * baseNum = baseNumArray[i];
        if (i == 0 && [baseNum intValue] == chuanMost) {
            for (NSArray * subArray in _curBaseCombines) {
                if (subArray.count != 0) {
                    double temp =1;
                    for ( int i=0; i<subArray.count; i++) {
                        temp *= [subArray[i] floatValue];
                    }
                    if (calculateBetCuntOrMaxBounds == 1) {
                        // 计算最大奖金
                        NSInteger matchNum = subArray.count;
                        if (1 < matchNum && matchNum <4) {
                            singleMaxBounds = 200000;
                        }else if (3 < matchNum && matchNum <6){
                            singleMaxBounds = 500000;
                        }else{
                            singleMaxBounds = 1000000;
                        }
                        temp *= 2;
                        if(temp > singleMaxBounds){
                            temp =singleMaxBounds;
                        }
                    }
                    betCuntTemp += temp;
                }
            }
        }else{
            for (int j=0; j<_curBaseCombines.count; j++) {
                NSMutableArray * numArrayToCaculatin = [NSMutableArray arrayWithArray:_curBaseCombines[j]];
                betCuntTemp += [self getCuntWithNumArray:numArrayToCaculatin withBaseNum:[baseNumArray[i] intValue]];
            }
        }
    }
    return betCuntTemp;
}

- (double)getCuntWithNumArray:(NSMutableArray *)numArray withBaseNum:(int)baseNum{
    double tempCunt =0;
    NSArray *combines_  = [self getCombination: numArray count: baseNum];
    
    for (NSArray * subArray in combines_) {
        if (subArray.count != 0) {
            double temp =1;
            for ( int i=0; i<subArray.count; i++) {
                temp *= [subArray[i] floatValue];
            }
            if (calculateBetCuntOrMaxBounds == 1) {
                // 计算最大奖金
                NSInteger matchNum = subArray.count;
                if (1 < matchNum && matchNum <4) {
                    singleMaxBounds = 200000;
                }else if (3 < matchNum && matchNum <6){
                    singleMaxBounds = 500000;
                }else{
                    singleMaxBounds = 1000000;
                }
                temp *= 2;
                if(temp > singleMaxBounds){
                    temp =singleMaxBounds;
                }
            }
            tempCunt += temp;
        }
    }
    return tempCunt;
}



- (void) separateHunheMatchBetNum:(NSArray *)marchArray{
    NSMutableArray * arrayContentTemp = [NSMutableArray array];
    NSMutableArray *arrayOdd = [NSMutableArray array];
    for (JCLQMatchModel * match in marchArray){
         NSMutableArray *arrayOddSelect = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * numCuntArray = [NSMutableArray array];
        NSMutableArray *selectArray = [NSMutableArray arrayWithCapacity:12];
        double max = 0;
        
        NSInteger index = 0;
        for (int i = 0; i<12 ; i++) {
         
            NSMutableArray *itemSelect = [NSMutableArray arrayWithCapacity:0];
            
            //0 sf  1 小  2  大 3 sfc
            if (i<6) {
                
                [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.SFSelectMatch[0] doubleValue]*[match.SFOddArray[0] doubleValue]]];
              
                
            }else{
                     [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.SFSelectMatch[1] doubleValue]*[match.SFOddArray[1] doubleValue]]];
                
            }
            
            double valueDX =[match.DXFSelectMatch[0] doubleValue] *[match.DXFSOddArray[0] doubleValue]>[match.DXFSelectMatch[1] doubleValue] *[match.DXFSOddArray[1] doubleValue]?[match.DXFSelectMatch[0] doubleValue] *[match.DXFSOddArray[0] doubleValue]:[match.DXFSelectMatch[1] doubleValue] *[match.DXFSOddArray[1] doubleValue];
            
            [itemSelect addObject:[NSString stringWithFormat:@"%.2f",valueDX]];
            
            [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.SFCSelectMatch[i] doubleValue] *[match.SFCOddArray[i] doubleValue]]];
            
            
            if (i<6) {   // 客胜
                
                if ([match.handicap doubleValue] >26) {
                    if (i == 5) {
                    [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[0] doubleValue] *[match.RFSFOddArray[0] doubleValue]]];
                    }
                }else if([match.handicap doubleValue] - (i*5+1)<0){
                    if (![match.RFSFSelectMatch[0] isEqualToString:@"0"]) {
                    [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[0] doubleValue] *[match.RFSFOddArray[0] doubleValue]]];
                        
                    }
                }
                
            }else{
                if ([match.handicap doubleValue] <-26) {
                    if (i == 11) {
                        [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[1] doubleValue] *[match.RFSFOddArray[1] doubleValue]]];
                    }
                }else if([match.handicap doubleValue] + ((i-6)*5+1)>0){
                    if (![match.RFSFSelectMatch[1] isEqualToString:@"0"]) {
                         [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[1] doubleValue] *[match.RFSFOddArray[1] doubleValue]]];
                    }
                   
                }
                
            }

            double lastMax = 0;
            for (NSString *odd in itemSelect) {
                lastMax += [odd doubleValue];
            }
            
            if (max<lastMax) {
                max = lastMax;
                index = i;
            }
            [selectArray addObject:itemSelect];
        }
        
        NSMutableArray *maxOddArray = selectArray[index];
        
        for (NSString *item in maxOddArray) {
            if (![item isEqualToString:@"0.00"]) {
                [arrayOddSelect addObject:item];
            }
        }

        if (match.SFSelectMatch && [self sumSelectPlayType:match.SFSelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.SFSelectMatch]]];
//            NSString *max = [self getMaxOdd:match.SFOddArray andMatchArray:match.SFSelectMatch];
//            if (max!=nil ) {
////                if (flagSfAndSfc == 1) {
////                     [arrayOddSelect addObject:@"1"];
////                }else{
//                
//                     [arrayOddSelect addObject:max];
////                }
//               
//            }
            
        }
        if (match.RFSFSelectMatch && [self sumSelectPlayType:match.RFSFSelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.RFSFSelectMatch]]];
//            NSString *max = [self getMaxOdd:match.RFSFOddArray andMatchArray:match.RFSFSelectMatch];
//            if (max!=nil) {
//                [arrayOddSelect addObject:max];
//            }
        }
        if (match.DXFSelectMatch && [self sumSelectPlayType:match.DXFSelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.DXFSelectMatch]]];
         
            NSString *max = [self getMaxOdd:match.DXFSOddArray andMatchArray:match.DXFSelectMatch];
//            if (max!=nil) {
//                [arrayOddSelect addObject:max];
//            }
            
        }
        if (match.SFCSelectMatch && [self sumSelectPlayType:match.SFCSelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.SFCSelectMatch]]];
//            NSString *max = [self getMaxOdd:match.SFCOddArray andMatchArray:match.SFCSelectMatch];
//            if (max!=nil) {
////                if (flagSfAndSfc == 2) {
////                    [arrayOddSelect addObject:@"1"];
////                }else{
//                
//                    [arrayOddSelect addObject:max];
////                }
//                
//            }
            
        }
        [arrayOdd addObject:arrayOddSelect];
        [arrayContentTemp addObject:numCuntArray];
    }
    self.numArrayContent = arrayContentTemp;
    self.odd_NumArrayContent = arrayOdd;
}

-(NSString*)getMaxOdd:(NSArray*)odd_array andMatchArray:(NSArray*)matchArray{

    NSString *max;
    for (int i = 0; i<odd_array.count; i++) {
        NSString *odd  = odd_array[i];
        NSString *state = matchArray[i];
        if ([odd floatValue]>[max floatValue]&&[state isEqualToString:@"1"]) {
            max = odd;
        }
    }
    return max;

}

-(NSInteger)getMaxOddIndex:(NSArray*)odd_array andMatchArray:(NSArray*)matchArray{
    
    NSString *max;
    NSInteger index = 0;
    for (int i = 0; i<odd_array.count; i++) {
        NSString *odd  = odd_array[i];
        NSString *state = matchArray[i];
        if ([odd floatValue]>[max floatValue]&&[state isEqualToString:@"1"]) {
            index = i;
        }
    }
    return index;
}



- (void)arrayOddRrgodicIndex:(int)index mutableString:(NSMutableString *)string{
if (index == _odd_NumArrayContent.count-1) {
    NSArray * numArray = _odd_NumArrayContent[index];
    for (int i =0; i<numArray.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%.2f",[numArray[i] floatValue]];
        NSMutableString * newString = [NSMutableString string];
                    [newString appendString:string];
        [newString appendString:str];
        [_odd_HunHeCombinesString addObject:newString];
    }
}else{
    NSArray * numArray = _odd_NumArrayContent[index];
    index += 1;
    for (int i =0; i<numArray.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%.2f",[numArray[i] floatValue]];
        if (string == nil) {
            string = [NSMutableString string];
        }
        NSMutableString * newString = [NSMutableString string];
                    [newString appendString:string];
        [newString appendString:str];
        [newString appendString:@","];
        [self arrayOddRrgodicIndex:index mutableString:newString];
    }
}
}

- (void)arrayRrgodicIndex:(int)index mutableString:(NSMutableString *)string{
    
  
    
    if (index == _numArrayContent.count-1) {
        NSArray * numArray = _numArrayContent[index];
        for (int i =0; i<numArray.count; i++) {
            NSString * str = [NSString stringWithFormat:@"%.2f",[numArray[i] floatValue]];
            NSMutableString * newString = [NSMutableString string];
            [newString appendString:string];
            [newString appendString:str];
            [_hunHeCombinesString addObject:newString];
        }
    }else{
        NSArray * numArray = _numArrayContent[index];
        index += 1;
        for (int i =0; i<numArray.count; i++) {
            NSString * str = [NSString stringWithFormat:@"%.2f",[numArray[i] floatValue]];
            if (string == nil) {
                string = [NSMutableString string];
            }
            NSMutableString * newString = [NSMutableString string];
            [newString appendString:string];
            [newString appendString:str];
            [newString appendString:@","];
            [self arrayRrgodicIndex:index mutableString:newString];
        }
    }
}

-(JCLQGuanType)getTZGuanType{
    if([_chuanFa isEqualToString:@"单场"])//比分支持单关，于是实际上将玩法改成了单关。
    {
        _guanType = JCLQGuanTypeDanGuan;
    }
    else
    {
        _guanType = JCLQGuanTypeGuoGuan;
    }
    return _guanType;
}

- (NSMutableDictionary *)submitParamDic{
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    
    self.betCost = self.betCount * [_beitou integerValue] * 2;
    
    paramDic[@"betSource"] = @"2";
    paramDic[@"cardCode"] = [GlobalInstance instance] .curUser.cardCode;
    paramDic[@"cost"] = [NSString stringWithFormat:@"%zd",self.betCost];
    paramDic[@"issueNumber"] = self.lottery.currentRound.issueNumber;
    
    
    paramDic[@"lottery"] = @"JCLQ";
    paramDic[@"multiple"] = [NSString stringWithFormat:@"%d",[self.beitou intValue]];
    NSString *playTypeStr = self.playType;
    if ([playTypeStr isEqualToString:@"JCLQHHGG"]) {
        playTypeStr = @"0";
    }else if ([playTypeStr isEqualToString:@"JCLQSF"]){
        playTypeStr = @"1";
    }
    else if ([playTypeStr isEqualToString:@"JCLQRFSF"]){
        playTypeStr = @"2";
    }
    else if ([playTypeStr isEqualToString:@"JCLQSFC"]){
        playTypeStr = @"3";
    }else if ([playTypeStr isEqualToString:@"JCLQDXF"]){
        playTypeStr = @"4";
    }
    paramDic[@"playType"] = playTypeStr;
    paramDic[@"schemeType"] = @"BUY_SELF";
    paramDic[@"units"] = [NSString stringWithFormat:@"%zd",self.betCount];
    paramDic[@"winningStatus"] = @"WAIT_LOTTERY";

    
//    paramDic[@"addtional"] = @"0";
//    
//    paramDic[@"bonus"] = @"0";
//    paramDic[@"catchOnOrderNum"] = @"1";
//    
//    paramDic[@"lotteryNumbers"] = @"";
//    //  paramDic[@"lotteryType"] = @"JCZQ";
//        paramDic[@"multiple"] = self.beitou;
//    paramDic[@"orderNumber"] = @"";
//    paramDic[@"orderStatus"] = @"WAIT_PAY";
//    paramDic[@"orderTime"] = [Utility timeStringFromFormat: @"yyyy-MM-dd HH:mm:ss" withDate: [NSDate date]];
//    paramDic[@"orderbonus"] = [NSString stringWithFormat:@"%zd",_betCost];
//    paramDic[@"ordercount"] = [NSString stringWithFormat:@"%zd",_betCount];
//    
//    
//    paramDic[@"saleChannelNo"] = @"";
//    paramDic[@"saleChannelType"] = @"";
    
    return paramDic;
}

- (id )lottData{
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];
    
//    paraDic[@"lotteryType"] = @"JCLQ";
    
    NSString * chuanFaString;
    
    if ([self.chuanFa isEqualToString:@"单场"]) {
        chuanFaString = @"P1";
    }else{
        chuanFaString = [NSString stringWithFormat:@"P%@",[self.chuanFa stringByReplacingOccurrencesOfString:@"串" withString:@"_"]];
    }
    paraDic[@"passType"] = chuanFaString;
    
    paraDic[@"passMode"] = [self.chuanFa isEqualToString:@"单场"]?@"SINGLE":@"PASS";
    
    paraDic[@"ticketItems"] = [self betContentArray];
    
    return paraDic;
}

- (NSArray *)betContentArray{
    NSMutableArray *betCountArr = [NSMutableArray arrayWithCapacity:_matchSelectArray.count];
    
    for (JCLQMatchModel *match in _matchSelectArray) {
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"dan"] = @"false";
        paraDic[@"matchKey"] = [NSString stringWithFormat:@"%@",match.matchKey];
        paraDic[@"matchID"] = [NSString stringWithFormat:@"%@",match.lineId];
        paraDic[@"value"] = [self betXiaBiao:match];
        [betCountArr addObject:paraDic];
    }
    
    return betCountArr;
}
- (NSString *)betXiaBiao:(JCLQMatchModel *)match{
    
    NSString *xiabiao = @"error";
    
    NSInteger sfSelected = [self selectedKEYWithArr:match.SFSelectMatch];
    NSInteger sfcSelected = [self selectedKEYWithArr:match.SFCSelectMatch];
    NSInteger dxfSelected = [self selectedKEYWithArr:match.DXFSelectMatch];
    NSInteger rfsfSelected = [self selectedKEYWithArr:match.RFSFSelectMatch];
    
    NSMutableString *selectedXiabiao = [NSMutableString string];
    if (sfSelected ) {
        [selectedXiabiao appendString:[NSString stringWithFormat:@"SF_%zd,",sfSelected]];
    }
    if (sfcSelected ) {
        [selectedXiabiao appendString:[NSString stringWithFormat:@"SFC_%zd,",sfcSelected]];
    }
    if (dxfSelected ) {
        [selectedXiabiao appendString:[NSString stringWithFormat:@"DXF_%zd,",dxfSelected]];
    }
    if (rfsfSelected ) {
        [selectedXiabiao appendString:[NSString stringWithFormat:@"RFSF_%zd,",rfsfSelected]];
    }
    if (selectedXiabiao.length > 1) {
        xiabiao = [selectedXiabiao substringToIndex:selectedXiabiao.length - 1];
    }
    return xiabiao;
}

- (NSInteger)selectedKEYWithArr:(NSArray *)arr{
    NSInteger temp = 0;
    NSUInteger index = 0;
    for (NSString *isSelected in arr) {
        if (![isSelected isEqualToString:@"0"]) {
            temp += pow(2, index);
        }
        index ++;
    }
    return temp;
}

-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] =[GlobalInstance instance] .curUser.cardCode;
    submitParaDic[@"lottery"] = @(10);
    submitParaDic[@"maxPrize"]  = @(self.maxPrize);
    submitParaDic[@"channelCode"] = CHANNEL_CODE;
    submitParaDic[@"schemeType"] =@(self.schemeType);
    submitParaDic[@"issueNumber"] = @"2018";
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%ld",(long)self.betCount];
    submitParaDic[@"multiple"] =self.beitou;
    NSString *betcost;
    if (self.costType == CostTypeCASH) {
        betcost  =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    }else if (self.costType == CostTypeSCORE){
        betcost =[NSString stringWithFormat:@"%ld",(long)self.betCost * 100];
    }
    submitParaDic[@"betCost"] = betcost;
    submitParaDic[@"betSource"] = @"2";
    submitParaDic[@"schemeSource"] = @(self.schemeSource);
    submitParaDic[@"secretType"] =@(self.secretType);
    submitParaDic[@"costType"] = @(self.costType);
    if (self.schemeType == SchemeTypeZigou) {
        submitParaDic[@"copies"] = @"1";
        submitParaDic[@"sponsorCopies"] = @"1";
        submitParaDic[@"minSubCost"] =betcost;
        submitParaDic[@"sponsorCost"] = betcost;
    }else if(self.schemeType == SchemeTypeHemai){
        submitParaDic[@"commissionRate"] = [NSString stringWithFormat:@"%.2f",self.commissionRate];
        submitParaDic[@"copies"] = [NSString stringWithFormat:@"%zd",self.copies];
        submitParaDic[@"sponsorCopies"] = [NSString stringWithFormat:@"%zd",self.sponsorCopies];
        submitParaDic[@"minSubCost"] =[NSString stringWithFormat:@"%.2f",self.minSubCost];
        submitParaDic[@"sponsorCost"] = [NSString stringWithFormat:@"%.2f",self.sponsorCost];
        submitParaDic[@"baodiCopies"] =[NSString stringWithFormat:@"%ld",(long)self.baodiCopies];
        submitParaDic[@"baodiCost"] = [NSString stringWithFormat:@"%.2f",self.baodiCopies *self.minSubCost];
    }

    return submitParaDic;
}

- (id)lottDataScheme{
    
    NSMutableArray *passTypes = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *type in self.selectItems) {
        NSString * chuanFaString;
        if ([type isEqualToString:@"单场"]) {
            chuanFaString = @"P1";
        }else{
            NSInteger changNum = [[[type componentsSeparatedByString:@"串"] firstObject] integerValue];
            NSInteger zhuNum = [[[type componentsSeparatedByString:@"串"] lastObject] integerValue];
            chuanFaString = [NSString stringWithFormat:@"P%ld_%ld",(long)changNum,(long)zhuNum];
        }
        [passTypes addObject:chuanFaString];
    }
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    NSArray *contentArray;
    
    
    NSMutableArray *betMatches = [NSMutableArray arrayWithCapacity:0];
    for (JCLQMatchModel *bet in self.matchSelectArray) {
        
        NSMutableArray *betPlayTypes = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *option1 = [[NSMutableArray alloc]init];
        NSMutableArray *option2 = [[NSMutableArray alloc]init];
        NSMutableArray *option3 = [[NSMutableArray alloc]init];
        NSMutableArray *option4 = [[NSMutableArray alloc]init];
        
        
        
        
        for (int i  = 0; i<bet.SFSelectMatch.count; i++) {
            NSString *flag = bet.SFSelectMatch[i];
            contentArray = dic[@"SF"];
            NSDictionary *dic = contentArray[i];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option1 addObject:option];
            }
        }
        for (int i  = 0; i<bet.RFSFSelectMatch.count; i++) {
            NSString *flag = bet.RFSFSelectMatch[i];
            contentArray = dic[@"RFSF"];
            NSDictionary *dic = contentArray[i];
            NSString *option = [self getOption:dic];
            if ([flag isEqualToString:@"1"]) {
                [option2 addObject:option];
            }
        }
        for (int i  = 0; i<bet.DXFSelectMatch.count; i++) {
            NSString *flag = bet.DXFSelectMatch[i];
            contentArray = dic[@"DXF"];
            NSDictionary *dic = contentArray[i];
            NSString *option = [self getOption:dic];
            if ([flag isEqualToString:@"1"]) {
                [option3 addObject:option];
            }
        }
        for (int i  = 0; i<bet.SFCSelectMatch.count; i++) {
            NSString *flag = bet.SFCSelectMatch[i];
            contentArray = dic[@"SFC"];
            NSDictionary *dic = contentArray[i];
            NSString *option = [self getOption:dic];
            if ([flag isEqualToString:@"1"]) {
                [option4 addObject:option];
            }
        }
        
        if (option1.count > 0) {
            NSDictionary * dic = @{@"options":option1,@"playType":@"1"};
            [betPlayTypes addObject:dic];
        }
        if (option2.count > 0) {
            NSDictionary * dic = @{@"options":option2,@"playType":@"2"};
            [betPlayTypes addObject:dic];
        }
        if (option3.count > 0) {
            NSDictionary * dic = @{@"options":option3,@"playType":@"4"};
            [betPlayTypes addObject:dic];
        }
        if (option4.count > 0) {
            NSDictionary * dic = @{@"options":option4,@"playType":@"3"};
            [betPlayTypes addObject:dic];
        }
        
        
        NSDictionary *dicMatches = @{@"dan":@NO,
                                     @"matchId": bet.lineId,
                                     @"clash":[NSString stringWithFormat:@"%@VS%@",bet.guestName,bet.homeName],
                                     @"matchKey":bet.matchKey,
                                     @"betPlayTypes":betPlayTypes
                                     };
        [betMatches addObject:dicMatches];
    }
    
    NSArray *betContent  = @[@{
                                  @"betMatches":betMatches,
                                  @"passTypes":passTypes,
                                  @"multiple":self.beitou
                                  }];
    
    
    return betContent;
    
}

-(NSString*)getOption:(NSDictionary*)dic{
    
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
        
        NSString *code = [NSString stringWithFormat:@"%d", [dic[@"code"] integerValue]%100 ];
        
        return code;
//        for (NSString *str  in dic.allKeys) {
//            if (![str isEqualToString:@"appear"]&&![str isEqualToString:@"code"]) {
//                return  str;
//            }
//        }
    }
    
    return  nil;
}

@end
