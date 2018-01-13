
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
    submitParaDic[@"channelCode"] = CHANNEL_CODE;
    submitParaDic[@"lottery"] = @(9);
    submitParaDic[@"schemeType"] = @(self.schemeType);
    submitParaDic[@"issueNumber"] = @"2018";
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%ld",(long)self.units];
    submitParaDic[@"multiple"] =self.beitou;
    
    submitParaDic[@"betSource"] = @"2";
    submitParaDic[@"schemeSource"] = @(0);
    submitParaDic[@"secretType"] =@(self.secretType);
    submitParaDic[@"costType"] = @(self.costType);
    NSString *betcost;
    if (self.costType == CostTypeCASH) {
       betcost  =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    }else if (self.costType == CostTypeSCORE){
        betcost =[NSString stringWithFormat:@"%ld",(long)self.betCost * 100];
    }
    submitParaDic[@"betCost"] = betcost;
    
    if (self.schemeType == SchemeTypeZigou) {
        submitParaDic[@"copies"] = @"1";
        submitParaDic[@"sponsorCopies"] = @"1";
        submitParaDic[@"minSubCost"] =betcost;
        submitParaDic[@"sponsorCost"] = betcost;
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
                [option2 addObject:option];
            }
        }
        for (int i  = 0; i<bet.BF_SelectMatch.count; i++) {
            NSString *flag = bet.BF_SelectMatch[i];
            contentArray = dic[@"BF"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",300+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option3 addObject:option];
            }
        }
        for (int i  = 0; i<bet.BQC_SelectMatch.count; i++) {
            NSString *flag = bet.BQC_SelectMatch[i];
            contentArray = dic[@"BQC"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",400+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option4 addObject:option];
            }
        }
        
        for (int i  = 0; i<bet.JQS_SelectMatch.count; i++) {
            NSString *flag = bet.JQS_SelectMatch[i];
            contentArray = dic[@"JQS"];
            NSDictionary *dic = contentArray[[NSString stringWithFormat:@"%d",500+i]];
            NSString *option = [self getOption:dic];
            
            
            if ([flag isEqualToString:@"1"]) {
                [option5 addObject:option];
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
    for (JCZQMatchModel *model in self.selectMatchArray) {
        [model refreshPrize];
    }
    
    [self peilvJiSuan];
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

- (void)peilvJiSuan{
    if (self.playType == JCZQPlayTypeDanGuan) {
        NSMutableArray * match_valid_odd_array = [NSMutableArray arrayWithCapacity:self.selectMatchArray.count];
//        NSMutableArray * match_min_valid_odd_array = [NSMutableArray arrayWithCapacity:self.selectMatchArray.count];
        for (JCZQMatchModel * mathc in self.selectMatchArray){
            
            NSArray * odds_array;
            NSArray * select_array;
            if ([self.curProfile.Desc isEqualToString:@"SPF"]) {
                odds_array = mathc.SPF_OddArray;
                select_array = mathc.SPF_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"RQSPF"]){
                odds_array = mathc.RQSPF_OddArray;
                select_array = mathc.RQSPF_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"BF"]){
                odds_array = mathc.BF_OddArray;
                select_array = mathc.BF_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"BQC"]){
                odds_array = mathc.BQC_OddArray;
                select_array = mathc.BQC_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"JQS"]){
                odds_array = mathc.JQS_OddArray;
                select_array = mathc.JQS_SelectMatch;
            }
            
            NSString * odd_string = [self setMatchMaxOddSelect:mathc oddsArray:odds_array selectArray:select_array];
            if (odd_string) {
                [match_valid_odd_array addObject:odd_string];
            }
            
//            NSString * odd_min_string = [self setMatchMinOddSelect:mathc oddsArray:odds_array selectArray:select_array];
//            if (odd_min_string) {
//                [match_min_valid_odd_array addObject:odd_min_string];
//            }
            
        }
        
        float temp = 0;
        for(NSString * odd in match_valid_odd_array){
            temp += [odd floatValue]*2;
            
        }
        
//        float tempMin = 0;
//        for(NSString * odd in match_min_valid_odd_array){
//            tempMin += [odd floatValue]*2;
//
//        }
        
        self.mostBounds = [NSString stringWithFormat:@"%.2f",temp*[self.beitou integerValue] *2];
