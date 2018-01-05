
//
//  JCZQTranscation.m
//  happyLottery
//
//  Created by 王博 on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQTranscation.h"

@interface JCZQTranscation()
{
    
    int singleMaxBounds;
    int calculateBetCuntOrMaxBounds;
    JCZQPlayType guanKaType;
}
@property (nonatomic , strong) NSArray * curBaseCombines;
// 混合  注数
@property (nonatomic , strong) NSMutableArray * hunHeCombinesString;
@property (nonatomic , strong) NSArray * numArrayContent;

// 混合  最大奖金
@property (nonatomic , strong) NSMutableArray * hunHeBoundCombinesString;
@property (nonatomic , strong) NSArray * hunHeBoundNumArrayContent;
@property(nonatomic,strong)NSString *guoguantype;
@end

@implementation JCZQTranscation


-(id)init{
    if ([super init]) {
        self.selectMatchArray = [NSMutableArray arrayWithCapacity:0];
        self.selectItems = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (NSInteger)hhggHasBetMatchNumWithPlayCode:(NSString *)playCd{
    NSInteger cunt = 0;
    for (JCZQMatchModel  * model in  self.selectMatchArray ) {
        
        
        
        if ([playCd isEqualToString:@"SPF"]) {
            cunt += [self sumSelectNum:model.SPF_SelectMatch];
        }else if ([playCd isEqualToString:@"RQSPF"]){
            cunt += [self sumSelectNum:model.RQSPF_SelectMatch];
        }else if ([playCd isEqualToString:@"BF"]){
            cunt += [self sumSelectNum:model.BF_SelectMatch];
        }else if ([playCd isEqualToString:@"BQC"]){
            cunt += [self sumSelectNum:model.BQC_SelectMatch];
        }else if ([playCd isEqualToString:@"JQS"]){
            cunt += [self sumSelectNum:model.JQS_SelectMatch];
        }else{
            return cunt;
        }
    }

    return cunt;
}

-(NSInteger)sumSelectNum:(NSArray *)selectArray{
    for (NSString * item in selectArray) {
        if ([item integerValue] == 1) {
            return 1;
        }
    }
    return 0 ;
    
}

-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] = [[GlobalInstance instance] curUser].cardCode ;
    submitParaDic[@"maxPrize"]  = @(self.maxPrize);
    submitParaDic[@"channelCode"] = @"TBZ";
    submitParaDic[@"lottery"] = @(9);
    submitParaDic[@"schemeType"] = @(self.schemeType);
    submitParaDic[@"issueNumber"] = @"2018";
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%ld",(long)self.units];
    submitParaDic[@"multiple"] =self.beitou;
    submitParaDic[@"betCost"] =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"betSource"] = @"2";
    submitParaDic[@"schemeSource"] = @(0);
    submitParaDic[@"secretType"] =@(self.secretType);
    submitParaDic[@"costType"] = @(self.costType);
    if (self.schemeType == SchemeTypeZigou) {
        submitParaDic[@"copies"] = @"1";
        submitParaDic[@"sponsorCopies"] = @"1";
        submitParaDic[@"minSubCost"] =[NSString stringWithFormat:@"%ld",(long)self.betCost];
        submitParaDic[@"sponsorCost"] = [NSString stringWithFormat:@"%ld",(long)self.betCost];
    }else if(self.schemeType == SchemeTypeHemai){
        submitParaDic[@"copies"] = [NSString stringWithFormat:@"%zd",self.copies];
        submitParaDic[@"sponsorCopies"] = [NSString stringWithFormat:@"%zd",self.sponsorCopies];
        submitParaDic[@"commissionRate"] = [NSString stringWithFormat:@"%.2f",self.commissionRate];
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
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSMutableArray *betMatches = [NSMutableArray arrayWithCapacity:0];
    for (JCZQMatchModel *bet in self.selectMatchArray) {
        
        NSMutableArray *betPlayTypes = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *option1 = [[NSMutableArray alloc]init];
        NSMutableArray *option2 = [[NSMutableArray alloc]init];
        NSMutableArray *option3 = [[NSMutableArray alloc]init];
        NSMutableArray *option4 = [[NSMutableArray alloc]init];
        NSMutableArray *option5 = [[NSMutableArray alloc]init];
        
        
        
        for (int i  = 0; i<bet.SPF_SelectMatch.count; i++) {
            NSString *flag = bet.SPF_SelectMatch[i];
            contentArray = dic[@"SPF"];
        
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",100+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option1 addObject:option];
            }
        }
        for (int i  = 0; i<bet.RQSPF_SelectMatch.count; i++) {
            NSString *flag = bet.RQSPF_SelectMatch[i];
            contentArray = dic[@"RQSPF"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",200+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option1 addObject:option];
            }
        }
        for (int i  = 0; i<bet.BF_SelectMatch.count; i++) {
            NSString *flag = bet.BF_SelectMatch[i];
            contentArray = dic[@"BF"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",300+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option1 addObject:option];
            }
        }
        for (int i  = 0; i<bet.BQC_SelectMatch.count; i++) {
            NSString *flag = bet.BQC_SelectMatch[i];
            contentArray = dic[@"BQC"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",400+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option1 addObject:option];
            }
        }
        
        for (int i  = 0; i<bet.JQS_SelectMatch.count; i++) {
            NSString *flag = bet.JQS_SelectMatch[i];
            contentArray = dic[@"JQS"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",500+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option1 addObject:option];
            }
        }
       
        
        
        
        if (option1.count > 0) {
            NSDictionary * dic = @{@"options":option1,@"playType":@"1"};
            [betPlayTypes addObject:dic];
        }
        if (option2.count > 0) {
            NSDictionary * dic = @{@"options":option2,@"playType":@"5"};
            [betPlayTypes addObject:dic];
        }
        if (option3.count > 0) {
            NSDictionary * dic = @{@"options":option3,@"playType":@"3"};
            [betPlayTypes addObject:dic];
        }
        if (option4.count > 0) {
            NSDictionary * dic = @{@"options":option4,@"playType":@"4"};
            [betPlayTypes addObject:dic];
        }
        if (option5.count > 0) {
            NSDictionary * dic = @{@"options":option5,@"playType":@"2"};
            [betPlayTypes addObject:dic];
        }
        
        
        NSDictionary *dicMatches = @{@"dan":@NO,
                                     @"matchId": bet.lineId,
                                     @"clash":[NSString stringWithFormat:@"%@VS%@",bet.homeName,bet.guestName],
                                     @"matchKey":bet.matchKey,
                                     @"betPlayTypes":betPlayTypes
                                     };
        [betMatches addObject:dicMatches];
    }
    
    NSDictionary *betContent  = @{
                                  @"betMatches":betMatches,
                                  @"passTypes":passTypes
                                  };
    
    
    return betContent;
    
}


