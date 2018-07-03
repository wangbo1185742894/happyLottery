//
//  X115LimitNum.m
//  Lottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "X115LimitNum.h"

@implementation X115LimitNum

-(id)initWithDic:(NSDictionary *)dic{
    
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }else if([key isEqualToString:@"limitNum"]){
        NSString *strValue = [NSString stringWithFormat:@"%@",value];
        NSArray *predicts = [strValue componentsSeparatedByString:@","];
        self.limitNum = predicts;
    }else{
        NSString *strValue = [NSString stringWithFormat:@"%@",value];
        [super setValue:strValue forKey:key];
    }
    
    
}
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    NSLog(@"@property(nonatomic,strong)NSString * %@",key);
    return;
}

@end
