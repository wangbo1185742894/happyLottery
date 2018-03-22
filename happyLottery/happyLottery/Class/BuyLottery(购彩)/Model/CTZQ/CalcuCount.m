
//
//  CalcuCount.m
//  CalculateCount
//
//  Created by 王博 on 16/3/8.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "CalcuCount.h"

#define SeletNumber 9
@implementation CalcuCount

+(NSInteger)calculateCount:(NSArray*)selectBetArray playType:(CTZQPlayType)type  andDanNumber:(NSArray *)dan{

    NSInteger numberOfZhu = 1;
    if (type == CTZQPlayTypeShiSi) {
        if(selectBetArray.count<14){
            return 0;
        }
        for (NSArray *itemArray in selectBetArray) {
            
            numberOfZhu = numberOfZhu* itemArray.count;
    
        }
        return numberOfZhu;
    }else if (type == CTZQPlayTypeRenjiu){
        if (selectBetArray.count<9) {
            return 0;
        }
        return [self calculateRenxuan9:selectBetArray andDan:dan];
    }

    return 0;
}

+(NSInteger)calculateRenxuan9:(NSArray*)selectArray andDan:(NSArray*)dan{
    NSInteger threeBetNumber = 0;
    NSInteger twoBetNumber = 0;
    NSInteger needSelect = 9;
    NSInteger betOfCount = 0;
    for (NSArray *itemArray in selectArray) {
        if (itemArray.count == 2) {
            
            
            twoBetNumber ++;
        }else if(itemArray .count == 3){
        
            threeBetNumber ++;
        }
    }
    
    needSelect = needSelect - dan.count;
    NSInteger danNeedAddNumber = 1;
//    处理胆码
    for (NSArray *itemArray in dan) {
        if (itemArray.count == 2) {
//            如果一个胆码中有多注 最后要乘该胆码的注数
            danNeedAddNumber = danNeedAddNumber * 2;
            twoBetNumber--;
        }else if (itemArray.count == 3){
            danNeedAddNumber = danNeedAddNumber * 3;
            threeBetNumber --;
        }
    }

        for (NSInteger i = 0; i<= twoBetNumber; i++) {
            NSInteger  temp = 0;
            NSInteger sumtemp ;
            sumtemp = [self compose:twoBetNumber selectNumber:i]*pow(2, i);
            for (NSInteger j = 0; j<=threeBetNumber; j++) {
                temp =  temp + [self compose:threeBetNumber selectNumber:j]*pow(3, j)*[self compose:selectArray.count - threeBetNumber - twoBetNumber - dan.count selectNumber:needSelect-i-j];
            }
            sumtemp = sumtemp * temp;
            betOfCount = betOfCount + sumtemp;
    }
    return betOfCount * danNeedAddNumber;
}

//计算组合数
+(NSInteger)compose:(NSInteger)total selectNumber:(NSInteger)select{

    NSInteger sum = 1;
    if (select == 0) {
        return sum;
    }
    if (total<select) {
        return 0;
    }
    NSInteger j = 1;
    for (NSInteger n = total; n>select; n--) {
        sum = sum * n/j;
        j++;
    }
    return sum;
}

@end