-(NSString*)getOption:(NSDictionary*)dic{
    
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
        if (dic[@"code"] != nil) {
            return dic[@"code"];
        }
        //        for (NSString *str  in dic.allKeys) {
        //            if (![str isEqualToString:@"appear"]&&![str isEqualToString:@"code"]) {
        //                return  str;
        //            }
        //        }
    }
    
    return  nil;
}
-(NSDictionary *)getOptionDic:(NSDictionary *)contentDic andKey:(NSString *)key{
    
    for (NSString *thisKey in contentDic.allKeys) {
        if ([thisKey isEqualToString:key]) {
            return contentDic[key];
        }
    }
    return nil;
}


-(NSArray*)schemeTypes{
    
    return  @[@"BUY_SELF",@"BUY_TOGETHER",@"BUY_CHASE",@"BUY_REC"];
}
///** 完全公共 */
//FULL_PUBLIC("完全公开"),
//
///** 开奖后公告 */
//DRAWN_PUBLIC("开奖后公开"),
//
///** 完全保密 */
//FULL_SECRET("完全保密"),
//
///** 跟单人公开 */
//FOLLOW_PUBLIC("跟单人公开");
-(NSArray *)secretTypes{
    return @[@"FULL_PUBLIC",@"DRAWN_PUBLIC",@"FOLLOW_PUBLIC",@"FULL_SECRET"];
}

