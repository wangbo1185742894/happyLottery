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
        if (item - [[temp lastObject] integerValue] > 1) {
            [temp addObject:@(item)];
        }
    }
    long long tempf = [self getMincCommon:temp];
    return tempf;
}

+(long)getMincCommon:(NSMutableArray *)numList{
    for (int i = 0; i < numList .count - 1; i ++) {
        long long minTemp = [self getMinCommon:[numList[i] longLongValue] and:[numList[i +1] longLongValue]];
        [numList removeObjectAtIndex:i ];
        [numList insertObject:@(minTemp) atIndex:i + 1];
    }
    return [[numList lastObject] longLongValue];
}
+(long long)getMinCommon:(long long )num1 and:(long long )num2{
    for(long long  i = num2 > num1?num2:num1; i<num1*num2;i+=num2 > num1?num2:num1){
        if((i%num1==0)&&(i%num2==0)){
            return i;
        }
    }
    return num1*num2;
}

@end
