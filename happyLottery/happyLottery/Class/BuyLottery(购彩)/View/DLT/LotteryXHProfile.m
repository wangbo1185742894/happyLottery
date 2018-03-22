//
//  LotteryXHProfile.m
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryXHProfile.h"

@implementation LotteryXHProfile
@synthesize percent;

- (float) getPercent {
    if (percent < 0.00001) {
        float percentageFloat = 0;
        if (![self.percentage isEqualToString: @"0"]) {
            NSExpression *expression = [NSExpression expressionWithFormat: self.percentage];
            percentageFloat = [[expression expressionValueWithObject:nil context:nil] floatValue];
        }
        
        self.percent = percentageFloat;
    }
    return percent;
}
@end
