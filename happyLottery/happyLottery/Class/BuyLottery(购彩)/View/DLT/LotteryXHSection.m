//
//  LotteryXHSection.m
//  Lottery
//
//  Created by AMP on 5/21/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryXHSection.h"

@implementation LotteryXHSection

- (BOOL) couldHaveMoreNumber {
    if (nil == self.numbersSelected
        || self.numbersSelected.count < [self.maxNumCount intValue]) {
        return YES;
    }
    return NO;
}
- (BOOL) couldHaveMoreDanHao {
    if (![self.needDanHao boolValue]) {
        return NO;
    }
    if (nil == self.numbersDanHao
        || self.numbersDanHao.count < [self.danHaoCount intValue]) {
        return YES;
    }
    return NO;
}

- (void) updateSelectedNumberDesc {
    NSUInteger selectedCount = self.numbersSelected.count + self.numbersDanHao.count;
    [self.titleView updateSelectedNumber: selectedCount];
}

- (BOOL)isNumHasEquel:(NSArray *)numArray{
    
    BOOL hadRepeat = NO;
    for (int i=0;i<numArray.count;i++){
        NSNumber * number = numArray[i];
        if(i+1<numArray.count){
            for (int j=i+1; j<numArray.count; j++) {
                NSNumber * number_ = numArray[j];
                if([number intValue] == [number_ intValue]){
                    hadRepeat = YES;
                    break;
                }
            }
        }
        if (hadRepeat) {
            break;
        }
    }
    return hadRepeat;
}

- (NSArray *) generateRandomNumber: (int) numberCount {
    NSMutableArray *numbersArray = [NSMutableArray arrayWithCapacity: numberCount];
    int maxIndexNumber = [self.numberCount intValue];
    for (int startIndex=0; startIndex<numberCount; startIndex++) {
        //get random index number
        int randomIndex = arc4random_uniform(maxIndexNumber) + [self.startIndex intValue];
        NSNumber *randomIndexNumber = [NSNumber numberWithInt: randomIndex];
        if (![numbersArray containsObject: randomIndexNumber]) {
            [numbersArray addObject: randomIndexNumber];
        } else {
            startIndex--;
        }
    }
    return numbersArray;
}

- (NSArray *) generateRandomNumber: (int) numberCount withOutRepeatArray:(NSArray *)numberArray{

    NSArray *newNumbers;
    BOOL isHadRepeat;
    
    //  获取随机数并去重
    BOOL isHadValidArray = NO;
    while(!isHadValidArray) {
        do {
            newNumbers = [self generateRandomNumber: numberCount];
            isHadRepeat = [self isNumHasEquel:newNumbers];
        } while (isHadRepeat);
        
        BOOL isHadNumHad = NO;
        for (int i=0;i< numberArray.count;i++){
            NSNumber * number = numberArray[i];
            for(NSNumber * num in newNumbers){
                if ([number intValue] == [num intValue]) {
                    isHadNumHad = YES;
                    break;
                }
            }
            if (isHadNumHad) {
                break;
            }
        }
        if (!isHadNumHad) {
            isHadValidArray = YES;
        }
    }
    return newNumbers;

}


@end