//        self.minBounds = [NSString stringWithFormat:@"%.2f",tempMin*[self.beitou integerValue]];
        return;
    }
    
    NSArray * chuanFaCodeDic = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
    NSString * index;
    
    //增加单场选择
    if([_chuanFa isEqualToString:@"单场"])
    {
        index = @"1";
    }
    else
    {
        index = [_chuanFa substringToIndex:1];
    }
    
    NSDictionary * sectionCodeDic = chuanFaCodeDic[[index intValue]-1];
    NSDictionary * codeDic = sectionCodeDic[_chuanFa];
    NSString * baseNum = codeDic[@"baseNum"];
    
    NSArray * baseNumArray = [baseNum componentsSeparatedByString:@","];
    
    if ([self.curProfile.Desc isEqualToString:@"HHGG"]) {
        //        NSDictionary * hunheBfPeiDuiDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HHGGPeilvTable" ofType:@"plist"]];
        //        NSMutableArray * oddNumArray_temp = [NSMutableArray array];
        for (int i=0;i<self.selectMatchArray.count;i++){
            
            JCZQMatchModel* match = self.selectMatchArray[i];
            if (match.matchBetArray .count == 0) {
                return;
            }
            NSArray * allZuheArray =   [self matchCodeFenZu:match.matchBetArray  match:match];
            
            NSArray * zuheValid;
//            NSArray * zuheValid_min;
            float maxValue = 0;
//            float minValue = NSIntegerMax;
            //            NSMutableArray * peilu_zuhe_temp =[NSMutableArray array];
            for(NSArray * array in allZuheArray){
                NSArray * peilv_zuhe_array = [self codeZuheShiftToOddZuhe:array match:match];
                float result=0;
                for(NSNumber *num in peilv_zuhe_array){
                    result += [num floatValue];
                }
                if (result > maxValue) {
                    maxValue = result;
                    zuheValid = peilv_zuhe_array;
                }
                
//                peilv_zuhe_array = [self codeZuheShiftToOddZuheMin:array match:match];
                result=0;
                for(NSNumber *num in peilv_zuhe_array){
                    result += [num floatValue];
                }
                
//                if (result < minValue) {
//                    minValue = result;
//                    zuheValid_min = peilv_zuhe_array;
//                }
            }
            match.odd_max_zuhe_HHGG = zuheValid;
//            match.odd_min_zuhe_HHGG = zuheValid_min;
            //            [oddNumArray_temp addObject:zuheValid];
        }
        
        NSMutableDictionary * matchGropDic = [NSMutableDictionary dictionary];
        NSMutableArray * matchIndexArray = [NSMutableArray array];
        for (int i=0;i<self.selectMatchArray.count;i++){
            NSString * indexString = [NSString stringWithFormat:@"%d",i];
            
            matchGropDic[indexString] = self.selectMatchArray[i];
            [matchIndexArray addObject:indexString];
        }
        NSArray * allGroup = [self getCombination:matchIndexArray count:[index intValue]];
        
        float bouns_temp =0;
        for (NSArray * indexArray in allGroup) {
            NSMutableArray * matchArray = [NSMutableArray arrayWithCapacity:indexArray.count];
            for (NSString * indexString in indexArray) {
                [matchArray addObject:matchGropDic[indexString]];
            }
            self.numArrayContent = [NSMutableArray array];
            NSMutableArray * numArrayContent_temp = [NSMutableArray array];
            for(JCZQMatchModel * match in matchArray){
                [numArrayContent_temp addObject:match.odd_max_zuhe_HHGG];
            }
            self.numArrayContent = numArrayContent_temp;
            
            self.hunHeCombinesString = [NSMutableArray array];
            
            [self arrayRrgodicIndex:0 mutableString:nil];
            for (int i =0; i<_hunHeCombinesString.count; i++) {
                NSString * numString = _hunHeCombinesString[i];
                NSArray * numArray = [numString componentsSeparatedByString:@","];
                double  value =[self calculateBetCount:numArray baseNumArray:baseNumArray];
                bouns_temp += value;
            }
        }
        float total_bounds = bouns_temp * [_beitou intValue] * 2;
        self.mostBounds = [NSString stringWithFormat:@"%.2f",total_bounds];
        
//        bouns_temp = 0;
//        for (NSArray * indexArray in allGroup) {
//            NSMutableArray * matchArray = [NSMutableArray arrayWithCapacity:indexArray.count];
//            for (NSString * indexString in indexArray) {
//                [matchArray addObject:matchGropDic[indexString]];
//            }
//            self.numArrayContent = [NSMutableArray array];
//            NSMutableArray * numArrayContent_temp = [NSMutableArray array];
//            for(JCZQMatchModel * match in matchArray){
//                [numArrayContent_temp addObject:match.odd_min_zuhe_HHGG];
//            }
//            self.numArrayContent = numArrayContent_temp;
//
//            self.hunHeCombinesString = [NSMutableArray array];
//
//            [self arrayRrgodicIndex:0 mutableString:nil];
//            for (int i =0; i<_hunHeCombinesString.count; i++) {
//                NSString * numString = _hunHeCombinesString[i];
//                NSArray * numArray = [numString componentsSeparatedByString:@","];
//                double  value =[self calculateBetCount:numArray baseNumArray:baseNumArray];
//                bouns_temp += value;
//            }
//        }
//        total_bounds = bouns_temp * [_beitou intValue];
//        self.minBounds = [NSString stringWithFormat:@"%.2f",total_bounds];
        
    }else{
        NSMutableArray * match_valid_odd_array = [NSMutableArray arrayWithCapacity:self.selectMatchArray.count];
//        NSMutableArray * match_min_valid_odd_array = [NSMutableArray arrayWithCapacity:self.selectMatchArray.count];
        for (JCZQMatchModel * mathc in self.selectMatchArray){
            
            NSArray * odds_array;
            NSArray * select_array;
            if ([self.curProfile.Desc isEqualToString:@"SPF"]) {
                odds_array = mathc.SPF_OddArray;
                select_array = mathc.SPF_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"RQSPF"]){
                odds_array = mathc.RQSPF_OddArray;
                select_array = mathc.RQSPF_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"BF"]){
                odds_array = mathc.BF_OddArray;
                select_array = mathc.BF_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"BQC"]){
                odds_array = mathc.BQC_OddArray;
                select_array = mathc.BQC_SelectMatch;
            }else if ([self.curProfile.Desc isEqualToString:@"JQS"]){
                odds_array = mathc.JQS_OddArray;
                select_array = mathc.JQS_SelectMatch;
            }
            
            NSString * odd_string = [self setMatchMaxOddSelect:mathc oddsArray:odds_array selectArray:select_array];
            if (odd_string) {
                [match_valid_odd_array addObject:odd_string];
            }
            
