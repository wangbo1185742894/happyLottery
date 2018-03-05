//
//  BonusOptimize.m
//  swift01
//
//  Created by 王博 on 2018/2/8.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BonusOptimize.h"

@implementation BonusOptimize

+(CGFloat)getMincCommonDivisor:(NSArray *)numList{
    NSMutableArray *mNumList  = [NSMutableArray arrayWithCapacity:0];
        for (NSString * temp in numList) {
            NSInteger ops = [[NSString  stringWithFormat:@"%.2f",[temp doubleValue]* 100] integerValue] ;
            [mNumList addObject:@(ops)];
        }
    CGFloat tempf = [self getMincCommon:mNumList] / 100.0;
    return tempf;
}

+(NSInteger)getMincCommon:(NSMutableArray *)numList{
    for (int i = 0; i < numList .count - 1; i ++) {
        NSInteger minTemp = [self getMinCommon:[numList[i] integerValue] and:[numList[i +1] integerValue]];
        
        [numList removeObjectAtIndex:i ];
        [numList insertObject:@(minTemp) atIndex:i + 1];
    }
    
    return [[numList lastObject] integerValue];
}

+(NSInteger)getMinCommon:(NSInteger )num1 and:(NSInteger )num2{
    
    for(NSInteger  i = num2 > num1?num2:num1; i<num1*num2;i+=num2 > num1?num2:num1){
        if((i%num1==0)&&(i%num2==0)){
            return i;
        }
    }
    return num1*num2;
}

@end
