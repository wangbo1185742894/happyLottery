//
//  LotteryBet.m
//  Lottery
//
//  Created by AMP on 5/25/15.
//  Copyright (c) 2015 AMP. All rights reserved.

#import "LotteryBet.h"
#import "LotteryXHSection.h"
#import "LotteryNumber.h"
#import "BetCalculationManage.h"

@interface LotteryBet() {
    BetCalculationManage * betCalculationMan;
    int betCount;
    float betCost;
    NSString *summaryDesc;
    
    BetType betType;
    NSString * betTypeDesc;
    NSDictionary *betTypeTexts;
}

- (void) getBetsCount;
- (void) getBetsCost;
@end

#define keyNumberDanHao @"numberdanhao"
#define keyNumberSelected @"numberselected"

@implementation LotteryBet
//11.20
- (void)setBetTypeDesc:(NSString *)betDesc {
    betTypeDesc = betDesc;
}
- (void)setBetCount:(int)totalCount {
    betCount = totalCount;
}
- (void)setBetsCost:(float)totalMoney {
    betCost = totalMoney;
}
- (void)setBetType:(int)betTypeTemp{
    betType = betTypeTemp;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        betType = BetTypeNotSet;
        self.costType = CostTypeCASH;
        self.beiTouCount =1;
    }
    return self;
}
/*
the product of combination Count of each section
 */
- (void) getBetsCount {
    
}

- (void) getBetsCost {
    
}

/*
 called when user cancel or selected one more number on each number section
 Lottery 
    |
 Lottery Details (LotteryXuanHao)
    |
 numbersDanHao, numbersSelected (LotteryNumber)
 
 如果有胆号选中，选号和胆号总数必须大于minNumCount+1
 胆号是每注里面都要存在的号码
 */

- (void) updateBetInfo {
    
    betType = BetTypeNotSet;
    if (self.betNumbers == nil) {
        self.betNumbers = [[NSMutableDictionary alloc] init];
    } else {
        [self.betNumbers removeAllObjects];
    }
    
    if (nil == betCalculationMan) {
        betCalculationMan = [[BetCalculationManage alloc] init];
    }
    NSDictionary * caluclactionResult = [betCalculationMan betCountAndCostCalculationWithLotteryDetail:_lotteryDetails withXHProfile:_betXHProfile];
    
    betCount = [caluclactionResult[@"count"] intValue];
    betCost = [caluclactionResult[@"cost"] intValue];
    self.betNumbers = caluclactionResult[@"betNumber"];
}

- (NSUInteger)getBetNumberRepeatCount{

    NSMutableDictionary * sectionNumCountDic = [NSMutableDictionary dictionaryWithCapacity:_lotteryDetails.count];
    BOOL isBetValid = YES;
    for (int i=0; i<self.lotteryDetails.count; i++) {
        LotteryXHSection *lotteryXH = _lotteryDetails[i];
        if (lotteryXH.numbersSelected.count < [lotteryXH.minNumCount intValue]) {
            isBetValid = NO;
            break;
        }
        sectionNumCountDic[[NSString stringWithFormat:@"%d",i]] = [NSString stringWithFormat:@"%d",(int)lotteryXH.numbersSelected.count];
    }
    if (isBetValid) {
        NSUInteger countNumRepeat =0;
        for (int i=0; i<self.lotteryDetails.count-1; i++) {
            LotteryXHSection *lotteryXH = _lotteryDetails[i];
            LotteryXHSection *lotteryXH_ = _lotteryDetails[i+1];
            for(LotteryNumber *lotteryNum in lotteryXH.numbersSelected){
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"numberValue = %d", [lotteryNum.number integerValue]];
                NSArray* resArr = [lotteryXH_.numbersSelected filteredArrayUsingPredicate:predicate];
                NSUInteger numTmep = resArr.count;
                for(NSString * key in [sectionNumCountDic allKeys]){
                    int keyIndex = [key intValue];
                    if (keyIndex != i && keyIndex != i+1) {
                        NSUInteger numberSelect = [sectionNumCountDic[key] intValue];
                        numTmep *= [Utility getArrangeGroup:numberSelect withExponent:1];
                    }
                }
                countNumRepeat += numTmep;
            }
        }
        return countNumRepeat;
    }
    return 0;
}