//            NSString * odd_string_min = [self setMatchMaxOddSelect:mathc oddsArray:odds_array selectArray:select_array];
//            if (odd_string_min) {
//                [match_min_valid_odd_array addObject:odd_string_min];
//            }
        }
        
        if ([_chuanFa isEqualToString:@"单场"]) {
            singleMaxBounds =  100000;
            float bouds = [self danChangBounds:match_valid_odd_array];
            _mostBounds = [NSString stringWithFormat:@"%.2f",bouds];
            
//            bouds = [self danChangBounds:match_min_valid_odd_array];
//            _minBounds = [NSString stringWithFormat:@"%.2f",bouds];
            return;
        }
        
        NSInteger matchNum = self.selectMatchArray.count;
        if (1 < matchNum && matchNum <4) {
            singleMaxBounds = 200000;
        }else if (3 < matchNum && matchNum <6){
            singleMaxBounds = 500000;
        }else{
            singleMaxBounds = 1000000;
        }
        float bounds = [self calculateBetCount:match_valid_odd_array baseNumArray:baseNumArray];
        float total_bounds = bounds * [_beitou intValue] * 2;
        self.mostBounds = [NSString stringWithFormat:@"%.2f",total_bounds];
//        bounds = [self calculateBetCount:match_min_valid_odd_array baseNumArray:baseNumArray];
//        total_bounds = bounds * [_beitou intValue];
//        self.minBounds = [NSString stringWithFormat:@"%.2f",total_bounds];
    }
}

//- (NSString *)setMatchMinOddSelect:(JCZQMatchModel *)match oddsArray:(NSArray *)odds_Array selectArray:(NSArray *)selectArray{
//    NSMutableArray * odds_has = [NSMutableArray arrayWithCapacity:0];
//    for (int i=0; i<selectArray.count; i++) {
//        NSString *select = selectArray[i];
//        if ([select integerValue] == 1) {
//            if (odds_Array.count > i) {
//                [odds_has addObject:odds_Array[i]];
//            }else{
//                return 0;
//            }
//        }
//    }
//    NSString * valid_odd;
//    for(NSString * odd in odds_has){
//        if (valid_odd) {
//            if ([valid_odd floatValue] > [odd floatValue]) {
//                valid_odd = odd;
//            }
//        }else{
//            valid_odd = odd;
//        }
//    }
//
//    return valid_odd;
//}

