//
//  BetCalculationManage.m
//  Lottery
//
//  Created by Yang on 15/7/3.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "BetCalculationManage.h"

#define CostPerBet  2

#define keyNumberDanHao @"numberdanhao"
#define keyNumberSelected @"numberselected"

@implementation BetCalculationManage


- (NSDictionary *)betCountAndCostCalculationWithLotteryDetail:(NSArray *)lotteryDetails withXHProfile:(LotteryXHProfile *)xhProfile{
    betCount = 0;
    betCost = 0;
    self.betNumbers = [NSMutableDictionary dictionary];
    
    switch ([xhProfile.betCalculation intValue]) {
        case BetCalculationTypeMixture:
            [self calculationFor:lotteryDetails couldRepeat:[xhProfile.couldRepeat boolValue]];
            break;
        case BetCalculationTypeFixedBallKind:
            [self calculationFor:lotteryDetails withXhProfile:xhProfile];
            break;
        default:
            break;
    }
    
    
    NSNumber* count;
    NSNumber* cost;
    if (betCount != 0) {
        if ([xhProfile.profileID isEqualToString:@"21"]) {
            count = @3;
            cost = @6;
        }else if ([xhProfile.profileID isEqualToString:@"22"]){
            count = @3;
            cost = @6;
        }else if ([xhProfile.profileID isEqualToString:@"23"]){
            count = @5;
            cost = @10;
        }else if ([xhProfile.profileID isEqualToString:@"24"]){
            count = @7;
            cost = @14;
        }else
            
        {
            
            count = [NSNumber numberWithInteger:betCount];
            cost = [NSNumber numberWithInteger:betCost];
        }
    }else{
        count = @0;
        cost = @0;
    }
  
    
    NSDictionary * dictionary = @{@"count":count,@"cost":cost,@"betNumber":self.betNumbers};
    return dictionary;
}


- (void)calculationFor:(NSArray *)lotteryDetails couldRepeat:(BOOL)couldRepeat{
    int combinationCount = 1;
    for (LotteryXHSection *lotteryXH in lotteryDetails) {
        //check if enough for one bet
        NSUInteger minNumberCount = [lotteryXH.minNumCount integerValue];
        NSUInteger selectNumberCount = [lotteryXH.numbersSelected count];
        NSUInteger selectDanhaoNumberCount = [lotteryXH.numbersDanHao count];
        
        if (selectDanhaoNumberCount > 0) {
            //if any danhao, the selected number count should be greater than minNumberCount + 1
            if ((selectDanhaoNumberCount + selectNumberCount) < minNumberCount + 1) {
                betCount = 0;
                betCost = 0;
                combinationCount = 0;
                break;
            }
        } else {
            //if no danhao, selected number count should equal or greater than minNumberCount
            if (selectNumberCount < minNumberCount) {
                betCount = 0;
                betCost = 0;
                combinationCount = 0;
                break;
            }
        }
        NSMutableDictionary *sectionBetNumDic = [NSMutableDictionary dictionaryWithCapacity: 2];
        sectionBetNumDic[keyNumberDanHao] = [NSArray arrayWithArray: lotteryXH.numbersDanHao];
        sectionBetNumDic[keyNumberSelected] = [NSArray arrayWithArray: lotteryXH.numbersSelected];
        self.betNumbers[lotteryXH.sectionID] = sectionBetNumDic;
        
        /*
         calculate combination
         1. no danhao, C(numberSelected, minNumber)
         2. has danhao, C((numberSelected-danhaoCount), (minNumber-danhaoCount))
         */
        //C(n,m) = n!/m!(n-m)!
        NSUInteger baseNum = selectNumberCount;
        NSUInteger denoNum = minNumberCount;
        if (selectDanhaoNumberCount > 0) {
            denoNum = minNumberCount - selectDanhaoNumberCount;
        }
        NSUInteger factorial = 1;
        if (baseNum != denoNum) {
            NSUInteger member = [Utility getFactorial: baseNum tillNumber: (baseNum-denoNum)];
            NSUInteger denominator = [Utility getFactorial: denoNum tillNumber: 1];
            factorial = member/denominator;
        }

        combinationCount *= factorial;
    }
    
    // can not repeat
    // C(selectNumberCount,1)
    if (!couldRepeat && lotteryDetails.count>1 && combinationCount > 0) {
        NSUInteger numberRepeat = [self getBetNumberRepeatCount:lotteryDetails];
        combinationCount -= numberRepeat;
    }
    betCount = combinationCount;
    betCost = betCount * CostPerBet;
}

