//
//  CTZQBet.m
//  Lottery
//
//  Created by 王博 on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQBet.h"

@implementation CTZQBet
-(id)initWith:(CTZQMatch *)match{

    if (self = [super init]) {
        self.cMatch = match;
    }
    return self;
}
- (NSComparisonResult)compareBet:(CTZQBet *)bet {
    // 先按照姓排序
    NSComparisonResult result;
    if ([self.cMatch.id_ integerValue] >=[bet.cMatch.id_ integerValue]) {
        result =  NSOrderedDescending;
    }else{
        result = NSOrderedAscending;
    }
    return result;
}
@end
