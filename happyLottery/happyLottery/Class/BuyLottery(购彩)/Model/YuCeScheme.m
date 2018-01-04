//
//  YuCeScheme.m
//  Lottery
//
//  Created by onlymac on 2017/10/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuCeScheme.h"

@implementation YuCeScheme
-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    //    value = [NSString stringWithFormat:@"%@",value];
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"id"]) {
        self._id = strValue;
    }else{
        
        [super setValue:strValue forKey:key];
    }
    if ([key isEqualToString:@"jcBetContent"]) {
        NSArray *arr = [Utility objFromJson:value];
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in arr) {
            arr1 =  dic[@"betMatches"];
            arr2 =  dic[@"passTypes"];
        }
        self.jcBetContent = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *betMatchesDic in arr1) {
            jcBetContent *model = [[jcBetContent alloc]initWith:betMatchesDic];
            [self.jcBetContent addObject:model];
            
        }
        
        for (NSString *passTypes in arr2) {
            self.passTypes = passTypes;
        }
        
    }
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}

@end