- (NSString *)setMatchMaxOddSelect:(JCZQMatchModel *)match oddsArray:(NSArray *)odds_Array selectArray:(NSArray *)selectArray{
    NSMutableArray * odds_has = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<selectArray.count; i++) {
        NSString *select = selectArray[i];
        if ([select integerValue] == 1) {
            if (odds_Array.count > i) {
              [odds_has addObject:odds_Array[i]];
            }else{
                return 0;
            }
        }
    }
    NSString * valid_odd;
    for(NSString * odd in odds_has){
        if (valid_odd) {
            if ([valid_odd floatValue] < [odd floatValue]) {
                valid_odd = odd;
            }
        }else{
            valid_odd = odd;
        }
    }
    
    return valid_odd;
}

- (NSArray *)matchCodeFenZu:(NSArray *)codeArray match:(JCZQMatchModel *)match{
    NSDictionary * hunheBfPeiDuiDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HHGGPeilvTable" ofType:@"plist"]];
    NSArray * allZuheTable = [hunheBfPeiDuiDic allValues];
    NSMutableArray * validZuhe = [NSMutableArray arrayWithCapacity:allZuheTable.count];
    for (NSArray  * array in allZuheTable) {
        NSString * zuheString = [array componentsJoinedByString:@","];
        NSMutableArray * zuhe_temp = [NSMutableArray arrayWithCapacity:codeArray.count];
        for(NSNumber * code in codeArray){
            int code_value = [code intValue];
            if(code_value > 199 && code_value < 203){
                NSNumber * bfCode = array[0];
                BOOL isValue = [self bfIsSuitalbeWithRq:bfCode rqspfCode:code andRelevant:match];
                if (isValue) {
                    [zuhe_temp addObject:code];
                }
            }else{
                NSString * code_string = [NSString stringWithFormat:@"%d",[code intValue]];
                if ([zuheString rangeOfString:code_string].location != NSNotFound) {
                    [zuhe_temp addObject:code];
                }
            }
        }
        if (zuhe_temp.count > 0) {
            [validZuhe addObject:zuhe_temp];
        }
    }
    return validZuhe;
}

