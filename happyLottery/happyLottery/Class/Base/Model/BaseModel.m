//
//  BaseModel.m
//  happyLottery
//
//  Created by 王博 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"id"]) {
        key = @"_id";
    }
    [super setValue:strValue forKey:key];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"@property(nonatomic,copy)NSString * %@;",key);
}

@end