- (void)setBetXHProfile:(LotteryXHProfile *)betXHProfile_{
    if (betXHProfile_) {
        _betXHProfile = betXHProfile_;
        self.lotteryDetails = betXHProfile_.details;
        _betProfile = betXHProfile_.title;
    }else{
        _betProfile = @"";
    }
}
- (int) getBetCount {
    
    return betCount;
}
- (int) getBetCost {
    if (_beiTouCount == 0) {
        _beiTouCount = 1;
    }
    
    _beiTouCount = 1;//防止出现负数
    int n = betCost * _beiTouCount;
    return n;//防止出现负数
//    int cost = _needZhuiJia?n+(betCount*_beiTouCount*1):n;
//    return cost;
}
- (NSAttributedString *) betNumberDesc: (UIFont *) font {
    if (_betNumbersDesc != nil) {
        return _betNumbersDesc;
    }
    _betNumbersDesc = [self numDescrption:font];;
    return _betNumbersDesc;
}

- (NSAttributedString *)numDescrption:(UIFont *)font{

    NSAttributedString * description;
    
    if ([_betLotteryIdentifier isEqualToString:@"DLT"]||[_betLotteryIdentifier isEqualToString:@"SSQ"]) {
        //  用颜色区分颜色的号码描述
        description = [self descriptionForColorDistinguish:font];
    }else if([_betLotteryIdentifier isEqualToString:@"SX115"] ||[_betLotteryIdentifier isEqualToString:@"SD115"]){
        switch ([_betXHProfile.profileID intValue]) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 11:
            case 23:
            case 24:
            case 12:{
                description = [self descriptionForColorDistinguish:font];
                break;
            }
                
            case 21:
            case 22:
            case 9:
            case 10:{
             //  前二直选 前三直选 8,9  5,8
                description = [self descriptionForSection:font];
                break;
            }
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20:{
                description = [self descriptionForDanTuoSection:font];
                break;
            }
            default:
                break;
        }

    }
    return description;
}
- (NSMutableAttributedString *)descriptionForColorDistinguish:(UIFont *)font{
    NSMutableAttributedString *numbersString = [[NSMutableAttributedString alloc] init];
    NSMutableDictionary *attributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    attributeDic[NSFontAttributeName] = font;
    for (LotteryXHSection *lotteryXH in self.lotteryDetails) {
        //check if enough for one bet
        NSString *color = lotteryXH.normalColor;
        attributeDic[NSForegroundColorAttributeName] = [Utility colorFromHexString: color];
        if ([color isEqualToString: @"000000"]) {
            //if black color use red instead
            color = @"e84f2a";
            attributeDic[NSForegroundColorAttributeName] = TextCharColor;
        }
        
        
        NSArray *numbersDanHaoTemp = self.betNumbers[lotteryXH.sectionID][keyNumberDanHao];
        NSArray *numbersSelectedTemp = self.betNumbers[lotteryXH.sectionID][keyNumberSelected];
        
        NSArray *numbersSelected = [self sortNumber:numbersSelectedTemp];
        NSArray *numbersDanHao = [self sortNumber:numbersDanHaoTemp];
        
        NSMutableString *numberDescStr = [NSMutableString string];
        if ([numbersDanHao count] > 0) {
            //add dan hao first if any
//            [numberDescStr appendString: @""];
//            NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersDanHao.count];
//            for (LotteryNumber *numberObj in numbersDanHao) {
//                [numberStr addObject: numberObj.numberDesc];
//            }
//            [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
//            [numberDescStr appendString: @"#"];
            [numberDescStr appendString: @"[胆:"];
            NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersDanHao.count];
            for (LotteryNumber *numberObj in numbersDanHao) {
                [numberStr addObject: numberObj.numberDesc];
            }
            [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
            [numberDescStr appendString: @"]\n"];
        }
        NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersDanHao.count];
        for (LotteryNumber *numberObj in numbersSelected) {
            [numberStr addObject: numberObj.numberDesc];
        }
        [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
        if (![[[self.lotteryDetails lastObject] sectionID] isEqualToString: lotteryXH.sectionID]) {
            [numberDescStr appendString: @" \n"];
        }
        [numbersString appendAttributedString: [[NSAttributedString alloc] initWithString: numberDescStr attributes: attributeDic]];
    }
    return numbersString;
}

