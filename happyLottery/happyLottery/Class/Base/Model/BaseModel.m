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
    if (key == nil) {
        return;
    }
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

+(NSString *)getLotteryByName:(NSString *)lottery{
    if ([lottery isEqualToString:@"JCZQ"]) {
        return @"竞彩足球";
    }else if([lottery isEqualToString:@"DLT"]){
        return [NSString stringWithFormat:@"超级大乐透"];
    }else if([lottery isEqualToString:@"RJC"]){
        return [NSString stringWithFormat:@"任选9场"];
    }else if([lottery isEqualToString:@"SFC"]){
        return [NSString stringWithFormat:@"胜负14场"];
    }else if ([lottery isEqualToString:@"JCGYJ"]){
        return @"冠亚军游戏";
    }else if ([lottery isEqualToString:@"JCGJ"]){
        return @"冠军游戏";
    }else if ([lottery isEqualToString:@"SSQ"]){
        return [NSString stringWithFormat:@"双色球"];
    }else if ([lottery isEqualToString:@"JCLQ"]){
        return @"竞彩篮球";
    }
    return @"彩票";
}

@end
