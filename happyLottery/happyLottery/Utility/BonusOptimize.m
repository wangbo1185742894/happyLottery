//
//  BonusOptimize.m
//  swift01
//
//  Created by 王博 on 2018/2/8.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BonusOptimize.h"

@implementation BonusOptimize

+(long long)getMincCommonDivisor:(NSArray *)numList{
    NSMutableArray *mNumList  = [NSMutableArray arrayWithCapacity:0];
        for (NSString * temp in numList) {
            long long ops = [[NSString  stringWithFormat:@"%.0f",[temp doubleValue]] longLongValue] ;
            [mNumList addObject:@(ops)];
        }
    [mNumList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger int1 = [obj1 integerValue];
        NSInteger int2 = [obj2 integerValue];
        return int1 > int2;
    }];
    
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    [temp addObject:[mNumList firstObject]];
    for (int i = 1; i < mNumList.count; i ++) {
        NSInteger item = [mNumList[i] integerValue];
        if ((item - [[temp lastObject] doubleValue] ) / [[temp lastObject] doubleValue] > 0.1) {
            [temp addObject:@(item)];
        }
    }
    long long tempf = [self getMincCommon:numList];
    return tempf;
}

+(unsigned long long)getMincCommon:(NSArray *)numList{
    return [self getMoreSmallMul:numList :numList.count];
//    for (int i = 0; i < numList .count - 1; i ++) {
//        long long minTemp = [self getMinCommon:[numList[i] longLongValue] and:[numList[i +1] longLongValue]];
//        [numList removeObjectAtIndex:i ];
//        [numList insertObject:@(minTemp) atIndex:i + 1];
//    }
//    return [[numList lastObject] longLongValue];
}
//+(long)getMinCommon:(long long )num1 and:(long long )num2{
//    for(long long  i = num2 > num1?num2:num1; i<num1*num2;i+=num2 > num1?num2:num1){
//        if((i%num1==0)&&(i%num2==0)){
//            return i;
//        }
//    }
//    return num1*num2;
//}


 +(unsigned long long )getBigDiv:(unsigned long long) a :(unsigned long long) b{// 求两个数的最大公约数
    if (b == 0)
        return a;
    return  [self getBigDiv:b :a % b];
}

 +(unsigned long long )getSmallMul:(unsigned long long) a :(unsigned long long) b{// 求两个数的最小公倍数
    return (a * b) / [self getBigDiv:b :a % b];
}

 +(unsigned long long )getMoreBigDiv:(NSArray *) num :(NSInteger) n{ // 求多个数的最大公约数
    if (n == 1)
        return [num[n - 1] longLongValue];
    return [self getBigDiv:[ num[n - 1] longLongValue] :[self getMoreBigDiv:num :n - 1]];  // , getMoreBigDiv(num, n - 1));
}

 +(unsigned long long )getMoreSmallMul:(NSArray *)num :(NSInteger )n {// 求多个数的最小公倍数
    if (n == 1)
        return (unsigned long long) num[n-1];
    return [self  getSmallMul:[ num[n - 1] longLongValue] :[self getMoreSmallMul:num :n - 1]];
}
@end