- (NSMutableAttributedString *)descriptionForSection:(UIFont *)font{
    NSMutableAttributedString *numbersString = [[NSMutableAttributedString alloc] init];
    NSMutableDictionary *attributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    attributeDic[NSFontAttributeName] = font;
    int i=0;
    for (LotteryXHSection *lotteryXH in self.lotteryDetails) {
        i++;
        attributeDic[NSForegroundColorAttributeName] = TextCharColor;
        
        NSArray *numbersSelectedTemp = self.betNumbers[lotteryXH.sectionID][keyNumberSelected];
        NSArray *numbersSelected = [self sortNumber:numbersSelectedTemp];
        
        NSMutableString *numberDescStr = [NSMutableString string];
        
        NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersSelected.count];
        for (LotteryNumber *numberObj in numbersSelected) {
            [numberStr addObject: numberObj.numberDesc];
        }
        [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
        if (i<self.lotteryDetails.count) {
            [numberDescStr appendString: @"#"];
        }
        [numbersString appendAttributedString: [[NSAttributedString alloc] initWithString: numberDescStr attributes: attributeDic]];
    }
    return numbersString;

}
- (NSMutableAttributedString *)descriptionForDanTuoSection:(UIFont *)font{
    NSMutableAttributedString *numbersString = [[NSMutableAttributedString alloc] init];
    NSMutableDictionary *attributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    attributeDic[NSFontAttributeName] = font;
    for (LotteryXHSection *lotteryXH in self.lotteryDetails) {
        attributeDic[NSForegroundColorAttributeName] = TextCharColor;
        NSString * title;
        if ([lotteryXH.sectionID intValue] == 1) {
//            title = @"胆码: ";
            title = @"";
        }else{
//            title = @"拖码: ";
            title = @"#";
        }
        [numbersString appendAttributedString: [[NSAttributedString alloc] initWithString: title attributes: attributeDic]];
        
        NSArray *numbersSelectedTemp = self.betNumbers[lotteryXH.sectionID][keyNumberSelected];
        NSArray *numbersSelected = [self sortNumber:numbersSelectedTemp];
        
        NSMutableString *numberDescStr = [NSMutableString string];
        
        NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersSelected.count];
        for (LotteryNumber *numberObj in numbersSelected) {
            [numberStr addObject: numberObj.numberDesc];
        }
        [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
//        [numberDescStr appendString: @" "];
        [numbersString appendAttributedString: [[NSAttributedString alloc] initWithString: numberDescStr attributes: attributeDic]];
    }
    return numbersString;
}

/*
 bet type:
    单式：只有一注
    复式：有多注
    胆拖：有胆号
 */



- (NSString *) getCellSummaryText{
    //get bet type desc
//    if (summaryDesc != nil) {
//        return summaryDesc;
//    }
    if (!betTypeDesc) {
        [self analysisBetType];
    }
    NSString *strCostType;
    CGFloat cost = 1;
    if (self.costType == CostTypeCASH) {
        strCostType = @"元";
        cost = 1;
    }else{
        cost = 100;
        strCostType = @"积分";
    }
    float nowbetCost = betCost;
    if(_needZhuiJia)
    {
        nowbetCost += nowbetCost/2;
    }
    nowbetCost *= cost;
    NSString *summaryText = [NSString stringWithFormat: @"%@%d%@, %.0f%@", TextTouZhuSummaryTotal, betCount, TextTouZhuSummaryBetUnit, nowbetCost, strCostType];
    
    NSMutableString *summaryDescTMP = [NSMutableString stringWithString: betTypeDesc];
    int spaceCount = 7;
    while (spaceCount-->0) {
        [summaryDescTMP appendString: @" "];
    }
    [summaryDescTMP appendString: summaryText];
    summaryDesc = summaryDescTMP;
    return summaryDesc;
}

