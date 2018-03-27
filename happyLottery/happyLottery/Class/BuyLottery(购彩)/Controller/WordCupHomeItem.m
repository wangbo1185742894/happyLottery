//
//  WordCupHomeItem.m
//  Lottery
//
//  Created by 王博 on 2018/3/12.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import "WordCupHomeItem.h"

@implementation WordCupHomeItem

-(NSString*)imgGuanKey{
    return [NSString stringWithFormat:@"flag%@",self.guanKey];
}

-(NSString*)imgYaKey{
    return [NSString stringWithFormat:@"flag%@",self.yaKey];
}

-(id)initWithDic:(NSDictionary *)dic{
    
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
