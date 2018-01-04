//
//  BiFenZhiboModel.m
//  Lottery
//
//  Created by 关阿龙 on 17/3/3.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BiFenZhiboModel.h"

@implementation BiFenZhiboModel

-(id)initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
 
}
@end