- (NSArray *)sortNumber:(NSArray *)numArray{
    NSArray * temp = [numArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 isKindOfClass:[NSString class]]) {
            NSString * numberFir = (NSString *)obj1;
            NSString * numberSec = (NSString *)obj2;
            if ([numberFir integerValue] > [numberSec integerValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }else{
            LotteryNumber * numberFir = (LotteryNumber *)obj1;
            LotteryNumber * numberSec = (LotteryNumber *)obj2;
            if (numberFir.numberValue > numberSec.numberValue) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }
       
    }];
    return temp;
}

- (NSString *) getBetNumberDesc {
    if (_orderBetNumberDesc) {
        return _orderBetNumberDesc;
    }
    NSMutableArray *numbersComp = [NSMutableArray arrayWithCapacity: self.lotteryDetails.count];
    for (LotteryXHSection *lotteryXH in self.lotteryDetails) {
        //check if enough for one bet
        NSArray *numbersDanHao = self.betNumbers[lotteryXH.sectionID][keyNumberDanHao];
        NSArray *numbersSelected = self.betNumbers[lotteryXH.sectionID][keyNumberSelected];
        numbersDanHao = [self sortNumber:numbersDanHao];
        numbersSelected = [self sortNumber:numbersSelected];
        NSMutableString *numberDescStr = [NSMutableString string];
        if ([numbersDanHao count] > 0) {
            //add dan hao first if any
            NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersDanHao.count];
            for (LotteryNumber *numberObj in numbersDanHao) {
                if ([numberObj isKindOfClass:[NSString class]]) {
                    [numberStr addObject: numberObj];
                }else{
                    
                    [numberStr addObject: numberObj.numberDesc];
                }
            }
            [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
            [numberDescStr appendString: @"#"];
        }
        NSMutableArray *numberStr = [NSMutableArray arrayWithCapacity: numbersDanHao.count];
        for (LotteryNumber *numberObj in numbersSelected) {
            if ([numberObj isKindOfClass:[NSString class]]) {
                [numberStr addObject: numberObj];
            }else{
            
                [numberStr addObject: numberObj.numberDesc];
            }
        }
        if (numberStr.count != 0) {
            [numberDescStr appendString: [numberStr componentsJoinedByString: @","]];
            [numbersComp addObject: numberDescStr];
        }
    }
    return [numbersComp componentsJoinedByString: _sectionDataLinkSymbol];
}

- (NSString *) betTypeDesc {
    if (nil == betTypeDesc) {
        [self analysisBetType];
    }
    return betTypeDesc;
}

- (int) betType {
    if (betType == BetTypeNotSet) {
        [self analysisBetType];
    }
    return betType;
}