- (BOOL)bfIsSuitalbeWithRq:(NSNumber *)bf rqspfCode:(NSNumber *)rqspf andRelevant:(JCZQMatchModel *)match{
    
    NSDictionary * codeConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiCode" ofType:@"plist"]];
    NSDictionary * bfDic = codeConfig[@"BF"];
    int bf_value = [bf intValue];
    NSDictionary * codeAppearDic = bfDic[[NSString stringWithFormat:@"%d",bf_value]];
    NSString * codeAppear = codeAppearDic[@"appear"];
    int rqspfValue = [rqspf intValue];
    int rq = [match.handicap intValue];
    if (bf_value == 512) {
        // 胜其他
        if(rq > 0 && rqspfValue == 200){
            return YES;
        }else if(rq == -1 && (rqspfValue == 200 || rqspfValue == 201)){
            return YES;
        }else if(rq < -1 ){
            return YES;
        }
    }else if (bf_value == 517){
        // 平其他
        if ((rq > 0 && rqspfValue==200) || (rq < 0 && rqspfValue==202)) {
            return YES;
        }
    }else if (bf_value == 530){
        // 负其他
        if (rq == 1 &&  (rqspfValue == 202 || rqspfValue == 201)) {
            return YES;
        }
        else if(rq > 1){
            return YES;
        }
        else if(rq < 0 && rqspfValue == 202){
            return YES;
        }
    }else{
        NSArray * num_array = [codeAppear componentsSeparatedByString:@":"];
        if (num_array.count != 2) {
            return NO;
        }
        int zhudui = [num_array[0] intValue];
        int kedui = [num_array[1] intValue];
        int zhudui_ = zhudui + rq;
        if (zhudui_ > kedui) {
            if (rqspfValue == 200) {
                return YES;
            }
        }else if(zhudui_ == kedui){
            if (rqspfValue == 201) {
                return YES;
            }
        }else{
            if (rqspfValue == 202) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray *) codeZuheShiftToOddZuhe:(NSArray *)codeArray match:(JCZQMatchModel *)match{
    NSMutableArray * valid_oddArray = [NSMutableArray arrayWithCapacity:codeArray.count];
    
    
    
    NSMutableArray * odd_spf = [NSMutableArray array];
    NSMutableArray * odd_rqspf = [NSMutableArray array];
    NSMutableArray * odd_jqs = [NSMutableArray array];
    NSMutableArray * odd_bqc = [NSMutableArray array];
    NSMutableArray * odd_bf = [NSMutableArray array];
    
    for(NSNumber * code in codeArray){
        NSArray * odds_source_array;
        NSMutableArray * code_select_array;
        
        int  codeValue = [code intValue];
        if (codeValue > 99 && codeValue < 103) {
            odds_source_array = match.SPF_OddArray;
            code_select_array = odd_spf;
        }else if (codeValue> 199 && codeValue < 203){
            odds_source_array = match.RQSPF_OddArray;
            code_select_array = odd_rqspf;
        }else if (codeValue> 299 && codeValue < 308){
            odds_source_array = match.JQS_OddArray;
            code_select_array = odd_jqs;
        }else if (codeValue> 399 && codeValue < 409){
            odds_source_array = match.BQC_OddArray;
            code_select_array = odd_bqc;
        }else if (codeValue> 499 && codeValue < 531){
            odds_source_array = match.BF_OddArray;
            code_select_array = odd_bf;
        }
        
        int codeIndex = codeValue %100;
        if (codeIndex < odds_source_array.count) {
            NSString * odd = odds_source_array[codeIndex];
            [code_select_array addObject:odd];
        }
    }
    
    NSArray * container_array = @[odd_spf,odd_rqspf,odd_jqs,odd_bqc,odd_bf];
    for(NSArray * container in container_array){
        
        if (container.count > 0) {
            NSString * value = [self maxValueInArray:container];
            [valid_oddArray addObject:value];
        }
    }
    return valid_oddArray;
}

//- (NSArray *) codeZuheShiftToOddZuheMin:(NSArray *)codeArray match:(JCZQMatchModel *)match{
//    NSMutableArray * valid_oddArray = [NSMutableArray arrayWithCapacity:codeArray.count];
//
//
//
//    NSMutableArray * odd_spf = [NSMutableArray array];
//    NSMutableArray * odd_rqspf = [NSMutableArray array];
//    NSMutableArray * odd_jqs = [NSMutableArray array];
//    NSMutableArray * odd_bqc = [NSMutableArray array];
//    NSMutableArray * odd_bf = [NSMutableArray array];
//
//    for(NSNumber * code in codeArray){
//        NSArray * odds_source_array;
//        NSMutableArray * code_select_array;
//
//        int  codeValue = [code intValue];
//        if (codeValue > 99 && codeValue < 103) {
//            odds_source_array = match.SPF_OddArray;
//            code_select_array = odd_spf;
//        }else if (codeValue> 199 && codeValue < 203){
//            odds_source_array = match.RQSPF_OddArray;
//            code_select_array = odd_rqspf;
//        }else if (codeValue> 299 && codeValue < 308){
//            odds_source_array = match.JQS_OddArray;
//            code_select_array = odd_jqs;
//        }else if (codeValue> 399 && codeValue < 409){
//            odds_source_array = match.BQC_OddArray;
//            code_select_array = odd_bqc;
//        }else if (codeValue> 499 && codeValue < 531){
//            odds_source_array = match.BF_OddArray;
//            code_select_array = odd_bf;
//        }
//
//        int codeIndex = codeValue %100;
//        if (codeIndex < odds_source_array.count) {
//            NSString * odd = odds_source_array[codeIndex];
//            [code_select_array addObject:odd];
//        }
//    }
//
//    NSArray * container_array = @[odd_spf,odd_rqspf,odd_jqs,odd_bqc,odd_bf];
//    for(NSArray * container in container_array){
//
//        if (container.count > 0) {
//            NSString * value = [self minValueInArray:container];
//            [valid_oddArray addObject:value];
//        }
//    }
//    return valid_oddArray;
//}

//- (NSString *)minValueInArray:(NSArray *)array{
//    NSString * string= nil;
//    for (NSString * str in array){
//        if (string) {
//            if ([str floatValue] < [string floatValue]) {
//                string = str;
//            }
//        }else{
//            string = str;
//        }
//    }
//    return string;
//}

- (NSString *)maxValueInArray:(NSArray *)array{
    NSString * string= nil;
    for (NSString * str in array){
        if (string) {
            if ([str floatValue] > [string floatValue]) {
                string = str;
            }
        }else{
            string = str;
        }
    }
    return string;
}

- (float)danChangBounds:(NSArray *)odds_array{
    float bounds_temp = 0;
    for(NSString * odds in odds_array){
        float bound = [odds floatValue] * 2 * [_beitou integerValue];
        bounds_temp += bound;
    }
    return bounds_temp;
}
@end