-(NSArray *)getCostType{
    return @[@"SCORE",@"CASH"];
}

-(NSString*)betSource{
    
    return @"2";
}


- (void)updataBetCount{
    calculateBetCuntOrMaxBounds = 0; // 计算奖金或计算bet 区分标识
    [self getBetCount];
    if (_selectMatchArray.count == 1 && self.playType == JCZQPlayTypeGuoGuan) {
        guanKaType = JCZQPlayTypeDanGuan;
    }
    if(guanKaType == JCZQPlayTypeDanGuan)
    {
        self.guoguantype = @"guoguan";
    }
    else
    {
        self.guoguantype = @"danguan";
    }
    //zwl 11/17
    if([self.chuanFa isEqualToString:@"单场"])//比分支持单关，于是实际上将玩法改成了单关。
    {
        guanKaType = JCZQPlayTypeDanGuan;
    }
    else
    {
        guanKaType = JCZQPlayTypeGuoGuan;
    }
    //
    calculateBetCuntOrMaxBounds = 1;
//    [self peilvJiSuan];
}
- (void)getBetCount{
    
    int betCuntTemp = 0;
    if ([self.chuanFa isEqualToString:@"单场"]) {
        for (JCZQMatchModel * bet in  _selectMatchArray){
            betCuntTemp += [bet selectItemNum];
        }
    }else{
        NSArray * chuanFaCodeDic = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
        NSString * index = [_chuanFa substringToIndex:1];
        if ([index integerValue] == 0) {
            return;
        }
        NSDictionary * sectionCodeDic = chuanFaCodeDic[[index intValue]-1];
        NSDictionary * codeDic = sectionCodeDic[_chuanFa];
        NSString * baseNum = codeDic[@"baseNum"];
        
        NSArray * baseNumArray = [baseNum componentsSeparatedByString:@","];
        NSMutableArray * numArray = [NSMutableArray arrayWithCapacity:_selectMatchArray.count];
        
        if ([_curProfile.Desc isEqualToString:@"HHGG"]) {
            NSMutableDictionary * matchGropDic = [NSMutableDictionary dictionary];
            NSMutableArray * matchIndexArray = [NSMutableArray array];
            for (int i=0;i<_selectMatchArray.count;i++){
                NSString * indexString = [NSString stringWithFormat:@"%d",i];
                JCZQMatchModel *bet = _selectMatchArray[i];
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
                [self separateHunheMatchBetNum:matchArray];
                [self arrayRrgodicIndex:0 mutableString:nil];
                for (int i =0; i<_hunHeCombinesString.count; i++) {
                    NSString * numString = _hunHeCombinesString[i];
                    NSArray * numArray = [numString componentsSeparatedByString:@","];
                    betCuntTemp += (int)[self calculateBetCount:numArray baseNumArray:baseNumArray];
                }
            }
        }else{
            for (JCZQMatchModel * bet in  _selectMatchArray){
                [numArray addObject:[NSNumber numberWithInteger:[bet selectItemNum] ]];
            }
            betCuntTemp += (int)[self calculateBetCount:numArray baseNumArray:baseNumArray];
        }
    }
    self.betCount = betCuntTemp;
    self.betCost = self.betCount * [_beitou intValue] * 2;
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

- (void) separateHunheMatchBetNum:(NSArray *)marchArray{
    NSMutableArray * arrayContentTemp = [NSMutableArray array];
    NSMutableArray *arrayOdd = [NSMutableArray array];
    for (JCZQMatchModel * match in marchArray){
        NSMutableArray *arrayOddSelect = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * numCuntArray = [NSMutableArray array];
        NSMutableArray *selectArray = [NSMutableArray arrayWithCapacity:12];
        double max = 0;
        
        NSInteger index = 0;
//        for (int i = 0; i<12 ; i++) {
//
//            NSMutableArray *itemSelect = [NSMutableArray arrayWithCapacity:0];
//
//            //0 sf  1 小  2  大 3 sfc
//            if (i<6) {
//
//                [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.SFSelectMatch[0] doubleValue]*[match.SFOddArray[0] doubleValue]]];
//
//
//            }else{
//                [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.SFSelectMatch[1] doubleValue]*[match.SFOddArray[1] doubleValue]]];
//
//            }
//
//            double valueDX =[match.DXFSelectMatch[0] doubleValue] *[match.DXFSOddArray[0] doubleValue]>[match.DXFSelectMatch[1] doubleValue] *[match.DXFSOddArray[1] doubleValue]?[match.DXFSelectMatch[0] doubleValue] *[match.DXFSOddArray[0] doubleValue]:[match.DXFSelectMatch[1] doubleValue] *[match.DXFSOddArray[1] doubleValue];
//
//            [itemSelect addObject:[NSString stringWithFormat:@"%.2f",valueDX]];
//
//            [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.SFCSelectMatch[i] doubleValue] *[match.SFCOddArray[i] doubleValue]]];
//
//
//            if (i<6) {   // 客胜
//
//                if ([match.handicap doubleValue] >26) {
//                    if (i == 5) {
//                        [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[0] doubleValue] *[match.RFSFOddArray[0] doubleValue]]];
//                    }
//                }else if([match.handicap doubleValue] - (i*5+1)<0){
//                    if (![match.RFSFSelectMatch[0] isEqualToString:@"0"]) {
//                        [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[0] doubleValue] *[match.RFSFOddArray[0] doubleValue]]];
//
//                    }
//                }
//
//            }else{
//                if ([match.handicap doubleValue] <-26) {
//                    if (i == 11) {
//                        [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[1] doubleValue] *[match.RFSFOddArray[1] doubleValue]]];
//                    }
//                }else if([match.handicap doubleValue] + ((i-6)*5+1)>0){
//                    if (![match.RFSFSelectMatch[1] isEqualToString:@"0"]) {
//                        [itemSelect addObject:[NSString stringWithFormat:@"%.2f",[match.RFSFSelectMatch[1] doubleValue] *[match.RFSFOddArray[1] doubleValue]]];
//                    }
//
//                }
//
//            }
//
//            double lastMax = 0;
//            for (NSString *odd in itemSelect) {
//                lastMax += [odd doubleValue];
//            }
//
//            if (max<lastMax) {
//                max = lastMax;
//                index = i;
//            }
//            [selectArray addObject:itemSelect];
//        }
        
//        NSMutableArray *maxOddArray = selectArray[index];
        
//        for (NSString *item in maxOddArray) {
//            if (![item isEqualToString:@"0.00"]) {
//                [arrayOddSelect addObject:item];
//            }
//        }
        
        if (match.SPF_SelectMatch && [self sumSelectPlayType:match.SPF_SelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.SPF_SelectMatch]]];
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
        if (match.RQSPF_SelectMatch && [self sumSelectPlayType:match.RQSPF_SelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.RQSPF_SelectMatch]]];
            //            NSString *max = [self getMaxOdd:match.RFSFOddArray andMatchArray:match.RFSFSelectMatch];
            //            if (max!=nil) {
            //                [arrayOddSelect addObject:max];
            //            }
        }
        if (match.BF_SelectMatch && [self sumSelectPlayType:match.BF_SelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.BF_SelectMatch]]];
            
            
            //            if (max!=nil) {
            //                [arrayOddSelect addObject:max];
            //            }
            
        }
        if (match.JQS_SelectMatch && [self sumSelectPlayType:match.JQS_SelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.JQS_SelectMatch]]];
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
        
        if (match.BQC_SelectMatch && [self sumSelectPlayType:match.BQC_SelectMatch] != 0) {
            [numCuntArray addObject:[NSNumber numberWithInteger:[self sumSelectPlayType:match.BQC_SelectMatch]]];
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
//    self.odd_NumArrayContent = arrayOdd;
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

-(NSInteger)sumSelectPlayType:(NSArray*)array{
    NSInteger num = 0;
    for (NSString *str  in array) {
        num = num+ [str integerValue];
    }
    return num;
}

@end