- (NSUInteger)getBetNumberRepeatCount:(NSArray *)lotteryDetails{
    
    NSMutableDictionary * sectionNumCountDic = [NSMutableDictionary dictionaryWithCapacity:lotteryDetails.count];
    BOOL isBetValid = YES;
    for (int i=0; i<lotteryDetails.count; i++) {
        LotteryXHSection *lotteryXH = lotteryDetails[i];
        if (lotteryXH.numbersSelected.count < [lotteryXH.minNumCount intValue]) {
            isBetValid = NO;
            break;
        }
        sectionNumCountDic[[NSString stringWithFormat:@"%d",i]] = [NSString stringWithFormat:@"%d",(int)lotteryXH.numbersSelected.count];
    }
    if (!isBetValid) {
        return 0;
    }
    NSUInteger countNumRepeat =0;
    if(lotteryDetails.count < 3){
   
        for (int i=0; i<lotteryDetails.count-1; i++) {
            LotteryXHSection *lotteryXH = lotteryDetails[i];
            LotteryXHSection *lotteryXH_ = lotteryDetails[i+1];
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
    }else{
        
        NSUInteger numSelect_fir = [(LotteryXHSection *)lotteryDetails[0] numbersSelected].count;
        NSUInteger numSelect_sec = [(LotteryXHSection *)lotteryDetails[1] numbersSelected].count;
        NSUInteger numSelect_thir = [(LotteryXHSection *)lotteryDetails[2] numbersSelected].count;
        for (int i=1; i<12; i++) {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"numberValue = %d", i];
            NSArray * section_fir;
            NSArray * section_sec;
            NSArray * section_thir;
            
            if (lotteryDetails.count == 3) {
                section_fir = [[(LotteryXHSection *)lotteryDetails[0] numbersSelected] filteredArrayUsingPredicate:predicate];
                section_sec = [[(LotteryXHSection *)lotteryDetails[1] numbersSelected] filteredArrayUsingPredicate:predicate];
                section_thir = [[(LotteryXHSection *)lotteryDetails[2] numbersSelected] filteredArrayUsingPredicate:predicate];
                
                if (section_fir.count != 0 && section_sec.count != 0 && section_thir.count != 0) {
                    countNumRepeat += (numSelect_fir-1 + numSelect_sec-1 + numSelect_thir-1 + 1);
                }else if (section_fir.count != 0 && section_sec.count != 0 && section_thir.count == 0){
                    countNumRepeat += numSelect_thir;
                }else if (section_fir.count != 0 && section_sec.count == 0 && section_thir.count != 0){
                    countNumRepeat += numSelect_sec;
                }else if (section_fir.count == 0 && section_sec.count != 0 && section_thir.count != 0){
                    countNumRepeat += numSelect_fir;
                }
            }
        }
    }
    return countNumRepeat;
}


- (void)calculationFor:(NSArray *)lotteryDetails withXhProfile:(LotteryXHProfile *)xhProfile{
    NSUInteger fixedNumCount = 0;
    NSUInteger mutableNumCount = 0;
    
    for (LotteryXHSection *lotteryXH in lotteryDetails) {
        //check if enough for one bet
        NSUInteger minNumberCount = [lotteryXH.minNumCount integerValue];
        NSUInteger selectNumberCount = [lotteryXH.numbersSelected count];

        if (selectNumberCount+1 > minNumberCount ) {
            //if any danhao, the selected number count should be greater than minNumberCount + 1
            if ([lotteryXH.needDanHao boolValue]) {
                fixedNumCount = selectNumberCount;
            }else{
                mutableNumCount = selectNumberCount;
            }
        }
        NSMutableDictionary *sectionBetNumDic = [NSMutableDictionary dictionaryWithCapacity: 2];
        sectionBetNumDic[keyNumberDanHao] = [NSArray arrayWithArray: lotteryXH.numbersDanHao];
        sectionBetNumDic[keyNumberSelected] = [NSArray arrayWithArray: lotteryXH.numbersSelected];
        self.betNumbers[lotteryXH.sectionID] = sectionBetNumDic;
    }
    NSUInteger minNunCount = [xhProfile.betMinNum integerValue];
    if (minNunCount < fixedNumCount + mutableNumCount+1) {
        NSUInteger baseNum;
        NSUInteger denoNum;
        baseNum = mutableNumCount;
        denoNum = minNunCount - fixedNumCount;
        if (baseNum == denoNum) {
            betCount = 1;
        }else if (fixedNumCount == 0){
            if (baseNum > minNunCount) {
                NSUInteger factorial = 1;
                denoNum = baseNum- minNunCount;
                
                if (baseNum != denoNum) {
                    NSUInteger member = [Utility getFactorial: baseNum tillNumber: (baseNum-denoNum)];
                    NSUInteger denominator = [Utility getFactorial: denoNum tillNumber: 1];
                    factorial = member/denominator;
                }
                betCount = factorial;
            }
        }else{
            NSUInteger factorial = 1;
            
            if (baseNum != denoNum) {
                NSUInteger member = [Utility getFactorial: baseNum tillNumber: (baseNum-denoNum)];
                NSUInteger denominator = [Utility getFactorial: denoNum tillNumber: 1];
                factorial = member/denominator;
            }
            betCount = factorial;
        }
        betCost = betCount * CostPerBet;
    }else{
        
        betCount = 0;
        betCost = 0;
    }
}
@end