- (void) analysisBetType{
    NSDictionary * codeDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BetPlayStyleCode" ofType:@"plist"]];
    NSDictionary * lotteryCodeDic = codeDic[[NSString stringWithFormat:@"%d",_betLotteryType]];
    NSString * nameKey;
    NSString * codeKey;
    
    if ([self.betLotteryIdentifier isEqualToString:@"DLT"]||[self.betLotteryIdentifier isEqualToString:@"SSQ"]) {
        int type = [self getBetType];
        if (type == BetTypeNomal) {
            nameKey = @"name_S";
            codeKey = @"code_S";
        }else if(type == BetTypePlural){
            nameKey = @"name_P";
            codeKey = @"code_P";
        }else if (type == BetTypeDanTuo){
            nameKey = @"name_D";
            codeKey = @"code_D";
        }
        betType = [lotteryCodeDic[codeKey] intValue];
        betTypeDesc = lotteryCodeDic[nameKey];
       
    }else if([self.betLotteryIdentifier isEqualToString:@"SX115"] || [self.betLotteryIdentifier isEqualToString:@"SD115"]){

        int betSelected = [_betXHProfile.profileID intValue];
        
        if (![_betXHProfile.couldRepeatSelect boolValue]) {
            NSDictionary * nunberInfSectionFir = (NSDictionary *)self.betNumbers[@"1"];
            NSArray * numberSelected = nunberInfSectionFir[keyNumberSelected];
            if (numberSelected == nil || numberSelected.count == 0) {
                betSelected = [self amendProfileId];
            }
        }
        NSDictionary * styleCodeDic = lotteryCodeDic[[NSString stringWithFormat:@"%d",betSelected]];
        int type = [self getBetType];
        switch (betSelected) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:{
                //  nomal  or dantuo
//                if(type == BetTypeDanTuo){
//                    nameKey = @"name_D";
//                    codeKey = @"code_D";
//                }else{
                    nameKey = @"name_n";
                    codeKey = @"code_n";
//                }
                break;
            }
            case 7:
            case 8:{
                // nomal
                nameKey = @"name_n";
                codeKey = @"code_n";
                break;
            }
            case 9:
            case 10:{
                // nomal  or  Plural
                if (type == BetTypeNomal) {
                    nameKey = @"name_n";
                    codeKey = @"code_n";
                }else if(type == BetTypePlural){
                    nameKey = @"name_F";
                    codeKey = @"code_F";
                }
                break;
            }
            case 11:
            case 12:{
                // nomal  or  Plural
                 nameKey = @"name_n";
                 codeKey = @"code_n";
                break;
            }
            case 13:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 14:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 15:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 16:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 17:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 18:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 19:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 20:{
                nameKey = @"name_D";
                codeKey = @"code_D";
                break;
            }
            case 21:{
                nameKey = @"name_S";
                codeKey = @"code_S";
                break;
            }
            case 22:{
                nameKey = @"name_S";
                codeKey = @"code_S";
                break;
            }
            case 23:{
                nameKey = @"name_S";
                codeKey = @"code_S";
                break;
            }
            case 24:{
                nameKey = @"name_S";
                codeKey = @"code_S";
                break;
            }
           
            default:
                break;
        }
        betType = [styleCodeDic[codeKey] intValue];
        betTypeDesc = styleCodeDic[nameKey];
    }
}


-(int)getBetType{
    int type = BetTypeNomal;
    BOOL pluralBets = NO;
    for (LotteryXHSection *lotteryXH in self.lotteryDetails) {
        //check if enough for one bet
        NSUInteger minNumberCount = [lotteryXH.minNumCount integerValue];
        
        NSArray *numbersDanHao = self.betNumbers[lotteryXH.sectionID][keyNumberDanHao];
        NSArray *numbersSelected = self.betNumbers[lotteryXH.sectionID][keyNumberSelected];
        NSUInteger selectNumberCount = [numbersSelected count];
        NSUInteger selectDanhaoNumberCount = [numbersDanHao count];
        
        if (selectDanhaoNumberCount > 0) {
            type = BetTypeDanTuo;
            break;
        } else {
            //if no danhao, selected number count should equal or greater than minNumberCount
            if (selectNumberCount > minNumberCount) {
                pluralBets = YES;
            }
        }
    }
    if (type != BetTypeDanTuo) {
        if (pluralBets) {
            type = BetTypePlural;
        }
    }
    return type;
}

- (int) amendProfileId{
    LotteryXHSection *lotteryXH = _lotteryDetails[0];

    
    NSUInteger selectNumberCount = [lotteryXH.numbersSelected count];
    if (selectNumberCount == 0) {
        int newType;
        switch ([_betXHProfile.profileID intValue]) {
            case 13:{
                newType = 1;
                break;
            }
            case 14:{
                newType = 2;
                break;
            }
            case 15:{
                newType = 3;
                break;
            }
            case 16:{
                newType = 4;
                break;
            }
            case 17:{
                newType = 5;
                break;
            }
            case 18:{
                newType = 6;
                break;
            }
            case 19:{
                newType = 11;
                break;
            }
            case 20:{
                newType = 12;
                break;
            }
            default:
            break;
                
        }
        return newType;
    }else{
        return [_betXHProfile.profileID intValue];
    }
}

@end
